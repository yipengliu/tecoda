function M = k_unfold(varargin)
% k_unfold() unfold a tensor into a tensor of size IkxIR.
%     Note that Ik = I1x..xIk,IR=I(k+1)x...xIN
%
%     M = k_unfold(T) unfold tensor T into a matrix by arranging the first 
%     mode as row and other modes as column in little-endian order, just
%     like mode_n_unfolding().
%
%     M = k_unfold(T,k) unfold a tensor into a tensor of size IkxIR.
%     Note that Ik = I1x..xIk,IR=I(k+1)x...xIN
%
% Examples
%     T = tensor(rand(2,4,6,8));
%     M = k_unfold(T);
%     M = k_unfold(T,2);

    % Input must be Tensor class
    if nargin == 0
        error("Input tensor must not be empty!")
    end
    if isa(varargin{1},'tensor')
        T = varargin{1}.data;
        sz = varargin{1}.size;
        ndim = length(sz);
    elseif isnumeric(varargin{1})
        T = varargin{1};
        sz = size(T);
        ndim = length(sz);
    else
        error("Input tensor must be tensor class data or high dimension matrix!")
    end



    if nargin == 1
        modeK = 1;
    elseif nargin == 2 
        if isnumeric(varargin{2}) && varargin{2} == int8(varargin{2}) && min(varargin{2})>0 && max(varargin{2})<=ndim
            modeK = int8(varargin{2});
        else
            error("Please input correct mode vector(integer between 1 and ndim)!")
        end
    else
        error("Arguments exceed 2!")
    end

    % Litte endian order
    mode_row = prod(sz(1:modeK));
    mode_col = prod(sz(modeK+1:ndim));

    M = reshape(T,[mode_row,mode_col]);
   
end