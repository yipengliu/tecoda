function Out = cores2tr(G)
N = length(G);
Out = G{1};
for i = 1:N-2
    Out = tensor_contraction(Out,G{i+1},ndims(Out),1);
end
Out = tensor_contraction(Out,G{N},[1, ndims(Out)],[3, 1]);
Out = tensor(Out);