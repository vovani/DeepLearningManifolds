clear;
close all;
add_paths;

mnist = loadMNISTImages('train-images.idx3-ubyte');
mnist5 = padarray(reshape(mnist(:,10000), 28, 28), [18 18]);
N = 32;

mnist_shpere = project_on_sphere(mnist5);
    alpha=2*pi*rand();
    beta=pi*rand();
    gamma=2*pi*rand();
 RotMtrx = euler2rotationMatrix(alpha, beta, gamma, 'zyx');
 ImgRot=RotateSphrImg(mnist_shpere.values,mnist_shpere.S,RotMtrx);   

 ImgInv=RotateSphrImg(ImgRot,mnist_shpere.S,RotMtrx'); 
 
 ErrMat=abs(mnist_shpere.values-ImgInv);
 
 figure;
scatter3(mnist_shpere.S(1,:),mnist_shpere.S(2,:),mnist_shpere.S(3,:),15,mnist_shpere.values(:),'filled');
 colormap(jet);
 title('Origin image');
colorbar;

 figure;
scatter3(mnist_shpere.S(1,:),mnist_shpere.S(2,:),mnist_shpere.S(3,:),15,ImgRot(:),'filled');
 colormap(jet);
  title('Rotated image');
colorbar;

 figure;
scatter3(mnist_shpere.S(1,:),mnist_shpere.S(2,:),mnist_shpere.S(3,:),15,ImgInv(:),'filled');
 colormap(jet);
  title('Recon image');
colorbar;

 figure;
scatter3(mnist_shpere.S(1,:),mnist_shpere.S(2,:),mnist_shpere.S(3,:),15,ErrMat,'filled');
 colormap(jet);
  title('Err image');
colorbar;

pic = mnist5;
sizes = size(pic);
img(1) = project_on_sphere(pic);
img(2) = img(1).rotate(pi / 2, 0, 0);
img(3) = img(1).rotate(0, pi / 2, 0);
img(4) = img(1).rotate(0, 0, pi / 2);

for i = 1:4
    subplot(2, 2, i);
    plot_sph(img(i), sizes);
end

bands = 2 * (0:32) + 1;
band = zeros(4, N + 1);
sh_fourier = cell(1, 4);
U = cell(4);
S = cell(4);

filt_opt = default_filter_options('dyadic', 2 * N);
filt_opt.Q = [2 1];
filt_opt.boundary = 'nonsymm';
filt_opt.fliter_type = 'gabor_1d';
filters = filter_bank(N + 1, filt_opt);

parfor i = 1 : 4 
    sh_fourier{i} = sh_image(img(i).dirs, directSHT(N, img(i).values, img(i).dirs, 'complex'));
    start = 1;
    for j = 1:(N+1)
        band(i, j) = sum(abs(sh_fourier{i}.values(start : start - 1 + bands(j))) .^ 2);
        start = start + bands(j);
    end
    [U{i}, S{i}] = scat2(filters, N, sh_fourier{i});
end

color = ['*', 'g', 'b', 'y'];
figure;
hold on;
for i = 1:4
    plot(band(i, :), color(i));
end
legend('original', 'rot = [pi / 2, 0, 0]',...
                   'rot = [0, pi / 2, 0]',...
                   'rot = [0, 0, pi / 2]');
hold off;

figure;
hold on;
for i = 1:4
    plot([S{i}{1} S{i}{2}], color(i));
end
legend('original', 'rot = [pi / 2, 0, 0]',...
                   'rot = [0, pi / 2, 0]',...
                   'rot = [0, 0, pi / 2]');
hold off;
