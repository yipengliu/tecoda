%% %test_tucker()
%   test tkclass
clear
clc
Qpause = true;
%% test TKtensor()
clc
disp('%%%%%%%%test TKtensor()%%%%%%%%');
T1 = TKtensor();
display(T1);

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test TKtensor(W,F)
clc
disp('%%%%%%%%test TKtensor(core,F)%%%%%%%%');
d = [5,8,10];
r = [4,2,3];
core = tensor(rand(r));

F = cell(3,1);
for n=1:length(d)
    F{n}=rand(d(n),r(n));
end

T=TKtensor(core,F);
display(T)


if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test TKtensor(W,F1,F2,...,Fn)
clc
disp('%%%%%%%%test TKtensor(core,F1,F2,...,Fn)%%%%%%%%');

T=TKtensor(core,F{1},F{2},F{3});
display(T)


if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test TKtensor(TK),copy an exist TKtensor
clc
disp('%%%%%%%%test TKtensor(TK)%%%%%%%%');
T2 = TKtensor(T);
fprintf("T2 is a copy of T.\n")
display(T2)

ERR=norm(calculate("minus",TK2tensor(T),TK2tensor(T2)));

if ERR==0
    fprintf("T2 equels T.\n")
end

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test hosvd and hooi
clc
disp('%%%%%%%%test HOSVD and HOOI%%%%%%%%');


X=tensor(rand([3,4,5]));
R=[3,4,5];
T1=HOSVD(X,R);
T2=HOOI(X,R);
X1 = TK2tensor(T1);
X2 = TK2tensor(T2);
Err1 = norm(calculate("minus", X1, X));
Err2 = norm(calculate("minus", X2, X));

nx=norm(X);

fprintf("HOSVD with rank [%d,%d,%d] achieve approximation error %d, relative error %d.\n",R(1),R(2),R(3),Err1,Err1/nx);
fprintf("HOOI with rank [%d,%d,%d] achieve approximation error %d, relative error %d.\n",R(1),R(2),R(3),Err2,Err2/nx);




if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end


%% test hosvd and hooi with real image
clc
disp('%%%%%%%%test HOSVD and HOOI%%%%%%%%');

X=double(imread('sherlock.jpg'));
X=tensor(X);
% rank : 10,10,3
R=[10,10,3];
T1=HOSVD(X,R);
T2=HOOI(X,R);
X1 = TK2tensor(T1);
X2 = TK2tensor(T2);
Err1 = norm(calculate("minus", X1, X));
Err2 = norm(calculate("minus", X2, X));
nx=norm(X);

fprintf("HOSVD with rank [%d,%d,%d] achieve approximation error %d, relative error %d.\n",R(1),R(2),R(3),Err1,Err1/nx);
fprintf("HOOI with rank [%d,%d,%d] achieve approximation error %d, relative error %d.\n",R(1),R(2),R(3),Err2,Err2/nx);

% rank : 50,50,3
R=[50,50,3];
T3=HOSVD(X,R);
T4=HOOI(X,R);
X3 = TK2tensor(T3);
X4 = TK2tensor(T4);
Err3 = norm(calculate("minus", X3, X));
Err4 = norm(calculate("minus", X4, X));
nx=norm(X);

fprintf("HOSVD with rank [%d,%d,%d] achieve approximation error %d, relative error %d.\n",R(1),R(2),R(3),Err3,Err3/nx);
fprintf("HOOI with rank [%d,%d,%d] achieve approximation error %d, relative error %d.\n",R(1),R(2),R(3),Err4,Err4/nx);

% disply results with HOSVD and HOOI
figure;
set(gcf,'unit','centimeters','position',[10 10 30 10]);

subplot(2,3,1);
imshow(imread('sherlock.jpg'));
title('Origin image','fontsize',12);

subplot(2,3,2);
imshow(uint8(double(X1)));
title({'Recovered image by HOSVD' ;['rank=[10,10,3]'];['AE=', num2str(Err1)]},'fontsize',12);

subplot(2,3,3);
imshow(uint8(double(X2)));
title({'Recovered image by HOOI' ;['rank=[10,10,3]'];['AE=', num2str(Err2)]},'fontsize',12);


subplot(2,3,5);
imshow(uint8(double(X3)));
title({'Recovered image by HOSVD' ;['rank=[50,50,3]'];['AE=', num2str(Err3)]},'fontsize',12);

subplot(2,3,6);
imshow(uint8(double(X4)));
title({'Recovered image by HOOI' ;'rank=[50,50,3]';['AE=', num2str(Err4)]},'fontsize',12);


if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end
