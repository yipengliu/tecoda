function T = tt2tensor(TT)
%convert a tttensor to a tensor
    N =length(TT.factors);
    T = TT.factors{1};
    for i = 1:N-1
        T = tensor_contraction(T,TT.factors{i+1},ndims(T),1);
    end
    T = squeeze(T);