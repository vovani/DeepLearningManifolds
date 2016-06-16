function perm_vec = haar_tree_learn(x, options)

% ----------------------------------------------------------------------------%
% Generate binary feature tree from Haar scattering
%
% Input:
%   x - A d*N array. Each col is a data sample.
%   options - pnorm: the norm used to compute the distance.
%           - J: the largest scale.
% Output:
%   perm_vec - Permutation vector, indicating the binary tree structure
%              learnt from pairing, up to a "left/right" switch at each 
%              bifurcation.
% ----------------------------------------------------------------------------%

if nargin < 2
    options = struct();
end

[Q,~] = size(x);

options = fill_struct(options, 'pnorm', 1);
options = fill_struct(options, 'J', floor(log2(Q)));

nLevel = options.J + 1;
BinT_feat = zeros(nLevel, Q);

BinT_feat(1,:) = 1:Q;
for iL = 2:nLevel
    
    % Computing distance between groups
    d = zeros(Q , Q);
    for i =1 :Q
        for j= i+1:Q
            Gi = x(BinT_feat(iL-1,:) == i,:);
            Gj = x(BinT_feat(iL-1,:) == j,:);
            Gdiff = Gi-Gj;
            switch options.pnorm
                case 1
                    d(i,j) = sum(sqrt(sum(abs(Gdiff).^2,1))); % l2-l1-l1
                case 2
                    d(i,j) = sum(sum(abs(Gdiff))); % l1-l1-l1
            end
        end
    end

    maxd = max(max(d));
    C = maxd + 1;
    W = C - d;
    
    % Pairing
    mate = max_wmatch( W );
    
    ind_rm = find(mate == 0);
    
    mate = [(1:Q)' mate];
    mate(ind_rm,:) = [];
  
    mate = sort(mate,2,'ascend');
    mate = unique(mate,'rows');
    
    % Filling in current level of tree
    for ipair = 1:size(mate,1)
        temp = BinT_feat(iL-1,:);
        BinT_feat(iL, temp == mate(ipair,1)) = ipair;
        BinT_feat(iL, temp == mate(ipair,2)) = ipair;
    end
    
    % Preparing data for next level
    
    tempmat = zeros(size(x));
    for ipair = 1:size(mate,1)
        idc_1 = find(BinT_feat(iL-1,:) == mate(ipair,1));
        idc_2 = find(BinT_feat(iL-1,:) == mate(ipair,2));
        
        idx_order1 = reorder_feat(BinT_feat(1:iL-1,idc_1));
        idx_order2 = reorder_feat(BinT_feat(1:iL-1,idc_2));
        
        idc_1 = idc_1(idx_order1);
        idc_2 = idc_2(idx_order2);
        
        tempmat(idc_1,:) = (x(idc_1,:) + x(idc_2,:))/sqrt(2);
        tempmat(idc_2,:) = abs(x(idc_1,:) - x(idc_2,:))/sqrt(2);
        
    end
    x = tempmat;
    
    if isempty(ind_rm)
        Q = Q/2;
    else
        Q = (Q-1)/2;
    end
        
end

ind_nzr = find(BinT_feat(nLevel,:) > 0);
ngrp = length(unique(BinT_feat(nLevel,ind_nzr)));
perm_vec = [];
for igrp = 1:ngrp
    idc = find(BinT_feat(nLevel,:) == igrp);
    idx_order = reorder_feat(BinT_feat(1:nLevel,idc));
    perm_vec = [perm_vec; idc(idx_order)'];
end


end

