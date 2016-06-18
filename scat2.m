function [ U, S,meta ] = scat2( filters, Y, img )
    U{1}.signal{1} = img.values;
    U{1}.bw = [0];
   
    Npoints = size(img.dirs,1);
    
    for m = 1 : numel(filters)
        layers_filters = filters{m};
        num_filters = numel(layers_filters.psi.filter);
        [a, U{m + 1}.bw, a_] = filter_freq(layers_filters.meta);
        for i = 1 : num_filters
            filter = layers_filters.psi.filter{i};
            for j = 1 : numel(U{m}.signal)
                idx = i * numel(U{m}.signal) + j - 1;
                if U{m}.bw(j) <= U{m + 1}.bw(i)
                    filtered = sphConvolution(U{m}.signal{j}, realize_filter(filter));
                    S{m}(idx) = sum(abs(filtered).^2);
                    meta{m,idx}.m=m;
                    meta{m,idx}.psi_scale=i;
                    meta{m,idx}.prev_scale=j;
                    if m ~= num_filters
                        f = Y' * abs(Y * filtered);
                        U{m + 1}.signal{idx} = (4*pi/Npoints) .* f;
                    end
                end
            end
        end
    end
end

