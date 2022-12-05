%test_op()

%% test Orthogonal Procrustes Problem with only one objective function

%example 1 
% min 0.5*||QA-A||_F^2 s.t. Q^T*Q=I
% solution: Q=I

disp('%%%%%%%%%%%%Exp 1%%%%%%%%%%%%%%%%%');

disp(' min 0.5*||QA-A||_F^2 s.t. Q^T*Q=I');
disp('Genarate a random matrix A')
A=rand(5,4);
disp('A=');
disp(A)
disp('get the orthogonal solution through Q=op(A,A,0.5);')
Q=op(A,A,0.5);
disp('The solution is ');
disp('Q=');
disp(Q)
if norm(Q-eye(size(Q)),'fro')<1e-10
    disp('The solution is an identity matrix');
end


%example 2
% min 0.5*||QA-B||_F^2 s.t. Q^T*Q=I
clear all;

disp('%%%%%%%%%%%%Exp 2%%%%%%%%%%%%%%%%%');
disp(' min 0.5*||QA-B||_F^2 s.t. Q^T*Q=I');

disp('generate a random orthgonal matrix Q by QR factorization')
X=rand(5,5);
[Q,~]=qr(X);
disp('Q=');
disp(Q)

if norm(Q'*Q-eye(size(Q)),'fro')<1e-10
    disp('The generated Q is orthognal !')
end
disp('Genarate a random matrix A')
A=rand(5,4);
disp('A=');
disp(A)
disp('Genarate B=Q*A')
B=Q*A;
disp('B=');
disp(B)
disp('get the orthogonal solution through Q=op(A,B,0.5);')
Q_hat=op(A,B,0.5);
disp('The solution is ');
disp('Q_hat=');
disp(Q_hat)
if norm(Q-Q_hat,'fro')<1e-10
    disp('The solution is what we generated !!!');
end
%% test Orthogonal Procrustes Problem with several objective functions
clear all;
disp('%%%%%%%%%%%%Exp 3%%%%%%%%%%%%%%%%%');
disp(' min sum_n 0.5*||QA{n}-B{n}||_F^2 s.t. Q^T*Q=I');

disp('generate a random orthgonal matrix Q by QR factorization')
X=rand(5,5);
[Q,~]=qr(X);
disp('Q=');
disp(Q)

if norm(Q'*Q-eye(size(Q)),'fro')<1e-10
    disp('The generated Q is orthognal !')
end
disp('Genarate random matrices A{1},..., A{N}')
N=5;
for n=1:N
A{n}=rand(5,4);
end
disp('For example, A{1}=');
disp(A{1})
disp('Genarate B{n}=Q*A{n}')
for n=1:N
B{n}=Q*A{n};
rho{n}=0.5;
end
disp('For example, B{1}=');
disp(B{1})

disp('get the orthogonal solution through Q=op(A,B,rho);')
Q_hat=op(A,B,rho);
disp('The solution is ');
disp('Q_hat=');
disp(Q_hat)
if norm(Q-Q_hat,'fro')<1e-10
    disp('The solution is what we generated !!!');
end