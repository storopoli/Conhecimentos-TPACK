using Arrow
using DataFrames
using Statistics

#### ENADE ####

#df2015 = Arrow.Table(joinpath(pwd(),  "data", "ENADE", "MICRODADOS_ENADE_2015.arrow")) |> DataFrame
#df2016 = Arrow.Table(joinpath(pwd(),  "data", "ENADE", "MICRODADOS_ENADE_2016.arrow")) |> DataFrame
df2017 = Arrow.Table(joinpath(pwd(),  "data", "ENADE", "MICRODADOS_ENADE_2017.arrow")) |> DataFrame
df2018 = Arrow.Table(joinpath(pwd(),  "data", "ENADE", "MICRODADOS_ENADE_2018.arrow")) |> DataFrame
df2019 = Arrow.Table(joinpath(pwd(),  "data", "ENADE", "MICRODADOS_ENADE_2019.arrow")) |> DataFrame

# Variables of Interest
vars = [
        :NU_ANO, :CO_IES,
        :NT_GER, :NT_FG, :NT_CE,                                         # NOTA
        :QE_I58, :QE_I28, :QE_I29, :QE_I49, :QE_I57, :QE_I40, :QE_I30,   # TPACK
        :QE_I32, :QE_I36, :QE_I37, :QE_I56, :QE_I38,                     # TPACK
        :QE_I61, :QE_I62, :QE_I63, :QE_I64, :QE_I65,                     # TPACK Contexto
        :CO_CATEGAD, :CO_ORGACAD,                                        # IES
        :CO_GRUPO, :CO_REGIAO_CURSO, :CO_MODALIDADE,                     # CURSO
        :NU_IDADE, :TP_SEXO, :QE_I01, :QE_I02, :QE_I05, :QE_I17, :QE_I08 # ALUNO
       ]

#select!(df2015, vars)
#select!(df2016, vars)
select!(df2017, vars)
select!(df2018, vars)
select!(df2019, vars)

df = vcat(df2017, df2018, df2019)

#filter!(row -> row.NU_ANO >= 2017, df)

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
# 318,627 alunos
dropmissing!(df, [
                  :QE_I58, :QE_I28, :QE_I29, :QE_I49, :QE_I57, :QE_I40, :QE_I30,
                  :QE_I32, :QE_I36, :QE_I37, :QE_I56, :QE_I38,
                  :QE_I61, :QE_I62, :QE_I63, :QE_I64, :QE_I65,
                  :CO_CATEGAD, :CO_ORGACAD,
                  :CO_GRUPO, :CO_REGIAO_CURSO, :CO_MODALIDADE,
                  :NU_IDADE, :TP_SEXO, :QE_I01, :QE_I02, :QE_I05, :QE_I17, :QE_I08
                 ])

#### Censo ####

# IES
#ies2015 = Arrow.Table(joinpath(pwd(), "data", "Censo", "DM_IES_2015.arrow")) |> DataFrame
#ies2016 = Arrow.Table(joinpath(pwd(), "data", "Censo", "DM_IES_2016.arrow")) |> DataFrame
ies2017 = Arrow.Table(joinpath(pwd(), "data", "Censo", "DM_IES_2017.arrow")) |> DataFrame
ies2018 = Arrow.Table(joinpath(pwd(), "data", "Censo", "DM_IES_2018.arrow")) |> DataFrame
ies2019 = Arrow.Table(joinpath(pwd(), "data", "Censo", "DM_IES_2019.arrow")) |> DataFrame

#rename!(ies2015, :VL_DES_INVESTIMENTO => :VL_DESPESA_INVESTIMENTO)
#rename!(ies2016, :VL_DES_INVESTIMENTO => :VL_DESPESA_INVESTIMENTO)
#ies2015[:, :NU_ANO_CENSO] .= 2015
#ies2016[:, :NU_ANO_CENSO] .= 2016
#select!(ies2015, :NU_ANO_CENSO, :CO_IES, :VL_DESPESA_INVESTIMENTO)
#select!(ies2016, :NU_ANO_CENSO, :CO_IES, :VL_DESPESA_INVESTIMENTO)
select!(ies2017, :NU_ANO_CENSO, :CO_IES, :VL_DESPESA_INVESTIMENTO)
select!(ies2018, :NU_ANO_CENSO, :CO_IES, :VL_DESPESA_INVESTIMENTO)
select!(ies2019, :NU_ANO_CENSO, :CO_IES, :VL_DESPESA_INVESTIMENTO)
ies = vcat(ies2017, ies2018, ies2019)
transform!(ies, :VL_DESPESA_INVESTIMENTO => ByRow(x -> parse(Float64, x)); renamecols=false)

