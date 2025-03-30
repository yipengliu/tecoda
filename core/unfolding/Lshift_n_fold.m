function T = Lshift_n_fold(varargin)
% Lshift_n_fold fold a Lshift_n_unfold matrix into its original tensor.
%
%     T = Lshift_n_fold(M,l,size) is the inverse operation of M = Lshift_n_fold(T,l,n)
%
% Example
%    T = tensor(rand(2,4,6,8));
%    M = Lshift_n_unfold(T,2,4);
%    T1 = Lshift_n_fold(T,2,T.size);
    if nargin ~= 3
        error("Incorrect arguments number!")
    end
    if isa(varargin{1},'tensor')
        T = varargin{1}.data;
    elseif isnumeric(varargin{1})
        T = varargin{1};
    else
        error("Input tensor must be tensor class data or high dimension matrix!")
    end
    if isnumeric(varargin{2}) && isnumeric(varargin{3})
        L = varargin{2};
        sz = varargin{3};
    else
        error("Please input correct mode vector and original tensor size!")
    end

    ndim = length(sz);
    sz = [sz(L:ndim),sz(1:L-1)];
    T = k_fold(T,sz);
    
    shift_list = [L:ndim,1:L-1];
    T = ipermute(T,shift_list);
end