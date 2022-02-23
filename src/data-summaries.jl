using Arrow
using CSV
using DataFrames
using Statistics

df = DataFrame(Arrow.Table(joinpath(pwd(), "data", "data.arrow")))
df_univ = filter(row -> row.CO_ORGACAD_NUM == 3, df)

# Geral
CSV.write(joinpath(pwd(), "tables", "summary.csv"))(
    describe(df, :mean, :median, :q25, :q75, :std, :min, :max)
)
CSV.write(joinpath(pwd(), "tables", "summary_univ.csv"))(
    describe(df_univ, :mean, :median, :q25, :q75, :std, :min, :max)
)

# Por Curso
q25(x) = quantile(x, 0.25)
q75(x) = quantile(x, 0.75)
CSV.write(joinpath(pwd(), "tables", "summary_curso.csv"))(
    combine(
            groupby(df, [:CO_CATEGAD_PRIVADA, :CO_GRUPO]),
        :CO_GRUPO => length => :QTD_ALUNOS, Between(:NT_GER, :QE_I65) .=> [mean minimum median std maximum q25 q75],
    ),
)
CSV.write(joinpath(pwd(), "tables", "summary_curso_univ.csv"))(
    combine(
            groupby(df_univ, [:CO_CATEGAD_PRIVADA, :CO_GRUPO]),
        :CO_GRUPO => length => :QTD_ALUNOS, Between(:NT_GER, :QE_I65) .=> [mean minimum median std maximum q25 q75],
    ),
)
