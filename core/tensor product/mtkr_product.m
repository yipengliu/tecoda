function Out = mtkr_product(X, T, n, varargin)
    % Input:
    %   X Tensor with n-mode unfold
    %   T{1}, T{2}, .... Tensor requiring khatrirao product without n-th
    %   T{1} Size(M1, N)
    %   T{2} Size(M2, N)
    %   T{3} Size(M3, N)
    %   ......
    %   if ischar(varargin{end}) && varargin{end} == 'T' -- transpose product
    % Output:
    %   Out = mtkr_product(X, T, n...)
    if nargin == 0
        error('error data input')
    end
    
    if ~iscell(T)
       T = {T}; 
    end
    
    if nargin > 3 && ischar(varargin{end}) && varargin{end} == 'T'
        for i = 1 : length(T)
        	T{i} = T{i}';
        end
    end
    
    N = ndims(X);
    if N < 2
        error('X is not a valid tensor structure.');
    end
    if N ~= length(T)
        error('Incorrect number of T.');
    end
    if abs(n) > N
       error('Incorrect value of n.') 
    end
    
    if n < 0
       n = N + 1 + n;
    end
    if n == 1
        R = size(T{2}, 2);
    else
        R = size(T{1}, 2);
    end
    for i = 1 : N
       if i == n, continue; end
       if size(X, i) ~= size(T{i}, 1) || size(T{i}, 2) ~= R
          error('Incorrect input format.') 
       end
    end
    
    Out = mode_n_unfold(X, n);
    U = khatrirao_product({T{1:n-1}, T{n+1:end}});
    Out = Out * U;
    
    
    
    
    
    
    