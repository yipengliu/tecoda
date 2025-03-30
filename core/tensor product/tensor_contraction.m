function Out = tensor_contraction(T1, T2, m, n)
    % Input:
    %   T1 -- Tensor1
    %   T2 -- Tensor2
    %   m - The modes of T1 used to conduct contraction 
    %   n - The modes of T2 used to conduct contraction 
    % Output:
    %   X - the contraction result
    if ~isa(T1,'tensor')
        t1 = tensor(T1);
    else
        t1 = T1;
    end
    if ~isa(T2,'tensor')
        t2 = tensor(T2);
    else
        t2 = T2;
    end
        
    L1 = size(t1);
    L2 = size(t2);
    index1 = 1:length(size(t1));
    % index1 = 1:max(m,length(size(t1)));
    index2 = 1:length(size(t2));
    % index2 = 1:max(n,length(size(t2)));
    index1(m) = [];
    index2(n) = [];
    tempXX = reshape(permute(t1, [index1,m]), [prod(L1(index1)),prod(L1(m))]);
    tempYY = reshape(permute(t2, [n,index2]), [prod(L2(n)),prod(L2(index2))]);
    
    % temp = tenmat(tempXX,1) * tenmat(tempYY,1);
    temp = tempXX * tempYY;

    Out = reshape(tensor(temp), [L1(index1),L2(index2)]);
    
    if (~isa(t1,'tensor') && ~isa(t2,'tensor')) && ismatrix(Out)
        Out = Out.data;
    end
end

