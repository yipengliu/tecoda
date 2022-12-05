function [X,AE]= lr(A,B,para)

% min ||B-AX||_F^2
% min sum_m f_m=sum_i w(i).*||B{m}-A{m}*X||_F^2

% Input:
% A- a N*P predictor or a cell of {A{1},....,A{M}} for M functions
% B- a N*Q response or a cell of {B{1},....,B{M}} for M functions
% para.X0- current estimate
% para.alg - algorithm type, defaulted as 'least square solution'
% para.w - weight vector for different functions, defaulted as [1/M, ..., 1/M]
% para.flag_one_step- indicate the solution required a full solution or a
% one update solution
%
% Output:
%
% X- required weight matrix
% AE-approximate error

if  ~isa(A,'cell')
    A={A};
    B={B};
end
M=length(A);

if ~isfield(para,'w')
    para.w=repmat(1./M,M,1);
end
if ~isfield(para,'alg')
    para.alg='ls';
end
switch para.alg
    case 'gd'
        
        [X,fs]=gd(A,B,para);
        AE=fs(end);
    case 'ls'
        [X,AE]=ls(A,B,para.w);
end
end

function [X,AE]=ls(A,B,w)
% least squares method
% solving problem
% min 0.5*||B-AX||_F^2
% min 0.5*sum_m f_m=0.5*sum_i w(i).*||B{m}-A{m}*X||_F^2

% Input
% A- a N*P predictor or a cell of {A{1},....,A{M}} for M functions
% B- a N*Q response or a cell of {B{1},....,B{M}} for M functions
% w-weight vector for M functions
%
% Output
% X-required weight matrix
% AE-approximate error

if  ~isa(A,'cell')% check if A a cell
    A={A};
    B={B};
end
M=length(A);% the number of functions



% check if size match
for m=1:M
    sa=size(A{m});
    sb=size(B{m});
    if sa(1)~=sb(1)
        error('Matrix size not match !!!!');
    end
end

I1=size(A{1},2);
I2=size(B{1},2);
tmp1=zeros(I1,I1);
tmp2=zeros(I1,I2);

for m=1:M
    tmp1=tmp1+w(m).*A{m}'*A{m};
    tmp2=tmp2+w(m).*A{m}'*B{m};
    
end

X=tmp1\tmp2; % solution

AE=0;
for m=1:M
AE=AE+w(m).*norm(A{m}*X-B{m})^2;% approximate error
end

end