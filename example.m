add_paths;

N = 32;

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
sh_fourier = sh_image(img.dirs, ...
                      directSHT(N, img.values, img.dirs, 'complex'));
 

figure;
scatter3(img.S(1,:),img.S(2,:),img.S(3,:),15,img.values(:),'filled');
 colormap(jet);
colorbar;

ImgRot = img.RandRotate();

figure;
scatter3(ImgRot.S(1,:),ImgRot.S(2,:),ImgRot.S(3,:),15,ImgRot.values(:),'filled');
 colormap(jet);
colorbar;

imgRecon = inverseSHT(sh_fourier.values, sh_fourier.dirs, 'complex');
 
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

ImgKernel=CreateKernel(realize_filter(filters.psi.filter{1}),img.dirs,1);
 filtered = sphere_to_grid( size(margined_mnist5), ImgKernel);
figure;
plot_projection_on_sphere(abs(filtered));
view([60 10]);

figure;
scatter3(ImgKernel.S(1,:),ImgKernel.S(2,:),ImgKernel.S(3,:),15,ImgKernel.values(:),'filled');
 colormap(jet);
colorbar;

FilterHightPass=zeros(32,1);
FilterHightPass(10:20)=1;
ImgKernel1=CreateKernel(FilterHightPass,img.dirs,1);
 filtered1 = sphere_to_grid( size(margined_mnist5), ImgKernel1);
figure;
plot_projection_on_sphere(abs(filtered1));
view([60 10]);

    