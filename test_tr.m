%% test TR_SVD and TR_ALS
X=rand(200,300,40);
X=tensor(X);
options.Rmax = 4;
options.MaxIter = 50;
G1 = TR_SVD(X, options);
Y1 = cores2tr(G1);
error1 = norm(calculate('minus', X, Y1));

G2 = TR_ALS(X, options);
Y2 = cores2tr(G2);
error2 = norm(calculate('minus', X, Y2));

nx = norm(X);
fprintf("TR_SVD approximation achieves approximation error %d, relative error %.8f.\n",error1,error1/nx);
fprintf("TR_ALS approximation achieves approximation error %d, relative error %.8f.\n",error2,error2/nx);