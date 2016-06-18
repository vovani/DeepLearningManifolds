function [ filtered ] = apply_filter( filter, sh_fourier)
%APPLY_FILTER Summary of this function goes here
%   Detailed explanation goes here

convolved = sphConvolution(sh_fourier.values, filter);
filtered = sh_image(sh_fourier.dirs, ...
                    inverseSHT(convolved, sh_fourier.dirs, 'complex'));
end

