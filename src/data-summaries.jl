using Arrow
using CSV
using DataFrames
using Statistics

df = DataFrame(Arrow.Table(joinpath(pwd(), "data", "data.arrow")))

# Geral
CSV.write(joinpath(pwd(), "tables", "summary.csv"))(
    describe(df, :mean, :median, :q25, :q75, :std, :min, :max)
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
