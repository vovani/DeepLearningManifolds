function  plot_sph( img, sizes )
    grid = sphere_to_grid(sizes, img);
    plot_projection_on_sphere(abs(grid));
    view([60 10]);
end

