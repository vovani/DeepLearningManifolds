function [ filtered ] = apply_filter( filter, sh_fourier, sh_dirs )
%APPLY_FILTER Summary of this function goes here
%   Detailed explanation goes here

convolved = sphConvolution(sh_fourier, [zeros(filter.start, 1); filter.coefft]);
filtered = inverseSHT(convolved, sh_dirs, 'complex');

end

