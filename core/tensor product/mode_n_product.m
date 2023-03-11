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
        tflag = 1;
    else
        Out = T1;
        tflag = 0;
    end
    
    if nargin >= 3 && ischar(varargin{end}) && varargin{end} == 'T'
        for i = 1 : length(T2)
        	T2{i} = T2{i}';
        end
        if nargin > 3
            mode = varargin{1:end-1};
        elseif nargin == 3
            mode = inf;
        end
    else
        if nargin >= 3
            mode = varargin{:};
        end
    end
    
    if (nargin == 2) | (exist('mode','var') & mode == inf)
        idx = 1 : numel(T2);
    else
        if sum(mode > 0) == 0
            idx = 1 : numel(T2);
            idx(abs(mode)) = [];
        elseif sum(mode < 0) == 0
            idx = mode;
        else
            error('Wrong mode input')
        end
    end
    
    Out = mode_product(Out, T2, idx, tflag);
end

function Out = mode_product(Out, T2, idx, tflag)
    for i = 1 : length(idx)
        if length(T2) == length(idx)
            Idx = i;
        elseif length(T2) > length(idx)
            Idx = idx(i);
        end
        L1 = size(Out);
        L2 = size(T2{Idx});
        index1 = 1:ndims(Out);
        index1(idx(i)) = [];
        perm = [index1,idx(i)];
        tempXX = reshape(permute(Out, perm), ([prod(L1(index1)),prod(L1(idx(i)))]));
        temp = tempXX *T2{Idx};
        Out = ipermute(reshape(temp,([L1(index1),L2(2)])), perm);
    end
    if tflag == 1
        Out = reshape(tensor(Out), ([L1(index1),L2(2)]));
    end
end

