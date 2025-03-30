function T = CP_ALS(X,R,options)
%CP_ALS Compute a CP decomposition of an given tensor.
%
%   T = CP_ALS(X,R) computes best rank-R CP approximation of tensor X using an alternating least-squares algorithm.
%
%   Input:
%   X : a tensor
%   R : predefined CP rank

%   Output:
%   T : a CP tensor
%

%% dimension
if isa(X,'tensor')
    dim=X.size;
    D=length(dim);
else
    dim=size(X);
    D=length(dim);
end

%% settings
if nargin < 3, options = struct; end
if ~isfield(options, 'MaxIter'), options.MaxIter = 1e3; end
if ~isfield(options, 'tol'), options.tol = 1e-5; end
if ~isfield(options,'init'),options.init='random';end
if ~isfield(options,'disp'),options.disp=true;end

%% initialization

if iscell(options.init)
    Uinit = init;
    if numel(Uinit) ~= D
        error('initialized factors should have %d cells',D);
    end
    for d=1:D
        if ~isequal(size(Uinit{d}),[dim(d) R])
            error('The initialized %d-th factor should be sized [%d,%d]',d,dim(d),R);
        end
    end
else
    if strcmp(options.init,'random')
        Uinit = cell(D,1);
        for d = 1:D
            Uinit{d} = rand(dim(d),R);
        end
    elseif strcmp(options.init,'svd')
        Uinit = cell(D,1);
        for d = 1:D
            Xd=mode_n_unfold(X,d);
            [uu,~,~]=svd(Xd);
            Uinit{d} = uu(:,1:R);
        end
    else
        error('initialization method not supported !!');
    end
end

T = CPtensor();
T.size=dim;
T.rank=R;
%% Main Loop
    U=Uinit; clear Uinit
    UtU = zeros(R,R,D);
    Xd=cell(D,1);
    for d = 1:D
        if d==1
            Xd{1}=reshape(X,[dim(1),prod(dim(2:D))]);
        elseif d==D
            Xd{D}=reshape(X,[prod(dim(1:D-1)),dim(D)])';
        else         
        temp=permute(X,[d 1:d-1,d+1:D]);
        Xd{d}=reshape(double(temp),[dim(d),prod(dim)/dim(d)]);
        end
        if ~isempty(U{d})
            UtU(:,:,d) = U{d}'*U{d};
        end
        
    end
    Err_o=1e3;
    for iter = 1:options.MaxIter
        
        
        for d = 1:D         
            
            Z = khatrirao_product(U{[1:d-1,d+1:D]},'r');% caculate khatrirao(all U except n, 'r')
            
            XU = Xd{d}*Z;
                        
            Y = prod(UtU(:,:,[1:d-1 d+1:D]),3);
            Unew = XU / Y;
                
            
            % update lambda
            if iter == 1
                lambda = sqrt(sum(Unew.^2,1))'; %2-norm
            else
                lambda = max( max(abs(Unew),[],1), 1 )'; %max-norm
            end
            
            Unew = bsxfun(@rdivide, Unew, lambda');
            
            U{d} = Unew;
            UtU(:,:,d) = U{d}'*U{d};
        end
        
        
        T.weights=lambda;
        T.factors=U;
        
        
        Err=norm(calculate('minus',X,CP2tensor(T)));%% calculate the approximation error
        % Err = norm(X-CP2tensor(T));
        
        % Check for convergence
        if (abs(Err_o - Err) < options.tol)
            break
        end
        Err_o=Err;
        if options.disp && mod(iter,10)==0
            fprintf(' Iter %2d: Err = %e Err-delta = %7.1e\n', iter, Err, abs(Err_o - Err));
        end
        
    end


    fprintf(' Final Err = %e \n', Err);


