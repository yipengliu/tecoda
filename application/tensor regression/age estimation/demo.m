%% age estimation for Fg-net dataset

clear all
addpath(genpath('..\..\..\core\'));
addpath(genpath('..\..\..\td\'));
addpath(genpath('..\..\..\optimization\'));
addpath(genpath('..\..\..\database\'));

addpath('tools\');
rng('default');
%% Load Database

load('age_estimation\features_hog\datasetx.mat');
load('age_estimation\age.mat');


N=size(datasetx,1);
%% Split the data into training and testing data
trainsample=floor(0.8*N);
Xtrain = datasetx(1:trainsample,:,:,:);
Ytrain = age(1:trainsample);
Xtest = datasetx(trainsample+1:end, :,:,:);
Ytest = age(trainsample+1:end);

%% model parameter setting
method_list={'hrTRR','orTRR','hrSTR','remurs','strum','SURF'};

method_select=input('index of selected method:');

ResultFolder=['Result/',method_list{method_select},'/']; % set result saving folder
mkdir(ResultFolder);
settings.resultfolder=ResultFolder;
settings.enable_cv=false; % indicator for cross_validation
addpath(method_list{method_select});

switch method_select
    case 1
        settings.maxR=10;
        model=test_hrTRR(Xtrain,Ytrain,Xtest,Ytest,settings);
    case 2
        model=test_orTRR(Xtrain,Ytrain,Xtest,Ytest,settings);
    case 3
        model=test_hrSTR(Xtrain,Ytrain,Xtest,Ytest,settings);
    case 4
        model=test_remurs(Xtrain,Ytrain,Xtest,Ytest,settings);
    case 5
        model=test_strum(Xtrain,Ytrain,Xtest,Ytest,settings);
    case 6
        model=test_surf(Xtrain,Ytrain,Xtest,Ytest,settings);
end


save([ResultFolder,'result.mat'],'model');
rmpath(method_list{method_select});



