%% %test_tr()
%   test tr
clear
clc
Qpause = true;
%% test TRtensor()
clc
disp('%%%%%%%%test TRtensor()%%%%%%%%');
T1 = TRtensor();
display(T1);

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test TRtensor(W,F)
clc
disp('%%%%%%%%test TRtensor(core,F)%%%%%%%%');
d = [5,8,10];
r = [4,2,3];
core = tensor(rand(r));

F = cell(3,1);
for n=1:length(d)-1
    F{n}=rand(r(n),d(n),r(n+1));
end
F{3}=rand(r(3),d(3),r(1));

T=TRtensor(F);
display(T)


if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test TRtensor(W,F1,F2,...,Fn)
clc
disp('%%%%%%%%test TRtensor(core,F1,F2,...,Fn)%%%%%%%%');

T=TRtensor(F{1},F{2},F{3});
display(T)


if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test TRtensor(TR),copy an exist TRtensor
clc
disp('%%%%%%%%test TRtensor(TR)%%%%%%%%');
T2 = TRtensor(T);
fprintf("T2 is a copy of T.\n")
display(T2)

ERR=norm(calculate('minus',TR2tensor(T),TR2tensor(T2)));

if ERR==0
    fprintf("T2 equels T.\n")
end

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test TR_SVD and TR_ALS
clc
disp('%%%%%%%%test TR_SVD and TR_ALS%%%%%%%%');


X=tensor(rand([30,40,50]));
options.tol = 0.1;
T1=TR_SVD(X,options.tol);

options.intial='svd';% svd or rand
options.MaxIter = 50;
options.Rmax=5;
T2=TR_ALS(X,options);
X1 = TR2tensor(T1);
X2 = TR2tensor(T2);
Err1 = norm(calculate('minus', X1, X))/sqrt(prod(X.size));
Err2 = norm(calculate('minus', X2, X))/sqrt(prod(X.size));
R=T1.rank;

fprintf("TR_SVD with rank [%d,%d,%d] achieve RMSE %d.\n",R(1),R(2),R(3),Err1);
fprintf("TR_ALS with rank [%d,%d,%d] achieve RMSE %d.\n",R(1),R(2),R(3),Err2);




if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end


%% %% test TR_SVD and TR_ALS with real image
clc
disp('%%%%%%%%test TR_SVD and TR_ALS with real image%%%%%%%%');

X=double(imread('sherlock.jpg'));
X=tensor(X);
options.tol = 0.1;
T1=TR_SVD(X,options.tol);

options.intial='svd';% svd or rand
options.MaxIter = 50;
options.maxR=5;
T2=TR_ALS(X,options);
X1 = TR2tensor(T1);
X2 = TR2tensor(T2);
Err1 = norm(calculate('minus', X1, X))/sqrt(prod(X.size));
Err2 = norm(calculate('minus', X2, X))/sqrt(prod(X.size));
R1=T1.rank;

fprintf("TR_SVD with rank [%d,%d,%d] achieve RMSE %d.\n",R1(1),R1(2),R1(3),Err1);
fprintf("TR_ALS with rank [%d,%d,%d] achieve RMSE %d.\n",R1(1),R1(2),R1(3),Err2);


% rank : 50,50,3
options.tol = 0.01;
T3=TR_SVD(X,options.tol);

options.intial='svd';% svd or rand
options.MaxIter = 50;
options.Rmax=50;
T4=TR_ALS(X,options);
X3 = TR2tensor(T3);
X4 = TR2tensor(T4);
Err3 = norm(calculate('minus', X3, X))/sqrt(prod(X.size));
Err4 = norm(calculate('minus', X4, X))/sqrt(prod(X.size));
R2=T3.rank;

fprintf("TR_SVD with rank [%d,%d,%d] achieve RMSE %d.\n",R2(1),R2(2),R2(3),Err3);
fprintf("TR_ALS with rank [%d,%d,%d] achieve RMSE %d.\n",R2(1),R2(2),R2(3),Err4);


