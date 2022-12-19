function T = mode_n1n2_fold(varargin)
% mode_n1n2_fold fold the mode_n_unfold tensor TU into its original tensor. 
%
%     T = mode_n1n2_fold(TU,n,size) is the inverse operation of TU =
%     mode_n1n2_unfold(T,n).n=[n1,n2...nn] is the original unfolding mode
%     vector.
%
%     T = mode_n1n2_fold(TU,n1,...,nn,size) is the inverse operation of TU = mode_n1n2_unfold(T,n1,n2...nn).
%
% Examples
%         T = tensor(rand(2,4,6,8));
%         MT = mode_n1n2_unfold(T,[3,2]);
%         T1 = mode_n1n2_unfold(T,[3,2],T.size);
%         MT = mode_n1n2_unfold(T,3,2);
%         T2 = mode_n1n2_unfold(T,3,2,T.size);

    % Input must be Tensor class
    if nargin < 3
        error("Input arguments are missing!")
    end
    if isa(varargin{1},'tensor')
        T = varargin{1}.data;
    elseif isnumeric(varargin{1})
        T = varargin{1};
    else
        error("Input tensor must be tensor class data or high dimension matrix!")
    end
    if nargin == 3 
        if isnumeric(varargin{2}) && isnumeric(varargin{3})
            modeN = int8(varargin{2});
            sz = int8(varargin{3});
        else
            error("Please input correct mode vector and original tensor size!")
        end
    else
        % nargin >= 4
        if isnumeric([varargin{2:end-1}]) && isnumeric(varargin{end})
            modeN = int8([varargin{2:end-1}]);
            sz = int8(varargin{end});
        else
            error("Please input correct mode vector and original tensor size!")
        end
    end
    ndim = length(sz);
    idx = true(ndim,1);
    idx(modeN) = false;
    modeR = 1:ndim;
    modeR = modeR(idx);
    modeList = [sz(modeN),sz(modeR)];
    T = reshape(T,modeList);
    
    permute_list = [modeN,modeR];
    T = ipermute(T,permute_list);
    T = tensor(T);
end
    
