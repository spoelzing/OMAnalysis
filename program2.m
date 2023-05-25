% This software is for analysis of line scan image 
% This program is now under construction
%                      Toshiyuki Oya
% thank you steeve
%initialise

clear all
close all


% loading

[Filename, Path]=uigetfile(':\Documents and Settings\Tohya\My Documents\*tif','load tif image');
Ima = imread([Path, Filename]);

% Area smoothing

kernal=1/9*[1 1 1;1 0 1;1 1 1];
Imac=conv2(Ima,kernal,'same');

% line choosing
figure(1)


plline=ginput(1);

c=128;
line=Imac(:,c)';

% line smoothing

lineimage=line-mean(line(10:20));
lineimage=conv2(lineimage,ones(1,99));



% window program


figure;

image(Ima);


%plotting

figure;
plot(lineimage);


title('confocal line scan images'),...
   xlabel('time, msec'),...
   ylabel('intensity of Ca'),...
   grid


% input method
figure(1)


plline=ginput(1);



