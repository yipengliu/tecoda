classdef TKtensor
    properties
        core
        factors
        size
        rank
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
                TK.size = [];
                TK.rank = [];
                return;
            end
            if(nargin==1&&isa(varargin{1},'TKtensor'))
                TK = varargin{1};
                return ;
            end
            if ~isa(varargin{1},'tensor')&&~isa(varargin{1},'double')
                error('Core must be a tensor or a double array.');
            else
                TK.core = tensor(varargin{1});
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
            
            siz = zeros(1,length(TK.factors));
            for i=1:length(TK.factors)
                siz(i)= size(TK.factors{i},1);
            end
            TK.size = siz;
            TK.rank = size(TK.core);
            return;
        end
    end
end
