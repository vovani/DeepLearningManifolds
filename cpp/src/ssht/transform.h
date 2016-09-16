/*
 * transform.h
 *
 *  Created on: Sep 16, 2016
 *      Author: vovain
 */

#pragma once

#include <complex>
#include <vector>
#include <cstddef>
#include <stdexcept>

#include <boost/range/adaptors.hpp>
#include <boost/range/algorithm.hpp>

extern "C" {
#include <ssht.h>
}

namespace ssht {

static constexpr size_t VERBOSE = 0;

template <typename Policy>
class Transform {
public:
	Transform(size_t L) : m_L(L) {}

	size_t num_samples() const { return Policy::num_samples(m_L); }
	size_t num_coeffs() const { return m_L * m_L; }

	template <typename Seq, typename OutputIt>
	void forward(const Seq& signal, OutputIt out) {
		if (signal.size() != num_samples()) { throw std::runtime_error("Wrong signal length"); }
		std::vector<_Complex double> ccoeffs(num_coeffs());
		Policy::forward(ccoeffs.data(), signal.data(), m_L);
		auto f = [] (const auto& c) { return *reinterpret_cast<const std::complex<double>*>(&c); };
		boost::copy(ccoeffs | boost::adaptors::transformed(f), out);
	}

	template <typename Seq, typename OutputIt>
	void inverse(const Seq& coeffs, OutputIt out) {
		if (coeffs.size() != num_coeffs()) { throw std::runtime_error("Wrong coeffs length"); }
		std::vector<double> csignal(num_samples());
		Policy::inverse(csignal.data(), reinterpret_cast<const _Complex double*>(coeffs.data()), m_L);
		boost::copy(csignal, out);
	}

private:
	size_t m_L;
};

struct MWPolicy {
	static size_t num_samples(size_t L) { return L * ( 2 * L - 1); }
	static void forward(_Complex double* coeffs, const double* signal, size_t L) {
		ssht_core_mw_forward_sov_conv_sym_real(coeffs, signal, L, SSHT_DL_TRAPANI, VERBOSE);
	}
	static void inverse(double* signal, const _Complex double* coeffs, size_t L) {
		ssht_core_mw_inverse_sov_sym_real(signal, coeffs, L, SSHT_DL_TRAPANI, VERBOSE);
	}
};

struct DLPolicy {
	static size_t num_samples(size_t L) { return 2 * L * ( 2 * L - 1); }
	static void forward(_Complex double* coeffs, const double* signal, size_t L) {
		ssht_core_dh_forward_sov_real(coeffs, signal, L, VERBOSE);
	}
	static void inverse(double* signal, const _Complex double* coeffs, size_t L) {
		ssht_core_dh_inverse_sov_real(signal, coeffs, L, VERBOSE);
	}
};

using MWTransform = Transform<MWPolicy>;
using DLTransform = Transform<DLPolicy>;

} /* namespace ssht */



