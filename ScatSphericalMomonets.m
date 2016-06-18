function [ features,meta,U, sh_fourier ] = ScatSphericalMomonets( Imgs,filters,SHbaisis )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

 if nargout > 2
     isFullOut=true;
 else
     isFullOut=false;
 end
num_images=length(Imgs);
Npoints = size(Imgs{1}.dirs, 1);

S = cell(1, num_images);
if isFullOut 
    U=cell(1, num_images);
    sh_fourier = cell(1, num_images);
end
%meta=cell(1, num_images);

parfor i = 1:num_images 
    
     sh_fourier{i} = sh_image(Imgs{i}.dirs, (4 * pi / Npoints) * SHbaisis' * Imgs{i}.values); 
    if isFullOut  
        [U{i}, S{i}] = scat2(filters, SHbaisis, sh_fourier{i});
    else 
        [~, S{i}] = scat2(filters, SHbaisis, sh_fourier{i});
        sh_fourier{i}=[];
    end
end
sh_fourier1 = sh_image(Imgs{1}.dirs, (4 * pi / Npoints) * SHbaisis' * Imgs{1}.values); 
[~, ~,meta] = scat2(filters, SHbaisis, sh_fourier1);
meta=cell2mat(meta);
features = cell2mat(cellfun(@(X)cell2mat(X),S,'UniformOutput', false)');
indxValid = cell2mat(cellfun(@(X)~isempty(X),{meta.m},'UniformOutput', false));
features=features(:,indxValid);
meta=meta(indxValid);
m=cell2mat({meta.m});
psi_scale=cell2mat({meta.psi_scale});
prev_scale=cell2mat({meta.prev_scale});
clear meta;
meta.m=m;
meta.psi_scale=psi_scale;
meta.prev_scale=prev_scale;
end

