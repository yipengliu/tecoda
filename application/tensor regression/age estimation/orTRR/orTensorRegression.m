function [U bias Alpha beta err] = orTensorRegression(InputData, InputTarget, MaxRank, Solver, Update_Method, beta, opt_str, MaxIter, MinDU, Uinit, verbose)
% Optimal rank tensor regression with L1,2 norm regularization.
% Input:
%    InputData:  the input data matrix, N * D, 
%                 N is the numer of training examples
%                 D is teh dimensionality 
%    InputTarget : the output labels associated with the input data, N * 1
%                 It is can be discrete for classifiation or real number
%                 for regression problem
%    Solver : the type of the problem,call different solver
%                              'lsq' : the least square
%                              'libsvm'
%   Update_Method : the update mehtod for alpha
%   beta :  the observatio noise variance or the fraction of the regularization parameter lambda
%   MaxRank: the maximum rank of the weight tensor
%   MaxIter: the maximum iterations
%   MinDU  : the tolerance for convergence
% Output:
%      U : the CP form of the weights tensor
%          U{m}: of size Im * R, m=1,2,..., M, M is the order of the tensor
%     Alpha: [alpha_1, alpha_2, ..., alpha_R]', the precision prior on for each
%            column of U{m} 
%     beta: the prior precision of observation
%
% Written by Weiwei Guo
% 02/28/2011

Sz = size(InputData);
N = Sz(end);
Sz(end) = [];
MaxAlpha = 1e8; % the upper bound for alpha_r, the component with larger alpha_r will be removed
M = length(Sz); % the order of the a single inpout tensor observation
if ~exist('MaxIter', 'var') || isempty(MaxIter)
    MaxIter = 30;
end
if ~exist('MinDU', 'var') || isempty(MinDU)
    MinDU = 1e-3;
end
if ~exist('Uinit', 'var') || isempty(Uinit)
       Uinit = cell(1,M);
    for m = 1 : M
        Uinit{m} = -1 + 2*rand(Sz(m), MaxRank);
    end
end
if strcmp(Solver, 'liblinear') || strcmp(Solver, 'libsvm')
    if ~exist('opt_str', 'var') || isempty(opt_str)
        error('It need the option string to call svr solver');
    end
end
if strcmp(Solver, 'lsq')
    if ~exist('beta', 'var') || isempty(beta)
        error('It needs the fraction of the regularization paramter to call ridge regression solver');
    end
end
if ~exist('verbose', 'var') || isempty(verbose)
    verbose = 1;
end


Alpha = ones(MaxRank,1);
% beta = 1/var(InputTarget);
Keep_indx = [1 : MaxRank]';
Reff = MaxRank;
bias = 0;
iter = 0;
AlphaEps = 1e-3;
noiterPruning = 1; % the iteration to begin with prunning the component;

