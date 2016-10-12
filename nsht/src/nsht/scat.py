import time
import os
import cProfile

import numpy as np
import scipy.io as sio

from nsht import config
from nsht.transform import SHTransform, nsht_theta_extended

def read_filters(L):
    filename = os.path.join(config.LOCAL_RESOURCE_DIR, 'ScatFilters_L{}.mat'.format(L))
    filters = sio.loadmat(filename)['ScatFilters']
    filters = [np.array(layer_filter[0]) for layer_filter in filters]
    return filters

def scat(flm, filters, t):
    moments = []
    layers = []
    zero_layer = []
    zero_layer.append({'scat_coeffs' : flm, 'curr' : 0, 'prev' : -1})
    layers.append(zero_layer)  # zero layer
    for n_layer, layer_filter  in enumerate(filters):
        num_filters = layer_filter.shape[0]
        curr_layer = []
        for i in xrange(num_filters):
            curr_filter = layer_filter[i, :].T
            for j, prev_layer in enumerate(layers[n_layer]):
                f = np.abs(t.inverse_fltr_aprox(prev_layer['scat_coeffs'], curr_filter))
                scat_coeffs = t.forward(f)
                curr_layer.append({'scat_coeffs' : scat_coeffs, 'curr' : i, 'prev' : j})
                moments.append(np.abs(np.linalg.norm(scat_coeffs)))
        layers.append(curr_layer)

    return moments, layers



class Main(object):
    L = 64

    def __init__(self):
        global t
        t = SHTransform(Main.L)
        global theta_extended
        theta_extended = nsht_theta_extended(t._theta)
        global filters
        filters = read_filters(Main.L)

        mnist5_orig = sio.loadmat(os.path.join(config.LOCAL_RESOURCE_DIR, 'mnist5.mat'))['mnist5_sphr']
        global mnist5_flm
        mnist5_flm = t.forward(mnist5_orig)

        cProfile.run("scat(mnist5_flm, filters, t)")

if __name__ == "__main__":
    Main()



