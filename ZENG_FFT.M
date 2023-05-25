function [Label, Comment, Ch_Time]=Zeng_FFT(Z,X1X2,ChLabel)
global Data
global Needed
s=get(gcbf,'userdata');
%3 Inputs----------------
%3 Outputs =1)Lable 2)Comment 3)Ch_Time
Label=[];
Comment=[];
Ch_Time=[];
%-----------------------------
%Needed=fft(Data{Z}(18:2:32,X1X2(1):(X1X2(1)+511))')';
Needed=fft(Data{Z}(18:2:32,:)')';
figure(10)

subplot(7,1,1),plot(abs(Needed(1,1:20)));
subplot(7,1,2),plot(abs(Needed(2,1:20)));

for n=3:7
   subplot(7,1,n),plot(abs(Needed(n+1,:)));
   
end


