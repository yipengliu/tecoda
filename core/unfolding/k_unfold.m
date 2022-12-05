function M = k_unfold(varargin)
% mode_k_unfold() unfold a tensor into a tensor of size IkxIR.
%     Note that Ik = I1x..xIk,IR=I(k+1)x...xIN
%
%     TU = k_unfold(T) unfold tensor T into a matrix by arranging the first 
%     mode as row and other modes as column in little-endian order, just
%     like mode_n_unfolding().
%
%     TU = k_unfold(T,k) unfold a tensor into a tensor of size IkxIR.
%     Note that Ik = I1x..xIk,IR=I(k+1)x...xIN
%
% Examples
%   
    % Input must be Tensor class
    if nargin == 0 || ~isa(varargin{1},'tensor')
        error("Input tensor must be tensor class data")
    end
    T = varargin{1};

    if nargin == 1
        modeN = 1;
    elseif nargin == 2 
        if isnumeric(varargin{2}) && varargin{2} == int8(varargin{2}) && min(a)>0 && max(a)<=TU.ndim
            modeN = int8(varargin{2});
        else
            error("Please input correct mode vector(integer between 1 and ndim)!")
        end
    else
        error("Arguments exceed 2!")
    end

    % Litte endian order
    mode_row = prod(1:k);
    mode_col = prod(k+1:T.ndim);

    M = reshape(TU,mode_row,mode_col);
   
end