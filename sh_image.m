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
        
        function new_obj = rotate(obj, alpa, betta,gamma)
                new_obj=obj;
                q=compose_rotation(alpa, betta,gamma);
                new_obj.values=RotateSphrImg(new_obj.values,new_obj.S,q)  ;
        end
        
        function new_obj = RandRotate(obj)
             alpa = 2*pi*rand() - pi ;% -180 to 180
             betta = pi*rand() - pi*0.5; % -90 to 90
             gamma = 2*pi*rand() - pi; % -180 to 180
            new_obj = rotate(obj, alpa, betta,gamma);
        end
    end
    
end

