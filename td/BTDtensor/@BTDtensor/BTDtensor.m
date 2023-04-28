classdef BTDtensor
    %   The decomposition in multilinear rank-(Lr,Lr,1)
    %   terms writes a third-order tensor as a sum of R low multilinear rank term.
    properties
        cores
        factors
        size
        L
        R
    end
    methods
        function BTD = BTDtensor(varargin)
        % BTDtensor is BTD format tensor(decomposed).
        % BTD = BTDtensor() creates a empty BTDtensor.
        % BTD = BTDtensor(BTD) copy a BTDtensor.
        % BTD = BTDtensor(U) use core tensor and factors fn to
        % create a BTDtensor.
        % BTD = BTDtensor(U)use a cell to
        % create a BTDtensor,the cell contains all factors and all cores.
            if (nargin == 0)
                BTD.size = 0;
                BTD.cores = {};
                BTD.factors = {};
                BTD.L = {};
                BTD.R = 0;
                return;
            end
            if(nargin == 1 && isa(varargin{1},'BTDtensor'))
                BTD = varargin{1};
                return ;
            end
            if ~isa(varargin{1},'cell')
                error('U must be a cell.');
            else
                BTD.R = length(varargin{1});
                for r = 1:BTD.R
                    BTD.cores{r} = tensor(varargin{1}{r}{1});
                    if isa(varargin{1}{r}{2},'cell')
                        BTD.factors{r} = varargin{1}{r}{2};
                    else
                        N = length(varargin{1}{r});
                        for i = 2:N
                            BTD.factors{r}{i-1} = varargin{1}{r}{i};
                        end
                    end
                end
            end
            %check that factors
            fac_num = length(BTD.factors{1});
            %get the BTDtensor size
            for dim = 1:fac_num
                BTD.size(dim) = size(BTD.factors{1}{dim},1);
            end
            for r = 1:BTD.R
                if length(BTD.factors{r}) ~= fac_num
                    error('all factors must have same length for the BTDtensor');
                end
                for i = 1:fac_num
                    if size(BTD.factors{r}{i},1) ~= BTD.size(i)
                        error('the BTDtensor have different sizes');
                    end
                    if size(BTD.factors{r}{i},2) ~= size(BTD.cores{r},i)
                        error('the BTDtensor have different sizes');
                    end
                    BTD.L{r}(i) = size(BTD.factors{r}{i},2);
                end
                
            end
            return;
        end
    end
end

