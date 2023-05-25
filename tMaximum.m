function [Label1,Comment1,Annote_Out]=Zeng_MonoDerPos(Z,X1X2,ChLabel,Annote)
% This function first checks to see if an activation time can be 
% assigned to each channel. If an activation time can be assigned, 
% then the algorithm looks for a suitbale repolarization time based
% on the maximum of the second derivative.

Label1='Max';
Comment1='Maximum';
Annote_Out=[];
%-----------------------------
global Log
%-----------------------------
Data=Zeng_FltLP_Return(Z,X1X2,400);
h=waitbar(1/length(ChLabel(:,1)),'Calculating Minimum');

% The loop that goes through all the channels
for i=1:length(ChLabel(:,1))
    
   DataCh=Data(ChLabel(i,2),:);
   
   [Y,PeakX]=max(DataCh);
   waitbar(i/length(ChLabel(:,1)));
   
   Annote_Out=[Annote_Out;ChLabel(i,1) PeakX Label1];
end
close(h)
Annote_Out(:,2)=Annote_Out(:,2)+X1X2(1);
Annote_Out=[Annote;Annote_Out];

%-----------------------------


