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
function density_enade(df::DataFrame)
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
    return f
end

# Violin [NT_GER, NT_FG, NT_CE] long como X e Y
# side :CO_CATEGAD_PRIVADA
# color :CO_ORGACAD_NUM
function violin_enade(df::DataFrame)
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
    return f
end

function tpack_nota(df::DataFrame, type::AbstractString; nota::Symbol=:NT_GER)
    base_layers = data(df) * (linear())
    base_fig = (; resolution=(1600, 1200))
    base_legend = (; position=:bottom, titleposition=:left, framevisible=true, padding=5)
    if type == "t"
        # TPACK T
        vars = :QE_I58
        plt =
            base_layers * mapping(
                vars,
                nota;
                color=:CO_CATEGAD_PRIVADA =>
                    renamer([0 => "Pública", 1 => "Privada"]) => "Tipo de IES",
                row=:CO_ORGACAD_NUM => renamer([
                    1 => "Faculdade", 2 => "Centro Universitário", 3 => "Universidade"
                ]),
            )
        f = draw(
            plt;
            figure=base_fig,
            axis=(; xticks=1:6, ylabel="Nota Geral"),
            legend=base_legend,
        )
        supertitle = Label(
            f.figure[0, :],
            "Notas do ENADE versus Perguntas QE de TPACK - T";
            textsize=30,
            tellwidth=false,
        )
    elseif type == "c"
        # TPACK C
        vars = [:QE_I28, :QE_I39, :QE_I49, :QE_I57]
        plt =
            base_layers * mapping(
                vars,
                nota;
                col=dims(1),
                color=:CO_CATEGAD_PRIVADA =>
                    renamer([0 => "Pública", 1 => "Privada"]) => "Tipo de IES",
                row=:CO_ORGACAD_NUM => renamer([
                    1 => "Faculdade", 2 => "Centro Universitário", 3 => "Universidade"
                ]),
            )
        f = draw(
            plt;
            figure=base_fig,
            axis=(; xticks=1:6, ylabel="Nota Geral"),
            legend=base_legend,
        )
        supertitle = Label(
            f.figure[0, :],
            "Notas do ENADE versus Perguntas QE de TPACK - C";
            textsize=30,
            tellwidth=false,
        )
    elseif type == "p"
        # TPACK P
        vars = [:QE_I29, :QE_I30, :QE_I32, :QE_I36, :QE_I40]
        plt =
            base_layers * mapping(
                vars,
                nota;
                col=dims(1),
                color=:CO_CATEGAD_PRIVADA =>
                    renamer([0 => "Pública", 1 => "Privada"]) => "Tipo de IES",
                row=:CO_ORGACAD_NUM => renamer([
                    1 => "Faculdade", 2 => "Centro Universitário", 3 => "Universidade"
                ]),
            )
        f = draw(
            plt;
            figure=base_fig,
            axis=(; xticks=1:6, ylabel="Nota Geral"),
            legend=base_legend,
        )
        supertitle = Label(
            f.figure[0, :],
            "Notas do ENADE versus Perguntas QE de TPACK - P";
            textsize=30,
            tellwidth=false,
        )
    end
    return f
end

function tpack_nota_curso(df::DataFrame, type::AbstractString, curso::Integer; nota::Symbol=:NT_GER)
    df_curso = filter(row -> row.CO_GRUPO == curso, df)
    base_layers = data(df_curso) * (linear())
    base_fig = (; resolution=(1600, 1200))
    base_legend = (; position=:bottom, titleposition=:left, framevisible=true, padding=5)
    if type == "t"
        # TPACK T
        vars = :QE_I58
        plt =
            base_layers * mapping(
                vars,
                nota;
                color=:CO_CATEGAD_PRIVADA =>
                    renamer([0 => "Pública", 1 => "Privada"]) => "Tipo de IES",
                row=:CO_ORGACAD_NUM => renamer([
                    1 => "Faculdade", 2 => "Centro Universitário", 3 => "Universidade"
                ]),
            )
        f = draw(
            plt;
            figure=base_fig,
            axis=(; xticks=1:6, ylabel="Nota Geral"),
            legend=base_legend,
        )
        supertitle = Label(
            f.figure[0, :],
            "Notas do ENADE versus Perguntas QE de TPACK - T - Curso $(curso)";
            textsize=30,
            tellwidth=false,
        )
    elseif type == "c"
        # TPACK C
        vars = [:QE_I28, :QE_I39, :QE_I49, :QE_I57]
        plt =
            base_layers * mapping(
                vars,
                nota;
                col=dims(1),
                color=:CO_CATEGAD_PRIVADA =>
                    renamer([0 => "Pública", 1 => "Privada"]) => "Tipo de IES",
                row=:CO_ORGACAD_NUM => renamer([
                    1 => "Faculdade", 2 => "Centro Universitário", 3 => "Universidade"
                ]),
            )
        f = draw(
            plt;
            figure=base_fig,
            axis=(; xticks=1:6, ylabel="Nota Geral"),
            legend=base_legend,
        )
        supertitle = Label(
            f.figure[0, :],
            "Notas do ENADE versus Perguntas QE de TPACK - C - Curso $(curso)";
            textsize=30,
            tellwidth=false,
        )
    elseif type == "p"
        # TPACK P
        vars = [:QE_I29, :QE_I30, :QE_I32, :QE_I36, :QE_I40]
        plt =
            base_layers * mapping(
                vars,
                nota;
                col=dims(1),
                color=:CO_CATEGAD_PRIVADA =>
                    renamer([0 => "Pública", 1 => "Privada"]) => "Tipo de IES",
                row=:CO_ORGACAD_NUM => renamer([
                    1 => "Faculdade", 2 => "Centro Universitário", 3 => "Universidade"
                ]),
            )
        f = draw(
            plt;
            figure=base_fig,
            axis=(; xticks=1:6, ylabel="Nota Geral"),
            legend=base_legend,
        )
        supertitle = Label(
            f.figure[0, :],
            "Notas do ENADE versus Perguntas QE de TPACK - P - Curso $(curso)";
            textsize=30,
            tellwidth=false,
        )
    end
    return f
end

save(joinpath(pwd(), "figures", "densidade_enade.png"), density_enade(df))

save(joinpath(pwd(), "figures", "violin_enade.png"), violin_enade(df))

save(joinpath(pwd(), "figures", "scatter_tpack_t.png"), tpack_nota(df,"t"))
save(joinpath(pwd(), "figures", "scatter_tpack_c.png"), tpack_nota(df,"c"))
save(joinpath(pwd(), "figures", "scatter_tpack_p.png"), tpack_nota(df,"p"))

map(x -> save(joinpath(pwd(), "figures", "scatter_tpack_t_curso_$(x).png"), tpack_nota_curso(df, "t", x)), [1, 2, 12, 2001, 4004])
map(x -> save(joinpath(pwd(), "figures", "scatter_tpack_c_curso_$(x).png"), tpack_nota_curso(df, "c", x)), [1, 2, 12, 2001, 4004])
map(x -> save(joinpath(pwd(), "figures", "scatter_tpack_p_curso_$(x).png"), tpack_nota_curso(df, "p", x)), [1, 2, 12, 2001, 4004])
