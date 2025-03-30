%%% test 
idx = 20;
sum1 = 0.0;
sum2 = 0.0;
sum3 = 0.0;
su1 = 1;
su2 = 1;
su3 = 1;
for i = 1:idx
    w1 = power(2,i);
    w2 = i;
    w3 = power(2,2*i);
    su1=su1*w1;
    sum1 = sum1+1.0*(w1-1)*i/su1;
    su2=su2*w2;
    sum2=sum2+1.0*(w2-1)*i/su2;
    su3=su3*w3;
    sum3=sum3+1.0*(w3-1)*i/su3;
end
disp(sum1);
disp(sum2);
disp(sum3);
Qpause = true;
%% inner product
dim=[3,3,5];
% A=rand(dim);
% A=tensor(A);
% B=tensor('iden',dim);
% C=inner_product(A,B);
A=rand(dim);
A=tensor(A);
B=rand(dim);
B=tensor(B);
C=inner_product(A,B);

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

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

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

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

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end
%% t-product
    %   T1 -- Tensor1 in Size(l, p, n)
    %   T2 -- Tensor2 in Size(p, m, n)
A = tensor(rand([3,4,5]));
B = tensor(rand([4,2,5]));
C=t_product(A,B);

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end
%% tensor contraction
B=rand([5,2,5]);
B=tensor(B);
C=tensor_contraction(A,B,3, 3);

B=rand([4,5,5]);
B=tensor(B);
C=tensor_contraction(A,B,3, 2);

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end
%% kron

A=rand(3,4);
B=rand(2,2);
C=kron(A,B);
C1=Kronecker_product(A,B);
C2=Kronecker_product(A,B,'r');

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end
%% khatirao

A=rand(3,4);
B=rand(2,4);
C=khatrirao_product(A,B);
D=khatrirao_product(A,B,C);
E=khatrirao_product(A,B,C,'r');

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end
%% mtkr_product
clear
dim=[3,4,5,6];
M=length(dim);
a=cell(M,1);
for m=1:M
    a{m}=rand(dim(m),2);
end
A = rand(10,4,5,6);
B = mtkr_product(A, a, 1);
disp(a);


clear
dim=[3,4,5,6];
M=length(dim);
a=cell(M,1);
for m=1:M
    a{m}=rand(dim(m),2);
end
A = rand(3,10,5,6);
B = mtkr_product(A, a, 2);

dim=[3,4,5,6];
M=length(dim);
a=cell(M,1);
for m=1:M
    a{m}=rand(3, dim(m));
end
A = rand(3,4,5,10);
B = mtkr_product(A, a, 4, 'T');
