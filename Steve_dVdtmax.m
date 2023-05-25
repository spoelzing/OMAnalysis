function [Label,Comment,Annote_Out]=Steve_dVdtmax(Z,X1X2,ChLabel,Annote) 
global Log
global Data
global PARAMETERSTRING Parameter4 TPRATIO
global Fig
global Stripchart

%-----------------------------

% ENTER DESCRIPTION FOR PARAMTERS
Parameter1Description=('Length of the boxcar filter (Positive Odd Numbers)');
Parameter2Description=('Number of consecutive sample points defining a peak (Positive Numbers)(Sample Points)');
Parameter3Description=('Blockout interval after detection of peak (Positive Numbers)(msec)');
Parameter4Description=('Peak amplitude and direction multplier factor (-5 to 5)');
Parameter5Description=('Slope Window (Points before and after AT)');
Parameter6Description=('Takeoff Threshold (Percentage. ie. 10% of upstroke)');
Parameter7Description=('Peak Threshold (Percentage. ie. 90% of upstroke)');
P1Default=3;
P2Default=5;
P3Default=50;
P4Default=-0.7;
P5Default=2;
P6Default=10;
P7Default=90;
P8Default=0;
PDefaults=[P1Default;P2Default;P3Default;P4Default;P5Default;P6Default;P7Default;P8Default];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NewAnnote1=[];
NewAnnote2=[];
NewAnnote3=[];
Label='AT';
Annote_Out=[];
% Fig.Annote=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


contin=RTInterface(Parameter1Description,Parameter2Description,Parameter3Description,Parameter4Description,Parameter5Description,Parameter6Description,Parameter7Description,PDefaults,Label);



if contin==1;
NewData=Data{Z};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%    ERROR CHEKCING GOES IN THE LINES BELOW
Log.Defaults.Parameter1=str2num(get(Fig.Parameter1,'String'));
  if isempty(Log.Defaults.Parameter1) | Log.Defaults.Parameter1<0 | rem(Log.Defaults.Parameter1,2)==0
     close(Fig.Figure)
      es=1;
    warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED. Err. 1')
     return
  end
  Log.Defaults.Parameter2=str2num(get(Fig.Parameter2,'String'));
  if isempty(Log.Defaults.Parameter2) | Log.Defaults.Parameter2<0
     close(Fig.Figure)
      es=1;
    warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED. Err. 2')
     return
  end
  Log.Defaults.Parameter3=str2num(get(Fig.Parameter3,'String'));
  if isempty(Log.Defaults.Parameter3) | Log.Defaults.Parameter3>(X1X2(2)-X1X2(1))
     close(Fig.Figure)
      es=1;
    warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED. Blockout too large')
      return
 end
  Log.Defaults.Parameter4=str2num(get(Fig.Parameter4,'String'));
  if isempty(Log.Defaults.Parameter4)
     close(Fig.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED. Err. 4')
     es=1;
     return
  end
  Log.Defaults.Parameter5=str2num(get(Fig.Parameter5,'String'));
  Log.Defaults.Par5=Log.Defaults.Parameter5;
  if isempty(Log.Defaults.Parameter5)
     close(Fig.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED. Err. 5')
     es=1;
     return
  end
  Log.Defaults.Parameter6=str2num(get(Fig.Parameter6,'String'));
  Log.Defaults.Par6=Log.Defaults.Parameter6;
  if isempty(Log.Defaults.Parameter6)
     close(Fig.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED. Err. 6')
      es=1;
    return
  end
  Log.Defaults.Parameter7=str2num(get(Fig.Parameter7,'String'));
  Log.Defaults.Par7=Log.Defaults.Parameter7;
  if isempty(Log.Defaults.Parameter7)
     close(Fig.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED. Err. 7')
      es=1;
    return
  end


%%%%%%%%%%%%%%%%%%%%      END ERROR CHECKING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h=waitbar(0,'Calculating Activation Time');
for i=1:(length(ChLabel(:,1)))
%   fiducialX=[];
  channel = ChLabel(i,2);
  X1=[X1X2(1):X1X2(2)];
   AT=PeakDetection(NewData(channel,X1),Log.Head.SRate,Log.Defaults.Parameter1,Log.Defaults.Parameter2,Log.Defaults.Parameter3,Log.Defaults.Parameter4);
   DataCh=NewData(i,X1X2(1):X1X2(2))/Log.Defaults.Parameter4/abs(Log.Defaults.Parameter4);
    [xdim ydim]=size(DataCh);
if AT~=0
    [y minindex]=min(DataCh(1:AT));
    if minindex>3 & minindex<ydim-3
        DataCh2=(DataCh-mean(DataCh(minindex-3:minindex+3)))*100/max(DataCh);
    else 
        if minindex<4
            DataCh2=(DataCh-mean(DataCh(minindex:minindex+3)))*100/max(DataCh);
        elseif minindex<ydim-4
            DataCh2=(DataCh-mean(DataCh(minindex-3:minindex)))*100/max(DataCh);
        end
    end
   Amp=max(DataCh2);
   EndRT=find(DataCh2(minindex:end)>=Log.Defaults.Parameter7/100*Amp)+minindex-1;
if ~isempty(EndRT) & EndRT(1)<ydim
      temp=fliplr(DataCh2);
      temp2=find(temp(ydim-EndRT(1):end)<=(Log.Defaults.Parameter6)/100*Amp);
      temp3=length(temp(ydim-EndRT(1):end));
      StartRT=temp3-temp2+1;
else
    StartRT=[];
end

   if i==0
    
      AT
      StartRT
      EndRT
      figure(10)
      plot(DataCh2)
   end
   
   if ~isempty(StartRT) & ~isempty(EndRT)
       Risetime(i)=EndRT(1)-StartRT(1);  
       dVdt=round(regress(DataCh2(AT-1:AT+2)',[0:1/Log.Head.SRate:3/Log.Head.SRate]'));
       if Risetime(i)<2
          Risetime(i)=[];
       elseif Risetime(i)>20;
          Risetime(i)=[];
       elseif StartRT(1)<=AT & EndRT(1)>AT
    %    if 1==2
    %     figure(100)
    %     plot(DataCh2)
    %     a=line([StartRT(1) StartRT(1)],[0 Amp]);
    %     set(a,'Color',[1 0 0])
    %     b=line([EndRT(1) EndRT(1)],[0 Amp]);
    %     set(b,'Color',[0 1 0])
    %     pause(0.1)   
    %    end 
        NewAnnote1=[NewAnnote1;ChLabel(i,1) StartRT(1)+X1X2(1)-1 'SRT'];  
        NewAnnote2=[NewAnnote2;ChLabel(i,1) EndRT(1)+X1X2(1)-1 'ERT'];      
        NewAnnote3=[NewAnnote3;ChLabel(i,1) dVdt/1000+X1X2(1)-1 'dVt'];  
       end
     else
       Risetime(i)=-1;
   end

  waitbar(i/length(ChLabel(:,1)),h);
end
end
Fig.Annote=[Annote;NewAnnote1];
Zeng_Analysis('Existing Check',Stripchart.Figure,'SRT','Start Rise Time',Fig.Annote)
Fig.Annote=[Stripchart.Annote.Array;NewAnnote2];
Zeng_Analysis('Existing Check',Stripchart.Figure,'ERT','End Rise Time  ',Fig.Annote)
Fig.Annote=[Stripchart.Annote.Array;NewAnnote3];
Zeng_Analysis('Existing Check',Stripchart.Figure,'dVt','dVdt Max       ',Fig.Annote)

close(h)

end

try 
        close(Fig.Figure)
end

end

   
