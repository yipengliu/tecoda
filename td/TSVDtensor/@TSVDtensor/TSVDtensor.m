classdef TSVDtensor
    properties
        size
        U
        S
        V
    end
    methods
        function TSVD = TSVDtensor(varargin)
            if nargin==1 && (isa(varargin{1},'tensor') || isnumeric(varargin{1}))
                [TSVD.U, TSVD.S, TSVD.V] = t_SVD(varargin{1},'p');
                if isa(varargin{1},'tensor')
                    TSVD.size = varargin{1}.size;
                else
                    TSVD.size = size(varargin{1});
                end
            elseif nargin==2 && (isa(varargin{1},'tensor')|| isnumeric(varargin{1})) && (varargin{2}=='p' || varargin{2}=='f')
                [TSVD.U, TSVD.S, TSVD.V] = t_SVD(varargin{1},varargin{2});
                if isa(varargin{1},'tensor')
                    TSVD.size = varargin{1}.size;
                else
                    TSVD.size = size(varargin{1});
                end
            else
                error("Incorrect input!");
            end
            return;
        end
    end
end