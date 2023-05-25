function [Label, Comment, AnnoteArray]=Zeng_BiPeak(Z,X1X2,ChLabel,Annote)
global Data
Label='AT '; %Has to be 3 digits...
Comment='Activation Time';
AnnoteArray=[];
%-----------------------------
for i=1:length(ChLabel(:,1))
   Temp=abs(Data{Z}(ChLabel(i,3),X1X2(1):X1X2(2))-Data{Z}(ChLabel(i,2),X1X2(1):X1X2(2)));
   Peak=find(Temp==max(Temp));
   AnnoteArray=[AnnoteArray;ChLabel(i,1) Peak(1) Label] ;
end
%X1X2(1)
AnnoteArray(:,2)=AnnoteArray(:,2)+X1X2(1)-1;
AnnoteArray=[Annote;AnnoteArray]; %The new ones have to be added underneath the ole one.



