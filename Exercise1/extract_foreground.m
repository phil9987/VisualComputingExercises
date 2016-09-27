function [  ] = extract_foreground(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    v = VideoReader('bluescreen.avi');
    frame1 = readFrame(v);  % read first frame
    whos frame1             % print available infos about frame
    imshow(frame1);         % show first frame for pixel-selection
    [x,y] = ginput(1);      % let user select a background-pixel
    x = cast(x, 'uint64');  % cast from double to int
    y = cast(y, 'uint64'); 
    color = frame1(y,x,:);  % get color of selected pixel
    color = squeeze(color) % remove singleton dimensions
    color = im2double(color);
    frame1d = im2double(frame1);
    
    background = ones(size(frame1), 'double');
    background(:,:,1) = color(1);
    background(:,:,2) = color(2);
    background(:,:,3) = color(3);
    
    D = frame1d - background;
    E = sqrt(sum(D.^2,3));
    
    size(E)
    %E = D(:,:,1) + D(:,:,2) + D(:,:,3);
    mask = E < 0.5;         % calculate mask from selected pixel
    
    surrounding = imread('mask.bmp');
    mask2 = surrounding(:,:,1) < 255;      % get surrounding mask
    mask = mask + mask2;                   % if bit > 1 then it is omitted in the picture
    mask3d = mask;                         % turn mask to 3 dimensions to use find below
    mask3d(:,:,2) = mask;
    mask3d(:,:,3) = mask;
    frame1(find(mask3d>=1)) = 0;           % set background pixels to (0,0,0) (black)
    imshow(frame1)
    
    
    
end

