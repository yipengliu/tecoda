function x = prox_l1(x,lambda)

% The proximal operator of the l1 norm
% Input b can be scalar, vector or multidimensional matrix
% 
% objective function: min_x \lambda*||x||_1+0.5*||x-b||_2^2
% 
% Input 
%     b: scalar or vector or matrix
%     lambda: a weight factor balancing the contribution of l1 norm
% Output
%     x: the output shape is the same as b
% 

%x = max(0,x-lambda)+min(0,x+lambda);
 x = sign(x).*max(0,abs(x)-lambda); 

end