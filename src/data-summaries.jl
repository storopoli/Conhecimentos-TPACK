using Arrow
using DataFrames

df2015 = Arrow.Table(joinpath(pwd(),  "data", "ENADE", "MICRODADOS_ENADE_2015.arrow")) |> DataFrame
df2016 = Arrow.Table(joinpath(pwd(),  "data", "ENADE", "MICRODADOS_ENADE_2016.arrow")) |> DataFrame
df2017 = Arrow.Table(joinpath(pwd(),  "data", "ENADE", "MICRODADOS_ENADE_2017.arrow")) |> DataFrame
df2018 = Arrow.Table(joinpath(pwd(),  "data", "ENADE", "MICRODADOS_ENADE_2018.arrow")) |> DataFrame
df2019 = Arrow.Table(joinpath(pwd(),  "data", "ENADE", "MICRODADOS_ENADE_2019.arrow")) |> DataFrame

# Variables of Interest
vars = [
        :NU_ANO,
        :NT_GER, :NT_FG, :NT_CE,                                         # NOTA
        :QE_I58,                                                         # T
        :QE_I29, :QE_I30, :QE_I36,                                       # P
        :QE_I28, :QE_I38, :QE_I49, :QE_I57,                              # C
        :CO_CATEGAD, :CO_ORGACAD,                                        # IES
        :CO_GRUPO, :CO_REGIAO_CURSO, :CO_MODALIDADE,                     # CURSO
        :NU_IDADE, :TP_SEXO, :QE_I01, :QE_I02, :QE_I05, :QE_I17, :QE_I08 # ALUNO
       ]

select!(df2015, vars)
select!(df2016, vars)
select!(df2017, vars)
select!(df2018, vars)
select!(df2019, vars)

df = vcat(df2015, df2016, df2017, df2018, df2019)

filter!(row -> row.NU_ANO >= 2017, df)

# Subset só dos Cursos de interesse
cursos = [
          1,     # ADM
          2,     # Direito
          12,    # Medicina
          2001,  # Pedagogia
          4004   # Computação
         ]

# 429,823 alunos
filter!(row -> row.CO_GRUPO in cursos, df)

# Missings das NOTAS
# 369,835 alunos
dropmissing!(df, :NT_GER)

# Missings das Outras Variáveis
# 351,743 alunos
dropmissing!(df, [:QE_I58,
                  :QE_I29, :QE_I30, :QE_I36,
                  :QE_I28, :QE_I38, :QE_I49, :QE_I57,
                  :CO_CATEGAD, :CO_ORGACAD,
                  :CO_GRUPO, :CO_REGIAO_CURSO, :CO_MODALIDADE,
                  :NU_IDADE, :TP_SEXO, :QE_I01, :QE_I02, :QE_I05, :QE_I17, :QE_I08
                 ])
