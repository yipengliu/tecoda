function t=TR2tensor(TR)
%convert a TRtensor to a tensor.
N = length(TR.factors);
t = TR.factors{1};
t = tensor(t);
if(length(size(t))==2)
    t = reshape(t,[size(t),1]);
end
% for i = 1:N-2
%     t = tensor_contraction(t,TR.factors{i+1},i+2,1);
% end
for i = 1:N-2
    TR_i = tensor(TR.factors{i+1});
    if(length(size(TR_i))==2)
        TR_i = reshape(TR_i,[size(TR_i),1]);
    end
    t = tensor_contraction(t,TR_i,i+2,1);
end
TR_N = tensor(TR.factors{N});
if(length(size(TR_N))==2)
    TR_N = reshape(TR_N,[size(TR_N),1]);
end
t = tensor_contraction(t,TR_N,[1, N+1],[3, 1]);
t = tensor(t);
end
