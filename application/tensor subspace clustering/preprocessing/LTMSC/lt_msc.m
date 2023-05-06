function [f,p,r,nmi,ar,acc] = lt_msc(X, gt, lambda)
V = length(X);
cls_num = length(unique(gt));
%% Note: each column is an sample (same as in LRR)
%% 
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
ModCount = 3; %unfold_mode_number
for v=1:ModCount
    para_ten{v} =lambda;
end

iter = 0;
mu = 10e-5; max_mu = 10e10; pho_mu = 2;%5
rho = 10e-5; max_rho = 10e12; pho_rho = 2;

Z_tensor = cat(3, Z{:,:});
G_tensor = cat(3, G{:,:});
G_1 = cat(3, G{:,:});
W_tensor = cat(3, W{:,:});

for i=1:ModCount
    WT{i} = W_tensor;
end
while(Isconverg == 0)
    fprintf('----processing iter %d--------\n', iter+1);
    for k=1:K
        %1 update Z^k
        tmp = (X{k}'*Y{k} + mu*X{k}'*X{k} - mu*X{k}'*E{k} - W{k})./rho +  G{k};
        Z{k}=inv(eye(N,N)+ (mu/rho)*X{k}'*X{k})*tmp;
        
        %2 update E^k
         F = [];
        for v=1:K
             F = [F;X{v}-X{v}*Z{v}+Y{v}/mu];
        end
        [Econcat] = solve_l1l2(F,lambda/mu);
        
        beg_ind = 0;
        end_ind = 0;
        for v=1:K
            if(v>1)
                beg_ind = beg_ind+size(X{v-1},1);
            else
                beg_ind = 1;
            end
            end_ind = end_ind+size(X{v},1);
            E{v} = Econcat(beg_ind:end_ind,:);
        end
        %3 update Yk
        Y{k} = Y{k} + mu*(X{k}-X{k}*Z{k}-E{k});
    end
    
    %4 update G
    Z_tensor = cat(3, Z{:,:});
    W_tensor = cat(3, W{:,:});
    z = Z_tensor(:);
    w = W_tensor(:);

    for umod=1:ModCount
        G_tensor = updateG_tensor(WT{umod},Z,sX,mu,para_ten,V,umod);
        WT{umod} = WT{umod}+mu*(Z_tensor-G_tensor);%alpha
    end

    %% coverge condition
    Isconverg = 1;
    for k=1:K
        if (norm(X{k}-X{k}*Z{k}-E{k},inf)>epson)
            history.norm_Z = norm(X{k}-X{k}*Z{k}-E{k},inf);
            Isconverg = 0;
        end
        
        G{k} = G_tensor(:,:,k);
        W_tensor = cat(3, WT{:,:});
        W{k} = W_tensor(:,:,k);
        if (norm(Z{k}-G{k},inf)>epson)
            history.norm_Z_G = norm(Z{k}-G{k},inf);
            Isconverg = 0;
        end
    end
   
    if (iter>50)
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
    f=F(1);
    p=P(1);
    r=R(1);
    nmi=nmi(1);
    ar=AR(1);
    acc=ACC(1);
    fprintf('F: %.3f(%.3f)\n', F(1), std(Fi));
    fprintf('P: %.3f(%.3f)\n', P(1), std(Pi));    
    fprintf('R: %.3f(%.3f)\n', R(1), std(Ri));
    fprintf('nmi: %.3f(%.3f)\n', nmi(1), std(nmii));
    fprintf('AR: %.3f(%.3f)\n', AR(1), std(ARi));
    fprintf('ACC: %.3f(%.3f)\n',  ACC(1), std(ACCi));




