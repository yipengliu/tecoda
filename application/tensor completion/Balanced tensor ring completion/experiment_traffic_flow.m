clc
clear
close all
load traffic_data
traffic=traffic(:,1:60,:);
SR=0.2;
F0=norm(traffic(:),'fro');
%%
siz=size(traffic);
%% sampling
P=sampling_uniform(traffic,SR);
%% solve problem via matrix completion
mat=reshape(P.*traffic,209,[]);
opts.tol = 1e-6; 
opts.max_iter = 1000;
opts.rho = 1.2;
opts.mu = 1e-3;
opts.max_mu = 1e10;
opts.DEBUG = 0;
x=lrmc(mat,find(P),opts);
x_M=reshape(x,siz);
err_M=norm(x_M(:)-traffic(:),'fro')/F0;
%% TR
% tnsr=reshape(traffic,[11,19,6,10,12,12]);
% P1=reshape(P,[11,19,6,10,12,12]);
[x,~,err_TR,run_time_TR]=TR_ADMM(traffic,P,10^-2.85,true);% 0.089,27.03s
%% TT
t=cputime;
[~,ranktube]=SVD_MPS_Rank_Estimation(P.*traffic,1e-2);
x=SiLRTC_TT(traffic,find(P),ranktube,0.01*ranktube,100,1e-5);
run_time_TT=cputime-t;
err_TT=norm(x(:)-traffic(:),'fro')/F0;% 0.097,113.35s
%% T-SVD
t=cputime;
x=lrtc_tnn(P.*traffic,find(P),[]); 
run_time_t_SVD=cputime-t;
err_tSVD=norm(x(:)-traffic(:),'fro')/F0;% 0.086,58.22s
%% TK
t=cputime;
x=HaLRTC(traffic,logical(P),ones(1,3)/3,1e-6,100,1e-5,P.*traffic);
run_time_TK=cputime-t;
err_TK=norm(x(:)-traffic(:),'fro')/F0;% 0.098,27.2s
%% CP
CPr=50;
t=cputime;
model=BCPF_IC(P.*traffic,'obs',P,'init','rand','maxRank',CPr,'maxiters',100,...
    'tol',1e-4,'dimRed',1,'verbose',0);
run_time_CP=cputime-t;
x=double(model.X);
err_CP=norm(x(:)-traffic(:),'fro')/F0;% 0.100,230.19s
%% HT
t=cputime;
x=Smoothlowrank_TV12(P.*traffic,find(P),0,P.*traffic,[10,10,0]);
run_time_HT=cputime-t;
err_HT=norm(x(:)-traffic(:),'fro')/F0;% 0.18,157.38s
%% display
err=[min(err_TR),err_TT,err_HT,err_TK,err_tSVD,err_CP,err_M];
figure;
X=categorical({'TRBU','SiLRTC-TT','STTC','HaLRTC','LRTC-TNN','FBCP','MC'});
X=reordercats(X,{'TRBU','SiLRTC-TT','STTC','HaLRTC','LRTC-TNN','FBCP','MC'});
bar(X,err);
ylabel('Relative error');