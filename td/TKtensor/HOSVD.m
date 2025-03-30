function TK = HOSVD(X,ranks,varargin)
%HOSVD Compute sequentially-truncated higher-order SVD (Tucker).
%   Input:  X:      Tensor in Size(I1, I2, ..., IN)
%           rank:   Multilinear rank(R1, R2, ..., RN)
%   Output: TK:     Tucker class 
%   TK = HOSVD(X,ranks,'param',value,...) specifies optional parameters and
%   values. Valid parameters and their default values are:
%      'verbosity' - How much to print between 0 and 10. Default: 1.
%      'tol' - Specify tolerance. Default: 10e-4.
%

%% Read paramters
d = ndims(X);

params = inputParser;
params.addParameter('verbosity',1);
params.addParameter('tol',10e-4);
params.parse(varargin{:});

verbosity = params.Results.verbosity;
tol = params.Results.tol;

%% Setup
if verbosity > 0
    fprintf('Computing HOSVD...\n');
end
normxsqr = norm(X(:));
eigsumthresh = tol.^2 * normxsqr / d;

if verbosity > 0
    fprintf('||X||^2 = %g\n', normxsqr);
    fprintf('tol = %g\n', tol);
    fprintf('eigenvalue sum threshold = tol^2 ||X||^2 / d = %g\n', eigsumthresh);
end

if ~isempty(ranks)
    if ~isvector(ranks) || length(ranks) ~= d
        error('Specified ranks must be a vector of length ndims(X)');
    end
    r = ranks;
end

%% Main loop

U = cell(d,1); % Allocate space for factor matrices
Y = X; % Copy input tensor, shrinks at each step for sequentially-truncated

for k = 1:d
    
    % Compute Gram matrix
    Yk = double(mode_n_unfold(Y,k));
    Z = Yk*Yk';
    
    % Compute eigenvalue decomposition
    [V,D] = eig(Z);
    [eigvec,pi] = sort(diag(D),'descend');
    
    % If rank is not prespecified, compute it.
    if r(k) == 0
        
        eigsum = cumsum(eigvec,'reverse');
        r(k) = find(eigsum > eigsumthresh, 1, 'last');
        
    end
    
    % Extract factor matrix by picking out leading eigenvectors of V
    U{k} = V(:,pi(1:r(k)));
    
    % Shrink!
    Y = mode_n_product(Y,U{k}',k,'T');
end

% Extract final core
G = Y;

%% Final result
TK = TKtensor(tensor(G),U);
