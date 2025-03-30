%% =================================================================

clc;
clear;
close all;
addpath(genpath('Functions'));
addpath(genpath('Data'));
CurPath = pwd;
seed_hsi = 255;
%% Set enable bits
EN_DTNN       = 1;
methodname    = {'Observed' 'DTNN'};
Mnum = length(methodname);


%% Load initial data

load('cleanPavia.mat')
data_name = 'HSI_Pa';
X = img_clean;%(1:256,1:256,:);

[~,~,n3] = size(X);
for i=1:n3
    temp=X(:,:,i);
    X(:,:,i)=temp/max(temp(:));
end
[n1,n2,n3] = size(X);
%% Sampling with random position
for sample_ratio =  [0.05 0.1:0.1:0.5]%:0.1:0.5% 0.05:0.05:0.5
    fprintf('\n');
    fprintf('===========data=====Results=p=%f======================\n',sample_ratio);
    
    Y_tensorT   = X;
    Ndim        = ndims(Y_tensorT);
    Nway        = size(Y_tensorT);
    rng('default')
    rng(seed_hsi);
    Omega       = find(rand(prod(Nway),1)<sample_ratio);
    Ind         = zeros(size(X));
    Ind(Omega)  = 1;
    Y_tensor0   = zeros(Nway);
    Y_tensor0(Omega) = Y_tensorT(Omega);
    %%
    i  = 1;
    Re_tensor{i} = Y_tensor0;
    [MPSNR0, SSIM0, UIQI0] = quality(Y_tensorT*255, Y_tensor0*255);
    time(i) = 0;
    enList = 1;
    fprintf(' %8.8s    %5.4s    %5.4s    %5.4s   %5.4s   %5.4s \n','method','PSNR', 'SSIM', 'FSIM','iter','time');
    fprintf(' %8.8s    %5.3f    %5.3f    %5.3f    %3.3d     %.1f \n',...
        methodname{enList(i)},MPSNR0, SSIM0(enList(i)), UIQI0,0,time(i));
    
    %%
    i = 2;
    d = 5*n3;
    A = Y_tensor0;
    B = padarray(A,[20,20,20],'symmetric','both');
    C = padarray(Ind,[20,20,20],'symmetric','both');
    a1 = interpolate2(shiftdim(B,1),shiftdim(C,1));
    a1(a1<0) = 0;
    a1(a1>1) = 1;
    a1 = a1(21:end-20,21:end-20,21:end-20);
    a1 = shiftdim(a1,2);
    a1(Omega) = Y_tensorT(Omega);
    a2 = interpolate2(shiftdim(B,2),shiftdim(C,2));
    a2(a2<0) = 0;
    a2(a2>1) = 1;
    a2 = a2(21:end-20,21:end-20,21:end-20);
    a2 = shiftdim(a2,1);
    a2(Omega) = Y_tensorT(Omega);
    a = 0.5*a1+0.5*a2;
    if sample_ratio <0.3
        for jjj = 1:10
            a = mode_n_unfold(a,3);
            [u,s,v] = svds(a,3);
            a = u*s*v';
            a = mode_n_fold(a,3,size(X));
            a(Omega) = Y_tensorT(Omega);
        end
    end
    X0 = a;
    X0(Omega) = Y_tensorT(Omega);
    X_m = mode_n_unfold(X0,3);
    Ind_m = mode_n_unfold(Ind,3);
    Ind2   = sum(Ind_m,1);
    [~,D_omega] = sort(Ind2(:),'descend');
    D0 = X_m(:,D_omega(1:d));
    D0 = D0./sqrt(sum(D0.^2,1));
    Z0 = rand(n1,n2,d);
    Z0 = Z0./sqrt(sum(Z0.^2,[1 2]));
    Z0 = Z0/5;
    

    opts = [];
    opts.u          = 0.01;
    opts.v          = 1;
    opts.w          = 100;
    opts.tol        = 1e-3;
    opts.rho        = 10;
    opts.DEBUG      = 1;
    opts.max_iter   = 100;
    opts.X0 = X0;
    opts.Z0 = Z0;
    opts.D0 = D0;
    
    
    tStart = tic;
    opts.DEBUG = 0;
    
    [Xhat5_out,D,obj,Z,iterations] = LRTC_DTNN(Y_tensor0,Omega,opts,Y_tensorT,X0);
    Re_tensor1 = Xhat5_out;
    time1= toc(tStart);
    [MPSNR1, SSIM1, UIQI1] = quality(Y_tensorT*255, Re_tensor1*255);
    fprintf(' %8.8s    %5.3f    %5.3f    %5.3f    %3d     %.1f | rho = %.3f   u = %.3f   v = %.3f   w = %.3f  \n',...
        methodname{i},MPSNR1, SSIM1, UIQI1,iterations,time1,opts.rho,opts.u,opts.v,opts.w);
end


