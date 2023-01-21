function [G,R] = TR_SVD(X,options)
%   Input:  X:      Tensor in Size(I1, I2, ..., IN)
%   options:
%           Rmax:   TR-rank threshold
%   Output: G:      G(n) in Size(Rn, In, Rn+1)

    if nargin == 1, options = struct; end
    if ~isfield(options, 'Rmax'), options.Rmax = 10; end
    
    G = {}; 
    M = {};
    R = [];
    N = ndims(X);
    I = size(X);

    M{1} = mode_n_unfold(X, 1);
    [U,S,V] = svd(M{1}, 'econ');
    R(1) = 1; R(2) = min(length(S), options.Rmax);
    G{1}(1:R(1),:,1:R(2)) = U(:, 1:R(2)); 
    M{2} = S(1:R(2),1:R(2))*V(:,1:R(2))';
    
    for i = 1 : N - 1
        [U,S,V] = svd(reshape(M{i}, R(i)*I(i), []), 'econ');
        R(i+1) = min(length(S), options.Rmax);
        G{i} = reshape(U(:,1:R(i+1)), R(i), I(i), R(i+1));
        M{i} = S(1:R(i+1),1:R(i+1))*V(:,1:R(i+1))';
    end
    G{N}(1:R(N),:,1:R(1)) = M{N-1};
    for i = 1 : length(G)
       G{i} = tensor(G{i}); 
    end
    G{N} = reshape(G{N}, [size(G{N}), 1]);    
end