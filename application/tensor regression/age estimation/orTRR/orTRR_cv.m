function [lambda_optimal,cvfold]=orTRR_cv(X,y,cv_fold,settings)

sx=size(X);
% sy=size(Y);
n=sx(1);
X=reshape(X,n,[]);

cvp = cvpartition(n,'Kfold',cv_fold);


%Rlist=1:settings.maxR;


lambda_list=settings.paraRange;

% cvfold.Rlist=Rlist;
accmax=0;
addpath(settings.ortrr_path);
for l=1:length(lambda_list)
    %     for k=1:length(Rlist)
    acc= zeros(cvp.NumTestSets,1);
    %         sprintf(['rank=[', num2str(Rlist(k)),']'])
    %         R=Rlist(k);
    lambda=lambda_list(l);
    for i = 1:cvp.NumTestSets
        trIdx = cvp.training(i);
        teIdx = cvp.test(i);
        numtrain=cvp.TrainSize(i);
        numtest=cvp.TestSize(i);
        
        Xtrain = reshape(X(trIdx,:),[numtrain,sx(2:end)]);
        Xtest  = reshape(X(teIdx,:),[numtest,sx(2:end)]);
        
        TrainData = tensor(permute(Xtrain,[2,3,4,1]));
        TestData =  tensor(permute(Xtest,[2,3,4,1]));
        
        ytrain = y(trIdx,:,:);
        ytest  = y(teIdx,:,:);
        
        models = [];
        model = [];
        for j = 1 :  size(ytest, 2)
            fprintf('<------------ Training for model : %d/%d----------------->\n', l, size(ytest, 2));
            %[U, d, train_err] = genTensorRegression(TrainData, ytrain(:, j), lambda, R); % tensor ridge regression
            %     [U, d, train_err] = linTensorSVR(TrainData, Ytrain(:,l), C, R);     % tensor svr
            [U, d, Alpha, beta, train_err] = orTensorRegression(TrainData, Ytrain(:,l), R, 'lsq', 'grl', lambda);
            model.U = U;
            model.b = d;
            model.train_err = train_err;
            models = [models model];
        end
        YPt = zeros(size(ytest));
        fprintf('Total : %d/%04d', size(ytest, 1), 0);
        for m = 1 : 1:   size(ytest, 1)
            Xdata = TestData(:,:,:,m);
            fprintf('\b\b\b\b%04d' ,i);
            for s = 1 : size(ytest, 2)
                model = models(s);
                U = model.U;
                d = model.b;
                ten_U = CP2tensor(U);
                 YPt(m, s) = inner_product(Xdata, ten_U)+d;
            end
        end
        %% save result
        
        
        acc(i) = mycorrcoef(ytest(:),YPt(:));
        
        
    end
    accmean=mean(acc);
    cvfold.acc(l)=accmean;
    save([settings.resultfolder,'cv_fold_result.mat'],'cvfold');
    if accmean>accmax
        accmax=accmean;
        lambda_optimal=lambda;
        %             R_optimal=Rlist(k);
    end
end
% end
cvfold.accmax=accmax;
% cvfold.bestR=R_optimal;
cvfold.bestratio=lambda_optimal;

end