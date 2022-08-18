library(cmdstanr)
library(arrow)
library(dplyr)
library(magrittr)

# Data
df <- read_feather("data/data.arrow")

# Stan model
m <- cmdstan_model("src/model.stan")

# Moderations
df %<>% mutate(
  tech = QE_I58,
  content = QE_I57,
  pedag = QE_I29,
  tech_content = QE_I58 * QE_I57,
  tech_pedag = QE_I58 * QE_I29,
  content_pedag = QE_I57 * QE_I29
)

# Stan data for different y
stan_data_ger <- list(
  X = df %>% select(
    starts_with("tech"),
    starts_with("content"),
    starts_with("pedag"),
    NU_IDADE:QE_I08_NUM
  ) %>%
    as.matrix(),
  y = df$NT_GER,
  N = df %>% nrow(),
  K = df %>% select(
    starts_with("tech"),
    starts_with("content"),
    starts_with("pedag"),
    NU_IDADE:QE_I08_NUM
  ) %>%
    ncol(),
  J1 = df$CO_REGIAO_CURSO %>% unique() %>% length(),
  J2 = df$CO_CATEGAD_PRIVADA %>% unique() %>% length(),
  idx1 = df$CO_REGIAO_CURSO,
  idx2 = df$CO_CATEGAD_PRIVADA + 1,
  mean_y = df$NT_GER %>% mean(),
  std_y = df$NT_GER %>% sd()
)

stan_data_fg <- list(
  X = df %>% select(
    starts_with("tech"),
    starts_with("content"),
    starts_with("pedag"),
    NU_IDADE:QE_I08_NUM
  ) %>%
    as.matrix(),
  y = df$NT_FG,
  N = df %>% nrow(),
  K = df %>% select(
    starts_with("tech"),
    starts_with("content"),
    starts_with("pedag"),
    NU_IDADE:QE_I08_NUM
  ) %>%
    ncol(),
  J1 = df$CO_REGIAO_CURSO %>% unique() %>% length(),
  J2 = df$CO_CATEGAD_PRIVADA %>% unique() %>% length(),
  idx1 = df$CO_REGIAO_CURSO,
  idx2 = df$CO_CATEGAD_PRIVADA + 1,
  mean_y = df$NT_FG %>% mean(),
  std_y = df$NT_FG %>% sd()
)

stan_data_ce <- list(
  X = df %>% select(
    starts_with("tech"),
    starts_with("content"),
    starts_with("pedag"),
    NU_IDADE:QE_I08_NUM
  ) %>%
    as.matrix(),
  y = df$NT_CE,
  N = df %>% nrow(),
  K = df %>% select(
    starts_with("tech"),
    starts_with("content"),
    starts_with("pedag"),
    NU_IDADE:QE_I08_NUM
  ) %>%
    ncol(),
  J1 = df$CO_REGIAO_CURSO %>% unique() %>% length(),
  J2 = df$CO_CATEGAD_PRIVADA %>% unique() %>% length(),
  idx1 = df$CO_REGIAO_CURSO,
  idx2 = df$CO_CATEGAD_PRIVADA + 1,
  mean_y = df$NT_CE %>% mean(),
  std_y = df$NT_CE %>% sd()
)

# fit the models
fit_ger <- m$sample(data = stan_data_ger, parallel_chains = 4)
fit_fg <- m$sample(data = stan_data_fg, parallel_chains = 4)
fit_ce <- m$sample(data = stan_data_ce, parallel_chains = 4)

# save results
fit_ger$summary() %>% write.csv("results/stan_ger.csv")
fit_fg$summary() %>% write.csv("results/stan_fg.csv")
fit_ce$summary() %>% write.csv("results/stan_ce.csv")
# beta:
# 1. QE_I58
# 2. QE_I29
# 3. QE_I57
# 4. QE_I58 * QE_I29
# 5. QE_I58 * QE_I57
# 6. QE_I57 * QE_I29
# 7. NU_IDADE
# 8. TP_SEXO_MASC
# 9. QE_I01_SOLTEIRO
# 10. QE_I02_BRANCA
# 11. QE_I05_NUM
# 12. QE_I17_PRIVADO
# 13. QE_I08_NUM

# alpha_j:
# alpha_j_1: CO_REGIAO_CURSO => 1=N, 2=NE, 3=SE, 4=S, 5=CO
# alpha_j_2: CO_CATEGAD_PRIVADA => 1=PUBLICA, 2=PRIVADA
