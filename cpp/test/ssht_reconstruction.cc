#include <gtest/gtest.h>

#include <iterator>
#include <random>
#include <vector>

#include <boost/filesystem.hpp>

#include <dlm/l2.h>

#include <ssht/transform.h>

template <typename Transform>
void test_signal_reconstruction(size_t L) {
	Transform t(L);
    std::vector<double>   orig(t.num_samples(), 0);
    std::vector<double> recon1(t.num_samples(), 0);
    std::vector<double> recon2(t.num_samples(), 0);
    std::vector<std::complex<double>> coeffs(t.num_coeffs());
    std::vector<std::complex<double>> coeffs_recon(t.num_coeffs());

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<> dis(0, 1);

    boost::generate(orig, [&] () { return dis(gen); });
    t.forward(orig, coeffs.begin());
    t.inverse(coeffs, recon1.begin());
    t.forward(recon1, coeffs_recon.begin());
    t.inverse(coeffs_recon, recon2.begin());

    std::cout << "Forward first error = " << dlm::l2_error(orig, recon1) << std::endl;
    using namespace boost::adaptors;
    boost::copy(orig | sliced(0,10), std::ostream_iterator<double>(std::cout, ",")); std::cout << std::endl;
    boost::copy(recon1 | sliced(0, 10), std::ostream_iterator<double>(std::cout, ",")); std::cout << std::endl;
    std::cout << "Inverse first error = " << dlm::l2_error(coeffs, coeffs_recon) << std::endl;
    std::cout << "Forward first error = " << dlm::l2_error(recon1, recon2) << std::endl;

    std::cout << "Original norm = " << dlm::l2_norm(orig) << std::endl;
    std::cout << "Recon1 norm = " << dlm::l2_norm(recon1) << std::endl;
    std::cout << "Recon2 norm = " << dlm::l2_norm(recon2) << std::endl;
    std::cout << "Coeffs norm = " << dlm::l2_norm(coeffs) << std::endl;
    std::cout << "Coeffs_recon norm = " << dlm::l2_norm(coeffs_recon) << std::endl;
}

template <typename Transform>
void test_coeff_reconstruction(size_t L) {
	Transform t(L);
    std::vector<double>   signal(t.num_samples());
    std::vector<double>   signal_recon(t.num_samples());
    std::vector<std::complex<double>> coeffs(t.num_coeffs());
    std::vector<std::complex<double>> coeffs_recon(t.num_coeffs());

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<> dis(-10, 300);

    for(size_t el = 0; el < L; ++el) {
        for (int m = 0; m <= static_cast<int>(el); ++m) {
            std::complex<double> v(dis(gen), (m !=0 ) * dis(gen));
            int i, i_neg;
            ssht_sampling_elm2ind(&i, el, m);
            ssht_sampling_elm2ind(&i_neg, el, -m);
            coeffs[i] = v;
            coeffs[i_neg] = std::pow(-1, m) * conj(v);
        }
    }

    t.inverse(coeffs, signal.begin());
    t.forward(signal, coeffs_recon.begin());
    t.inverse(coeffs_recon, signal_recon.begin());

    using namespace boost::adaptors;
    boost::copy(coeffs | sliced(0,10), std::ostream_iterator<std::complex<double>>(std::cout, ",")); std::cout << std::endl;
    boost::copy(coeffs_recon | sliced(0, 10), std::ostream_iterator<std::complex<double>>(std::cout, ",")); std::cout << std::endl;
    boost::copy(signal | sliced(0,10), std::ostream_iterator<double>(std::cout, ",")); std::cout << std::endl;
    std::cout << "Reconstruction error = " << dlm::l2_error(coeffs, coeffs_recon) << std::endl;
    std::cout << "Signal     error = " << dlm::l2_error(signal, signal_recon) << std::endl;
    std::cout << "Signal norm = " << dlm::l2_norm(signal) << std::endl;
    std::cout << "Coeffs norm = " << dlm::l2_norm(coeffs) << std::endl;
    std::cout << "Coeffs_recon norm = " << dlm::l2_norm(coeffs_recon) << std::endl;
}

static constexpr size_t L = 64;
TEST(Transform, ssht_mw) { test_signal_reconstruction<ssht::MWTransform>(L); }
TEST(Transform, ssht_mw_inverse) { test_coeff_reconstruction<ssht::MWTransform>(L); }
TEST(Transform, ssht_dl) { test_signal_reconstruction<ssht::DHTransform>(L); }
TEST(Transform, ssht_dl_inverse) { test_coeff_reconstruction<ssht::DHTransform>(L); }
