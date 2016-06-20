path_to_proj = fileparts(mfilename('fullpath'));

addpath(fullfile('C:','Data','ImageDataSets','MNIST','mnist'));


addpath(fullfile(path_to_proj, 'MNIST'));
addpath(fullfile(path_to_proj, 'polarch-Spherical-Harmonic-Transform-8360a11'));
addpath(fullfile(path_to_proj, 'scatnet'));
addpath(genpath(fullfile(path_to_proj, 'SphericalUtils')));
addpath_scatnet;

clear path_to_proj;