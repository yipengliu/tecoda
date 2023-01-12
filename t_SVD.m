function [U,S,V]=t_SVD(X)
%   t_SVD decomposition, X=U*S*V', * denotes t_product and 'denotes tensor
%   transpose
%   Input:  X:      Tensor in Size(I1, I2, I3)
%   Output: U:      Orthogonal Tensor
%           S:      f-diagonal Tensor
%           V:      Orthogonal Tensor

%% New t-SVD for 3-way data
D = fft(X.data,[],3);
Uh = tensor('zeros',[X.size(1),X.size(1),X.size(3)]);
Sh = tensor('zeros',[X.size(1),X.size(2),X.size(3)]);
Vh = tensor('zeros',[X.size(2),X.size(2),X.size(3)]);
I3 = X.size(3);
for i3 = 1:ceil(I3/2)
    [Uh(:,:,i3),Sh(:,:,i3),Vh(:,:,i3)] = svd(D(:,:,i3));
end
for i3 = ceil(I3/2):I3
    Uh(:,:,i3) = conj(Uh(I3-i3+2));
    Sh(:,:,i3) = Sh(I3-i3+2);
    Vh(:,:,i3) = conj(Vh(I3-i3+2));
end
U = tensor(ifft(Uh.data,[],3));
S = tensor(ifft(Sh.data,[],3));
V = tensor(ifft(Vh.data,[],3));

%% Naive t-SVD for 3-way data
% D = fft(X.data,[],3);
% Uh = tensor('zeros',[X.size(1),X.size(1),X.size(3)]);
% Sh = tensor('zeros',[X.size(1),X.size(2),X.size(3)]);
% Vh = tensor('zeros',[X.size(2),X.size(2),X.size(3)]);
% for i3 = 1:X.size(3)
%     [Uh(:,:,i3),Sh(:,:,i3),Vh(:,:,i3)] = svd(D(:,:,i3));
% end
% U = tensor(ifft(Uh.data,[],3));
% S = tensor(ifft(Sh.data,[],3));
% V = tensor(ifft(Vh.data,[],3));

end
