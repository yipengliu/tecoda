function X=prox_tk_nuclear_norm(B,lambda,alpha)

% objective function: min lambda*||X||_*+0.5*||X-B||_F^2
% here ||X||_*=\sum_d \alpha_d * ||X_(d)||_* subject to \sum_d \alpha_d=1
% 
% Input 
%     B: a D-th tensor sized of I_1*....*I_D
%     lambda: a weight factor balancing the contribution of nuclear norm
%     term and the approxiamte error
%     alpha: a vector includes weight factors banlancing the contribution of nuclear norm of
%     each mode, the default setting is 1/D for each mode if not assigned
% 
% output
%     X: a low tucker rank approximate for B

% size and order of B
if isa(B,'tensor')
    sizeOfB=B.size;
else
    sizeOfB=size(B);
end
dimension=length(sizeOfB);

% check if alpha exist
if nargin < 3
    alpha=repmat(1/dimension,dimension,1);
end
% check if alpha is a vector
if numel(alpha)==1
    alpha=repmat(alpha,dimension,1);
end
% check if the summation of alpha equals to 1
if sum(alpha)~=1
    alpha=alpha./sum(alpha);
end

X=zeros(sizeOfB);
for d=1:dimension
		Bd_unfold = mode_n_unfold(B, d); % mode n unfolding of B
        gamma=alpha(d)*lambda;
        Xd=prox_nuclear_norm(Bd_unfold,gamma);
        X=X+mode_n_fold(tensor(Xd),d,sizeOfB);
end
X=X./dimension;

end