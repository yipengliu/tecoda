function Out = outer_product(varargin)
    % Input:
    %   T1, T2, .... Tensor requiring outer product
    % Output:
    %   Out = outer_product(T1, T2, ...)

    % % test
    % % data = {};
    % % for i = 1 : numel(varargin)
    % %     data = [data varargin{i}];
    % % end

    % error judgement
    % -------------------------------------------
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
           Out = bsxfun(@times, Out(:), T{i}(:).'); 
        end
    %   Reshape
        Out = Out.reshape(cell2mat(cellfun(@(x) size(x), T, 'UniformOutput', false)));
    %     X = reshape(X, cell2mat(cellfun(@(x) size(x), T, 'UniformOutput', false)));
    end
end
