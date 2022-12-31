%test unfold
%   test unfold functions,can also refer to ./test_tennuf.m
%test ternuf
%   test ternuf class,can also refer to ./core/test_unfold.m
clear
clc
Qpause = true;
T = rand(5,30,56,6);
sz = size(T);
idx = {2,3,4,5};
%Ti = T(idx{:});
% test tensor class input
% T = tensor(rand(5,30,56,6,7,8));
% sz = T.size;

%% test k_unfold()
clc
disp('%%%%%%test k_unfold%%%%%');
% test k_unfold(T)
Mk = k_unfold(T);
sm=size(Mk);
i=2;
j=3+(4-1)*30+(5-1)*30*56;

fprintf("k unfolding, mode = %d \n  unfolding matrix sized of [%d,%d], element in [%d,%d] is %d.\n",1,sm(1),sm(2),i,j,Mk(i,j));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-Mk(i,j)));

Tk = k_fold(Mk,sz);% fold the unfolding matrix back
stk=size(Tk);
fprintf("k folding, mode = %d \n  folding tensor sized of [%d,%d,%d,%d], element in [%d,%d,%d,%d] is %d.\n",1,stk(1),stk(2),stk(3),stk(4),idx{1},idx{2},idx{3},idx{4},Tk(idx{:}));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-Tk(idx{:})));
disp("----------------------------------------------------------------------------------------------");

% test k_unfold(T,k)
modeK = 2;
Mk = k_unfold(T,modeK);
sm=size(Mk);
i=2+(3-1)*5;
j=4+(5-1)*56;

fprintf("k unfolding, mode = %d \n  unfolding matrix sized of [%d,%d], element in [%d,%d] is %d.\n",modeK,sm(1),sm(2),i,j,Mk(i,j));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-Mk(i,j)));

Tk = k_fold(Mk,sz);% fold the unfolding matrix back
stk=size(Tk);
fprintf("k folding, mode = %d \n  folding tensor sized of [%d,%d,%d,%d], element in [%d,%d,%d,%d] is %d.\n",modeK,stk(1),stk(2),stk(3),stk(4),idx{1},idx{2},idx{3},idx{4},Tk(idx{:}));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-Tk(idx{:})));

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end
%% test mode_n_unfold()
clc
disp('%%%%%%%%test mode_n_unfold%%%%%%%%');
% test mode_n_unfold(T)
Mn = mode_n_unfold(T);
sm=size(Mn);
i=2;
j=3+(4-1)*30+(5-1)*30*56;

fprintf("mode n unfolding, mode = %d \n  unfolding matrix sized of [%d,%d], element in [%d,%d] is %d.\n",1,sm(1),sm(2),i,j,Mn(i,j));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-Mn(i,j)));

Tn = mode_n_fold(Mn,1,sz);% fold the unfolding matrix back
stk=size(Tn);
fprintf("mode n folding, mode = %d \n  folding tensor sized of [%d,%d,%d,%d], element in [%d,%d,%d,%d] is %d.\n",1,stk(1),stk(2),stk(3),stk(4),idx{1},idx{2},idx{3},idx{4},Tn(idx{:}));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-Tn(idx{:})));
disp("----------------------------------------------------------------------------------------------");
%test mode_n_unfold(T,mode)
modeN = 2;
Mn = mode_n_unfold(T,modeN);
sm=size(Mn);
i=3;
j=2+(4-1)*5+(5-1)*5*56;

fprintf("mode n unfolding, mode = %d\n  unfolding matrix sized of [%d,%d], element in [%d,%d] is %d.\n",modeN,sm(1),sm(2),i,j,Mn(i,j));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-Mn(i,j)));

Tn = mode_n_fold(Mn,modeN,sz);% fold the unfolding matrix back
stk=size(Tn);
fprintf("mode n folding, mode = %d,\n  folding tensor sized of [%d,%d,%d,%d], element in [%d,%d,%d,%d] is %d.\n",modeN,stk(1),stk(2),stk(3),stk(4),idx{1},idx{2},idx{3},idx{4},Tn(idx{:}));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-Tn(idx{:})));
disp("----------------------------------------------------------------------------------------------");
%test mode_n_unfold(T,mode,order)
modeN = 2;
order = 'i';
Mn = mode_n_unfold(T,modeN,order);
sm=size(Mn);
i=3;
j=4+(5-1)*56+(2-1)*56*6;

fprintf("mode n unfolding, mode = %d, order  = %s\n  unfolding matrix sized of [%d,%d], element in [%d,%d] is %d.\n",modeN,order,sm(1),sm(2),i,j,Mn(i,j));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-Mn(i,j)));

Tn = mode_n_fold(Mn,modeN,sz,order);% fold the unfolding matrix back
stk=size(Tn);
fprintf("mode n folding, mode = %d, order  = %s\n  folding tensor sized of [%d,%d,%d,%d], element in [%d,%d,%d,%d] is %d.\n",modeN,order,stk(1),stk(2),stk(3),stk(4),idx{1},idx{2},idx{3},idx{4},Tn(idx{:}));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-Tn(idx{:})));
disp("----------------------------------------------------------------------------------------------");

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end
%% test mode_n1n2_unfold()
clc
disp('%%%%%%%%test mode_n1n2_unfold%%%%%%%%');
% test mode_n1n2_unfold(T),just the same to mode_n_unfold(T,1)
Mn1n2 = mode_n1n2_unfold(T);
sm=size(Mn1n2);
i=2;
j=3+(4-1)*30+(5-1)*30*56;

