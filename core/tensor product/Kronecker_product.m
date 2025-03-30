function Out = Kronecker_product(varargin)
    % Input:
    %   T1, T2, .... Tensor requiring Kronecker product
    % Output:
    %   Out = Kronecker_product(T1, T2, ...)

    T = {};
    % Kronecker_product(A,B,'r'):
    %   Reverse order operation——invariant
    if ischar(varargin{end}) && varargin{end} == 'r'
        for i = 1 : nargin - 1
            if ~isa(varargin{i},'tensor')
                T = [T varargin{i}];
            else
                T = [T varargin{i}.data];
            end
        end
        idx = numel(T)-1 : -1 : 1;
        Out = T{end};
    else
        for i = 1 : nargin
            if ~isa(varargin{i},'tensor')
                T = [T varargin{i}];
            else
                T = [T varargin{i}.data];
            end
        end
        idx = 2 : 1 : numel(T);
        Out = T{1};
    end
    

    if numel(T) ~= 1
        for i = idx
            if ndims(Out) ~= ndims(T{i})
                error('error data size')
            end
            tempT = T{i};
            [I, J] = size(Out);
            [K, L] = size(tempT);
            Out = reshape(Out, [1 I 1 J]);
            tempT = reshape(tempT, [K 1 L 1]);
            Out = reshape(bsxfun(@times, Out, tempT),[I*K J*L]);
        end
    end
    
    if isa(varargin{1},'tensor') && ~ismatrix(Out)
        Out = tensor(Out);
    end
end
