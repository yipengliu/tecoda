function Out=t_product(varargin)
    % Input:
    %   T1 -- Tensor1 in Size(l, p, n)
    %   T2 -- Tensor2 in Size(p, m, n)
    % Output:
    %   X - the contraction result
    if nargin == 0 || ~isa(varargin{1},'tensor')
        error('Input tensor must be tensor class data')
    elseif nargin > 2
        error('error data number') 
    end
    T = {};
    for i = 1 : nargin
        T = [T varargin{i}];
    end
    if numel(T) ~= 2
        if numel(T) == 1
            Out = T{1};
        else
            error('error data number') 
        end
    else
        T1 = T{1};
        T2 = T{2};
        if T1.size(2) ~= T2.size(1) || T1.size(3) ~= T2.size(3)
           error('Wrond data size') 
        end

        [l, ~, ~] = T1.size;
        [p, m, n] = T2.size;
        Outdim = [l, m, n];

        T1_Unfold = T1.permute([2,1,3]).reshape(p, [])';
        T2_Unfold = T2.permute([2,1,3]).reshape(m, [])';

        T1_bcirc = zeros([l*n, p*n]);
        for i=1:n
            T1_bcirc(:,(1:p)+(i-1)*p)=circshift(T1_Unfold,l*(i-1),1);
        end

        temp = (T1_bcirc * T2_Unfold)';
        Out = temp.reshape(Outdim([2,1,3])).ipermute([2,1,3]);
    end
end
