%%% test 

%% mode-n-product
dim=[3,3,5];
A=rand(dim);
A=tensor(A);
B=tensor("iden",dim);
C=mode_n_unfold(A,1);
C=mode_n_unfold(A,2);
C=mode_n_unfold(A,3);

%% k-unfold
C=k_unfold(A,1);
C=k_unfold(A,2);