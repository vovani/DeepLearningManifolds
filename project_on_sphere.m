function [ img,dirs ] = project_on_sphere( pic,dirs,RandomSample )
%PROJECT_ON_SHPERE Summary of this function goes here
%   Detailed explanation goes here
if ~exist('dirs','var')
    dirs=[];
end
if ~exist('RandomSample','var')
    RandomSample=false;
end
[height, width] = size(pic);
if isempty(dirs)
    if RandomSample
        Ndirs=height*width;
        S=randn(3,Ndirs);
        S=S./repmat(sqrt(sum(S.^2)),[3 1]);
        [dirs(1,:),dirs(2,:)]=cart2sph(S(1,:),S(2,:),S(3,:));
        dirs=dirs';
        dirs=dirs+repmat([pi pi/2],[Ndirs 1]);
    else
        dirs = grid2dirs(360 / width, 180 / height);
    end
end
proj_indecies = round(dirs * diag([(width - 1)/ (2 * pi), (height - 1) / pi])) + 1;
proj_indecies = sub2ind(size(pic), proj_indecies(:,2), proj_indecies(:,1));
proj = pic(proj_indecies);
img = sh_image(dirs, proj);
end

