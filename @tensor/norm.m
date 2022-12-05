function n = norm(T)
%NORM Frobenius norm of a tensor.
%
%   NORM(X) returns the Frobenius norm of a tensor.
%



v = reshape(T.data, numel(T.data), 1);
n = norm(v);