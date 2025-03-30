%% age estimation for Fg-net dataset

clear all
addpath(genpath('..\..\..\database\'));

%% Load Database
load('age_estimation\age.mat');
 
%% obtain the ground truth of the test data
N=size(age,1);
trainsample=floor(0.8*N);
Ytest = age(trainsample+1:end);

%% split the age into groups
range=[0,6,12,17,45];
for l=1:length(range)-1
    indexl=find(Ytest>range(l));
    indexr=find(Ytest<=range(l+1));
    index{l}=intersect(indexl,indexr);
end

%% load prediction

method_list={'hrTRR','orTRR','hrSTR','remurs','strum','SURF'};

fig=figure;
width = 800;  % width in pixels
height = 600; % height in pixels
set(fig, 'Position', [400, 150, width, height]);
for method_select=1:length(method_list)

load(['Result/',method_list{method_select},'/result.mat']);
Ypred=model.Ypred;
subplot(2,3,method_select);
for l=1:length(index)
scatter(Ypred(index{l}),Ytest(index{l}));
hold on
end
xlabel('Ground truth');
ylabel('Predicted');
legend('1-6','7-12','13-17','18-45');
title(method_list{method_select});

end
