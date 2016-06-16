function coord_list = scan_coord(dim1, dim2, options)

% dim1 and dim2 are both multiples of 2^(J/2)
if nargin < 3
    options = struct(); 
end

if mod(dim1,2) || mod(dim2,2)
    error('dim1 and dim2 have to be even numbers!');
else
    maxJ = 2;
    while ~mod(dim1,2^(maxJ/2)) && ~mod(dim2,2^(maxJ/2))
        maxJ = maxJ + 2;
    end
    maxJ = maxJ-2;
end

options = fill_struct(options, 'direction', 'h');
options = fill_struct(options, 'J', maxJ);

if mod(dim1,2^(options.J/2)) ||  mod(dim2,2^(options.J/2))
    error('dim1 and dim2 have to be multiples of 2^(J/2)!');
end

dim = 2^(options.J/2);
cl = scan_coord_sqr(dim, options);
coord_list = [];
for i = 1: dim1/dim
    for j = 1:dim2/dim
        temp_cl(:,1) = cl(:,1) + (i-1)*dim;
        temp_cl(:,2) = cl(:,2) + (j-1)*dim;
        coord_list = [coord_list; temp_cl];
    end
end


end