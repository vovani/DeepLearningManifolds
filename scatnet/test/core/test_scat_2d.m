% script that demonstrates use of 2d scattering

clear; close all;
x = uiuc_sample;
filt_opt.J = 7;
filt_opt.L = 8;
scat_opt.oversampling = 0;
[Wop, filters] = wavelet_factory_2d(size(x), filt_opt, scat_opt);

%%
profile on;
tic;
[Sx, Ux] = scat(x, Wop);
toc;
profile off;
profile viewer;