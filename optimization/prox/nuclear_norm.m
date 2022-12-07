function nuclearNorm = nuclear_norm(x)
%PROX_NUCLEARNORM Proximal operator with the nuclear norm
%   Usage:  result=prox_nuclear_norm(x, lambda)
%
% objective function: arg\min_{z} \frac{1}{2} \|x - z\|_2^2 + \lambda  ||z||_*
% 
% Input 
%     x: a input matrix
%     lambda: a weight factor balancing the contribution of nuclear norm
% Output
%     A: a low tucker rank approximate for B
%

% nuclear norm of matrix

if(length(size(x)) == 2 || (isa(x,'tensor') && length(tensor.size) == 2))
    x = double(x);

    [~, S, ~] = svd(x,'econ');
    sigma = diag(S);            % to get column vector
    nuclearNorm = sum(sigma);
else
    fprintf('error, please check your input is a two way array\n');
    nuclearNorm = 0;
end

end