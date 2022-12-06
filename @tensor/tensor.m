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

classdef tensor
    properties
        data
        size
    end

    
    methods
        function t = tensor(varargin)%

        %   X = TENSOR(A,SIZ) creates a tensor from the multidimensional
        %   array A. The SIZ argument specifies the desired shape of A.
        %   X = TENSOR(A) creates a tensor from the multidimensional array
        %   Z, using SIZ = size(A).
        %   X = TENSOR(A) converts an  CPtensor, TKensor, or tenunf object
        %   to a tensor.  
        %   X = TENSOR("zeros",SIZ) creates a zero tensor
        %   X = TENSOR("ones",SIZ) creates a one tensor
        %   X = TENSOR("rand",SIZ) creates a random tensor
        %   X = TENSOR("iden",SIZ) creates a identity tensor.A identity
        %   tensor must be a three-dimension tensor.The size of first two
        %   dimensions must be the same.
        %   X = TENSOR("diag",V) creates a diagonal tensor.The elements of
        %   V are placed on the superdiagonal of the tensor.
        %   X = TENSOR("fdiag",M) creates a f_diagonal tensor.Each row of 
        %   the matrix M will be placed on the diagonal of the frontal slice 
        %   of the tensor

        if (nargin == 0)
            t.data = [];
            t.size = [];
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
        data = reshape(data,[siz 1 1]);
    % Create the tensor
            t.data = data;
            t.size = siz;
            return;
        end
        
% zero/one/diag/rand/identify/f_diag tensor
        if(nargin==2)&&isa(varargin{1},'string')
            siz = varargin{2};
            if ~isempty(siz) && ndims(siz) ~= 2 && size(siz,1) ~= 1
                error('Second argument must be a row vector.');
            end
            %zero tensor
            if(varargin{1}=="zeros")
                data = zeros(siz);
            end
            %one tensor
            if(varargin{1}=="ones")
                data = ones(siz);
            end
            %rand tensor
            if(varargin{1}=="rand")
                data = rand(siz);
            end
            %iden tensor
            if(varargin{1}=="iden")
                if(length(siz)>3)
                    error('Size of identity tensor must be three');
                end
                if(siz(1)~=siz(2))
                    error('First two arguments of size must be the same');
                end
                data = zeros(siz);
                identity = eye(siz(1));
                data(:,:,1)= identity;
            end
            %diag tensor
            if(varargin{1}=="diag")
                v = varargin{2};
                N = numel(v);
                siz = repmat(N,1,N);
                data = zeros(siz);
                subs = repmat((1:N)',1,length(siz));
                ind = tt_sub2ind(siz,subs);
                data(ind) = v;
            end
            %f_diag tensor
            if(varargin{1}=="fdiag")
                mat = varargin{2};
                if(ndims(mat)~=2)
                    error('Second argument must be a matrix');
                end
                siz = size(mat);
                dim_12 = siz(2);
                dim_3 = siz(1);
                data = zeros(dim_12,dim_12,dim_3);
                for i = 1:dim_3
                    data(:,:,i)=diag(mat(i,:));
                end
             end
            t.data = data;
            t.size = siz;
            return;
        end
        error('Unsupported use of function TENSOR.');
        end
        end
end


