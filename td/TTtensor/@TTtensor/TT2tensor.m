function T = tt2tensor(TT)
%convert a tttensor to a tensor
    N =length(TT.factors);
    T = TT.factors{1};
    T = tensor(T);
    if(length(size(T))==2)
        T = reshape(T,[size(T),1]);
    end
    % for i = 1:N-1
    %     T = tensor_contraction(T,TT.factors{i+1},i+2,1);
    % end
    for i = 1:N-1
        T_i = tensor(TT.factors{i+1});
        if(length(size(T_i))==2)
            T_i = reshape(T_i,[size(T_i),1]);
        end
        T = tensor_contraction(T,T_i,i+2,1);
    end
    T = squeeze(T);