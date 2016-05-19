classdef sh_image
    %SH_IMAGE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dirs
        values
        proj_indecies
    end
    
    methods
        function obj = sh_image(dirs, values)
         obj.dirs = dirs;
         obj.values = values;
        end
        
        function new_obj = rotate(obj, azimuth, longtitude)
          new_obj = sh_image(obj.dirs, obj.values);
          new_obj.dirs(:,1) = mod((new_obj.dirs(:,1) + azimuth), 2 * pi);
          new_obj.dirs(:,2) = mod((new_obj.dirs(:,2) + longtitude), pi);
        end
    end
    
end

