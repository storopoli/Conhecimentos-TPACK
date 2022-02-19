using AlgebraOfGraphics
using Arrow
using CategoricalArrays
using DataFrames
using GLMakie
using Statistics

df = DataFrame(Arrow.Table(joinpath(pwd(), "data", "data.arrow")))

# Theme
my_theme = Theme(; fontsize=22, font="CMU Serif", Axis=(; titlesize=30))
set_theme!(my_theme)
const blue = RGBAf(0.0, 0.447059, 0.698039, 1.0)
const orange = RGBAf(0.901961, 0.623529, 0.0, 1.0)
const green = RGBAf(0.0, 0.619608, 0.45098, 1.0)

# Density Nota ENADE
f = Figure(; resolution=(1600, 1200))
ax = Axis(
    f[1, 1];
    title="Densidade Notas do ENADE",
    xlabel="Nota",
    ylabel="",
    yticksvisible=false,
    yticklabelsvisible=false,
)
density!(ax, df.NT_GER; label="Geral")
density!(ax, df.NT_FG; label="FG")
density!(ax, df.NT_CE; label="CE")
axislegend(ax)

save(joinpath(pwd(), "figures", "densidade_enade.png"), f)

# Violin [NT_GER, NT_FG, NT_CE] long como X e Y
# side :CO_CATEGAD_PRIVADA
# color :CO_ORGACAD_NUM
df_temp = stack(
    select(df, [:CO_CATEGAD_PRIVADA, :CO_ORGACAD_NUM, :NT_GER, :NT_FG, :NT_CE]),
    [:NT_GER, :NT_FG, :NT_CE],
)
transform!(
    df_temp,
    :variable => (x -> categorical(x; levels=["NT_GER", "NT_FG", "NT_CE"]));
    renamecols=false,
)

f = Figure(; resolution=(1600, 1200))
ax = Axis(
    f[1, 1];
    title="Densidade Notas do ENADE versus Tipo e Categoria de IES",
    xlabel="Nota",
    xticks=(2:3:8, ["Geral", "FG", "CE"]),
    ylabel="",
)
ys = filter(row -> row.variable == "NT_GER" && row.CO_ORGACAD_NUM == 1, df_temp)
violin!(
    ones(nrow(ys)) .+ 0,
    ys.value;
    side=ifelse.(ys.CO_CATEGAD_PRIVADA .== 0, :left, :right),
    show_median=true,
    width=0.95,
    medianlinewidth=3,
    color=blue,
    label="Faculdade",
)
ys = filter(row -> row.variable == "NT_GER" && row.CO_ORGACAD_NUM == 2, df_temp)
violin!(
    ones(nrow(ys)) .+ 1,
    ys.value;
    side=ifelse.(ys.CO_CATEGAD_PRIVADA .== 0, :left, :right),
    show_median=true,
    width=0.95,
    medianlinewidth=3,
    color=orange,
    label="Centro Universitário",
)
ys = filter(row -> row.variable == "NT_GER" && row.CO_ORGACAD_NUM == 3, df_temp)
violin!(
    ones(nrow(ys)) .+ 2,
    ys.value;
    side=ifelse.(ys.CO_CATEGAD_PRIVADA .== 0, :left, :right),
    show_median=true,
    width=0.95,
    medianlinewidth=3,
    color=green,
    label="Universidade",
)
ys = filter(row -> row.variable == "NT_FG" && row.CO_ORGACAD_NUM == 1, df_temp)
violin!(
    ones(nrow(ys)) .+ 3,
    ys.value;
    side=ifelse.(ys.CO_CATEGAD_PRIVADA .== 0, :left, :right),
    show_median=true,
    width=0.95,
    medianlinewidth=3,
    color=blue,
    label="Faculdade",
)
ys = filter(row -> row.variable == "NT_FG" && row.CO_ORGACAD_NUM == 2, df_temp)
violin!(
    ones(nrow(ys)) .+ 4,
    ys.value;
    side=ifelse.(ys.CO_CATEGAD_PRIVADA .== 0, :left, :right),
    show_median=true,
    width=0.95,
    medianlinewidth=3,
    color=orange,
    label="Centro Universitário",
)
ys = filter(row -> row.variable == "NT_FG" && row.CO_ORGACAD_NUM == 3, df_temp)
violin!(
    ones(nrow(ys)) .+ 5,
    ys.value;
    side=ifelse.(ys.CO_CATEGAD_PRIVADA .== 0, :left, :right),
    show_median=true,
    width=0.95,
    medianlinewidth=3,
    color=green,
    label="Universidade",
)
ys = filter(row -> row.variable == "NT_CE" && row.CO_ORGACAD_NUM == 1, df_temp)
violin!(
    ones(nrow(ys)) .+ 6,
    ys.value;
    side=ifelse.(ys.CO_CATEGAD_PRIVADA .== 0, :left, :right),
    show_median=true,
    width=0.95,
    medianlinewidth=3,
    color=blue,
    label="Faculdade",
)
ys = filter(row -> row.variable == "NT_CE" && row.CO_ORGACAD_NUM == 2, df_temp)
violin!(
    ones(nrow(ys)) .+ 7,
    ys.value;
    side=ifelse.(ys.CO_CATEGAD_PRIVADA .== 0, :left, :right),
    show_median=true,
    width=0.95,
    medianlinewidth=3,
    color=orange,
    label="Centro Universitário",
)
ys = filter(row -> row.variable == "NT_CE" && row.CO_ORGACAD_NUM == 3, df_temp)
violin!(
    ones(nrow(ys)) .+ 8,
    ys.value;
    side=ifelse.(ys.CO_CATEGAD_PRIVADA .== 0, :left, :right),
    show_median=true,
    width=0.95,
    medianlinewidth=3,
    color=green,
    label="Universidade",
)
elem_1 = PolyElement(; color=blue)
elem_2 = PolyElement(; color=orange)
elem_3 = PolyElement(; color=green)
categ_ies = [elem_1, elem_2, elem_3]
categ_ies_label = ["Faculdade", "Centro Universitário", "Universidade"]
elem_5 = MarkerElement(; color=:black, marker='L', markersize=20)
elem_6 = MarkerElement(; color=:black, marker='R', markersize=20)
tipo_ies = [elem_5, elem_6]
tipo_ies_label = ["Pública", "Privada"]
axislegend(
    ax,
    [categ_ies, tipo_ies],
    [categ_ies_label, tipo_ies_label],
    ["Categoria de IES", "Tipo de IES"];
    position=:rt,
    orientation=:horizontal,
)

