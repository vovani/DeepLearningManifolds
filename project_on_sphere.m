function [ proj, dirs, proj_indexes ] = project_on_sphere( pic )
%PROJECT_ON_SHPERE Summary of this function goes here
%   Detailed explanation goes here
[height, width] = size(pic);
dirs = grid2dirs(360 / width, 180 / height);
proj_indexes = round(dirs * diag([(width - 1)/ (2 * pi), (height - 1) / pi])) + 1;
proj_indexes = sub2ind(size(pic), proj_indexes(:,2), proj_indexes(:,1));
proj = pic(proj_indexes);
end

