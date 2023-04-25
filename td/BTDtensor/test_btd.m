%test_BTD()


clc;
clear;
% the size of origin tensor
size_tens=[10, 11, 12];
size_core={[2, 2, 3],[3, 4, 2],[5 ,6, 4]};
% to generator a random factors and cores U
U=btd_rand(size_tens,size_core);
% rand a new tensor
T=tensor('rand',size_tens);
% execute nls algorithms
U_out=btd_nls(T,U);
% to get the T_out
T_out=btdgen(U_out);
% create a BTD tensor
BTD=BTDtensor(U_out);
% calculate square error
err=norm(T.data(:)-T_out.data(:),'fro');