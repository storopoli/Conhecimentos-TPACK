# Conhecimentos TPACK

A escala [TPACK](https://www.sciencedirect.com/science/article/pii/S0360131511002569).

## Variáveis do ENADE

### Desempenho do Aluno

- `NT_GER`: Nota Geral
- `NT_FG`: Nota Formação Geral
- `NT_CE`: Nota Componente Específico

### TPACK

Valores:
- `1` - Discordo totalmente
- `2` - Discordo
- `3` - Discordo parcialmente
- `4` - Concordo parcialmente
- `5` - Concordo
- `6` - Concordo totalmente
- `7` - Não se aplica
- `8` - Não sei responder

- `TP` (Tecnologia + Pedagogia):
	- `QE_I58`: Os professores utilizarão tecnologias da informação e comunicação (TICs) como estratégia de ensino (projetor, multimídia, laboratórios de informática, ambiente virtual de aprendizagem).
- `P` (Pedagogia):
	- `QE_I29`: As metodologias de ensino utilizadas no curso desafiaram você a aprofundar conhecimentos e desenvolver competências reflexivas e críticas.
	- `QE_I30`: O curso propiciou experiências de aprendizagem inovadoras.
	- `QE_I36`: O curso contribuiu para o desenvolvimento da sua capacidade de aprender e atualizar-se permanentemente.
- `C` (Conteúdo):
	- `QE_I28`: Os conteúdos abordados nas disciplinas do curso favoreceram sua atuação em estágios ou em atividades de iniciação profissional/
	- `QE_I38`: Os planos de ensino apresentados pelos professores contribuíram para o desenvolvimento das atividades acadêmicas e para seus estudos.
	- `QE_I49`: O curso propiciou acesso a conhecimentos atualizados e/ou contemporâneos em sua área de formação.
	- `QE_I57`: Os professores demonstraram domínio dos conteúdos abordados nas disciplinas.

### IES

- Categoria Administrativa - `CO_CATEGAD`:
	- `10005`, `10008`, `118`, `120`, `121`, `10006` e `10009`: IES privada
	- `93`, `17634`, `115`, `116`, `10001`, `10002` e `10003`: IES pública
- Organização Acadêmica - `CO_ORGACAD`:
	- `10022`: Faculdade
	- `10020`: Centro Universitário
	- `10028`: Universidade
	- `10019` e `10026`: Centros Federais e Institutos Federais (removidos)

### Curso

- Área do Curso no ENADE - `CO_GRUPO`:
	- `1`: ADMINISTRAÇÃO: **SELECIONADO**
	- `2`: DIREITO: **SELECIONADO**
	- `12`: MEDICINA: **SELECIONADO**
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
	- `2001`: PEDAGOGIA: **SELECIONADO**
	- `4004`: CIÊNCIAS DA COMPUTAÇÃO: **SELECIONADO**

- Região do Curso - `CO_REGIAO_CURSO`:
	- `1`: Região Norte (NO)
	- `2`: Região Nordeste (NE)
	- `3`: Região Sudeste (SE)
	- `4`: Região Sul (SUL)
	- `5`: Região Centro-Oeste (CO)

- Modalidade de Ensino - `CO_MODALIDADE`:
	- `1`: Educação Presencial - **SELECIONADO**
	- `2`: Educação a Distância

### Aluno

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
