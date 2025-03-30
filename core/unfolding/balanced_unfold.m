function [M,lbest,nbest] = balanced_unfold(varargin)
% balanced_unfold Lshift_n_unfold a tensor into a square matrix as
% approximatively as possible by choosing the suitable shift l and mode n.
%
%     [M,l,n] = Lshift_n_unfold(T) does the function above.
%
% Example
%    T = tensor(rand(2,4,6,8));
%    M = balanced_unfold(T);
%    [M,l,n] = balanced_unfold(T);
    if nargin ~= 1
        error("Incorrect arguments number!")
    end
    if isa(varargin{1},'tensor')
        M = varargin{1}.data;
        sz = varargin{1}.size;
        ndim = length(sz);
    elseif isnumeric(varargin{1})
        M = varargin{1};
        sz = size(M);
        ndim = length(sz);
    else
        error("Input tensor must be tensor class data or high dimension matrix!")
    end
    
    best = sqrt(prod(sz));
    approximation = inf;
    for l = 1:ndim-1
        left = 1;
        for n = 1:ndim-l
            left = left*sz(l+n-1);
            if abs(left-best) < approximation
                lbest = l;
                nbest = n;
                approximation = abs(left-best);
            end
        end
    end
    M = Lshift_n_unfold(M,lbest,nbest);
end

