import pytest
import mnist
import math
import numpy as np
import numpy.matlib

import matplotlib.pyplot as plt
from matplotlib import cm, colors
from mpl_toolkits.mplot3d import Axes3D

from nsht.transform import SHTransform

# Add tests for L = 16, 32, 64
Ls = [64]

@pytest.mark.parametrize("L", Ls)
def test_reconstruction(L):
    t = SHTransform(L)
    random_signal = np.random.rand(1, L ** 2)
    reconstructed_signal = t.inverse(t.forward(random_signal))
    error = np.linalg.norm(random_signal - reconstructed_signal) / np.linalg.norm(random_signal)
    assert error < 1e-14

def normalize_points(points):
    npoints = len(points)
    return np.array(points) / np.matlib.repmat([np.pi, 2 * np.pi], npoints, 1)

def transform_mnist(mnist_img, width):
    img = np.array(mnist_img)
    img_width = int(math.sqrt(img.size))
    assert(img_width ** 2 == img.size)
    img = np.reshape(img, [img_width, img_width])

    to_pad = width - img_width
    assert (to_pad >= 0 and to_pad % 2 == 0)
    img = np.pad(img, to_pad / 2, 'constant', constant_values = 0)
    return img

def projection(img, _points):
    points = np.intp(np.matlib.repmat(np.array(img.shape) - 1, len(_points), 1) * normalize_points(_points))
    return img[(points[:, 0], points[:, 1])]

def power_spectrum(coeffs, L):
    assert (len(coeffs) ==  L ** 2)
    band_width = 2 * np.arange(L) + 1
    energies = []
    for i, width in enumerate(band_width):
        band_start = sum(band_width[:i])
        energies.append(np.linalg.norm(coeffs[band_start : band_start + band_width[i]]))
    return np.array(energies)

def rotate_points(points, mat):
    phi = points[:, 1]
    theta = points[:, 0]
    cart = np.array([np.sin(theta) * np.cos(phi), np.sin(theta) * np.sin(phi), np.cos(theta)])
    cart_rot = np.dot(mat, cart)
    rot_theta = np.arccos(cart_rot[2, :])
    rot_phi = np.arctan2(cart_rot[1,:], cart_rot[0,:])
    return np.array([rot_theta, rot_phi]).T


def plot_spherical(_img, points):
    # img = np.double(np.reshape(_img, [64,64]))
    # phi = np.reshape(points[:, 1], [64, 64])
    # theta = np.reshape(points[:, 0], [64, 64])
    img = np.array(_img, dtype=float)
    phi = points[:, 1]
    theta = points[:, 0]

    # The Cartesian coordinates of the unit sphere
    x = np.sin(theta) * np.cos(phi)
    y = np.sin(theta) * np.sin(phi)
    z = np.cos(theta)

    fmax, fmin = img.max(), img.min()
    fcolors = (img - fmin)/(fmax - fmin)

    # Set the aspect ratio to 1 so our sphere looks spherical
    fig = plt.figure(figsize=plt.figaspect(1.))
    ax = fig.add_subplot(111, projection='3d')
    ax.scatter(x, y, z, c=cm.seismic(fcolors))
    # Turn off the axis planes
    ax.set_axis_off()
    plt.draw()

@pytest.mark.parametrize("L", Ls)
def test_rotation(L):
    t = SHTransform(L)
    loader = mnist.MNIST(r"C:\Users\Vladimir Anisimov\Documents\MATLAB\DeepLearningOnManifolds\mnist")
    mnist_imgs, mnist_lbls = loader.load_training()

    p = np.array(t.sampling_points()).T

    [u, _, _] = np.linalg.svd(np.random.rand(3, 3))

    orig_grid = transform_mnist(mnist_imgs[0], 64)
    orig = projection(orig_grid, p)

    rotated_samples = rotate_points(p, u)
    rotated = projection(orig_grid, rotated_samples)

    orig = np.zeros_like(orig)
    rotated = np.zeros_like(rotated)
    orig[100] = 1
    rotated[101] = 1

    plot_spherical(orig, p)
    plt.show()
    plot_spherical(rotated, p)
    plt.show()

    orig_coeffs = t.forward(orig.reshape(-1))
    rotated_coeffs = t.forward(rotated.reshape(-1))

    print power_spectrum(orig_coeffs, L)
    print power_spectrum(rotated_coeffs, L)
    print np.linalg.norm(power_spectrum(orig_coeffs, L) - power_spectrum(rotated_coeffs, L)) / np.linalg.norm(power_spectrum(orig_coeffs, L))