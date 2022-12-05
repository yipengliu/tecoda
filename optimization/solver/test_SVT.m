%test_SVT()

%% test SVT with shape image

%example 1 

disp('%%%%%%%%%%%%Exp 1%%%%%%%%%%%%%%%%%');

disp('%%%%%%%%%SVT for shape data%%%%%%%%%%%%');

X=double(imread('circlesBrightDark.png'));
tol_list=[10,1e2,1e3,1e4];
X_hat=cell(length(tol_list),1);
AE=zeros(length(tol_list),1);
for i=1:length(tol_list)
    tol=tol_list(i);
    [U,S,V]=SVT(X,tol);
    X_hat{i}=U*S*V';
    AE(i)=norm(X-X_hat{i},'fro');
    disp(['tolerance: ', num2str(tol),', Approximate error:', num2str(AE(i))]);
end

% disply results with different torlence
figure;
set(gcf,'unit','centimeters','position',[10 10 30 10]);
N=length(tol_list)+1;
for i=1:N
    if i==1
        subplot(1,N,1);
imshow(imread('circlesBrightDark.png'));
title('Origin image','fontsize',12);
    else
    subplot(1,N,i);
imshow(uint8(X_hat{i-1}));
title({'Approximated image' ;['tol=', num2str(tol_list(i-1))]},'fontsize',12);
    end
end

suptitle('Image Approximation with SVT for Circles');




%% test SVT with grey image
disp('%%%%%%%%%%%%Exp 2%%%%%%%%%%%%%%%%%');

disp('%%%%%%%%%SVT for Grey Image%%%%%%%%%%%%');

X=double(imread('coins.png'));
tol_list=[10,1e2,1e3,1e4];
X_hat=cell(length(tol_list),1);
AE=zeros(length(tol_list),1);
for i=1:length(tol_list)
    tol=tol_list(i);
    [U,S,V]=SVT(X,tol);
    X_hat{i}=U*S*V';
    AE(i)=norm(X-X_hat{i},'fro');
    disp(['tolerance: ', num2str(tol),', Approximate error:', num2str(AE(i))]);
end

% disply results with different torlence
figure;
set(gcf,'unit','centimeters','position',[10 10 30 10]);
N=length(tol_list)+1;
for i=1:N
    if i==1
        subplot(1,N,1);
imshow(imread('coins.png'));
title('Origin image','fontsize',12);
    else
    subplot(1,N,i);
imshow(uint8(X_hat{i-1}));
title({'Approximated image' ;['tol=', num2str(tol_list(i-1))]},'fontsize',12);
    end
end

suptitle('Image Approximation with SVT for Grey Image');


%% test SVT with color image

disp('%%%%%%%%%%%%Exp 3%%%%%%%%%%%%%%%%%');

disp('%%%%%%%%%SVT for Color Image%%%%%%%%%%%%');

X=double(imread('onion.png'));
sx=size(X);
X=reshape(X,135,[]);
tol_list=[10,1e2,1e3,1e4];
X_hat=cell(length(tol_list),1);
AE=zeros(length(tol_list),1);
for i=1:length(tol_list)
    tol=tol_list(i);
    [U,S,V]=SVT(X,tol);
    X_hat{i}=U*S*V';
    AE(i)=norm(X-X_hat{i},'fro');
    disp(['tolerance: ', num2str(tol),', Approximate error:', num2str(AE(i))]);
end

% disply results with different torlence
figure;
set(gcf,'unit','centimeters','position',[10 10 30 10]);
N=length(tol_list)+1;
for i=1:N
    if i==1
        subplot(1,N,1);
imshow(imread('onion.png'));
title('Origin image','fontsize',12);
    else
    subplot(1,N,i);
imshow(uint8(reshape(X_hat{i-1},sx)));
title({'Approximated image' ;['tol=', num2str(tol_list(i-1))]},'fontsize',12);
    end
end

suptitle('Image Approximation with SVT for Color Image');




