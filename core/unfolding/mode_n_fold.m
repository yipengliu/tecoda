function T = mode_n_fold(varargin)
% mode_n_fold fold a matrix into a tensor
%     T = mode_n_fold(M,mode,size) fold the mode_n_unfold matrix M into
%     original tensor. It's the inverse operation of M = mode_n_unfold(T,mode).
%
%     T = mode_n_fold(M,mode,size,order) is the same above expect the order
%     can be assigned by "n" for normal order or "i" for inverse order. 
%     It's the inverse operation of M = mode_n_unfold(T,mode,order).
%
% Examples:
%      T = tensor(rand(4,5,6));
%      M = mode_n_unfold(T,2); % Unfold T into matrix of size 5x24 in little-endian order.
%      T1 = mode_n_fold(M,2,T.size);
    if nargin < 3 || nargin > 4
        error("Incorrect input arguments number!")
    elseif nargin == 3
        order = 'n';
    else 
        if varargin{4} == 'n' || varargin{4} == 'i'
            order = varargin{4};
        else
            error("Order must be 'n' or 'i'!")
        end
    end
    if isa(varargin{1},'tensor')
        T = varargin{1}.data;
    elseif isnumeric(varargin{1})
        T = varargin{1};
    else
        error("Input tensor must be tensor class data or matrix!")
    end
    if isnumeric(varargin{2}) && isnumeric(varargin{3})
        mode = varargin{2};
        sz = varargin{3};
    else
        error("Mode or size must be numeric!")
    end

    if order == 'n'
        mode_list = [sz(mode),sz(1:mode-1),sz(mode+1:end)];
        T = reshape(T,mode_list);
        permute_list = [mode,1:mode-1,mode+1:length(sz)];
        T = ipermute(T,permute_list);
    else
        mode_list = [sz(mode),sz(mode+1:end),sz(1:mode-1)];
        T = reshape(T,mode_list);
        permute_list = [mode,mode+1:length(sz),1:mode-1];
        T = ipermute(T,permute_list);
    end
    % T = tensor(T);
end