% AUTHOR: Steven Poelzing
% DATE LAST MODIFIED: 04/09/2008
% This calculate the background for dual tandem detector

function [Label,Comment,Annote_Out]=Calcium_Amplitude(Z,X1X2,ChLabel,Annote)
Label='C_D';
Comment='Calcium Diastolic';
Annote_Out=[];
Fig.Annote=[];
Annote=[];
global Data
global Fig
global Stripchart
NewAnnote1=[];
NewAnnote2=[];
NewData=Data{Z};
h=waitbar(0,'Please Wait');
for i=1:(length(ChLabel(:,1)))
    waitbar(i/length(ChLabel(:,1)),h);
   NewData0=NewData(ChLabel(i,2),X1X2(1):X1X2(2));
   TempMin=min(NewData0);
   NewData1=NewData0-TempMin;
   
   TempMean=median(NewData1);
   TempStd=std(NewData1);
   TempMaxAmp=find(NewData1>TempMean+0.65*TempStd);
   TempMinVal=find(NewData1<TempMean-0.65*TempStd);
Diastolic=round(median(NewData0(1:25)));
D1=Diastolic;
DV=Diastolic-TempMin;
TT=conv2(NewData1,1/21*ones(1,21),'same');
CaAmp=max(NewData1(TempMaxAmp))-DV;
% CaAmp=round(median(NewData1(TempMaxAmp))-DV);

% CaAmp=round(median(NewData1(TempMaxAmp))-median(NewData1(TempMinVal)));
% Diastolic=median(NewData1(TempMinVal))+TempMin;
if i==719
% if 1==2
    disp('************************')
    figure(7)
    plot(NewData1)
    SNR=round(median(NewData1(TempMaxAmp))-DV)/std(NewData0(1:30))
    CaAmp
    Diastolic
    t1=CaAmp/std(NewData0(1:25))
    Stdev=std(NewData0(1:25))
       X1X2(2)-X1X2(1)
    disp('************************')
    line([0 700],[DV DV])
    line([0 700],[median(NewData1(TempMaxAmp)) median(NewData1(TempMaxAmp))])
%     pause
end

if CaAmp/std(NewData0(1:25))<1 | std(NewData0(1:25))>30 | Diastolic>(X1X2(2)-X1X2(1))*3
%     TempMaxAmp=find(NewData1>TempMean-0.25*TempStd);
%     CaAmp=round(median(NewData1(TempMaxAmp))-DV);
    Diastolic=-1;
    CaAmp=-1;
% elseif CaAmp/std(NewData0(1:50))<1.0 | Diastolic>=(X1X2(2)-X1X2(1))
%     CaAmp=-1;
%     Diastolic=-1;
end
if isempty(CaAmp)
    Diastolic=-1;
    CaAmp=-1;
end  

if i==719
   
end

   NewAnnote1=[NewAnnote1;ChLabel(i,1) Diastolic+X1X2(1) 'C_D '];  
   NewAnnote2=[NewAnnote2;ChLabel(i,1) CaAmp+X1X2(1) 'C_A '];  
end

% Annotes=[Annote;NewAnnote1,NewAnnote2];

Zeng_Analysis('Existing Check',Stripchart.Figure,'C_D','Calcium Diastolic',[Annote;NewAnnote1])
Zeng_Analysis('Existing Check',Stripchart.Figure,'C_A','Calcium Amplitude',[Annote;NewAnnote1;NewAnnote2])

 if 1==2
     ssound=['chord.wav'];
   [Y,FS,BITS]=wavread(ssound);
   sound(Y,FS,BITS)
 end

 close(h)  
   