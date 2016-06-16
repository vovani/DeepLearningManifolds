function [Feat_Tr, Feat_Te, meta] = pls_multiclass( Data_Tr, Data_Te, Labels_Tr, K, D)
% concatenate K groups of features
%
% input: 
%       Data_Tr         p-by-NTr, original representation of training data
%       Data_Te         p-by-NTe
%       Labels_Tr       1-by-NTr, labels of training data, taking values 1, ..., K
%       K               number of class
%       D               intended reduced dimension per-class
%
% output:
%       Feat_Tr         Dall-by-NTr, Representation in reduced dimension,
%                           Dall is the total number of nonrepetitive
%                           selected indeces
%       Feat_Te         Dall-by-NTe
%       meta.D          dimension per-class
%
% OLS (Parital Least Square) supervised dimension reduction for K-classes
%
% train the selected subspace for each class in one-vs-all mode, and
% concatenate the features
%

[p, NTr] = size( Data_Tr);
NTe = size( Data_Te, 2);


% OLS per class 

meta.select_index = cell(1,K);

Feat_Tr = zeros( K*D, NTr);
Feat_Te = zeros( K*D, NTe);


%for icls = 1: K
for icls = 1: K %not include the last class which gives linearly dependent features
    
    fprintf('PLS processing class %d:', icls);
    
    %%% linear regression: y = X * beta
     
    xtr = Data_Tr.'; % training data, N-by-p
    xte = Data_Te.'; %test data
    
    y = zeros( NTr, 1); y( Labels_Tr == icls ) = 1; %training label, N-by-1
    
    %%% firstly select the bias term/the constant feature, equivalently remove the mean per-coordinate
    %xtr1 = bsxfun( @minus, xtr, mean( xtr, 1));
    xtr1 = xtr;
    
    %%% OLS on training data to learn the selected D indeces
    atom_ind = ols( y, xtr1, D);
    if numel( atom_ind) < D
        warning(sprintf('selected %d dimensions only.', numel( atom_ind) ));
        pause();
    end
    
    meta.select_index{icls} = atom_ind;

    % The new representation is the Q_tr so that Q_tr*R_tr = (X_tr|_selected)
    % thus, Q_te = (X_te|_selected) * inv(R_tr)
    [Q,R] = qr( xtr(:, atom_ind), 0); %if N > D, then Q is N-by-D, and R is D-by-D


    Q_tr = Q;
    Q_te = xte(:, atom_ind)/R;

    Feat_Tr( D*(icls-1)+1: D*icls, :) = Q_tr';
    Feat_Te( D*(icls-1)+1: D*icls, :) = Q_te.';

end


