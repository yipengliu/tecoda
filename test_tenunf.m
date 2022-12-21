%test_cp()
%   test cpclass
clear
clc
T = rand(5,30,56,6,7,8);
sz = size(T);
idx = {2,3,4,5,6,7};
Ti = T(idx{:});
% test tensor class input
% T = tensor(rand(5,30,56,6,7,8));
% sz = T.size;
tenunf1 = tenunf();

%% test mode_k_unfold()
disp('%%%%%%test k_unfold()%%%%%');
% test k_unfold(T)
Mk = tenunf1.ten2unf('k',T);
Mki = Mk(2,3+(4-1)*30+(5-1)*30*56+(6-1)*30*56*6+(7-1)*30*56*6*7);
Tk = tenunf1.unf2ten('k',T,sz);
Tki = Tk(idx{:});
fprintf("Ti=%d,Mki=%d,Tki=%d in %d_unfolding.\n",Ti,Mki,Tki,1);
% test k_unfold(T,k)
modeK = 2;
Mk = tenunf1.ten2unf('k',T,modeK);
Mki = Mk(2+(3-1)*5,4+(5-1)*56+(6-1)*56*6+(7-1)*56*6*7);
Tk = tenunf1.unf2ten('k',T,sz);
Tki = Tk(idx{:});
fprintf("Ti=%d,Mki=%d,Tki=%d in %d_unfolding.\n",Ti,Mki,Tki,modeK);
disp("----------------------------------------------------------------------------------------------");

%% test mode_n_unfold()
disp('%%%%%%%%test mode_n_unfold%%%%%%%%');
% test mode_n_unfold(T)
Mn = tenunf1.ten2unf('n',T);
Mni = Mn(2,3+(4-1)*30+(5-1)*30*56+(6-1)*30*56*6+(7-1)*30*56*6*7);
Tn = tenunf1.unf2ten('n',T,1,sz);
Tni = Tn(idx{:});
fprintf("Ti=%d,Mni=%d,Tni=%d in mode_%d_unfolding.\n",Ti,Mni,Tni,1);
%test mode_n_unfold(T,mode)
modeN = 2;
Mn = tenunf1.ten2unf('n',T,modeN);
Mni = Mn(3,2+(4-1)*5+(5-1)*5*56+(6-1)*5*56*6+(7-1)*5*56*6*7);
Tn = tenunf1.unf2ten('n',Mn,modeN,sz);
Tni = Tn(idx{:});
fprintf("Ti=%d,Mni=%d,Tni=%d in mode_%d_unfolding.\n",Ti,Mni,Tni,modeN);
%test mode_n_unfold(T,mode,order)
modeN = 2;
order = 'i';
Mn = tenunf1.ten2unf('n',T,modeN,order);
Mni = Mn(3,4+(5-1)*56+(6-1)*56*6+(7-1)*56*6*7+(2-1)*56*6*7*8);
Tn = tenunf1.unf2ten('n',Mn,modeN,sz,order);
Tni = Tn(idx{:});
fprintf("Ti=%d,Mni=%d,Tni=%d in mode_%d_unfolding.\n",Ti,Mni,Tni,modeN);
disp("----------------------------------------------------------------------------------------------");

%% test mode_n1n2_unfold()
disp('%%%%%%%%test mode_n1n2_unfold%%%%%%%%');
% test mode_n1n2_unfold(T),just the same to mode_n1_unfold(T,1)
Mn1n2 = tenunf1.ten2unf('n1n2',T);
Mn1n2i = Mn1n2(2,3+(4-1)*30+(5-1)*30*56+(6-1)*30*56*6+(7-1)*30*56*6*7);
Tn1n2 = tenunf1.unf2ten('n',Mn1n2,1,sz);
Tn1n2i = Tn1n2(idx{:});
fprintf("Ti=%d,Mn1n2i=%d,Tni=%d in mode_%d_unfolding.\n",Ti,Mn1n2i,Tn1n2i,1);
% test mode_n1n2_unfold(T,n)
n=[4,2];
Mn1n2 = tenunf1.ten2unf('n1n2',T,n);
Mn1n2i = Mn1n2(5,3,2+(4-1)*5+(6-1)*5*56+(7-1)*5*56*7);
Tn1n2 = tenunf1.unf2ten('n1n2',Mn1n2,n,sz);
Tn1n2i = Tn1n2(idx{:});
fprintf("Ti=%d,Mn1n2i=%d,Tni=%d in mode_%d_%d_unfolding.\n",Ti,Mn1n2i,Tn1n2i,n(1),n(2));
% test mode_n1n2_unfold(T,n1,n2,...,nn)
n=[4,2];
Mn1n2 = tenunf1.ten2unf('n1n2',T,n(1),n(2));
Mn1n2i = Mn1n2(5,3,2+(4-1)*5+(6-1)*5*56+(7-1)*5*56*7);
Tn1n2 = tenunf1.unf2ten('n1n2',Mn1n2,n(1),n(2),sz);
Tn1n2i = Tn1n2(idx{:});
fprintf("Ti=%d,Mn1n2i=%d,Tni=%d in mode_%d_%d_unfolding.\n",Ti,Mn1n2i,Tn1n2i,n(1),n(2));
disp("----------------------------------------------------------------------------------------------");

%% test Lshift_n_unfold()
disp('%%%%%%test Lshift_n_unfold()%%%%%');
L = 4;
n=2;
MLn = tenunf1.ten2unf('Ln',T,L,n);
MLni = MLn(5+(6-1)*6,7+(2-1)*8+(3-1)*8*5+(4-1)*8*5*30);
TLn = tenunf1.unf2ten('Ln',MLn,L,sz);
TLni = TLn(idx{:});
fprintf("Ti=%d,MLni=%d,TLni=%d in %dshift_mode%d_unfolding.\n",Ti,MLni,TLni,L,n);
disp("----------------------------------------------------------------------------------------------");

%% test balanced_unfold()
disp('%%%%%%test balanced_unfold()%%%%%');
[Mb,L,n] = tenunf1.ten2unf('b',T);
fprintf("Lbest = %d, nbest = %d.\n",L,n);
Tb = tenunf1.unf2ten('b',Mb,L,sz);
Tbi = Tb(idx{:});
fprintf("Ti=%d,Tbi=%d.\n",Ti,Tbi);
disp("----------------------------------------------------------------------------------------------");
