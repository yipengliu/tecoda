function t=BTD2tensor(BTD)
    %convert a BTDtensor to a tensor.
    t=tensor('zeros',BTD.size);
    for r=1:BTD.rank
        t = calculate('add', t, mode_n_product(BTD.cores{r},BTD.factors{r},'T'));
    end
end
