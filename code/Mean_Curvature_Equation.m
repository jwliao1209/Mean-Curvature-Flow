% Implement the numerical scheme in the paper
% Input :
%    img : 2D matrix (gray-image) or 3D tensor (RGB-image)
%  maxit : max itertion number
%     dt : step length
%   dist : How large of the neighborhood (open ball) we considered
%      w : 'constant' or 'exponent'
%  sigma : only used when w is 'exponent'
% Ouput:
%      f : the image after applying the equation
function f = Mean_Curvature_Equation(img, maxit, jmp, dist, w, sigma)
% Preprocess
    f = img;
    
    % Get relative neighborhood index
    [DX, DY] = Find_Neighborhood(dist);
    
    for ii = 1 : maxit
        % Find L inf norm
        [Lpos, Lneg] = L_inf_norm(f, dist, w, sigma, DX, DY);
        
        % Find Curvature
        [~, ~, Kw] = Mean_Curvature(f, dist, w, sigma, DX, DY);
        
        % Non-local dilation and erosion
        [NLD, NLE] = NonLocal_Dilation_Erosion(f, Lpos, Lneg, jmp);
        
        % update
        f(Kw > 0) = NLD(Kw > 0);
        f(Kw < 0) = NLE(Kw < 0);
    end
    
end