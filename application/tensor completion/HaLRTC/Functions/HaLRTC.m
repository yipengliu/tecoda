%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ADM algorithm: tensor completion
% paper: Tensor completion for estimating missing values in visual data
% date: 05-22-2011
% min_X: \sum_i \alpha_i \|X_{i(i)}\|_*
% s.t.:  X_\Omega = T_\Omega
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [X, errList] = HaLRTC(T, Omega, alpha, beta, maxIter, epsilon, X)

if nargin < 7
    X = T;
    X(logical(1-Omega)) = 0;
end

errList = zeros(maxIter, 1);
dim = size(T);
Y = cell(ndims(T), 1);
M = Y;

normT = norm(T(:));
for i = 1:ndims(T)
    M{i} = X;
    Y{i} = zeros(dim);
end

Msum = zeros(dim);
Ysum = zeros(dim);
for k = 1: maxIter
     %if mod(k, 20) == 0
     %    fprintf('HaLRTC: iterations = %d   difference=%f\n', k, errList(k-1));
     %end
    beta = beta * 1.05;
    
    % update M
    Msum = 0*Msum;
    Ysum = 0*Ysum;
    for i = 1:ndims(T)
        M{i} = Fold(Pro2TraceNorm(Unfold(X-Y{i}/beta, dim, i), alpha(i)/beta), dim, i);
        Msum = Msum + M{i};
        Ysum = Ysum + Y{i};
    end
    
    % update X
    %X(logical(1-Omega)) = ( Msum(logical(1-Omega)) + beta*Ysum(logical(1-Omega)) ) / (ndims(T)*beta);
    
    X = (Msum + Ysum/beta) / ndims(T);
    X(Omega) = T(Omega);
    
    % update Y
    for i = 1:ndims(T)
        Y{i} = Y{i} + beta*(M{i} - X);
    end
    
    % compute the error
    errList(k) = norm(X(:)-T(:)) / normT;
    %fprintf('Iteration=%d\tRelative Error=%f\n',k,errList(k));
    if errList(k) < epsilon
        break;
    end
end

% errList = errList(1:k);
% fprintf('FaLRTC ends: total iterations = %d   difference=%f\n\n', k, errList(k));

