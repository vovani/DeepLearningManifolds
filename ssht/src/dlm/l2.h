/*
 * l2.h
 *
 *  Created on: Sep 16, 2016
 *      Author: vovain
 */

#pragma once

#include <cmath>

#include <boost/range/combine.hpp>
#include <boost/range/adaptors.hpp>
#include <boost/range/numeric.hpp>

namespace dlm {

template <typename Range>
double l2_norm(const Range& a) {
	auto v_l2 = [] (const auto& v) { return std::pow(std::abs(v), 2); };
	return std::sqrt(boost::accumulate(a | boost::adaptors::transformed(v_l2), double(0)));
}

template <typename Range>
double l2_diff(const Range& a, const Range& b) {
	auto diff = [] (const auto& p) {
		return std::abs(p.template get<0>() - p.template get<1>());
	};
	return l2_norm(boost::combine(a, b) | boost::adaptors::transformed(diff));
}

template <typename Range>
double l2_error(const Range& a, const Range& b) {
	return l2_diff(a, b) / l2_norm(a);
}

} /* namespace dlm */
