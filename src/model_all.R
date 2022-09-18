library(cmdstanr)
library(arrow)
library(dplyr)
library(magrittr)

# Data
df <- read_feather("data/data.arrow")

# Stan model
m <- cmdstan_model("src/model_all.stan")

# Moderations
df %<>% mutate(
  tech = QE_I58,
  content = QE_I57,
  pedag = QE_I29,
  tech_content = QE_I58 * QE_I57,
  tech_pedag = QE_I58 * QE_I29,
  content_pedag = QE_I57 * QE_I29,
  tech_pedag_content = QE_I58 * QE_I57 * QE_I29,
  regiao_n = if_else(CO_REGIAO_CURSO == 1, 1, 0),
  regiao_ne = if_else(CO_REGIAO_CURSO == 2, 1, 0),
  regiao_se = if_else(CO_REGIAO_CURSO == 3, 1, 0),
  regiao_s = if_else(CO_REGIAO_CURSO == 4, 1, 0),
  regiao_co = if_else(CO_REGIAO_CURSO == 5, 1, 0),
  co_grupo = case_when(
    CO_GRUPO == 1 ~ 0, # adm (basal)
    CO_GRUPO == 2 ~ 1, # direito
    CO_GRUPO == 12 ~ 2, # medicina
    CO_GRUPO == 2001 ~ 3, # pedagogia
    CO_GRUPO == 4004 ~ 4, # computacao
  )
)

# Stan data
stan_data <- list(
  X = df %>% select(
    starts_with("tech"),
    starts_with("content"),
    starts_with("pedag"),
    NU_IDADE:QE_I08_NUM,
    starts_with("regiao")
  ) %>%
    as.matrix(),
  y = df$NT_GER,
  N = df %>% nrow(),
  K = df %>% select(
    starts_with("tech"),
    starts_with("content"),
    starts_with("pedag"),
    NU_IDADE:QE_I08_NUM,
    starts_with("regiao")
  ) %>%
    ncol(),
  J1 = df$co_grupo %>% unique() %>% length(),
  # J2 = df$CO_CATEGAD_PRIVADA %>% unique() %>% length(),
  idx1 = df$co_grupo,
  # idx2 = df$CO_CATEGAD_PRIVADA, # index is {0=publica, 1=privada}
  mean_y = df$NT_GER %>% mean(),
  std_y = df$NT_GER %>% sd(),
  beta_i = 7
)

# fit the model
fit_all <- m$sample(data = stan_data, parallel_chains = 4)

# save results
fit_all$summary() %>% write.csv("results/all/results.csv")
# beta:
# 1. QE_I58                    tech
# 2. QE_I58 * QE_I29           tech_contet
# 3. QE_I58 * QE_I57           tech_pedag
# 4. QE_I58 * QE_I29 * QE_I57  tech_content_pedag
# 5. QE_I29                    content
# 6. QE_I57 * QE_I29           content_pedag
# 7. QE_I57                    pedag
# 8. NU_IDADE
# 9. TP_SEXO_MASC
# 1-. QE_I01_SOLTEIRO
# 11. QE_I02_BRANCA
# 12. QE_I05_NUM
# 13. QE_I17_PRIVADO
# 14. QE_I08_NUM
# Regiao:
# 14. N
# 15. NE
# 16. SE
# 17. S
# 18. CO

# betaj:
# betaj1: CURSO => 0=adm (basal), 2=direito, 3=medicina, 4=pedagogia, 5=computacao
# betaj2: CO_CATEGAD_PRIVADA => 1=PUBLICA, 2=PRIVADA
