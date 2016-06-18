function show_results(filter, sizes, sh_fourier)
    sh_filtered = apply_filter(filter, sh_fourier);
    filtered = sphere_to_grid(sizes, sh_filtered);
    figure;
    plot_projection_on_sphere(abs(filtered));
    view([60 10]);
end