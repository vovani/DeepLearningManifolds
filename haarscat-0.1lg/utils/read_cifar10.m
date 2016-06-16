function [X_tr_yuv, X_te_yuv] = read_cifar10(path_to_cifar)

NClass = 10;

X_tr = cell(NClass,1);
for iclass = 1:NClass
    X_tr{iclass} = [];
end

for ifile  = 1:5
    filename = strcat(path_to_cifar,'data_batch_',num2str(ifile),'.mat');
    load(filename);
    labels = labels + 1;
    for iclass = 1:NClass
        X_tr{iclass} = [X_tr{iclass} data(labels == iclass,:)'];
    end
end

X_te = cell(NClass,1);
load(strcat(path_to_cifar,'test_batch.mat'));
labels = labels + 1;
for iclass = 1:NClass
    X_te{iclass} = data(labels == iclass,:)';
end


% Change images to YUV space

X_te_yuv = cell(NClass,1);
for iclass = 1:NClass
    iclass
    X_te_yuv{iclass} = zeros(3072,size(X_te{iclass},2));
    for i = 1: size(X_te{iclass},2)
        temp = X_te{iclass}(:,i);
        temp = reshape(temp,[1024 3]);
        temp = reshape(temp, [32 32 3]);
        temp = permute(temp, [2 1 3]);
        temp = rgb2ycbcr(temp);
        temp = reshape(temp,[1024 3]);
        X_te_yuv{iclass}(:,i) = temp(:);
    end
end

X_tr_yuv = cell(NClass,1);
for iclass = 1:NClass
    iclass
    X_tr_yuv{iclass} = zeros(3072,size(X_tr{iclass},2));
    for i = 1: size(X_tr{iclass},2)
        temp = X_tr{iclass}(:,i);
        temp = reshape(temp,[1024,3]);
        temp = reshape(temp, [32 32 3]);
        temp = permute(temp, [2 1 3]);
        temp = rgb2ycbcr(temp);
        temp = reshape(temp,[1024,3]);
        X_tr_yuv{iclass}(:,i) = temp(:);
    end
end

end
