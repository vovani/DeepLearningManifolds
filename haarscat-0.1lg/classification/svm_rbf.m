function [acc, varargout] = svm_rbf(TrainData, TrainLabel, TestData, TestLabel, params)

% ----------------------------------------------------------------------------%
% SVM_RBF.m
%
% This function calls LIBSVM to perform multi-class RBF-kernel SVM 
% including parameter selection by cross validation.
%
% Please make sure the LIBSVM toolbox is included in the path.
% For infomation about LIBSVM, refer to: http://www.csie.ntu.edu.tw/~cjlin/libsvm/
%
% Note: In order to distinguish LIBSVM functions from the svm functions in
% the Statistics Toolbox of Matlab, we changed the function names 'svmtrain' 
% and 'svmpredict' to 'libsvmtrain' and 'libsvmpredict'. 
% 
% ----------------------------------------------------------------------------%
% Input: 
% 
% TrainData    - A matrix containing training samples as rows
% TrainLabel   - A column vector containing training labels
%
% TestData     - A matrix containing testing samples as rows
% TestLabel    - A column vector containing testing labels
%
% params (optional) - 'gamma','C'
%
% TrainData and TestData should be scaled to [-1,1] outside this function,
% using the same scaling factor.
% 
% Output:
%
% acc          - Accuracy
% opt_gamma (optional)  - Optimal value of parameter gamma out of cross validation
% opt_C (optional) - Optimal value of parameter C out of cross validation
% ----------------------------------------------------------------------------%

if nargin < 5 % Perform cross validation
    
    cv_NPC = 1000; % choose part of the training set to perform cross validation,
    % set to maximum if using entire training set.
    cv_TrainData = [];
    cv_TrainLabel = [];
    labels = unique(TrainLabel);
    for iclass = 1:length(labels)
        idx_iclass = find(TrainLabel == labels(iclass));
        if length(idx_iclass) > cv_NPC
            idx_tr = randsample(length(idx_iclass),cv_NPC);
            cv_TrainData = [cv_TrainData; TrainData(idx_iclass(idx_tr),:) ];
            cv_TrainLabel = [cv_TrainLabel; TrainLabel(idx_iclass(idx_tr))];
        else
            cv_TrainData = [cv_TrainData; TrainData(idx_iclass,:) ];
            cv_TrainLabel = [cv_TrainLabel; TrainLabel(idx_iclass)];
        end
    end
    
    gamma = 2.^(-15:2:3)';
    C = 2.^(-1:2:15)';
    numcv = 5; % # of cross validation folds
    
    cvAcc = zeros(length(gamma),length(C));
    
    for igamma = 1:length(gamma)
        for iC = 1:length(C)
            svm_opt = sprintf('-t 2 -h 0 -v %d -g %11.9f -c %11.5f', numcv, gamma(igamma), C(iC));
            cvAcc(igamma,iC) = svmtrain(cv_TrainLabel, cv_TrainData, svm_opt);%libsvmtrain
        end
    end
    
    [~,idx_C] = max(max(cvAcc));
    [~,idx_gamma] = max(max(cvAcc,[],2));
    
    opt_C = C(idx_C);
    opt_gamma = gamma(idx_gamma);
    
else
    opt_C = params.C;
    opt_gamma = params.gamma;
end

% SVM

svm_opt = sprintf('-t 2 -h 0 -g %11.9f -c %11.5f', opt_gamma, opt_C);
        
ModelRBF = svmtrain(TrainLabel,TrainData, svm_opt); 

[~, temp, ~] = svmpredict(TestLabel, TestData, ModelRBF);

acc = temp(1);

if nargout == 3
    varargout{1} = opt_C;
    varargout{2} = opt_gamma;
end

if nargout ~= 1 && nargout ~= 3
    error('Wrong number of outputs!');
end
    
    
end