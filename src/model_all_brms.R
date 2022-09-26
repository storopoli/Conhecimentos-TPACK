library(cmdstanr)
library(brms)
library(posterior)
library(arrow)
library(dplyr)
library(magrittr)
library(jsonlite)

# Data
df <- read_feather("data/data.arrow")

# Moderations
df %<>% mutate(
  tech = QE_I58,
  content = QE_I57,
  pedag = QE_I29,
  co_grupo = case_when(
    CO_GRUPO == 1 ~ 1, # adm
    CO_GRUPO == 2 ~ 2, # direito
    CO_GRUPO == 12 ~ 3, # medicina
    CO_GRUPO == 2001 ~ 4, # pedagogia
    CO_GRUPO == 4004 ~ 5, # computacao
  )
)

# brms formula
form <- bf(NT_GER ~ 1
  # group levels
  + (0 + tech * pedag * content | co_grupo)
  + (0 + tech * pedag * content | CO_CATEGAD_PRIVADA)
  # controles
  + NU_IDADE + TP_SEXO_MASC + QE_I01_SOLTEIRO + QE_I02_BRANCA + QE_I05_NUM
  + QE_I17_PRIVADO + QE_I08_NUM + CO_REGIAO_CURSO)

mean_NT_GER <- mean(df$NT_GER) # 45.10
sd_NT_GER <- sd(df$NT_GER) # 14 * 2.5 = 35

# priors
custom_priors <- c(
  set_prior("student_t(3, 0, 2.5)", class = "b"),
  set_prior("student_t(3, 45.1, 35)", class = "Intercept"),
  set_prior("cauchy(0, 2)", class = "sd"),
  set_prior("exponential(1)", class = "sigma")
)

fit_all <- brm(form,
  data = df,
  family = gaussian(),
  prior = custom_priors,
  backend = "cmdstanr",
  normalize = FALSE,
  threads = threading(threads = parallel::detectCores()),
  output_dir = file.path("chains", "model_all"),
  cores = 4,
  chains = 4,
  iter = 2000
)

# save model
make_stancode(
  form,
  data = df,
  family = gaussian(),
  prior = custom_priors,
  normalize = FALSE,
  threads = threading(threads = parallel::detectCores() / 4),
  cores = 4,
  chains = 4,
  iter = 2000) %>% writeLines(file.path("src", "model_all_brms.stan"))

# save data
make_standata(
  form,
  data = df,
  family = gaussian(),
  prior = custom_priors,
  normalize = FALSE,
  threads = threading(threads = parallel::detectCores() / 4),
  cores = 4,
  chains = 4,
  iter = 2000
) %>% saveRDS(file.path("data", "stan", "model_all_brms.rds"))

make_standata(
  form,
  data = df,
  family = gaussian(),
  prior = custom_priors,
  normalize = FALSE,
  threads = threading(threads = parallel::detectCores() / 4),
  cores = 4,
  chains = 4,
  iter = 2000
) %>% toJSON(pretty = TRUE, auto_unbox = TRUE) %>% 
  write(file.path("data", "stan", "model_all_brms.json"))

# save results
(draws_fit <- as_draws_array(fit_all))
fit_summary <- summarize_draws(draws_fit)
fit_summary %>% write.csv("results/all/results_brms.csv")
