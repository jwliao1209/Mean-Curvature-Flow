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