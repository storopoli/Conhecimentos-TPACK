using Arrow
using DataFrames

df2015 = Arrow.Table(joinpath(pwd(), "data", "MICRODADOS_ENADE_2015.arrow")) |> DataFrame
df2016 = Arrow.Table(joinpath(pwd(), "data", "MICRODADOS_ENADE_2016.arrow")) |> DataFrame
df2017 = Arrow.Table(joinpath(pwd(), "data", "MICRODADOS_ENADE_2017.arrow")) |> DataFrame
df2018 = Arrow.Table(joinpath(pwd(), "data", "MICRODADOS_ENADE_2018.arrow")) |> DataFrame
df2019 = Arrow.Table(joinpath(pwd(), "data", "MICRODADOS_ENADE_2019.arrow")) |> DataFrame

# Variables of Interest
vars = [
        :NT_GER, :NT_FG, :NT_CE, # NOTA
        :QE_I58, # T
        :QE_I29, :QE_I30, :QE_I36, # P
        :QE_I28, :QE_I38, :QE_I49, :QE_I57, # C
        :CO_CATEGAD, :CO_ORGACAD, # IES
        :CO_GRUPO, :CO_REGIAO_CURSO, :CO_MODALIDADE, # CURSO
        :NU_IDADE, :TP_SEXO, :QE_I01, :QE_I02, :QE_I05, :QE_I17, :QE_I08 # ALUNO
       ]
