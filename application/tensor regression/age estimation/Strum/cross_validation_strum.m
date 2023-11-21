function [ best ] = cross_validation_strum(X, y, setting)

indexTotal = 1:length(y);
numFold    = 5;
numTest    =floor( length(indexTotal) / numFold);

 

alphaRange = [10^-3, 5*10^-3, 10^-2, 5*10^-2, 10^-1, 5*10^-1, 10^0, 5*10^0, 10^1, 5*10^1, 10^2, 5*10^2];
betaRange  = [10^-3, 5*10^-3, 10^-2, 5*10^-2, 10^-1, 5*10^-1, 10^0, 5*10^0, 10^1, 5*10^1, 10^2, 5*10^2, 10^3];

best.acc = 0;
for alpha =  alphaRange
    isBetaMax = false;
    for beta =  betaRange
        if isBetaMax
            fprintf('Reach max beta! Break!!!\n');
            break;
        end
        
        isTooSmallBeta = false;
        
        fprintf('alpha: %d, beta: %d\n', alpha, beta);
        
        acc = zeros(1,numFold);
        num = zeros(1,numFold);
        
        for testFold = 1:numFold
            %% Train--test
            indexTest  = indexTotal((testFold-1)*numTest+1 : testFold*numTest);
            indexTrain = setdiff(indexTotal,indexTest);
            
            tX_test = X(:, :, :, indexTest);
            y_test = y(indexTest, :);
            
            tX_train = X(:, :, :, indexTrain);
            y_train = y(indexTrain, :);
            %% Cross validation
            [tW, errlist] = Strum(tX_train, y_train, alpha, beta, setting.epsilon, 1000);
           
            X_test = reshape(tX_test, [], size(tX_test, 4));
            X_test = X_test';
            
            %% Predict
            y_predict = X_test * tW(:);
            threshold = (max(y)+min(y))/2;
            y_predict(find(y_predict >= threshold)) = max(y);
            y_predict(find(y_predict <  threshold)) = min(y);
            
            num(testFold) = length(find(tW(:) ~= 0));
            %% Early stop if too few voxels are selected.
            if num(testFold) < setting.nVoxels * 0.05
                isBetaMax = true;
                break;
            end
            
            %% Break if too many voxels are selected
            if num(testFold) > setting.nVoxels * 0.5
                fprintf('Too small beta!!!\n');
                isTooSmallBeta = true;
                break;
            end
            
            acc(testFold) = length(find(y_predict == y_test)) / length(y_test);
                
        end

        avgAcc = mean(acc);
        
        if ~isBetaMax & ~isTooSmallBeta & avgAcc > best.acc
            best.acc   = avgAcc;
            best.alpha = alpha;
            best.beta  = beta;
        end
    end
end
end

