function [ OutImg ] = project_on_sphere_MNIST( InImg )
    ReformatImg=@(X)(padarray(reshape(X, 28, 28), [18 18]));
    
    num_train_images=size(InImg,2);
    
    if num_train_images==1
        OutImg = project_on_sphere(ReformatImg(InImg(:,1)));
        return;
    end
    
    OutImg = cell(1, num_train_images);
    parfor i = 1:num_train_images
        OutImg{i} = project_on_sphere(ReformatImg(InImg(:,i)));
    end

end