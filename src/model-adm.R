library(cmdstanr)
library(arrow)
library(dplyr)

# Data
df <- read_arrow("data/adm_only.arrow")

# Stan model
m <- cmdstan_model("src/model-adm.stan")

# Stan data for different y
stan_data_ger <- list(
    X = df %>% select(-NT_GER, -NT_FG, -NT_CE, -CO_REGIAO_CURSO, -CO_CATEGAD_PRIVADA) %>% as.matrix,
    y = df$NT_GER,
    N = df %>% nrow,
    K = df %>% select(-NT_GER, -NT_FG, -NT_CE, -CO_REGIAO_CURSO, -CO_CATEGAD_PRIVADA) %>% ncol,
    J1 = df$CO_REGIAO_CURSO %>% unique %>% length,
    J2 = df$CO_CATEGAD_PRIVADA %>% unique %>% length,
    idx1 = df$CO_REGIAO_CURSO,
    idx2 = df$CO_CATEGAD_PRIVADA + 1,
    mean_y = df$NT_GER %>% mean,
    std_y = df$NT_GER %>% sd
)

stan_data_fg <- list(
    X = df %>% select(-NT_GER, -NT_FG, -NT_CE, -CO_REGIAO_CURSO, -CO_CATEGAD_PRIVADA) %>% as.matrix,
    y = df$NT_FG,
    N = df %>% nrow,
    K = df %>% select(-NT_GER, -NT_FG, -NT_CE, -CO_REGIAO_CURSO, -CO_CATEGAD_PRIVADA) %>% ncol,
    J1 = df$CO_REGIAO_CURSO %>% unique %>% length,
    J2 = df$CO_CATEGAD_PRIVADA %>% unique %>% length,
    idx1 = df$CO_REGIAO_CURSO,
    idx2 = df$CO_CATEGAD_PRIVADA + 1,
    mean_y = df$NT_GER %>% mean,
    std_y = df$NT_GER %>% sd
)

stan_data_ce <- list(
    X = df %>% select(-NT_GER, -NT_FG, -NT_CE, -CO_REGIAO_CURSO, -CO_CATEGAD_PRIVADA) %>% as.matrix,
    y = df$NT_CE,
    N = df %>% nrow,
    K = df %>% select(-NT_GER, -NT_FG, -NT_CE, -CO_REGIAO_CURSO, -CO_CATEGAD_PRIVADA) %>% ncol,
    J1 = df$CO_REGIAO_CURSO %>% unique %>% length,
    J2 = df$CO_CATEGAD_PRIVADA %>% unique %>% length,
    idx1 = df$CO_REGIAO_CURSO,
    idx2 = df$CO_CATEGAD_PRIVADA + 1,
    mean_y = df$NT_GER %>% mean,
    std_y = df$NT_GER %>% sd
)

# fit the models
fit_ger <- m$sample(data=stan_data_ger, parallel_chains=4)
fit_fg <- m$sample(data=stan_data_fg, parallel_chains=4)
fit_ce <- m$sample(data=stan_data_ce, parallel_chains=4)

# save results
fit_ger$summary() %>% write.csv("results/stan_ger.csv")
fit_fg$summary() %>% write.csv("results/stan_fg.csv")
fit_ce$summary() %>% write.csv("results/stan_ce.csv")
# beta:
# 1. QE_I58
# 2. QE_I29
# 3. QE_I57
# 4. NU_IDADE
# 5. TP_SEXO_MASC
# 6. QE_I02_BRANCA
# 7. QE_I17_PRIVADO

# alpha_j:
# alpha_j_1: CO_REGIAO_CURSO => 1=NORTE, 2=NORDESTE, 3=SUDESTE, 4=SUL, 5=CENTRO-OESTE
# alpha_j_2: CO_CATEGAD_PRIVADA => 1=PUBLICA, 2=PRIVADA
