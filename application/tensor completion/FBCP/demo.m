clc;
clear;

addpath(genpath('Functions\'));
addpath(genpath('Evalutaion\'));

% filename='..\..\..\testdata\Color images\airplane.bmp';
 filename='..\..\..\database\color image\airplane.bmp';
img = imread(filename);
T= im2double(img);
size_tensor=size(T);
Nway =size_tensor;
N = ndims(T);
for ObsRatio=10:10:80
% ObsRatio=10;
Omega = randperm(prod(Nway));
Omega = Omega(1:round((ObsRatio/100)*prod(Nway)));
O = zeros(Nway);
O(Omega) = 1;
y=T.*O;
known=find(y);
Q=logical(O);
tic;
[model] = BCPF_IC(y, 'obs', O, 'init', 'rand', 'maxRank', 90, 'maxiters', 20, ...
'tol', 1e-4, 'dimRed', 1, 'verbose', 2);
X = double(model.X);
time_FBCP(ObsRatio)=toc;
% X_FBCP(:,:,:,ObsRatio)=X;
end
save airplane.mat time_FBCP

clc;
clear;
filename='..\..\..\testdata\Color images\baboon.bmp';
img = imread(filename);
T= im2double(img);
size_tensor=size(T);
Nway =size_tensor;
N = ndims(T);
for ObsRatio=10:10:80
% ObsRatio=10;
Omega = randperm(prod(Nway));
Omega = Omega(1:round((ObsRatio/100)*prod(Nway)));
O = zeros(Nway);
O(Omega) = 1;
y=T.*O;
known=find(y);
Q=logical(O);
tic;
[model] = BCPF_IC(y, 'obs', O, 'init', 'rand', 'maxRank', 90, 'maxiters', 20, ...
    'tol', 1e-4, 'dimRed', 1, 'verbose', 2);
X = double(model.X);
time_FBCP(ObsRatio)=toc;
% X_FBCP(:,:,:,ObsRatio)=X;
end
save baboon.mat time_FBCP

clc;
clear;
filename='..\..\..\testdata\Color images\barbara.bmp';
img = imread(filename);
T= im2double(img);
size_tensor=size(T);
Nway =size_tensor;
N = ndims(T);
for ObsRatio=10:10:80
% ObsRatio=10;
Omega = randperm(prod(Nway));
Omega = Omega(1:round((ObsRatio/100)*prod(Nway)));
O = zeros(Nway);
O(Omega) = 1;
y=T.*O;
known=find(y);
Q=logical(O);
tic;
[model] = BCPF_IC(y, 'obs', O, 'init', 'rand', 'maxRank', 90, 'maxiters', 20, ...
    'tol', 1e-4, 'dimRed', 1, 'verbose', 2);
X = double(model.X);
time_FBCP(ObsRatio)=toc;
% X_FBCP(:,:,:,ObsRatio)=X;
end
save barbara.mat time_FBCP

clc;
clear;
filename='..\..\..\testdata\Color images\facade.bmp';
img = imread(filename);
T= im2double(img);
size_tensor=size(T);
Nway =size_tensor;
N = ndims(T);
for ObsRatio=10:10:80
% ObsRatio=10;
Omega = randperm(prod(Nway));
Omega = Omega(1:round((ObsRatio/100)*prod(Nway)));
O = zeros(Nway);
O(Omega) = 1;
y=T.*O;
known=find(y);
Q=logical(O);
tic;
[model] = BCPF_IC(y, 'obs', O, 'init', 'rand', 'maxRank', 90, 'maxiters', 20, ...
    'tol', 1e-4, 'dimRed', 1, 'verbose', 2);
X = double(model.X);
time_FBCP(ObsRatio)=toc;
% X_FBCP(:,:,:,ObsRatio)=X;
end
save facade.mat time_FBCP

clc;
clear;
filename='..\..\..\testdata\Color images\house.bmp';
img = imread(filename);
T= im2double(img);
size_tensor=size(T);
Nway =size_tensor;
N = ndims(T);
for ObsRatio=10:10:80
% ObsRatio=10;
Omega = randperm(prod(Nway));
Omega = Omega(1:round((ObsRatio/100)*prod(Nway)));
O = zeros(Nway);
O(Omega) = 1;
y=T.*O;
known=find(y);
Q=logical(O);
tic;
[model] = BCPF_IC(y, 'obs', O, 'init', 'rand', 'maxRank', 90, 'maxiters', 20, ...
    'tol', 1e-4, 'dimRed', 1, 'verbose', 2);
X = double(model.X);
time_FBCP(ObsRatio)=toc;
% X_FBCP(:,:,:,ObsRatio)=X;
end
save house.mat time_FBCP

clc;
clear;
% filename='..\..\..\testdata\Color images\lena.bmp';
filename='..\..\..\database\color image\lena.bmp';
img = imread(filename);
T= im2double(img);
size_tensor=size(T);
Nway =size_tensor;
N = ndims(T);
for ObsRatio=10:10:80
% ObsRatio=10;
Omega = randperm(prod(Nway));
Omega = Omega(1:round((ObsRatio/100)*prod(Nway)));
O = zeros(Nway);
O(Omega) = 1;
y=T.*O;
known=find(y);
Q=logical(O);
tic;
[model] = BCPF_IC(y, 'obs', O, 'init', 'rand', 'maxRank', 90, 'maxiters', 20, ...
    'tol', 1e-4, 'dimRed', 1, 'verbose', 2);
X = double(model.X);
time_FBCP(ObsRatio)=toc;
% X_FBCP(:,:,:,ObsRatio)=X;
end
save lena.mat time_FBCP

clc;
clear;
filename='..\..\..\testdata\Color images\peppers.bmp';
img = imread(filename);
T= im2double(img);
size_tensor=size(T);
Nway =size_tensor;
N = ndims(T);
for ObsRatio=10:10:80
% ObsRatio=10;
Omega = randperm(prod(Nway));
Omega = Omega(1:round((ObsRatio/100)*prod(Nway)));
O = zeros(Nway);
O(Omega) = 1;
y=T.*O;
known=find(y);
Q=logical(O);
tic;
[model] = BCPF_IC(y, 'obs', O, 'init', 'rand', 'maxRank', 90, 'maxiters', 20, ...
    'tol', 1e-4, 'dimRed', 1, 'verbose', 2);
X = double(model.X);
time_FBCP(ObsRatio)=toc;
% X_FBCP(:,:,:,ObsRatio)=X;
end
save peppers.mat time_FBCP

clc;
clear;
filename='..\..\..\testdata\Color images\sailboat.bmp';
img = imread(filename);
T= im2double(img);
size_tensor=size(T);
Nway =size_tensor;
N = ndims(T);
for ObsRatio=10:10:80
% ObsRatio=10;
Omega = randperm(prod(Nway));
Omega = Omega(1:round((ObsRatio/100)*prod(Nway)));
O = zeros(Nway);
O(Omega) = 1;
y=T.*O;
known=find(y);
Q=logical(O);
tic;
[model] = BCPF_IC(y, 'obs', O, 'init', 'rand', 'maxRank', 90, 'maxiters', 20, ...
    'tol', 1e-4, 'dimRed', 1, 'verbose', 2);
X = double(model.X);
time_FBCP(ObsRatio)=toc;
% X_FBCP(:,:,:,ObsRatio)=X;
end
save sailboat.mat time_FBCP