%% Main LOOP
RR = [];
U = CPtensor(Uinit);
while (1)
    %% pruning the component with larger alpha_r
    if iter > noiterPruning
        if Reff ~= 1
            if max(Alpha) > MaxAlpha-AlphaEps
                L = Alpha <= MaxAlpha-AlphaEps;
                Keep_indx = Keep_indx(L);
                Reff = sum(L);
                if Reff == 0
                    fprintf('No efficient rank, Pleae Inrease the Max Rank');
                    break;
                end
                for m = 1 : M
                    Um = U.factors{m};
                    Um(:,~L) = [];
                    U.factors{m} = Um;
                end
                Alpha = Alpha(L);
            end
        end
    end
    RR = [RR Reff];
    
    if U.rank ~= size(U.factors{1},2)
        U.rank=size(U.factors{1},2);
        U.weights=U.weights(1:U.rank);
    end
    
    %% Computing new weigths, U{m}, m =1,..., M
    switch lower(Solver)
        case 'lsq'
            % closed form for lsq in each subproblem, currently there is some problem
            Uold = U;
            X = tensor(InputData);
            for m = 1 : M
                Utm = U.factors;
                Utm(m) = [];
                Ukrp = khatrirao(Utm, 'r');
                Szm = Sz;
                Szm(m) = [];
                Xm = tenmat(X,m);
                Xm = reshape(double(Xm), [Sz(m) prod(Szm) N]);
                Xm = tensor(Xm);
                XU = ttm(Xm, Ukrp', 2);
                Phi = reshape(double(XU), Sz(m)*Reff, N);
                Phi = [Phi' ones(N,1)];
                lam = Alpha./beta'; 
                lambda = repmat(lam, Sz(m),1);
                Lambda = diag([lambda(:); 1]);
                uopt = pinv(Lambda+Phi'*Phi)*Phi'*InputTarget;
                U.factors{m} = reshape(uopt(1:end-1), Sz(m), Reff);
                bias = uopt(end);
            end
%             TU = full(ktensor(U)); % full tensor representation of a Ktensor
%             TU = double(TU);
%             Yt = [InputData ones(N,1)]* [TU(:); bias];
%             Err = InputTarget - Yt;
%             RMS = sqrt(mean(Err.^2));
        case 'libsvm'
            % with libsvm toolbox for classification or regression
            Uold = U;
            X = InputData;
            for m = 1 : M
                Utm = U.factors;
                Utm(m) = [];
                Ukrp = khatrirao_product(Utm, 'r');
                Szm = Sz;
                Szm(m) = [];
                Xm = mode_n_unfold(X,m);
                Xm = reshape(Xm, [Sz(m) prod(Szm) N]);
                Xm = tensor(Xm);
                XU = mode_n_product(Xm, Ukrp, 2);
                Phi = reshape(double(XU), Sz(m)*Reff, N);
                Phi = Phi';
                alpham = kron(diag(1./sqrt(Alpha)),eye(Sz(m)));
                PhiUm = Phi*alpham;
                libsvm_model = svmtrain(InputTarget, sparse(PhiUm), opt_str);
                Z = libsvm_model.SVs'*libsvm_model.sv_coef;
                bias = -libsvm_model.rho;
                Z = reshape(Z, Sz(m), Reff);
                Um = Z* diag(1./sqrt(Alpha));
                U.factors{m} = Um;
            end      
        otherwise
            error('Unknown Problem Type...')
    end
    
  
    
   %% Update hyperparamters alpha
    if iter > noiterPruning
        UA = zeros(1, Reff);
        for m = 1 : M
            Um = U.factors{m};
            UA = UA + sum(Um.^2,1);
            %         Alpha = (Sz(m) + a - 1)./(sum(Um.^2,1)+b);
        end
        if strcmp(Update_Method, 'sbl')
            Alpha = (sum(Sz)/2+a-1)./(UA/2+b);
        elseif strcmp(Update_Method, 'grl')
%             alpha = sqrt(sum(Um.^2,1));
            alpha = sqrt(UA);
            alpha = alpha./sum(alpha) + 1e-12;
%             alpha = alpha + 1e-12;
            Alpha = 1./alpha;
        elseif strcmp(Update_Method, 'fix')
            Alpha = ones(1, Reff);
        end
    end
    
    %% Stop conditions
    iter = iter + 1;
    
    DU =calculate('minus',CP2tensor(U),CP2tensor(Uold));
    NmDU = norm(DU)/norm( CP2tensor(Uold));
    if verbose
%         if ~(strcmp(Type, 'liblinear') ||  strcmp(Type, 'libsvm'))      
%             fprintf('Iteration: %d,  RMS: %.05f, Weight Change: %0.5f, Noise Var: %0.4f, Rank: %d\n', iter, RMS, NmDU, 1/beta, Reff);
%         else
            fprintf('Iteration: %d, Weight Change: %0.5f, Rank: %d\n', iter , NmDU,  Reff);
%         end
%         disp(['Iteration: ',num2str(iter), '  Errors: ', num2str(rms), ...
%  '        Weights Change: ',num2str(norm(DU)), '       Efficient Rank: ', num2str(Reff)])

    end
    if iter > MaxIter
        break;
    end
    if NmDU < MinDU
        break;
    end
    
end
pred = zeros(N, 1);
for n = 1 : N
    ten_U = CP2tensor(U);
     Xdata = eval(['InputData(' repmat(':,', 1, M) num2str(n) ')']);    
    pred(n) = inner_product(Xdata, ten_U)+bias;
end
err = InputTarget - pred;
err = sqrt(mean((err).^2));