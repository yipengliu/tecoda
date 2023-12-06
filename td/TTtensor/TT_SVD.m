function TT = TT_SVD(T,rho)
% appriximate origin data within certain error rho.
%
%--input:
%       T: origin tensor
%       rho: desired approximation errors
%--output:
%       A: tensor train decomposition of origin tensor T
%       r: tensor train ranks
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
sigma=rho*tnorm/sqrt(d-1);

 

%initialization
T1=mode_n_unfold(T,1);
[U,S,V]=SVT(T1, sigma );
%obtain r1,r2
rnew = length(diag(S));

r(1)= 1;
r(2)=rnew;
A =cell(1,d);
B=cell(1,d);
A{1}=reshape(U,[r(1),dim(1),r(2)]);
B{1}=reshape(S*V',[r(2),prod(dim(2:d))]);

%loop

for k=2:d-1
    B{k-1}=reshape(B{k-1},[r(k)*dim(k),prod(dim(k+1:d))]);
    [U,S,V]=SVT(B{k-1}, sigma );
    r(k+1)=length(diag(S));
    A{k}=reshape(U,[r(k),dim(k),r(k+1)]);
    B{k}=reshape(S*V',[r(k+1),prod(dim(k+1:d)),r(1)]);
end
A{d}=B{k};
TT = TTtensor(A);