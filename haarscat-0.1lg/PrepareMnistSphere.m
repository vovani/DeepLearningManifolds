clear; close all;

path_to_mnist = 'C:\Data\ImageDataSets\MNIST';
addpath('C:\dev\Matlab_code\Spectral_meth\Scattering\scatnet-0.2\scatnet-0.2\utils');
addpath(genpath('./'));
options.mode='mild';% small rotation

int16Round=@(X)(int16(round(X)));

[X_tr, X_te,S,Theta,Phi,theta,phi] = ...
    read_mnist_sphere_uniform(path_to_mnist,options);

Theta=reshape(Theta,sqrt(size(Theta,1)),sqrt(size(Theta,1)));
Phi=reshape(Phi,sqrt(size(Phi,1)),sqrt(size(Phi,1)));
[Xtensor_Tr, Ytensor_Tr] = MnistSpherToTensor(X_tr);
[Xtensor_Ts, Ytensor_Ts] = MnistSpherToTensor(X_te);

Xtensor_Tr=int16Round(Xtensor_Tr);
Ytensor_Tr=int16(Ytensor_Tr);
Xtensor_Ts=int16Round(Xtensor_Ts);
Ytensor_Ts=int16(Ytensor_Ts);

save('data/Small/TrainX.mat','Xtensor_Tr');
save('data/Small/TrainLabels.mat','Ytensor_Tr');
save('data/Small/TestX.mat','Xtensor_Ts');
save('data/Small/TestLabels.mat','Ytensor_Ts');
save('data/Small/Theta.mat','Theta');
save('data/Small/Phi.mat','Phi');

ImgS=squeeze(Xtensor_Ts(1,1,:,:));
figure, imagesc(theta,phi,ImgS),colormap(jet),
xlabel('theta')
ylabel('phi');

figure;
scatter3(S(1,:),S(2,:),S(3,:),15,ImgS(:),'filled');
colormap(jet);
colorbar;

ImgS=X_tr{1}(:,1); %zero
figure;
scatter3(S(1,:),S(2,:),S(3,:),15,ImgS(:),'filled');
colormap(jet);
colorbar;

clear;
path_to_mnist = 'C:\Data\ImageDataSets\MNIST';
addpath('C:\dev\Matlab_code\Spectral_meth\Scattering\scatnet-0.2\scatnet-0.2\utils');
addpath(genpath('./'));
options.mode='mild';% small rotation

int16Round=@(X)(int16(round(X)));


options.mode='uniform';% small rotation
[X_tr, X_te,S,Theta,Phi] = read_mnist_sphere_uniform(path_to_mnist,options);

Theta=reshape(Theta,sqrt(size(Theta,1)),sqrt(size(Theta,1)));
Phi=reshape(Phi,sqrt(size(Phi,1)),sqrt(size(Phi,1)));
[Xtensor_Tr, Ytensor_Tr] = MnistSpherToTensor(X_tr);
[Xtensor_Ts, Ytensor_Ts] = MnistSpherToTensor(X_te);

Xtensor_Tr=int16Round(Xtensor_Tr);
Ytensor_Tr=int16(Ytensor_Tr);
Xtensor_Ts=int16Round(Xtensor_Ts);
Ytensor_Ts=int16(Ytensor_Ts);

save('data/Large/TrainX.mat','Xtensor_Tr');
save('data/Large/TrainLabels.mat','Ytensor_Tr');
save('data/Large/TestX.mat','Xtensor_Ts');
save('data/Large/TestLabels.mat','Ytensor_Ts');
save('data/Large/Theta.mat','Theta');
save('data/Large/Phi.mat','Phi');
