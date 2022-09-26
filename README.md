# Conhecimentos TPACK

Este repositório contém os dados e código para reproduzir a anaálise
do paper "TITULO" publicado no "JOURNAL".

TODO: Inserir citação APA.

## Dicionário de Dados

### ENADE - Desempenho do Aluno

- `NT_GER`: Nota Geral
- `NT_FG`: Nota Formação Geral
- `NT_CE`: Nota Componente Específico

### ENADE - TPACK

Valores:

- `1` - Discordo totalmente
- `2` - Discordo
- `3` - Discordo parcialmente
- `4` - Concordo parcialmente
- `5` - Concordo
- `6` - Concordo totalmente
- `7` - Não se aplica
- `8` - Não sei responder

- `T` (Tecnologia):
  - `QE_I58`: Os professores utilizarão tecnologias da informação e
              comunicação (TICs) como estratégia de ensino
              (projetor, multimídia, laboratórios de informática,
               ambiente virtual de aprendizagem).
- `C` (Conteúdo):
  - `QE_I57`: Os professores demonstraram domínio dos conteúdos abordados nas disciplinas.
- `P` (Pedagogia):
  - `QE_I29`: As metodologias de ensino utilizadas no curso desafiaram você a
              aprofundar conhecimentos e desenvolver competências reflexivas e críticas.

### ENADE - IES

- Categoria Administrativa - `CO_CATEGAD`:
  - `10005`, `10008`, `118`, `120`, `121`, `10006` e `10009`: IES privada
  - `93`, `17634`, `115`, `116`, `10001`, `10002` e `10003`: IES pública
- Organização Acadêmica - `CO_ORGACAD`:
  - `10022`: Faculdade `1`
  - `10020`: Centro Universitário `2`
  - `10028`: Universidade `3` **SELECIONADO**
  - `10019` e `10026`: Centros Federais e Institutos Federais (removidos)

### ENADE - Curso

- Área do Curso no ENADE - `CO_GRUPO`:
  - `1`: ADMINISTRAÇÃO: **SELECIONADO**
  - `2`: DIREITO: **SELECIONADO**
  - `12`: MEDICINA: **SELECIONADO**
  - `2001`: PEDAGOGIA: **SELECIONADO**
  - `4004`: CIÊNCIAS DA COMPUTAÇÃO: **SELECIONADO**
  - `13`: CIÊNCIAS ECONÔMICAS
  - `18`: PSICOLOGIA
  - `22`: CIÊNCIAS CONTÁBEIS
  - `26`: DESIGN
  - `29`: TURISMO
  - `38`: SERVIÇO SOCIAL
  - `67`: SECRETARIADO EXECUTIVO
  - `81`: RELAÇÕES INTERNACIONAIS
  - `83`: TECNOLOGIA EM DESIGN DE MODA
  - `84`: TECNOLOGIA EM MARKETING
  - `85`: TECNOLOGIA EM PROCESSOS GERENCIAIS
  - `86`: TECNOLOGIA EM GESTÃO DE RECURSOS HUMANOS
  - `87`: TECNOLOGIA EM GESTÃO FINANCEIRA
  - `88`: TECNOLOGIA EM GASTRONOMIA
  - `93`: TECNOLOGIA EM GESTÃO COMERCIAL
  - `94`: TECNOLOGIA EM LOGÍSTICA
  - `100`: ADMINISTRAÇÃO PÚBLICA
  - `101`: TEOLOGIA
  - `102`: TECNOLOGIA EM COMÉRCIO EXTERIOR
  - `103`: TECNOLOGIA EM DESIGN DE INTERIORES
  - `104`: TECNOLOGIA EM DESIGN GRÁFICO
  - `105`: TECNOLOGIA EM GESTÃO DA QUALIDADE
  - `106`: TECNOLOGIA EM GESTÃO PÚBLICA
  - `803`: COMUNICAÇÃO SOCIAL: JORNALISMO
  - `804`: COMUNICAÇÃO SOCIAL: PUBLICIDADE E PROPAGANDA

- Região do Curso - `CO_REGIAO_CURSO`:
  - `1`: Região Norte (NO)
  - `2`: Região Nordeste (NE)
  - `3`: Região Sudeste (SE)
  - `4`: Região Sul (SUL)
  - `5`: Região Centro-Oeste (CO)

- Modalidade de Ensino - `CO_MODALIDADE`:
  - `1`: Educação Presencial - **SELECIONADO**
  - `2`: Educação a Distância

### ENADE - Aluno

- Idade - `NU_IDADE`
- Sexo -  `TP_SEXO`:
  - `M`: Masculino
  - `F`: Feminino

- Estado Civil - `QE_I01` (Solteiro e Não-Solteiro):
  - `A`: Solteiro(a)
  - `B`: Casado(a)
  - `C`: Separado(a) judicialmente/divorciado(a)
  - `D`: Viúvo(a)
  - `E`: Outro

