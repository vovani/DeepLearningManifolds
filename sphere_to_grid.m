function [ grid_pic ] = sphere_to_grid( size, img )
%SPHERE_TO_GRID Summary of this function goes here
%   Detailed explanation goes here
    grid_pic = zeros(size);
%     proj_indecies = round(img.dirs * diag([(size(2) - 1)/ (2 * pi), (size(1) - 1) / pi])) + 1;
%     proj_indecies = sub2ind(size, proj_indecies(:,2), proj_indecies(:,1));
    for w = 1 : size(2)
        for h = 1 : size(1)
            azi = 2 * pi * w / size(2);
            elev = pi * h / size(1);
            d = distance(img.dirs, repmat([azi elev], [length(img.dirs) 1]));
            [~, closest] = sort(d);
            grid_pic(h, w) = img.values(closest(1));
        end
    end
end
