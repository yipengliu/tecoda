function [X,D,OUT,Z,iter] = LRTC_DTNN(M,omega,opts,M_true,X0)

% Solve the Low-Rank Tensor Completion (LRTC) based on Tensor Nuclear Norm (TNN) problem by ADMM

if ~exist('opts', 'var')
    opts = [];
end

if isfield(opts, 'tol');        tol         = opts.tol;         end
if isfield(opts, 'max_iter');   max_iter    = opts.max_iter;	end
if isfield(opts, 'rho');        rho        	= opts.rho;      	end
if isfield(opts, 'u');          u           = opts.u;           end
if isfield(opts, 'v');          v           = opts.v;           end
if isfield(opts, 'w');          w           = opts.w;           end
if isfield(opts, 'DEBUG');      DEBUG   	= opts.DEBUG;     	end
if isfield(opts, 'D0');      	D0          = opts.D0;end
if isfield(opts, 'Z0');      	Z0          = opts.Z0;end
%%% Generate Framelet Filters (B_spline)
OUT = [];
Dim         = size(M);
d           = size(D0,2);
X           = X0;%gpuArray.rand(Dim);
X(omega)    = M(omega);

X(omega)    = M(omega);
Z           = Z0;
D           = D0;

obj_Ori     = 0;
for iter    = 1 : max_iter
    
%     if iter == 20
%         X           = 0.05*gpuArray.randn(Dim)+X;
%         X(omega)    = M(omega);
%     end
    if DEBUG
        tStart = tic;
    end
    Xk	= X;
    Dk	= D;
    Zk	= Z;

    % update d_i and z_i
    X_mat = mode_n_unfold(X,3);
    Zk_mat= mode_n_unfold(Zk,3);
    DZ_new = 0;
    DZ_old = D*Zk_mat;
    for i  = 1:d
        DZ_old = DZ_old - D(:,i)*Zk_mat(i,:);
        Xbar        = X_mat-DZ_new-DZ_old;
        rhodkXbar   = mode_n_fold(rho*D(:,i)'*Xbar,3,[Dim(1:2),1]);
        zki        = Zk(:,:,i);
        %if mod(iter,5) == 0
            pki        = rho*Xbar*zki(:)+1/v*Dk(:,i);
             if iter>5
            D(:,i)     = pki/norm(pki);
             else
                 D(:,i) =  D(:,i);
             end
      %  end
        %pinvD = (D'*D)\D'; norminvD = norm(pinvD(i,:))/norm(pinvD,'fro');%norminvD*
        % [Z(:,:,i),nn(i)]    = prox_nuclear(u/(1+rho*u)*(zki/u+double(rhodkXbar)),u/(1+rho*u));
        [Z(:,:,i),nn(i)]    = prox_nuclear_norm(u/(1+rho*u)*(zki/u+double(rhodkXbar)),u/(1+rho*u));
        zki_new = Z(:,:,i);
        DZ_new = DZ_new+ D(:,i)*zki_new(:)';
    end
    if DEBUG
        Znuclear = sum(nn);
        OUT.Znuclear(iter) = Znuclear;
    end
     

    % update X
    
    DZ = mode_n_fold(DZ_new,3,size(X));%Fold(D*Unfold(Z,size(Z),3),size(X),3);
    if iter>10
    X = w/(1+rho*w)*(rho*double(DZ)+1/w*double(Xk));
    end
    X(omega) = M(omega);

    if DEBUG
        XminusDZ = norm(X(:)-DZ(:))^2;
        OUT.XminusDZ(iter) = XminusDZ;
    end
    
    if DEBUG
        Obj = Znuclear+rho*0.5*XminusDZ;
        OUT.Obj(iter) = Obj;
    end
    % update multipliers
   
    chgZ    = norm(Zk(:)-Z(:))/norm(Zk(:));OUT.chgZ(iter) = chgZ;
    chgX    = norm(Xk(:)-X(:))/norm(Xk(:));OUT.chgX(iter) = chgX;
    chgD    = norm(Dk(:)-D(:))/norm(Dk(:));OUT.chgD(iter) = chgD;
    chg     = max([chgX chgZ chgD]);
     if DEBUG
        time_iter = toc(tStart);
        [MPSNR1,~,~] =quality(M_true*255, X*255);
        OUT.MPSNR(iter) = MPSNR1;
        fprintf('iter = %3.d, MPSNR = %3.2f,RelCha(Z,X,D) = (%.4f,%.4f,%.4f) Obj = %.1f,  Znuclear = %.1f, ||X-DZ|| = %.1f, time = %.1f \n',...
            iter,       MPSNR1,     chgZ,chgX,chgD,Obj,Znuclear,XminusDZ,time_iter);
    end
    
    if chg < tol
        break;
    end 
%     if iter >30
%     rho = rho*1.2;%618;%618;%618;
%     end
%     
    if iter == 25
        rho = rho*1.5;%618;%618;%618;
    end
    
    if iter == 30
        rho = rho*1.5;
    end
    
    if iter == 35
        rho = rho*1.5;
    end
    
    if iter > 40
        rho = rho*1.2;
    end
end
obj = obj_Ori;
err = norm(M_true(:)-X(:));

 
