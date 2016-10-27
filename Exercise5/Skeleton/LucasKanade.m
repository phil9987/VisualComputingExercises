function [u, v, cert] = LucasKanade(uIn, vIn, im1, im2, alpha)
%==========================================================================
% function [u, v, cert] = LucasKanadeRefined(uIn, vIn, im1, im2)
%==========================================================================
% Computes the optical flow between im1 and im2. The optical flow
% formulation is based on the iterative Lucas-Kanade version. This means
% that the current flow estimates uIn and vIn are used to warp one image
% such that the update (du, dv) for the optical flow 
%       (u, v) = (uIn, vIn) + (du,dv)
% decreases with every iteration (i.e. converges to zero). 

uIn = round(uIn);
vIn = round(vIn);

u   = zeros(size(im1));
v   = zeros(size(im2));

% Derivative computation is based on a 5-by-5 patch. The boundary pixels of
% this patch are discarded, however (due to difficulties with boundary 
% conditions for gradient computation). We thus end up with a 3-by-3 window
% which is used to constrain the gradient constraint equation. 
for i = 3:size(im1,1)-2 % only iterate over pixels for which the 5-by-5 patch is completely inside the image
   for j = 3:size(im2,2)-2
      % warp the 5-by-5 patch in im1 using the current estimates of the
      % optical flow: 
      [lowRindex, highRindex, lowCindex, highCindex] = warpPatch(im1, i, j, uIn, vIn);
      % extract the two patches: 
      curIm1                = im1(i-2:i+2, j-2:j+2);
      curIm2                = im2(lowRindex:highRindex, lowCindex:highCindex);
      
      % compute the spatial and temporal partial derivatives between these
      % patches: 
      [curFx, curFy, curFt] = ComputeDerivs(curIm1, curIm2);
      
      % set up linear system and solve
      %[your line here]; 
      %[your line here];      
      u(i,j)=U(1);
      v(i,j)=U(2);

      
   end
end

% update the optical flow estimates:
u = u+uIn;
v = v+vIn;

end

%--------------------------------------------------------------------------
function [lowRindex, highRindex, lowCindex, highCindex] = warpPatch(im1, i, j, uIn, vIn)
%--------------------------------------------------------------------------
      lowRindex  = i-2+vIn(i,j);
      highRindex = i+2+vIn(i,j);
      lowCindex  = j-2+uIn(i,j);
      highCindex = j+2+uIn(i,j);

      % handle cases for indices which are out of range:
      if (lowRindex < 1) 
         lowRindex = 1;
         highRindex = 5;
      end;
      
      if (highRindex > size(im1,1))
         lowRindex = size(im1,1)-4;
         highRindex = size(im1,1);
      end;
      
      if (lowCindex < 1) 
         lowCindex = 1;
         highCindex = 5;
      end;
      
      if (highCindex > size(im1,2))
         lowCindex = size(im1,2)-4;
         highCindex = size(im1,2);
      end;
      
      if isnan(lowRindex)
         lowRindex = i-2;
         highRindex = i+2;
      end;
      
      if isnan(lowCindex)
         lowCindex = j-2;
         highCindex = j+2;
      end;
end