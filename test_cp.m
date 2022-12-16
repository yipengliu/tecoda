%test_cp()
clear all;

%example 1 
N=3;
P=[5,8,10];
R=3;
U=cell(3,1);
for n=1:N
    U{n}=rand(P(n),R);
end

T=cptensor(U);
X=cp2tensor(T);
if isa(X,'tensor')
    sx=X.size;
else
sx=size(X);
end

assert(prod(P)==prod(sx))