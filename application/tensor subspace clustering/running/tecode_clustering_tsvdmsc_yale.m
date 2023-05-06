%% For convinience, we assume the order of the tensor is always 3;
clear all; 
close all; 
clc;
addpath('../preprocessing');
addpath('../preprocessing/ClusteringMeasure');
addpath('../../../database/multi-view datasets');

load('yale.mat');
cls_num = length(unique(gt));
X{1} = X2; X{2} =X1; X{3} = X3;
%% Note: each column is an sample (same as in LRR)
%% 
 for v=1:3
    [X{v}]=NormalizeData(X{v});
     %X{v} = zscore(X{v},1);
end
% Initialize...

K = length(X); N = size(X{1},2); %sample number

for k=1:K
    Z{k} = zeros(N,N); %Z{2} = zeros(N,N);
    W{k} = zeros(N,N);
    G{k} = zeros(N,N);
    E{k} = zeros(size(X{k},1),N); %E{2} = zeros(size(X{k},1),N);
    Y{k} = zeros(size(X{k},1),N); %Y{2} = zeros(size(X{k},1),N);
end

w = zeros(N*N*K,1);
g = zeros(N*N*K,1);
dim1 = N;dim2 = N;dim3 = K;
myNorm = 'tSVD_1';
sX = [N, N, K];
%set Default
parOP         =    false;
ABSTOL        =    1e-6;
RELTOL        =    1e-4;


Isconverg = 0;epson = 1e-7;
lambda =1.1; %1.5 best
iter = 0;
mu = 10e-5; max_mu = 10e10; pho_mu = 2;
rho = 0.0001; max_rho = 10e12; pho_rho = 2;
tic;

while(Isconverg == 0)
    fprintf('----processing iter %d--------\n', iter+1);
    for k=1:K
        %1 update Z^k
        tmp = (X{k}'*Y{k} + mu*X{k}'*X{k} - mu*X{k}'*E{k} - W{k})./rho +  G{k};
        Z{k}=inv(eye(N,N)+ (mu/rho)*X{k}'*X{k})*tmp;
        
        %2 update E^k
        F = [X{1}-X{1}*Z{1}+Y{1}/mu;X{2}-X{2}*Z{2}+Y{2}/mu;X{3}-X{3}*Z{3}+Y{3}/mu];
        %F = [X{1}-X{1}*Z{1}+Y{1}/mu;X{2}-X{2}*Z{2}+Y{2}/mu];
        [Econcat] = solve_l1l2(F,lambda/mu);
        %F = F';
        %[Econcat,info] = prox_l21(F, 0.5/1);
        E{1} = Econcat(1:size(X{1},1),:);
        E{2} = Econcat(size(X{1},1)+1:size(X{1},1)+size(X{2},1),:);
        E{3} = Econcat(size(X{1},1)+size(X{2},1)+1:end,:);
        %3 update Yk
        %Y{k} = Y{k} + mu*(X{k}-X{k}*Z{k}-E{k});
        Y{k} = Y{k} + mu*(X{k}-X{k}*Z{k}-E{k});
    end
    
    %4 update G
    Z_tensor = cat(3, Z{:,:});
    W_tensor = cat(3, W{:,:});
    z = Z_tensor(:);
    w = W_tensor(:);
    
    %twist-version
   [g, objV] = wshrinkObj(z + 1/rho*w,1/rho,sX,0,3)   ;
    G_tensor = reshape(g, sX);
    
    %5 update W
    w = w + rho*(z - g);
    
    %record the iteration information
    history.objval(iter+1)   =  objV;

    %% coverge condition
    Isconverg = 1;
    for k=1:K
        if (norm(X{k}-X{k}*Z{k}-E{k},inf)>epson)
            history.norm_Z = norm(X{k}-X{k}*Z{k}-E{k},inf);
            fprintf('    norm_Z %7.10f    ', history.norm_Z);
            Isconverg = 0;
        end
        
        G{k} = G_tensor(:,:,k);
        W_tensor = reshape(w, sX);
        W{k} = W_tensor(:,:,k);
        if (norm(Z{k}-G{k},inf)>epson)
            history.norm_Z_G = norm(Z{k}-G{k},inf);
            fprintf('norm_Z_G %7.10f    \n', history.norm_Z_G);
            Isconverg = 0;
        end
    end
   
    if (iter>100)
        Isconverg  = 1;
    end
    iter = iter + 1;
    mu = min(mu*pho_mu, max_mu);
    rho = min(rho*pho_rho, max_rho);
end
S = 0;
for k=1:K
    S = S + abs(Z{k})+abs(Z{k}');
end

 for i=1:10
        C = SpectralClustering(S,cls_num);% C = kmeans(U,numClust,'EmptyAction','drop');
        [Fi(i),Pi(i),Ri(i)] = compute_f(gt,C);
        [A nmii(i) avgenti(i)] = compute_nmi(gt,C);    
        ACCi(i) = Accuracy(C,double(gt));
        if (min(gt)==0)
            [ARi(i),RIi(i),MIi(i),HIi(i)]=RandIndex(gt+1,C);
        else
            [ARi(i),RIi(i),MIi(i),HIi(i)]=RandIndex(gt,C);
        end       
 end

    F(1) = mean(Fi); F(2) = std(Fi);
    P(1) = mean(Pi); P(2) = std(Pi);
    R(1) = mean(Ri); R(2) = std(Ri);
    nmi(1) = mean(nmii); nmi(2) = std(nmii);
    avgent(1) = mean(avgenti); avgent(2) = std(avgenti);
    AR(1) = mean(ARi); AR(2) = std(ARi);
    ACC(1)=mean(ACCi); ACC(2)=std(ACCi);
    
    fprintf('F: %.3f(%.3f)\n', F(1), std(Fi));
    fprintf('P: %.3f(%.3f)\n', P(1), std(Pi));    
    fprintf('R: %.3f(%.3f)\n', R(1), std(Ri));
    fprintf('nmi:%.3f(%.3f)\n', nmi(1), std(nmii));
%     fprintf('avgent: %f(%f)\n', avgent(1), std(avgenti));
    fprintf('AR: %.3f(%.3f)\n', AR(1), std(ARi));
    fprintf('ACC: %.3f(%.3f)\n',  ACC(1), std(ACCi));
% toc;

