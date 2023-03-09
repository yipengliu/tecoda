%% test TT_SVD and TT_als
X=rand(200,300,40);
X=tensor(X);
options.Rmax = 4;
options.MaxIter = 50;
TT1 = TT_SVD(X, options);
T1 = tt2tensor(TT1);
error1 = norm(calculate('minus', X, T1));

TT2 = TT_als(X, options);
T2 = tt2tensor(TT2);
error2 = norm(calculate('minus', X, T2));

nx = norm(X);
fprintf("TT_SVD approximation achieves approximation error %d, relative error %.8f.\n",error1,error1/nx);
fprintf("TT_als approximation achieves approximation error %d, relative error %.8f.\n",error2,error2/nx);