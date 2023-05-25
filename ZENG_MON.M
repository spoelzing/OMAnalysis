function [Label,Comment,Annote_Out]=Zeng_MonoDerPos(Z,X1X2,ChLabel,Annote)
Label='RT ';
Comment='Repolarization Time';
Annote_Out=[];
%-----------------------------
global Log
%-----------------------------
Data=Zeng_FltLP_Return(Z,X1X2,400);
%-----------------------------
for i=1:length(ChLabel(:,1))
   Temp=[0 diff(Data(ChLabel(i,2),:))];
   Peak=find(Temp==max(Temp));
   Annote_Out=[Annote_Out;ChLabel(i,1) Peak(1) Label];
end
Annote_Out(:,2)=Annote_Out(:,2)+X1X2(1);
Annote_Out=[Annote;Annote_Out];
%-----------------------------


