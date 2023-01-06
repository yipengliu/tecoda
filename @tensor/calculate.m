function T = calculate(op,A,B)

if ~isa(A,'tensor')||~isa(B,'tensor')
    error('input must be tensor');
else
    count = tensor('zeros',size(A));
    if(op=='add')
        count.data = A.data+B.data;
    end
    if(op=='minus')
        count.data = A.data-B.data;
    end
    T=count;
    return;
end