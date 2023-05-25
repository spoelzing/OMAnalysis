function [Label,Comment,Annote_Out]=Zeng_ARIMinf(Z,X1X2,ChLabel,Annote)
global Log
%3 Inputs----------------4= imported ACT [Ch Time]
%3 Outputs =1)Lable 2)Comment 3)Ch_Time
Label=Log.Annote.Label{2};
Comment='Max Mono';
Annote_Out=[];
%-----------------------------
Data=Zeng_FltLP_Return(Z,X1X2,30);
%-----------------------------
Shift=80;
AnnoteRange=find(Annote(:,2)>=X1X2(1) & Annote(:,2)<=X1X2(2));
AnnoteRange=Annote(AnnoteRange(strmatch(Log.Annote.Label{1},Annote(AnnoteRange,3:5))),:);


for i=1:length(ChLabel(:,1))
   Ch=find(AnnoteRange(:,1)==ChLabel(i,1));
   if ~isempty(Ch)
      Temp=[0 diff(Data(ChLabel(i,2),(((AnnoteRange(Ch(1),2)+Shift):X1X2(2))-X1X2(1))))];
      Peak=find(Temp==min(Temp));
      Annote_Out=[Annote_Out;ChLabel(i,1) Peak(1)+AnnoteRange(Ch(1),2)+Shift-1 Label];
   end
   
end

Annote_Out=[Annote;Annote_Out];
%-----------------------------

