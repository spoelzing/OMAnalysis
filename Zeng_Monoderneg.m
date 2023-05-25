function [Label,Comment,Annote_Out]=Zeng_MonoDerNeg(Z,X1X2,ChLabel,Annote)
% AUTHOR: TinTon (tony magni)
% DATE LAST MODIFIED: 04/01/08
% Signal Avereging software

% new in average6:
% PeakDetection exported to PeakDetection.m and documented
%   

% new in average5:
% PEAKS initialized to empty array, to avoid errors when no peaks
% found.
% for loop to go through all channels.
  

% new in average4:
% made slopewindow be all points that are below Parameter4 (in
% derivative)
% perform all derivative analysis on Parameter1ed derivaitve
% Parameter1 function converted to convolution method, rather than
% analytic.
% made switch statement for pos or neg peak detection in peak
% detection function.

% new in average3:
% added Parameter1 function from average2
% removed all commented code from average2

% ENTER DESCRIPTION FOR PARAMTERS
Parameter1Description=('Length of the boxcar filter (Positive Odd Integers)');
Parameter2Description=('Number of consecutive sample points defining a peak (Positive Integers)(Sample Points)');
Parameter3Description=('Blockout interval after detection of peak (Positive Integers)(msec)');
Parameter4Description=('Peak amplitude and direction multplier factor (-5 to 5)');
Parameter5Description=(' ');
Parameter6Description=('Activation Time Label');
Parameter7Description=(' ');

% ENTER PARAMETER DEFAULTS
P1Default=3;
P2Default=5;
P3Default=120;
P4Default=-1.1;
P5Default=6;
P6Default=0;
P7Default=0;
es=0;

PDefaults=[P1Default;P2Default;P3Default;P4Default;P5Default;P6Default;P7Default];

Label='AT ';
Comment='Activation Time';
Annote_Out=[]; 
global Log
global Data
global PARAMETERSTRING Parameter4 TPRATIO
global Fig
global Stripchart
contin=ActInterface(Parameter1Description,Parameter2Description,Parameter3Description,Parameter4Description,Parameter5Description,Parameter6Description,Parameter7Description,PDefaults,Label);

if contin==1
NewData=Data{Z};
TPRATIO=[];

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
  % USER SELECTABLE OPTIONS %
  channel = ChLabel(i,2);
  X1=[X1X2(1):X1X2(2)];
  X2=[X1X2(1):X1X2(2)-1];
  datadiff=diff(NewData(channel,X1));
  
  temp=PeakDetection(NewData(channel,X1),Log.Head.SRate,Log.Defaults.Parameter1,Log.Defaults.Parameter2,Log.Defaults.Parameter3,Log.Defaults.Parameter4);
  if temp==-1
        return
  end
  
  if temp~=0
  fiducialX = X1(temp);
  fiducialY = NewData(channel,fiducialX);
  for count=1:length(fiducialX);
    Annote_Out=[Annote_Out;ChLabel(i,1) fiducialX(count) Label];
  end
waitbar(i/length(ChLabel(:,1)),h);
end
end
close(h)
Annote_Out=[Annote;Annote_Out];
close(Fig.Figure)
elseif contin==4
   close(Fig.Figure)
   return
end






