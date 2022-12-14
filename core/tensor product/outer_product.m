function Out = outer_product(varargin)
    % Input:
    %   T1, T2, .... Tensor requiring outer product
    % Output:
    %   Out = outer_product(T1, T2, ...)

    if nargin == 0
        error('error data input')
    end
    
    T = {};
    for i = 1 : nargin
        T = [T varargin{i}];
    end
    Out = T{1};
    if numel(T) ~= 1
        for i = 2 : numel(T)
           Out = bsxfun(@times, Out(:), T{i}(:).'); 
        end
    %   Reshape
    	Outsize = cell2mat(cellfun(@(x) tensorsize(x), T, 'UniformOutput', false));
        Out = reshape(Out, Outsize(:)');
    end
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
