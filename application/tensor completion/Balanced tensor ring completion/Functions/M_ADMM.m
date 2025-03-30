function [X,Z,fval,gval]=M_ADMM(X,P,varargin)
% set default parameters
opt=propertylist2struct(varargin{:});
opt=set_defaults(opt,'eta',[],'lambda',0,'tol',1e-6,'solver',@matrix_adm);
% initialization
sz=size(X);
nd=ndims(X);
ind=find(P);
yy=X(ind);
X=reshape(X,prod(sz(1:floor(nd/2))),[]);
[I1,I2]=ind2sub(size(X),ind);
% matrix completion subroutine
[X,Z,~,fval,gval]=opt.solver(X, {I1, I2}, yy, opt.lambda, opt);
end