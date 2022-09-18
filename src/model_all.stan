data {
  int<lower=1> N;                        // number of observations
  int<lower=1> K;                        // number of independent variables
  matrix[N, K] X;                        // data matrix
  vector[N] y;                           // dependent variable vector
  int<lower=2> J1;                       // number of groups (group 1)
  // int<lower=2> J2;                       // number of groups (group 2)
  array[N] int<lower=0, upper=J1> idx1;  // group 1 membership
  // array[N] int<lower=1, upper=J2> idx2;  // group 2 membership
  real mean_y;                           // mean y
  real std_y;                            // std y
  int beta_i;                            // max index for the random slopes
}
parameters {
  real alpha;                           // intercept
  vector[K] beta;                       // coefficients for independent variables
  real<lower=0> sigma;                  // model error
  vector<lower=0>[J1] tau1;             // group-level SD slopes (group 1)
  matrix[beta_i, J1] Z1;                     // group-level non-centered slopes (group 1)
  // vector<lower=0>[J2] tau2;             // group-level SD slopes (group 2)
  // matrix[beta_i, J2] Z2;                     // group-level non-centered slopes (group 2)
}
transformed parameters {
  matrix[beta_i, J1] betaj1;                   // group-level slopes (group 1)
  for (j in 1:J1) betaj1[, j] = Z1[, j] * tau1[j];
  // matrix[beta_i, J2] betaj2;                   // group-level slopes (group 2)
  // for (j in 1:J2) betaj2[, j] = Z2[, j] * tau2[j];
}
model {
  // priors
  alpha ~ student_t(3, mean_y, 2.5 * std_y);
  beta ~ student_t(3, 0, 2.5);
  sigma ~ exponential(1);
  tau1 ~ cauchy(0, 2);
  to_vector(Z1) ~ normal(0, 1);
  // tau2 ~ cauchy(0, 2);
  // to_vector(Z2) ~ normal(0, 1);

  // likelihood
  y ~ normal(alpha
             + (X * beta)
             + (X[:, 1:beta_i] * betaj1 * tau1)
            //  + (X[:, 1:beta_i] * betaj2 * tau2)
             ,
             sigma);
}
