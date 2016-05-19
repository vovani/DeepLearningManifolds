function [ img ] = project_on_sphere( pic )
%PROJECT_ON_SHPERE Summary of this function goes here
%   Detailed explanation goes here
[height, width] = size(pic);
dirs = grid2dirs(360 / width, 180 / height);
proj_indecies = round(dirs * diag([(width - 1)/ (2 * pi), (height - 1) / pi])) + 1;
proj_indecies = sub2ind(size(pic), proj_indecies(:,2), proj_indecies(:,1));
proj = pic(proj_indecies);
img = sh_image(dirs, proj);
end

