function T = balanced_fold(varargin)
% balanced_fold() fold a balanced_unfold matrix into its original tensor.
%
%     T = balanced_fold(M,l,n) is the inverse operation of [M,l,n] = balanced_unfold(T)
%
% Examples
%    T = tensor(rand(2,4,6,8));
%    [M,l,n] = balanced_unfold(T);
%    T1 = balanced_fold(M,l,T.size);

    T = Lshift_n_fold(varargin{:});
end