%test_cp()
%   test cpclass
clear
clc
Qpause = true;
%% test cptensor()
clc
disp('%%%%%%%%test cptensor()%%%%%%%%');
T1 = cptensor();
display(T1);

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test cptensor(F) and cptensor(cp)
clc
disp('%%%%%%%%test cptensor(F)%%%%%%%%');
d = [5,8,10];
r = 4;
F = cell(3,1);
for n=1:length(d)
    F{n}=rand(d(n),r);
end

T=cptensor(F);
display(T)


disp('%%%%%%%%test cp2tensor()%%%%%%%%');

X=cp2tensor(T);
sx=size(X);

fprintf("Tensor X is sized of [%d,%d,%d].\n",sx(1),sx(2),sx(3))

% test cptensor(cp),copy an exist cp tensor
disp('%%%%%%%%test cptensor(cp)%%%%%%%%');
T2 = cptensor(T);
fprintf("T2 is a copy of T and its tensor format is X2.\n")
display(T2)

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test cptensor(W,F)
clc
disp('%%%%%%%%test cptensor(W,F)%%%%%%%%');
W = [2,1,3,2];
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

fprintf("CP approxiamtion with rank %d achieve approxiamtion erro %d.\n",R,Err)


if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end
