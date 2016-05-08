%% Example Title
% Summary of example objective

%% Section 1 Title
% escription of first code block

add_paths;

N = 64;

minst5 = loadMNISTImages('train-images.idx3-ubyte');
minst5 = reshape(minst5(:,1), 28, 28);
margined_minst5 = zeros(N, N);
margined_minst5(13 : 40, 13 : 40) = minst5;

plot_projection_on_sphere(margined_minst5);

[sh_pic, sh_dirs, proj_indecies] = project_on_sphere(margined_minst5);
sh_fourier = directSHT(N, sh_pic, sh_dirs, 'complex');

filt_opt = default_filter_options('dyadic', 2 * N);
filt_opt.Q = 1;
filt_opt.B = 0.5;
filt_opt.boundary = 'nonsymm';

filters = morlet_filter_bank_1d(N, filt_opt);

figure;
hold on;
for i = 1:numel(filters.psi.filter)
    filter = filters.psi.filter{i};
    plot([zeros(1, filter.start) filter.coefft.']);
end
hold off;

for i = 1:numel(filters.psi.filter)
    filter = filters.psi.filter{i};
    sh_filtered = apply_filter(filter, sh_fourier, sh_dirs);
    filtered = sphere_to_grid(size(margined_minst5), sh_filtered, proj_indecies);
    figure;
    plot_projection_on_sphere(abs(filtered));
end

filter = filters.phi.filter;
sh_filtered = apply_filter(filter, sh_fourier, sh_dirs);
filtered = sphere_to_grid(size(margined_minst5), sh_filtered, proj_indecies);
figure;
plot_projection_on_sphere(abs(filtered));