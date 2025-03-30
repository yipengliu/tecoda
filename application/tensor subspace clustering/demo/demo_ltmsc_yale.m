clear all; 
close all; 
clc;
addpath('../preprocessing');
addpath('../preprocessing/ClusteringMeasure');
addpath('../preprocessing/LTMSC');
addpath('../../../database/multi-view datasets');

load('yale.mat');
X{1} = X2; X{2} =X1; X{3} = X3;
num_views = 3;
for v=1:num_views
   X{v} = X{v}./(repmat(sqrt(sum(X{v}.^2,1)),size(X{v},1),1)+10e-10);
   %X{v} = NormalizeData(X{v});
end
truth=gt;

lambda = 0.1;
[f,p,r,nmi,ar,acc] = lt_msc(X, truth, lambda);

fprintf('lambda=%f, F=%f, P=%f, R=%f, nmi score=%f, AR=%f, ACC=%f,\n',lambda,f,p,r,nmi,ar,acc);
