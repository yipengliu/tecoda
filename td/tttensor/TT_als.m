function TT = TT_als(X,options)
%   Input:  X:      Tensor in Size(I1, I2, ..., IN)
%   options:
%           Rmax:   TT-rank threshold
%           Err:    Tolerance error
%           MaxIter:Max Iteration
%   Output: TT:      TTtensor with all factors in Size(Rn, In, Rn+1)
    
    if nargin == 1, options = struct; end
    if ~isfield(options, 'Err'), options.Err = 1e-3; end
    if ~isfield(options, 'MaxIter'), options.MaxIter = 50; end
    if ~isfield(options, 'Rmax'), options.Rmax = 8; end
    
   
    N = ndims(X);
    I = size(X);
    TT = TT_SVD(X);
    G = TT.factors;
    R = TT.rank;
    B = {};
    Bn = {};
    normX = norm(X);
    for iter = 1 : options.MaxIter
        for i = 1 : N
            if i == N
                B{i} = G{1};
                mIdx = 2:i-1;
            else
                B{i} = G{i+1};
                mIdx = cat(2, i+2:N, 1:i-1);
            end
            for m = mIdx
                B{i} = tensor_contraction(B{i}, G{m}, ndims(B{i}), 1);
            end
            idx = 1 : N;
            idx(i) = [];
            B{i} = reshape(B{i}, [R(i+1), prod(I(idx)), R(i)]);
            Bn{i} = reshape(permute(B{i}, [3,1,2]), [R(i)*R(i+1), tnumel(B{i})/(R(i)*R(i+1))])';
            
            Gsize = size(G{i});
            
            XnT = mode_n_unfold(X, i, 'i').';
            G{i} = reshape(tensor((Bn{i} \ XnT).'),Gsize);
            G{i} = reshape(mode_n_fold(G{i},2,Gsize), Gsize);
        end
        % Compute current relative error
        TT = tttensor(G);
        Y = tt2tensor(TT);
        error = norm(calculate('minus', X, Y)) / normX;
        if error < options.Err, break; end
    end
end
    