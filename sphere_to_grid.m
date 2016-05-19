function [ grid_pic ] = sphere_to_grid( size, img )
%SPHERE_TO_GRID Summary of this function goes here
%   Detailed explanation goes here
    grid_pic = zeros(size);
    proj_indecies = round(img.dirs * diag([(size(2) - 1)/ (2 * pi), (size(1) - 1) / pi])) + 1;
    proj_indecies = sub2ind(size, proj_indecies(:,2), proj_indecies(:,1));
    grid_pic(proj_indecies) = img.values;
end
