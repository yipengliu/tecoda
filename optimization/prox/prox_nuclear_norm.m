function [result, nuclearNorm] = prox_nuclear_norm(x, lambda)
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

    [U, S, V] = svd(x,'econ');
    % Singular value truncation:
    sigma = diag(S);            % to get column vector
    sigma = prox_l1(sigma, lambda);     % modified singular values!
    r = sum(sigma > 0);             % rank of solution
    % Reconstruct X with new singular values
    sigma = sigma(1:r);
    nuclearNorm = sum(sigma);
    % result = Ur Sr Vr', where Ur = U(:, 1:r), Sr = diag(sigma), Vr = Vr(:, 1:r)
    result = U(:, 1:r) * diag(sigma) * V(:,1:r)';
else
    fprintf('error, please check your input is a two way array');
end

end
