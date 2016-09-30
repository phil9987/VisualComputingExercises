function [  ] = video_adaptation(  )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
videoBG = VideoReader('jugglingBG.avi');
videoTest = VideoReader('jugglingTest.avi');

i = 1;
% Store all available frames
% There 20 frames, therefore storing all of them should be feasible
while hasFrame(videoBG)
    frames(:,:,:,i) = readFrame(videoBG);
    i = i+1;
end

% Generate relevant information (mean, covariance) for distance
% calculation, for each pixel
[n,m,k,l] = size(frames);
means = ones(n,m,k);
covariances = ones(n,m,k,k);
observations = ones(k,l);
for i=1:n
    for j=1:m
        observations(:,:) = frames(i,j,:,:);
        % Transpose in order to match the observation patter (row = event)
        observations = observations';
        currentMean = mean(observations);
        means(i,j,:) = currentMean;
        currentCovariance = cov(observations);
        covariances(i,j,:,:) = currentCovariance;
    end
end

% adapt all actual frames
% retrieve and save all frames

i = 1;
while hasFrame(videoTest)
    frames(:,:,:,i) = readFrame(videoTest);
    i = i+1;
end
% iterate over all frames
[n,m,k,l] = size(frames);
outputFrame = ones(n,m,k,l);
mahaDistances = ones(n,m);
for frameCount = 1:l
    %iterate over all pixels per frame
    for i=1:n
        for j=1:m
            % compute maha distance for this pixel
        end
    end

    % mask this image based on mahaDistances matrix
    outputFrame(:,:,:,frameCount) = 0;
end


end

