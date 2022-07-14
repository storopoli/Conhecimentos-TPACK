using Arrow
using CategoricalArrays
using DataFrames
using Statistics

df = DataFrame(Arrow.Table(joinpath(pwd(), "data", "data.arrow")))

# 24,418
df_adm = filter(row -> row.CO_GRUPO == 1, df)

vars = [
        :NT_GER, :NT_FG, :NT_CE,
        :QE_I58, :QE_I29, :QE_I57,
        :CO_REGIAO_CURSO, :CO_CATEGAD_PRIVADA,
        :NU_IDADE, :TP_SEXO_MASC, :QE_I02_BRANCA, :QE_I17_PRIVADO
       ]

select!(df_adm, vars)

Arrow.write(joinpath(pwd(), "data", "adm_only.arrow"); compress=:lz4)(df_adm)
