function M = mode_n_unfold(varargin)
% mode_n_unfold unfold a tensor into a matrix of size (I1x...xIn)x(In+1x...xIn)
%     M = mode_n_unfolding(T) unfold tensor T into a matrix by arranging the first 
%     mode as row and other modes as column in little-endian order.
%
%     M = mode_n_unfolding(T,m) unfold tensor T into a matrix by arranging 
%     the m-th mode as row and other modes as column in little-endian order.Note
%     that m is integer between 1 and the number of dimension of T.
%
% Examples:
%      T = tensor(rand(4,5,6))
%      M = mode_n_unfolding(T) % Unfold T into matrix of size 4x30 in little-endian order.
%      M = mode_n_unfolding(T,2) % Unfold T into matrix of size 5x24 in little-endian order.

    % default mode:arrange first mode as the row and in little-end order
    if nargin == 0 || ~isa(varargin{1},'tensor')
        error("Input tensor must be tensor class data")
    end
    T = varargin{1};
    if nargin == 1
        mode = 1;
    elseif nargin == 2
        % If input contains mode, it must be an integer between 1 and the number of dimension of T
        if isnumeric(varargin{2}) && varargin{2}>1 && varargin{2} <= T.ndim && varargin{2} == int8(varargin{2})
            mode = int8(varargin{2});
        else
            error("Please input correct mode(integer between 1 and ndim)!")
        end
    else
        error("Arguments exceed 2!")
    end

    % Litte endian order
    mode_col = [T.shape(1:mode-1),T.shape(mode-1:end)]';
    M = permute(T,[mode,mode_col]);
    M = reshape(M,mode,[]);
   
end