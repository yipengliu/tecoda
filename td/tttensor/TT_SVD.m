function TT = TT_SVD(X,options)
%   Input:  X:      Tensor in Size(I1, I2, ..., IN)
%   options:
%           Rmax:   TT-rank threshold
%   Output: TT:      TTtensor with all factors in Size(Rn, In, Rn+1)
if nargin == 1, options = struct; end
if ~isfield(options, 'Rmax'), options.Rmax = 10; end

G = {};
M = {};
R = [];
N = ndims(X);
I = size(X);

M{1} = mode_n_unfold(X,1);
R(1) = 1;

for i =1:N-1
    [U,S,V] = svd(reshape(M{i}, R(i)*I(i),[]),'econ');
    R(i+1) = min(length(S), options.Rmax);
    G{i} = reshape(U(:,1:R(i+1)),[R(i),I(i),R(i+1)]);
    M{i+1} = S(1:R(i+1),1:R(i+1))*V(:,1:R(i+1))';
end
G{N} = M{N};
for i = 1:length(G)
    G{i} = tensor(G{i});
end
G{N} = reshape(G{N},[size(G{N}),1]);
TT = tttensor(G);