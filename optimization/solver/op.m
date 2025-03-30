function Q=op(A,B,rho)

%Orthogonal Procrustes Problem

% min sum_i rho{i}* || Q*A{i}-B{i}||_F^2
% subject to Q^T*Q=I


% input :
%
%         A: a cell contains the A{1},.....,A{N} N is the number of
%         objective functions
%         B: a cell contains the B{1},.....,B{N}
%         rho: a cell contains the rho{1},.....,rho{N}

% output
%         Q: a orthogonal matrix

%% check if A is a cell, indicating there is only one objective function or
% multiple ones
if isa(A,'cell')
    N=length(A); % the number of objective functions
else
    N=1;
end

%% solve for one objective function
if N==1
    
    
    sa=size(A);
    sb=size(B);
    if  sa(2)==sb(2) % check the size
        
        temp=B*A';
        [U,S,V]=svd(temp); % perform svd over B*A'
        Q=U*eye(size(S))*V';
        return
        
    else
        error('The size of given A and B do not match !!!');
        
    end
end

%% solve for multiple objective functions

temp=zeros(size(B{1},1),size(A{1},1)); 

for n=1:N
    sa=size(A{n});
    sb=size(B{n});
    if  sa(2)==sb(2) % check the size
        
        temp=temp+rho{n}.*B{n}*A{n}'; % sum of rho{n}.*B{n}*A{n}'
    else
        error('The size of given A and B do not match !!!');
        
    end
end

[U,S,V]=svd(temp); % perform svd over sum of rho{n}.*B{n}*A{n}'
Q=U*eye(size(S))*V';


end

