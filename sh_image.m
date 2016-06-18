classdef sh_image
    %SH_IMAGE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dirs
        values
        S
    end
    
    methods
        function obj = sh_image(dirs, values)
         obj.dirs = dirs;
         obj.values = values;
         obj.S=zeros(3,size(dirs,1));
         [obj.S(1,:),obj.S(2,:),obj.S(3,:)]=sph2cart(dirs(:,2), dirs(:,1),ones(size(dirs,1),1));  
         
        end
        
        function [new_obj,RotMtrx] = rotate(obj, alpha, beta, gamma)
            RotMtrx = euler2rotationMatrix(alpha, beta, gamma, 'zyx');
           % new_obj=obj;
            new_values=RotateSphrImg(obj.values,obj.S,RotMtrx); 
            new_obj=sh_image(obj.dirs, new_values);
            
%             [U(:,1), U(:,2), U(:,3)] = sph2cart(obj.dirs(:,1), obj.dirs(:,2) - pi/2,1);
%             U_rot = U * R.';
%             [new_dirs(:,1),new_dirs(:,2)] = cart2sph(U_rot(:,1), U_rot(:,2), U_rot(:,3));
%             azi = new_dirs(:, 1);
%             azi(azi < 0) = azi(azi < 0) + 2*pi;
%             new_dirs(:, 1) = azi;
%             new_dirs(:, 2) = pi/2 + new_dirs(:, 2);
%             
%             new_obj=sh_image(new_dirs, obj.values);
            
        end
        
        function [new_obj,RotMtrx,alpha,beta,gamma] = rand_rotate(obj)
                 alpha=2*pi*rand();
                 beta=pi*rand();
                 gamma=2*pi*rand();
                 [new_obj,RotMtrx] = rotate(obj, alpha, beta, gamma);
        end
    end
    
end

