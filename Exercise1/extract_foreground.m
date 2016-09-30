function [  ] = extract_foreground(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    iterations = 10;
    v = VideoReader('bluescreen.avi');
    frame1 = readFrame(v);  % read first frame
    imshow(frame1);         % show first frame for pixel-selection

    [n,m,k] = size(frame1);  % shape of image
    frame1Doubles = im2double(frame1);    % reformat matrix to doubles
    
    [x,y] = ginput(iterations);      % let user select background-pixels
    % x and y are of size iterations*1
    x = cast(x, 'uint64');  % cast from double to int
    y = cast(y, 'uint64'); 
    
    % userSamples represents an array of RGB values the user has picked
    % preallocate to save space and time
    userSamples = ones(iterations,3);
    for i=1:iterations
        userSamples(i,:) = frame1(y(i),x(i),:);
    end
    
    userSamplesDoubles = im2double(userSamples);
    % meanValue: 1*3, covariance: 3*3
    meanValues = reshape(mean(userSamplesDoubles),[3,1]);
    invertedCovariance = pinv(cov(userSamplesDoubles));
    
    mahaDistanceMatrix = ones(n,m);
    % there ought to be a more matlab way to do this
    for i=1:n
        for j=1:m
            aux = reshape(frame1Doubles(i,j,:), [3,1]);
            diff = aux - meanValues;
            mahaDistanceMatrix(i,j) = diff' * invertedCovariance * diff;
        end
    end
   
    p1 = mean(mean(mahaDistanceMatrix));
    % p2 = max(max(mahaDistanceMatrix));
    % p3 = min(min(mahaDistanceMatrix));
    
    % in a mask, 1 represents affirmation of the condition
    % calculate mask from selected pixel
    mask = mahaDistanceMatrix <= p1;         %the distances differ extremely heavily per execution, therefore use of a dependent term is advisable
    
    surrounding = imread('mask.bmp');
    mask2 = surrounding(:,:,1) < 255;      % get surrounding mask
    
    % unify masks
    mask = mask + mask2;                   % if bit > 1 then it is omitted in the picture
    mask3d = mask;                         % turn mask to 3 dimensions (r,g,b) to use find below
    mask3d(:,:,2) = mask;
    mask3d(:,:,3) = mask;
    frame1(find(mask3d>=1)) = 0;           % set background pixels to (0,0,0) (black)

    imshow(frame1)  
end

        

