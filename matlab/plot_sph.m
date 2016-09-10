function  plot_sph( img, sizes )
    grid = sphere_to_grid(sizes, img);
    plot_projection_on_sphere(abs(grid));
    view([60 10]);
%     scatter3(img.S(1, :), img.S(2,:), img.S(3,:), 20, abs(img.values));
end

