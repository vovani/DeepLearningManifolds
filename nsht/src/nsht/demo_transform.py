import math
import os
import matplotlib.pyplot as plt
import numpy as np
import scipy.io as sio

from mpl_toolkits.mplot3d import Axes3D
from numpy import matrix as npmtrx

from nsht.transform import SHTransform, nsht_theta_extended, sph2cart
from nsht import config

L = 64
t = SHTransform(L)
theta_extended = nsht_theta_extended(t._theta)

f = np.random.rand(L**2,1)
flm = t.forward(f)
f_recon = t.inverse(flm)


mnist5_orig = sio.loadmat(os.path.join(config.LOCAL_RESOURCE_DIR, 'mnist5.mat'))
mnist5_orig = mnist5_orig['mnist5_sphr']
mnist5_flm = sio.loadmat('{0}mnist_flm.mat'.format(config.LOCAL_RESOURCE_DIR))
mnist5_flm = mnist5_flm['mnist5_flm']
mnist5_recon = sio.loadmat('{0}mnist_recon.mat'.format(config.LOCAL_RESOURCE_DIR))
mnist5_recon = mnist5_recon['mnist5_recon']

mnist5_flm_py = t.forward(mnist5_orig)
mnist5_recon_py = t.inverse(mnist5_flm_py)

err_flm_py = max(abs(mnist5_flm_py-mnist5_flm.squeeze()))
err_recon_py = max(abs(mnist5_recon_py-mnist5_recon.squeeze()))

flm_00 = np.zeros_like(flm)
flm_00[0]=1
sh_00 = t.inverse(flm_00)

flm_lm = np.zeros_like(flm_00)
flm_lm[SHTransform.index_flm(1,0)]=1
sh_lm = t.inverse(flm)

[x,y,z]= sph2cart(t._phi, theta_extended)
fig = plt.figure()
ax = fig.gca(projection='3d')
ax.scatter(x,y,z,c = np.abs(mnist5_recon_py))
ax.set_xlabel('X Label')
ax.set_ylabel('Y Label')
ax.set_zlabel('Z Label')

fig_sh = plt.figure()
ax_sh = fig_sh.gca(projection='3d')
ax_sh.scatter(x,y,z,c = np.abs(sh_lm))

# surf = ax.plot_surface(x,y,z, rstride = 1, cstride = 1, facecolors = np.abs(mnist5_recon_py),
#                        linewidth = 0, antialiased = False)

ax_sh.set_xlabel('X Label')
ax_sh.set_ylabel('Y Label')
ax_sh.set_zlabel('Z Label')
plt.show()


Err_recon_random = np.max(np.abs(f.squeeze()-f_recon))

print err_flm_py
print err_recon_py
print Err_recon_random