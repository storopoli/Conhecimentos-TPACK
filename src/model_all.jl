using Arrow
using CSV
using DataFramesMeta
using LinearAlgebra
using Statistics
using Turing
using ReverseDiff

# reproducibility
using Random: seed!

# ReverseDiff backend
Turing.setadbackend(:reversediff)
Turing.setrdcache(true)

seed!(123)

# data
df = DataFrame(Arrow.Table(joinpath(pwd(), "data", "data.arrow")))

function recode_curso(x::Int64)
    # CO_GRUPO == 1 ~ 0, # adm
    # CO_GRUPO == 2 ~ 1, # direito
    # CO_GRUPO == 12 ~ 2, # medicina
    # CO_GRUPO == 2001 ~ 3, # pedagogia
    # CO_GRUPO == 4004 ~ 4, # computacao
    if x == 1
        return 1 # adm
    elseif x == 2
        return 2 # direito
    elseif x == 12
        return 3 # medicina
    elseif x == 2001
        return 4 # pedagogia
    elseif x == 4004
        return 5 # computacao 
    end
end

@transform! df begin
    :tech = :QE_I58
    :content = :QE_I57
    :pedag = :QE_I29
    :tech_content = :QE_I58 .* :QE_I57
    :tech_pedag = :QE_I58 .* :QE_I29
    :content_pedag = :QE_I57 .* :QE_I29
    :tech_content_pedag = :QE_I58 .* :QE_I57 .* :QE_I29
    :curso = @. recode_curso(:CO_GRUPO)
end

# define data matrix X
X = Matrix(select(df, Cols(r"tech", r"content", r"pedag", Between(:NU_IDADE, :QE_I08_NUM))))

# define dependent variables y
nt_ger = float(df[:, :NT_GER])

# define vector of group memberships idx
idx_curso = df[:, :curso]
idx_privada = df[:, :CO_CATEGAD_PRIVADA] # index is {0=publica, 1=privada}

# define the model
@model function varying_slope_ncp_regression(
    X,
    idx,
    y;
    N=size(X, 1),
    predictors=size(X, 2),
    n_gr=length(unique(idx)),
    mean_y=mean(y),
    std_y=std(y),
    βᵢ=7, # max index for random slopes
)
    # priors
    α ~ TDist(3) * (2.5 * std_y) + mean_y
    β ~ filldist(TDist(3) * 2.5, predictors)
    σ ~ Exponential(1)

    # prior for variance of random slopes
    # usually requires thoughtful specification
    τ ~ filldist(truncated(Cauchy(0, 2); lower=0), n_gr)                      # group-level SDs slopes
    Zⱼ ~ arraydist([MvNormal(Diagonal(fill(1, βᵢ))) for j in 1:n_gr]) # group-level non-centered slopes
    βⱼ = Zⱼ .* τ'                                                             # group-level slopes

    # likelihood
    for i in 1:N
        y[i] ~ Normal(α + X[i, :] ⋅ β + X[i, 1:βᵢ] ⋅ βⱼ[1:βᵢ, idx[i]], σ)
    end
    return (; y, α, β, σ, βⱼ, τ)
end

# instantiate model
model = varying_slope_ncp_regression(
    X,
    idx_curso,
    # idx_privada,
    nt_ger,
)

# run chains
chn = sample(model, NUTS(1_000, 0.8), MCMCThreads(), 1_000, 4)

# save summarystats
CSV.write(
    joinpath(pwd(), "results", "all", "turing_summarystats_ger.csv"), summarystats(chn)
)

# save quantiles
CSV.write(joinpath(pwd(), "results", "all", "turing_quantile_ger.csv"), quantile(chn))

# β:
# 1. QE_I58                    tech
# 2. QE_I58 * QE_I29           tech_contet
# 3. QE_I58 * QE_I57           tech_pedag
# 4. QE_I58 * QE_I29 * QE_I57  tech_content_pedag
# 5. QE_I29                    content
# 6. QE_I57 * QE_I29           content_pedag
# 7. QE_I57                    pedag
# 8. NU_IDADE                
# 9. TP_SEXO_MASC
# 10. QE_I01_SOLTEIRO
# 11. QE_I02_BRANCA
# 12. QE_I05_NUM
# 13. QE_I17_PRIVADO
# 14. QE_I08_NUM

# βⱼ:
# βⱼ_1: CURSO => 0=adm (basal), 2=direito, 3=medicina, 4=pedagogia, 5=computacao
# βⱼ_2: CO_CATEGAD_PRIVADA => 0=PUBLICA, 1=PRIVADA
