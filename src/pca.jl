using Arrow
using CSV
using DataFramesMeta
using MultivariateStats
using CairoMakie
using AlgebraOfGraphics
using Statistics: mean

# data
df = DataFrame(Arrow.Table(joinpath(pwd(), "data", "data.arrow")))

# PCA
# One component - Variance Explained 59.6% for 1 PC
tpack = fit(PCA, Matrix(select(df, [:QE_I58, :QE_I57, :QE_I29])); maxoutdim=2);

# df with summary stuff
@select! df begin
    :CO_GRUPO
    :tpack_pca_1 = vec(tpack.proj[:, 1])
    :tpack_pca_2 = vec(tpack.proj[:, 2])
end

pca_df = @chain df begin
    groupby(:CO_GRUPO)
    @combine $(Not(:CO_GRUPO) .=> mean)
end

# Plots
plt =
    data(pca_df) *
    mapping(
        :tpack_pca_1_mean => "PC1",
        :tpack_pca_1_mean => "PC2";
        color=:CO_GRUPO => nonnumeric => "Curso",
    ) *
    visual(Scatter)

fig = draw(plt; axis=(; limits=(-1, 1, -1, 1)))

save(joinpath(pwd(), "figures", "pca_scatter.png"), fig; px_per_unit=3)