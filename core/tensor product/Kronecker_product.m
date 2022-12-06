function Out = Kronecker_product(varargin)
    % Input:
    %   T1, T2, .... Tensor requiring Kronecker product
    % Output:
    %   Out = Kronecker_product(T1, T2, ...)
    if nargin == 0 || ~isa(varargin{1},'tensor')
        error('Input tensor must be tensor class data')
    end
    T = {};
    for i = 1 : nargin
        T = [T varargin{i}];
    %   T = [T varargin{i}.data];
    end
    Out = T{1};
    if numel(T) ~= 1
        for i = 2 : numel(T)
            if numel(Out) ~= numel(T{i})
                error('error data size')
            end
            tempT = T{i};
            Out = Out.reshape([1 I 1 J]);
            tempT = tempT.reshape([K 1 L 1]);
            Out = reshape(bsxfun(@times, Out, tempT),[I*K J*L]);
        end
    end
end
