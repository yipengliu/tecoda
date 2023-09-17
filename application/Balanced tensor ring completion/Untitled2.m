clc
clear
close all

TRr=7;
sr=0.1;
img=imread('..\..\testdata\Color images\lena.bmp');

siz=size(img);
img=double(img);
P=sampling_uniform(img,sr);

I=[2*ones(1,16) 3];
order=[1 9 2 10 3 11 4 12 5 13 6 14 7 15 8 16 17];
 J=[4*ones(1,8) 3];
 tnsr=l2h(img,I,order,J);