function X= rlr(A,B,para)

%% min f(X)+lambda*g(X)


% X= rlr(A,B,pentype,lambda)
% min 0.5*||B-AX||_F^2+lambda*g(X)

%X= rlr([],B,pentype,lambda)
% min 0.5*||B-X||_F^2+lambda*g(X)

% when g(X)=||X||_1, the problem corresponds to lasso problem
% when g(X)=||X||_21,the problem corresponds to group lasso problem
% when g(X)=||X||_*,the problem corresponds to reduced rank problem
% when g(X)=||X||_tv,the problem corresponds to smooth regression problem

% Input:
% A- a N*P predictor
% B- a N*Q response
% pentype- type of penalty term type
%             - options: 'ell_1', 'ell_21', 'nuclear_norm', 'tv'
% lambda- weight factor balancing the approximate error and the penalty
% term

% Output:
% X- required weight matrix


% step size ( 0.33 causes instability, 0.2 quite accurate)
if ~isfield(para,'eta')
    eta = 1e-1;
end
% termination tolerance
if ~isfield(para,'tol')
    tol = 1e-3;
end
% maximum number of allowed iterations
if ~isfield(para,'maxiter')
    maxiter = 500;
end
% minimum allowed perturbation
dxmin = 1e-3;
lambda=para.lambda;

%% check if A assigned and define the gradient function of f(x)
if isempty(A)
    f=@(X) 0.5*norm(X-B)^2;%f(x)
    fg=@(X) X-B; %  the gradient function of f(x)
else   
    %check if size match
    sa=size(A);
    sb=size(B);
    if sa(1)~=sb(1)
        error('The  size of Given matrices does not match !!!');
    end
    f=@(X) 0.5*norm(A*X-B)^2;%f(x)
    AtA=A'*A;
    AtB=A'*B;
    fg=@(X) AtA*X-AtB;%  the gradient function of f(x)
end


%% define the prox operator for specific constraints
switch para.pentype
    case 'ell_1'
        g=@(X) norm(X,1);
        prox=@(X) prox_l1 (X,lambda);        
    case 'ell_21'        
          g=@(X) norm_l21(X);
          prox=@(X) prox_l21 (X,lambda);
    case 'ell_tv'
          g=@(X) norm_tv(X);
          prox=@(X) prox_tv (X,lambda);
    case 'nuclear_norm'
          g=@(X) nuclear_norm(X);
          prox=@(X) prox_nuclear_norm (X,lambda);
end


%% initialization
if isfield(para,'X0') && numel(para.X0)==sa(2)*sb(2)
    X=para.X0;
else
    X=zeros(sa(2),sb(2));
end
obj=f(X)+lambda*g(X);

%% main loop
objs=[];niter = 0; dx = inf; d_obj=inf;
while and(d_obj/obj>=tol, and(niter <= maxiter, dx >= dxmin))
    % calculate gradient:
  
    grad=fg(X);
    
    % take step:
    X_new=X-eta.*grad;
    
       % projection
    X_new=prox(X_new);
    
    % check step
    if ~isfinite(double(X_new(:)))
        disp(['Number of iterations: ' num2str(niter)]);
        error('X is inf or NaN');
    end
    
 
    % update termination metrics
    niter = niter + 1;
    dx = norm(double(X_new(:)-X(:)));
    obj_new=f(X_new)+lambda*g(X);
    if  (obj_new >obj)
        disp('Function value increase: shrink step size');
        eta = eta/10;
        continue;
    end
    d_obj = abs(obj_new - obj);
    X = X_new;
    obj = obj_new;
    objs =  [objs,obj];
    if isfield(para,'flag_one_step') && para.flag_one_step
        disp(['gd stop after one iteration with approximate error: ' num2str(obj) ])
        return
    end
end

disp(['gd converge after ' num2str(niter) ' iterations with approximate error: ' num2str(obj) ])


end
