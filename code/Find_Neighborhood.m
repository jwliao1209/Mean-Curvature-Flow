% Given distance, find dx and dy for the neighborhood (diamond), and sort by length
% For example, dist = 2
% Then DX = [0 -1  0 0 1 -2 -1 -1 0  0  1 1 2]
%      DY = [0  0 -1 1 0  0 -1  1 -2 2 -1 1 0]
function [DX, DY] = Find_Neighborhood(dist)
    [DX, DY] = meshgrid(-dist:dist, -dist:dist);
    T = reshape(abs(DX)+abs(DY), [numel(DX),1]);
    [~, I] = sort(T);
    
    N = 2*(dist^2+dist); % Note : there are 2d^2+2d element in the diamond (exclude u itself)
    DX = DX(I); DX = DX(2:N+1);
    DY = DY(I); DY = DY(2:N+1);
end