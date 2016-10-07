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

#include <boost/format.hpp>
#include <boost/range/adaptors.hpp>
#include <boost/range/algorithm.hpp>

#include "method.h"

namespace ssht {

static constexpr size_t VERBOSE = 0;

namespace detail {

template <typename Method>
class Transform {
public:
    Transform(size_t L) : L_(L) {}

    size_t num_samples() const { return Method::num_samples(L_); }
    size_t num_coeffs() const { return L_ * L_; }

    std::vector<std::pair<double, double>> sampling_points() const {
        return Method::sampling_points(L_);
    }

    template <typename Seq, typename OutputIt>
    void forward(const Seq& signal, OutputIt out) const {
        if (signal.size() != num_samples()) {
            throw std::runtime_error((boost::format("Wrong signal length. Expected %d, got %d.") % num_samples() % signal.size()).str());
        }
        std::vector<_Complex double> ccoeffs(num_coeffs());
        Method::forward(ccoeffs.data(), signal.data(), L_);
        auto f = [] (const auto& c) { return *reinterpret_cast<const std::complex<double>*>(&c); };
        boost::copy(ccoeffs | boost::adaptors::transformed(f), out);
    }

    template <typename Seq, typename OutputIt>
    void inverse(const Seq& coeffs, OutputIt out) const {
        if (coeffs.size() != num_coeffs()) {
            throw std::runtime_error((boost::format("Wrong coeffs length. Expected %d, got %d.") % num_coeffs() % coeffs.size()).str());
        }
        std::vector<double> csignal(num_samples());
        Method::inverse(csignal.data(), reinterpret_cast<const _Complex double*>(coeffs.data()), L_);
        boost::copy(csignal, out);
    }

private:
    size_t L_;
};

} /* namespace detail */

typedef detail::Transform<detail::MWMethod> MWTransform;
typedef detail::Transform<detail::DHMethod> DHTransform;

} /* namespace ssht */



