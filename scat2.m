function [ U, S ] = scat2( filters, N, img )
    U{1}.signal{1} = img.values;
    U{1}.bw = [0];
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
                    if m ~= num_filters
                        ifiltered = abs(inverseSHT(filtered, img.dirs, 'complex'));
                        U{m + 1}.signal{idx} = directSHT(N, ifiltered, img.dirs, 'complex');
                    end
                end
            end
        end
    end
end

