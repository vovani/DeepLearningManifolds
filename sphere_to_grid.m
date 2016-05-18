function [ grid_pic ] = sphere_to_grid( size, img )
%SPHERE_TO_GRID Summary of this function goes here
%   Detailed explanation goes here
    grid_pic = zeros(size);
    grid_pic(img.proj_indecies) = img.values;
end
