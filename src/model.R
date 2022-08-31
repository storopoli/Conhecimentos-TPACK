library(cmdstanr)
library(arrow)
library(dplyr)
library(magrittr)

# Data
df <- read_feather("data/data.arrow")

# Stan model
m <- cmdstan_model("src/model.stan")

# Moderations and PCA
df %<>% mutate(
  tech = QE_I58,
  content = QE_I57,
  pedag = QE_I29,
  tech_content = QE_I58 * QE_I57,
  tech_pedag = QE_I58 * QE_I29,
  content_pedag = QE_I57 * QE_I29,
  adm = if_else(CO_GRUPO == 1, 1, 0),
  direito = if_else(CO_GRUPO == 2, 1, 0),
  med = if_else(CO_GRUPO == 12, 1, 0),
  ped = if_else(CO_GRUPO == 2001, 1, 0),
  comput = if_else(CO_GRUPO == 4004, 1, 0),
  tpack_pca = prcomp(
    as.matrix(cbind(QE_I58, QE_I57, QE_I29)),
    center = TRUE,
    scale. = TRUE,
    rank. = 1
  )$x[, 1]
)

# Stan data for different y
stan_data_ger <- list(
  X = df %>% select(
    starts_with("tech"),
    starts_with("content"),
    starts_with("pedag"),
    NU_IDADE:QE_I08_NUM,
    adm:comput
  ) %>%
    as.matrix(),
  y = df$NT_GER,
  N = df %>% nrow(),
  K = df %>% select(
    starts_with("tech"),
    starts_with("content"),
    starts_with("pedag"),
    NU_IDADE:QE_I08_NUM,
    adm:comput
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
    NU_IDADE:QE_I08_NUM,
    adm:comput
  ) %>%
    as.matrix(),
  y = df$NT_FG,
  N = df %>% nrow(),
  K = df %>% select(
    starts_with("tech"),
    starts_with("content"),
    starts_with("pedag"),
    NU_IDADE:QE_I08_NUM,
    adm:comput
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
    NU_IDADE:QE_I08_NUM,
    adm:comput
  ) %>%
    as.matrix(),
  y = df$NT_CE,
  N = df %>% nrow(),
  K = df %>% select(
    starts_with("tech"),
    starts_with("content"),
    starts_with("pedag"),
    NU_IDADE:QE_I08_NUM,
    adm:comput
  ) %>%
    ncol(),
  J1 = df$CO_REGIAO_CURSO %>% unique() %>% length(),
  J2 = df$CO_CATEGAD_PRIVADA %>% unique() %>% length(),
  idx1 = df$CO_REGIAO_CURSO,
  idx2 = df$CO_CATEGAD_PRIVADA + 1,
  mean_y = df$NT_CE %>% mean(),
  std_y = df$NT_CE %>% sd()
)

stan_data_pca_ger <- list(
  X = df %>% select(
    tpack_pca,
    NU_IDADE:QE_I08_NUM
  ) %>%
    as.matrix(),
  y = df$NT_GER,
  N = df %>% nrow(),
  K = df %>% select(
    tpack_pca,
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

stan_data_pca_fg <- list(
  X = df %>% select(
    tpack_pca,
    NU_IDADE:QE_I08_NUM
  ) %>%
    as.matrix(),
  y = df$NT_FG,
  N = df %>% nrow(),
  K = df %>% select(
    tpack_pca,
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

stan_data_pca_ce <- list(
  X = df %>% select(
    tpack_pca,
    NU_IDADE:QE_I08_NUM
  ) %>%
    as.matrix(),
  y = df$NT_CE,
  N = df %>% nrow(),
  K = df %>% select(
    tpack_pca,
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
fit_pca_ger <- m$sample(data = stan_data_pca_ger, parallel_chains = 4)
fit_pca_fg <- m$sample(data = stan_data_pca_fg, parallel_chains = 4)
fit_pca_ce <- m$sample(data = stan_data_pca_ce, parallel_chains = 4)

# save results
fit_ger$summary() %>% write.csv("results/curso/stan_ger.csv")
fit_fg$summary() %>% write.csv("results/curso/stan_fg.csv")
fit_ce$summary() %>% write.csv("results/curso/stan_ce.csv")
fit_pca_ger$summary() %>% write.csv("results/pca/stan_pca_ger.csv")
fit_pca_fg$summary() %>% write.csv("results/pca/stan_pca_fg.csv")
fit_pca_ce$summary() %>% write.csv("results/pca/stan_pca_ce.csv")
# beta/beta_pca:
# 1. QE_I58
# 2. QE_I29
# 3. QE_I57
# 4. QE_I58 * QE_I29
# 5. QE_I58 * QE_I57
# 6. QE_I57 * QE_I29
# 7/2. NU_IDADE
# 8/3. TP_SEXO_MASC
# 9/4. QE_I01_SOLTEIRO
# 10/5. QE_I02_BRANCA
# 11/6. QE_I05_NUM
# 12/7. QE_I17_PRIVADO
# 13/8. QE_I08_NUM
# modelos com curso
# 14. administracao
# 15. direito
# 16. medicina
# 17. pedagogia
# 18. ciencias da computacao

# alpha_j:
# alpha_j_1: CO_REGIAO_CURSO => 1=N, 2=NE, 3=SE, 4=S, 5=CO
# alpha_j_2: CO_CATEGAD_PRIVADA => 1=PUBLICA, 2=PRIVADA
