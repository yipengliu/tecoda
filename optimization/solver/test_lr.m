%test_lr()
clear all;
%% test linear regression with only one function

%example 1

disp('%%%%%%%%%%%%Exp 1%%%%%%%%%%%%%%%%%');

disp('%%%%%%%%%Linear regression with simulated data%%%%%%%%%%%%');


disp('Generate random predictor and matrix matrix, construct corresponding response with noise')
N=100;
P=10; Q=5;
X=rand(N,P); % N * P predictor
B=rand(P,Q); % P * Q weight matrix
Y=X*B+0.1.*rand(N,Q); % N * Q response with noise

disp('Sove linear regression model with least squares method')
para.alg='ls';
B_ls=lr(X,Y,para);
rmse_ls=root_mse(Y,X*B_ls);%norm(Y-X*B_ls)^2;
disp('B_ls=');
disp(B_ls);
disp(['RMSE=',num2str(rmse_ls)]);

disp('Sove linear regression model with gradient descent method')
para.alg='gd';
B_gd=lr(X,Y,para);
rmse_gd=root_mse(Y,X*B_gd);%norm(Y-X*B_gd)^2;
disp('B_gd=');
disp(B_gd);
disp(['RMSE=',num2str(rmse_gd)]);

disp('%%%%%%%%%%%%Exp 2%%%%%%%%%%%%%%%%%');

disp('%%%%%%%%%Linear regression with shape image as weight matrix%%%%%%%%%%%%');

disp('Generate simulated data with shape image as weight matrix')

B=double(imread('circlesBrightDark.png'));
B=B(1:16:end,1:16:end);
N=1000;
X=rand(N,32);
Y=X*B+0.1.*rand(N,32);


disp('Sove linear regression model with least squares method')
para.alg='ls';
B_ls=lr(X,Y,para);
rmse_ls=root_mse(Y,X*B_ls);%norm(Y-X*B_ls)^2;
disp(['RMSE=',num2str(rmse_ls)]);

disp('Sove linear regression model with gradient descent method')
para.alg='gd';
B_gd=lr(X,Y,para);
rmse_gd=root_mse(Y,X*B_gd);%norm(Y-X*B_gd)^2;
disp(['RMSE=',num2str(rmse_gd)]);

% disply results with different torlence
figure;
set(gcf,'unit','centimeters','position',[10 10 30 10]);

subplot(1,3,1);
imshow(imread('circlesBrightDark.png'));
title('Origin image','fontsize',14);

subplot(1,3,2);
imshow(uint8(B_ls));
title({'Recovered image by LS' ;['RMSE=', num2str(roundn(rmse_ls,-3))]},'fontsize',14);

subplot(1,3,3);
imshow(uint8(B_gd));
title({'Recovered image by GD' ;['RMSE=', num2str(roundn(rmse_gd,-3))]},'fontsize',14);

% suptitle('Image Recovery for Circles');

%% test linear regression with only multiple function (here M=3)

%example 1

disp('%%%%%%%%%%%%Exp 3%%%%%%%%%%%%%%%%%');

disp('%%%%%%%%%Linear regression with simulated data%%%%%%%%%%%%');


disp('Generate random predictor and matrix matrix, construct corresponding response with noise')
M=3;
N=[100,200,50];
P=10; Q=5;
B=rand(P,Q); % P * Q weight matrix
X=cell(M,1);
Y=cell(M,1);
for m=1:M
    X{m}=rand(N(m),P); % N * P predictor
    Y{m}=X{m}*B+0.1.*rand(N(m),Q); % N * Q response with noise
end
disp('Sove linear regression model with least squares method')
para.alg='ls';
para.w=[1,1,1];
B_ls=lr(X,Y,para);
rmse_ls=0;
for m=1:M
    rmse_ls=rmse_ls+para.w(m).*root_mse(Y{m},X{m}*B_ls);%norm(Y{m}-X{m}*B_ls)^2;
end
disp('B_ls=');
disp(B_ls);
disp(['RMSE=',num2str(rmse_ls)]);

disp('Sove linear regression model with gradient descent method')
para.alg='gd';
B_gd=lr(X,Y,para);
rmse_gd=0;
for m=1:M
    rmse_gd=rmse_gd+para.w(m).*root_mse(Y{m},X{m}*B_gd);%norm(Y{m}-X{m}*B_gd)^2;
end
disp('B_gd=');
disp(B_gd);
disp(['RMSE=',num2str(rmse_gd)]);

disp('%%%%%%%%%%%%Exp 4%%%%%%%%%%%%%%%%%');

disp('%%%%%%%%%Linear regression with shape image as weight matrix%%%%%%%%%%%%');

disp('Generate simulated data with shape image as weight matrix')

B=double(imread('circlesBrightDark.png'));
B=B(1:16:end,1:16:end);
N=[1000,200,500];
X=cell(M,1);
Y=cell(M,1);
for m=1:M
    X{m}=rand(N(m),32); % N * P predictor
    Y{m}=X{m}*B+0.1.*rand(N(m),32); % N * Q response with noise
end


disp('Sove linear regression model with least squares method')
para.alg='ls';
para.w=[1,1,1];
B_ls=lr(X,Y,para);
rmse_ls=0;
for m=1:M
    rmse_ls=rmse_ls+para.w(m).*root_mse(Y{m},X{m}*B_ls);%norm(Y{m}-X{m}*B_ls)^2;
end
disp(['RMSE=',num2str(rmse_ls)]);

disp('Sove linear regression model with gradient descent method')
para.alg='gd';
B_gd=lr(X,Y,para);
rmse_gd=0;
for m=1:M
    rmse_gd=rmse_gd+para.w(m).*root_mse(Y{m},X{m}*B_gd);%norm(Y{m}-X{m}*B_gd)^2;
end
disp(['RMSE=',num2str(rmse_gd)]);

% disply results with different torlence
figure;
set(gcf,'unit','centimeters','position',[10 10 30 10]);

subplot(1,3,1);
imshow(imread('circlesBrightDark.png'));
title('Origin image','fontsize',14);

subplot(1,3,2);
imshow(uint8(B_ls));
title({'Recovered image by LS' ;['RMSE=', num2str(roundn(rmse_ls,-3))]},'fontsize',14);

subplot(1,3,3);
imshow(uint8(B_gd));
title({'Recovered image by GD' ;['RMSE=', num2str(roundn(rmse_gd,-3))]},'fontsize',14);

% suptitle('Image Recovery for Circles');

