classdef TKtensor
    properties
        core
        factors
        ndims
        shape
    end
    methods
        function TK = TKtensor(varargin)
        %TKtensor is Tucker format tensor(decomposed).
        % TK = TKtensor() creates a empty TKtensor.
        % TK = TKtensor(TK) copy a TKtensor.
        % TK = TKtensor(CORE,F1,F2,...,Fn) use core tensor and factos fn to
        % create a TKtensor.
        % TK = TKtensor(CORE,{F1,F2,...,Fn})use core tensor and a cell to
        % create a TKtensor,the cell contains all factors.
            if (nargin==0)
                TK.core=tensor();
                TK.factors = {};
                TK.ndims = 0;
                TK.shape = [];
                return;
            end
            if(nargin==1&&isa(varargin{1},'TKtensor'))
                TK = varargin{1};
                return ;
            end
            if ~isa(varargin{1},'tensor')
                error('Core must be a tensor.')
            else
                TK.core = varargin{1};
                if isa(varargin{2},'cell')
                    TK.factors = varargin{2};
                else
                    for i = 2:nargin
                        TK.factors{i-1} = varargin{i};
                    end
                end
            end
            
            %check that factors are indeed matrices
            for i = 1:length(TK.factors)
                if ndims(TK.factors{i}) ~=2
                    error('All factors must be matrices.');
                end
            end
            
            %size check
            s_core = size(TK.core);
            if length(s_core)~=length(TK.factors)
                error('Number of factors should match dimensions of the core tensor.')
            end
            
            for i = 1:length(TK.factors)
                if size(TK.factors{i},2) ~=s_core(i)
                    error('Second dimension of factor %d must be equal to %d dimension of the core tensor.',i,i);
                end
            end
            
            TK.ndims = ndims(TK.core);
            shape{1} = s_core;
            for i=1:length(TK.factors)
                shape{i+1}=size(TK.factors{i});
            end
            TK.shape = shape;
            return;
        end
    end
end