function Out = tensor_contraction(T1, T2, m, n)
    % Input:
    %   T1 -- Tensor1
    %   T2 -- Tensor2
    %   m - The modes of T1 used to conduct contraction 
    %   n - The modes of T2 used to conduct contraction 
    % Output:
    %   X - the contraction result

    L1 = size(T1);
    L2 = size(T2);
    index1 = 1:length(size(T1));
    index2 = 1:length(size(T2));
    index1(m) = [];
    index2(n) = [];
    tempXX = reshape(permute(T1, [index1,m]), [prod(L1(index1)),prod(L1(m))]);
    tempYY = reshape(permute(T2, [n,index2]), [prod(L2(n)),prod(L2(index2))]);
    temp = tempXX.data * tempYY.data;

    Out = reshape(temp, [L1(index1),L2(index2)]);
    
    if isa(T1,'tensor') && ~ismatrix(Out)
        Out = tensor(Out);
    end
end

