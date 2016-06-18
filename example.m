add_paths;

N = 32;

% NOTE: The image was created using the following code. 
% 
%  minst5 = loadMNISTImages('train-images.idx3-ubyte');
% minst5 = reshape(minst5(:,1), 28, 28);
% margined_mnist5 = zeros(N, N);
% margined_mnist5(13 : 40, 13 : 40) = minst5;
% save margined_mnist5 margined_mnist5
load margined_mnist5

plot_projection_on_sphere(margined_mnist5);
view([60 10]);
img = project_on_sphere(margined_mnist5);
sh_fourier = sh_image(img.dirs, ...
                      directSHT(N, img.values, img.dirs, 'complex'));
 

figure;
scatter3(img.S(1,:),img.S(2,:),img.S(3,:),15,img.values(:),'filled');
 colormap(jet);
colorbar;

% ImgRot = img.RandRotate();
% 
% figure;
% scatter3(ImgRot.S(1,:),ImgRot.S(2,:),ImgRot.S(3,:),15,ImgRot.values(:),'filled');
%  colormap(jet);
% colorbar;

imgRecon = inverseSHT(sh_fourier.values, sh_fourier.dirs, 'complex');
 
filt_opt = default_filter_options('dyadic', 2 * N);
filt_opt.Q = [2 1];
filt_opt.boundary = 'nonsymm';
filt_opt.fliter_type = 'gabor_1d';

filters = filter_bank(N, filt_opt);

figure;
for m = 1 : numel(filters)
    subplot(1, 2, m);
    hold on;
    for i = 1:numel(filters{m}.psi.filter)
        filter = realize_filter(filters{m}.psi.filter{i}, N);
        plot(filter);
    end
    hold off;
end

[U, S] = scat( filters, N, sh_fourier );

for i = 1:numel(filters.psi.filter)
    show_results(realize_filter(filters.psi.filter{i}, N), size(margined_mnist5), sh_fourier);
end
show_results(realize_filter(filters.phi.filter), size(margined_mnist5), sh_fourier);
