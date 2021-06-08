% Given a graph G(V,E,w) (We only consider n-adjacency grid here)
% Define the norms of gradients as follows
% |(grad_w^+ f)(u)|_inf = max(w(u,v)(f(v)-f(u))^+) over all v~u
% |(grad_w^- f)(u)|_inf = max(w(u,v)(f(v)-f(u))^-) over all v~u

% Input :
%    img : A matrix (image)
%      w : 'constant' or 'exponential'
%   dist : v~u if |v(x)-u(x)| + |v(y)-u(y)| <= dist
% DX, DY : relative neighborbood index
% Output:
%   Lpos: max(w(u,v)(f(v)-f(u))^+) over all v~u
%   Lneg: max(w(u,v)(f(v)-f(u))^-) over all v~u
function [Lpos, Lneg] = L_inf_norm(img, dist, w, sigma, DX, DY)
    [M, N, P] = size(img);
    T = M*N*P;
    Num_of_Neighbor = length(DX);
    
    % Compute the weight
    switch (w)
        case 'constant'
            Weight = ones([dist,1]);
        case 'exponent'
            % We first try 1-norm in the numerator
            Weight = exp(-(1:dist.^2)/(sigma^2));
        otherwise
            error('w must be "constant" or "exponent"');
    end
    
    % Pos_pad is used to compute Lpos
    % Note that img = Pos_pad(dist+1:dist+M, dist+1, dist+N, :)
    Pos_pad = padarray(img, [dist, dist], -Inf);
    Pos_diff = zeros([size(img), Num_of_Neighbor]);
    for ii = 1 : Num_of_Neighbor
        cx = dist+1+DX(ii) : dist+M+DX(ii);
        cy = dist+1+DY(ii) : dist+N+DY(ii);
        Pos_diff( (ii-1)*T+1 : ii*T ) = Weight(abs(DX(ii))+abs(DY(ii))) * ( Pos_pad(cx,cy)-img ); 
    end
    Lpos = max(max(Pos_diff, [], ndims(Pos_diff)), 0);
    Pos_diff(Pos_diff == -Inf) = Inf; % This is Neg_diff (But it only different from Pos_diff sightly)
    Lneg = max(-min(Pos_diff, [], ndims(Pos_diff)), 0);
end
