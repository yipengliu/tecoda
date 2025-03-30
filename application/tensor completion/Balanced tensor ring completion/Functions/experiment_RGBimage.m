clc
clear
close all
%% load the image
% img=imread('..\..\testdata\Color images\lena.bmp');
img=imread('..\..\..\database\color image\lena.bmp');
img=double(img);
siz=size(img);
%% sampling
P=sampling_uniform(img,0.5);
%% solve problem via matrix completion
mat=reshape(P.*img,256,[]);
opts.tol = 1e-6; 
opts.max_iter = 1000;
opts.rho = 1.2;
opts.mu = 1e-3;
opts.max_mu = 1e10;
opts.DEBUG = 0;
x=lrmc(mat,find(P),opts);
x_M=reshape(x,siz);
err_psnr_M=psnr(uint8(x_M),uint8(img));
%% solve problem via TR-ADMM
I=[2*ones(1,16),3];
order=[1:(length(I)-1)/2;(length(I)+1)/2:length(I)-1];
order=[order(:);length(I)]';
J=[4*ones(1,8),3];
tnsr=l2h(img,I,order,J);
P1=l2h(P,I,order,J);
[x,~,~,run_time]=TR_ADMM(tnsr,P1,10^-3.7,false);
x_TR=h2l(x,I,order,siz);
err_psnr_TR=psnr(uint8(x_TR),uint8(img));
%% solve problem via SiLRTC-TT
tnsr=CastImageAsKet(img,[4*ones(1,8),3],2,2);
P1=CastImageAsKet(P,[4*ones(1,8),3],2,2);
[~,ranktube]=SVD_MPS_Rank_Estimation(P1.*tnsr,1e-2);
x=SiLRTC_TT(tnsr,find(P1),ranktube,0.01*ranktube,500,1e-5);
x_TT=CastKet2Image(x,256,256,2,2);
err_psnr_TT=psnr(uint8(x_TT),uint8(img));
%% solve problem via LRTC-TNN
x_tSVD=lrtc_tnn(P.*img,find(P),[]);
err_psnr_tSVD=psnr(uint8(x_tSVD),uint8(img));
%% solve problem via FBCP
model=BCPF_IC(P.*img,'obs',P,'init','rand','maxRank',100,'maxiters',100,...
    'tol',1e-4,'dimRed',1,'verbose',0);
x_CP=double(model.X);
err_psnr_CP=psnr(uint8(x_CP),uint8(img));
%% solve problem via HaLRTC
x_TK=HaLRTC(img,logical(P),ones(1,length(siz))/length(siz),1e-6,500,1e-5,P.*img);
err_psnr_TK=psnr(uint8(x_TK),uint8(img));
%% solve problem via STTC
x_HT=Smoothlowrank_TV12(P.*img,find(P),0,P.*img,[10,10,0]);
err_psnr_HT=psnr(uint8(x_HT),uint8(img));
%% display
img_original=uint8(img);
img_observed=uint8(P.*img);
figure;
subplot(3,3,1);
imshow(img_original,'border','tight');
title('Original');
subplot(3,3,2);
imshow(img_observed,'border','tight');
title('Observed');
subplot(3,3,3);
imshow(uint8(x_M),'border','tight');
title(['MC (' num2str(err_psnr_M,'%.2f') 'dB)']);
subplot(3,3,4);
imshow(uint8(x_TR),'border','tight');
title(['TRBU (' num2str(err_psnr_TR,'%.2f') 'dB)']);
subplot(3,3,5);
imshow(uint8(x_TT),'border','tight');
title(['SiLRTC-TT (' num2str(err_psnr_TT,'%.2f') 'dB)']);
subplot(3,3,6);
imshow(uint8(x_HT),'border','tight');
title(['STTC (' num2str(err_psnr_HT,'%.2f') 'dB)']);
subplot(3,3,7);
imshow(uint8(x_tSVD),'border','tight');
title(['LRTC-TNN (' num2str(err_psnr_tSVD,'%.2f') 'dB)']);
subplot(3,3,8);
imshow(uint8(x_TK),'border','tight');
title(['HaLRTC (' num2str(err_psnr_TK,'%.2f') 'dB)']);
subplot(3,3,9);
imshow(uint8(x_CP),'border','tight');
title(['FBCP (' num2str(err_psnr_CP,'%.2f') 'dB)']);