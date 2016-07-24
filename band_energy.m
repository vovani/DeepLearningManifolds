function [ energy ] = band_energy( N, coeffs )
    band_width = 2 * (0:N) + 1;
    energy = zeros(1, N + 1);
    
    start = 1;
    for i = 1:(N+1)
        energy(i) = sum(abs(coeffs(start : start - 1 + band_width(i))) .^ 2) / band_width(i) ;
        start = start + band_width(i);
    end
end

