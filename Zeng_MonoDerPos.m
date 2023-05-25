function [Label,Comment,Annote_Out]=Zeng_MonoDerPos(Z,X1X2,ChLabel,Annote)
% This function first checks to see if an activation time can be 
% assigned to each channel. If an activation time can be assigned, 
% then the algorithm looks for a suitbale repolarization time based
% on the maximum of the second derivative.
% Edited 04/01/08 S.P.
Label='RT ';
Comment='Repolarization Time';
Annote_Out=[];
%-----------------------------
global Log
global Data
global PARAMETERSTRING Parameter4 TPRATIO
global Fig
global Stripchart

%-----------------------------

Parameter1Description=('Length of the boxcar filter (Positive Odd Numbers)');
Parameter2Description=('Number of consecutive sample points defining a peak (Positive Numbers)(Sample Points)');
Parameter3Description=('Blockout interval after detection of peak (Positive Numbers)(msec)');
Parameter4Description=('Peak amplitude and direction multplier factor (-5 to 5)');
Parameter5Description=(['Lowpass Filtering Cutoff (0 to ',num2str(Log.Head.SRate/2),' Hz)']);
Parameter6Description=('Repolarization Time Label');
Parameter7Description=(' ');

% ENTER PARAMETER DEFAULTS
P1Default=3;
P2Default=5;
P3Default=150;
P4Default=-1.1;
P5Default=20;
P6Default=0;
P7Default=0;
PDefaults=[P1Default;P2Default;P3Default;P4Default;P5Default;P6Default;P7Default];

contin=RepInterface(Parameter1Description,Parameter2Description,Parameter3Description,Parameter4Description,Parameter5Description,Parameter6Description,Parameter7Description,PDefaults,Label);

if contin==1
%%%%%%%%%%%%%%%%%%%%%    ERROR CHEKCING GOES IN THE LINES BELOW

