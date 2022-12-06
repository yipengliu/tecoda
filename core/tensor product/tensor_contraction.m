function Out = tensor_contraction(T1, T2, m, n)
    % Input:
    %   T1 -- Tensor1
    %   T2 -- Tensor2
    %   m - The modes of T1 used to conduct contraction 
    %   n - The modes of T2 used to conduct contraction 
    % Output:
    %   X - the contraction result

    L1 = T1.size;
    L2 = T2.size;
    index1 = 1:T1.ndims;
    index2 = 1:T2.ndims;
    index1(m) = [];
    index2(n) = [];
    tempXX = T1.permute([index1,m]).reshape([prod(L1(index1)),prod(L1(m))]);
    tempYY = T2.permute([n,index2]).reshape([prod(L2(n)),prod(L2(index2))]);
    temp = tempXX * tempYY;

    Out = temp.reshape([L1(index1),L2(index2)]);
end

