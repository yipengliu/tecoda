%CPtensor:Class for CANDECOMP/PARAFAC(CP) CPensors
%
%CPtensor Methods:
% tecoda  1.0, 2022
%
%
%For all questions, bugs and suggestions please mail
%ouweiting7@gmail.com
%License:
%---------------------------
classdef CPtensor
    properties
        weights
        factors
        rank
        size
    end
    methods
        function CP = CPtensor(varargin)
        % cptensor is CANDECOMP/PARAFAC(CP) format tensor(decomposed).
        %   CP = CPtensor() creates an empty cptensor

        %   CP = CPtensor(cp) copy a cptensor cp to new cptensor CP.

        %   CP = CPtensor(F) uses cell F, where F = {F1,F2,...Fn}, and 
        %   assume weights of each factor matrix Fi is 1.

        %   CP = CPtensor(W,F) uses weightvector W and cell F,where F =
        %   {F1,F2,...Fn}. W[i] is the weight of factor matrix F{i}

        %   CP = CPtensor(W,F1,F2,...,Fn) uses weightvector W and a list
        %   of factor matrix Fi.

        % Examples:
        %   CP = CPtensor({rand(3,4),rand(5,4),rand(7,4)})
        %   CP = CPtensor([1,2,1],{rand(3,4),rand(5,4),rand(7,4)})
        %   CP = CPtensor([1,2,1],rand(3,4),rand(5,4),rand(7,4))

            % Empty construtor
            if nargin == 0
                CP.weights = [];
                CP.factors = {};
                CP.rank = 0;
                CP.size = [];
                return;
            end

            % cptensor construtor
            if nargin == 1 && isa(varargin{1},'CPtensor')
                CP = varargin{1};
                return;
            end

            % Cell construtor
            if nargin == 1 && isa(varargin{1},'cell')
                CP.factors = varargin{1};    
                ndims = numel(CP.factors);
                CP.rank = size(CP.factors{1},2);
                CP.weights = ones(CP.rank,1);
                CP.size = [size(CP.factors{1},1),zeros(1,ndims-1)];
                for i = 2 : ndims
                    sz = size(CP.factors{i});
                    if sz(2) ~= CP.rank
                        error('Second dimension of factor matrix %d must be equal to the first matrix!',i)
                    else
                        CP.size(i) = sz(1);
                    end
                end
                return;
            end

            % weight vector and cell constructor
            if nargin == 2 && isvector(varargin{1}) && isa(varargin{2},'cell')
                CP.weights = varargin{1};
                CP.factors = varargin{2};    
                ndims = numel(CP.factors);
                CP.rank = size(CP.factors{1},2);
                CP.size = [size(CP.factors{1},1),zeros(1,ndims-1)];
                for i = 2 : ndims
                    sz = size(CP.factors{i});
                    if sz(2) ~= CP.rank
                        error('Second dimension of factor matrix %d must be equal to the first matrix!',i)
                    else
                        CP.size(i) = sz(1);
                    end
                end
                return;
            end

            % weight vector and a list of factor matrix constructor
            if nargin >= 2 && isvector(varargin{1}) && ismatrix(varargin(2:end))
                CP.weights = varargin{1};
                CP.factors = varargin(2:end);
                ndims = numel(CP.factors);
                CP.rank = size(CP.factors{1},2);
                CP.size = [size(CP.factors{1},1),zeros(1,ndims-1)];
                for i = 2 : ndims
                    sz = size(CP.factors{i});
                    if sz(2) ~= CP.rank
                        error('Second dimension of factor matrix %d must be equal to the first matrix!',i)
                    else
                        CP.size(i) = sz(1);
                    end
                end
                return;
            end             

           error('Invalid CPtensor constructor');
           
        end
   end
end