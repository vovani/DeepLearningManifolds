function idx_order = reorder_feat(temp_bint)

nLevel = size(temp_bint,1);
tool_vec = (1:size(temp_bint,2))';
for iL = nLevel:-1:2
    grp_val = unique(temp_bint(iL,:));
    ngrp = length(grp_val);
    for igrp = 1:ngrp
        temp_ind = find(temp_bint(iL,:) == grp_val(igrp));
        [~,ind_sort] = sort(temp_bint(iL-1,temp_ind));
        
        temp_bint(1:iL-1,temp_ind) = temp_bint(1:iL-1,temp_ind(ind_sort));
        tool_vec(temp_ind) = tool_vec(temp_ind(ind_sort));
    end
end

idx_order = tool_vec;

end