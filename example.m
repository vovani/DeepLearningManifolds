add_paths;

N = 64;

% NOTE: The image was created using the following code. 
% 
% minst5 = loadMNISTImages('train-images.idx3-ubyte');
% minst5 = reshape(minst5(:,1), 28, 28);
% margined_mnist5 = zeros(N, N);
% margined_mnist5(13 : 40, 13 : 40) = minst5;
load margined_mnist5

plot_projection_on_sphere(margined_mnist5);

% NOTE:
%     The filters where created by the following code. Currently I've saved
%     them to .mat files and loading them, becuase I didn't want to upload 
%     huge amounts of data (the external packages I've used) to git, since
%     my connection on the satellite internet is quite slow.
%
% [sh_pic, sh_dirs, proj_indecies] = project_on_sphere(margined_mnist5);
% sh_fourier = directSHT(N, sh_pic, sh_dirs, 'complex');
% 
% filt_opt = default_filter_options('dyadic', 2 * N);
% filt_opt.Q = 2;
% filt_opt.B = 0.5;
% filt_opt.boundary = 'nonsymm';
% filt_opt.fliter_type = 'gabor_1d';
% 
% filters = morlet_filter_bank_1d(N, filt_opt);
load filters

figure;
hold on;
for i = 1:numel(filters.psi.filter)
    filter = realize_filter(filters.psi.filter{i}, N);
    plot(filter);
end
hold off;

for i = 1:numel(filters.psi.filter)
    filter = realize_filter(filters.psi.filter{i}, N);
    sh_filtered = apply_filter(filter, sh_fourier, sh_dirs);
    filtered = sphere_to_grid(size(margined_mnist5), sh_filtered, proj_indecies);
    figure;
    plot_projection_on_sphere(abs(filtered));
end

filter = realize_filter(filters.phi.filter);
sh_filtered = apply_filter(filter, sh_fourier, sh_dirs);
filtered = sphere_to_grid(size(margined_mnist5), sh_filtered, proj_indecies);
figure;
plot_projection_on_sphere(abs(filtered));