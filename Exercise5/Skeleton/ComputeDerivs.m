function [fx, fy, ft] = ComputeDerivs(im1, im2)
%==========================================================================
% function [fx, fy, ft] = ComputeDerivs(im1, im2)
%==========================================================================
% Computes the spatial and temporal partial derivative between two
% gray-valued image patches im1 and im2. The patches must be of size [5,5].
% 
%==========================================================================

% spatial partial derivatives use kernel [-1 1] and a spatial smoothing of 
% the derivatives (separable 2D kernel with 1D kernel 1/2 * [1 1]) is performed. Moreover we take
% the mean between the gradients of the two patches. These steps can be
% implemented in the following way: 
%fx = [your line here]; 
%fy = [your line here]; 

% temporal partial derivative is again based on kernel [1 -1] and a
% separable 2D smoothing kernel (with underlying 1D kernel 1/2 * [1 1]):
%ft = [your line here]; 



% conv2 outputs a larger matrix than its input matrices --> make same size as input
fx=fx(1:size(fx,1)-1, 1:size(fx,2)-1);
fy=fy(1:size(fy,1)-1, 1:size(fy,2)-1);
ft=ft(1:size(ft,1)-1, 1:size(ft,2)-1);

% Discard boundary pixel of 5-by-5 patches
fx = fx(2:4, 2:4);
fy = fy(2:4, 2:4);
ft = ft(2:4, 2:4);

% vectorize the partial derivatives of the 3-by-3 patches: 
fx = fx';
fy = fy';
ft = ft';

fx = fx(:);
fy = fy(:);
ft = ft(:);
