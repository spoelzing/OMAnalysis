function [Label,Comment,Annote_Out]=Zeng_MonoDerNeg(Z,X1X2,ChLabel,Annote)
Label='AT ';
Comment='Activation Time';
Annote_Out=[];
%-----------------------------
global Log
%-----------------------------
Data=Zeng_FltLP_Return(Z,X1X2,390);
% Boxcar => The variable that specifies the length of the boxcar filter
% Make sure to use an ODD NUMBER
Boxcar=13;
% N D are the Numerator and Denominator Coefficients for the filter
[N D]=butter(4,59/500,'low');
% PhaseDelay => The delay introduced by the filter. You should Tweak this
%   until you are comfortable that it is assigning the AT at the correct location.
PhaseDelay=10;
% Threshold => An arbitrary value that prevents noisy channels from having 
%              an activation time assigned.
Threshold=-0.3;
%-----------------------------
h=waitbar(1/length(ChLabel(:,1)),'Calculating Activation Times');

for i=1:length(ChLabel(:,1))
% DataCh => The Data for a specific Channel
   DataCh=Data(ChLabel(i,2),:);
   
% Smooth => Smoothing the original data
%            Use One but not both.   
       % Smooth=conv2(DataCh,ones(1,Boxcar),'same');
         Smooth=filter(N,D,DataCh);
         
% Temp => The derivative of the Smoothd Data
   Temp=[0 diff(Smooth)];
   Peak=find(Temp==min(Temp(Boxcar:length(Temp)-Boxcar)));
   
   
   
   if min(Temp(Boxcar:length(Temp)-Boxcar))<Threshold*std(Temp(Boxcar:length(Temp)-Boxcar))
      Annote_Out=[Annote_Out;ChLabel(i,1) Peak(1)-PhaseDelay Label];
   end
      waitbar(i/length(ChLabel(:,1)));
end
close(h)
Annote_Out(:,2)=Annote_Out(:,2)+X1X2(1);
Annote_Out=[Annote;Annote_Out];
%-----------------------------



