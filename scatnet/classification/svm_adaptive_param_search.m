% SVM_ADAPTIVE_PARAM_SEARCH Adaptive parameter search for SVM classifier
%
% Usage
%    [err, C, gamma] = SVM_ADAPTIVE_PARAM_SEARCH(db, train_set, valid_set, ...
%       options)
%
% Input
%    db (struct): The database containing the feature vector.
%    train_set (int): The object indices of the training instances.
%    valid_set (int): The object indices of the validation instances.
%    options (struct): The training options passed to svm_train.
%
% Output
%    err (cell): Cell array of errors for the parameters tested at each depth.
%    C (cell): Cell array of slack factors tested at each depth.
%    gamma (cell): Cell array of gammas tested (for Gaussian kernel) for each 
%       depth.
%
% Description
%    Instead of performing a single grid search over a range of parameters,
%    as svm_param_search does, svm_adaptive_param_search refines the parameter
%    grid a set number of times (given by options.search_depth). At each 
%    iterations, the errors and parameter sets are stored in the cell arrays
%    err, C, gamma. The final, finest, grid is therefore contained in 
%    err{end}, C{end} and gamma{end}.
%
% See also
%   SVM_PARAM_SEARCH, SVM_TRAIN, SVM_TEST

function [err,C,gamma] = svm_adaptive_param_search(db,train_set,valid_set,opt)
	opt = fill_struct(opt,'gamma',1e-4);
	opt = fill_struct(opt,'C',8);
	opt = fill_struct(opt,'search_depth',2);
    
	gamma0 = opt.gamma;
	C0 = opt.C;

	for k = 1:opt.search_depth
		[err{k},C{k},gamma{k}] = svm_param_search(db,train_set,valid_set,opt);
	
		[temp,ind] = min(mean(err{k},2));
		
		if length(C0) > 1
			step = exp(1/2*mean(log(C0(2:end))-log(C0(1:end-1))));
			C0 = [step^(-1) 1 step]*C{k}(ind);
		end
		
		if length(gamma0) > 1
			step = exp(1/2*mean(log(gamma0(2:end))-log(gamma0(1:end-1))));
			gamma0 = [step^(-1) 1 step]*gamma{k}(ind);
		end

		opt.C = C0;
		opt.gamma = gamma0;
	end
end