save(joinpath(pwd(), "figures", "violin_enade.png"), f)

# AoG NT_GERAL vs TPACK
base_layers = data(df) * (linear())
base_fig = (; resolution=(1600, 1200))
base_legend = (; position=:bottom, titleposition=:left, framevisible=true, padding=5)

# TPACK T
plt_t =
    base_layers * mapping(
        :QE_I58,
        :NT_GER;
        color=:CO_CATEGAD_PRIVADA =>
            renamer([0 => "Pública", 1 => "Privada"]) => "Tipo de IES",
        row=:CO_ORGACAD_NUM =>
            renamer([1 => "Faculdade", 2 => "Centro Universitário", 3 => "Universidade"]),
    )
fg_plt_t = draw(
    plt_t; figure=base_fig, axis=(; xticks=1:6, ylabel="Nota Geral"), legend=base_legend
)
supertitle = Label(
    fg_plt_t.figure[0, :],
    "Notas do ENADE versus Perguntas QE de TPACK - T";
    textsize=30,
    tellwidth=false,
)

save(joinpath(pwd(), "figures", "scatter_tpack_t.png"), fg_plt_t)

# TPACK C
c_vars = [:QE_I28, :QE_I39, :QE_I49, :QE_I57]
plt_c =
    base_layers * mapping(
        c_vars,
        :NT_GER;
        col=dims(1),
        color=:CO_CATEGAD_PRIVADA =>
            renamer([0 => "Pública", 1 => "Privada"]) => "Tipo de IES",
        row=:CO_ORGACAD_NUM =>
            renamer([1 => "Faculdade", 2 => "Centro Universitário", 3 => "Universidade"]),
    )
fg_plt_c = draw(
    plt_c; figure=base_fig, axis=(; xticks=1:6, ylabel="Nota Geral"), legend=base_legend
)
supertitle = Label(
    fg_plt_c.figure[0, :],
    "Notas do ENADE versus Perguntas QE de TPACK - C";
    textsize=30,
    tellwidth=false,
)

save(joinpath(pwd(), "figures", "scatter_tpack_c.png"), fg_plt_c)

# TPACK P
p_vars = [:QE_I29, :QE_I30, :QE_I32, :QE_I36, :QE_I40]
plt_p =
    base_layers * mapping(
        p_vars,
        :NT_GER;
        col=dims(1),
        color=:CO_CATEGAD_PRIVADA =>
            renamer([0 => "Pública", 1 => "Privada"]) => "Tipo de IES",
        row=:CO_ORGACAD_NUM =>
            renamer([1 => "Faculdade", 2 => "Centro Universitário", 3 => "Universidade"]),
    )
fg_plt_p = draw(
    plt_p; figure=base_fig, axis=(; xticks=1:6, ylabel="Nota Geral"), legend=base_legend
)
supertitle = Label(
    fg_plt_p.figure[0, :],
    "Notas do ENADE versus Perguntas QE de TPACK - P";
    textsize=30,
    tellwidth=false,
)

save(joinpath(pwd(), "figures", "scatter_tpack_p.png"), fg_plt_p)
