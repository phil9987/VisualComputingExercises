im1=single((imread('frame10.png')));
im2=single((imread('frame11.png')));

% Generate debugging data (for example, a simple translation of the whole
% image)
if (false)
    tform = maketform('affine',[1 0 0; 0 1 0; 0 5 1]);
    im2 = imtransform(im1,tform, 'XData', [1,size(im1,2)], 'YData', [1,size(im1,1)]);
    figure(); subplot(1,2,1); imshow(im1,[]); subplot(1,2,2); imshow(im2,[]);
end

%--------------------------------------------------------------------------
% some adjustable parameters
%--------------------------------------------------------------------------
numLevels  = 5;     % number of levels in the Gaussian Pyramid
iterations = 3;     % number of iterative refinement steps to perform
alpha      = 0.001; % regularization parameter for linear systems 

% Construct image pyramid, using setting in Bruhn et al in
%     "Lucas/Kanade.." (IJCV2005') page 218
pyramidSpacing    = 2; 
h                 = fspecial('gaussian', 2*round(1.5*pyramidSpacing/2) +1, pyramidSpacing/2);

%------------------------------------
% Compute image pyramids
%------------------------------------
pyramid1    = imgPyramid(im1, h, numLevels, 1/pyramidSpacing);
pyramid2    = imgPyramid(im2, h, numLevels, 1/pyramidSpacing);

%------------------------------------
% Iterate over all pyramid levels, starting from the top:
%------------------------------------
for p = 1:numLevels
    % current Level
    im1 = pyramid1{1,(numLevels - p)+1}; 
    im2 = pyramid2{1,(numLevels - p)+1}; 

    if p==1
        % initialize the optical flow
        u=zeros(size(im1));
        v=zeros(size(im1));
    else  
        % upsample & resize optical flow of lower resolution level:
        u = pyramidSpacing * imresize(u,size(u)*pyramidSpacing,'bilinear');   
        v = pyramidSpacing * imresize(v,size(v)*pyramidSpacing,'bilinear');
    end
    
    % iterative refinment loop
    for r = 1:iterations
        [u,v] = LucasKanade(u, v, im1, im2, alpha);        
    end
    
    % visualize current flow estimate: 
    figure(1); 
    subplot(1,numLevels, p); 
    flow = zeros([size(u), 2]); 
    flow(:,:,1) = u; 
    flow(:,:,2) = v; 
    imgFlow = flowToColor(flow, 7); 
    imshow(imgFlow); 
    title(['Optical Flow at Pyramid level ' num2str(p)]);
end % end pyramid loop

% Comparison with ground truth: 
flow        = zeros([size(u), 2]); 
flow(:,:,1) = u; 
flow(:,:,2) = v; 
imgFlow     = flowToColor(flow, 7); 

groundTruth = readFlowFile('flow10.flo'); 
imgFlowGT   = flowToColor(groundTruth, 7); 
figure(); subplot(1,2,1); imshow(imgFlow); subplot(1,2,2); imshow(imgFlowGT); 

% arrow plot of optical flow: 
pyramidU    = imgPyramid(medfilt2(u, [5 5]), h, 3, 1/pyramidSpacing);
pyramidV    = imgPyramid(medfilt2(v, [5 5]), h, 3, 1/pyramidSpacing);
figure(); 
imshow(pyramid1{3}, []); 
hold on; 
quiver(pyramidU{3}, pyramidV{3}, 0); axis equal; 


