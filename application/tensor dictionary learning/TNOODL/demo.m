% Uncomment the following for a quick test!

addpath(genpath('Functions\'));

n = 100;  
m = 150; 
J = 100;
a = 0.05; 
eta = 20;
b = a; %(beta and alpha)
seed=1;
out_folder = './';

[done] = run_noodl_tens(n, m, J, a, eta, seed, out_folder);

