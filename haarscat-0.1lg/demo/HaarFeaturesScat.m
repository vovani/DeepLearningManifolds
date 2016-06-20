clear; close all;
addpath('C:\dev\DeepLearningManifolds');
addpath('C:\dev\DeepLearningManifolds\scatnet\utils');
addpath('C:\dev\DeepLearningManifolds\libsvm-compact-0.1\matlab');
addpath(genpath('C:\dev\DeepLearningManifolds\haarscat-0.1lg\'));

disp('load HaarFeatures_data4svm')
load HaarFeatures_data4svm

nTrees = 512*2; 
 FBoot=1.0;%=1.0
paroptions = statset('UseParallel',true);%, 'Streams',RandStream.getGlobalStream()

%OOBVarImp - feature importance on/off
TreeBagggerClasifParams={ 'Method','classification','Options',paroptions,...
        'FBoot',FBoot,'OOBVarImp','off','SampleWithReplacement','on',...
        'oobpred','on','MinLeaf',1};
%Crating RF model    
RFModelMethod = @(X,Y)((TreeBagger(nTrees,X,Y,TreeBagggerClasifParams{:})));
%Prediction
RFpredict=@(Model,X)(str2double(Model.predict(X)));

%save('HaarFeatures_data4svm.mat','Feat_Tr', 'TrainLabel', 'Feat_Te', 'TestLabel', 'params','-v7.3');

disp('Train RF model');
model= RFModelMethod(Feat_Tr', TrainLabel(:));
% 
% disp('Save RFmodelHaar');
%  save ('RFmodelHaar', 'model' ,'-v7.3');
 
 disp('OOB error(out-of-the-bag');
oobErr=oobError(model);

% figure,
% bar(model.OOBPermutedPredictorDeltaError);
% title('Features importance');

disp('predict Rot test');
PredTs_rot=RFpredict(model, Feat_Te');
ErrPred_rot=error(model,Feat_Te',TestLabel(:));