Log.Defaults.Parameter1=str2num(get(Fig.Parameter1,'String'));
  if isempty(Log.Defaults.Parameter1) | Log.Defaults.Parameter1<0 | rem(Log.Defaults.Parameter1,2)==0
     close(Fig.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
     return
  end
  Log.Defaults.Parameter2=str2num(get(Fig.Parameter2,'String'));
  if isempty(Log.Defaults.Parameter2) | Log.Defaults.Parameter2<0
     close(Fig.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
     return
  end
  Log.Defaults.Parameter3=str2num(get(Fig.Parameter3,'String'));
  if isempty(Log.Defaults.Parameter3) | Log.Defaults.Parameter2<0
     close(Fig.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
      return
 end
  Log.Defaults.Parameter4=str2num(get(Fig.Parameter4,'String'));
  if isempty(Log.Defaults.Parameter4)
     close(Fig.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
     return
  end
    Log.Defaults.Parameter5=str2num(get(Fig.Parameter5,'String'));
  if isempty(Log.Defaults.Parameter5)
     close(Fig.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
     return
  end
%   Log.Defaults.Parameter6=str2num(get(Fig.Parameter6,'String'));
%   if isempty(Log.Defaults.Parameter6)
%      close(Fig.Figure)
%      warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
%      return
%   end
  Log.Defaults.Parameter7=str2num(get(Fig.Parameter7,'String'));
  if isempty(Log.Defaults.Parameter7)
     close(Fig.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
     return
  end
  Log.Defaults.Par8=0;

Label=get(Fig.Parameter6,'String');
if length(Label)>3
    Label
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
      es=1;
    return
elseif length(Label)<3
    offby=3-length(Label);
    switch offby
        case 1
            Label=[Label,' '];
        case 2
            Label=[Label,'  '];
    end
end
   
NewData=Data{Z};
blockout=Log.Defaults.Parameter3*Log.Head.SRate/1000;
if Log.Defaults.Parameter5>=Log.Head.SRate/2-0.02*2/Log.Head.SRate;
   Log.Defaults.Parameter5=Log.Head.SRate/2-(0.0200001/2*Log.Head.SRate);
elseif Log.Defaults.Parameter5<=0
   Log.Defaults.Parameter5=0.0001;
end
Rp=1;
Rs=.1;
f = [0 Log.Defaults.Parameter5*2/Log.Head.SRate Log.Defaults.Parameter5*2/Log.Head.SRate+0.02 1];
m = [1  1  0 0];
devs = [ (10^(Rp/20)-1)/(10^(Rp/20)+1)  10^(-Rs/20) ];
w = [1 1]*max(devs)./devs;
%order=Log.Defaults.Parameter6;
order=30;
B=firls(order,f,m,w);
Threshold=-5;

% NR DR are the Numerator and Denominator Coefficients for the Repolarization filter
load DataCh
Noise=DataCh;

bbb=0;
%-----------------------------
h=waitbar(1/length(ChLabel(:,1)),'Calculating Repolarization Times');
for i=1:length(ChLabel(:,1))
  fiducialX=[]; 
  AP=0;
  DataCh=NewData(ChLabel(i,2),X1X2(1):X1X2(2));
  DataCh=DataCh-min(DataCh);
  Smooth=filter(B,1,DataCh);
  Boxcar2=21;
  Smooth=filter(ones(1,Boxcar2),1,Smooth);

  Smooth=Smooth(round((length(B)+Boxcar2)/2):end);
     % FIRLS SEEMS TO HAVE A SHIFT BUILT IN. IGNORE THE NEXT LINE
     %     Smooth=Smooth(round(length(B)/2):end);
     
  X1=[X1X2(1):X1X2(2)];
  X2=[X1X2(1):X1X2(2)-1];
% datadiff=diff(DataCh);
 temp=PeakDetection(DataCh,Log.Head.SRate,Log.Defaults.Parameter1,Log.Defaults.Parameter2,Log.Defaults.Parameter3,Log.Defaults.Parameter4);
%  Log.Defaults.Parameter4
if Log.Defaults.Parameter4>0
    Smooth=-Smooth;
end

 if temp~=0
    fiducialX = X1(temp);
 % fiducialY = NewData(channel,fiducialX);
 for count=1:length(fiducialX);
     Temp=diff(Smooth);
     Temp=diff(Temp);
     Is=(fiducialX(count)-X1X2(1)+blockout);
if length(fiducialX)>count & (fiducialX(count)+blockout)<length(Temp)+X1X2(1)-10
%      if (fiducialX(count+1)-X1X2(1)-blockout)<=Is
     if (fiducialX(count+1)-X1X2(1)-blockout/3)<=Is
%       close(h)
%		  close(Fig.Figure)
%		  warndlg('Hey Man, you did not read the SLP did you? Blockout too big. Think smaller')
%        return
     else
%         Peakr=find(Temp==max(Temp(Is:fiducialX(count+1)-X1X2(1)-blockout)));
        Peakr=find(Temp==min(Temp(Is:fiducialX(count+1)-X1X2(1)-blockout/3)));
        Annote_Out=[Annote_Out;ChLabel(i,1) Peakr(1) Label];
     end
     
elseif (fiducialX(count)+blockout)<length(Temp)+X1X2(1)-30  
    if Log.Defaults.Parameter4>0
        Peakr=find(Temp(Is:end)==min(Temp(Is:end)));
    else
        Peakr=find(Temp(Is:end)==max(Temp(Is:end)));
    end     
      Peakr(1)=Peakr(1)+Is-1;
 %     if Y(1)<max(Temp)/2
	     Annote_Out=[Annote_Out;ChLabel(i,1) Peakr(1) Label];
 %     end

%break
 
end
%       if i==1211
      if 1==2
          fiducialX(count+1)-X1X2(1)-10
          Is
            figure(10)
            plot(DataCh,'r')
            hold
%           plot(10*diff(diff(DataCh)),'g')
            plot(Temp)
            hold off
            Peakr(1)
            line([Peakr(1) Peakr(1)],[max(Temp) min(Temp)]);
            line([0 length(Temp)],[max(Temp)/5 max(Temp)/5]);
            pause
      end

  end
waitbar(i/length(ChLabel(:,1)),h);
end
end
close(h)
Annote_Out(:,2)=Annote_Out(:,2)+X1X2(1);
Annote_Out=[Annote;Annote_Out];
close(Fig.Figure)
%-----------------------------
elseif contin==4
   close(Fig.Figure)
   return
end
