function X = prox_l21(B,lambda)

% The proximal operator of the l21 norm of a matrix
% l21 norm is the sum of the l2 norm of all columns of a matrix 
%
% min_X \lambda*||X||_{2,1}+0.5*||X-B||_2^2
%

% store the final result
X = zeros(size(B));
% Traverse every column of the matrix of B
for j = 1 : size(X,2)
    norm_j = norm(B(:,j));% Find the 2-norm of the column
    if norm_j > lambda
        X(:,j) = (1-lambda/norm_j)*B(:,j);
    end
end