%test_cp()
%   test cpclass
clear
clc
Qpause = true;
%% test cptensor()
clc
% test cptensor()
disp('%%%%%%%%test cptensor()%%%%%%%%');
T1 = cptensor();
display(T1);
if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test cptensor(F),cp2tensor() and cptensor(cp)
clc
% test cptensor(F),default weight is 1
disp('%%%%%%%%test cptensor(F)%%%%%%%%');
d = [5,8,10];
r = 4;
F = cell(3,1);
for n=1:length(d)
    F{n}=rand(d(n),r);
end
T=cptensor(F);
display(T)

% test cp2tensor() method
disp('%%%%%%%%test cp2tensor()%%%%%%%%');
X=cp2tensor(T);
sx=size(X);
fprintf("Tensor X is sized of [%d,%d,%d].\n",sx(1),sx(2),sx(3))

% test cptensor(cp),copy an existing cp tensor
disp('%%%%%%%%test cptensor(cp)%%%%%%%%');
T2 = cptensor(T);
fprintf("T2 is a copy of T.\n")
display(T2)

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test cptensor(W,F)
clc
disp('%%%%%%%%test cptensor(W,F)%%%%%%%%');
W = [2,1.5,3,2];
d = [5,8,10];
r = 4;
F = cell(3,1);
for n=1:length(d)
    F{n}=rand(d(n),r);
end

T=cptensor(W,F);
display(T)
X=cp2tensor(T);

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
disp('%%%%%%%%test cptensor(W,F1,F2,...,Fn)%%%%%%%%');
disp('%%%%%%%%test cptensor(W,F)%%%%%%%%');
W = [2,1,3,2];
d = [5,8,10];
r = 4;
F = cell(3,1);
for n=1:length(d)
    F{n}=rand(d(n),r);
end

T=cptensor(W,F{1},F{2},F{3});
display(T)
X=cp2tensor(T);

% test the elements are equal between T and X
idx = [3,4,6];
Ti = sum(W.*F{1}(idx(1),:).*F{2}(idx(2),:).*F{3}(idx(3),:));
Xi = X(idx);
fprintf("Ti is %d and Xi is %d.\n",Ti,Xi)

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test cp_als
clc
disp('%%%%%%%%test cp-als%%%%%%%%');

X=tensor(rand([3,4,5]));
R=10;
T=cp_als(X,R);
X_hat=cp2tensor(T);

Err=norm(calculate("minus",X,cp2tensor(T)))/norm(X);%% needs further define

fprintf("CP approximation with rank %d achieve approximation erro %d.\n",R,Err)


if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end


%% test cp_als with real image
clc
disp('%%%%%%%%test cp_als %%%%%%%%');

X=double(imread('sherlock.jpg'));
X=tensor(X);
% rank : 10
R=10;
T=cp_als(X,R);
X1 = cp2tensor(T);
Err1 = norm(calculate("minus", X1, X));
nx=norm(X);

fprintf("CP approximation with rank %d achieve approximation error %d, relative error %d.\n",R,Err1,Err1/nx);


% rank : 50
R=50;
T=cp_als(X,R);
X2 = cp2tensor(T);
Err2 = norm(calculate("minus", X2, X));
nx=norm(X);

fprintf("CP approximation with rank %d achieve approximation error %d, relative error %d.\n",R,Err2,Err2/nx);


% disply results with cp_als
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
