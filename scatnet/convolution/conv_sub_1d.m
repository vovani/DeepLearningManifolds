% CONV_SUB_1D One-dimensional convolution and downsampling.
%
% Usage
%    y_ds = CONV_SUB_1D(xf, filter, ds)
%
% Input
%    xf (numeric): The Fourier transform of the signal to be convolved.
%    filter (*numeric OR struct*): The analysis filter in the frequency
%       domain. Either Fourier transform of the filter or the output of
%       OPTIMIZE_FILTER.
%    ds (int): The downsampling factor as a power of 2 with respect to xf.
%
% Output
%    y_ds (numeric): the filtered, downsampled signal, in the time domain.
%
% Description
%    This function is at the foundation of the wavelet transform in 1D. It
%    performs an element-wise product of a signal and a filter in the
%    frequency domain, equivalent to a convolution in the time domain.
%    The filter argument may either be:
%       * a DFT real vector, or
%       * an optimized filter structure from OPTIMIZE_FILTER
%    In the latter case, different methods are used to speed up the calcula-
%    tion, such as storing the filter at different resolutions or only storing
%    the Fourier transform coefficients that are non-zero. These are obtained
%    when defining the filter bank using the filt_opt.filter_format parameter. 
%    See FILTER_BANK for more information.
%
%    Multiple signals can be convolved in parallel by specifying them as dif-
%    ferent columns of xf. If many signals need to be convolved at the same
%    time, this is often much faster than performing calling CONV_SUB_1D on
%    each signal separately.
%
% See also
%   CONV_SUB_2D, WAVELET_1D

function y_ds = conv_sub_1d(xf, filter, ds)
	sig_length = size(xf,1);

	if isnumeric(filter)
		% simple Fourier transform
		filter_j = [filter(1:sig_length/2); ...
			filter(sig_length/2+1)/2+filter(end-sig_length/2+1)/2; ...
			filter(end-sig_length/2+2:end)];
		yf = bsxfun(@times, xf, filter_j);
	elseif isstruct(filter)
		% optimized filter, output of OPTIMIZE_FILTER
		if strcmp(filter.type,'fourier_multires')
			% periodized multiresolution filter, output of PERIODIZE_FILTER
			yf = bsxfun(@times, xf, filter.coefft{1+log2(filter.N/sig_length)});
		elseif strcmp(filter.type,'fourier_truncated')
			% truncated filter, output of TRUNCATE_FILTER
			start = filter.start;
			coefft = filter.coefft;
			if length(coefft) > sig_length
				% filter is larger than signal, lowpass filter & periodize the former
				% create lowpass filter
				start0 = mod(start-1,filter.N)+1;
				nCoeffts0 = length(coefft);
				if start0+nCoeffts0-1 <= filter.N
					rng = start0+0:nCoeffts0-1;
				else
					rng = [start0:filter.N 1:nCoeffts0+start0-filter.N-1];
				end
				lowpass = zeros(size(coefft));
				lowpass(rng<sig_length/2+1) = 1;
				lowpass(rng==sig_length/2+1) = 1/2;
				lowpass(rng==filter.N-sig_length/2+1) = 1/2;
				lowpass(rng>filter.N-sig_length/2+1) = 1;
				% filter and periodize
				coefft = sum(reshape(coefft.*lowpass,[sig_length length(coefft)/sig_length]),2);
			end
			nCoeffts = length(coefft);
			j = log2(nCoeffts/sig_length);
			start = mod(start-1,size(xf,1))+1;
			if start+nCoeffts-1 <= size(xf,1)
				% filter support contained in one period, no wrap-around
				yf = bsxfun(@times, ...
					xf(start:nCoeffts+start-1,:), coefft);
			else
				% filter support wraps around, extract both parts
				yf = bsxfun(@times, ...
					xf([start:end 1:nCoeffts+start-size(xf,1)-1],:), ...
                    coefft);
			end
		end
	else
		error('Unsupported filter type');
	end
	
	% calculate the downsampling factor with respect to yf
	dsj = ds+log2(size(yf,1)/sig_length);
	if dsj > 0 
		% actually downsample, so periodize in Fourier
		yf_ds = reshape( ...
			sum(reshape(yf,[size(yf,1)/2^dsj 2^dsj size(yf,2)]),2), ...
			[size(yf,1)/2^dsj size(yf,2)]);
	elseif dsj < 0
		% upsample, so zero-pad in Fourier
		% note that this only happens for fourier_truncated filters, since otherwise
		% filter sizes are always the same as the signal size
		% also, we have to do one-sided padding since otherwise we might break 
		% continuity of Fourier transform
		yf_ds = [yf; zeros((2^(-dsj)-1)*size(yf,1),size(yf,2))];
	else
		yf_ds = yf;
	end
	
	if isstruct(filter) && ...
		strcmp(filter.type, 'fourier_truncated') && ...
		filter.recenter
		% result has been shifted in frequency so that the zero fre-
		% quency is actually at -filter.start+1
		yf_ds = circshift(yf_ds, filter.start-1);
	end

	y_ds = ifft(yf_ds)/2^(ds/2);
end
