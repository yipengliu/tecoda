%test_cp()
%   test cpclass
clear
clc
Qpause = true;
%% test cptensor()
disp('%%%%%%%%test cptensor()%%%%%%%%');
T1 = cptensor();
display(T1);

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test cptensor(F) and cptensor(cp)
disp('%%%%%%%%test cptensor(F) and cptensor(cp)%%%%%%%%');
d = [5,8,10];
r = 4;
F = cell(3,1);
for n=1:length(d)
    F{n}=rand(d(n),r);
end

T=cptensor(F);
display(T)
X=cp2tensor(T);

% test the elements are equal between T and X
idx = [3,4,6];
Ti = sum(F{1}(idx(1),:).*F{2}(idx(2),:).*F{3}(idx(3),:));
Xi = X(idx);
fprintf("Ti is %d and Xi is %d.\n",Ti,Xi)

% test cptensor(cp),copy an exist cp tensor
fprintf("-------------------------------------\n")
T2 = cptensor(T);
fprintf("T2 is a copy of T and its tensor format is X2.\n")
display(T2)
X2 = cp2tensor(T2);
X2i = X2(idx);
fprintf("X2i is %d and Ti is %d.\n",X2i,Ti)

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test cptensor(W,F)
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
disp('%%%%%%%%test cp-als%%%%%%%%');

X=tensor(rand([3,4,5]));
R=10;
T=cp_als(X,R);
X_hat=cp2tensor(T);
Err=norm(reshape(double(X)-double(cp2tensor(T)),1,[]))/norm(reshape(double(X),1,[]));%% needs further define

fprintf("CP approxiamtion with rank %d achieve approxiamtion erro %d.\n",R,Err)


if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end
