
function G=TR_SVD(T,rho)
% appriximate origin data within certain error rho.
%
%--input:
%       T: origin tensor
%       rho: desired approximation errors
%--output:
%       A: tensor ring decomposition of origin tensor T
%       r: tensor ring ranks
%---------------------------

if isa(T,'tensor')
    dim=T.size;
    tnorm=norm(T);
else
    dim=size(T);
    tnorm=norm(reshape(T,1,[]),'fro');
end
d=length(dim);

%compute truncation threshold sigma(k) for k>1.
sigma=zeros(1,d);
for k=1:d
    if k == 1
        sigma(1,k)=(sqrt(2)*rho*tnorm)/sqrt(d);
    else
        sigma(1,k)=(rho*tnorm)/sqrt(d);
    end
end

%initialization
T1=mode_n_unfold(T,1);
[U,S,V]=SVT(T1, sigma(1,1) );
%obtain r1,r2
rnew = length(diag(S));

factors = divisors(rnew);
r(1)= factors(floor((length(factors) + 1) / 2));
r(2)=rnew/r(1);
A =cell(1,d);
B=cell(1,d);
A{1}=permute(reshape(U,[dim(1),r(1),r(2)]),[2,1,3]);
B{1}=permute(reshape(S*V',[r(1),r(2),prod(dim(2:d))]),[2,3,1]);

%loop

for k=2:d-1
    B{k-1}=reshape(B{k-1},[r(k)*dim(k),prod(dim(k+1:d))*r(1)]);
    [U,S,V]=SVT(B{k-1}, sigma(1,k) );
    r(k+1)=length(diag(S));
    A{k}=reshape(U,[r(k),dim(k),r(k+1)]);
    B{k}=reshape(S*V',[r(k+1),prod(dim(k+1:d)),r(1)]);
end
A{d}=B{k};
G = TRtensor(A);

end
