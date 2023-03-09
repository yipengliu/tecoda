function T = trans(A)
%Transpose transpose 3D tensor.
%
%   At = transpose(A) transpose 3D tensor A in size of I1*I2*I3 by
%   transposing frontal slices and then reversing the order of transposed
%   frontal slices from 2 tp I3. Note the transpose only changes the
%   position and is not conjugate transpose for complex number.
%
    if ndims(A)==3
        T=permute(A,[2,1,3]);
        T.data(:,:,2:T.size(3))=T.data(:,:,T.size(3):-1:2);
        return;
    end
    if ndims(A)==2
        T = permute(A,[2,1]);
        T.data = A.data';
        return;
    end
    error('Order of tensor must be 2 or 3!');
end
