clc;
clear;
% load('F:\documents\科研\TCPM\code\MRI\cardiac_perfusion2.mat');
% T=abs(perdata);
% T= im2double(img);
filename='..\..\..\testdata\Color images\sailboat.bmp';
img = imread(filename);
T= im2double(img);
size_tensor=size(T);
% size_core=mlrankest(T);
Nway =size_tensor;
N = ndims(T);
% 
% 
for ObsRatio=10:10:10
% for ObsRatio=10:5:30
% ObsRatio=10;
Omega = randperm(prod(Nway));
Omega = Omega(1:round((ObsRatio/100)*prod(Nway)));
O = zeros(Nway);
O(Omega) = 1;
y=T.*O;
known=find(y);
Q=logical(O);
% filename='F:\documents\科研\Journal materials\results\color image\flowers\flowers2.bmp';
% img = imread(filename);
% y= im2double(img);
% O = (y ~= 0);
tic;
[model] = BCPF_IC(y, 'obs', O, 'init', 'rand', 'maxRank', 90, 'maxiters', 20, ...
    'tol', 1e-4, 'dimRed', 1, 'verbose', 2);
X = double(model.X);
time_FBCP(ObsRatio)=toc;
X_FBCP(:,:,:,ObsRatio)=X;

end
