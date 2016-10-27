function [ output_args ] = task2( input_args )

% threshold = 0.3;

image = imread('lighthouse.png');
double_image = im2double(image);

sobel_filter = [-1,0,1;-2,0,2;-1,0,1];
gaussian_filter = fspecial('gaussian', 3, 0.5);

%conv_1 = conv2(sobel_filter * gaussian_filter , double_image);
%conv_2 = conv2(sobel_filter' * gaussian_filter  , double_image);

conv_1 = conv2(gaussian_filter * sobel_filter  , double_image);
conv_2 = conv2(gaussian_filter * sobel_filter'  , double_image);

dot_conv = sqrt(conv_1.^2 + conv_2.^2);

% masked_image = ((dot_conv > threshold)*255);

% result = conv2(imageDouble, combined_filter);
% imshow(masked_image);
imshow(dot_conv);

end