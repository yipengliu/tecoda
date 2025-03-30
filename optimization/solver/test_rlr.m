%test_lr()
clear all;
%% test regularized linear regression with ell_1 constraints

%example 1 

disp('%%%%%%%%%%%%Exp 1%%%%%%%%%%%%%%%%%');

disp('%%%%%%%%%regularized Linear regression with simulated data%%%%%%%%%%%%');


disp('Generate random predictor and matrix matrix, construct corresponding response with noise')
N=100;
P=10; Q=5;
X=rand(N,P); % N * P predictor
B=rand(P,Q); % P * Q weight matrix
ind=randsample(numel(B),floor(numel(B)*0.8));
B(ind)=0;
Y=X*B+0.1.*rand(N,Q); % N * Q response with noise

disp('Sove linear regression model with regularized least squares method')
para.pentype='ell_1';
para.lambda=0.005;
B=rlr(X,Y,para);
% rmse_1=root_mse(Y,X*B);
rmse_1=norm(Y-X*B)^2;
disp('B=');
disp(B);
disp(['RMSE=',num2str(rmse_1)]);


disp('%%%%%%%%%%%%Exp 2%%%%%%%%%%%%%%%%%');

disp('%%%%%%%%%Linear regression with shape image as weight matrix%%%%%%%%%%%%');

disp('Generate simulated data with shape image as weight matrix')

% B=double(imread('butterfly.bmp'));
B=B(1:16:end,1:16:end);
B(50<B&B<200)=0;
B0=B;
N=1000;
X=rand(N,size(B,1));
Y=X*B+0.1.*rand(N,size(B,1));

disp('Sove linear regression model with RLR- L1-norm')
para.pentype='ell_1';
para.lambda=0.0001;
B_1=rlr(X,Y,para);
% rmse_1=root_mse(Y,X*B_1);
rmse_1=norm(Y-X*B_1)^2;
disp('B_1=');
disp(B_1);
disp(['RMSE=',num2str(rmse_1)]);


disp('Sove linear regression model with RLR- L21-norm')
para.pentype='ell_21';
para.lambda=0.0001;
B_21=rlr(X,Y,para);
% rmse_21=root_mse(Y,X*B_21);
rmse_21=norm(Y-X*B_21)^2;
disp('B_21=');
disp(B_21);
disp(['RMSE=',num2str(rmse_21)]);

disp('Sove linear regression model with RLR- nuclear-norm')
para.pentype='nuclear_norm';
para.lambda=0.0001;
B_nu=rlr(X,Y,para);
% rmse_nu=root_mse(Y,X*B_nu);
rmse_nu=norm(Y-X*B_nu)^2;
disp('B_nu=');
disp(B_nu);
disp(['RMSE=',num2str(rmse_nu)]);

disp('Sove linear regression model with RLR- tv-constraint')
para.pentype='ell_tv';
para.lambda=0.0001;
B_tv=rlr(X,Y,para);
% rmse_tv=root_mse(Y,X*B_tv);
rmse_tv=norm(Y-X*B_tv)^2;
disp('B_tv=');
disp(B_tv);
disp(['RMSE=',num2str(rmse_tv)]);

% disply results with different torlence
figure;
set(gcf,'unit','centimeters','position',[10 10 15 10]);

        subplot(2,3,1);
imshow((B0));
title('Original','fontsize',12);
    
    subplot(2,3,2);
imshow((B_1));
title({' RLR-L1' ;['RMSE=', num2str(roundn(rmse_1,-3))]},'fontsize',12);

    subplot(2,3,3);
imshow((B_21));
title({'RLR-L21' ;['RMSE=', num2str(roundn(rmse_21,-3))]},'fontsize',12);

    subplot(2,3,5);
imshow((B_nu));
title({'RLR-nuclear-norm' ;['RMSE=', num2str(roundn(rmse_nu,-3))]},'fontsize',12);


 subplot(2,3,6);
imshow((B_tv));
title({'RLR-tv' ;['RMSE=', num2str(roundn(rmse_tv,-3))]},'fontsize',12);



