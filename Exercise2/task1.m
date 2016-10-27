function [ output_args ] = exercise1( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

threshold = 0.7;
sobel_filter = [-1,0,1;-2,0,2;-1,0,1];
prewitt_filter = [-1,0,1;-1,0,1;-1,0,1];

image = imread('lighthouse.png');
double_image = im2double(image);
[x, y] = size(image);

sobel_conv_1 = conv2(sobel_filter, double_image);
sobel_conv_2 = conv2(sobel_filter', double_image);
% imshow(sobel_conv_1);
% imshow(sobel_conv_2);
dot_conv = sqrt(sobel_conv_1.^2 + sobel_conv_2.^2);
% add_conv = sobel_conv_1 + sobel_conv_2;
reference = edge(image, 'sobel', 0.09);

% mask = zeros(x, y);
% mask(dot_conv > threshold) = 1;
% masked_image = mask.*dot_conv;
masked_image = ((dot_conv > threshold)*255);

% imshow(reference);
imshow(masked_image);

end

