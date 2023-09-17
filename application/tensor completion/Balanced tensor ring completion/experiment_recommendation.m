clc
clear
close all
%% load the data
load aaai10_uclaf_data
img=UserLocAct;
img=densify(img,20);
omega=double(img~=0);
F0=norm(img(:),'fro');
%%
siz=size(img);
%% sampling
P=sampling_uniform(img,0.5);
%% solve problem via matrix completion
mat=reshape(P.*img,12,[]);
opts.tol = 1e-6; 
opts.max_iter = 1000;
opts.rho = 1.2;
opts.mu = 1e-3;
opts.max_mu = 1e10;
opts.DEBUG = 0;
x=lrmc(mat,find(P),opts);
x_M=reshape(x,siz);
err_M=norm(x_M(:)-img(:),'fro')/F0;
%% solve problem via TR-ADMM
I=[3,4,4,5];
order=1:length(I);
J=I;
tnsr=l2h(img,I,order,J);
P1=l2h(P,I,order,J);
[x,~,~,run_time]=TR_ADMM(tnsr,P1,10^-1,false);
x_TR=h2l(x,I,order,siz);
err_TR=norm(x_TR(:)-img(:),'fro')/F0;
%% solve problem via SiLRTC-TT
I=[3,4,4,5];
order=1:length(I);
J=I;
tnsr=l2h(img,I,order,J);
P1=l2h(P,I,order,J);
[~,ranktube]=SVD_MPS_Rank_Estimation(P1.*tnsr,1e-2);
x=SiLRTC_TT(tnsr,find(P1),ranktube,0.01*ranktube,500,1e-5);
x_TT=h2l(x,I,order,siz);
err_TT=norm(x_TT(:)-img(:),'fro')/F0;
%% solve problem via LRTC-TNN
x_tSVD=lrtc_tnn(P.*img,find(P),[]);
err_tSVD=norm(x_tSVD(:)-img(:),'fro')/F0;
%% solve problem via FBCP
model=BCPF_IC(P.*img,'obs',P,'init','rand','maxRank',100,'maxiters',100,...
    'tol',1e-4,'dimRed',1,'verbose',0);
x_CP=double(model.X);
err_CP=norm(x_CP(:)-img(:),'fro')/F0;
%% solve problem via HaLRTC
x_TK=HaLRTC(img,logical(P),ones(1,length(siz))/length(siz),1e-6,500,1e-5,P.*img);
err_TK=norm(x_TK(:)-img(:),'fro')/F0;
%% solve problem via STTC
x_HT=Smoothlowrank_TV12(P.*img,find(P),0,P.*img,[10,10,0]);
err_HT=norm(x_HT(:)-img(:),'fro')/F0;
%% display
err=[err_TR,err_TT,err_HT,err_TK,err_tSVD,err_CP,err_M];
figure;
X=categorical({'TRBU','SiLRTC-TT','STTC','HaLRTC','LRTC-TNN','FBCP','MC'});
X=reordercats(X,{'TRBU','SiLRTC-TT','STTC','HaLRTC','LRTC-TNN','FBCP','MC'});
bar(X,err);
ylabel('Relative error');
%% densify function
function tnsr=densify(tnsr,threshold)
idx=[];
for i=1:size(tnsr,1)
    if(nnz(tnsr(i,:,:))>=threshold)
        idx=[idx,i];
    end
end
tnsr=tnsr(idx,:,:);
idx=[];
for j=1:size(tnsr,2)
    if(nnz(tnsr(:,j,:))>=threshold)
        idx=[idx,j];
    end
end
tnsr=tnsr(:,idx,:);
idx=[];
for k=1:size(tnsr,3)
    if(nnz(tnsr(:,:,k))>=threshold)
        idx=[idx,k];
    end
end
tnsr=tnsr(:,:,idx);
end