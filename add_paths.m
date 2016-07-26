path_to_proj = fileparts(mfilename('fullpath'));

addpath(fullfile(path_to_proj, 'MNIST'));
addpath(fullfile(path_to_proj, 'polarch-Spherical-Harmonic-Transform-8360a11'));
addpath(fullfile(path_to_proj, 'scatnet'));
addpath(fullfile(path_to_proj, 'haarscat-0.1','utils'));
addpath(genpath(fullfile(path_to_proj, 'nsht','src')));
addpath(genpath(fullfile(path_to_proj, 'libsvm-compact-0.1','matlab')));

addpath_scatnet;

clear path_to_proj;