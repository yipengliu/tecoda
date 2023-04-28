function M = mtkronprod(T,U,n,transpose)
%MTKRONPROD Matricized tensor Kronecker product.
%   mtkronprod(T,U,n) computes the product
%
%      tens2mat(T,n)*conj(kron(U([end:-1:n+1 n-1:-1:1])))

if nargin < 4, transpose = 0; end
if ischar(transpose)
    if strcmp(transpose,'T'), transpose = 1;
    elseif strcmp(transpose,'H'), transpose = 1i; end
end
U = U(:).';
if transpose == 0, size_tens = cellfun('size',U,1);
else size_tens = cellfun('size',U,2); end
data = T;
N = length(size_tens);
if transpose == 0, size_core = cellfun('size',U,2);
else size_core = cellfun('size',U,1); end
if n > 0, size_core(n) = size_tens(n); end
R = prod(size_core([1:n-1 n+1:N]));

% Determine if large-scale version of the algorithm should be executed.
ratio = size_core./size_tens;
perm = zeros(1,N);
l = 1; r = N;
for i = 1:N
    if r == n || (l < n && ratio(l) < ratio(r)), perm(i) = l; l = l+1;
    else perm(i) = r; r = r-1;
    end
end
if n == 0, mem = 8*prod(size_tens);
else mem = 8*prod(size_tens([1:perm(1)-1 perm(1)+1:N]))*size_core(perm(1));
end
    
% Apply structure-exploiting matricized tensor Kronecker product.
M = T;
cpl = cumprod([1 size_core(perm(perm < n))]); l = 1;
cpr = cumprod([1 size_core(perm(perm > n))]); r = 1;
for i = 1:length(perm)
    
    mode = perm(i);
    if mode < n
        
        tmp = reshape(M,[cpl(l)*size_tens(mode),prod(size(M))/(cpl(l)*size_tens(mode))]);
        M = zeros(cpl(l),size(tmp,2)*size_core(mode));
        for j = 1:cpl(l)
            idx = j:cpl(l):size(tmp,1);
            switch transpose
                case 0,  tmp2 = U{mode}'*tmp(idx,:);
                case 1,  tmp2 = conj(U{mode})*tmp(idx,:);
                case 1i, tmp2 = U{mode}*tmp(idx,:);
            end
            M(j,:) = tmp2(:);
        end
        l = l+1;
        
    elseif mode > n
        
        tmp = reshape(M,[prod(size(M))/(cpr(r)*size_tens(mode)),cpr(r)*size_tens(mode)]);
        M = zeros(size(tmp,1)*size_core(mode),cpr(r));
        for j = 1:cpr(r)
            idx = (1:size_tens(mode))+(j-1)*size_tens(mode);
            switch transpose
                case 0,  tmp2 = tmp(:,idx)*conj(U{mode});
                case 1,  tmp2 = tmp(:,idx)*U{mode}';
                case 1i, tmp2 = tmp(:,idx)*U{mode}.';
            end
            M(:,j) = tmp2(:);
        end
        r = r+1;
        
    end
    
end

% Permute and reshape output.
if n > 1
    M = reshape(M,[cpl(end) size_tens(n) cpr(end)]);
    M = reshape(permute(M,[2 1 3]),[size_tens(n),prod(size(M))/size_tens(n)]);
else
    if n == 0, M = reshape(M,[1,prod(size(M))]);
    else M = reshape(M,[size_tens(n),prod(size(M))/size_tens(n)]); end
end

end