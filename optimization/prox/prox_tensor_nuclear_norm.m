function [X,tersor_nuclear_norm,tubal_rank] = prox_tensor_nuclear_norm(Y,lambda)

% The proximal operator of the tensor nuclear norm of a 3 way tensor
%
% objective function: min_X \rho*||X||_*+0.5*||X-Y||_F^2
%
% Input 
%     Y: n1*n2*n3 tensor
%     lambda: a weight factor balancing the contribution of tensor nuclear norm
% Output
%     X: n1*n2*n3 tensor
%

[n1,n2,n3] = size(Y);
% Final result x
X = zeros(n1,n2,n3);
% Y is transformed into frequency domain by fft
Yf = fft(Y,[],3);
% tensor nuclear norm of X
tersor_nuclear_norm = 0;
% tensor tubal rank of X
tubal_rank = 0;
        
% The first front slice is decomposed into svd separately
% econ is economy size decomposition
[U,S,V] = svd(Yf(:,:,1),'econ');
% The vector of diagonal line is truncated by singular value
S = diag(S);
% rho is the threshold value for truncation
r = length(find(S>lambda));
if r>=1
    S = S(1:r)-lambda;
    % The result after singular value truncation is stored in x
    X(:,:,1) = U(:,1:r)*diag(S)*V(:,1:r)';
    tersor_nuclear_norm = tersor_nuclear_norm+sum(S);
    tubal_rank = max(tubal_rank,r);
end
% i=2,...,halfn3
half_n3 = round(n3/2);
for i = 2 : half_n3
    [U,S,V] = svd(Yf(:,:,i),'econ');
    S = diag(S);
    r = length(find(S>lambda));
    if r>=1
        S = S(1:r)-lambda;
        X(:,:,i) = U(:,1:r)*diag(S)*V(:,1:r)';
        % Multiply by 2 because both sides are symmetrical
        tersor_nuclear_norm = tersor_nuclear_norm+sum(S)*2;
        tubal_rank = max(tubal_rank,r);
    end
    % This is the application of t product property
    X(:,:,n3+2-i) = conj(X(:,:,i));
end

% if n3 is even, A front slice will be missed
if mod(n3,2) == 0
    i = half_n3+1;
    [U,S,V] = svd(Yf(:,:,i),'econ');
    S = diag(S);
    r = length(find(S>lambda));
    if r>=1
        S = S(1:r)-lambda;
        X(:,:,i) = U(:,1:r)*diag(S)*V(:,1:r)';
        tersor_nuclear_norm = tersor_nuclear_norm+sum(S);
        tubal_rank = max(tubal_rank,r);
    end
end
tersor_nuclear_norm = tersor_nuclear_norm/n3;
% The final result is obtained after ifft
X = ifft(X,[],3);
end