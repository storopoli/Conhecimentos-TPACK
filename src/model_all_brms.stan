// generated with brms 2.19.0
functions {
 /* compute correlated group-level effects
  * Args:
  *   z: matrix of unscaled group-level effects
  *   SD: vector of standard deviation parameters
  *   L: cholesky factor correlation matrix
  * Returns:
  *   matrix of scaled group-level effects
  */
  matrix scale_r_cor(matrix z, vector SD, matrix L) {
    // r is stored in another dimension order than z
    return transpose(diag_pre_multiply(SD, L) * z);
  }
  /* integer sequence of values
   * Args:
   *   start: starting integer
   *   end: ending integer
   * Returns:
   *   an integer sequence from start to end
   */
  int[] sequence(int start, int end) {
    int seq[end - start + 1];
    for (n in 1:num_elements(seq)) {
      seq[n] = n + start - 1;
    }
    return seq;
  }
  // compute partial sums of the log-likelihood
  real partial_log_lik_lpmf(int[] seq, int start, int end, data vector Y, data matrix Xc, vector b, real Intercept, real sigma, data int[] J_1, data vector Z_1_1, data vector Z_1_2, data vector Z_1_3, data vector Z_1_4, data vector Z_1_5, data vector Z_1_6, data vector Z_1_7, vector r_1_1, vector r_1_2, vector r_1_3, vector r_1_4, vector r_1_5, vector r_1_6, vector r_1_7, data int[] J_2, data vector Z_2_1, data vector Z_2_2, data vector Z_2_3, data vector Z_2_4, data vector Z_2_5, data vector Z_2_6, data vector Z_2_7, vector r_2_1, vector r_2_2, vector r_2_3, vector r_2_4, vector r_2_5, vector r_2_6, vector r_2_7) {
    real ptarget = 0;
    int N = end - start + 1;
    // initialize linear predictor term
    vector[N] mu = rep_vector(0.0, N);
    mu += Intercept;
    for (n in 1:N) {
      // add more terms to the linear predictor
      int nn = n + start - 1;
      mu[n] += r_1_1[J_1[nn]] * Z_1_1[nn] + r_1_2[J_1[nn]] * Z_1_2[nn] + r_1_3[J_1[nn]] * Z_1_3[nn] + r_1_4[J_1[nn]] * Z_1_4[nn] + r_1_5[J_1[nn]] * Z_1_5[nn] + r_1_6[J_1[nn]] * Z_1_6[nn] + r_1_7[J_1[nn]] * Z_1_7[nn] + r_2_1[J_2[nn]] * Z_2_1[nn] + r_2_2[J_2[nn]] * Z_2_2[nn] + r_2_3[J_2[nn]] * Z_2_3[nn] + r_2_4[J_2[nn]] * Z_2_4[nn] + r_2_5[J_2[nn]] * Z_2_5[nn] + r_2_6[J_2[nn]] * Z_2_6[nn] + r_2_7[J_2[nn]] * Z_2_7[nn];
    }
    ptarget += normal_id_glm_lupdf(Y[start:end] | Xc[start:end], mu, b, sigma);
    return ptarget;
  }
}
data {
  int<lower=1> N;  // total number of observations
  vector[N] Y;  // response variable
  int<lower=1> K;  // number of population-level effects
  matrix[N, K] X;  // population-level design matrix
  int grainsize;  // grainsize for threading
  // data for group-level effects of ID 1
  int<lower=1> N_1;  // number of grouping levels
  int<lower=1> M_1;  // number of coefficients per level
  int<lower=1> J_1[N];  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_1_1;
  vector[N] Z_1_2;
  vector[N] Z_1_3;
  vector[N] Z_1_4;
  vector[N] Z_1_5;
  vector[N] Z_1_6;
  vector[N] Z_1_7;
  int<lower=1> NC_1;  // number of group-level correlations
  // data for group-level effects of ID 2
  int<lower=1> N_2;  // number of grouping levels
  int<lower=1> M_2;  // number of coefficients per level
  int<lower=1> J_2[N];  // grouping indicator per observation
  // group-level predictor values
  vector[N] Z_2_1;
  vector[N] Z_2_2;
  vector[N] Z_2_3;
  vector[N] Z_2_4;
  vector[N] Z_2_5;
  vector[N] Z_2_6;
  vector[N] Z_2_7;
  int<lower=1> NC_2;  // number of group-level correlations
  int prior_only;  // should the likelihood be ignored?
}
transformed data {
  int Kc = K - 1;
  matrix[N, Kc] Xc;  // centered version of X without an intercept
  vector[Kc] means_X;  // column means of X before centering
  int seq[N] = sequence(1, N);
  for (i in 2:K) {
    means_X[i - 1] = mean(X[, i]);
    Xc[, i - 1] = X[, i] - means_X[i - 1];
  }
}
parameters {
  vector[Kc] b;  // population-level effects
  real Intercept;  // temporary intercept for centered predictors
  real<lower=0> sigma;  // dispersion parameter
  vector<lower=0>[M_1] sd_1;  // group-level standard deviations
  matrix[M_1, N_1] z_1;  // standardized group-level effects
  cholesky_factor_corr[M_1] L_1;  // cholesky factor of correlation matrix
  vector<lower=0>[M_2] sd_2;  // group-level standard deviations
  matrix[M_2, N_2] z_2;  // standardized group-level effects
  cholesky_factor_corr[M_2] L_2;  // cholesky factor of correlation matrix
}
transformed parameters {
  matrix[N_1, M_1] r_1;  // actual group-level effects
  // using vectors speeds up indexing in loops
  vector[N_1] r_1_1;
  vector[N_1] r_1_2;
  vector[N_1] r_1_3;
  vector[N_1] r_1_4;
  vector[N_1] r_1_5;
  vector[N_1] r_1_6;
  vector[N_1] r_1_7;
  matrix[N_2, M_2] r_2;  // actual group-level effects
  // using vectors speeds up indexing in loops
  vector[N_2] r_2_1;
  vector[N_2] r_2_2;
  vector[N_2] r_2_3;
  vector[N_2] r_2_4;
  vector[N_2] r_2_5;
  vector[N_2] r_2_6;
  vector[N_2] r_2_7;
  // compute actual group-level effects
  r_1 = scale_r_cor(z_1, sd_1, L_1);
  r_1_1 = r_1[, 1];
  r_1_2 = r_1[, 2];
  r_1_3 = r_1[, 3];
  r_1_4 = r_1[, 4];
  r_1_5 = r_1[, 5];
  r_1_6 = r_1[, 6];
  r_1_7 = r_1[, 7];
  // compute actual group-level effects
  r_2 = scale_r_cor(z_2, sd_2, L_2);
  r_2_1 = r_2[, 1];
  r_2_2 = r_2[, 2];
  r_2_3 = r_2[, 3];
  r_2_4 = r_2[, 4];
  r_2_5 = r_2[, 5];
  r_2_6 = r_2[, 6];
  r_2_7 = r_2[, 7];
}
model {
  real lprior = 0;  // prior contributions to the log posterior
  // likelihood not including constants
  if (!prior_only) {
    target += reduce_sum(partial_log_lik_lpmf, seq, grainsize, Y, Xc, b, Intercept, sigma, J_1, Z_1_1, Z_1_2, Z_1_3, Z_1_4, Z_1_5, Z_1_6, Z_1_7, r_1_1, r_1_2, r_1_3, r_1_4, r_1_5, r_1_6, r_1_7, J_2, Z_2_1, Z_2_2, Z_2_3, Z_2_4, Z_2_5, Z_2_6, Z_2_7, r_2_1, r_2_2, r_2_3, r_2_4, r_2_5, r_2_6, r_2_7);
  }
  // priors not including constants
  lprior += student_t_lupdf(b | 3, 0, 2.5);
  lprior += student_t_lupdf(Intercept | 3, 45.1, 35);
  lprior += exponential_lupdf(sigma | 1);
  lprior += cauchy_lupdf(sd_1 | 0, 2);
  lprior += lkj_corr_cholesky_lupdf(L_1 | 1);
  lprior += cauchy_lupdf(sd_2 | 0, 2);
  lprior += lkj_corr_cholesky_lupdf(L_2 | 1);
  target += lprior;
  target += std_normal_lupdf(to_vector(z_1));
  target += std_normal_lupdf(to_vector(z_2));
}
generated quantities {
  // actual population-level intercept
  real b_Intercept = Intercept - dot_product(means_X, b);
  // compute group-level correlations
  corr_matrix[M_1] Cor_1 = multiply_lower_tri_self_transpose(L_1);
  vector<lower=-1,upper=1>[NC_1] cor_1;
  // compute group-level correlations
  corr_matrix[M_2] Cor_2 = multiply_lower_tri_self_transpose(L_2);
  vector<lower=-1,upper=1>[NC_2] cor_2;
  // extract upper diagonal of correlation matrix
  for (k in 1:M_1) {
    for (j in 1:(k - 1)) {
      cor_1[choose(k - 1, 2) + j] = Cor_1[j, k];
    }
  }
  // extract upper diagonal of correlation matrix
  for (k in 1:M_2) {
    for (j in 1:(k - 1)) {
      cor_2[choose(k - 1, 2) + j] = Cor_2[j, k];
    }
  }
}

