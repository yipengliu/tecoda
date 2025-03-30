function [U,output] = btd_nls(T,U0,varargin)
%BTD_CORE Computational core for block term decomposition.

% Format the tensor T.

% Check the initial factors U0
U0 = U0(:).';
if any(~cellfun(@iscell, U0))
    error('btd_core:U0', 'U0 should be a cell of cells');
end
U0 = cellfun(@(u) u(:).', U0, 'UniformOutput', false);

size_tensor = T.size;% to get the size of origin tensor

%get the dimension of tensor
N = length(U0{1}) - 1;
% Obtain the rank R of the tensor
R = length(U0);
U1 = cell(1,R);
cores = cell(1,R);
factors = cell(1,R);
for r1=1:R
    U1{r1} = cell(1,N+1);
    cores{r1} = U0{r1}{1};
    factors{r1} = cell(1,N);
    for a=1:N
        factors{r1}{a} = U0{r1}{a + 1};
        U1{r1}{a}= U0{r1}{a + 1};
    end
    U1{r1}{N+1}= double(U0{r1}{1});
end

% parse options
p = inputParser;
p.addOptional('OptimizationType', 'nls');
p.addOptional('Algorithm', @nls_gndl);
p.addOptional('CGMaxIter', 10);
p.addOptional('Display', 0);
p.addOptional('M', nan);
p.addOptional('TolLargeScale', 0.02);
p.addOptional('TolFun', 1e-12);
p.addOptional('TolX', 1e-6);
p.addOptional('TolAbs', 0);
p.KeepUnmatched = true;
p.parse(varargin{:});
fn = [fieldnames(p.Results); fieldnames(p.Unmatched)];
data = [struct2cell(p.Results); struct2cell(p.Unmatched)];
options = cell2struct(data, fn);

% Set absolute tolerances

% Calculate the square of the F norm of the tensor
cache.T2 = norm(T)^2;

options.TolAbs = 0.5*options.TolAbs*cache.T2;

% Check optimization algorithms
% Set what algorithm to use
options.OptimizationType = lower(options.OptimizationType);

nlsfun = cellfun(@func2str, {@nls_gndl,@nls_gncgs,@nls_lm}, 'UniformOutput', ...
    false);

% Select optimization subroutines.
usestate = false;
if strcmpi(options.OptimizationType, 'nls')
    usestate = true;
    dF.JHJx = @JHJx;
    dF.JHF = @grad;
    options.M = 'block-Jacobi';
    dF.M = @M_blockJacobi;
    state(U1);
else
    dF = @grad;
    if isfield(options, 'M') && isnan(options.M)
        options = rmfield(options, 'M');
    end
end

% Call the optimization method.
cache.offset = cell2mat(cellfun(@(t)cellfun(@numel,t(:).'),U1(:).', ...
    'UniformOutput',false));
cache.offset = cumsum([1 cache.offset]);
[U_tmp,output] = options.Algorithm(@objfun,dF,U1(:).',options);
U = cell(1,R);
for r1=1:R
    U{r1} = cell(1,N+1);
    for a=2:N+1
        U{r1}{a}= U_tmp{r1}{a-1};
    end
    U{r1}{1}= tensor(U_tmp{r1}{end});
end
U=BTDtensor(U);
output.Name = func2str(options.Algorithm);

if output.info == 4 && isstructured
    warning('btd_core:accuracy', ...
        ['Maximal numerical accuracy for structured tensors reached. The ' ...
        'result may be improved using ful(T) instead of T.']);
end



    function state(z)
        
        % Cache the factor matrices' Gramians.
        [idx,jdx,kdx] = ndgrid(1:R,1:N,1:R);
        cache.UHU = ...
            arrayfun(@(i,n,j)z{i}{n}'*z{j}{n}, ...
            idx,jdx,kdx,'UniformOutput',false);
        
        % Optionally cache some results for the block-Jacobi preconditioner.
        if ischar(options.M) || isa(options.M,'function_handle')
            [idx,jdx] = ndgrid(1:R,1:N);
            UHU = cache.UHU;
            cache.invSKS = arrayfun(@(r,n)inv(mtkronprod(z{r}{end},UHU(r,:,r),n)* ...
                conj(reshape(double(permute(z{r}{end},[1:n-1 n+1:N n])),[],size(z{r}{end},n)))),idx,jdx,'UniformOutput',false);
            cache.invUHU = arrayfun( ...
                @(r,n)inv(UHU{r,n,r}),idx,jdx,'UniformOutput',false);
        end
        % arrayfun(@(r,n)inv(mtkronprod(z{r}{1},UHU(r,:,r),n)*conj(reshape(permute(z{r}{1},[1:n-1 n+1:N n]),[],size(z{r}{1},n)))),idx,jdx);
        
    end

    function fval = objfun(z)
        % BTD objective function.
        
        fval = z{1}{1}*mtkronprod(z{1}{end},z{1}(1:end-1),1,'H');
        for r = 2:length(z)
            fval = fval+z{r}{1}*mtkronprod(z{r}{end},z{r}(1:end-1),1,'H');
        end
        fval = fval-reshape(T,size(fval));
        cache.residual = reshape(fval,size_tensor);
        fval = 0.5*(fval(:)'*fval(:));
        
    end

    function grad = grad(z)
        
        % BTD scaled conjugate cogradient.
        if usestate, state(z); end
        E = cache.residual;
        offset = cache.offset;
        grad = nan(offset(end)-1,1);
        cnt = 1;
        for r = 1:length(z)
            V = z{r}(1:N);
            S = conj(z{r}{end});
            for n = 1:N
                tmp = full(mtkronprod(E,V,n))* ...
                    reshape(permute(S,[1:n-1 n+1:N n]),[],size(S,n));
                grad(offset(cnt):offset(cnt+1)-1) = tmp(:);
                cnt = cnt+1;
            end
            tmp = full(mtkronprod(E,V,0));
            grad(offset(cnt):offset(cnt+1)-1) = tmp;
            cnt = cnt+1;
        end
        
    end

    function y = JHJx(z,x)
        
        % BTD fast Jacobian's Gramian vector product.
        % Ignores the fact that the tensor might be incomplete.
        offset = cache.offset;
        UHU = cache.UHU;
        [idx,jdx,kdx] = ndgrid(1:R,1:N,1:R);
        x = deserialize(x);
        XHU = arrayfun(@(i,n,j)x{i}{n}'*z{j}{n}, ...
            idx,jdx,kdx,'UniformOutput',false);
        y = nan(offset(end)-1,1);
        cnt = 1;
        for ri = 1:R
            
            % Factor matrices.
            for ni = 1:N
                idx = offset(cnt):offset(cnt+1)-1;
                Sri = permute(z{ri}{end},[1:ni-1 ni+1:N ni]);
                Sri = conj(reshape(Sri,[],size(Sri,N)));
                for rj = 1:R
                    Srj = z{rj}{end};
                    tmp = mtkronprod(x{rj}{end},UHU(rj,:,ri),ni);
                    for nj = [1:ni-1 ni+1:N]
                        proj = UHU(rj,:,ri);
                        proj{nj} = XHU{rj,nj,ri};
                        tmp = tmp+mtkronprod(Srj,proj,ni);
                    end
                    tmp = z{rj}{ni}*(tmp*Sri);
                    tmp = tmp+x{rj}{ni}* ...
                        (mtkronprod(z{rj}{end},UHU(rj,:,ri),ni)*Sri);
                    if rj == 1, y(idx) = tmp(:);
                    else y(idx) = y(idx)+tmp(:); end
                end
                cnt = cnt+1;
            end
            
            % Core tensor.
            idx = offset(cnt):offset(cnt+1)-1;
            for rj = 1:R
                Srj = z{rj}{end};
                tmp = mtkronprod(x{rj}{end},UHU(rj,:,ri),0);
                for nj = 1:N
                    proj = UHU(rj,:,ri);
                    proj{nj} = XHU{rj,nj,ri};
                    tmp = tmp+mtkronprod(Srj,proj,0);
                end
                if rj == 1, y(idx) = tmp(:);
                else y(idx) = y(idx)+tmp(:); end
            end
            cnt = cnt+1;
            
        end
        
    end

    function x = M_blockJacobi(~,b)
        
        % Solve M*x = b, where M is a block-diagonal approximation for JHJ.
        x = nan(size(b));
        offset = cache.offset;
        invSKS = cache.invSKS;
        invUHU = cache.invUHU;
        cnt = 1;
        for r = 1:R
            for n = 1:N
                idx = offset(cnt):offset(cnt+1)-1;
                tmp = reshape(b(idx),[],size(invSKS{r,n},1))*invSKS{r,n};
                x(idx) = tmp(:);
                cnt = cnt+1;
            end
            idx = offset(cnt):offset(cnt+1)-1;
            size_core = cellfun('size',invUHU(r,:),1);
            x(idx) = mtkronprod(reshape(b(idx),size_core),invUHU(r,:),0);
            cnt = cnt+1;
        end
        
    end

    function x = deserialize(x)
        off = cache.offset; tmp = x; cnt = 1;
        x = cell(1,R);
        for r = 1:R
            x{r} = cell(1,N+1);
            for n = 1:N
                x{r}{n} = reshape(tmp(off(cnt):off(cnt+1)-1),size(U1{r}{n}));
                cnt = cnt+1;
            end
            x{r}{end} = reshape(tmp(off(cnt):off(cnt+1)-1),size(U1{r}{end}));
            cnt = cnt+1;
        end
    end
end

function M=mtkronprod(T,U,n,transpose)
%MTKRONPROD Matricized tensor Kronecker product.
%   mtkronprod(T,U,n) computes the product
%
%      tens2mat(T,n)*conj(kron(U([end:-1:n+1 n-1:-1:1])))
if nargin>3
    if n==0
        M = reshape(double(mode_n_product(T, U, transpose)),1,[]);
    else
        M = mode_n_unfold(mode_n_product(T, U, -n,transpose),n);
    end
else
    if n==0
        M = reshape(double(mode_n_product(T, U)),1,[]);
    else
        M = mode_n_unfold(mode_n_product(T, U, -n),n);
    end
end

end
