%TENSOR Class for dense tensors.
%
%TENSOR Methods:
%   double      - Convert tensor to double array.
%   find        - Find subscripts of nonzero elements in a tensor.
%   ndims       - Return the number of dimensions of a tensor.
%   nnz         - Number of nonzeros for tensors. 
%   norm        - Frobenius norm of a tensor.
%   permute     - Permute tensor dimensions.
%   reshape     - Change tensor size.
%   size        - Tensor dimensions.
%   squeeze     - Remove singleton dimensions from a tensor.
%   tensor      - Create tensor.
%

function t = tensor(varargin)%

%   X = TENSOR(A,SIZ) creates a tensor from the multidimensional
%   array A. The SIZ argument specifies the desired shape of A.
%
%   X = TENSOR(A) creates a tensor from the multidimensional array
%   Z, using SIZ = size(A).
%
%   X = TENSOR(A) converts an  CPtensor, TKensor, or tenunf object
%   to a tensor.  
%

if (nargin == 0)
    t.data = [];
    t.size = [];
    t = class(t, 'tensor');
    return;
end

% Copy 
if (nargin == 1) && isa(varargin{1}, 'tensor')
    v = varargin{1};
    t = tensor;
    t.data = v.data;
    t.size = v.size;
    return;
end
% from cp tensor
if (nargin == 1) && isa(varargin{1}, 'CPtensor')
    v = varargin{1};
    t = cp2tensor(v);
    return;
end
% from tk tensor
if (nargin == 1) && isa(varargin{1}, 'TKtensor')
    v = varargin{1};
    t = tk2tensor(v);
    return;
end
%from tenunf
if (nargin == 1) && isa(varargin{1}, 'tenunf')
    v = varargin{1};
    t = tenunf2tensor(v);
    return;
end

% from multidimensional array
if (nargin <= 2)&& isa(varargin{1},'double')
    data=varargin{1};
    % tensor size
    if nargin == 1
        siz = size(data);
    else
        siz = varargin{2};
        if ~isempty(siz) && ndims(siz) ~= 2 && size(siz,1) ~= 1
            error('Second argument must be a row vector.');
        end
    end

    % Make sure the number of elements matches what's been specified
    if prod(siz) ~= numel(data)
        error('Size of data does not match specified size of tensor');
    end
    

   data = reshape(data,siz);
    
    % Create the tensor
    t.data = data;
    t.size = siz;
    t = class(t, 'tensor');
    return;

end


error('Unsupported use of function TENSOR.');


