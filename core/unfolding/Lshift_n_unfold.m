function M = Lshift_n_unfold(varargin)
% Lshift_n_unfold unfold a tensor into a matrix of size
% Il...Imod(l+n,N)xImod(l+n+1,N)...I(l-1)
%
%     M = Lshift_n_unfold(T,l,n) first shifts the original tensor T by l
%     and unfolds the tensor along the n-th mode.
%
% Example
%    T = tensor(rand(2,4,6,8));
%    M = Lshift_n_unfold(T,2,4);
    if nargin ~= 3
        error("Incorrect arguments number!")
    end
    if isa(varargin{1},'tensor')
        M = varargin{1}.data;
    elseif isnumeric(varargin{1})
        M = varargin{1};
    else
        error("Input tensor must be tensor class data or high dimension matrix!")
    end
    if isnumeric(varargin{2}) && isnumeric(varargin{3})
        L = varargin{2};
        n = varargin{3};
    else
        error("Please input correct mode vector and original tensor size!")
    end
    sz = size(M);
    ndim = length(sz);

    shift_list = [L:ndim,1:L-1];
    M = permute(M,shift_list);
    M = k_unfold(M,n);
end