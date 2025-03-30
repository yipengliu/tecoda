function G = TT_als(X,options)
%   Input:  X:      Tensor in Size(I1, I2, ..., IN)
%   options:
%           Rmax:   TT-rank threshold
%           Err:    Tolerance error
%           MaxIter:Max Iteration
%   Output: TT:      TTtensor with all factors in Size(Rn, In, Rn+1)

if nargin == 1, options = struct; end
if ~isfield(options, 'Err'), options.Err = 1e-3; end
if ~isfield(options, 'MaxIter'), options.MaxIter = 50; end
if ~isfield(options, 'maxR'), options.maxR = 10; end
if ~isfield(options, 'initialization'), options.initialization = 'svd'; end


N = ndims(X);
I = size(X);
switch options.initialization
    case 'svd'
        G = SSVD(X, options.maxR);
    case 'rand'
        G=cell(1,d);
        for k=1:N
            if k==N
                G{k}=randn(r(k),dim(k),r(1));
            else
                G{k}=randn(r(k),dim(k),r(k+1));
            end
        end
end


G = TTtensor(G);
R=G.rank;
B = cell(N,1);
Bn =  cell(N,1);
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
        
        B{i} = tensor(B{i});
        if(length(size(B{i}))==2)
            B{i} = reshape(B{i},[size(B{i}),1]);
        end

        k=0;
        for m = mIdx
            k=k+1;
            G_m = tensor(G.factors{m});
            if(length(size(G_m))==2)
                G_m = reshape(G_m,[size(G_m),1]);
            end
            B{i} = tensor_contraction(B{i}, G_m, k+2, 1);
        end
        idx = 1 : N;
        idx(i) = [];
        B{i} = reshape(B{i}, [R(i+1), prod(I(idx)), R(i)]);
        Bn{i} = reshape(permute(B{i}, [3,1,2]), [R(i)*R(i+1), tnumel(B{i})/(R(i)*R(i+1))])';
        
        Gsize = size(G.factors{i});
        
        XnT = mode_n_unfold(X, i, 'i').';
        G.factors{i} = reshape(tensor((Bn{i} \ XnT).'),Gsize);
        G.factors{i} = reshape(mode_n_fold(G.factors{i},2,Gsize), Gsize);
    end
    % Compute current relative error
    Y = TT2tensor(G);
    error = norm(calculate('minus', X, Y)) / normX;
    if error < options.Err, break; end
end
end
