classdef TTtensor
    properties
        factors
        size
        rank
    end
    
    methods
        %tttensor()is Tensor Train format tensor(decomposed).
        % TT = tttensor() creates a empty tttensor.
        % TT = tttensor(TT) copy a tttensor.
        % TT = TTtensor(F1,F2,...,Fn) use factors fn to
        % create a tttensor.
        % TT = TTtensor({F1,F2,...,Fn})use a cell to
        % create a tttensor,the cell contains all factors.
        function TT = TTtensor(varargin)
            if(nargin==0)
                TT.factors = {};
                TT.rank = 0;
                TT.size = 0;
                return;
            end
            if(nargin==1&&isa(varargin{1},'TTtensor'))
                TT = varargin{1};
                return;
            end
            if(nargin==1&&isa(varargin{1},'cell'))
                TT.factors = varargin{1};
            end
            if(nargin>1)
                for i = 1:nargin
                    TT.factors{i} = varargin{i};
                end
            end
            
            %size check
            Ranks = [];
            Size_t = {};
            N = length(TT.factors);
            szs = {};
            for i = 1:N
                sz = size(TT.factors{i});
                szs{i} = sz;
                if ~isa(TT.factors{i},'tensor')&&~isa(TT.factors{i},'double')
                   error('factors must be three dimension tensors or double arrays');
                end
                if(ndims(TT.factors{i})~=3)
                    if ismatrix(TT.factors{i})
                        if i==length(TT.factors)
                            if  size(TT.factors{1}, 1)~=1
                                error('Rank inconsistency.');
                            end
                        else
                            if size(TT.factors{i+1}, 1)~=1
                                error('Rank inconsistency.');
                            end
                        end
                    else
                   error('factors must be three dimension tensors or double arrays');
                    end      
                end
%                 if(i==1&&sz(1)~=1)
%                    error('First dimension of the first factor should be 1'); 
%                 end
%                 if(i==N&&sz(3)~=1)
%                     error('Last dimension of the last factor should be 1');
%                 end
                Ranks(i) = szs{i}(1);
                Size_t{i} = szs{i}(2);
            end
            for i = 1:N-1
                if length(szs{i})==3 && szs{i}(3) ~= szs{i+1}(1)
                    error('Rank inconsistency.');
                end
            end
            Ranks(N+1) = 1;
            Sizes = cell2mat(Size_t);
            TT.rank = Ranks;
            TT.size = Sizes;
            return;
        end
    end
end

