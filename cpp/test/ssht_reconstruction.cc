#include <iostream>
#include <vector>
#include <valarray>
#include <algorithm>
#include <numeric>
#include <cmath>
#include <random>
#include <sys/time.h>

extern "C" {
#include <ssht.h>
}

int main() {
    size_t L = 64;
    size_t NSAMPLES = L * (2 * L - 1);
    int verbosity = 1;

    std::vector<double> f(NSAMPLES);
    std::vector<double> recon(NSAMPLES);
    std::vector<_Complex double> coeffs(L * L);

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<> dis(-1, 1);

    f[100] = 1;
//    std::generate_n(coeffs.begin(), L * L, [&] () { return dis(gen); });
//    double s = std::accumulate(f.begin(), f.end(), 0) / f.size();
//    std::transform(f.begin(), f.end(), f.begin(), [s] (const auto& v) { return v - s; });
//    ssht_test_gen_flm_real(coeffs.data(), L, 0);
//    std::generate_n(coeffs.begin(), coeffs.size(), rand);
//    for(size_t i = 0; i < NSAMPLES; ++i) {
////    	f[i]= rand() ;
//    	std::cout << creal(f[i]) << " " ;
//    } std::cout << std::endl;

//    ssht_core_mw_forward_sov_conv_sym_real(coeffs.data(), f.data(), L, SSHT_DL_RISBO, verbosity);
//    ssht_core_mw_inverse_sov_sym_real(recon.data(), coeffs.data(), L, SSHT_DL_RISBO, verbosity);

    ssht_core_dh_forward_sov_real(coeffs.data(), f.data(), L, verbosity);
    ssht_core_dh_inverse_sov_real(recon.data(), coeffs.data(), L, verbosity);

    double err = 0;
    double fnorm = 0;
    for(size_t i = 0; i < NSAMPLES; ++i) {
    	std::cout << creal(f[i]) << " " << creal(recon[i]) << std::endl;
    	err += pow(cabs(f[i] - recon[i]), 2);
    	fnorm += pow(cabs(f[i]), 2);
    }
    std::cout << "Error = " << sqrt(err/ fnorm) << std::endl;
    return 0;
}