% disply results with TR_SVD and TR_ALS
figure;
set(gcf,'unit','centimeters','position',[10 10 30 10]);

subplot(2,3,1);
imshow(imread('sherlock.jpg'));
title('Original','fontsize',12);

subplot(2,3,2);
imshow(uint8(double(X1)));
title({'TR\_SVD' ;"rank=["+strjoin(string(R1))+"]";['RMSE=', num2str(roundn(Err1,-2))]},'fontsize',12);

subplot(2,3,3);
imshow(uint8(double(X2)));
title({'TR\_ALS' ;"rank=["+strjoin(string(R1))+"]";['RMSE=', num2str(roundn(Err2,-2))]},'fontsize',12);


subplot(2,3,5);
imshow(uint8(double(X3)));
title({'TR\_SVD' ;"rank=["+strjoin(string(R2))+"]";['RMSE=', num2str(roundn(Err3,-2))]},'fontsize',12);

subplot(2,3,6);
imshow(uint8(double(X4)));
title({'TR\_ALS' ;"rank=["+strjoin(string(R2))+"]";['RMSE=', num2str(roundn(Err4,-2))]},'fontsize',12);


if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test with video

clc
disp('%%%%%%%%test TR_SVD and TR_ALS with video%%%%%%%%');

vidObj = VideoReader("xylophone_video.mp4");
frames = double(read(vidObj,[18 47]));


X=tensor(frames);
options.tol = 0.5;
T1=TR_SVD(X,options.tol);

options.intial='svd';% svd or rand
options.MaxIter = 50;
options.maxR=1;
T2=TR_ALS(X,options);
X1 = TR2tensor(T1);
X2 = TR2tensor(T2);
Err1 = norm(calculate('minus', X1, X))/sqrt(prod(X.size));
Err2 = norm(calculate('minus', X2, X))/sqrt(prod(X.size));
R1=T1.rank;

fprintf("TR_SVD with rank [%d,%d,%d] achieve RMSE %d.\n",R1(1),R1(2),R1(3),Err1);
fprintf("TR_ALS with rank [%d,%d,%d] achieve RMSE %d.\n",R1(1),R1(2),R1(3),Err2);


% rank : 50,50,3
options.tol = 0.1;
T3=TR_SVD(X,options.tol);

options.intial='rand';% svd or rand
options.MaxIter = 50;
options.Rmax=2;
T4=TR_ALS(X,options);
X3 = TR2tensor(T3);
X4 = TR2tensor(T4);
Err3 = norm(calculate('minus', X3, X))/sqrt(prod(X.size));
Err4 = norm(calculate('minus', X4, X))/sqrt(prod(X.size));
R2=T3.rank;

fprintf("TR_SVD with rank [%d,%d,%d] achieve RMSE %d.\n",R2(1),R2(2),R2(3),Err3);
fprintf("TR_ALS with rank [%d,%d,%d] achieve RMSE %d.\n",R2(1),R2(2),R2(3),Err4);


% disply results with TR_SVD and TR_ALS
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
    title({'TR\_SVD' ;"rank=["+strjoin(string(R1))+"]";['RMSE=', num2str(roundn(Err1,-3))]},'fontsize',12);
    
    subplot(2,3,3);
    imshow(uint8(double(X2(:,:,:,f))));
    title({'TR\_ALS' ;"rank=["+strjoin(string(R1))+"]";['RMSE=', num2str(roundn(Err2,-3))]},'fontsize',12);
    
    
    subplot(2,3,5);
    imshow(uint8(double(X3(:,:,:,f))));
    title({'TR\_SVD' ;"rank=["+strjoin(string(R2))+"]";['RMSE=', num2str(roundn(Err3,-3))]},'fontsize',12);
    
    subplot(2,3,6);
    imshow(uint8(double(X4(:,:,:,f))));
    title({'TR\_ALS' ;"rank=["+strjoin(string(R2))+"]";['RMSE=', num2str(roundn(Err4,-3))]},'fontsize',12);
    
    drawnow
end

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end
