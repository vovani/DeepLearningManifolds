function [s, meta]  = haar_scat_2d_image_grid_multishift(x, N_shift, options)
% ----------------------------------------------------------------------------%
% Compute averaged Haar scattering coefficients over multiple shifts 
% on 2D image grid.
%
% Input:
%   x - A dim1*dim2*N 3D array. N sample images.
%   N_shift - Number of shifts.
%   options - M: Computation up to the scattering order M.
%           - J: Largest scale.
% Output:
%   s - Averaged scattering coefficients, an array of size n_grp * n_path * N, where
%          n_grp = floor(d/2^J), n_path = \sum_0^M \binom{J}{M}. It is a 2D
%          array if either n_grp or n_path is 1.
%   meta - m: n_path*1 array, giving the scattering order of each coefficient.
%        - path: n_path*J array, each row is a scattering path corresponding 
%                to each coefficient.
% ----------------------------------------------------------------------------%

if nargin < 3
    options = struct();
end

[dim1,dim2,N] = size(x);
x = reshape(x, [dim1*dim2, N]);

if N_shift == 1
    
    perm_vec = haar_tree_2d_image_grid(dim1, dim2, options);
    [s, meta] = haar_scat(x, perm_vec, options);
    
else

    if floor(log2(min(dim1, dim2))) < 2
        error('Image size is too small to perform Haar scattering with multiple shifts!');
    end
    
    % For 2D image image grid, J is twice the scale of the side length of a
    % square image.
    options = fill_struct(options, 'J', 2*floor(log2(min(dim1, dim2)))-2);
    options = fill_struct(options, 'M', options.J);
    options = fill_struct(options, 'direction', 'h');
    
    % For 2D image image grid, J is set to be a even number
    if options.J == 1
        options.J = options.J + 1;
    else if mod(options.J,2)
            options.J = options.J - 1;
        end
    end
    
    % If J is too large, set J to the largest possible scale
    if 2^(options.J/2) > min(dim1, dim2)/2
        options.J = 2*floor(log2(min(dim1, dim2)))-2;
    end
    
    % If M is too large, set M=J
    if options.M > options.J
        options.M = options.J;
    end
    
    % If N_shift is too large, set to largest possible number of shifts
    if N_shift > (2^floor(options.J/2))^2
        N_shift = (2^floor(options.J/2))^2;
    end
    
    
    %%% Sample multiple shifts
    tempvec = randsample(2^options.J,N_shift);
    tempmat = reshape((1:2^options.J)', 2^(options.J/2), 2^(options.J/2));
    shift_offset = zeros(N_shift,2);
    for ishift = 1:N_shift
        [shift_offset(ishift,1),shift_offset(ishift,2)] = find(tempmat == tempvec(ishift));
    end
    
    %%% Compute average Haar Scattering
    idx_vec = reshape((1:dim1*dim2)', dim1, dim2);
    % The effective computing area is the largest area that covers an integer number of
    % the scattering scale and allows an extra scale for multiple shifts.
    d1 = 2^(options.J/2)*floor(dim1/2^(options.J/2));
    d1 = d1-2^(options.J/2);
    d2 = 2^(options.J/2)*floor(dim2/2^(options.J/2));
    d2 = d2-2^(options.J/2);
    coord_list = scan_coord(d1, d2, options);
    s = [];
    for ishift = 1:N_shift
        perm_vec = zeros(d1*d2,1);
        for i = 1:d1*d2
            perm_vec(i) = idx_vec(coord_list(i,1)+shift_offset(ishift,1),...
                coord_list(i,2)+shift_offset(ishift,2));
        end
        [ss, meta] = haar_scat(x, perm_vec, options);
        s = cat(length(size(ss))+1,s,ss);
    end
    s = mean(s,length(size(ss))+1);
end


end
