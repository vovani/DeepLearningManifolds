function show_results(filter, sizes, proj_indecies, sh_fourier, sh_dirs)
    sh_filtered = apply_filter(filter, sh_fourier, sh_dirs);
    filtered = sphere_to_grid(sizes, sh_filtered, proj_indecies);
    figure;
    plot_projection_on_sphere(abs(filtered));
    view([60 10]);
end