using Arrow
using CSV
using DataFrames
using Statistics

df = DataFrame(Arrow.Table(joinpath(pwd(), "data", "data.arrow")))

# Geral
CSV.write(joinpath(pwd(), "tables", "summary.csv"))(
    describe(df, :mean, :median, :q25, :q75, :std, :min, :max)
)

q25(x) = quantile(x, 0.25)
q75(x) = quantile(x, 0.75)
fun_vec = [mean minimum median std maximum q25 q75]

# Total de IES
CSV.write(joinpath(pwd(), "tables", "summary_ies.csv"))(
    combine(groupby(df, :CO_CATEGAD_PRIVADA), :CO_IES => length ∘ unique => "N_IES")
)

# Por Categoria
CSV.write(joinpath(pwd(), "tables", "summary_categ.csv"))(
    combine(
        groupby(df, :CO_CATEGAD_PRIVADA),
        :CO_GRUPO => length => :QTD_ALUNOS,
        Between(:NT_GER, :QE_I08_NUM) .=> fun_vec,
    ),
)

# Por Categoria/Curso
CSV.write(joinpath(pwd(), "tables", "summary_curso.csv"))(
    combine(
        groupby(df, [:CO_CATEGAD_PRIVADA, :CO_GRUPO]),
        :CO_GRUPO => length => :QTD_ALUNOS,
        Between(:NT_GER, :QE_I08_NUM) .=> fun_vec,
    ),
)

# Por Categoria/Curso/Regiao
CSV.write(joinpath(pwd(), "tables", "summary_regiao.csv"))(
    combine(
        groupby(df, [:CO_CATEGAD_PRIVADA, :CO_GRUPO, :CO_REGIAO_CURSO]),
        :CO_GRUPO => length => :QTD_ALUNOS,
        Between(:NT_GER, :QE_I08_NUM) .=> fun_vec,
    ),
)
