clear all; 
close all; 
clc;
addpath('../preprocessing');
addpath('../preprocessing/ClusteringMeasure');
addpath('../preprocessing/LTMSC');
addpath('../../../database/multi-view datasets');

load('UCI_3view.mat');%
X1 = data{1};X2 = data{2};X3 = data{3};
X{1} = X1';X{2} = X2';X{3} = X3';

num_views = 3;
for v=1:num_views
   X{v} = X{v}./(repmat(sqrt(sum(X{v}.^2,1)),size(X{v},1),1)+10e-10);
end


lambda = 0.04;
[f,p,r,nmi,ar,acc] = lt_msc(X, truth, lambda);

fprintf('lambda=%f, F=%f, P=%f, R=%f, nmi score=%f, AR=%f, ACC=%f,\n',lambda,f,p,r,nmi,ar,acc);