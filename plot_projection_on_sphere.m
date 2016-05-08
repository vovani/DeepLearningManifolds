function plot_projection_on_sphere( grid_vals )
    [xx, yy, zz] = sphere;
    h = surf(xx, yy, zz);
%     h = findobj('Type','surface');
    set(h,'CData',flipud(grid_vals),'FaceColor','texturemap')
end

