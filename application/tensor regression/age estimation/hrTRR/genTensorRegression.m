function [U, d, err] = genTensorRegression(InputData, InputTarget, lambda, R, MaxIter, Tol, Uini)
% general tensor ridge regression
% tensor ridge regression
% Input:
%      InputDate : the Data Tensor, I1xI2x...xI_MxN, N is the number of
%                  training data, and M is the modes of a single tensor
%                  observation
%      InputTarget : the output variable : Nx1
%      lambda      : the regularization paramters, lambda
%      R           : the rank
%      MaxIter     : the maximum number iterations
%      Tol         : the tolerance for convergence 
%      Uini        : the initialized factor matrices 
% Output
%      U : the factor matrices of regression weights
%      d : the bias
%      err : the trainign error
% Dependencies : tensor toolbox
%
% Written by Weiwei Guo

if ~exist('lambda', 'var') || isempty(lambda)
    lambda = 0.1; % regularization parameter
end
if ~exist('R', 'var') || isempty(R)
    R = 3; % rank
end
if ~exist('MaxIter', 'var') || isempty(MaxIter)
    MaxIter = 30; % the maximum number of iteration
end
if ~exist('Tol', 'var') || isempty(Tol)
    Tol = 1e-3; % the Tolerance of convergence
end

Dims = size(InputData);
N = Dims(end); % the number of training data
ndim = length(Dims) - 1;

U =cell(1, ndim);
if ~exist('Uini', 'var') || isempty(Uini)
    % Initialization
    % randomized
    for i = 1 : ndim
        u = rand(Dims(i), R);
        u = -1+ 2*u;
        U{i} = u;
    end
end
U=CPtensor(U);
%% Iteration
Loop = 1;
iter = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
while(Loop)
    iter = iter + 1;
    Uold = U;
    for i = 1 : ndim
        Phi = zeros(N, prod(size(U.factors{i}))+1);
        for n = 1 : N
            Xdata = eval(['InputData(' repmat(':,', 1, ndim) num2str(n) ')']);
            xi = double(mtkr_product(Xdata, U.factors, i));%mttkrp(Xdata, U, i);
            Phi(n,:) = [(xi(:))' 1];
        end
%         ridge regression
        [ignorce dim] = size(Phi);
        ww = inv(lambda*eye(dim)+Phi'*Phi)*Phi'*InputTarget;
        U.factors{i} = reshape(ww(1:end-1), Dims(i), R);
        d = ww(end);
        
    end
    
    
    
    ten_U_old = CP2tensor(Uold);
    ten_U = CP2tensor(U);
    
    norm_u = norm(ten_U);
    norm_u_gap = norm(calculate('minus',ten_U,ten_U_old));
    tor = norm_u_gap/norm_u;
    % check terminatation conditions
    fprintf('Iteration: %d, Tor: %f\n', iter, tor);
    if isnan(tor)
        break;
    end
    if(iter>MaxIter || tor < Tol)
        Loop = 0;
    end
end
%     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



pred = zeros(N,1);
for n = 1 : N
    ten_U = CP2tensor(U);
%     ten_U = tensor(ten_U);
    Xdata = eval(['InputData(' repmat(':,', 1, ndim) num2str(n) ')']);
    
    pred(n) = inner_product(Xdata, ten_U)+d;   
end

err = InputTarget - pred;
err = sqrt(mean((err).^2));



