function G = TR_ALS(X,options)
%   Input:  X:      Tensor in Size(I1, I2, ..., IN)
%   options:
%           Rmax:   TR-rank threshold
%           Err:    Tolerance error
%           MaxIter:Max Iteration
%   Output: G:      G(n) in Size(Rn, In, Rn+1)
    
    if nargin == 1, options = struct; end
    if ~isfield(options, 'Err'), options.Err = 1e-3; end
    if ~isfield(options, 'MaxIter'), options.MaxIter = 50; end
    if ~isfield(options, 'Rmax'), options.Rmax = 8; end
    
    N = ndims(X);
    I = size(X);
    [G,R] = TR_SVD(X, options);
    R = horzcat(R, R(1));
    B = {};
    Bn = {};
    normX = norm(X);
    for iter = 1 : options.MaxIter
        for i = 1 : N
            if i == N
                B{i} = G.factors{1};
                mIdx = 2:i-1;
            else
                B{i} = G.factors{i+1};
                mIdx = cat(2, i+2:N, 1:i-1);
            end
            for m = mIdx
                B{i} = tensor_contraction(B{i}, G.factors{m}, ndims(B{i}), 1);
            end
            mIdx = size(B{i});
            idx = 1 : N;
            idx(i) = [];
            B{i} = reshape(B{i}, [R(i+1), prod(I(idx)), R(i)]);
            % tensor类的numel 有问题
            Bn{i} = reshape(permute(B{i}, [3,1,2]), [R(i)*R(i+1), numel(B{i}.data)/(R(i)*R(i+1))])';
            
            Gsize = size(G.factors{i});


            XnT = mode_n_unfold(X, i, 'i').';
            temp = reshape(tensor((Bn{i} \ XnT).'),Gsize);
            G.factors{i} = reshape(mode_n_fold(temp,2,Gsize), Gsize);

        end
        % Compute current relative error
        Y = TR2tensor(G);
        error = norm(calculate('minus', X, Y)) / normX;

        if error < options.Err, break; end
    end
    G = TRtensor(G);
end