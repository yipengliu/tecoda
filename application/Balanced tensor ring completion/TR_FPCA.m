function [x,err,mu,run_time]=TR_FPCA(tnsr,P,mu_min,flag)
%% tensor augmentation
% if N is odd, augment it by adding one dimension
N=ndims(tnsr);
J=size(tnsr);
if mod(N,2)==1
    J=[J,1];
    tnsr=reshape(tnsr,J);
    P=reshape(P,J);
    N=N+1;
end
%% initialize parameters
x=zeros(J);
xtemp=zeros(J);
t=1.999;
mu_max=zeros(N/2,1);
sk=zeros(N/2,1);
for n=1:N/2
    order=[n:N 1:n-1];
    X_temp=permute(P.*tnsr,order);
    X=reshape(X_temp,prod(J(order(1:N/2))),[]);
    mu_max(n)=norm(X,2);
    sk(n)=min(size(X));
end
mu_max=max(mu_max)/pi^4;
mu=mu_max;
epsilon=1e-2;
xtol=1e-4;
errtol=1e-6;
x_old=-ones(J);
maxiter=1000;
err=zeros(maxiter,1);
err(1)=inf;
F0=norm(tnsr(:),2);
num_dvg=0;
num_cvg=0;
i=2;
%% FPCA algorithm
tic
while mu>mu_min
    while norm(x(:)-x_old(:),2)/norm(x_old(:),2)>xtol*sqrt(mu/mu_max)
        x_old=x;
        y=x-t*P.*(x-tnsr);
        for n=1:N/2
            order=[n:N 1:n-1];           
            Z_temp=permute((N*x+2*y)/(N+2),order);
            Z=reshape(Z_temp,prod(J(order(1:N/2))),[]);
            [u,s,v]=svds(Z,sk(n));
            s_vec=diag(s)-N*t*mu/(N+2);
            idx=find(s_vec>0,1,'last');
            sk(n)=find(s_vec>=epsilon*s_vec(1),1,'last');
            s_shrink=diag(s_vec(1:idx));
            Y=u(:,1:idx)*s_shrink*v(:,1:idx)';
            Y_temp=reshape(Y,J(order));
            ytemp=ipermute(Y_temp,order);
            xtemp=xtemp+ytemp;
        end
        x=2*xtemp/N;
        %if fr>0.6
        %    x=(1-P).*x+P.*tnsr;
        %end
        xtemp=zeros(J);
        if norm(x(:),2)>norm(x_old(:),2)
            sk=sk+1;
        end
        err(i)=norm(x(:)-tnsr(:),2)/F0;
        if flag && mod(i,10)==0
            fprintf('Iteratoin=%d\tRE=%f\n',i-1,err(i));
        end
        if err(i)>err(i-1)
            num_dvg=num_dvg+1;
        else
            if 1-err(i)/err(i-1)<errtol
                num_cvg=num_cvg+1;
            end
        end
        i=i+1;
        if num_dvg>=10||num_cvg>=10
            break    
        end
    end
    if num_dvg>=10||num_cvg>=10
        break    
    end
    mu=mu/pi;
end
run_time=toc;
fprintf('running time=%fs\n',run_time);
err(1)=[];
err(err==0)=[];
end