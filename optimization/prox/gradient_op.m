function [dx, dy, dz] = gradient_op(I)
%GRADIENT_OP 2 Dimensional gradient operator
%   Usage:  [dx, dy, dz] = gradient_op(I)
%
%   Input parameters:
%         I     : Input data 
%
%   Output parameters:
%         dx    : Gradient along x
%         dy    : Gradient along y
%         dz    : Gradient along z
%
%   Compute the 2(3)-dimensional gradient of I. If the input I is a cube.

if ndims(I) <= 2
    dx = [I(2:end, :,:)-I(1:end-1, :,:) ; zeros(1, size(I, 2),size(I, 3))];
    dy = [I(:, 2:end,:)-I(:, 1:end-1,:) , zeros(size(I, 1), 1,size(I, 3))];
    dz = -1;
else
    dx = [I(2:end, :, :,:)-I(1:end-1, :, :,:) ;...
      zeros(1, size(I, 2), size(I, 3),size(I, 4))];
    dy = [I(:, 2:end, :,:)-I(:, 1:end-1, :,:) , ...
        zeros(size(I, 1), 1, size(I, 3),size(I, 4))];
    dz = cat(3, I(:, :, 2:end,:)-I(:, :, 1:end-1,:) , ...
        zeros(size(I, 1),size(I, 2), 1,size(I, 4)));
end


end