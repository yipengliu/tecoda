%CPtensor:Class for CANDECOMP/PARAFAC(CP) Tensors
%
%CPtensor Methods:
% TensorAnalysis 1.0, 2022
%
%
%For all questions, bugs and suggestions please mail
%ouweiting7@gmail.com
%License:
%---------------------------
function T = CPtensor(varargin)
% T = CPtensor(lambda,U1,U2,...,Un) create the CP format tensor

% support cell

% Empty
if nargin == 0
    T.weights = [];
    T.factors = {};
    T.rank = 0;
    T.ndims = 0;
    T.shape = []; 
    T = class(T,'CPtensor');
    return;
elseif nargin == 1 && isa(varargin{1},'CPtensor')
    T.weights = varargin{1}.weights;
    T.factors = varargin{1}.factors;    
    T.ndims = numel(T.shape);
    T.rank = size(T.factors{1},2);
    T.shape = [size(T.factors{1},1),zeros(1,T.ndims-1)];
    for i = 2 : T.ndims
        shape = size(T.factors{i});
        if shape(2) ~= T.rank
            error('Rank of factor matrix %d must be equal to the first matrix!',i)
        else
            T.shape(i) = shape(1);
        end
    end
    T = class(T,'CPtensor');
    return;
else
    error('Invalid CPtensor constructor');
end



