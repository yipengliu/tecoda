function [imout, paramsout] = TNDLMRI(kdata,mask,X_real,paramsin,par)
% Tensor-CS based reconstruction of undersampled dynamic MRI data by solving
% min ||X-[G;D1,D2,D3]||^2 + lambda*||G||_0 + mu*||E*X-Y||^2,
% where E*X = mask.*[X;fftshift(F),fftshift(F),I].
% 
% For single coil k-space data

num = paramsin.num;
lambda0 = paramsin.lambda;
mu0 = paramsin.mu;  
delta = paramsin.delta;
tol = paramsin.tol;
%%% 多线圈的情况处理
sizeData= size(X_real);
% if sizeData(4)>1 && ndims(mask)<4
%     mask = repmat(mask,[1,1,1,sizeData(4)]); 
% end
sampindex = find(mask==1);  % Return a vector
im0 = fftshift(ifft(fftshift(kdata.*mask,1),[],1),1);
im0 = fftshift(ifft(fftshift(im0,2),[],2),2);

if ~paramsin.isnormalized   
    sc = max(im0(:));
    im0 = im0/sc;   
    kdata = kdata/sc;   % Normalization
    if isfield(paramsin,'imfull')
        paramsin.imfull = paramsin.imfull/sc;
    end
end
if isfield(paramsin,'imfull') 
    paramsout.PSNR0 = eval_PSNR(paramsin.imfull,im0);
    fprintf(' ite: 0 , Zero-filled reconstruction PSNR: %-8.2f\n', paramsout.PSNR0); 
end

ite = 0;    % Iteration number
imNew = reshape(im0,sizeData);
currenterror = 999;

Npatch          = Im2Patch3D(X_real, par);  %% 将图像展开为64块相应的矩阵,很大块的矩阵
sizePatch       = size(Npatch);
[Sel_arr]       = nonLocal_arr(sizeData, par); % PreCompute the all the patch index in the searching window 
L             = length(Sel_arr); %% 计算的窗口中间储存了相应步长的坐标的值
 D1=cell(L,1); D2=cell(L,1); D3=cell(L,1); Gten=cell(L,1); Q=cell(L,1);
% iterations
while (ite < num  && currenterror > tol) || ite < paramsin.itemin 
    ite = ite+1; 
    imPre =imNew; 
    lambda = lambda0*delta^ite;
    mu = mu0*delta^ite;
    
    % Extracting blocks
    Curpatch=Im2Patch3D(imPre,par);

