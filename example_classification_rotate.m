clear;
close all;
add_paths;

addpath('C:\Data\MNIST');

% disp('Load Raw mnist data');
% raw_train_images = loadMNISTImages('train-images.idx3-ubyte');
 train_labels = loadMNISTLabels('train-labels.idx1-ubyte');
% raw_test_images = loadMNISTImages('t10k-images.idx3-ubyte');
test_labels = loadMNISTLabels('t10k-labels.idx1-ubyte');

% test_labels(test_labels == 9) = 6;
% train_labels(train_labels == 9) = 6;

% num_train_images = size(raw_train_images, 2);
% num_test_images = size(raw_test_images, 2);

N = 32;

% train_img = cell(1, num_train_images);
% parfor i = 1:num_train_images
%     train_img{i} = project_on_sphere(padarray(reshape(raw_train_images(:,i), 28, 28), [18 18]));
% end

%save('ProjectedMNISTtrain','train_img','train_labels','-v7.3');
 disp('Load ProjectedMNISTtrain');
  load ProjectedMNISTtrain

num_train_images = length(train_labels);
% 
sh_fourier = cell(1, num_train_images);
U = cell(1, num_train_images);
S = cell(1, num_train_images);

filt_opt = default_filter_options('dyadic', 2 * N);
filt_opt.Q =[8 4]; %[4 2];
filt_opt.boundary = 'nonsymm';
filt_opt.fliter_type = 'gabor_1d';
filters = filter_bank(N + 1, filt_opt);

Y = getSH(N, train_img{1}.dirs, 'complex');
Npoints = size(train_img{1}.dirs, 1);

% for i = 1 : num_train_images
%     sh_fourier{i} = sh_image(train_img{i}.dirs, (4 * pi / Npoints) * Y' * train_img{i}.values);
%     [U{i}, S{i},meta{i}] = scat2(filters, Y, sh_fourier{i});
% end

disp('Calc of scat moments for ror tr images')
[featuresTr] = ...
    ScatSphericalMomonets( train_img,filters,Y );

save mnist_train_features_all featuresTr Y  filters filt_opt

%disp('Load mnist_train_features'); 
%load mnist_train_features_all
% 
% 
% load mnist_train_features
 num_train_images = length(train_labels);

featuresTr = cell2mat(cellfun(@(X)cell2mat(X),Str,'UniformOutput', false)');

% %featuresTr=sqrt(featuresTr);
 nTrees = 300; 
 FBoot=0.75;%=1.0
paroptions = statset('UseParallel',true);%, 'Streams',RandStream.getGlobalStream()
% 
% %============CLASSSIFICATION
%RF parameters 
%OOBVarImp - feature importance on/off
TreeBagggerClasifParams={ 'Method','classification','Options',paroptions,...
        'FBoot',FBoot,'OOBVarImp','On','SampleWithReplacement','on',...
        'oobpred','on','MinLeaf',1};
%Crating RF model    
RFModelMethod = @(X,Y)((TreeBagger(nTrees,X,Y,TreeBagggerClasifParams{:})));
%Prediction
RFpredict=@(Model,X)(str2double(Model.predict(X)));

disp('Train RF model');
model= RFModelMethod(featuresTr, train_labels(:));
% 
disp('Save RFmodelALL');
 save ('RFmodelALL', 'model' ,'-v7.3')
%disp('load RFmodel');
%load RFmodelALL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%TESTING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test_imgs = cell(1,num_test_images);
% parfor i = 1:num_test_images
%     test_imgs{i} = project_on_sphere(padarray(reshape(raw_test_images(:,i), 28, 28), [18 18]));
% end
% save('ProjectedMNISTtest','test_imgs','test_labels','-v7.3');
% disp('load ProjectedMNISTtest');
% load ProjectedMNISTtest

num_test_images=length(test_labels);

% disp('Calculate Scat monets for testing data')
% Sts = ScatSphericalMomonets( test_imgs,filters,Y );
% save('mnist_test_features','Sts');
% disp('load mnist_test_features');
% load mnist_test_features;
% featuresTs = cell2mat(cellfun(@(X)cell2mat(X),Sts,'UniformOutput', false)'); 

% 
% %featuresTs=sqrt(featuresTs);
% disp('predict for testing data');
% PredTs=RFpredict(model, featuresTs);
% ErrPred=error(model,featuresTs,test_labels);
% accPred=mean(PredTs == test_labels(1:num_test_images));
disp('OOB error(out-of-the-bag');
oobErr=oobError(model);

figure,
bar(model.OOBPermutedPredictorDeltaError);
title('Features importance');
% 
% [PcaComp,featuresTr_pca,eigVal] = pca(featuresTr);

%fprintf('acc = %f\n', nnz(pred == test_labels(1:num_test_images)) / num_test_images);

%%%%%%%%%%%%%%%%RandomRotImgs%%%%%
% disp('random rotations testing images')
% test_imgs_rot=cell(num_test_images,1);
% parfor i = 1:num_test_images  
%     alpha=2*pi*rand();
%     beta=pi*rand();
%     gamma=2*pi*rand();
%     test_imgs_rot{i} = test_imgs{i}.rotate(alpha,beta,gamma);
% end
%  save('ProjectedMNISTtestRot','test_imgs_rot','test_labels','-v7.3');
disp('load ProjectedMNISTtestRot');
 load ProjectedMNISTtestRot
% 
disp('Calc of scat moments for ror ts images')
[Sts_rot,Uts_rot,sh_fourierTs_rot,metaTs_rot] = ...
    ScatSphericalMomonets( test_imgs_rot,filters,Y );
% S,U, sh_fourier,meta 
disp('save mnist_test_Rot_features_all');
 save('mnist_test_Rot_features_all','Sts_rot','Uts_rot','sh_fourierTs_rot','metaTs_rot','-v7.3');
%load mnist_test_Rot_features Sts_rot
featuresTs_rot =  cell2mat(cellfun(@(X)cell2mat(X),Sts_rot,'UniformOutput', false)');

disp('predict Rot test');
PredTs_rot=RFpredict(model, featuresTs_rot);
ErrPred_rot=error(model,featuresTs_rot,test_labels);

