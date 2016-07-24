function [ img ] = project_on_sphere( pic, dirs )
%PROJECT_ON_SHPERE Summary of this function goes here
%   Detailed explanation goes here
[height, width] = size(pic);
num_dirs = height * width;

if nargin < 2
    S = randn(3, num_dirs);
    S = S ./ repmat(sqrt(sum(S.^2)), [3 1]);
    [azimuth, elev] = cart2sph(S(1,:), S(2,:), S(3,:));
    dirs = [azimuth.' elev.'] + repmat([pi, pi/2], [num_dirs 1]);
end

proj_indecies = round(dirs * diag([(width - 1)/ (2 * pi), (height - 1) / pi])) + 1;
proj_indecies = sub2ind(size(pic), proj_indecies(:,2), proj_indecies(:,1));
proj = pic(proj_indecies);
img = sh_image(dirs, proj);
end

