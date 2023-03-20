function [Z_group,Da,De,errList] = LTDL(Da,De,nclusters,All_group,R,lamda1,lamda2,par)
%
% the optimization algorithm of proposed Low-rank Tensor Dictionary Learning (LTDL)
%
C_group = cell(1,nclusters);
YC_group = cell(1,nclusters);
T_group = cell(1,nclusters);
epsilon = par.epsilon;
max_iternum = par.max_iter;
rho = par.rho;
errList = zeros(max_iternum, 1);
sizX = zeros(nclusters,3);
sizDa = size(Da,2);
sizDe = size(De,2);
%% initialize Z 
Z_group = cell(1,nclusters); 
D = (kron(De,Da))';
invD = pinv(D*D');
for kk = 1:nclusters
    X = All_group{kk};
    sizX(kk,:) = size(X);
    X3 = mode_n_unfold(X,3);
    Z3 = (X3*D')*invD;
    Z = double(mode_n_fold(Z3,3,[sizDa sizDe sizX(kk,3)]));
    Z_group{kk} = Z;
    YC_group{kk} = zeros([sizDa sizDe sizX(kk,3)]);
end
for k = 1:max_iternum
    %fprintf('Inter:%f \n',k);
    errZ = 0;
    D = (kron(De,Da))';
    d = size(D);
    [Uspa,Sspa,~] = svd(Da'*Da);
    [Uspe,Sspe,~] = svd(De'*De);
    kU=kron(Uspe,Uspa);
    kS=kron(sum(Sspe),sum(Sspa));
    for kk = 1:nclusters 
        Z = Z_group{kk};
        lastZ = Z;
        X = All_group{kk};  
        %% Update C
        C_group{kk} = mysoft(double(Z)-double(YC_group{kk})./rho,lamda1/rho,1); %l1 norm soft-thresholding
        
        %% Update T (hosvd or hooi)
%         T = double(HOSVD(tensor(mode_n_product(Z,{Da',De'},[1,2])),1e-3,'ranks',(R(:,kk))'));

        T = double(TK2tensor(HOSVD(tensor(mode_n_product(Z,{Da',De'},[1,2])),(R(:,kk))')));
% % % % %         Tu = mode_n_product(Z,{Da',De'},[1,2]);
% % % % %         RR=R(:,kk);
% % % % %         if RR(1)==1||RR(2)==1||RR(3)==1
% % % % %             Tu=tensor(Tu);
% % % % %         end
% % % % %         T = double(TK2tensor(HOSVD(Tu,(R(:,kk))')));
        T_group{kk} = T;
%         Tu = tucker_als(tensor(mode_n_product(Z,{Da',De'},[1,2])),(R(:,kk))','tol',1e-1,'printitn',0); %hooi
%         T = mode_n_product(double(Tu.core),Tu.U,[1,2,3]);
%         T_group{kk}  = T;
        
        %% Update Z
        dimsZ = [sizDa sizDe sizX(kk,3)];
        s = (mode_n_unfold(2*X+2*lamda2*T,3))*D';
        Z3 = (s+mode_n_unfold(rho*C_group{kk}+YC_group{kk},3))*kU*diag(1./((2+2*lamda2)*kS+rho*ones(1,d(1))))*kU';
        Z = double(mode_n_fold(Z3', 3, dimsZ));
        Z_group{kk} = Z;
        
        %% Update Y
        YC_group{kk} = YC_group{kk}+rho*(C_group{kk}-Z_group{kk});
        
%         errZ = errZ+frob(Z-lastZ);
        errZ = errZ+norm(Z(:)-lastZ(:),'fro');
    end
    clear D kU s Z3 Z T Tu;
    errList(k) = errZ/nclusters;
    %% Update Da and De
    X = [];
    A = [];
    for i = 1:nclusters
        XX = (mode_n_unfold(All_group{i}+lamda2*T_group{i},1))/(1+lamda2);
        X = [X,XX];
        AA = mode_n_unfold(mode_n_product(Z_group{i},{De},[2]),1);
        A = [A,AA];
    end
    Da = l2ls_learn_basis_dual(X, A, 1, Da);
    X = [];
    A = [];
    for i = 1:nclusters
        XX = (mode_n_unfold(All_group{i}+lamda2*T_group{i},2))/(1+lamda2);
        X = [X,XX];
        AA = mode_n_unfold(mode_n_product(Z_group{i},{Da},[1]),2);
        A = [A,AA];
    end
    De = l2ls_learn_basis_dual(X, A, 1, De);
    clear XX X AA A 

    rho = rho*1.3;
    %displayDictionaryElementsAsImage(Dspa, 4, 19, 8,8);
    %set(gca,'position',[0.1 0.1 0.8 0.8]);
    if errList(k) < epsilon
       break
    end
end
end
