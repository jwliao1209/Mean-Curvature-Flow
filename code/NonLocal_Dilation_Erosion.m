% Calculate NonLocal dilation and erosion 
% NLD(f) = f + |grad(f)^+|_inf
% NLE(f) = f - |grad(f)^-|_inf
function [NLD, NLE] = NonLocal_Dilation_Erosion(f, Lpos, Lneg, jmp)
    NLD = f + jmp * Lpos;
    NLE = f - jmp * Lneg;
end