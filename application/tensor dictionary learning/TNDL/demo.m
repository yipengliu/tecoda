clc; clear;     

addpath(genpath('Data'));
addpath(genpath('Functions'));

%% load reference image and mask
load('perf_128_40'); 
seq=image;
load mask_perf_radial
mask=Mask(:,:,:,5);
%% simulating k-data and adding noise
%E = E_singlecoil();  % Fourier encoding for dynamic MRI with single coil
imfull = seq/max(abs(seq(:)));  % Normalization
kdata = fftshift(fft(fftshift(imfull,1),[],1),1);
kdata = fftshift(fft(fftshift(kdata,2),[],2),2);  % Fourier encoding for dynamic MRI with single coil

im_noise_PSNR = inf; % Representing the noise which corresponds to the PSNR of the
                    % IFFT reconstruction of fullysampled data corrupted by noise
sigma = 1/(10^(im_noise_PSNR/20))*sqrt(size(kdata,1)*size(kdata,2));  % Corresponding noise standard deviation
noise =(sigma /sqrt(2))*(randn(size(kdata))+(0+1i)*randn(size(kdata)));  % Noise  
kdata = kdata+noise;   % Synthetic k-space data
%im_n = E'*kdata;   % noised image 
% im_u_n = E'*(kdata.*mask);  % undesampled and noised image 
%% parameter setting
paramsin.imfull = imfull;
paramsin.isnormalized = 1;
paramsin.tol = 0.0002;
paramsin.num = 200;    % Maximum iterate number
paramsin.itemin = 5;   % Minimum iterate number
paramsin.disp = 1;
paramsin.isfullsampled = 0.9;

par.J=5;
par.patsize=8;
par.patnum=32;
par.step=par.patsize;
 
% important parameters

mu = 100;
paramsin.mu = mu/sigma;


lambdai=[0.001,0.05,0.1,0.15];
deltai=[0.9,0.93,0.95,0.97,0.1];
PSNR=size(length(lambdai),length(deltai));
for i=1:length(lambdai) 
    for j=1:length(deltai)
        paramsin.lambda = lambdai(i);
        paramsin.delta =deltai(j);
        %% running
        tic, [imout, paramsout] = TNDLMRI(kdata,mask,image,paramsin,par); t = toc;
        figure,
        subplot(1,2,1),plot(paramsout.PSNR);
        subplot(1,2,2),imshow(abs(imout(:,:,1)),[])
        PSNR(i,j)=paramsout.PSNR(end);
        rec_im(:,:,:,i,j)=imout;
    end
end
