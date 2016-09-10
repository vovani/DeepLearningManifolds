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
         [obj.S(1,:),obj.S(2,:),obj.S(3,:)]=sph2cart(dirs(:,1), dirs(:,2) - pi/2,ones(size(dirs,1),1));  
         
        end
        
        function new_obj = rotate(obj, alpha, beta, gamma)
            R = euler2rotationMatrix(alpha, beta, gamma, 'zyx');
            new_obj=obj;
            [U(:,1), U(:,2), U(:,3)] = sph2cart(new_obj.dirs(:,1), new_obj.dirs(:,2) - pi/2,1);
            U_rot = U * R.';
            [new_obj.dirs(:,1),new_obj.dirs(:,2)] = cart2sph(U_rot(:,1), U_rot(:,2), U_rot(:,3));
            azi = new_obj.dirs(:, 1);
            azi(azi < 0) = azi(azi < 0) + 2*pi;
            new_obj.dirs(:, 1) = azi;
            new_obj.dirs(:, 2) = pi/2 + new_obj.dirs(:, 2);
        end
    end
    
end

