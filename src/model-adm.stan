data {
  int<lower=1> N;                        // number of observations
  int<lower=1> K;                        // number of independent variables
  matrix[N, K] X;                        // data matrix
  vector[N] y;                           // dependent variable vector
  int<lower=2> J1;                       // number of groups (group 1)
  int<lower=2> J2;                       // number of groups (group 2)
  array[N] int<lower=1, upper=J1> idx1;   // group 1 membership
  array[N] int<lower=1, upper=J2> idx2;   // group 2 membership
  real mean_y;                           // mean y
  real std_y;                            // std y
}
parameters {
  real alpha;                            // intercept
  vector[K] beta;                        // coefficients for independent variables
  real<lower=0> sigma;                   // model error
  real<lower=0> tau_1;                   // group-level SD intercepts (group 1)
  vector[J1] z_1;                         // group-level non-centered intercepts (group 1)
  real<lower=0> tau_2;                   // group-level SD intercepts (group 2)
  vector[J2] z_2;                         // group-level non-centered intercepts (group 2)
}
transformed parameters {
  vector[J1] alpha_j_1 = z_1 * tau_1;     // group-level intercepts (group 1)
  vector[J2] alpha_j_2 = z_2 * tau_2;     // group-level intercepts (group 2)
}
model {
  // priors
  alpha ~ student_t(3, mean_y, 2.5 * std_y);
  beta ~ student_t(3, 0, 2.5);
  sigma ~ exponential(1);
  tau_1 ~ cauchy(0, 2);
  z_1 ~ normal(0, 1);
  tau_2 ~ cauchy(0, 2);
  z_2 ~ normal(0, 1);

  // likelihood
  y ~ normal(alpha + alpha_j_1[idx1] + alpha_j_2[idx2] + X * beta, sigma);
}
