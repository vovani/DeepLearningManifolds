clear;
close all;
add_paths;

num_train_images = 100000 ;
num_test_images = 100000 ;

N = 64;
[theta, phi] = nsht_sampling_points(N);

for i = 0:N-1
    theta_indecies(i^2 +1: (i+1)^2) = i + 1;
end

theta = theta(theta_indecies);
dirs = [phi; theta]';
S=zeros(3,size(dirs,1));
[S(1,:),S(2,:),S(3,:)]=sph2cart(dirs(:,1), dirs(:,2) - pi/2,ones(size(dirs,1),1)); 
 
train_options.mode='mild';
test_options.mode='uniform';
[Xtr, Ctr, ~, ~] = read_mnist_sphere('.', S,train_options);
[~, ~, Xte, Cte] = read_mnist_sphere('.', S,test_options);

% save SphericalMNIStuniform_nshtGrid2.mat Xtr Ctr Xte Cte -v7.3;
 
s_tr = cellfun(@(c) min( num_train_images, size(c,2)), Xtr);
train_labels = arrayfun(@(x, i) i*ones(1,x), s_tr', 1:length(Xtr), 'UniformOutput', false);
train_labels = cell2mat(train_labels);
train_labels = train_labels(:);
features = cell(1, length(Xtr));
parfor i = 1 : length(Xtr)
    digits = Xtr{i};
    for img = 1 : min( num_train_images, size(digits,2) )
        features{i}(img, :) = band_energy(N - 1, nsht_forward(digits(:, img)', N));
    end
end
features = cell2mat(features.');

save mnist_train_features features -v7.3

disp('Load data');
load mnist_train_features
nTrees = 300; 
FBoot=0.75;%=1.0
paroptions = statset('UseParallel',true);%, 'Streams',RandStream.getGlobalStream()

%============CLASSSIFICATION
%RF parameters 
%OOBVarImp - feature importance on/off
TreeBagggerClasifParams={ 'Method','classification','Options',paroptions,...
        'FBoot',FBoot,'OOBVarImp','On','SampleWithReplacement','on',...
        'oobpred','on','MinLeaf',1};
%Crating RF model    
RFModelMethod = @(X,Y)((TreeBagger(nTrees,X,Y,TreeBagggerClasifParams{:})));
%Prediction
RFpredict=@(Model,X)(str2double(Model.predict(X)));

disp('prediction')
model= RFModelMethod(features, train_labels);

s_te = cellfun(@(c) min( num_test_images, size(c,2)), Xte);
test_labels = arrayfun(@(x, i) i*ones(1,x), s_te', 1:length(Xte), 'UniformOutput', false);
test_labels = cell2mat(test_labels);
test_labels = test_labels(:);
featuresTs = cell(1, length(Xte));

parfor i = 1:length(Xte)
    digits = Xte{i};
    for img = 1:s_te(i)
        featuresTs{i}(img,:) = band_energy(N - 1, nsht_forward(digits(:,img)', N));
    end
end
featuresTs = cell2mat(featuresTs.');

%disp('Save features')
save mnist_train_features features featuresTs test_labels train_labels model  -v7.3

disp('Classification error'); 
ErrTs=error(model,featuresTs,test_labels);

test_labels_pred=RFpredict(model,featuresTs);
%Classification confusion matrix
[c,order] = confusionmat(test_labels,test_labels_pred);

%plotconfusion(test_labels,test_labels_pred);


%Classification error 
%ErrTr=error(model,features,train_labels);

fprintf('acc = %f\n', 100*(1-ErrTs(end)));

%OOB error(out-of-the-bag)
oobErr=oobError(model);

figure,
bar(model.OOBPermutedPredictorDeltaError);
title('Features importance');

figure,
plot(oobErr);
hold on;
plot(ErrTs);
hold off;
legend('out-of-the-bag','Testing Error');
title('Perfomance');

