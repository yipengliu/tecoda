function Out = khatrirao_product(varargin)
    % Input:
    %   T1, T2, .... Tensor requiring khatrirao product
    %   T1 Size(M1, N)
    %   T2 Size(M2, N)
    %   T3 Size(M3, N)
    %   ......
    % Output:
    %   Out = khatrirao_product(T1, T2, ...)

    if nargin == 0
        error('error data input')
    end
    
    T = {};
    if ischar(varargin{end}) && varargin{end} == 'r'
        for i = 1 : nargin - 1
            T = [T varargin{i}];
        end
        idx = numel(T)-1 : -1 : 1;
        Out = T{end};
    else
        for i = 1 : nargin
            T = [T varargin{i}];
        end
        idx = 2 : 1 : numel(T);
        Out = T{1};
    end
    
    
    N = cellfun(@(x) size(x, 2), T);
    if(~all(N == N(1)))
        error('All data must have the same column dimension.');
    end

    N = N(1);
    if numel(T) ~= 1
        for i = idx
           Out = bsxfun(@times, reshape(T{i}, [], 1, N), reshape(Out, 1, [], N)); 
        end
    end
    Out = reshape(Out, [], N);
    if ~ismatrix(Out)
        Out = tensor(Out);
    end
end

function Size = tensorsize(T)
    if isvector(T)
       Size = numel(T);
    else
        Size = size(T);
    end
end