function [U ,S, V, sv, AE] = SVT(A, tol)
%SVT Truncated SVD decomposition.
%
%	[U S V sv error] = SVT(A)
%	[U S V sv error] = SVT(A, tau)
%
%   input:
%	A    - matrix
%	tol  - tolerance, only singular values > tol are kept (default: eps)
%
%   output:
%	U    - truncated left singular vectors
%	S   - truncated singular values
%	V   - truncated right singular vectors
%	sv  - sum of  truncated singular values
%   AE - approximate error
%
%	eg. 	[U S V sv error] = SVT(rand(6,7), 0.5)
%
%	

if nargin == 1
	tol = eps; % default setting for tol if not assigned
end

[U,S,V] = svd(A, 'econ'); % svd for A

sv=zeros(min(size(S)),1);
 for i=1:min(size(S))
         sv(i)= prox_l1(S(i,i),tol); % soft threholding for each singular value
 end
 r=sum(sv>0); % truncated rank
if r==0
    error('The defined tolerance is bigger than all singular values !!!!');
else
    U=U(:,1:r);
    V=V(:,1:r);
    S=diag(sv(1:r));
end
sv=sum(sv);% sum of singular values
AE=norm(A-U*S*V'); % approximate error
end


      