# Docente
#docente2015 = Arrow.Table(joinpath(pwd(), "data", "Censo", "DM_DOCENTE_2015.arrow")) |> DataFrame
#docente2016 = Arrow.Table(joinpath(pwd(), "data", "Censo", "DM_DOCENTE_2016.arrow")) |> DataFrame
docente2017 = Arrow.Table(joinpath(pwd(), "data", "Censo", "DM_DOCENTE_2017.arrow")) |> DataFrame
docente2018 = Arrow.Table(joinpath(pwd(), "data", "Censo", "DM_DOCENTE_2018.arrow")) |> DataFrame
docente2019 = Arrow.Table(joinpath(pwd(), "data", "Censo", "DM_DOCENTE_2019.arrow")) |> DataFrame

#docente2015[:, :NU_ANO_CENSO] .= 2015
#docente2016[:, :NU_ANO_CENSO] .= 2016

#select!(docente2015,
#        :NU_ANO_CENSO,
#        :CO_IES,
#        :IN_SEXO_DOCENTE => :TP_SEXO,
#        :DS_ESCOLARIDADE_DOCENTE => :TP_ESCOLARIDADE,
#        :DS_REGIME_TRABALHO => :TP_REGIME_TRABALHO,
#        :NU_IDADE_DOCENTE => :NU_IDADE,
#        :DS_COR_RACA_DOCENTE => :TP_COR_RACA)
#select!(docente2016,
#        :NU_ANO_CENSO,
#        :CO_IES,
#        :IN_SEXO_DOCENTE => :TP_SEXO,
#        :DS_ESCOLARIDADE_DOCENTE => :TP_ESCOLARIDADE,
#        :DS_REGIME_TRABALHO => :TP_REGIME_TRABALHO,
#        :NU_IDADE_DOCENTE => :NU_IDADE,
#        :DS_COR_RACA_DOCENTE => :TP_COR_RACA)
select!(docente2017, :NU_ANO_CENSO, :CO_IES, :TP_SEXO, :TP_ESCOLARIDADE, :TP_REGIME_TRABALHO, :NU_IDADE, :TP_COR_RACA)
select!(docente2018, :NU_ANO_CENSO, :CO_IES, :TP_SEXO, :TP_ESCOLARIDADE, :TP_REGIME_TRABALHO, :NU_IDADE, :TP_COR_RACA)
select!(docente2019, :NU_ANO_CENSO, :CO_IES, :TP_SEXO, :TP_ESCOLARIDADE, :TP_REGIME_TRABALHO, :NU_IDADE, :TP_COR_RACA)
docente = vcat(docente2017, docente2018, docente2019)
dropmissing!(docente)

transform!(docente,
          :TP_SEXO => ByRow(x -> ifelse(x == 1, 0, 1)) => :TP_SEXO_MASC,
          :TP_REGIME_TRABALHO => ByRow(x -> ifelse(x <= 2, 1, 0)) => :TP_REGIME_TRABALHO_TI,
          :TP_COR_RACA => ByRow(x -> ifelse(x == 1, 1, 0)) => :TP_COR_RACA_BRANCA)
select!(docente, Not([:TP_SEXO, :TP_REGIME_TRABALHO, :TP_COR_RACA]))

# Groupby Docente por CO_IES
docente_grouped = combine(groupby(docente, [:NU_ANO_CENSO, :CO_IES]),
                          nrow => :NU_DOCENTE,
                          [:TP_ESCOLARIDADE,
                           :NU_IDADE,
                           :TP_SEXO_MASC,
                           :TP_REGIME_TRABALHO_TI,
                           :TP_COR_RACA_BRANCA] .=> mean .=>
                          [:TP_ESCOLARIDADE_DOCENTE,
                           :NU_IDADE_DOCENTE,
                           :TP_SEXO_MASC_DOCENTE,
                           :TP_REGIME_TRABALHO_TI_DOCENTE,
                           :TP_COR_RACA_BRANCA_DOCENTE]
                         )

#### JOINS ####

df = leftjoin(df, ies; on=[:CO_IES, :NU_ANO => :NU_ANO_CENSO])
df = leftjoin(df, docente_grouped; on=[:CO_IES, :NU_ANO => :NU_ANO_CENSO])

# 318,627 para 318,386
dropmissing!(df)

df |> Arrow.write(joinpath(pwd(), "data", "data.arrow"); compress=:lz4)
