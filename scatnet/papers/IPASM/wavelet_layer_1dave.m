% WAVELET_LAYER_1D Compute the one-dimensional wavelet transform from
% the modulus wavelet coefficients of the previous layer.
%
% Usages
%    [U_phi , U_psi] = wavelet_layer_1d(U, filters)
%
%    [U_phi , U_psi] = wavelet_layer_1d(U, filters, scat_opt)
%
%    [U_phi , U_psi] = wavelet_layer_1d(U, filters, scat_opt, wavelet)
%
% Input
%    U (struct): The input layer to be transformed.
%    filters (cell): The filters of the wavelet transform.
%    scat_opt (struct): The options that are transferred to the wavelet
%    function handle.
%    wavelet (function handle): the wavelet transform function (default is
%    @wavelet_1d).  
%
% Output
%    U_phi The coefficients of in, lowpass-filtered (scattering
%       coefficients).
%    U_psi: The wavelet transform coefficients.
%
% Description
%    This function has a pivotal role between WAVELET_1D (which computes a
%    single wavelet transform), and WAVELET_FACTORY_1D (which creates the
%    whole cascade). Given inputs modulus wavelet coefficients
%    corresponding to a layer, WAVELET_LAYER_1D computes the wavelet
%    transform coefficients of the next layer using WAVELET_1D. 
% See also
%   WAVELET_1D, WAVELET_FACTORY_1D, WAVELET_LAYER_2D

function [U_phi, U_psi] = wavelet_layer_1dave(U, filters, scat_opt, wavelet)
	if nargin < 3
		scat_opt = struct();
	end
	
	if nargin < 4
		wavelet = @wavelet_1d;
	end
	
	calc_U = (nargout>=2);

	[psi_xi,psi_bw,phi_bw] = filter_freq(filters.meta);
	
	if ~isfield(U.meta, 'bandwidth'), U.meta.bandwidth = 2*pi; end
	if ~isfield(U.meta, 'resolution'), U.meta.resolution = 0; end
	
	U_phi.signal = {};
	U_phi.meta.bandwidth = [];
	U_phi.meta.resolution = [];
	U_phi.meta.j = zeros(size(U.meta.j,1),0);
	
	U_psi.signal = {};
	U_psi.meta.bandwidth = [];
	U_psi.meta.resolution = [];
	U_psi.meta.j = zeros(size(U.meta.j,1)+1,0);
	
	r = 1;
	for p1 = 1:length(U.signal)
		psi_mask = calc_U&(U.meta.bandwidth(p1)>psi_xi);
		
		scat_opt.x_resolution = U.meta.resolution(p1);
		scat_opt.psi_mask = psi_mask;
		[x_phi, x_psi, meta_phi, meta_psi] = ...
			wavelet(U.signal{p1}, filters, scat_opt);
		
		U_phi.signal{1,p1} = mean(U.signal{p1}(:));
		U_phi.meta = map_meta(U.meta,p1,U_phi.meta,p1);
		U_phi.meta.bandwidth(1,p1) = meta_phi.bandwidth;
		U_phi.meta.resolution(1,p1) = meta_phi.resolution;
		
		ind = r:r+sum(psi_mask)-1;
		U_psi.signal(1,ind) = x_psi(1,psi_mask);
		U_psi.meta = map_meta(U.meta,p1,U_psi.meta,ind,{'j'});
		U_psi.meta.bandwidth(1,ind) = meta_psi.bandwidth(1,psi_mask);
		U_psi.meta.resolution(1,ind) = meta_psi.resolution(1,psi_mask);
		U_psi.meta.j(:,ind) = [U.meta.j(:,p1)*ones(1,length(ind)); ...
			meta_psi.j(1,psi_mask)];
			
		r = r+length(ind);
	end
end
