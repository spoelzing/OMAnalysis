function [Label,Comment,Annote_Out]=Steve_SecondWave(Z,X1X2,ChLabel,Annote)
% AUTHOR: Steve)
% DATE LAST MODIFIED: 05/28/2013
% Calculating timing and amplitude of SCR's, DAD's and Subthreshold stimuli


Parameter1Description=('Length of the boxcar filter (Positive Odd Integers)');
Parameter2Description=('Number of consecutive sample points defining a peak (Positive Integers)(Sample Points)');
Parameter3Description=('Blockout interval after detection of peak (Positive Integers)(msec)');
Parameter4Description=('Peak amplitude and direction multplier factor (-5 to 5)');
Parameter5Description=(' ');
Parameter6Description=('Time To Peak Label');
Parameter7Description=(' ');

% ENTER PARAMETER DEFAULTS
P1Default=3;
P2Default=5;
P3Default=200;
P4Default=1.1;
P5Default=6;
P6Default=0;
P7Default=0;
es=0;

PDefaults=[P1Default;P2Default;P3Default;P4Default;P5Default;P6Default;P7Default];



Annote_Out=[]; 
global Log
global Data
global Fig
global Stripchart
Label='TTP';
Comment='Time To Peak';
contin=ActInterface(Parameter1Description,Parameter2Description,Parameter3Description,Parameter4Description,Parameter5Description,Parameter6Description,Parameter7Description,PDefaults,Label);

NewAnnote1=[];
NewAnnote2=[];
NewAnnote3=[];
NewAnnote4=[];   
 n=1;  
if contin==1
NewData=Data{Z};

%%%%%%%%%%%%%%%%%%%%%    ERROR CHEKCING GOES IN THE LINES BELOW

