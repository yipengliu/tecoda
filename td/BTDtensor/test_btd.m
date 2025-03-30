

%% %test_BTD()
%   test BTD
clear
clc
Qpause = true;
%% test BTDtensor()
clc
disp('%%%%%%%%test BTDtensor()%%%%%%%%');
T1 = BTDtensor();
display(T1);

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test BTDtensor(F)
clc
disp('%%%%%%%%test BTDtensor(F)%%%%%%%%');
 
size_tens=[10, 11, 12];
size_core={[2, 2, 3],[3, 4, 2],[5 ,6, 4]};
F = cell(3,1);
for i=1:length(size_core)
    F{i}{1}=rand(size_core{i});
    for j=2:length(size_tens)+1
        F{i}{j}=rand(size_tens(j-1),size_core{i}(j-1));
    end
end
 
T=BTDtensor(F);
display(T)


if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test BTDtensor(F1,F2,...,Fn)
clc
disp('%%%%%%%%test TTtensor(F1,F2,...,Fn)%%%%%%%%');

T=BTDtensor(F{1},F{2},F{3});
display(T)


if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test BTDtensor(BTD),copy an exist BTDtensor
clc
disp('%%%%%%%%test BTDtensor(BTD)%%%%%%%%');
T2 = BTDtensor(T);
fprintf("T2 is a copy of T.\n")
display(T2)

ERR=norm(calculate('minus',BTD2tensor(T),BTD2tensor(T2)));

if ERR==0
    fprintf("T2 equels T.\n")
end

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test BTD_NLS

size_tens=[10, 11, 12];
size_core={[2, 2, 3],[3, 4, 2],[5 ,6, 4]};
X=rand(size_tens);
X=tensor(X);
 U1=btd_rand(size_tens,size_core);
 U1=btd_nls(X,U1);
 R1=U1.rank;
T1 = BTD2tensor(U1);
Err1 = norm(calculate('minus', X, T1))/sqrt(prod(X.size));
 
fprintf("BTD_NLS with rank %d achieve RMSE %d.\n",R1,Err1);
 
if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end


%% %% test BTD_NLS with real image
clc
disp('%%%%%%%%test BTD_NLS with real image%%%%%%%%');

X=double(imread('sherlock.jpg'));

size_tens=[640,960, 3];
size_core={[2, 2, 3]};

X=tensor(X);
 U1=btd_rand(size_tens,size_core);
 U1=btd_nls(X,U1);
 R1=U1.rank;
T1 = BTD2tensor(U1);
Err1 = norm(calculate('minus', X, T1))/sqrt(prod(X.size));
 
fprintf("BTD_NLS with rank %d achieve RMSE %d.\n",R1,Err1);
 

size_core={[2, 2, 3],[3, 4, 2],[5 ,6, 2]};
 U2=btd_rand(size_tens,size_core);
 U2=btd_nls(X,U2);
 R2=U2.rank;
T2 = BTD2tensor(U2);
Err2 = norm(calculate('minus', X, T2))/sqrt(prod(X.size));
 
fprintf("BTD_NLS with rank %d achieve RMSE %d.\n",R2,Err2);
 
 

% disply results with BTD_NLS
figure;
set(gcf,'unit','centimeters','position',[10 10 30 10]);

subplot(1,3,1);
imshow(imread('sherlock.jpg'));
title('Original','fontsize',12);

subplot(1,3,2);
imshow(uint8(double(T1)));
title({'BTD\_NLS' ;"rank=["+strjoin(string(R1))+"]";['RMSE=', num2str(roundn(Err1,-2))]},'fontsize',12);

subplot(1,3,3);
imshow(uint8(double(T2)));
title({'BTD\_NLS' ;"rank=["+strjoin(string(R2))+"]";['RMSE=', num2str(roundn(Err2,-2))]},'fontsize',12);

 
if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end

%% test with video

clc
disp('%%%%%%%%test BTD_NLS with video%%%%%%%%');

vidObj = VideoReader("xylophone_video.mp4");
frames = double(read(vidObj,[18 47]));

size_tens=[240,320, 3,30];
size_core={[2, 2, 3,2]};

X=tensor(frames);
 U1=btd_rand(size_tens,size_core);
 U1=btd_nls(X,U1);
 R1=U1.rank;
T1 = BTD2tensor(U1);
Err1 = norm(calculate('minus', X, T1))/sqrt(prod(X.size));
 
fprintf("BTD_NLS with rank %d achieve RMSE %d.\n",R1,Err1);

size_core={[2, 2, 3,2],[2,3,2,4]};

 U2=btd_rand(size_tens,size_core);
 U2=btd_nls(X,U2);
 R2=U2.rank;
T2 = BTD2tensor(U2);
Err2 = norm(calculate('minus', X, T2))/sqrt(prod(X.size));
 
fprintf("BTD_NLS with rank %d achieve RMSE %d.\n",R2,Err2);
 
 
 
% disply results with BTD_NLS
figure;
set(gcf,'unit','centimeters','position',[10 10 30 10]);
X=double(X);
X1=double(T1);
X2=double(T2);
 

for f=1:size(X,4)
    subplot(1,3,1);
    imshow(uint8(X(:,:,:,f)));
    title('Original','fontsize',12);
    
    subplot(1,3,2);
    imshow(uint8(double(X1(:,:,:,f))));
    title({'BTD\_NLS' ;"rank=["+strjoin(string(R1))+"]";['RMSE=', num2str(roundn(Err1,-3))]},'fontsize',12);
    
    subplot(1,3,3);
    imshow(uint8(double(X2(:,:,:,f))));
    title({'BTD\_NLS' ;"rank=["+strjoin(string(R2))+"]";['RMSE=', num2str(roundn(Err2,-3))]},'fontsize',12);
    
     
    drawnow
end

if Qpause
    fprintf("Enter any key to continue,press ctrl+c to exit\n")
    pause
end
