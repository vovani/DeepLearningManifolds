#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#include <ssht.h>

int main() {
    size_t L = 64;
    size_t NSAMPLES = L * L;
    int verbosity = 0;
    
    complex double* f = malloc(NSAMPLES * sizeof(complex double));
    double* coeffs = malloc((2 * L) * (2 * L - 1) * sizeof(double));
    complex double* recon = malloc(NSAMPLES * sizeof(complex double));

    f[100] = 1;
    f[101] = 1;
    f[102] = 1;
    ssht_core_dh_forward_sov_real(f, coeffs, L, verbosity);
    ssht_core_dh_inverse_sov_real(coeffs, recon, L, verbosity);

    double err = 0;
    for(size_t i = 0; i < NSAMPLES; ++i) {
        err += abs(f[i] - recon[i]);
    }

    printf("%f\n", err / NSAMPLES);
    return 0;
}
