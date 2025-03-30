classdef TRtensor
    properties
        factors
        size
        rank
    end
    methods
        function TR = TRtensor(varargin)
            %TRtensor is tensor ring format tensor(decomposed).
            % TR = TRtensor() creates a empty TRtensor.
            % TR = TRtensor(TR) copy a TRtensor.
            % TR = TRtensor(F1,F2,...,Fn) use core factors fn to
            % create a TRtensor.
            % TR = TRtensor({F1,F2,...,Fn})use a cell to
            % create a TRtensor,the cell contains all factors.
            if (nargin==0)
                TR.factors = {};
                TR.size = [];
                TR.rank = [];
                return;
            end
            if(nargin==1&&isa(varargin{1},'TRtensor'))
                TR = varargin{1};
                return ;
            end
            if ~isa(varargin{1},'cell')&&~isa(varargin{1},'double')
                error('Factors must be a cell or a double array.');
            else
                if isa(varargin{1},'cell')
                    TR.factors = varargin{1};
                else
                    for i = 1:nargin
                        TR.factors{i} = varargin{i};
                    end
                end
            end
            
            %check that factors are indeed matrices
            for i = 1:length(TR.factors)
                if ndims(TR.factors{i}) ~=3
                    if ismatrix(TR.factors{i})
                        if i==length(TR.factors)
                            if  size(TR.factors{1}, 1)~=1
                                error('Rank inconsistency.');
                            end
                        else
                            if size(TR.factors{i+1}, 1)~=1
                                error('Rank inconsistency.');
                            end
                        end
                    else
                        error('All factors must be 3-order tensor.');
                    end
                end
            end
            
            %check rank
            for i = 1:length(TR.factors) - 1
                if size(TR.factors{i}, 3) ~= size(TR.factors{i+1}, 1)
                    error('Rank inconsistency.');
                end
            end
            if size(TR.factors{end}, 3) ~= size(TR.factors{1}, 1)
                error('Rank inconsistency.');
            end
            
            
            siz = zeros(1,length(TR.factors));
            ranks = zeros(1,length(TR.factors));
            for i=1:length(TR.factors)
                siz(i)= size(TR.factors{i},2);
                ranks(i)= size(TR.factors{i},1);
            end
            TR.size = siz;
            TR.rank = ranks;
            return;
        end
    end
end
