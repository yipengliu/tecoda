function [res]=test_surf(trainM,trainy,testM,testy,settings)


 

TrainData_3D=double(permute(trainM,[2,3,4,1]));
Mtrain=reshape(TrainData_3D,[],size(TrainData_3D,4))';

TestData_3D=double(permute(testM,[2,3,4,1]));
settings.nVoxels=numel(trainM(:,:,:,1));
%% Select parameters via cross validation
alpha=1;
cv_fold=5;

if settings.enable_cv
    [R,eplsion,cv_fold]=surf_cv(TrainData_3D,Mtrain,trainy,cv_fold,alpha);
    save([settings.resultfolder,'cv_fold_result.mat'],'cv_fold');
    
else
    eplsion=10;
    R=200;
end


for rep=1:10
    
    
    %% Train the model (by default the maximum iteration is 1000)
    tic;
    [~,~,Wt,~,~,~,~,~] = main_SURF(TrainData_3D, Mtrain,trainy,R,alpha,eplsion);
    runtime(rep)=toc;
    %% Predict
    Mtest=reshape(TestData_3D,[],size(TestData_3D,4))';
    
    YPt=sum(Mtest * Wt',2);
    
    fprintf('\n');
    Ypress = sum((testy(:)-YPt(:)).^2);
    rmse(rep) = sqrt(Ypress./numel(testy));
    Q2(rep) = 1 - Ypress./sum(testy(:).^2);
    cor(rep)=mycorrcoef(testy(:),YPt(:));
end
res.model=Wt;
res.rmse=rmse;
res.Q2=Q2;
res.cor=cor;
res.runtime=runtime;
res.Ypred=YPt;

end

