% create test input examples
matrix1=rand(3,5);
matrix2=rand(5,3);
vec1=rand(4,1);
vec2=rand(1,4);
tensor1=rand(4,3,5);
tensor2=rand(4,4,4);


%% prox_l1
%{
x1=prox_l1(matrix1,0.22);
x2=prox_l1(matrix2,0.22);
x3=prox_l1(matrix1,rand(size(matrix1)));
x4=prox_l1(0.55,0.23);
x5=prox_l1(tensor1,0.25);
%}
%% prox_l21
%{
x1=prox_l21(matrix1,0.22);
x2=prox_l21(matrix2,0.22);
%}
%% prox_nuclear_norm
%{
y1=prox_nuclear_norm(matrix1,0.34);
y2=prox_nuclear_norm(matrix2,0.34);
y3=prox_nuclear_norm(tensor1,0.34);
%}
%% prox_tensor_nuclear_norm
%{
t1=prox_tensor_nuclear_norm(tensor1,0.26);
%}
%% prox_tk_nuclear_norm
%{
tk1=prox_tk_nuclear_norm(tensor1,0.24,0.5);
%}
%% prox_tv

%% norm