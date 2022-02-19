using Arrow
using CSV
using DataFrames
using Statistics

df = DataFrame(Arrow.Table(joinpath(pwd(), "data", "data.arrow")))

# Geral
CSV.write(joinpath(pwd(), "tables", "summary.csv"))(
    describe(df, :mean, :median, :q25, :q75, :std, :min, :max)
)

function rename_cursos(i::Integer)
    return if i == 1
        "Administração"
    elseif i == 2
        "Direito"
    elseif i == 12
        "Medicina"
    elseif i == 2001
        "Pedagogia"
    elseif i == 4004
        "Ciências da Computação"
    end
end

# Por Curso
q25(x) = quantile(x, 0.25)
q75(x) = quantile(x, 0.75)
CSV.write(joinpath(pwd(), "tables", "summary_curso.csv"))(
    combine(
        groupby(transform(df, :CO_GRUPO => ByRow(rename_cursos) => :CURSO), :CURSO),
        Between(:NT_GER, :QE_I65) .=> [mean minimum median maximum q25 q75],
    ),
)
