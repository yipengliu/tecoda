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
AE=norm(Y-X*B)^2;
disp('B=');
disp(B);
disp(['Approxiamte error=',num2str(AE)]);


disp('%%%%%%%%%%%%Exp 2%%%%%%%%%%%%%%%%%');

disp('%%%%%%%%%Linear regression with shape image as weight matrix%%%%%%%%%%%%');

disp('Generate simulated data with shape image as weight matrix')

B=double(imread('circlesBrightDark.png'));
B=B(1:16:end,1:16:end);
B(50<B&B<200)=0;
B0=B;
N=1000;
X=rand(N,32);
Y=X*B+0.1.*rand(N,32);

disp('Sove linear regression model with RLR- L1-norm')
para.pentype='ell_1';
para.lambda=0.0001;
B_1=rlr(X,Y,para);
AE_1=norm(Y-X*B_1)^2;
disp('B_1=');
disp(B_1);
disp(['Approxiamte error=',num2str(AE_1)]);


disp('Sove linear regression model with RLR- L21-norm')
para.pentype='ell_21';
para.lambda=0.0001;
B_21=rlr(X,Y,para);
AE_21=norm(Y-X*B_21)^2;
disp('B_21=');
disp(B_21);
disp(['Approxiamte error=',num2str(AE_21)]);

disp('Sove linear regression model with RLR- nuclear-norm')
para.pentype='nuclear_norm';
para.lambda=0.0001;
B_nu=rlr(X,Y,para);
AE_nu=norm(Y-X*B_nu)^2;
disp('B_nu=');
disp(B_nu);
disp(['Approxiamte error=',num2str(AE_nu)]);


% disply results with different torlence
figure;
set(gcf,'unit','centimeters','position',[10 10 40 10]);

        subplot(1,4,1);
imshow(uint8(B0));
title('Origin image','fontsize',12);
    
    subplot(1,4,2);
imshow(uint8(B));
title({'Recovered image by RLR-L1' ;['AE=', num2str(AE_1)]},'fontsize',12);

    subplot(1,4,3);
imshow(uint8(B));
title({'Recovered image by RLR-L21' ;['AE=', num2str(AE_21)]},'fontsize',12);

    subplot(1,4,4);
imshow(uint8(B));
title({'Recovered image by RLR-nuclear-norm' ;['AE=', num2str(AE_nu)]},'fontsize',12);


suptitle('Image Recovery for Circles');

