using Arrow
using CSV
using DataFramesMeta
using LinearAlgebra
using MultivariateStats
using Statistics
using Turing

# reproducibility
using Random: seed!

seed!(123)

# data
df = DataFrame(Arrow.Table(joinpath(pwd(), "data", "data.arrow")))

# PCA
# One component - Variance Explained 59.6%
tpack = fit(PCA, select(df, [:QE_I58, :QE_I57, :QE_I29]) |> Matrix; maxoutdim=1);

@transform! df begin
    :tech = :QE_I58
    :content = :QE_I57
    :pedag = :QE_I29
    :tech_content = :QE_I58 .* :QE_I57
    :tech_pedag = :QE_I58 .* :QE_I29
    :content_pedag = :QE_I57 .* :QE_I29
    :tpack_pca = vec(tpack.proj)
end


# define data matrix X
X = Matrix(
    select(df,
        Cols(
            r"tech",
            r"content",
            r"pedag",
            Between(:NU_IDADE, :QE_I08_NUM))
    )
)

X_pca = Matrix(
    select(df,
        Cols(
            :tpack_pca,
            Between(:NU_IDADE, :QE_I08_NUM))
    )
)

# define dependent variables y
nt_ger = float(df[:, :NT_GER])
nt_fg = float(df[:, :NT_FG])
nt_ce = float(df[:, :NT_CE])

# define vector of group memberships idx
idx_regiao = df[:, :CO_REGIAO_CURSO]
idx_privada = df[:, :CO_CATEGAD_PRIVADA] .+ 1 # index is {0=publica, 1=privada} so we need to be {1=publica,2=privada}

# define the model
@model function varying_intercept_ncp_regression(
    X,
    idx1,
    idx2,
    y;
    predictors=size(X, 2),
    n_gr1=length(unique(idx1)),
    n_gr2=length(unique(idx2)),
    mean_y=mean(y),
    std_y=std(y)
)
    # priors
    α ~ TDist(3) * (2.5 * std_y) + mean_y
    β ~ filldist(TDist(3) * 2.5, predictors)
    σ ~ Exponential(1)

    # prior for variance of random intercepts
    # usually requires thoughtful specification
    τ_1 ~ truncated(Cauchy(0, 2), 0, Inf) # group-level SDs intercepts
    zⱼ_1 ~ filldist(Normal(0, 1), n_gr1)  # group-level non-centered intercepts
    αⱼ_1 = zⱼ_1 .* τ_1                    # group-level intercepts
    τ_2 ~ truncated(Cauchy(0, 2), 0, Inf) # group-level SDs intercepts
    zⱼ_2 ~ filldist(Normal(0, 1), n_gr2)  # group-level non-centered intercepts
    αⱼ_2 = zⱼ_2 .* τ_2                    # group-level intercepts

    # likelihood
    y ~ MvNormal(α .+ αⱼ_1[idx1] .+ αⱼ_2[idx2] .+ X * β, σ^2 * I)
    return (; y, α, β, σ, αⱼ_1, αⱼ_2, τ_1, τ_2, zⱼ_1, zⱼ_2)
end

# instantiate models
model_ger = varying_intercept_ncp_regression(X, idx_regiao, idx_privada, nt_ger)
model_fg = varying_intercept_ncp_regression(X, idx_regiao, idx_privada, nt_fg)
model_ce = varying_intercept_ncp_regression(X, idx_regiao, idx_privada, nt_ce)
model_pca = varying_intercept_ncp_regression(X_pca, idx_regiao, idx_privada, nt_ger)

# run chains
chn_ger = sample(model_ger, NUTS(), MCMCThreads(), 2_000, 4)
chn_fg = sample(model_fg, NUTS(), MCMCThreads(), 2_000, 4)
chn_ce = sample(model_ce, NUTS(), MCMCThreads(), 2_000, 4)
chn_pca = sample(model_pca, NUTS(), MCMCThreads(), 2_000, 4)

# save summarystats
CSV.write(joinpath(pwd(), "results", "turing_summarystats_ger.csv"), summarystats(chn_ger))
CSV.write(joinpath(pwd(), "results", "turing_summarystats_fg.csv"), summarystats(chn_fg))
CSV.write(joinpath(pwd(), "results", "turing_summarystats_ce.csv"), summarystats(chn_ce))
CSV.write(joinpath(pwd(), "results", "turing_summarystats_pca.csv"), summarystats(chn_pca))

# save quantiles
CSV.write(joinpath(pwd(), "results", "turing_quantile_ger.csv"), quantile(chn_ger))
CSV.write(joinpath(pwd(), "results", "turing_quantile_fg.csv"), quantile(chn_fg))
CSV.write(joinpath(pwd(), "results", "turing_quantile_ce.csv"), quantile(chn_ce))
CSV.write(joinpath(pwd(), "results", "turing_quantile_pca.csv"), quantile(chn_pca))

# β/β_pca:
# 1. QE_I58
# 2. QE_I29
# 3. QE_I57
# 4. QE_I58 * QE_I29
# 5. QE_I58 * QE_I57
# 6. QE_I57 * QE_I29
# 7/2. NU_IDADE
# 8/3. TP_SEXO_MASC
# 9/4. QE_I01_SOLTEIRO
# 10/5. QE_I02_BRANCA
# 11/6. QE_I05_NUM
# 12/7. QE_I17_PRIVADO
# 13/8. QE_I08_NUM

# αⱼ:
# αⱼ_1: CO_REGIAO_CURSO => 1=N, 2=NE, 3=SE, 4=S, 5=CO
# αⱼ_2: CO_CATEGAD_PRIVADA => 1=PUBLICA, 2=PRIVADA
