function t=TSVD2tensor(TSVD)
    %convert a TSVDtensor to a tensor.
    t=t_product(TSVD.U,TSVD.S);
    t=t_product(t,trans(TSVD.V));
end