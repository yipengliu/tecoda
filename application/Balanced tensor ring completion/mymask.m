clc
clear
close all
img1=imread('llama.jpg');
for i=1:3
    img(:,:,i)=imresize(img1(:,:,i),[256,384]);
end
siz=size(img);
img=double(img);
P=ones(siz(1:2));
BW=imread('hands1-mask.png');
BW=imresize(BW,[42,56]);
% 1
BW1=~BW;
P(201:200+size(BW1,1),201:200+size(BW1,2))=BW1;
% 2
BW2=~imrotate(BW,30);
P(131:130+size(BW2,1),31:30+size(BW2,2))=BW2;
% 3
BW3=~imrotate(BW,60);
P(101:100+size(BW3,1),301:300+size(BW3,2))=BW3;
% 4
BW4=~imrotate(BW,90);
P(111:110+size(BW4,1),141:140+size(BW4,2))=BW4;
% 5
BW5=~imrotate(BW,-90);
P(201:200+size(BW5,1),101:100+size(BW5,2))=BW5;
% 6
BW6=~imrotate(BW,180);
P(101:100+size(BW6,1),221:220+size(BW6,2))=BW6;
% 7
BW7=~imrotate(BW,-30);
P(21:20+size(BW7,1),21:20+size(BW7,2))=BW7;
% 8
BW8=~imrotate(BW,-45);
P(21:20+size(BW8,1),221:220+size(BW8,2))=BW8;
% 9
BW9=~imrotate(BW,-75);
P(181:180+size(BW9,1),321:320+size(BW9,2))=BW9;
% 10
BW10=~imrotate(BW,105);
P(21:20+size(BW10,1),321:320+size(BW10,2))=BW10;
% 11
BW11=~imrotate(BW,-135);
P(74:73+size(BW11,1),41:40+size(BW11,2))=BW11;

P=cat(3,P,P,P);
imshow(uint8(P.*img))
save P P