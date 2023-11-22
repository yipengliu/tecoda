function [X] = HaLRTC1(T, Omega, alpha, beta2,maxIter,epsilon,X)

if nargin < 7
    X = T;
    X(logical(1-Omega)) = 0;
    % X(logical(1-Omega)) = 10;
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

normT = norm(T(:));
for i = 1:ndims(T)
    Y{i} = X;
    M{i} = zeros(dim);
end

Msum = zeros(dim);
Ysum =zeros(dim);
% for k = 1: maxIter
%     if mod(k, 20) == 0
%         fprintf('HaLRTC: iterations = %d   difference=%f\n', k, errList(k-1));
%     end
    beta2 = beta2 * 1.05;
    
    % update M
    Msum = 0*Msum;
    Ysum = 0*Ysum;
    for i = 1:ndims(T)
        M{i} = Fold(Pro2TraceNorm(Unfold(X-Lambda2/beta2, dim, i), alpha(i)/beta2), dim, i);
        Msum = Msum + M{i};
%         Ysum = Ysum + Y{i};
    end
    
    % update X
    %X(logical(1-Omega)) = ( Msum(logical(1-Omega)) + beta*Ysum(logical(1-Omega)) ) / (ndims(T)*beta);
    lastX = X;
    X = Msum  / ndims(T);
    X(Known) = T(Known);







