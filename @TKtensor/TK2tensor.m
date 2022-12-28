function t=TK2tensor(TK)
    %convert a TKtensor to a tensor.
    for i=2:length(TK.shape)
        m(i-1)=TK.shape{i}(1);
    end
    t = tensor("zeros",m);
    t = mode_n_product(TK.core,TK.factors);
    t = tensor(t);
end