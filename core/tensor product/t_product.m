function Out=t_product(varargin)
% Input:
%   T1 -- Tensor1 in Size(l, p, n)
%   T2 -- Tensor2 in Size(p, m, n)
% Output:
%   X - fold(bcirc(T1)*unfold(T2))
if nargin == 0
    error('Input tensor must be tensor class data')
elseif nargin > 2
    error('error data number')
end

tflag = 0;
if isa(varargin{1},'tensor')
    tflag = 1;
    T = {};
    for i = 1 : nargin
        T = [T varargin{i}.data];
    end
end
if isa(varargin{1},'double')
    T =varargin;
end

if numel(T) ~= 2
    if numel(T) == 1
        Out = T{1};
    else
        error('error data number')
    end
else
    T1 = T{1};
    T2 = T{2};
    if size(T1, 2) ~= size(T2, 1) || size(T1, 3) ~= size(T2, 3)
        error('Wrond data size')
    end
    
    [l, ~, ~] = size(T1);
    [p, m, n] = size(T2);
    Outdim = [l, m, n];
    
    T1_Unfold = reshape(permute(T1, [2,1,3]), p, [])';
    T2_Unfold = reshape(permute(T2, [2,1,3]), m, [])';
    
    T1_bcirc = zeros([l*n, p*n]);
    for i=1:n
        T1_bcirc(:,(1:p)+(i-1)*p)=circshift(T1_Unfold,l*(i-1),1);
    end
    
    temp = (T1_bcirc * T2_Unfold)';
    Out = ipermute(reshape(temp, Outdim([2,1,3])), [2,1,3]);
end
if ~ismatrix(Out) && tflag == 1
    Out = tensor(Out);
end
end
