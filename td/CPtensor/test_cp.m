%test_CP()
%   test CPclass
clear
clc
Qpause = true;
%% test CPtensor()
clc
% test CPtensor()
disp('%%%%%%%%test CPtensor()%%%%%%%%');
T1 = CPtensor();
display(T1);
if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test CPtensor(F),CP2tensor() and CPtensor(CP)
clc
% test CPtensor(F),default weight is 1
disp('%%%%%%%%test CPtensor(F)%%%%%%%%');
d = [5,8,10];
r = 4;
F = cell(3,1);
for n=1:length(d)
    F{n}=rand(d(n),r);
end
T=CPtensor(F);
display(T)

% test CP2tensor() method
disp('%%%%%%%%test CP2tensor()%%%%%%%%');
X=CP2tensor(T);
sx=size(X);
fprintf("Tensor X is sized of [%d,%d,%d].\n",sx(1),sx(2),sx(3))

% test CPtensor(CP),copy an existing CP tensor
disp('%%%%%%%%test CPtensor(CP)%%%%%%%%');
T2 = CPtensor(T);
fprintf("T2 is a copy of T.\n")
display(T2)

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test CPtensor(W,F)
clc
disp('%%%%%%%%test CPtensor(W,F)%%%%%%%%');
W = [2,1.5,3,2];
d = [5,8,10];
r = 4;
F = cell(3,1);
for n=1:length(d)
    F{n}=rand(d(n),r);
end

T=CPtensor(W,F);
display(T)
X=CP2tensor(T);

% test the elements are equal between T and X
idx = [3,4,6];
Ti = sum(W.*F{1}(idx(1),:).*F{2}(idx(2),:).*F{3}(idx(3),:));
Xi = X(idx);
fprintf("Ti is %d and Xi is %d.\n",Ti,Xi)

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test (W,F1,F2,...,Fn)
clc
disp('%%%%%%%%test CPtensor(W,F1,F2,...,Fn)%%%%%%%%');
disp('%%%%%%%%test CPtensor(W,F)%%%%%%%%');
W = [2,1,3,2];
d = [5,8,10];
r = 4;
F = cell(3,1);
for n=1:length(d)
    F{n}=rand(d(n),r);
end

T=CPtensor(W,F{1},F{2},F{3});
display(T)
X=CP2tensor(T);

% test the elements are equal between T and X
idx = [3,4,6];
Ti = sum(W.*F{1}(idx(1),:).*F{2}(idx(2),:).*F{3}(idx(3),:));
Xi = X(idx);
fprintf("Ti is %d and Xi is %d.\n",Ti,Xi)

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test CP_ALS
clc
disp('%%%%%%%%test CP_ALS%%%%%%%%');

X=tensor(rand([3,4,5]));
R=10;
T=CP_ALS(X,R);
X_hat=CP2tensor(T);

Err=norm(calculate('minus',X,CP2tensor(T)))/norm(X);%% needs further define

fprintf("CP approximation with rank %d achieve approximation erro %d.\n",R,Err)


if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end


%% test CP_ALS with real image
clc
disp('%%%%%%%%test CP_ALS %%%%%%%%');

X=double(imread('sherlock.jpg'));
X=tensor(X);
% rank : 10
R=10;
T=CP_ALS(X,R);
X1 = CP2tensor(T);
Err1 = norm(calculate('minus', X1, X));
nx=norm(X);

fprintf("CP approximation with rank %d achieve approximation error %d, relative error %d.\n",R,Err1,Err1/nx);


% rank : 50
R=50;
T=CP_ALS(X,R);
X2 = CP2tensor(T);
Err2 = norm(calculate('minus', X2, X));
nx=norm(X);

fprintf("CP approximation with rank %d achieve approximation error %d, relative error %d.\n",R,Err2,Err2/nx);


% disply results with CP_ALS
figure;
set(gcf,'unit','centimeters','position',[10 10 30 10]);

subplot(1,3,1);
imshow(imread('sherlock.jpg'));
title('Origin image','fontsize',12);

subplot(1,3,2);
imshow(uint8(double(X1)));
title({['rank=10'];['AE=', num2str(Err1)]},'fontsize',12);

subplot(1,3,3);
imshow(uint8(double(X2)));
title({['rank=50'];['AE=', num2str(Err2)]},'fontsize',12);


if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end