fprintf("mode n unfolding, mode = %d \n  unfolding matrix sized of [%d,%d], element in [%d,%d] is %d.\n",1,sm(1),sm(2),i,j,Mn1n2(i,j));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-Mn1n2(i,j)));

Tn1n2 = mode_n1n2_fold(Mn1n2,1,sz);% fold the unfolding matrix back
stk=size(Tn1n2);
fprintf("mode n folding, mode = %d \n  folding tensor sized of [%d,%d,%d,%d], element in [%d,%d,%d,%d] is %d.\n",1,stk(1),stk(2),stk(3),stk(4),idx{1},idx{2},idx{3},idx{4},Tn1n2(idx{:}));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-Tn1n2(idx{:})));
disp("----------------------------------------------------------------------------------------------");

% test mode_n1n2_unfold(T,n)
n=[3,2];
Mn1n2 = mode_n1n2_unfold(T,n);
sm=size(Mn1n2);
i=4;
j=3;
k=2+(5-1)*5;

fprintf("mode n1n2 unfolding, mode = [%d,%d] \n  unfolding tensor sized of [%d,%d,%d], element in [%d,%d,%d] is %d.\n",n(1),n(2),sm(1),sm(2),sm(3),i,j,k,Mn1n2(i,j,k));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-Mn1n2(i,j,k)));

Tn1n2 = mode_n1n2_fold(Mn1n2,n,sz);% fold the unfolding matrix back
stk=size(Tn1n2);
fprintf("mode n folding, mode = [%d,%d] \n  folding tensor sized of [%d,%d,%d,%d], element in [%d,%d,%d,%d] is %d.\n",n(1),n(2),stk(1),stk(2),stk(3),stk(4),idx{1},idx{2},idx{3},idx{4},Tn1n2(idx{:}));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-Tn1n2(idx{:})));
disp("----------------------------------------------------------------------------------------------");
% test mode_n1n2_unfold(T,n1,n2,...,nn)
n=[3,2];
Mn1n2 = mode_n1n2_unfold(T,n(1),n(2));
sm=size(Mn1n2);
i=4;
j=3;
k=2+(5-1)*5;

fprintf("mode n1n2 unfolding, mode = [%d,%d] \n  unfolding tensor sized of [%d,%d,%d], element in [%d,%d,%d] is %d.\n",n(1),n(2),sm(1),sm(2),sm(3),i,j,k,Mn1n2(i,j,k));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-Mn1n2(i,j,k)));

Tn1n2 = mode_n1n2_fold(Mn1n2,n(1),n(2),sz);% fold the unfolding matrix back
stk=size(Tn1n2);
fprintf("mode n folding, mode = [%d,%d] \n  folding tensor sized of [%d,%d,%d,%d], element in [%d,%d,%d,%d] is %d.\n",n(1),n(2),stk(1),stk(2),stk(3),stk(4),idx{1},idx{2},idx{3},idx{4},Tn1n2(idx{:}));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-Tn1n2(idx{:})));

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end
%% test Lshift_n_unfold()
clc
disp('%%%%%%test Lshift_n_unfold()%%%%%');
Lshift = 3;
n=2;
MLn = Lshift_n_unfold(T,Lshift,n);
sm=size(MLn);
i=4+(5-1)*56;
j=2+(3-1)*5;

fprintf("L-shift mode n unfolding, Lshift = %d, mode = %d\n  unfolding matrix sized of [%d,%d], element in [%d,%d] is %d.\n",Lshift,n,sm(1),sm(2),i,j,MLn(i,j));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-MLn(i,j)));

TLn = Lshift_n_fold(MLn,Lshift,sz);% fold the unfolding matrix back
stk=size(TLn);
fprintf("L-shift mode n folding, Lshift = %d, mode = %d,\n  folding tensor sized of [%d,%d,%d,%d], element in [%d,%d,%d,%d] is %d.\n",Lshift,n,stk(1),stk(2),stk(3),stk(4),idx{1},idx{2},idx{3},idx{4},TLn(idx{:}));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-TLn(idx{:})));

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end
%% test balanced_unfold()
disp('%%%%%%test balanced_unfold()%%%%%');
[Mb,L,n] = balanced_unfold(T);
sm=size(Mb);
fprintf(['balanced unfolding, best_Lshift = %d, best_modeN = %d,\n  unfolding matrix sized of [',repmat(' %d',1,length(sm)),'].\n'],L,n,sm(:));

Tb = balanced_fold(Mb,L,sz);
stk=size(Tb);
fprintf("balanced folding, Lshift = %d, mode = %d,\n  folding tensor sized of [%d,%d,%d,%d], element in [%d,%d,%d,%d] is %d.\n",L,n,stk(1),stk(2),stk(3),stk(4),idx{1},idx{2},idx{3},idx{4},Tb(idx{:}));
fprintf("  matches the value in original tensor T with error %d ! \n",norm(T(idx{:})-Tb(idx{:})));

