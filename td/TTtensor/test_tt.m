

%% %test_tt()
%   test tr
clear
clc
Qpause = true;
%% test TTtensor()
clc
disp('%%%%%%%%test TTtensor()%%%%%%%%');
T1 = TTtensor();
display(T1);

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test TTtensor(W,F)
clc
disp('%%%%%%%%test TTtensor(F)%%%%%%%%');
d = [5,8,10];
r = [1,2,3];
 
F = cell(3,1);
for n=1:length(d)-1
    F{n}=rand(r(n),d(n),r(n+1));
end
F{3}=rand(r(3),d(3),r(1));

T=TTtensor(F);
display(T)


if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test TTtensor(F1,F2,...,Fn)
clc
disp('%%%%%%%%test TTtensor(F1,F2,...,Fn)%%%%%%%%');

T=TTtensor(F{1},F{2},F{3});
display(T)


if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test TTtensor(TT),copy an exist TRtensor
clc
disp('%%%%%%%%test TTtensor(TT)%%%%%%%%');
T2 = TTtensor(T);
fprintf("T2 is a copy of T.\n")
display(T2)

ERR=norm(calculate('minus',TT2tensor(T),TT2tensor(T2)));

if ERR==0
    fprintf("T2 equels T.\n")
end

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test TT_SVD and TT_als
X=rand(200,300,40);
X=tensor(X);
tol=0.1;
TT1 = TT_SVD(X, tol);
T1 = TT2tensor(TT1);
Err1 = norm(calculate('minus', X, T1))/sqrt(prod(X.size));
R1=TT1.rank;

options.maxR = 4;
options.MaxIter = 50;
TT2 = TT_ALS(X, options);
T2 = TT2tensor(TT2);
Err2 = norm(calculate('minus', X, T2))/sqrt(prod(X.size));
R2=TT2.rank;

fprintf("TT_SVD with rank [%d,%d,%d] achieve RMSE %d.\n",R1(1),R1(2),R1(3),Err1);
fprintf("TT_ALS with rank [%d,%d,%d] achieve RMSE %d.\n",R2(1),R2(2),R2(3),Err2);

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end


%% %% test TT_SVD and TT_ALS with real image
clc
disp('%%%%%%%%test TT_SVD and TT_ALS with real image%%%%%%%%');

X=double(imread('sherlock.jpg'));
X=tensor(X);
options.tol = 0.1;
T1=TT_SVD(X,options.tol);

options.intial='svd';% svd or rand
options.MaxIter = 50;
options.maxR=5;
T2=TT_ALS(X,options);
X1 = TT2tensor(T1);
X2 = TT2tensor(T2);
Err1 = norm(calculate('minus', X1, X))/sqrt(prod(X.size));
Err2 = norm(calculate('minus', X2, X))/sqrt(prod(X.size));
R1=T1.rank;

fprintf("TT_SVD with rank [%d,%d,%d] achieve RMSE %d.\n",R1(1),R1(2),R1(3),Err1);
fprintf("TT_ALS with rank [%d,%d,%d] achieve RMSE %d.\n",R1(1),R1(2),R1(3),Err2);


% rank : 50,50,3
options.tol = 0.01;
T3=TT_SVD(X,options.tol);

options.intial='svd';% svd or rand
options.MaxIter = 50;
options.maxR=50;
T4=TT_ALS(X,options);
X3 = TT2tensor(T3);
X4 = TT2tensor(T4);
Err3 = norm(calculate('minus', X3, X))/sqrt(prod(X.size));
Err4 = norm(calculate('minus', X4, X))/sqrt(prod(X.size));
R2=T3.rank;

fprintf("TT_SVD with rank [%d,%d,%d] achieve RMSE %d.\n",R2(1),R2(2),R2(3),Err3);
fprintf("TT_ALS with rank [%d,%d,%d] achieve RMSE %d.\n",R2(1),R2(2),R2(3),Err4);


% disply results with TT_SVD and TT_ALS
figure;
set(gcf,'unit','centimeters','position',[10 10 30 10]);

subplot(2,3,1);
imshow(imread('sherlock.jpg'));
title('Original','fontsize',12);

