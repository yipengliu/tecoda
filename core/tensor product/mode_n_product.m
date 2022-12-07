function Out = mode_n_product(T1, T2, mode)
    % Input:
    %   T1  --  Tensor requiring mode-n product
    %   T2  --  Martix mode-n product
    %   mode
    % Output:
    %   Out = mode_n_product(T1, T2, mode)


    %  error
    if mode < 0 || mode > T1.ndims
        error('Wrong mode')
    end

    if T1.size(mode) ~= size(T2, 2)
        if T1.size(mode) == size(T2, 1)
           T2 = T2';
           warning('Matrix needs to be transposed.')
        else
           error('Wrong data')
        end
    end

    L1 = T1.size;
    L2 = size(T2);
    N = T1.ndims;
    index1 = 1:N;
    index1(mode) = [];
    perm = [index1,mode];
    tempXX = T1.permute(perm).reshape([prod(L1(index1)),prod(L1(mode))]);
    temp = tempXX *T2';
    Out = temp.reshape([L1(index1),L2(1)]).ipermute(perm);
    % iperm(perm) = 1:N;
    % X = temp.reshape([L1(index1),L2(1)]).permute(iperm);
end

