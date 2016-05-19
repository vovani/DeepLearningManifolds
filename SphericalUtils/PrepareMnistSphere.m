clear; close all;

addpath('C:\dev\Matlab_code\Spectral_meth\Sphere\Rotation');
path_to_mnist = 'C:\Data\ImageDataSets\MNIST';
%addpath('C:\dev\Matlab_code\Spectral_meth\Scattering\scatnet-0.2\scatnet-0.2\utils');
addpath(genpath('./'));
options.mode='mild';% mild=small uniform=large
options.alpha=0;
options.RotTheta=0;%pi;
options.RotPhi=pi;%0.5*pi;
options.n=64;
SavePathDir='data/NoneRotShiftNEW/';
if ~exist(SavePathDir,'dir')
    mkdir(SavePathDir);
end
int16Round=@(X)(int16(round(X)));

[X_tr, X_te,S,Theta,Phi,theta,phi] = ...
    read_mnist_sphere_uniform2(path_to_mnist,options);

Theta=reshape(Theta,sqrt(size(Theta,1)),sqrt(size(Theta,1)));
Phi=reshape(Phi,sqrt(size(Phi,1)),sqrt(size(Phi,1)));
[Xtensor_Tr, Ytensor_Tr] = MnistSpherToTensor(X_tr);
[Xtensor_Ts, Ytensor_Ts] = MnistSpherToTensor(X_te);

Xtensor_Tr=int16Round(Xtensor_Tr);
Ytensor_Tr=int16(Ytensor_Tr);
Xtensor_Ts=int16Round(Xtensor_Ts);
Ytensor_Ts=int16(Ytensor_Ts);

save([SavePathDir 'TrainX.mat'],'Xtensor_Tr');
save([SavePathDir 'TrainLabels.mat'],'Ytensor_Tr');
save([SavePathDir 'TestX.mat'],'Xtensor_Ts');
save([SavePathDir 'TestLabels.mat'],'Ytensor_Ts');
save([SavePathDir 'Theta.mat'],'Theta');
save([SavePathDir 'Phi.mat'],'Phi');

ImgS=squeeze(Xtensor_Ts(1,1,:,:));
figure, imagesc(theta,phi,ImgS),colormap(jet),
xlabel('theta')
ylabel('phi');
title('Oroginal Image')

alpha = 2*pi*rand(9,1) - pi ;% -180 to 180
beta = pi*rand(9,1) - pi*0.5; % -90 to 90
gama = 2*pi*rand(9,1) - pi; % -180 to 180
RotMtrx=compose_rotation(alpha(:),beta(:),gama(:));
figure;
for i=1:9
    ImgRot=RotateSphrImg(ImgS,S,squeeze(RotMtrx(i,:,:)));
    subplot(3,3,i);
  %  imagesc(theta,phi,ImgRot),colormap(jet),
    imagesc(ImgRot),colormap(jet),
    xlabel('theta')
    ylabel('phi');
    
%     str__=sprintf('Rotate,degs alpha=%d, betta=%d, gamma=%d', ...
%         round(rad2deg(alpha(i))),round(rad2deg(beta(i))),round(rad2deg(gama(i))) );
%     title(str__);
% figure;
% scatter3(S(1,:),S(2,:),S(3,:),15,ImgRot(:),'filled');
% colormap(jet);
% colorbar;
end

figure;
scatter3(S(1,:),S(2,:),S(3,:),15,ImgS(:),'filled');
colormap(jet);
colorbar;

ImgS=X_tr{1}(:,1); %zero
figure;
scatter3(S(1,:),S(2,:),S(3,:),15,ImgS(:),'filled');
colormap(jet);
colorbar;

% clear;
% path_to_mnist = 'C:\Data\ImageDataSets\MNIST';
% addpath('C:\dev\Matlab_code\Spectral_meth\Scattering\scatnet-0.2\scatnet-0.2\utils');
% addpath(genpath('./'));
% options.mode='mild';% small rotation
% 
% int16Round=@(X)(int16(round(X)));


% options.mode='uniform';% large rotation
% [X_tr, X_te,S,Theta,Phi] = read_mnist_sphere_uniform(path_to_mnist,options);

% Theta=reshape(Theta,sqrt(size(Theta,1)),sqrt(size(Theta,1)));
% Phi=reshape(Phi,sqrt(size(Phi,1)),sqrt(size(Phi,1)));
% [Xtensor_Tr, Ytensor_Tr] = MnistSpherToTensor(X_tr);
% [Xtensor_Ts, Ytensor_Ts] = MnistSpherToTensor(X_te);
% 
% Xtensor_Tr=int16Round(Xtensor_Tr);
% Ytensor_Tr=int16(Ytensor_Tr);
% Xtensor_Ts=int16Round(Xtensor_Ts);
% Ytensor_Ts=int16(Ytensor_Ts);
% 
% save('data/Large/TrainX.mat','Xtensor_Tr');
% save('data/Large/TrainLabels.mat','Ytensor_Tr');
% save('data/Large/TestX.mat','Xtensor_Ts');
% save('data/Large/TestLabels.mat','Ytensor_Ts');
% save('data/Large/Theta.mat','Theta');
% save('data/Large/Phi.mat','Phi');

%Img_temp=zeros(64);
% 
% figure;
% scatter3(S(1,:),S(2,:),S(3,:),15,Img_temp(:),'filled');
% colormap(jet);
% colorbar;
indx=1;
figure;
theta=Theta(1,:);
phi=Phi(:,1);
for j=1:5
    indxImg=find(Ytensor_Tr==j);
    for i=1:5
        subplot(5,5,indx);
        %Img_temp(:)=X_te{j}(:,i);
        Img_temp=squeeze(Xtensor_Tr(indxImg(i),1,:,:));
        imagesc(theta,phi,Img_temp),colormap(jet),
        xlabel('theta');
        ylabel('phi');
        indx=indx+1;
    end
end

indx=1;
figure;
for j=1:5
    indxImg=find(Ytensor_Ts==j);
    for i=1:5
        subplot(5,5,indx);
        %Img_temp(:)=X_te{j}(:,i);
        Img_temp=squeeze(Xtensor_Ts(indxImg(i),1,:,:));
        imagesc(theta,phi,Img_temp),colormap(jet),
        xlabel('theta');
        ylabel('phi');
        indx=indx+1;
    end
end



    
    