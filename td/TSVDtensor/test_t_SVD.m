%% test t_SVD,precise
X=double(imread('sherlock.jpg'));
X=tensor(X);% X can also be 3D array
% [U,S,V]=t_SVD(X); % default is presice
tic
[U,S,V]=t_SVD(X,'p');
toc
Xhat=t_product(U,S);
Xhat=t_product(Xhat,trans(V));
nx=norm(X);
Err=norm(calculate('minus', X, Xhat));
fprintf("precise t-SVD approximation achieves approximation error %d, relative error %d.\n",Err,Err/nx);

%% test t_SVD,precise
X=double(imread('sherlock.jpg'));
X=tensor(X);% X can also be 3D array
tic
[U,S,V]=t_SVD(X,'f');
toc
Xhat=t_product(U,S);
Xhat=t_product(Xhat,trans(V));
nx=norm(X);
Err=norm(calculate('minus', X, Xhat));
fprintf("fast t-SVD approximation achieves approximation error %d, relative error %d.\n",Err,Err/nx);

%% tset TSVDtensor
X=double(imread('sherlock.jpg'));
X=tensor(X);% X can also be 3D array
TSVD = TSVDtensor(X);
Xhat = TSVD2tensor(TSVD);
nx=norm(X);
Err=norm(calculate('minus', X, Xhat));
fprintf("precise t-SVD approximation achieves approximation error %d, relative error %d.\n",Err,Err/nx);