- Cor/Raça - `QE_I02` (Branca e Não-Branca):
  - `A`: Branca
  - `B`: Preta
  - `C`: Amarela
  - `D`: Parda
  - `E`: Indígena
  - `F`: Não quero declarar
- Escolarização da Mãe - `QE_I05` (Superior ou Não):
  - `A`: Nenhuma
  - `B`: Ensino Fundamental: 1º ao 5º ano (1ª a 4ª série)
  - `C`: Ensino Fundamental: 6º ao 9º ano (5ª a 8ª série)
  - `D`: Ensino médio
  - `E`: Ensino Superior - Graduação
  - `F`: Pós-graduação
- Ensino Médio - `QE_I17` (Pública ou Privada):
  - `A`: Todo em escola pública
  - `B`: Todo em escola privada (particular)
  - `C`: Todo no exterior
  - `D`: A maior parte em escola pública
  - `E`: A maior parte em escola privada (particular)
  - `F`: Parte no Brasil e parte no exterior
- Renda Total Familiar - `QE_I08`:
  - `A`: Até 1,5 salário mínimo (até R$ 1.431,00)
  - `B`: De 1,5 a 3 salários mínimos (R$ 1.431,01 a R$ 2.862,00)
  - `C`: De 3 a 4,5 salários mínimos (R$ 2.862,01 a R$ 4.293,00)
  - `D`: De 4,5 a 6 salários mínimos (R$ 4.293,01 a R$ 5.724,00)
  - `E`: De 6 a 10 salários mínimos (R$ 5.724,01 a R$ 9.540,00)
  - `F`: De 10 a 30 salários mínimos (R$ 9.540,01 a R$ 28.620,00)
  - `G`: Acima de 30 salários mínimos (mais de R$ 28.620,00)

## Modelos

- Variável Dependente: `NT_GER`
- Variável Independente: `TPACK` em suas 7 composições:
  - `T`: `QE_I58`
  - `P`: `QE_I57`
  - `C`: `QE_I29`
  - `TP`/`PT`: `QE_I58 * QE_I57`
  - `TC`/`CT`: `QE_I58 * QE_I29`
  - `PC`/`CP`: `QE_I57 * QE_I29`
  - `TPC`: `QE_I58 * QE_I57 * QE_I29`
- Variáveis de Controle:
  - Idade - `NU_IDADE`
  - Sexo -  `TP_SEXO_MASC`
  - Estado Civil - `QE_I01` (Solteiro e Não-Solteiro)
  - Cor/Raça - `QE_I02` (Branca e Não-Branca)
  - Escolarização da Mãe - `QE_I05` (Superior ou Não)
  - Ensino Médio - `QE_I17` (Pública ou Privada)
  - Renda Total Familiar - `QE_I08`
  - Região do Curso - `CO_REGIAO_CURSO`:
    - `1`: Região Norte (NO)
    - `2`: Região Nordeste (NE)
    - `3`: Região Sudeste (SE)
    - `4`: Região Sul (SUL)
    - `5`: Região Centro-Oeste (CO)
- Variável "Hierárquica": Um $\beta$ para cada
  - Curso `CO_GRUPO`:
    - `1`: ADMINISTRAÇÃO
    - `2`: DIREITO
    - `12`: MEDICINA
    - `2001`: PEDAGOGIA
    - `4004`: CIÊNCIAS DA COMPUTAÇÃO
  - Categoria Administrativa - `CO_CATEGAD`:
    - `10005`, `10008`, `118`, `120`, `121`, `10006` e `10009`: IES privada
    - `93`, `17634`, `115`, `116`, `10001`, `10002` e `10003`: IES pública
    
## Executar modelo Stan

1. Siga as instruções de instalação na documentação do [`CmdStan`](https://mc-stan.org/docs/cmdstan-guide/cmdstan-installation.html).
  1. Não se esqueça de setar `STAN_CPP_OPTIMS=true` e `STAN_THREADS=true` no arquivo `make/local` para amostragem em paralelo; ou siga as recomendações do arquivo `make/local.example`.
1. No diretório da instalação de `CmdStan` digite `make <caminho_para_diretorio_raiz>/src/model_all_brms`.
1. Execute o modelo com 4 correntes Markov paralelas `./model_all_brms sample num_chains=4 data file=model_all_brms.json file=model_all_brms.json output file=output.csv num_threads=K`, onde `K` é o número de threads disponíveis para computação em paralelo.
1. As correntes Markov estarão em arquivos `.csv` individuais: `output_1.csv`, `output_2.csv`, `output_3.csv`, `output_4.csv`.

**Observação**: ajustar o valor `grainsize` do `model_all_brms.json` para `max(100, N / (2 * threads))`, onde `N` é o  número de observações nos dados (`99978`) arredondado para cima.
