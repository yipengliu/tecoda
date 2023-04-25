function [U,output] = btd_rnd(size_tens,size_core,varargin)
%BTD_RND Pseudorandom initialization for BTD.
%   U = btd_rnd(size_tens,size_core) generates R pseudorandom terms U{r} to
%   initialize algorithms that compute a block term decomposition of an
%   N-th order tensor. Each term U{r} is a cell array of N unitary factor
%   matrices U{r}{n}, followed by a core tensor U{r}{1} of size
%   size_core{r}.

if ~iscell(size_core), size_core = {size_core}; end
function U = capture(size_core)
    S = tensor('rand',size_core);
    U = cell(1,length(size_tens) + 1);
    U{1} = S;
    for n=2:length(size_tens)+1
        U{n}=rand(size_tens(n-1),size_core(n-1));
    end
end
U = cellfun(@capture,size_core,'UniformOutput',false);
output = struct;

end
