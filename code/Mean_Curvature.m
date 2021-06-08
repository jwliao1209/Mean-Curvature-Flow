% This function is used to compute the mean curvature on graph
% and split it into positive and negative part
% Kwf(u) = (sum w(u,v)sign(f(v)-f(u))/mu(u) where the sum is over v~u
function [Kpos, Kneg, Kw] = Mean_Curvature(img, dist, w, sigma, DX, DY)
    [M, N, ~] = size(img);
    T = numel(img);
    Num_of_Neighbor = length(DX);  % Remember that we didn't count u itself
    
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
    
    % Compute the numerator part
    img_pad = padarray(img, [dist, dist], Inf);
    fv_fu = zeros([size(img), Num_of_Neighbor]);
    for ii = 1 : Num_of_Neighbor
        cx = dist+1+DX(ii) : dist+M+DX(ii);
        cy = dist+1+DY(ii) : dist+N+DY(ii);
        fv_fu( (ii-1)*T+1 : ii*T ) = Weight(abs(DX(ii))+abs(DY(ii))) * Sign( img_pad(cx,cy)-img );
    end
    Kw = sum(fv_fu, ndims(fv_fu));
    % add w(u,u)sign(f(u)-f(u)) (In fact, this equals to 1)
    Kw = Kw + 1;
    
    % Construct the degree matrix
    Deg = ones(size(img));
    Filt = Make_Weight_Filter(dist, DX, DY, Weight);
    Deg = convn(Deg, Filt, 'same');
    
    Kw = Kw ./ Deg;
    Kpos = max(Kw, 0);
    Kneg = -min(Kw, 0);
end

% Note that our definition of sign function is sightly different from
% matlab
% We define sign(r) = 1, -1, 0 if inf>r>=0, r<0, r=Inf respectively
function b = Sign(a)
    b = ones(size(a));
    b(a == Inf) = 0;
    b(a < 0) = -1;
end

function Filt = Make_Weight_Filter(dist, DX, DY, Weight)
    Filt = zeros(2*dist+1);
    c = dist + 1; % center point
    Filt(c,c) = 1;
    
    Idx = sub2ind(size(Filt), DX+dist+1, DY+dist+1);
    temp = 1;
    for ii = 1 : dist
        Filt( Idx(temp : temp+4*ii-1) ) = Weight(ii);
        temp = temp + 4*ii;
    end
end