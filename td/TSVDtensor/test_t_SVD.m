%% test t_SVD,precise
X=double(imread('sherlock.jpg'));
X=tensor(X);% X can also be 3D array
% [U,S,V]=t_SVD(X); % default is presice
tic
TSVDtensor1=t_SVD(X,'p');
toc
Xhat=t_product(TSVDtensor1.U,TSVDtensor1.S);
Xhat=t_product(Xhat,trans(TSVDtensor1.V));
nx=norm(X);
Err=norm(calculate('minus', X, Xhat));
fprintf("precise t-SVD approximation achieves approximation error %d, relative error %d.\n",Err,Err/nx);

%% test t_SVD,precise
X=double(imread('sherlock.jpg'));
X=tensor(X);% X can also be 3D array
tic
TSVDtensor2=t_SVD(X,'f');
toc
Xhat=t_product(TSVDtensor2.U,TSVDtensor2.S);
Xhat=t_product(Xhat,trans(TSVDtensor2.V));
nx=norm(X);
Err=norm(calculate('minus', X, Xhat));
fprintf("fast t-SVD approximation achieves approximation error %d, relative error %d.\n",Err,Err/nx);

%% test TSVDtensor
X=double(imread('sherlock.jpg'));
X=tensor(X);% X can also be 3D array
TSVDtensor3 = t_SVD(X);
Xhat = TSVD2tensor(TSVDtensor3);
nx=norm(X);
Err=norm(calculate('minus', X, Xhat));
fprintf("precise t-SVD approximation achieves approximation error %d, relative error %d.\n",Err,Err/nx);
