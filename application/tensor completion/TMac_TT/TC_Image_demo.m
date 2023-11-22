clc
clear
close all
addpath('Functions/');
%rng(213412);
% Initial parameters
Nway = [4*ones(1,8),3];     % 9th-order dimensions for KA
N = numel(Nway);
I1 = 2; J1 = 2;                 % KA parameters
SR = 0.1;                       % Sample ratio (SR), e.g. 0.1 = 10% known samples
mr = (1-SR)*100;                % Missing ratio (mr);

% Image selection 
fig='..\..\testdata\Color images\lena';
%fig='..\..\testdata\Color images\peppers';
imgfile = strcat(fig,'.bmp');
X1 = double(imread(imgfile));

% Ket Augmentation
X = CastImageAsKet(X1,Nway,I1,J1);

% Generate known data
P = round(SR*prod(Nway));
Known = randsample(prod(Nway),P);
[Known,~] = sort(Known);

% Main function for tensor completion
[Tres,~] = TensorCompletion(X,Known);  
x=Tres.MS;
x=CastKet2Image(x,256,256,2,2);
err_re=norm(x(:)-X1(:),2)/norm(X1(:),2)
figure;
imshow(uint8(X1),'border','tight');
figure;
imshow(uint8(x),'border','tight');
figure;
img=zeros(size(X1));
img(Known)=X1(Known);
imshow(uint8(img),'border','tight');