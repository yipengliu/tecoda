function T = calculate(op,A,B)

if ~isa(A,'tensor')||~isa(B,'tensor')
    error('input must be tensor');
else
    count = tensor('zeros',size(A));
    switch op
        case 'add'
            count.data = A.data+B.data;
        case 'minus'
            count.data = A.data-B.data;
        otherwise
            error('The given operation is not supported !!! please use add or minus');
    end
    T=count;
    return;
end
