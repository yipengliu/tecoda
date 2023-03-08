function [U,S,V]=t_SVD(varargin)
%   t_SVD decomposition, X=U*S*V', * denotes t_product and 'denotes tensor
%   transpose
%   Input:  X:      Tensor in Size(I1, I2, I3)
%           algo:   char 'p' for precise algorithm or 'f' for fast
%           algorithm, default is 'p'
%   Output: U:      Orthogonal Tensor
%           S:      f-diagonal Tensor
%           V:      Orthogonal Tensor

if nargin==1
    algo = 'p';
     if isa(varargin{1},'tensor')
        X = varargin{1};
     elseif isnumeric(varargin{1})
        X = tensor(varargin{1});
     else
        error("Input tensor must be tensor class data or matrix!")
     end
elseif nargin==2
     if isa(varargin{1},'tensor')
        X = varargin{1};
     elseif isnumeric(varargin{1})
        X = tensor(varargin{1});
     else
        error("Input tensor must be tensor class data or matrix!")
     end
     if varargin{2}=='p' || varargin{2}=='f'
         algo = varargin{2};
     else
         error("algorithm must be 'p' for precise algorithm or 'f' for fast algorithm!");
     end
else
    error("Number of arguments must be 1 or 2!");
end

%% Naive t-SVD for 3-way data,precise but slow
if algo == 'p'
    D = fft(X.data,[],3);
    Uh = tensor('zeros',[X.size(1),X.size(1),X.size(3)]);
    Sh = tensor('zeros',[X.size(1),X.size(2),X.size(3)]);
    Vh = tensor('zeros',[X.size(2),X.size(2),X.size(3)]);
    for i3 = 1:X.size(3)
        [Uh(:,:,i3),Sh(:,:,i3),Vh(:,:,i3)] = svd(D(:,:,i3));
    end
    U = tensor(ifft(Uh.data,[],3));
    S = tensor(ifft(Sh.data,[],3));
    V = tensor(ifft(Vh.data,[],3));
else
%% New t-SVD for 3-way data,fast but imprecise
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

end
