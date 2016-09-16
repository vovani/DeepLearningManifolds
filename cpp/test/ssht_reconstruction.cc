#include <iostream>
#include <vector>
#include <algorithm>
#include <numeric>
#include <cmath>
#include <iterator>
#include <random>

#include <boost/range/algorithm.hpp>
#include <boost/range/numeric.hpp>
#include <boost/range/adaptors.hpp>
#include <boost/range/combine.hpp>

extern "C" {
#include <ssht.h>
}

namespace dlm {

double abs(_Complex double n) {	return cabs(n); }

template <typename Range>
double l2_norm(const Range& a) {
	auto v_l2 = [] (const auto& v) { return std::pow(abs(v), 2); };
	return std::sqrt(boost::accumulate(a | boost::adaptors::transformed(v_l2), double(0)));
}

template <typename Range>
double l2_diff(const Range& a, const Range& b) {
	auto diff = [] (const auto& p) {
		return abs(p.template get<0>() - p.template get<1>());
	};
	return l2_norm(boost::combine(a, b) | boost::adaptors::transformed(diff)) / l2_norm(a);
}

} /* namespace dlm */

int main() {
    size_t L = 64;
    size_t NSAMPLES = 2 * L * (2 * L - 1);
    int verbosity = 1;

    std::vector<double> orig(NSAMPLES);
    std::vector<double> recon1(NSAMPLES);
    std::vector<double> recon2(NSAMPLES);
    std::vector<_Complex double> coeffs(L * L);
    std::vector<_Complex double> coeffs_recon(L * L);

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<> dis(0, 1);

    boost::generate(orig, [&] () { return dis(gen); });

//    ssht_core_mw_forward_sov_conv_sym_real(coeffs.data(), f.data(), L, SSHT_DL_RISBO, verbosity);
//    ssht_core_mw_inverse_sov_sym_real(recon.data(), coeffs.data(), L, SSHT_DL_RISBO, verbosity);

    ssht_core_dh_forward_sov_real(coeffs.data(), orig.data(), L, verbosity);
    ssht_core_dh_inverse_sov_real(recon1.data(), coeffs.data(), L, verbosity);
    ssht_core_dh_forward_sov_real(coeffs_recon.data(), recon1.data(), L, verbosity);
    ssht_core_dh_inverse_sov_real(recon2.data(), coeffs_recon.data(), L, verbosity);

    using namespace boost::adaptors;
    std::cout << std::endl;
    std::cout << "Forward first error = " << dlm::l2_diff(orig, recon1) << std::endl;
    boost::copy(orig | sliced(0,25), std::ostream_iterator<double>(std::cout, ",")); std::cout << std::endl;
    boost::copy(recon1 | sliced(0, 25), std::ostream_iterator<double>(std::cout, ",")); std::cout << std::endl;
    std::cout << "Inverse first error = " << dlm::l2_diff(coeffs, coeffs_recon) << std::endl;
    std::cout << "Forward first error = " << dlm::l2_diff(recon1, recon2) << std::endl;

    std::cout << "Original norm = " << dlm::l2_norm(orig) << std::endl;
    std::cout << "Recon1 norm = " << dlm::l2_norm(recon1) << std::endl;
    std::cout << "Recon2 norm = " << dlm::l2_norm(recon2) << std::endl;
    return 0;
}
