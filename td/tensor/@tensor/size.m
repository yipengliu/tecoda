function m = size(t,idx)
%SIZE Tensor dimensions.
%  
%   D = SIZE(T) returns the sizes of each dimension of tensor X in a
%   vector D with ndims(X) elements.
%
%   I = size(T,DIM) returns the size of the dimension specified by
%   the scalar DIM.
%
if exist('idx','var')
    m = t.size(idx);
else
    m = t.size;
end