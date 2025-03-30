%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TMac-TT
% Time: 30/06/2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [M,X01,Y01,timeTC,relerr] = TMacTT(data,known,Nway,N,ranktube,tol,maxiter)
    % Compute the weights for each matrix
    lambda = weightTC(Nway);

    % Initialization
    M = initialization_M(Nway,known,data);
    [X0,Y0] = initialMatrix(N,Nway,ranktube);
    opts.X0 = X0; opts.Y0 = Y0;opts.lambda = lambda;opts.maxit = maxiter;opts.M0 =M;
    % Start Time measure
    t0=cputime;
    [M,X01,Y01,relerr] = GlobalTMP(data,known,Nway,opts,tol);
    % Stop Time measure
    timeTC = cputime-t0;
end
%%
function [X0,Y0] = initialMatrix(N,Nway,ranktube)
    X0 = cell(1,N-1);Y0 = cell(1,N-1);
    dimL = zeros(1,N-1);
    dimR = zeros(1,N-1);
    IL = 1;
    for k = 1:N-1
        dimL(k) = IL*Nway(k);
        dimR(k) = prod(Nway)/dimL(k);
        %
        X0{k} = randn(dimL(k),ranktube(k));
        Y0{k} = randn(ranktube(k),dimR(k));
        %uniform distribution on the unit sphere
        X0{k} = bsxfun(@rdivide,X0{k},sqrt(sum(X0{k}.^2,1)));
        Y0{k} = bsxfun(@rdivide,Y0{k},sqrt(sum(Y0{k}.^2,2)));
        %
        IL = dimL(k);
    end   
end
%%
function [M, X,Y,relerr] = GlobalTMP(data,known,Nway,opts,tol)

    X = opts.X0; Y = opts.Y0; lambda = opts.lambda;
    N = length(Nway);
    if isfield(opts,'M0')
        M = opts.M0;
        M = reshape(M,Nway);
    else
        M = zeros(Nway);
        M(known) = data;
    end
    normM = norm(data(:),'fro');
    Xsq = cell(1,N-1);
    k = 1;
    relerr = [];
    maxit = opts.maxit;
    relerr(1) = 1;
    
    
    %close all;
    % Initialize figures
    %R=256;C = 256;I1 = 2;J1 = 2;
    %h1 = figure();clf;
    %subplot(1,3,1);cla;hold on;
    %subplot(1,3,2);
    %set(h1,'Position',[200 600 1500 350]);
    %Img = CastKet2Image(M,R,C,I1,J1);
    %Img = reshape(Img,[R C 3]);
    %imagesc(uint8(Img));drawnow;
    %cla;hold on;
    %subplot(1,3,3);
    %fprintf('iter: RSE  \n');

    while relerr(k) > tol
        k = k+1;
        Mlast = M;

        % update (X,Y)
        for n = 1:N-1
            Mn = reshape(M,[size(X{n},1) size(Y{n},2)]);
            X{n} = Mn*Y{n}';
            Xsq{n} = X{n}'*X{n};
            Y{n} = pinv(Xsq{n})*X{n}'*Mn;
        end
        % update M
        Mn = X{1}*Y{1};
        M = lambda(1)*Mn;
        M = reshape(M,Nway);
        for n = 2:N-1
            Mn = X{n}*Y{n};
            Mn = reshape(Mn,Nway);
            M = M+lambda(n)*Mn;
        end

        M(known) = data;


        % Calculate relative error
        relerr(k) = abs(norm(M(:)-Mlast(:)) / normM);


        % Update figures
        %set(0,'CurrentFigure',h1);
        %subplot(1,3,1);cla;hold on;   
        %plot(relerr);
        %plot(tol*ones(1,length(relerr)));
        %grid on
        %set(gca,'YScale','log')
        %title('Relative Error')
        %ylim([(tol-5e-5) 1]);
        %subplot(1,3,2);
        %Img = CastKet2Image(M,R,C,I1,J1);
        %imagesc(uint8(Img));
        %title('TMac-TT');        
        %drawnow; 
        % message log
        %Img0=CastKet2Image(Orig,R,C,I1,J1);
        %subplot(1,3,3);
        %imagesc(uint8(Img0));
        %title('Original image');
        %fprintf('  %d:  %f \n',k-1,RSE(Img(:),Img0(:)));
        % check stopping criterion
        if k > maxit || (relerr(k)-relerr(k-1) > 0)
            break
        end
    end
end
%%
function [U, S, V]=svd_Truncate(T,D)
    th = 10^(-10); 
    if nargin == 1
        D = 1e6;
    end
    [U,S,V] = svd(T,'econ');
    V=V';
    ms = 0;
    dS = diag(S);
    for k = 1:length(dS)
        if dS(k)/dS(1)>th
            ms = ms+1;
        end
    end
    nDim = min(ms,D); % nDim = number of dimensions to be kept
    nDim = max(nDim,2); % avoid nDim = 1

    U = U(:,1:nDim);
    V = V(1:nDim,:);
    S = S(1:nDim,1:nDim);
end