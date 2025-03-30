function [X,fs]=gd(A,B,para)

% gradient descent algorithm:
% solving problem
% min ||B-AX||_F^2
% min sum_m f_m=sum_i w(i).*||B{m}-A{m}*X||_F^2

% Input
% A- a N*P predictor or a cell of {A{1},....,A{M}} for M functions
% B- a N*Q response or a cell of {B{1},....,B{M}} for M functions
% w-weight vector for M functions
% X0-inital value for X
% flag_one_step-one step update flag, only update one step if flag is true
% eta-step size for gradient descent
%
% Output
% X-required weight matrix
% fs-history recordings for values of objective function


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

%

if  ~isa(A,'cell')
    A={A};
    B={B};
    
end

%check if matrix size match
M=length(A);

if ~isfield(para,'w')
    w=repmat(1./M,M,1);
else
    w=para.w;
end

for m=1:M
    sa=size(A{m});
    sb=size(B{m});
    if sa(1)~=sb(1)
        error('Matrix size not match !!!!');
    end
end

%% initalize X as zero matrix

if isfield(para,'X0') && numel(para.X0)==sa(2)*sb(2)
    X=para.X0;
else
    X=zeros(sa(2),sb(2));
end

% initialize iteration counter, perturbation
niter = 0; dx = inf; df=inf;
fs = [];

f=0;
for m=1:M
    gap=A{m}*X-B{m};
    f = f+w(m).*norm((gap))^2;
end

while and(df/f>=tol, and(niter <= maxiter, dx >= dxmin))
    % calculate gradient:
    
    grad=zeros(size(X));
    for m=1:M
        grad=grad+2*w(m).*A{m}'*(A{m}*X-B{m});
    end
    
    % take step:
    X_new=X-eta.*grad;
    
    % check step
    if ~isfinite(double(X_new(:)))
        disp(['Number of iterations: ' num2str(niter)]);
        error('X is inf or NaN');
    end
    
    % update termination metrics
    niter = niter + 1;
    dx = norm(double(X_new(:)-X(:)));
    fnew=0;
    for m=1:M
        gap=A{m}*X_new-B{m};
        fnew = fnew+w(m).*norm((gap))^2;
    end
    if  (fnew >f)
        disp('Function value increase: shrink step size');
        eta = eta/10;
        continue;
    end
    df = abs(fnew - f);
    X = X_new;
    f = fnew;
    fs =  [fs,f];
    if isfield(para,'flag_one_step') && para.flag_one_step
        disp(['gd stop after one iteration with approximate error: ' num2str(f) ])
        return
    end
end

disp(['gd converge after ' num2str(niter) ' iterations with approximate error: ' num2str(f) ])

end