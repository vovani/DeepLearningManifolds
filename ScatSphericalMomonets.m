function [ features,U, sh_fourier,meta ] = ScatSphericalMomonets( Imgs,filters,SHbaisis )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
num_images=length(Imgs);
Npoints = size(Imgs{1}.dirs, 1);
sh_fourier = cell(1, num_images);
S = cell(1, num_images);
U=cell(1, num_images);
%meta=cell(1, num_images);
parfor i = 1:num_images  
    sh_fourier{i} = sh_image(Imgs{i}.dirs, (4 * pi / Npoints) * SHbaisis' * Imgs{i}.values);
    [U{i}, S{i}] = scat2(filters, SHbaisis, sh_fourier{i});
end
[~, ~,meta] = scat2(filters, SHbaisis, sh_fourier{1});
features = cell2mat(cellfun(@(X)cell2mat(X),S,'UniformOutput', false)');

end

