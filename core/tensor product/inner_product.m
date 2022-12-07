function Out = inner_product(varargin)
    % Input:
    %   T1, T2 --  Tensor requiring inner product
    % Output:
    %   Out = inner_product(T1, T2, ...)
    if nargin == 0 || ~isa(varargin{1},'tensor')
        error('Input tensor must be tensor class data')
    elseif nargin > 2
        error('error data number') 
    end


    T = {};
    for i = 1 : nargin
        T = [T varargin{i}];
    %   T = [T varargin{i}.data];
    end

    if numel(T) == 2
        if numel(T{1}) ~= numel(T{2})
            error('error data size')
        end
        Out = T{2}(:)' * T{1}(:);
    else
        error('error data number') 
    end
end
