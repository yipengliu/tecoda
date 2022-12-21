function TK = HOOI(X, rank, options)
%   Input:  X:      Tensor in Size(I1, I2, ..., IN)
%           rank:   Multilinear rank(R1, R2, ..., RN)
%   Output: TK:     Tucker class 
    
    if nargin < 3, options = struct; end
    if ~isfield(options, 'MaxIter'), options.MaxIter = 1e3; end
    if ~isfield(options, 'Err'), options.Err = 1e-5; end
    
    TK = HOSVD(X, rank);
%     TK = struct;
%     u = cell(1,3);
%     u{1} = rand(3,2)';
%     u{2} = rand(4,3)';
%     u{3} = rand(5,4)';
%     TK.factors = u;
%     TK.kernel = rand(2,3,4);
    
    for i = 1 : options.MaxIter
        for j = 1 : length(rank)
            y = mode_n_product(X, TK.factors, -j, 'T');
            [u,~,~] = svd(mode_n_unfold(y, j),'econ');
            TK.factors{j} = u(:, 1:rank(j))';
        end
        G = mode_n_product(TK.kernel, TK.factors);
        error = norm(X-G);
%         error = norm(reshape(X, numel(X), 1)-reshape(G, numel(G), 1), inf);
        if error < options.Err, break; end
    end
end