function result = norm_l21(X)
% Input:
%       vector or matrix
% Output:
%       the l21 norm of X

    c = sqrt(sum(X.^2,2)); % Calculate the l2 norm of each line
    result = sum(c);
end