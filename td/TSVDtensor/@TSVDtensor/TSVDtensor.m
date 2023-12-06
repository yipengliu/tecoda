classdef TSVDtensor
    properties
        U
        S
        V
    end
    methods
        function TSVD = TSVDtensor(varargin)
            if nargin~=3 
                error("Incorrect input!");
            elseif numel(size(varargin{1}))~=3 || numel(size(varargin{2}))~=3 || numel(size(varargin{3})）~=3
                error("Incorrect dimensions of input!");
            elseif size(varargin{1},2)~=size(varargin{2},1) || size(varargin{1},3)~=size(varargin{3},2) || size(varargin{2},2)~=size(varargin{3},2) || size(varargin{2},3)~=size(varargin{3},3)
                error("Incorrect shapes of input!");
            else
                if isa(varargin{1},'tensor')
                    TSVD.U = varargin{1};
                else
                    TSVD.U = tensor(varargin{1});
                end
                if isa(varargin{2},'tensor')
                    TSVD.S = varargin{2};
                else
                    TSVD.S = tensor(varargin{2});
                end
                if isa(varargin{1},'tensor')
                    TSVD.U = varargin{3};
                else
                    TSVD.U = tensor(varargin{3});
                end
            end
            return;
        end
    end
end
