function t=TK2tensor(TK)
    %convert a TKtensor to a tensor.
    t = mode_n_product(TK.core,TK.factors,'T');
end