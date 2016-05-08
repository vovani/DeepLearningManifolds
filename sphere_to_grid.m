function [ grid_pic ] = sphere_to_grid( size, sh_values, proj_indexes )
%SPHERE_TO_GRID Summary of this function goes here
%   Detailed explanation goes here
    grid_pic = zeros(size);
    grid_pic(proj_indexes) = sh_values;
end

