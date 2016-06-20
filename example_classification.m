clear;
close all;
add_paths;

raw_train_images = loadMNISTImages('train-images.idx3-ubyte');
train_labels = loadMNISTLabels('train-labels.idx1-ubyte');
raw_test_images = loadMNISTImages('t10k-images.idx3-ubyte');
test_labels = loadMNISTLabels('t10k-labels.idx1-ubyte');

test_labels(test_labels == 9) = 6;
train_labels(train_labels == 9) = 6;

num_train_images = size(raw_train_images, 2);
num_test_images = size(raw_test_images, 2);

N = 32;

train_img = cell(1, num_train_images);
parfor i = 1:num_train_images
    train_img{i} = project_on_sphere(padarray(reshape(raw_train_images(:,i), 28, 28), [18 18]));
end

sh_fourier = cell(1, num_train_images);
U = cell(1, num_train_images);
S = cell(1, num_train_images);

filt_opt = default_filter_options('dyadic', 2 * N);
filt_opt.Q = [2 1];
filt_opt.boundary = 'nonsymm';
filt_opt.fliter_type = 'gabor_1d';
filters = filter_bank(N + 1, filt_opt);

Y = getSH(N, train_img{1}.dirs, 'complex');
Npoints = size(train_img{1}.dirs, 1);

parfor i = 1 : num_train_images
    sh_fourier{i} = sh_image(train_img{i}.dirs, (4 * pi / Npoints) * Y' * train_img{i}.values);
    [U{i}, S{i}] = scat2(filters, Y, sh_fourier{i});
end

save mnist_train_features S

features = zeros(numel(S), 47);
for i = 1:numel(S)
    features(i,:) = [S{i}{1} S{i}{2}];
end

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

model= RFModelMethod(features, train_labels(1:numel(S)));

test_imgs = cell(1,num_test_images);
pred = zeros(num_test_images,1);
parfor i = 1:num_test_images
    test_imgs{i} = project_on_sphere(padarray(reshape(raw_test_images(:,i), 28, 28), [18 18]));
    sh_fourier = sh_image(test_imgs{i}.dirs, (4 * pi / Npoints) * Y' * test_imgs{i}.values);
    [u, s] = scat2(filters, Y, sh_fourier);
    pred(i) = RFpredict(model, [s{1} s{2}]);
end

fprintf('acc = %f\n', nnz(pred == test_labels(1:num_test_images)) / num_test_images);

