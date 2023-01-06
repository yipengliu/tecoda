function TK = HOOI(X, rank, options)
%   Input:  X:      Tensor in Size(I1, I2, ..., IN)
%           rank:   Multilinear rank(R1, R2, ..., RN)
%   Output: TK:     Tucker class 
    
    if nargin < 3, options = struct; end
    if ~isfield(options, 'MaxIter'), options.MaxIter = 1e3; end
    if ~isfield(options, 'Err'), options.Err = 1e-5; end
    
    TK = HOSVD(X, rank);
    
    for i = 1 : options.MaxIter
        lostcore = TK.core;
        for j = 1 : length(rank)
            y = mode_n_product(X, TK.factors, -j);
            [u,~,~] = svd(mode_n_unfold(y, j),'econ');
            TK.factors{j} = u(:, 1:rank(j));
        end
        TK.core = tensor(mode_n_product(X, TK.factors));
        error = norm(calculate('minus', TK.core, lostcore));
        if error < options.Err, break; end
    end
    TK.core = mode_n_product(X, TK.factors);
end
