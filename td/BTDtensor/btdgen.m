function T = btdgen(U)
%BTDGEN Generate full tensor given a BTD.
%   T = btdgen(U) computes the tensor T as the sum of the R block terms

N = length(U{1})-1;
if nargin == 1
    T = mode_n_product(U{1}{1},U{1}(2:N+1),'T');
    for r = 2:length(U)
        T = calculate('add',T,mode_n_product(U{r}{1},U{r}(2:N+1),'T'));
    end
else 
    error('btdgen:index', ...
          'Either linear or subscripts indices should be provided');    
end
