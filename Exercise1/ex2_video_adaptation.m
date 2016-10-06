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
        % 10/03 Kevin: this returns a dimension mismatch I do not understand
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
% outputFrame = ones(n,m,k,l);
mahaDistances = ones(n,m);
for frameCount = 1:l
    %iterate over all pixels per frame
    for i=1:n
        for j=1:m
            % compute maha distance for this pixel
            currentMean = means(i,j,:);
            invertedCovariance = pinv(covariances(i,j,:,:));
            aux = reshape(frames(i,j,:,l), [3,1]);
            diff = aux - currentMean;
            mahaDistances(i,j) = diff' * invertedCovariance * diff;
        end
    end

    % mask this image based on mahaDistances matrix
    mask = mahaDistanceMatrix > 100;         %the distances differ extremely heavily per execution, therefore use of a dependent term is advisable
    mask3d = mask;                      % turn mask to 3 dimensions to use find below
    mask3d(:,:,2) = mask;
    mask3d(:,:,3) = mask;
    nextFrame = im2uint8(frames(:,:,:,frameCount).*mask3d);
    writeVideo(vw,nextFrame);
end



end

