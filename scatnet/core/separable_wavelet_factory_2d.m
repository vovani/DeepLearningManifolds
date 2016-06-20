function cascade = separable_wavelet_factory_2d(N, filter_options, scat_options, M)
	filters{1} = filter_bank(N(1),filter_options{1});
	filters{2} = filter_bank(N(2),filter_options{2});
	
	for m = 0:M
		filt1_ind = min(numel(filters{1}), m+1);
		filt2_ind = min(numel(filters{2}), m+1);
		cascade{m+1} = @(X)(separable_wavelet_layer_2d(X, ...
			{filters{1}{filt1_ind} filters{2}{filt2_ind}}, scat_options));
	end
end