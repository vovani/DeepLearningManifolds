function [s, meta] = haar_scat(x, perm_vec, options)

% ----------------------------------------------------------------------------%
% Compute Haar scattering coefficients given data and a permutation vector.
%
% Usage
%   [s, meta] = haar_scat(x, perm_vec, options)
%
% Input
%   x - A d*N array. Each col is a data sample.
%   perm_vec - Permutation vector.
%   options - M: Computation up to the scattering order M.
%           - J: Largest scale.
% Output
%   s - Scattering coefficients, an array of size n_grp * n_path * N, where
%          n_grp = floor(d/2^J), n_path = \sum_0^M \binom{J}{M}. It is a 2D
%          array if either n_grp or n_path is 1.
%   meta - m: n_path*1 array, giving the scattering order of each coefficient.
%        - path: n_path*J array, each row is a scattering path corresponding 
%                to each coefficient.
% ----------------------------------------------------------------------------%


if nargin < 3
    options = struct();
end

[Q,N] = size(x);

options = fill_struct(options, 'J', floor(log2(Q)));
options = fill_struct(options, 'M', options.J);

x = x(perm_vec,:);
Q = length(perm_vec);

s_pre = reshape(x,[Q,1,N]);
for j = 1:options.J
   
    % At each layer: 1 <= n <= Q/2^j, 1 <= q <= 2^j
   s = zeros(Q/2^j,2^j,N);
   order = zeros(2^j,j);
   
   [~, n_path, ~] = size(s_pre);
   for q = 1:n_path
       s(:,2*q-1,:) = haar_conv_1d(s_pre(:,q,:), 'h');
       s(:,2*q,:) = abs(haar_conv_1d(s_pre(:,q,:), 'g'));
       if j == 1
           order(2*q-1,:) = 0;
           order(2*q,:) = 1;
       else
           order(2*q-1,:) = [order_pre(q,:) 0];
           order(2*q,:) = [order_pre(q,:) 1];
       end
   end
   
   s_pre = s;
   order_pre = order;
end

meta.path = (-1) * ones(size(order));
for q = 1:size(order,1)
    temp = find(order(q,:) == 1);
    meta.path(q,1:length(temp)) = temp;
end

meta.m = sum(meta.path > 0,2);

s = squeeze(s(:,meta.m <= options.M,:));
meta.m = meta.m(meta.m <= options.M);
meta.path = meta.path(meta.m <= options.M, 1:options.M);


end