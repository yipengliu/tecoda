function [res]=test_remurs(trainM,trainy,testM,testy,settings)


addpath('Remurs/tools');


if isfield(settings,'epsilon')
   epsilon=  settings.epsilon;
else
    epsilon=1e-4;
end
if isfield(settings,'enable_cv')
   enable_cv=  settings.enable_cv;
else
    enable_cv=true;
end
 

trainM=double(permute(trainM,[2,3,4,1]));
testM=double(permute(testM,[2,3,4,1]));
settings.nVoxels=numel(trainM(:,:,:,1));
 
   %% Select parameters via cross validation
   if enable_cv
       settings.epsilon=epsilon;
    best = cross_validation_Remurs(trainM, trainy, settings);
%     save([settings.resultfolder,'cv_fold_result.mat'],'cv_fold');
   else
       best.alpha=0.1;
       best.beta=0.1;
   end


for rep=1:10
   
    
    %% Train the model (by default the maximum iteration is 1000)
    tic;
        [tW, errList] = Remurs(trainM, trainy, best.alpha, best.beta, epsilon, 1000);

    runtime(rep)=toc;
    %% Predict
    X_test = reshape(testM, [], size(testM, 4));
    X_test = X_test';
    
    YPt = X_test * tW(:);
    fprintf('\n');
    Ypress = sum((testy(:)-YPt(:)).^2);
    rmse(rep) = sqrt(Ypress./numel(testy));
    Q2(rep) = 1 - Ypress./sum(testy(:).^2);
    cor(rep)=mycorrcoef(testy(:),YPt(:));
end
res.model=tW;
res.rmse=rmse;
res.Q2=Q2;
res.cor=cor;
res.runtime=runtime;
res.Ypred=YPt;

end

