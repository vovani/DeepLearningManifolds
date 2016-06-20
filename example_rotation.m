clear;
close all;
add_paths;
add_paths
mnist = loadMNISTImages('train-images.idx3-ubyte');
train_labels = loadMNISTLabels('train-labels.idx1-ubyte');
mnist5=padarray(reshape(mnist(:,1), 28, 28), [18 18]);
%mnist5 = imresize(mnist5,2);
sizes = size(mnist5);
N = round(mean(sizes)/2);

simplImg=zeros([128 128]);
simplImg(48:80, 48:80)=1;
mnist_shpere = project_on_sphere(mnist5,true);
    alpha=2*pi*rand();
    beta=pi*rand();
    gamma=2*pi*rand();
 
[ImgRot,RotMtrx]=mnist_shpere.rotate(alpha,beta,beta);

[ImgRot1,RotMtrx1]=mnist_shpere.rotateOLD(alpha,beta,beta);

[ImgRotInv,RotMtrxInv]=ImgRot.rotateMtrx(RotMtrx');

%  RotMtrx = euler2rotationMatrix(alpha, beta, gamma, 'zyx');
%  ImgRot=RotateSphrImg(mnist_shpere.values,mnist_shpere.S,RotMtrx);   

% ImgInv=RotateSphrImg(ImgRot,mnist_shpere.S,RotMtrx'); 
 
 %ErrMat=abs(mnist_shpere.values-ImgInv);
 
 figure;
 plot_sph(ImgRot, sizes);
 
 figure;
 plot_sph(mnist_shpere, sizes);

 
 figure;
scatter3(mnist_shpere.S(1,:),mnist_shpere.S(2,:),mnist_shpere.S(3,:),15,mnist_shpere.values(:),'filled'); 
colormap(jet);
 title('Origin image');
colorbar;

 figure;
scatter3(ImgRot.S(1,:),ImgRot.S(2,:),ImgRot.S(3,:),15,ImgRot.values(:),'filled');
  view([60 10]);
 colormap(jet);
  title('Rotated image');
colorbar;

 figure;
scatter3(ImgRot1.S(1,:),ImgRot1.S(2,:),ImgRot1.S(3,:),15,ImgRot1.values(:),'filled');
 colormap(jet);
  title('OLDRotated image');
colorbar;

 figure;
scatter3(ImgRotInv.S(1,:),ImgRotInv.S(2,:),ImgRotInv.S(3,:),15,ImgRotInv.values(:),'filled');
 colormap(jet);
  title('Recon image');
colorbar;

filt_opt = default_filter_options('dyadic', 2 * N);
filt_opt.Q =[4 2]; %[8 4]; [4 2]
filt_opt.boundary = 'nonsymm';
filt_opt.fliter_type = 'gabor_1d';
filters = filter_bank(N + 1, filt_opt);

originSH = getSH(N, mnist_shpere.dirs, 'complex');
[ features_origin,meta_origin,U_origin,fourier_origin] =...
    ScatSphericalMomonets( mnist_shpere,filters,originSH );

RotSH = getSH(N, ImgRot.dirs, 'complex');
[ features_rot,meta_rot,U_rot,fourier_rot] =...
    ScatSphericalMomonets( ImgRot,filters,originSH );

Rot1SH = getSH(N, ImgRot1.dirs, 'complex');
[ features_rot1,meta_rot1,U_rot1,fourier_rot1] =...
    ScatSphericalMomonets( ImgRot1,filters,Rot1SH );

InvSH = getSH(N, ImgRotInv.dirs, 'complex');
[ features_inv,meta_inv,U_inv,fourier_inv] =...
    ScatSphericalMomonets( ImgRotInv,filters,InvSH );

figure
plot(features_origin,'*-b'); hold on;
plot(features_rot,'o-c');
plot(features_rot1,'.-m');
plot(features_inv,'d-g')
legend('Origin','Rotated','Rotated OLD','Recon'); 
%  figure;
% scatter3(mnist_shpere.S(1,:),mnist_shpere.S(2,:),mnist_shpere.S(3,:),15,ImgInv(:),'filled');
%  colormap(jet);
%   title('Recon image');
% colorbar;
% 
%  figure;
% scatter3(mnist_shpere.S(1,:),mnist_shpere.S(2,:),mnist_shpere.S(3,:),15,ErrMat,'filled');
%  colormap(jet);
%   title('Err image');
% colorbar;

% pic = mnist5;
% sizes = size(pic);
% img(1) = project_on_sphere(pic);
% img(2) = img(1).rotate(pi / 2, 0, 0);
% img(3) = img(1).rotate(0, pi / 2, 0);
% img(4) = img(1).rotate(0, 0, pi / 2);
% 
% for i = 1:4
%     subplot(2, 2, i);
%     plot_sph(img(i), sizes);
% end
% 
% bands = 2 * (0:32) + 1;
% band = zeros(4, N + 1);
% sh_fourier = cell(1, 4);
% U = cell(4);
% S = cell(4);
% 
% filt_opt = default_filter_options('dyadic', 2 * N);
% filt_opt.Q = [2 1];
% filt_opt.boundary = 'nonsymm';
% filt_opt.fliter_type = 'gabor_1d';
% filters = filter_bank(N + 1, filt_opt);
% 
% parfor i = 1 : 4 
%     sh_fourier{i} = sh_image(img(i).dirs, directSHT(N, img(i).values, img(i).dirs, 'complex'));
%     start = 1;
%     for j = 1:(N+1)
%         band(i, j) = sum(abs(sh_fourier{i}.values(start : start - 1 + bands(j))) .^ 2);
%         start = start + bands(j);
%     end
%     [U{i}, S{i}] = scat2(filters, N, sh_fourier{i});
% end
% 
% color = ['*', 'g', 'b', 'y'];
% figure;
% hold on;
% for i = 1:4
%     plot(band(i, :), color(i));
% end
% legend('original', 'rot = [pi / 2, 0, 0]',...
%                    'rot = [0, pi / 2, 0]',...
%                    'rot = [0, 0, pi / 2]');
% hold off;
% 
% figure;
% hold on;
% for i = 1:4
%     plot([S{i}{1} S{i}{2}], color(i));
% end
% legend('original', 'rot = [pi / 2, 0, 0]',...
%                    'rot = [0, pi / 2, 0]',...
%                    'rot = [0, 0, pi / 2]');
% hold off;
