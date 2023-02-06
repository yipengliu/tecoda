function t=TR2tensor(TR)
    %convert a TRtensor to a tensor.
    N = length(TR.factors);
    t = TR.factors{1};
    for i = 1:N-2
        t = tensor_contraction(t,TR.factors{i+1},ndims(t),1);
    end
    t = tensor_contraction(t,TR.factors{N},[1, ndims(t)],[3, 1]);
    t = tensor(t);
end