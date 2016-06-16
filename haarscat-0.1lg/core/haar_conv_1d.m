function y = haar_conv_1d(x, filter)
% ----------------------------------------------------------------------------%
% Usage
%    y = HAAR_CONV_1D(x, filter)
%
% Input
%    x : The signal to be convolved.
%    filter: 'h' = (1,1)/sqrt(2) or 'g' = (1, -1)/sqrt(2).
%
% Output
%    y : The filtered, downsampled signal, in the time domain.
%
% Description
%    This function is at the foundation of the Haar scattering transform. 
%    It performs a 1D convolution of a signal and a filter in the 
%    time domain.
%    
%    Multiple signals can be convolved in parallel by specifying them as 
%    different columns of x.
%
% ----------------------------------------------------------------------------%

[n, ~] = size(x);

if mod(n, 2) % odd size, throw the last/most right
    x = x(1:n-1, :);
    n = n-1;
end
% up to this point n is even

switch filter
    case 'h'
        y = x( 1: 2: n-1, :) + x( 2: 2: n,:);      
    case 'g'
        y = x( 1: 2: n-1, :) - x( 2: 2: n,:);
end

y = y/sqrt(2);
%do the global constant division outside

end