if ( mod(ite,par.J)==0 || (ite==1))
    % block matching to find samilar FBP goups
    unfoldPatch     = abs(mode_n_unfold(Curpatch,3)');  %%%
    patchXpatch     = sum(unfoldPatch.*unfoldPatch,1);
    distenMat       = repmat(patchXpatch(Sel_arr),sizePatch(3),1)+repmat(patchXpatch',1,L)-2*(unfoldPatch')*unfoldPatch(:,Sel_arr);
    [~,index]       = sort(distenMat);      %%  聚类的分析情况
    index           = index(1:par.patnum,:);
      
   
    clear patchXpatch distenMat;
end
       
    tempPatch       = cell(L,1); 
    Epatch          = zeros(sizePatch);
    W               = zeros(sizePatch(1),sizePatch(3));

       
   for ii=1:L
        tempPatch{ii} = Curpatch(:,:,index(:,ii));  %% 表示分成了L组为其中的索引的值，每租有65个
        Xtrain=tensor(tempPatch{ii});
    if ite == 1
        % Using HOSVD to initialize the dictionaries
        T = double(mode_n_unfold(Xtrain,1));
        [D11,~] = eig(T*T');
       
        T = double(mode_n_unfold(Xtrain,2));
        [D22,~] = eig(T*T');
        
        T = double(mode_n_unfold(Xtrain,3));
        [D33,~] = eig(T*T');
        
    else 
       
         Gtrain = Gten{ii};
         D11=D1{ii};
         D22=D2{ii};
         D33=D3{ii};
         Xtrain_col = double(mode_n_unfold(Xtrain,1));
         Gtrain_col = double(mode_n_unfold(mode_n_product(Gtrain,{D22,D33},[2,3]),1));
         [U,~,V] = svd(Xtrain_col*Gtrain_col');
         D11 = U*V';
         
         Xtrain_col = double(mode_n_unfold(Xtrain,2));
         Gtrain_col = double(mode_n_unfold(mode_n_product(Gtrain,{D11,D33},[1,3]),2));
         [U,~,V] = svd(Xtrain_col*Gtrain_col');
         D22 = U*V';
         
         Xtrain_col = double(mode_n_unfold(Xtrain,3));
         Gtrain_col = double(mode_n_unfold(mode_n_product(Gtrain,{D11,D22},[1,2]),3));
         [U,~,V] = svd(Xtrain_col*Gtrain_col');
         D33 = U*V'; 
    end
    D1{ii}=D11;
    D2{ii}=D22;
    D3{ii}=D33;
    end
    
    parfor ii=1:L
    % Sparse coding 
    D11=D1{ii};
    D22=D2{ii};
    D33=D3{ii};
    Xten=tensor(tempPatch{ii});
    G = double(mode_n_product(Xten,{D11',D22',D33'},[1,2,3]));
    G(abs(G)<lambda) = 0;        % hard thresholding 
    Gten{ii} = tensor(G);   %%%% !!!!Gten 中存储tensor
    end
  
  
    
    for ii = 1:L  
        Q{ii}=double(mode_n_product(Gten{ii},{D1{ii},D2{ii},D3{ii}},[1,2,3]));
        Epatch(:,:,index(:,ii))  = Epatch(:,:,index(:,ii)) + Q{ii};
        W(:,index(:,ii))         = W(:,index(:,ii))+ones(size(tempPatch{ii},1),size(tempPatch{ii},3));
     end 
    
     [QQ, ~]  =  Patch2Im3D( Epatch, W, par, sizeData);  %%此处的Q为计算过的值

    % Updating reconstruction
    S1 = fftshift(fft(fftshift(QQ,1),[],1),1);
    S1 = fftshift(fft(fftshift(S1,2),[],2),2);  % Fourier transform    
    S = S1;
    if mu >= 1e20  %% 这边的是主要考虑噪声比较大的时候，处理的情况；
        S(sampindex) = kdata(sampindex);
    else         
        S(sampindex) = 1/(1+mu)*(mu*S1(sampindex) + kdata(sampindex));
    end    
       
    % Inverse Fourier transform
    imNew = fftshift(ifft(fftshift(S,1),[],1),1);
    imNew = fftshift(ifft(fftshift(imNew,2),[],2),2);
    %Compute various performance metrics
    paramsout.itererror(ite) = norm(imPre(:)-imNew(:))/norm(imPre(:)); 
    currenterror = paramsout.itererror(ite);

    paramsout.PSNR(ite) = eval_PSNR(paramsin.imfull,double(imNew));
    paramsout.SSIM(ite) = eval_SSIM(paramsin.imfull,double(imNew));

    fprintf(' ite: %d ,currenterror: %f, PSNR: %-8.2f\n', ite,currenterror,paramsout.PSNR(ite)); 
    
    paramsout.runtime(ite) = toc;
end

% Outputs
imout = double(imNew);

function  [SelfIndex_arr]  =  nonLocal_arr(sizeD, par)
% -SelfIndex_arr is the index of keypatches in the total patch index array 

TempR         =  floor (sizeD(1)-par.patsize)+1;
TempC         =   floor(sizeD(2)-par.patsize)+1;  %%  最后的索引块的终点
R_GridIdx	  =   1:par.step:TempR;  %% 此处默认的每次移动一个距离点即pstep=1
R_GridIdx	  =   [R_GridIdx R_GridIdx(end)+1:TempR];  %%用于间隔取不到的值，进行处理~
C_GridIdx	  =   1:par.step:TempC;
C_GridIdx	  =   [C_GridIdx C_GridIdx(end)+1:TempC];  %%利用步长取到所有的最终的索引的值

temp          = 1:TempR*TempC;               %%共有这个多的块的数目
temp          = reshape(temp,TempR,TempC);
SelfIndex_arr = temp(R_GridIdx,C_GridIdx);
SelfIndex_arr = SelfIndex_arr(:)';
end
function PSNR = eval_PSNR(orig, obj)
% Evaluate peak signal to noise ratio (PSNR) index between orig and obj
    MSE = mean(abs(orig(:)-obj(:)).^2);
    PSNR = 10*log10(max(abs(orig(:)))^2/MSE);
end

function SSIM = eval_SSIM(orig, obj)
% Evaluate SSIM index between orig and obj
    ss = zeros(1, size(orig,3));
    for n = 1 : size(orig,3)
        ss(n) = ssim_index(abs(orig(:,:,n)),abs(obj(:,:,n)));
    end
    SSIM = mean(ss);    
end

function [mssim, ssim_map] = ssim_index(img1, img2, K, window, L)
%----------------------------------------------------------------------
%
%This is an implementation of the algorithm for calculating the
%Structural SIMilarity (SSIM) index between two images.
%
%----------------------------------------------------------------------
%
%Input : (1) img1: the first image being compared
%        (2) img2: the second image being compared
%        (3) K: constants in the SSIM index formula (see the above
%            reference). defualt value: K = [0.01 0.03]
%        (4) window: local window for statistics (see the above
%            reference). default widnow is Gaussian given by
%            window = fspecial('gaussian', 11, 1.5);
%        (5) L: dynamic range of the images. default: L = 255
%
%Output: (1) mssim: the mean SSIM index value between 2 images.
%            If one of the images being compared is regarded as 
%            perfect quality, then mssim can be considered as the
%            quality measure of the other image.
%            If img1 = img2, then mssim = 1.
%        (2) ssim_map: the SSIM index map of the test image. The map
%            has a smaller size than the input images. The actual size:
%            size(img1) - size(window) + 1.
%
%Default Usage:
%   Given 2 test images img1 and img2, whose dynamic range is 0-255
%
%   [mssim ssim_map] = ssim_index(img1, img2);
%
%Advanced Usage:
%   User defined parameters. For example
%
%   K = [0.05 0.05];
%   window = ones(8);
%   L = 100;
%   [mssim ssim_map] = ssim_index(img1, img2, K, window, L);
%
%See the results:
%
%   mssim                        %Gives the mssim value
%   imshow(max(0, ssim_map).^4)  %Shows the SSIM index map
%
%========================================================================


if (nargin < 2 || nargin > 5)
   ssim_index = -Inf;
   ssim_map = -Inf;
   return;
end

if (size(img1) ~= size(img2))
   ssim_index = -Inf;
   ssim_map = -Inf;
   return;
end

[M N] = size(img1);

if (nargin == 2)
   if ((M < 11) || (N < 11))
	   ssim_index = -Inf;
	   ssim_map = -Inf;
      return
   end
   window = fspecial('gaussian', 11, 1.5);	%
   K(1) = 0.01;								      % default settings
   K(2) = 0.03;								      %
%    L = 255;                                  %
   L = 1;    % hjh
end

if (nargin == 3)
   if ((M < 11) || (N < 11))
	   ssim_index = -Inf;
	   ssim_map = -Inf;
      return
   end
   window = fspecial('gaussian', 11, 1.5);
%    L = 255;                                  %
   L = 1;    % hjh
   if (length(K) == 2)
      if (K(1) < 0 || K(2) < 0)
		   ssim_index = -Inf;
   		ssim_map = -Inf;
	   	return;
      end
   else
	   ssim_index = -Inf;
   	ssim_map = -Inf;
	   return;
   end
end

if (nargin == 4)
   [H W] = size(window);
   if ((H*W) < 4 || (H > M) || (W > N))
	   ssim_index = -Inf;
	   ssim_map = -Inf;
      return
   end
%    L = 255;                                  %
   L = 1;    % hjh
   if (length(K) == 2)
      if (K(1) < 0 || K(2) < 0)
		   ssim_index = -Inf;
   		ssim_map = -Inf;
	   	return;
      end
   else
	   ssim_index = -Inf;
   	ssim_map = -Inf;
	   return;
   end
end

if (nargin == 5)
   [H W] = size(window);
   if ((H*W) < 4 || (H > M) || (W > N))
	   ssim_index = -Inf;
	   ssim_map = -Inf;
      return
   end
   if (length(K) == 2)
      if (K(1) < 0 || K(2) < 0)
		   ssim_index = -Inf;
   		ssim_map = -Inf;
	   	return;
      end
   else
	   ssim_index = -Inf;
   	ssim_map = -Inf;
	   return;
   end
end

C1 = (K(1)*L)^2;
C2 = (K(2)*L)^2;
window = window/sum(sum(window));
img1 = double(img1);
img2 = double(img2);

mu1   = filter2(window, img1, 'valid');
mu2   = filter2(window, img2, 'valid');
mu1_sq = mu1.*mu1;
mu2_sq = mu2.*mu2;
mu1_mu2 = mu1.*mu2;
sigma1_sq = filter2(window, img1.*img1, 'valid') - mu1_sq;
sigma2_sq = filter2(window, img2.*img2, 'valid') - mu2_sq;
sigma12 = filter2(window, img1.*img2, 'valid') - mu1_mu2;

if (C1 > 0 & C2 > 0)
   ssim_map = ((2*mu1_mu2 + C1).*(2*sigma12 + C2))./((mu1_sq + mu2_sq + C1).*(sigma1_sq + sigma2_sq + C2));
else
   numerator1 = 2*mu1_mu2 + C1;
   numerator2 = 2*sigma12 + C2;
	denominator1 = mu1_sq + mu2_sq + C1;
   denominator2 = sigma1_sq + sigma2_sq + C2;
   ssim_map = ones(size(mu1));
   index = (denominator1.*denominator2 > 0);
   ssim_map(index) = (numerator1(index).*numerator2(index))./(denominator1(index).*denominator2(index));
   index = (denominator1 ~= 0) & (denominator2 == 0);
   ssim_map(index) = numerator1(index)./denominator1(index);
end

mssim = mean2(ssim_map);

end
end
