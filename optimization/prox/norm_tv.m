function y = norm_tv(I)
%NORM_TV 2 Dimentional TV norm
%   Usage:  y = norm_tv(x);
%
%   Input parameters:
%         I     : Input data 
%   Output parameters:
%         y     : Norm
%
%   Compute the 2-dimentional TV norm of I. If the input I is a cube. This
%   function will compute the norm of all image and return a vector of norms.
%

[dx, dy] = gradient_op(I);
 
tmp = sqrt(abs(dx).^2 + abs(dy).^2);

y = reshape(sum(sum(tmp,1),2),[],1);

end