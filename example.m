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
view([60 10]);
img = project_on_sphere(margined_mnist5);
img = img.rotate(0, 50);
sh_fourier = sh_image(img.dirs, ...
                      directSHT(N, img.values, img.dirs, 'complex'));
 
filt_opt = default_filter_options('dyadic', 2 * N);
filt_opt.Q = 2;
filt_opt.B = 0.5;
filt_opt.boundary = 'nonsymm';
filt_opt.fliter_type = 'gabor_1d';

filters = morlet_filter_bank_1d(N, filt_opt);

figure;
hold on;
for i = 1:numel(filters.psi.filter)
    filter = realize_filter(filters.psi.filter{i}, N);
    plot(filter);
end
hold off;

for i = 1:numel(filters.psi.filter)
    show_results(realize_filter(filters.psi.filter{i}, N), size(margined_mnist5), sh_fourier);
end
show_results(realize_filter(filters.phi.filter), size(margined_mnist5), sh_fourier);