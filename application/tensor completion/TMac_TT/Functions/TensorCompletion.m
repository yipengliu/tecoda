function [Out,Xmiss] = TensorCompletion(X,known)
    %% Missing data
    Nway = size(X); N = numel(Nway);
    Xkn = X(known);
    Omega = zeros(Nway);
    Omega(known) = 1;
    Omega = logical(Omega);
    Out.Omega = Omega;
    Xmiss = Omega.*X; 

    %% TMac-TT Algorithm        
    thl = [0.02];       % Adjust this value for different thresholds
    tol = 10^(-4);      % tol from Eq. (43)
    maxiter = 100;     % max iterations
    RSl = zeros(1,length(thl));MSl = cell(1,length(thl));relerrSl = MSl;timeTSl = RSl;
    for k=1:length(thl)
        th = thl(k);
        [~,ranktube] = SVD_MPS_Rank_Estimation(X,th);   % Initial TT ranks
        [MSl{k},~,~,timeTSl(k),relerrSl{k}] = TMacTT(Xkn,known,Nway,N,ranktube,tol,maxiter);    
        RSl(k)= RSE(MSl{k}(:),X(:));
    end
    %Choose the minimum RSE
    [Out.RSEmin, Idx] = min(RSl);
    Out.timeTS = timeTSl(Idx);
    Out.muf = thl(Idx);
    Out.MS = MSl{Idx};
    Out.err = relerrSl{Idx};
        
%    %% Original image with missing pixels
%     R=256;C=256;I1=2;J1=2;
%     Xmiss = CastKet2Image(Xmiss,R,C,I1,J1);
%     h3 = figure();
%     set(h3,'Position',[700 150 400 350]);
%     imagesc(uint8(Xmiss));
%     st = strcat('Original image with{ }',num2str(mr),'% missing pixels');
%     title(st);
    
end
