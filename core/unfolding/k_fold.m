function T = k_fold(varargin)
% k_fold() fold a k_unfold matrix into its original tensor.
%
%     T = k_fold(M,size) is the inverse operation of M = k_unfold(T,k)
%
% Examples
%     T = tensor(rand(2,4,6,8));
%     M = k_unfold(T,2);
%     T1 = k_fold(M,T.size)

    if nargin ~= 2
        error("Incorrect input arguments number!")
    end
    if isa(varargin{1},'tensor')
        T = varargin{1}.data;
    elseif isnumeric(varargin{1})
        T = varargin{1};
    else
        error("Input tensor must be tensor class data or matrix!")
    end
    if isnumeric(varargin{2})
        sz = varargin{2};
    else
        error("Mode or size must be numeric!")
    end

    T = reshape(T,sz);
    T = tensor(T);
end