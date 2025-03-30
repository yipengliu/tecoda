clear
addpath(genpath('..\..\..\core\'));
addpath(genpath('..\..\..\td\'));
addpath(genpath('..\..\..\optimization\'));
addpath(genpath('..\..\..\database\'));
addpath(genpath(cd))

% pic_name = 'color_image\lena.bmp';
pic_name = '..\..\database\color image\lena.bmp';
X = double(imread(pic_name));

X = X/255;
maxP = max(abs(X(:)));
[n1,n2,n3] = size(X);
Xn = X;
rhos = 0.3
ind = find(rand(n1*n2*n3,1)<rhos);
Xn(ind) = rand(length(ind),1);

opts.mu = 1e-4;
opts.tol = 1e-5;
opts.rho = 1.1;
opts.max_iter = 500;
opts.DEBUG = 1;

[n1,n2,n3] = size(Xn);
lambda = 1/sqrt(max(n1,n2)*n3);
[Xhat,E,err,iter] = TRPCA_TNN(Xn,lambda,opts);
 
Xhat = max(Xhat,0);
Xhat = min(Xhat,maxP);
% psnr = PSNR(X,Xhat,maxP)

figure(1)
subplot(1,3,1)
imshow(X/max(X(:)))
title('Original');
subplot(1,3,2)
imshow(Xn/max(Xn(:)))
title('Observed');
subplot(1,3,3)
imshow(Xhat/max(Xhat(:)))
title('Denoised');





