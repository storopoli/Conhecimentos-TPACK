using AlgebraOfGraphics
using Arrow
using CairoMakie
using DataFrames
using Statistics

df = Arrow.Table(joinpath(pwd(), "data", "data.arrow")) |> DataFrame

set_aog_theme!()

tpack = names(df, Between(:QE_I58, :QE_I65))
control = ["NU_IDADE"] ∪ names(df, Between(:TP_SEXO_MASC, :QE_I08_NUM))
nt = ["NT_GER", "NT_FG", "NT_CE"]
df_nt_long = stack(select(df, ["CO_CATEGAD_PRIVADA", "CO_ORGACAD_NUM"] ∪ nt), nt)
df_tpack_long = stack(select(df, ["CO_CATEGAD_PRIVADA", "CO_ORGACAD_NUM"] ∪ tpack), tpack)
df_control_long = stack(select(df, nt ∪ control), nt)

# Density [NT_GER, NT_FG, NT_CE] long como X e Y
density_nt = data(df_nt_long) *
    mapping(
        :value => "";
        color=:variable => renamer(["NT_GER" => "GER", "NT_CE" => "CE", "NT_FG" => "FG"]) => "Nota ENADE",
            ) *
            AlgebraOfGraphics.density()

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

# Violin TPACK long como X e Y
# side e color como CO_ORGACAD_NUM com renamer
violing_tpack_categ = data(df_tpack_long) *
    mapping(
        :variable,
        :value => "";
        color=:CO_CATEGAD_PRIVADA => renamer([0 => "Pública", 1 => "Privada"]) => "Tipo de IES",
        side=:CO_CATEGAD_PRIVADA => renamer([0 => "Pública", 1 => "Privada"]) => "Tipo de IES"
        ) *
    visual(Violin; show_median=true, width=0.95)

fg_violing_tpack_categ = draw(violing_tpack_categ;
    legend=(; position=:bottom, titleposition=:left, framevisible=true, padding=5))

save(joinpath(pwd(), "figures", "violin_tpack_categ.png"), fg_violing_tpack_categ; px_per_unit=3)

# Violin TPACK long como X e Y
# dodge e color como CO_ORGACAD_NUM com renamer
violin_tpack_tipo = data(df_tpack_long) *
    mapping(
        :variable,
        :value => "";
        color=:CO_ORGACAD_NUM => renamer([1 => "Faculdade", 2 => "Centro Universitário", 3 => "Universidade"]) => "Categoria de IES",
        dodge=:CO_ORGACAD_NUM => renamer([1 => "Faculdade", 2 => "Centro Universitário", 3 => "Universidade"]) => "Categoria de IES"
        ) *
    visual(Violin; show_median=true, width=0.95)

fg_violin_tpack_tipo = draw(violing_tpack_tipo;
    legend=(; position=:bottom, titleposition=:left, framevisible=true, padding=5))

save(joinpath(pwd(), "figures", "violin_tpack_tipo.png"), fg_violin_tpack_tipo; px_per_unit=3)
