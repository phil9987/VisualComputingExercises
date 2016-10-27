function P = imgPyramid(img, h, noLevels, ratio)
%==========================================================================
% function P = imgPyramid(img, h, noLevels, ratio)
%==========================================================================
% Computes noLevels levels of the image pyramid which results by using filter
% kernel h. 'ratio' specifies the decrease in size between two consecutive
% layers of the pyramid (normally, ratio == 1/2)
% Note: The image pyramid is returned in a cell array P. 
%==========================================================================
    P   = cell(1,noLevels);
    tmp = img;
    
    % ensure correct size of image, otherwise crop input image: 
    sz = size(tmp); 
    sz_new = floor(sz .* (ratio^(noLevels-1))) ./ (ratio^(noLevels-1));
    if (sz - sz_new ~= 0)
        warning(['imgPyramid: need to crop images in order to build image pyramid...']);
        tmp = tmp(1:sz_new(1), 1:sz_new(2)); 
        sz = sz_new; 
    end
    
    % original image corresponds to base level: 
    P{1}= tmp;
    
    for m = 2:noLevels
        % Low-pass filtering (== convolution in spatial domain)
        tmp  = imfilter(%[your line here]); 
        % Downsampling with factor ratio*sz:
        sz   = size(tmp); 
        tmp  = imresize(%[your line here]); 
        P{m} = tmp;
    end
end
