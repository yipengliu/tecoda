function Out = mode_n_product(T1, T2, varargin)
    % Input:
    %   T1  --  Tensor requiring mode-n product
    %   T2  --  Martix mode-n product
    %   if ischar(varargin{end}) && varargin{end} == 'T' -- transpose product
    %   mode
    % Output:
    %   Out = mode_n_product(T1, T2, mode)
    
    if ~iscell(T2)
       T2 = {T2}; 
    end
        
    if isa(T1,'tensor')
        Out = T1.data;
    else
        Out = T1;
    end
    if nargin > 2
        if ischar(varargin{end}) && varargin{end} == 'T'
           for i = 1 : length(T2)
              T2{i} = T2{i}';
           end
            mode = varargin{1:end-1};
        else
            mode = varargin{:};
        end
        if ndims(mode) == 1
            idx = mode;
            if mode < 0
                idx = 1 : numel(T2);
                idx(abs(mode)) = [];
            end
        else
            if sum(sum(mode < 0)) == numel(mode)
                idx = 1 : numel(T2);
                idx(abs(mode)) = [];
            elseif sum(sum(mode > 0)) == numel(mode)
                idx = mode;
            else
                error('Wrong mode input')
            end
        end
    else
        idx = 1 : numel(T2);
    end
    
    Out = mode_product(Out, T2, idx);
    if isa(T1,'tensor') && ~ismatrix(Out)
        Out = tensor(Out);
    end
end

function Out = mode_product(Out, T2, idx)
    for i = idx
        L1 = size(Out);
        L2 = size(T2{i});
        index1 = 1:ndims(Out);
        index1(i) = [];
        perm = [index1,i];
        tempXX = reshape(permute(Out, perm), ([prod(L1(index1)),prod(L1(i))]));
        temp = tempXX *T2{i};
        Out = ipermute(reshape(temp,([L1(index1),L2(2)])), perm);
    end
end

