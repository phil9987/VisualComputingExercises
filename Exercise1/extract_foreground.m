function [  ] = extract_foreground(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    % constant representing the number of user inputs
    iterations = 10;
    v = VideoReader('bluescreen.avi');
    frame1 = readFrame(v);  % read first frame
    whos frame1             % print available infos about frame
    imshow(frame1);         % show first frame for pixel-selection
    % x,y: iterations * 2 integer 
    [x,y] = ginput(iterations);      % let user select a background-pixel
    x = cast(x, 'uint64');  % cast from double to int
    y = cast(y, 'uint64'); 
    % The following returns 300x1
    % color(:) = frame1(y,x,:);  % get color of selected pixel
    % The following returns 10x10x3
    % colorTest = frame1(y,x,:);
    % makeshift workaround
    % color is 10x3
    color(1:iterations,1:3) = 0;
    for i=1:iterations
       color(i,:) = frame1(y(i),x(i),:); 
    end
    color = squeeze(color); % remove singleton dimensions
    color = im2double(color);
    % this is basically a cast to doubles, permitting later subtraction
    frame1Double = im2double(frame1);
  
    covariance = cov(color);
    meanValue = mean(color);
    background = frame1Double;
    background(:,:,1) = meanValue(1);
    background(:,:,2) = meanValue(2);
    background(:,:,3) = meanValue(3);
    
    D = (frame1Double - background)' * pinv(covariance) * (frame1Double - background);
    %E = sqrt(sum(D.^2,3));
  
    mask = D < 0.5;         % calculate mask from selected pixel
    
    surrounding = imread('mask.bmp');
    mask2 = surrounding(:,:,1) < 255;      % get surrounding mask
    mask = mask + mask2;                   % if bit > 1 then it is omitted in the picture
    mask3d = mask;                         % turn mask to 3 dimensions to use find below
    mask3d(:,:,2) = mask;
    mask3d(:,:,3) = mask;
    frame1(find(mask3d>=1)) = 0;           % set background pixels to (0,0,0) (black)
    imshow(frame1)
end

