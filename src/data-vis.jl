using AlgebraOfGraphics
using Arrow
using CairoMakie
using DataFrames
using Statistics
using AlgebraOfGraphics: density

df = Arrow.Table(joinpath(pwd(), "data", "data.arrow")) |> DataFrame

set_aog_theme!()

nt = [:NT_GER, :NT_FG, :NT_CE]
tpack = Symbol.(names(df, Between(:QE_I58, :QE_I65)))
control = ["NU_IDADE"] ∪ names(df, Between(:TP_SEXO_MASC, :QE_I08_NUM))
df_nt_long = stack(select(df, [:CO_CATEGAD_PRIVADA, :CO_ORGACAD_NUM] ∪ nt), nt)

# Density [NT_GER, NT_FG, NT_CE] long como X e Y
density_nt = data(df) *
    density() *
    mapping(nt .=> "Nota ENADE") *
    mapping(; color=dims(1) => renamer(["GER", "CE", "FG"]) => "Nota ENADE")

fg_density_nt = draw(density_nt;
     legend=(; position=:top, titleposition=:left, framevisible=true, padding=5),
     axis=(; ylabel="", yticklabelsvisible=false, yticksvisible=false))

save(joinpath(pwd(), "figures", "histograma_enade.png"), fg_density_nt; px_per_unit=3)

# Violin [NT_GER, NT_FG, NT_CE] long como X e Y
# side e color :CO_CATEGAD_PRIVADA
violin_nt = data(df_nt_long) *
    mapping(
        :variable => renamer(["NT_GER" => "GER", "NT_CE" => "CE", "NT_FG" => "FG"]) => "Nota ENADE",
        :value => "";
        color=:CO_CATEGAD_PRIVADA => renamer([0 => "Pública", 1 => "Privada"]) => "Tipo de IES",
        side=:CO_CATEGAD_PRIVADA => renamer([0 => "Pública", 1 => "Privada"]) => "Tipo de IES",
        col=:CO_ORGACAD_NUM => renamer([1 => "Faculdade", 2 => "Centro Universitário", 3 => "Universidade"]) => "Categoria de IES"
            ) *
    visual(Violin; show_median=true, width=0.95)

fg_violin_nt = draw(violin_nt;
    legend=(; position=:bottom, titleposition=:left, framevisible=true, padding=5))

save(joinpath(pwd(), "figures", "violin_enade.png"), fg_violin_nt; px_per_unit=3)

# Barplot Expectation TPACK com Tipo de IES
df_tpack_tipo = combine(groupby(df, :CO_CATEGAD_PRIVADA), tpack .=> mean ∘ skipmissing .=> tpack)
transform!(df_tpack_tipo, :CO_CATEGAD_PRIVADA => ByRow(x -> ifelse(x == 1, "Privada", "Pública")); renamecols=false)
df_tpack_tipo = permutedims(df_tpack_tipo, 1, "Perguntas QE")
df_tpack_tipo = stack(df_tpack_tipo, 2:3)
expectation_tpack_tipo = data(df_tpack_tipo) *
    visual(BarPlot) *
    mapping(
        "Perguntas QE",
        :value => "";
        color=:variable => "Tipo de IES",
        dodge=:variable
    )


fg_expectation_tpack_tipo = draw(expectation_tpack_tipo;
    legend=(; position=:bottom, titleposition=:left, framevisible=true, padding=5),
    axis=(; xticklabelrotation=π/8))

save(joinpath(pwd(), "figures", "barplot_tpack_tipo.png"), fg_expectation_tpack_tipo; px_per_unit=3)

# Barplot Expectation TPACK com Categoria de IES
df_tpack_categ = combine(groupby(df, :CO_ORGACAD_NUM), tpack .=> mean ∘ skipmissing .=> tpack)
transform!(df_tpack_categ, :CO_ORGACAD_NUM => ByRow(string); renamecols=false)
transform!(df_tpack_categ, :CO_ORGACAD_NUM => x -> replace(x, "1" => "Faculdade", "2" => "Centro Universitário", "3" => "Universidade"); renamecols=false)
df_tpack_categ = permutedims(df_tpack_categ, 1, "Perguntas QE")
df_tpack_categ = stack(df_tpack_categ, 2:4)
expectation_tpack_categ = data(df_tpack_categ) *
    visual(BarPlot) *
    mapping(
        "Perguntas QE",
        :value => "";
        color=:variable => "Categoria de IES",
        dodge=:variable
    )


fg_expectation_tpack_categ = draw(expectation_tpack_categ;
    legend=(; position=:bottom, titleposition=:left, framevisible=true, padding=5),
    axis=(; xticklabelrotation=π/8))

save(joinpath(pwd(), "figures", "barplot_tpack_categ.png"), fg_expectation_tpack_categ; px_per_unit=3)
