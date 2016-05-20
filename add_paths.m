path_to_proj = fileparts(mfilename('fullpath'));

addpath(genpath('.\SphericalUtils'));
addpath(fullfile(path_to_proj, 'polarch-Spherical-Harmonic-Transform-8360a11'));
addpath(fullfile(path_to_proj, 'scatnet'));
addpath_scatnet;

clear path_to_proj;