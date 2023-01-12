%% test t_SVD
X=double(imread('sherlock.jpg'));
X=tensor(X);
[U,S,V]=t_SVD(X);
Xhat=t_product(U,S);
Xhat=t_product(Xhat,transpose(V));
nx=norm(X);
Err=norm(calculate('minus', X, Xhat));
fprintf("t-SVD approximation achieves approximation error %d, relative error %d.\n",Err,Err/nx);
function Xt=transpose(X)
    Xt=tensor('zeros',[X.size(2),X.size(1),X.size(3)]);
    Xt(:,:,1)=Xt(:,:,1)';
    I3=X.size(3);
    for i3=2:I3
        Xt(:,:,i3)=X(:,:,I3-i3+2)';
    end
end
