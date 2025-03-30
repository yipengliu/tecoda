function t = reshape(t,siz)
%RESHAPE Change tensor size.
%   RESHAPE(X,SIZ) returns the tensor whose elements
%   have been reshaped to the appropriate size.
%

if prod(t.size) ~= prod(siz)
    error('Number of elements cannot change');
end

if(length(siz)>2)
    t.data = reshape(t.data,siz);
    t.size = siz;
    return;
else
    t = reshape(t.data,siz);
    return;
end
