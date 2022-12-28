function [sol,normTv] = prox_tv(b, gamma, varargin)
%PROX_TV Total variation proximal operator
%   Usage:  sol=prox_tv(b, gamma)
%
%   Input parameters:
%         b     : Input signal.
%         gamma : Regularization parameter.
%         varargin: include a flag to choose the type of tv
%   Output parameters
%         sol   : Solution.
%
%   .. math::  sol = arg\min_{z} \frac{1}{2} \|x - z\|_2^2 + \gamma  \|z\|_{TV}
%

% Initializations
flag = 0;
if nargin > 3
    tmp = varargin{1};
    if tmp == 0
        flag = 0;
    elseif tmp == 1
        flag = 1;
    else
        error('wrong tv type specified');
    end
end
[r, s] = gradient_op(b*0);
pold = r; qold = s;
told = 1; prev_obj = 0;
tol=10e-4;
normTv=0;
mt = 1;

% Main iterations

for iter = 1:200

    % Current solution
    sol = b - gamma*div_op(r, s);

    % Objective function value
    tmp = gamma * sum(norm_tv(sol,flag));
    obj = .5*norm(b(:)-sol(:), 2)^2 + tmp;
    rel_obj = abs(obj-prev_obj)/obj;
    prev_obj = obj;


    % Udpate divergence vectors and project
    [dx, dy] = gradient_op(sol);
    
    r = r - 1/(8*gamma)/mt^2 * dx; 
    s = s - 1/(8*gamma)/mt^2 * dy;
    
    weights = max(1, sqrt(abs(r).^2+abs(s).^2));
    
    p = r./weights; 
    q = s./weights;

    % FISTA update
    t = (1+sqrt(4*told.^2))/2;
    r = p + (told-1)/t * (p - pold); pold = p;
    s = q + (told-1)/t * (q - qold); qold = q;
    told = t;

end
end

function I = div_op(dx, dy)
%DIV_OP Divergence operator in 2 dimensions
%   Usage:  I = div_op(dx, dy)
%
%   Input parameters:
%         dx    : Gradient along x
%         dy    : Gradient along y
%
%   Output parameters:
%         I     : Output divergence image 
%
%   Compute the 2-dimensional divergence of an image. If a cube is given,
%   it will compute the divergence of all images in the cube.
%
%   ..      div  = - grad'
%
%   .. math:: \text{div} = - \nabla^*

I = [dx(1, :,:) ; ...
    dx(2:end-1, :,:)-dx(1:end-2, :,:) ;...
    -dx(end-1, :,:)];
I = I + [dy(:, 1,:) ,...
    dy(:, 2:end-1,:)-dy(:, 1:end-2,:) ,...
    -dy(:, end-1,:)];

end