Log.Defaults.Parameter1=str2num(get(Fig.Parameter1,'String'));
  if isempty(Log.Defaults.Parameter1) | Log.Defaults.Parameter1<0 | rem(Log.Defaults.Parameter1,2)==0
     close(Fig.Figure)
      es=1;
    warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
     return
  end
  Log.Defaults.Parameter2=str2num(get(Fig.Parameter2,'String'));
  if isempty(Log.Defaults.Parameter2) | Log.Defaults.Parameter2<0
     close(Fig.Figure)
      es=1;
    warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
     return
  end
  Log.Defaults.Parameter3=str2num(get(Fig.Parameter3,'String'));
  if isempty(Log.Defaults.Parameter3) | Log.Defaults.Parameter2<0
     close(Fig.Figure)
      es=1;
    warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
      return
 end
  Log.Defaults.Parameter4=str2num(get(Fig.Parameter4,'String'));
  if isempty(Log.Defaults.Parameter4)
     close(Fig.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
     es=1;
     return
  end
  Log.Defaults.Parameter5=str2num(get(Fig.Parameter5,'String'));
  Log.Defaults.Par5=Log.Defaults.Parameter5;
  if isempty(Log.Defaults.Parameter5)
     close(Fig.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
     es=1;
     return
  end
  Log.Defaults.Parameter6=get(Fig.Parameter6,'String');
  Log.Defaults.Par6=Log.Defaults.Parameter6;
  if isempty(Log.Defaults.Parameter6)
     close(Fig.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
      es=1;
    return
  end
  Log.Defaults.Parameter7=str2num(get(Fig.Parameter7,'String'));
  Log.Defaults.Par7=Log.Defaults.Parameter7;
  if isempty(Log.Defaults.Parameter7)
     close(Fig.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
      es=1;
    return
  end
Log.Defaults.Par8=0;


Label=get(Fig.Parameter6,'String');
if length(Label)>3
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


    
%%%%%%%%%%%%%%%%%%%%      END ERROR CHECKING

   h=waitbar(0,'Calculating Activation Time');
for i=1:(length(ChLabel(:,1)))
    fiducialX=[];
  Blockout=Log.Defaults.Parameter3;
  % USER SELECTABLE OPTIONS %
  channel = ChLabel(i,2);
  X1=[X1X2(1):X1X2(2)];
  NewDataCh=NewData(channel,X1X2(1):X1X2(2));
  temp=PeakDetection(NewDataCh,Log.Head.SRate,Log.Defaults.Parameter1,Log.Defaults.Parameter2,Log.Defaults.Parameter3,Log.Defaults.Parameter4);
  if temp==-1
        return
  end
  
  if temp~=0 & temp>1 
  fiducialX = X1(temp)-X1X2(1);
  fiducialX=fiducialX(1);
%   fiducialY = NewData(channel,fiducialX); %This is the amplitude of the signal at a fiducial
%   for count=1:length(fiducialX);
%     Annote_Out=[Annote_Out;ChLabel(i,1) fiducialX(count) Label];
%   end
   NewDataCh=NewDataCh-NewDataCh(1);
   FiltSignal=conv2(NewDataCh,ones(1,Log.Defaults.Parameter1+8),'same');
   FiltdataCh=Log.Defaults.Parameter4/abs(Log.Defaults.Parameter4)*FiltSignal; % Make the signal upright
%    figure(10)
%    plot(FiltdataCh)
   [h1,i1]=max(FiltdataCh);

   
if (i1-4>1) & (i1+4<X1X2(2)-X1X2(1))
   maxval=median(FiltdataCh(i1-4:i1+4));
   minval=median(FiltdataCh(1:fiducialX));
   Twowav=FiltdataCh(fiducialX+Blockout:end);
   [TwondwavAmp,i3]=max(Twowav);

   TwowavTime=i3+Blockout+fiducialX;

  if fiducialX+Blockout+i3<X1X2(2)-X1X2(1)

      Twowav2=FiltdataCh(fiducialX:fiducialX+Blockout+i3);
     [y,i4]=min(Twowav2);
      min2ndwavt=i4+fiducialX;
      WaveAmp=(TwondwavAmp-y)/(maxval-minval)*100;
      ttp=TwowavTime+X1X2(1)-fiducialX;
  if WaveAmp>10 && WaveAmp<100 && ttp>(fiducialX+X1X2(1)+Blockout)%& (maxval-minval)/std(FiltdataCh(1:fiducialX))>5
       
%   if channel==1820
%   disp('*******************************1')
%       figure(9)
%       plot(Twowav)
%       figure(10)
%       plot(FiltdataCh)
%       Xs=[min2ndwavt-1 min2ndwavt-1];
%       Xs2=[TwowavTime TwowavTime];
%       Ys=[max(FiltdataCh)+10 min(FiltdataCh)-10];
%       line(Xs,Ys);
%       line(Xs2,Ys);
%       SNR=(maxval-minval)/std(FiltdataCh(1:fiducialX))
%       WaveAmp
%       disp('*************************2')
%       pause(0.1)
%   end

MP(n,1)=ttp;
MP(n,2)=WaveAmp+X1X2(1);
n=n+1;
   NewAnnote1=[NewAnnote1;ChLabel(i,1) TwowavTime+X1X2(1) 'TOP'];  
   NewAnnote2=[NewAnnote2;ChLabel(i,1) TwowavTime+X1X2(1)-fiducialX 'TTP'];
   NewAnnote3=[NewAnnote3;ChLabel(i,1) WaveAmp+X1X2(1) 'WAm'];  
  
      end % Associated with checking Wave Amplitude greater than 10%
      end % Associated with i1 check
  end % Associated with i3 check
  
  
waitbar(i/length(ChLabel(:,1)),h);
end
end
close(h)
Zeng_Analysis('Existing Check',Stripchart.Figure,'TOP','Time OF Peak',[Annote;NewAnnote1])
Annote=[Annote;NewAnnote1];
Zeng_Analysis('Existing Check',Stripchart.Figure,'TTP','Time TTP Peak',[Annote;NewAnnote2])
Annote=[Annote;NewAnnote2];
Zeng_Analysis('Existing Check',Stripchart.Figure,'WAm','Wave Amplitude',[Annote;NewAnnote3])
Annote=[Annote;NewAnnote3];
close(Fig.Figure)
figure
MP=MP-X1X2(1);
plot(MP(:,1),MP(:,2))
xlabel('Time to Peak (ms)')
ylabel('Amplitude (% S1)')
disp('********************')
[R,P]=corrcoef(MP(:,2),MP(:,1));
val=polyfit(MP(:,1),MP(:,2),1);
m=val(1) % slope of the line. y=mx+b. where x is ttp, and y is WaveAmp
b=val(2) % y-intercept
Rval=R(1,2)
pval=P(1,2)

elseif contin==4
   close(Fig.Figure)
   return
end






