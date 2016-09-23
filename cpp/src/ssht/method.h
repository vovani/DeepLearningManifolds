/*
 * methods.h
 *
 *  Created on: Sep 20, 2016
 *      Author: vovain
 */

#pragma once

extern "C" {
#include <ssht.h>
#undef I
}

namespace ssht {
namespace detail {

static constexpr size_t VERBOSE = 0;

struct MWMethod {
    static size_t num_samples(size_t L) { return ssht_sampling_mw_n(L); }

    static std::vector<std::pair<double, double>> sampling_points(size_t L) {
        std::vector<std::pair<double, double>> rv;
        for(size_t theta = 0; theta <= ssht_sampling_mw_ntheta(L); ++theta) {
            for(size_t phi = 0; phi <= ssht_sampling_mw_nphi(L); ++phi) {
                rv.push_back({ssht_sampling_mw_t2theta(theta, L), ssht_sampling_mw_p2phi(phi, L)});
            }
        }
        return rv;
    }

    static void forward(_Complex double* coeffs, const double* signal, size_t L) {
        ssht_core_mw_forward_sov_conv_sym_real(coeffs, signal, L, SSHT_DL_TRAPANI, VERBOSE);
    }
    static void inverse(double* signal, const _Complex double* coeffs, size_t L) {
        ssht_core_mw_inverse_sov_sym_real(signal, coeffs, L, SSHT_DL_TRAPANI, VERBOSE);
    }
};

struct DHMethod {
    static size_t num_samples(size_t L) { return ssht_sampling_dh_n(L); }

    static std::vector<std::pair<double, double>> sampling_points(size_t L) {
        std::vector<std::pair<double, double>> rv;
        for(size_t theta = 0; theta <= ssht_sampling_dh_ntheta(L); ++theta) {
            for(size_t phi = 0; phi <= ssht_sampling_dh_nphi(L); ++phi) {
                rv.push_back({ssht_sampling_dh_t2theta(theta, L), ssht_sampling_dh_p2phi(phi, L)});
            }
        }
        return rv;
    }

    static void forward(_Complex double* coeffs, const double* signal, size_t L) {
        ssht_core_dh_forward_sov_real(coeffs, signal, L, VERBOSE);
    }
    static void inverse(double* signal, const _Complex double* coeffs, size_t L) {
        ssht_core_dh_inverse_sov_real(signal, coeffs, L, VERBOSE);
    }
};

}  // namespace detail
}  // namespace ssht

