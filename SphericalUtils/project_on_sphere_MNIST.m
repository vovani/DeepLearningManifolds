function [ OutImg,dirs ] = project_on_sphere_MNIST( InImg,RandomSample,ImScale )
    ReformatImg=@(X)(padarray(reshape(X, 28, 28), [18 18]));
    
    if exist('ImScale','var')
        ReformatImg=@(X)(imresize(padarray(reshape(X, 28, 28), [18 18]),ImScale));
    end
    
    num_train_images=size(InImg,2);
    
    [ ~,dirs ] = project_on_sphere( ReformatImg(InImg(:,1)),[],RandomSample );
    
    if num_train_images==1
        OutImg = project_on_sphere(ReformatImg(InImg(:,1)),dirs);
        return;
    end
    
    OutImg = cell(1, num_train_images);
    parfor i = 1:num_train_images
        OutImg{i} = project_on_sphere(ReformatImg(InImg(:,i)),dirs);
    end

end