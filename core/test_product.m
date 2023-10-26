%%% test 

%% inner product
dim=[3,3,5];
A=rand(dim);
A=tensor(A);
B=tensor('iden',dim);
C=inner_product(A,B);

%% outer product
dim=[3,4,5];
a=rand(3,1);
b=rand(4,1);
c=outer_product(a,b);


M=3;
a=cell(M,1);
for m=1:M
    a{m}=rand(dim(m),1);
end
c=outer_product(a);

%% mode-n-product
dim=[3,4,5];
A=rand(dim);
A=tensor(A);
C=mode_n_product(A,a{1},1);
C=mode_n_product(A,a);
C=mode_n_product(A,a,-2);
C=mode_n_product(A,a(1:2),[1,2]);
A=tensor(rand(6,4,1));
A = reshape(A, [6,4,1]);
a=cell(3,1);
a{1} = rand(49,6);
a{2} = rand(31,4);
a{3} = rand(22,1);
C=mode_n_product(A,a,'T');
%% t-product
    %   T1 -- Tensor1 in Size(l, p, n)
    %   T2 -- Tensor2 in Size(p, m, n)
B=rand([4,2,5]);
B=tensor(B);
C=t_product(A,B);

%% tensor contraction
B=rand([5,2,5]);
B=tensor(B);
C=tensor_contraction(A,B,3, 3);


B=rand([4,5,5]);
B=tensor(B);
C=tensor_contraction(A,B,3, 2);

%% kron

A=rand(3,4);
B=rand(2,2);
C=kron(A,B);
C1=Kronecker_product(A,B);
C2=Kronecker_product(A,B,'r');

%% khatirao

A=rand(3,4);
B=rand(2,4);
C=khatrirao_product(A,B);
D=khatrirao_product(A,B,C);
E=khatrirao_product(A,B,C,'r');


%% mtkr_product
clear
dim=[3,4,5,6];
M=length(dim);
a=cell(M,1);
for m=1:M
    a{m}=rand(dim(m),2);
end
A = rand(3,4,5,10);
B = mtkr_product(A, a, 4);

dim=[3,4,5,6];
M=length(dim);
a=cell(M,1);
for m=1:M
    a{m}=rand(3, dim(m));
end
A = rand(3,4,5,10);
B = mtkr_product(A, a, 4, 'T');
