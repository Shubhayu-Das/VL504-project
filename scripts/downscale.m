clc;

image = imread('../images/vga-over-uart/test-original.jpg');
image = imresize(image, [240 320]);

% Reducing the number of colors
n_colors = 2^6;
[new_image, newmap] = rgb2ind(image, n_colors, 'dither');

% Converting to 8 bit colors and extracting the top 4 bits of each of the colors
newmap = uint8(round(newmap * 255));
newmap = bitand(newmap, 224);

% See the colors used for creating the image
% This needs to be manually copied into a Python file
% Refer to mapping.py for the format
disp(newmap);

% Compare the original image with the down-sampled image
subplot(121);
imshow(image);
subplot(122);
imshow(new_image, newmap);

% Store the image as a data file
% Use create_coe.py to convert this to a COE file
% fid = fopen('data.py', 'wt');
% fprintf(fid,"import numpy as np\ndata=np.array([\n");
% fprintf(fid, '%d,', new_image);
% fprintf(fid, "], dtype=np.uint8)");
% fclose(fid);
