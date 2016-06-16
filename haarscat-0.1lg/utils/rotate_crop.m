function data_out = rotate_crop(data_in, angle)

len1 = size(data_in,1);
len2 = size(data_in,2);

temp = uint8(100*ones(len1,len2));
temp = imrotate(temp, angle,'crop');

% initialize
width = min(len1,len2);
height = width;
xmin = floor((len1-width)/2)+1;
ymin = floor((len2-width)/2)+1;
temp_cropped = temp(xmin:xmin+height-1,ymin:ymin+width-1);

while sum(sum(temp_cropped == 0))
    width = width-2;
    height = width;
    xmin = floor((len1-width)/2)+1;
    ymin = floor((len2-width)/2)+1;
    temp_cropped = temp(xmin:xmin+height-1,ymin:ymin+width-1);
end

data_out = imrotate(data_in, angle,'crop');
data_out = data_out(xmin:xmin+height-1,ymin:ymin+width-1,:);


end