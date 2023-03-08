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
options.Rmax = 4;
options.MaxIter = 50;
[T1,R]=TR_SVD(X,options);
T2=TR_ALS(X,options);
X1 = TR2tensor(T1);
X2 = TR2tensor(T2);
Err1 = norm(calculate('minus', X1, X));
Err2 = norm(calculate('minus', X2, X));

nx=norm(X);

fprintf("TR_SVD with rank [%d,%d,%d] achieve approximation error %d, relative error %d.\n",R(1),R(2),R(3),Err1,Err1/nx);
fprintf("TR_ALS with rank [%d,%d,%d] achieve approximation error %d, relative error %d.\n",R(1),R(2),R(3),Err2,Err2/nx);




if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end


%% %% test TR_SVD and TR_ALS with real image
clc
disp('%%%%%%%%test TR_SVD and TR_ALS%%%%%%%%');

X=double(imread('sherlock.jpg'));
X=tensor(X);
options.Rmax = 5;
options.MaxIter = 100;

[T1,R1]=TR_SVD(X,options);
T2=TR_ALS(X,options);
X1 = TR2tensor(T1);
X2 = TR2tensor(T2);
Err1 = norm(calculate('minus', X1, X));
Err2 = norm(calculate('minus', X2, X));
nx=norm(X);

fprintf("TR_SVD with rank [%d,%d,%d] achieve approximation error %d, relative error %d.\n",R1(1),R1(2),R1(3),Err1,Err1/nx);
fprintf("TR_ALS with rank [%d,%d,%d] achieve approximation error %d, relative error %d.\n",R1(1),R1(2),R1(3),Err2,Err2/nx);

% rank : 50,50,3
options.Rmax = 50;
options.MaxIter = 100;
[T3,R2]=TR_SVD(X,options);
T4=TR_ALS(X,options);
X3 = TR2tensor(T3);
X4 = TR2tensor(T4);
Err3 = norm(calculate('minus', X3, X));
Err4 = norm(calculate('minus', X4, X));
nx=norm(X);

fprintf("TR_SVD with rank [%d,%d,%d] achieve approximation error %d, relative error %d.\n",R2(1),R2(2),R2(3),Err3,Err3/nx);
fprintf("TR_ALS with rank [%d,%d,%d] achieve approximation error %d, relative error %d.\n",R2(1),R2(2),R2(3),Err4,Err4/nx);

% disply results with TR_SVD and TR_ALS
figure;
set(gcf,'unit','centimeters','position',[10 10 30 10]);

subplot(2,3,1);
imshow(imread('sherlock.jpg'));
title('Origin image','fontsize',12);

subplot(2,3,2);
imshow(uint8(double(X1)));
title({'Recovered image by TR_SVD' ;['rank=',R1];['AE=', num2str(Err1)]},'fontsize',12);

subplot(2,3,3);
imshow(uint8(double(X2)));
title({'Recovered image by TR_ALS' ;['rank=',R1];['AE=', num2str(Err2)]},'fontsize',12);


subplot(2,3,5);
imshow(uint8(double(X3)));
title({'Recovered image by TR_SVD' ;['rank=',R2];['AE=', num2str(Err3)]},'fontsize',12);

subplot(2,3,6);
imshow(uint8(double(X4)));
title({'Recovered image by TR_ALS' ;['rank=',R2];['AE=', num2str(Err4)]},'fontsize',12);


if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end
