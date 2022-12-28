function y = norm_tv(I,varargin)
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
if nargin > 1
    flag = varargin{1};
else
    flag = 0;
end
[dx, dy] = gradient_op(I);

if flag == 0
    tmp = sqrt(abs(dx).^2 + abs(dy).^2);
else
    tmp = abs(dx) + abs(dy);
end

y = reshape(sum(sum(tmp,1),2),[],1);

end