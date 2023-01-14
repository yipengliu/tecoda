%% test t_SVD
X=double(imread('sherlock.jpg'));
X=tensor(X);
[U,S,V]=t_SVD(X);
Xhat=t_product(U,S);
Xhat=t_product(Xhat,trans(V));
nx=norm(X);
Err=norm(calculate('minus', X, Xhat));
fprintf("t-SVD approximation achieves approximation error %d, relative error %d.\n",Err,Err/nx);

