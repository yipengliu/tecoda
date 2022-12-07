function Y = squeeze(X)
%SQUEEZE Remove singleton dimensions from a tensor.
%
%   Y = SQUEEZE(X) returns a tensor Y with the same elements as
%   X but with all the singleton dimensions removed.  A singleton
%   is a dimension such that size(X,dim)==1.  
%

if all(X.size > 1)
  % No singleton dimensions to squeeze
  Y = X;
else
  idx = find(X.size > 1);
  if numel(idx) == 0
    % Scalar case - only singleton dimensions
    Y = X.data;
  else
    siz = X.size(idx);
    Y = tensor(squeeze(X.data),siz);
  end
end

return;