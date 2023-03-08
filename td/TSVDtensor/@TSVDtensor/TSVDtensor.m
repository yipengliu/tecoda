classdef TSVDtensor
    properties
        U
        S
        V
    end
    methods
        function TSVD = TSVDtensor(varargin)
            if nargin==1 && (isa(varargin{1},'tensor') || isnumeric(varargin{1}))
                [TSVD.U, TSVD.S, TSVD.V] = t_SVD(varargin{1},'p');
            elseif nargin==2 && (isa(varargin{1},'tensor')|| isnumeric(varargin{1})) && (varargin{2}=='p' || varargin{2}=='f')
                [TSVD.U, TSVD.S, TSVD.V] = t_SVD(varargin{1},varargin{2});
            else
                error("Incorrect input!");
            end
            return;
        end
    end
end