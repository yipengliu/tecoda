function [res]=test_orTRR(Xtrain,Ytrain,Xtest,Ytest,settings)

 addpath('orTRR\tools\libsvm-mat-2.9-1\');

if ~isa(Xtrain,'double')
Xtrain=double(Xtrain);
end
if ~isa(Xtest,'double')
Xtest=double(Xtest);
end

flag_cv=0;
if flag_cv==1
    cv_fold=5;
    [lambda,cv_fold]=orTRR_cv(Xtrain,Ytrain,cv_fold,settings);
    save([settings.resultfolder,'cv_fold_result.mat'],'cv_fold');
else
    %% Training
    R = 18;
    lambda = 1000;
end
%% Reshape with mult-way array

TrainData = tensor(permute(Xtrain,[2,3,4,1]));
TestData =  tensor(permute(Xtest,[2,3,4,1]));
models = [];
model = [];

 C = 0.1;
 libsvm_options = sprintf('-s %d -t %d -c %f', 3, 0, C);
for rep=1:10
    tic;
    for l = 1 :  size(Ytest, 2)
        fprintf('<------------ Training for model : %d/%d----------------->\n', l, size(Ytest, 2));
  %      [U, d, train_err] = genTensorRegression(TrainData, Ytrain(:, l), lambda, R); % tensor ridge regression
        %     [U, d, train_err] = linTensorSVR(TrainData, Ytrain(:,l), C, R);     % tensor svr
        [U, d, Alpha, beta, train_err] = orTensorRegression(TrainData, Ytrain(:,l), R, 'libsvm', 'grl', lambda,libsvm_options);
        model.U = U;
        model.b = d;
        model.train_err = train_err;
        models = [models model];
    end
    runtime(rep) = toc;
    %% testing
    YPt = zeros(size(Ytest));
    fprintf('Total : %d/%04d', size(Ytest, 1), 0);
    for i = 1 : 1:   size(Ytest, 1)
        Xdata = TestData(:,:,:,i);
        fprintf('\b\b\b\b%04d' ,i);
        for l = 1 : size(Ytest, 2)
            model = models(l);
            U = model.U;
            d = model.b;
            ten_U = CP2tensor(U);
             YPt(i, l) = inner_product(Xdata, ten_U)+d;
        end
    end
    fprintf('\n');
    Ypress = sum((Ytest(:)-YPt(:)).^2);
    rmse(rep) = sqrt(Ypress./numel(Ytest));
    Q2(rep) = 1 - Ypress./sum(Ytest(:).^2);
    cor(rep)=mycorrcoef(Ytest(:),YPt(:));
end
res.model=models;
res.rmse=rmse;
res.Q2=Q2;
res.cor=cor;
res.runtime=runtime;
res.Ypred=YPt;
end
