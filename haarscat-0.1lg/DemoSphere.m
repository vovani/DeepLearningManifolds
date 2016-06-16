close all;
clear;
path_to_mnist = 'C:\Data\ImageDataSets\MNIST';
addpath('C:\dev\Matlab_code\Spectral_meth\Scattering\scatnet-0.2\scatnet-0.2\utils');
addpath(genpath('C:\Data\ImageDataSets\TestImage\'));
addpath(genpath('./'));
options.mode='mild';% small rotation
load('lena512.mat');
Image_babun=rgb2gray(imread('4.2.03.tiff'));
int16Round=@(X)(int16(round(X)));

N=256^2;
S=zeros(3,N);
n=sqrt(N);
theta=linspace(0,2*pi,n+1);
theta=theta(1:end-1);
phi=linspace(0,pi,n+1);
phi=phi(1:end-1);
[Theta,Phi]=meshgrid(theta,phi);
Theta=Theta(:);
Phi=Phi(:);
[S(1,:),S(2,:),S(3,:)]=sph2cart(Phi,Theta,ones(size(Phi)));


options.mode='uniform';% small rotation
switch options.mode
    case 'uniform'
        alpha = 1;
    case 'mild'
        alpha = 0;
end

M0 = 128;

[labels] = readidx(fullfile(path_to_mnist,'mnist','train-labels.idx1-ubyte'),60000,60000);
[xifres] = readidx(fullfile(path_to_mnist,'mnist','train-images.idx3-ubyte'),60000,60000);

indx0=find(labels==0);
indx5=find(labels==5);
indx8=find(labels==8);
Img2D_0=xifres(:,indx0(1));
Img2D_0 = reshape(Img2D_0,28,28);
Img2D_5=xifres(:,indx5(1));
Img2D_5 = reshape(Img2D_5,28,28);
Img2D_8=xifres(:,indx8(1));
Img2D_8 = reshape(Img2D_8,28,28);

ImgLena = imresize(lena512,[128 128],'bicubic');
Image_babun = imresize(Image_babun,[128 128],'bicubic');

[ ImgSphere_0 ] = ProjectImageToSphere( Img2D_0, [M0 M0], alpha, S );
[ ImgSphere_5 ] = ProjectImageToSphere( Img2D_5, [M0 M0], alpha, S );
[ ImgSphere_8 ] = ProjectImageToSphere( Img2D_8, [M0 M0], alpha, S );

[ ImgSphere_Lena ] = ProjectImageToSphere( ImgLena, [M0 M0], alpha, S );
[ ImgSphere_Babun ] = ProjectImageToSphere( Image_babun, [M0 M0], alpha, S );


figure;
scatter3(S(1,:),S(2,:),S(3,:),15,ImgSphere_0,'filled');
    colormap(jet);
       
    
    figure;   
scatter3(S(1,:),S(2,:),S(3,:),15,ImgSphere_5,'filled');
    colormap(jet);
    
    figure;
 scatter3(S(1,:),S(2,:),S(3,:),15,ImgSphere_8,'filled');
    colormap(jet);
    
      figure;
 scatter3(S(1,:),S(2,:),S(3,:),15,ImgSphere_Lena,'filled');
    colormap(jet);
    
      figure;
 scatter3(S(1,:),S(2,:),S(3,:),15,ImgSphere_Babun,'filled');
    colormap(jet);
    
    figure;
      imagesc(reshape(ImgSphere_0,n,n));
      colormap(jet);
      
        figure;
      imagesc(reshape(ImgSphere_5,n,n));
      colormap(jet);
      
        figure;
      imagesc(reshape(ImgSphere_Lena,n,n));
      colormap(jet);
      
          figure;
      imagesc(reshape(ImgSphere_Babun,n,n));
      colormap(jet);
      
      
      figure;
      imagesc(Img2D_0);
      colormap(gray);
      
        figure;
      imagesc(Img2D_5);
      colormap(gray);
      
        figure;
      imagesc(Img2D_8);
      colormap(gray);
      
       figure;
      imagesc(ImgLena);
      colormap(gray);
      
       figure;
      imagesc(Image_babun);
      colormap(gray);