subplot(2,3,2);
imshow(uint8(double(X1)));
title({'TT\_SVD' ;"rank=["+strjoin(string(R1))+"]";['RMSE=', num2str(roundn(Err1,-2))]},'fontsize',12);

subplot(2,3,3);
imshow(uint8(double(X2)));
title({'TT\_ALS' ;"rank=["+strjoin(string(R1))+"]";['RMSE=', num2str(roundn(Err2,-2))]},'fontsize',12);


subplot(2,3,5);
imshow(uint8(double(X3)));
title({'TT\_SVD' ;"rank=["+strjoin(string(R2))+"]";['RMSE=', num2str(roundn(Err3,-2))]},'fontsize',12);

subplot(2,3,6);
imshow(uint8(double(X4)));
title({'TT\_ALS' ;"rank=["+strjoin(string(R2))+"]";['RMSE=', num2str(roundn(Err4,-2))]},'fontsize',12);


if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test with video

clc
disp('%%%%%%%%test TT_SVD and TT_ALS with video%%%%%%%%');

vidObj = VideoReader("xylophone_video.mp4");
frames = double(read(vidObj,[18 47]));


X=tensor(frames);
options.tol = 0.5;
T1=TT_SVD(X,options.tol);

options.intial='svd';% svd or rand
options.MaxIter = 50;
options.maxR=1;
T2=TT_ALS(X,options);
X1 = TT2tensor(T1);
X2 = TT2tensor(T2);
Err1 = norm(calculate('minus', X1, X))/sqrt(prod(X.size));
Err2 = norm(calculate('minus', X2, X))/sqrt(prod(X.size));
R1=T1.rank;

fprintf("TT_SVD with rank [%d,%d,%d] achieve RMSE %d.\n",R1(1),R1(2),R1(3),Err1);
fprintf("TT_ALS with rank [%d,%d,%d] achieve RMSE %d.\n",R1(1),R1(2),R1(3),Err2);


% rank : 50,50,3
options.tol = 0.1;
T3=TT_SVD(X,options.tol);

options.intial='rand';% svd or rand
options.MaxIter = 50;
options.maxR=2;
T4=TT_ALS(X,options);
X3 = TT2tensor(T3);
X4 = TT2tensor(T4);
Err3 = norm(calculate('minus', X3, X))/sqrt(prod(X.size));
Err4 = norm(calculate('minus', X4, X))/sqrt(prod(X.size));
R2=T3.rank;

fprintf("TT_SVD with rank [%d,%d,%d] achieve RMSE %d.\n",R2(1),R2(2),R2(3),Err3);
fprintf("TT_ALS with rank [%d,%d,%d] achieve RMSE %d.\n",R2(1),R2(2),R2(3),Err4);


% disply results with TT_SVD and TT_ALS
figure;
set(gcf,'unit','centimeters','position',[10 10 30 10]);
X=double(X);
X1=double(X1);
X2=double(X2);
X3=double(X3);
X4=double(X4);

for f=1:size(X,4)
    subplot(2,3,1);
    imshow(uint8(X(:,:,:,f)));
    title('Original','fontsize',12);
    
    subplot(2,3,2);
    imshow(uint8(double(X1(:,:,:,f))));
    title({'TT\_SVD' ;"rank=["+strjoin(string(R1))+"]";['RMSE=', num2str(roundn(Err1,-3))]},'fontsize',12);
    
    subplot(2,3,3);
    imshow(uint8(double(X2(:,:,:,f))));
    title({'TT\_ALS' ;"rank=["+strjoin(string(R1))+"]";['RMSE=', num2str(roundn(Err2,-3))]},'fontsize',12);
    
    
    subplot(2,3,5);
    imshow(uint8(double(X3(:,:,:,f))));
    title({'TT\_SVD' ;"rank=["+strjoin(string(R2))+"]";['RMSE=', num2str(roundn(Err3,-3))]},'fontsize',12);
    
    subplot(2,3,6);
    imshow(uint8(double(X4(:,:,:,f))));
    title({'TT\_ALS' ;"rank=["+strjoin(string(R2))+"]";['RMSE=', num2str(roundn(Err4,-3))]},'fontsize',12);
    
    drawnow
end

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end
