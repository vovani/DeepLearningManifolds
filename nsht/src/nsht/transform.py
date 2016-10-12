import math
import os
import numpy as np
import scipy.io as sio
import matplotlib.pyplot as plt

from  numpy import  matrix as npmtrx
from mpl_toolkits.mplot3d import Axes3D

from nsht import config

class SHTransform(object):
    @staticmethod
    def index_flm(el, m):
        return el**2 + el + m

    @staticmethod
    def index_el(el):
        return range(el**2, (el+1)**2, 1)

    @staticmethod
    def get_el_coeff(flm, el):
        index = SHTransform.index_el(el)
        return flm[index]

    @staticmethod
    def _fix_theta(theta):
        L = len(theta)
        theta_indecies = np.zeros([L ** 2, ], dtype=int)
        for i in range(L):
            theta_indecies[i ** 2:(i + 1) ** 2] = i
        theta_extended = np.array(theta)[theta_indecies]
        # theta_extended = theta_extended-0.5*np.pi
        return theta_extended

    def __init__(self, L):
        self.L = L
        P_mat = self._get_resource('Pmat_L')['P_mat']
        sampling_points = self._get_resource('nsht_sampling_points_L')

        self._P_mat = [np.array(item[0]) for item in P_mat]
        self._theta = SHTransform._fix_theta(np.array(sampling_points['theta'][0]))
        self._phi = np.array(sampling_points['phi'][0])
        self._phi_weights, self._phi_weights_neg = self._phi_weights()

    def sampling_points(self):
        return self._theta, self._phi

    def forward(self, f):
        f = f.reshape([self.L ** 2, 1])
        flm = np.zeros_like(f, dtype=complex)
        fft_v = np.zeros_like(f, dtype=complex)

        for m in range(self.L - 1, -1, -1):
            P_mat_t = self._P_mat[m][:(self.L - m), :]
            f_corr = f[m ** 2:(m + 1) ** 2]
            fft_v_bit = (np.fft.fft(f_corr, axis=0)) / len(f_corr)
            fft_v[m ** 2:(m + 1) ** 2] = fft_v_bit

            flm_t = self._inversion(P_mat_t, fft_v, m)

            f = self._spatial_elimination(P_mat_t, f[:m ** 2], flm_t, m)

            for el in range(m, self.L, 1):
                flm[el ** 2 + el + m, :] = flm_t[el - m, :]
                flm[el ** 2 + el - m, :] = ((-1) ** m) * np.conj(flm[el ** 2 + el + m, :])

        return flm.squeeze()

    def inverse(self, flm):
        filter = np.ones([self.L, 1], dtype = float)
        return self.inverse_filter_aprox(flm, filter)

    def inverse_filter_aprox(self, flm, filter):
        flm = flm.reshape([self.L**2, 1])
        filter = filter.reshape([self.L, 1])
        f = np.zeros_like(flm)
        supp = np.nonzero(filter[:,0]>1e-04)[0]
        L_max = supp[-1]+1

        for m in range(L_max):
            fm = np.zeros([L_max-m, 1],dtype = complex)
            fm_neg = np.zeros_like(fm)

            for el in range(m, L_max, 1):
                fm[el-m,:]=filter[el,:]*flm[el**2+el+m,:]
                fm_neg[el-m,:]=filter[el,:]*flm[el**2+el-m,:]

            P_mat_m = np.matrix(self._P_mat[m][:(L_max - m), :])
            gm = fm.T*P_mat_m
            gm_neg=(fm_neg.T*P_mat_m)
            gm_neg=((-1)**m)*gm_neg

            f_temp = np.zeros_like(f)
            f_temp_neg = np.zeros_like(f)

            for ii in xrange(self.L):
                f_temp[ii**2:(ii+1)**2,:]=gm[:,ii]
                f_temp_neg[ii ** 2:(ii + 1) ** 2, :] = gm_neg[:,ii]

            if (m==0):
                f+=f_temp
            else:
                phi_weights_m = np.matrix(self._phi_weights[m])
                phi_weights_neg_m = np.matrix(self._phi_weights_neg[m])
                f_w = np.multiply(f_temp, phi_weights_m.T)
                f_w_neg = np.multiply(f_temp_neg, phi_weights_neg_m.T)
                f_w = f_w+f_w_neg
                f+=f_w

        return f.squeeze()

    def _get_resource(self, resource):
        return sio.loadmat(os.path.join(config.LOCAL_RESOURCE_DIR, resource + '{}.mat'.format(self.L)))

    def _phi_weights(self):
        phi_weights = []
        phi_weights_neg = []
        for m in xrange(self.L):
            phi_weights.append(np.exp(1j * m * self._phi))
            phi_weights_neg.append(np.exp(-1j * m * self._phi))
        return phi_weights, phi_weights_neg

    def _inversion(self, P_mat_t, fft_v, m):
        b = np.zeros([self.L - m, 1], dtype = complex)
        for el in range(m, self.L, 1):
            b[el-m] = fft_v[m + el**2][0]
        P = P_mat_t[:, m:]
        flmt_t = np.linalg.lstsq(npmtrx.transpose(P),b)[0]
        return flmt_t

    def _spatial_elimination(self, P_mat_t, f_t, flm_t, m):
        P_mat = npmtrx.transpose(P_mat_t[:, :m])
        gm = np.dot(P_mat, flm_t)
        gm_neg = np.conj(gm)

        phi_weights = np.reshape(self._phi_weights[m][:m ** 2], [m ** 2, 1])
        phi_weights_neg =np.reshape(self._phi_weights_neg[m][:m ** 2], [m ** 2, 1])

        f_temp = np.zeros_like(phi_weights)
        f_temp_neg = np.zeros_like(phi_weights_neg)

        for ii in range(m):
            f_temp[ii**2 : (ii+1)**2, :] = gm[ii]
            f_temp_neg[ii ** 2 : (ii + 1) ** 2, :] = gm_neg[ii]

        f_temp= np.multiply(f_temp, phi_weights)
        f_temp_neg = np.multiply(f_temp_neg, phi_weights_neg)
        f_t = f_t - f_temp - f_temp_neg

        return f_t

def band_energy(flm, L):
    return np.array([np.linalg.norm(SHTransform.get_el_coeff(flm, el)) / (2 * el + 1) for el in range(L)])

def sph2cart(azimuth, elevation, r = 1.0):
    azimuth = np.array(azimuth).reshape(-1)
    elevation = np.array(elevation).reshape(-1)
    x = r * np.multiply(np.cos(elevation) ,np.cos(azimuth))
    y = r * np.multiply(np.cos(elevation) , np.sin(azimuth))
    z = r * np.sin(elevation)
    return x, y, z

