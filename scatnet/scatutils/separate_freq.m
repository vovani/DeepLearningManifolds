function Z = separate_freq(Y)
	if iscell(Y)
		Z = {};
	
		for m = 0:length(Y)-1
			Z{m+1} = separate_freq(Y{m+1});
		end
		
		return;
	end

	Z.signal = {};
	Z.meta = struct();

	r = 1;
	for k = 1:length(Y.signal)
		if ~iscell(Y.signal{k})
			% because matlab is stupid and ignores last dim if 1
			sz_orig = size(Y.signal{k});
			if numel(sz_orig) == 2
				sz_orig(3) = 1;
			end
		else
			sz_orig = [length(Y.signal{k}) 0 size(Y.signal{k}{1},2)];
		end	
		
		for l = 1:sz_orig(1)
			if ~iscell(Y.signal{k})
				nsignal = Y.signal{k}(l,:);
			else
				nsignal = Y.signal{k}{l};
			end

			nsignal = reshape(nsignal,[numel(nsignal)/sz_orig(3) sz_orig(3)]);

			Z.signal{r} = nsignal;

			r = r+1;
		end
	end

	[temp,I] = sortrows(Y.meta.j(1:size(Y.meta.j,1),:).');
	
	Z.signal = Z.signal(I);
	
	field_names = fieldnames(Y.meta);
	for n = 1:length(field_names)
		src_value = getfield(Y.meta,field_names{n});
		Z.meta = setfield(Z.meta,field_names{n},src_value(:,I));
	end
	
	Z.signal = cellfun(@(x)(permute(x,[1 3 2])), Z.signal, ...
		'UniformOutput', false);
end
