function perm_vec = haar_tree_2d_image_grid(dim1, dim2, options)

% ----------------------------------------------------------------------------%
% Generate binary feature tree from Haar scattering
%
% Input:
%   dim1, dim2 - the dimension of an image grid
%   options - direction: the direction of the initial pairing,
%                   'h' (horizontal) or 'v' (vertical).
%
% Output:
%   perm_vec - Permutation vector, indicating the binary tree structure
%              from a 2d image grid.
% ----------------------------------------------------------------------------%

if nargin < 3
    options = struct(); 
end

% For 2D image image grid, J is twice the scale of the side length of a
% square image.
options = fill_struct(options, 'J', 2*floor(log2(min(dim1, dim2))));
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
if 2^(options.J/2) > min(dim1, dim2)
    options.J = 2*floor(log2(min(dim1, dim2)));
end

% If M is too large, set M=J
if options.M > options.J
    options.M = options.J;
end


idx_vec = reshape((1:dim1*dim2)', dim1, dim2);

% The effective computing area is the largest area that covers an integer number of 
% the scattering scale.
d1 = 2^(options.J/2)*floor(dim1/2^(options.J/2));
d2 = 2^(options.J/2)*floor(dim2/2^(options.J/2));

coord_list = scan_coord(d1, d2, options);

perm_vec = zeros(d1*d2,1);
for i = 1:d1*d2
    perm_vec(i) = idx_vec(coord_list(i,1),coord_list(i,2));
end


end