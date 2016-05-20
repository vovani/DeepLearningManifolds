function ImgKernel=CreateKernel(filter,dirs,PointIndx)
    % vector of spherical harmonics
    N = length(filter);
    Y_N = getSH(N, dirs, 'complex');
    Coeff=Y_N(PointIndx,:);
    sh_fourier = sh_image(dirs,Coeff);
    
    ImgKernel = apply_filter( filter, sh_fourier);
end