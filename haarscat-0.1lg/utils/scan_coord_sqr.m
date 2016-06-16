function coord_list = scan_coord_sqr(dim, options)

% dim is a power of 2.

if nargin < 2
    options = struct(); 
end

options = fill_struct(options, 'direction', 'h');

if dim == 1
    coord_list = [1 1];
else
    sub_dim = dim/2;

    % 1-1 block
    sub_list_11 = scan_coord_sqr(sub_dim, options); 
    % 1-2 block
    sub_list_12 =  [sub_list_11(:,1) sub_list_11(:,2)+sub_dim];
    % 2-1 block
    sub_list_21 =  [sub_list_11(:,1)+sub_dim sub_list_11(:,2)];
    % 2-2 block
    sub_list_22 =  sub_list_11+sub_dim;
    
    switch options.direction
        case 'h'
            coord_list = [sub_list_11;sub_list_12;sub_list_21;sub_list_22];
        case 'v'
            coord_list = [sub_list_11;sub_list_21;sub_list_12;sub_list_22];
    end
end
    

end