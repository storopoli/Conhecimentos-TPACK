using Arrow
using CategoricalArrays
using DataFrames
using Statistics

#### ENADE ####

df2017 = DataFrame(
    Arrow.Table(joinpath(pwd(), "data", "ENADE", "MICRODADOS_ENADE_2017.arrow"))
)
df2018 = DataFrame(
    Arrow.Table(joinpath(pwd(), "data", "ENADE", "MICRODADOS_ENADE_2018.arrow"))
)
df2019 = DataFrame(
    Arrow.Table(joinpath(pwd(), "data", "ENADE", "MICRODADOS_ENADE_2019.arrow"))
)

# Variables of Interest
vars = [
    :NU_ANO,
    :CO_IES,
    :NT_GER,
    :NT_FG,
    :NT_CE,
    :TP_PRES,
    :QE_I58,
    :QE_I28,
    :QE_I39,
    :QE_I49,
    :QE_I57,
    :QE_I40,
    :QE_I29,
    :QE_I30,
    :QE_I32,
    :QE_I36,
    :QE_I37,
    :QE_I56,
    :QE_I38,
    :QE_I61,
    :QE_I62,
    :QE_I63,
    :QE_I64,
    :QE_I65,
    :CO_CATEGAD,
    :CO_ORGACAD,
    :CO_GRUPO,
    :CO_REGIAO_CURSO,
    :CO_MODALIDADE,
    :NU_IDADE,
    :TP_SEXO,
    :QE_I01,
    :QE_I02,
    :QE_I05,
    :QE_I17,
    :QE_I08,
]

select!(df2017, vars)
select!(df2018, vars)
select!(df2019, vars)

df = vcat(df2017, df2018, df2019)

# Subset só dos Cursos de interesse
cursos = [
    1,     # ADM
    2,     # Direito
    12,    # Medicina
    2001,  # Pedagogia
    4004,  # Computação
]

# 429,823 alunos
filter!(row -> row.CO_GRUPO in cursos, df)

# Missings das NOTAS
# 369,835 alunos
dropmissing!(df, :NT_GER)

# Missings das Outras Variáveis
# 318,134 alunos
dropmissing!(
    df,
    [
        :QE_I58,
        :QE_I28,
        :QE_I39,
        :QE_I49,
        :QE_I57,
        :QE_I40,
        :QE_I29,
        :QE_I30,
        :QE_I32,
        :QE_I36,
        :QE_I37,
        :QE_I56,
        :QE_I38,
        :QE_I61,
        :QE_I62,
        :QE_I63,
        :QE_I64,
        :QE_I65,
        :CO_CATEGAD,
        :CO_ORGACAD,
        :CO_GRUPO,
        :CO_REGIAO_CURSO,
        :CO_MODALIDADE,
        :NU_IDADE,
        :TP_SEXO,
        :QE_I01,
        :QE_I02,
        :QE_I05,
        :QE_I17,
        :QE_I08,
    ],
)

# Codificação de Categóricas
transform!(
    df,
    :TP_SEXO => ByRow(x -> ifelse(x == "M", 1, 0)) => :TP_SEXO_MASC,
    :QE_I01 => ByRow(x -> ifelse(x == "A", 1, 0)) => :QE_I01_SOLTEIRO,
    :QE_I02 => ByRow(x -> ifelse(x == "A", 1, 0)) => :QE_I02_BRANCA,
    :QE_I05 =>
        (x -> categorical(x; levels=["A", "B", "C", "D", "E", "F"], ordered=true)) =>
            :QE_I05_NUM,
    :QE_I17 => ByRow(x -> ifelse(x == "A" || x == "D", 0, 1)) => :QE_I17_PRIVADO,
    :QE_I08 =>
        (x -> categorical(x; levels=["A", "B", "C", "D", "E", "F", "G"], ordered=true)) =>
            :QE_I08_NUM,
)
select!(df, Not([:TP_SEXO, :QE_I01, :QE_I02, :QE_I05, :QE_I17, :QE_I08]))
transform!(df, [:QE_I05_NUM, :QE_I08_NUM] .=> ByRow(levelcode); renamecols=false)

# Removendo 7 não se aplica e 8 não sei responder
# 318,134 para 296,599
transform!(df, names(df)[8:24] .=> ByRow(x -> ifelse(x >= 7, missing, x)); renamecols=false)
dropmissing!(df, Between(:QE_I56, :QE_I65))

# Tipo IES
# Mantido apenas Universidade
# 296,599 para 138,474
filter!(row -> row.CO_ORGACAD == 10028, df)
transform!(
    df,
    :CO_CATEGAD =>
        ByRow(
            x -> ifelse(x ∈ [10005, 10008, 118, 120, 121, 10006, 10009, 4, 5, 7], 1, 0)
        ) => :CO_CATEGAD_PRIVADA,
    :CO_ORGACAD =>
        (x -> categorical(x; levels=[10022, 10020, 10028], ordered=true)) =>
            :CO_ORGACAD_NUM,
)
transform!(df, :CO_ORGACAD_NUM => ByRow(levelcode); renamecols=false)
select!(df, Between(1, :CO_IES), :CO_CATEGAD_PRIVADA, :CO_ORGACAD_NUM, :)

# Removendo mais missings
# 138,474 para 134,555
dropmissing!(df)

# Selecionando apenas presencial CO_MODALIDADE = 1
# 134,555 para 103,914
filter!(row -> row.CO_MODALIDADE == 1, df)

# Selecionando apenas presenca valida
# :TP_PRES = 555
# 103,914 para 99,978
filter!(row -> row.TP_PRES == 555, df)

Arrow.write(joinpath(pwd(), "data", "data.arrow"); compress=:lz4)(df)
