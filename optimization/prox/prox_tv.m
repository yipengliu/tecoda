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

[r, s, k] = gradient_op(b*0);
pold = r; qold = s; kold = k; k_flag = k;
told = 1; prev_obj = 0;
tol=10e-4;
normTv=0;
mt = 1;

% Main iterations

for iter = 1:200

    % Current solution
    if k_flag ~= -1
        sol = b - gamma*div_op(r, s, k);
    else
        sol = b - gamma*div_op(r, s);
    end
    

    % Objective function value
    obj = .5*norm(b(:)-sol(:), 2)^2 + gamma * sum(norm_tv(sol,flag));
    rel_obj = abs(obj-prev_obj)/obj;
    prev_obj = obj;
    if rel_obj < tol
        break;
    end

    % Udpate divergence vectors and project
    [dx, dy, dz] = gradient_op(sol);
    if k_flag ~= -1
        r = r - 1/(12*gamma)/mt^2 * dx; 
        s = s - 1/(12*gamma)/mt^2 * dy;
        k = k - 1/(12*gamma)/mt^2 * dz;
        weights = max(1, sqrt(abs(r).^2+abs(s).^2+abs(k).^2));
        o = k./weights;
    else
        r = r - 1/(8*gamma)/mt^2 * dx; 
        s = s - 1/(8*gamma)/mt^2 * dy;
        weights = max(1, sqrt(abs(r).^2+abs(s).^2));
    end

    p = r./weights; 
    q = s./weights;

    % FISTA update
    t = (1+sqrt(4*told.^2))/2;
    r = p + (told-1)/t * (p - pold); pold = p;
    s = q + (told-1)/t * (q - qold); qold = q;
    if k_flag ~= -1
        k = o + (told-1)/t * (o - kold); kold = o;
    end
    told = t;

end
end

function I = div_op(dx, dy, dz)
%DIV_OP Divergence operator in 2 dimensions
%   Usage:  I = div_op(dx, dy,  dz)
%
%   Input parameters:
%         dx    : Gradient along x
%         dy    : Gradient along y
%         dz    : Gradient along z
%
%   Output parameters:
%         I     : Output divergence image 
%
%   Compute the 2(3)-dimensional divergence of an image. If a cube is given,
%   it will compute the divergence of all images in the cube.
%
%   ..      div  = - grad'
%
%   .. math:: \text{div} = - \nabla^*

if nargin > 2
    I = [dx(1, :, :,:) ; dx(2:end-1, :, :,:) - ...
        dx(1:end-2, :, :,:) ; -dx(end-1, :, :,:)];
    I = I + [dy(:, 1, :,:) , dy(:, 2:end-1, :,:) - ...
        dy(:, 1:end-2, :,:) , -dy(:, end-1, :,:)];
    I = I + cat(3, dz(:, :, 1,:) , dz(:, :, 2:end-1,:) - ...
        dz(:, :, 1:end-2,:) , -dz(:, :, end-1,:));
else
    I = [dx(1, :,:) ; ...
        dx(2:end-1, :,:)-dx(1:end-2, :,:) ;...
        -dx(end-1, :,:)];
    I = I + [dy(:, 1,:) ,...
        dy(:, 2:end-1,:)-dy(:, 1:end-2,:) ,...
        -dy(:, end-1,:)];
end

end

