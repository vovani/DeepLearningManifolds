%module dlm

%{
#include <complex>
#include <iterator>

#include <ssht/transform.h>
#include <dlm/l2.h>
%}

%include <std_complex.i>
%include <std_pair.i>
%include <std_vector.i>
%include <std_except.i>

%include <ssht/transform.h>

%template(point) std::pair<double, double>;
%template(complexVec) std::vector<std::complex<double>>;
%template(pointsVec) std::vector<std::pair<double,double>>;
%template(doubleVec) std::vector<double>;

namespace ssht {
namespace detail {

%extend Transform {
    std::vector<std::complex<double>> forward(const std::vector<double>& signal) const {
        std::vector<std::complex<double>> rv;
        $self->forward(signal, std::back_inserter(rv));
        return rv;
    }
    
    std::vector<double> inverse(const std::vector<std::complex<double>>& coeffs) const {
        std::vector<double> rv;
        $self->inverse(coeffs, std::back_inserter(rv));
        return rv;
    }
}

%template(MWTransform) Transform<ssht::detail::MWMethod>;

}
}

