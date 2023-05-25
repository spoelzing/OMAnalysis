function [varargout]=Zeng_Percent2(varargin)


action = varargin{1};
global Data
global Fig
global Log
global Stripchart
warning off
switch action
case 'Initial'
 Fig=[];
Fig.avgarray=[];   
Fig.X1X2=varargin{11};
Fig.ChLabel=varargin{10};
Fig.Annote=varargin{12};

Log.Steve.Figure=figure(8);

	   FG_Size(3:4)=[600 500];
   	FG_Size(1:2)=[Log.UD.ScreenSize(1)-FG_Size(3)*1.7 Log.UD.ScreenSize(2)-FG_Size(4)*1.1-40 ];
   
	   set(Log.Steve.Figure,...
         'Color',[0.8 0.8 0.8], ...
         'Menu','none',...
         'Name','Percent Repolarization Parameter Window',...
         'NumberTitle','off',...
         'Position',FG_Size, ...
         'Tag','FigFigure');
      Log.Steve.Figure=findobj('Tag','FigFigure');
  Fig.Frame1 = uicontrol('Parent',Log.Steve.Figure, ...
			 'Units','pixels', ...
			 'BackgroundColor',[0.8 0.8 0.8], ...
			 'ListboxTop',0, ...
			 'Position',[10 (FG_Size(3)-345) (FG_Size(3)-10) (FG_Size(4)-255)], ...
			 'Style','frame', ...
			 'Tag','Frame1');
  ExplanationSize=[20 (FG_Size(4)-30) FG_Size(3)-120 20];
  Explanation = uicontrol('Parent',Log.Steve.Figure, ...
			  'BackgroundColor',[0.8 .8 .8],...
			  'FontName','Arial',...
			  'FontUnits','points',...
			  'FontSize',14,...
			  'FontWeight','normal',...
			  'FontAngle','normal',...
			  'HorizontalAlignment','Left',...
			  'Units','pixels',...
			  'Position',ExplanationSize, ...
			  'String','Peak Detection Parameters',...
			  'style','text');
      
      
      
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETER 1      
  ExplanationSize=[90 (FG_Size(4)-72) FG_Size(3)-120 20];
  Explanation = uicontrol('Parent',Log.Steve.Figure, ...
			  'BackgroundColor',[0.8 .8 .8],...
			  'FontName','Arial',...
			  'FontUnits','points',...
			  'FontSize',Log.UD.Ref.FontSize,...
			  'FontWeight','normal',...
			  'FontAngle','normal',...
			  'HorizontalAlignment','Left',...
			  'Units','pixels',...
			  'Position',ExplanationSize, ...
			  'String',varargin{2},...
			  'style','text');

  Fig.Parameter1Size=[20 (FG_Size(4)-70) 60 22];  
  Fig.Parameter1 = uicontrol('Parent',Log.Steve.Figure, ...
			     'Units','pixels', ...
			     'BackgroundColor',[1 1 1], ...
			     'ListboxTop',0, ...
			     'Position',Fig.Parameter1Size, ...
			     'String',varargin{9}(1,:), ...
			     'Style','edit', ...
			     'Tag','EditText1');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETER 2      
  ExplanationSize=[90 (FG_Size(4)-112) FG_Size(3)-120 20];
  Explanation = uicontrol('Parent',Log.Steve.Figure, ...
			  'BackgroundColor',[0.8 .8 .8],...
			  'FontName','Arial',...
			  'FontUnits','points',...
			  'FontSize',Log.UD.Ref.FontSize,...
			  'FontWeight','normal',...
			  'FontAngle','normal',...
			  'HorizontalAlignment','Left',...
			  'Units','pixels',...
			  'Position',ExplanationSize, ...
			  'String',varargin{3},...
			  'style','text');
     
  Fig.Parameter2Size=[20 (FG_Size(4)-110) 60 22];
  Fig.Parameter2 = uicontrol('Parent',Log.Steve.Figure, ...
			     'Units','pixels', ...
			     'BackgroundColor',[1 1 1], ...
			     'ListboxTop',0, ...
			     'Position',Fig.Parameter2Size, ...
			     'String',varargin{9}(2,:), ...
			     'Style','edit', ...
			     'Tag','EditText1');

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETER 3      
  ExplanationSize=[90 (FG_Size(4)-152) FG_Size(3)-120 20];
  Explanation = uicontrol('Parent',Log.Steve.Figure, ...
			  'BackgroundColor',[0.8 .8 .8],...
			  'FontName','Arial',...
			  'FontUnits','points',...
			  'FontSize',Log.UD.Ref.FontSize,...
			  'FontWeight','normal',...
			  'FontAngle','normal',...
			  'HorizontalAlignment','Left',...
			  'Units','pixels',...
			  'Position',ExplanationSize, ...
			  'String',varargin{4},...
			  'style','text');
  
  Fig.Parameter3Size=[20 (FG_Size(4)-150) 60 22];
  Fig.Parameter3 = uicontrol('Parent',Log.Steve.Figure, ...
			     'Units','pixels', ...
			     'BackgroundColor',[1 1 1], ...
			     'ListboxTop',0, ...
			     'Position',Fig.Parameter3Size, ...
			     'String',varargin{9}(3,:), ...
			     'Style','edit', ...
			     'Tag','EditText1');
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETER 4      
  ExplanationSize=[90 (FG_Size(4)-192) FG_Size(3)-120 20];
  Explanation = uicontrol('Parent',Log.Steve.Figure, ...
			  'BackgroundColor',[0.8 .8 .8],...
			  'FontName','Arial',...
			  'FontUnits','points',...
			  'FontSize',Log.UD.Ref.FontSize,...
			  'FontWeight','normal',...
			  'FontAngle','normal',...
			  'HorizontalAlignment','Left',...
			  'Units','pixels',...
			  'Position',ExplanationSize, ...
			  'String',varargin{5},...
			  'style','text');
  
  Fig.Parameter4Size=[20 (FG_Size(4)-190) 60 22];
  Fig.Parameter4 = uicontrol('Parent',Log.Steve.Figure, ...
			     'Units','pixels', ...
			     'BackgroundColor',[1 1 1], ...
			     'ListboxTop',0, ...
			     'Position',Fig.Parameter4Size, ...
			     'String',varargin{9}(4,:), ...
			     'Style','edit', ...
			     'Tag','EditText1');
      
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETER 5 
  Fig.Frame1 = uicontrol('Parent',Log.Steve.Figure, ...
			 'Units','pixels', ...
			 'BackgroundColor',[0.8 0.8 0.8], ...
			 'ListboxTop',0, ...
			 'Position',[10 (FG_Size(3)-500) (FG_Size(3)-10) (FG_Size(4)-300)], ...
			 'Style','frame', ...
			 'Tag','Frame1');
  
  ExplanationSize=[20 (FG_Size(4)-230) FG_Size(3)-120 25];
  Explanation = uicontrol('Parent',Log.Steve.Figure, ...
			  'BackgroundColor',[0.8 .8 .8],...
			  'FontName','Arial',...
			  'FontUnits','points',...
			  'FontSize',14,...
			  'FontWeight','normal',...
			  'FontAngle','normal',...
			  'HorizontalAlignment','Left',...
			  'Units','pixels',...
			  'Position',ExplanationSize, ...
			  'String','Repolarization Parameters',...
			  'style','text');
  ExplanationSize=[90 (FG_Size(4)-262) FG_Size(3)-120 22];
  Explanation = uicontrol('Parent',Log.Steve.Figure, ...
			  'BackgroundColor',[0.8 .8 .8],...
			  'FontName','Arial',...
			  'FontUnits','points',...
			  'FontSize',Log.UD.Ref.FontSize,...
			  'FontWeight','normal',...
			  'FontAngle','normal',...
			  'HorizontalAlignment','Left',...
			  'Units','pixels',...
			  'Position',ExplanationSize, ...
			  'String',varargin{6},...
			  'style','text');
      
  Fig.Parameter5Size=[20 (FG_Size(4)-260) 60 22];
  Fig.Parameter5 = uicontrol('Parent',Log.Steve.Figure, ...
			     'Units','pixels', ...
			     'BackgroundColor',[1 1 1], ...
			     'ListboxTop',0, ...
			     'Position',Fig.Parameter5Size, ...
			     'Style','edit', ...
			     'String',varargin{9}(5,:), ...
			     'Tag','EditText1');


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETER 6
  ExplanationSize=[90 (FG_Size(4)-300) FG_Size(3)-120 20];
  Explanation = uicontrol('Parent',Log.Steve.Figure, ...
			  'BackgroundColor',[0.8 .8 .8],...
			  'FontName','Arial',...
			  'FontUnits','points',...
			  'FontSize',Log.UD.Ref.FontSize,...
			  'FontWeight','normal',...
			  'FontAngle','normal',...
			  'HorizontalAlignment','Left',...
			  'Units','pixels',...
			  'Position',ExplanationSize, ...
			  'String',varargin{7},...
			  'style','text');
      
  Fig.Parameter6Size=[20 (FG_Size(4)-300) 60 22];
  Fig.Parameter6 = uicontrol('Parent',Log.Steve.Figure, ...
			     'Units','pixels', ...
			     'BackgroundColor',[1 1 1], ...
			     'ListboxTop',0, ...
			     'Position',Fig.Parameter6Size, ...
			     'Style','edit', ...
			     'String',varargin{9}(6,:), ...
			     'Tag','EditText1');


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PARAMETER 7      
  ExplanationSize=[90 (FG_Size(4)-330) FG_Size(3)-120 20];
  Explanation = uicontrol('Parent',Log.Steve.Figure, ...
			  'BackgroundColor',[0.8 .8 .8],...
			  'FontName','Arial',...
			  'FontUnits','points',...
			  'FontSize',Log.UD.Ref.FontSize,...
			  'FontWeight','normal',...
			  'FontAngle','normal',...
			  'HorizontalAlignment','Left',...
			  'Units','pixels',...
			  'Position',ExplanationSize, ...
			  'String',varargin{8},...
			  'style','text');
      
  Fig.Parameter7Size=[20 (FG_Size(4)-330) 60 22];
  Fig.Parameter7 = uicontrol('Parent',Log.Steve.Figure, ...
			     'Units','pixels', ...
			     'BackgroundColor',[1 1 1], ...
			     'ListboxTop',0, ...
			     'Position',Fig.Parameter7Size, ...
			     'Style','edit', ...
			     'String',varargin{9}(7,:), ...
			     'visible','on',...
			     'Tag','EditText1');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   END OF PARAMETER SPECIFICATIONS    %%%%%%%

Fig.ContinueSize=[FG_Size(3)/5-60/2 10 60 22];
Fig.Continue = uicontrol('Parent',Log.Steve.Figure, ...
	'Units','pixels', ...
   'Callback','Zeng_Percent2 Run',...
   'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
   'ListboxTop',0, ...
	'Position',Fig.ContinueSize, ...
	'String','Run', ...
   'Style','Pushbutton', ...
   'Value',0,...
   'Tag','Pushbutton1');

Fig.CancelSize=[FG_Size(3)*2/4-60/2 10 60 22];
Fig.Cancel = uicontrol('Parent',Log.Steve.Figure, ...
     'Units','pixels',...
     'Callback','Zeng_Percent2 Cancel',...
     'FontName','Arial',...
     'FontUnits','points',...
     'FontSize',Log.UD.Ref.FontSize,...
     'FontWeight','normal',...
     'FontAngle','normal',...
     'Position',Fig.CancelSize, ...
     'String','Cancel', ...
     'Style','Pushbutton',...
     'Tag','Pushbutton2');
Fig.RestoreSize=[FG_Size(3)*7.2/9-60/2 10 60 22];
Fig.Restore = uicontrol('Parent',Log.Steve.Figure, ...
     'Units','pixels',...
     'Callback','Zeng_Percent2 Restore',...
     'FontName','Arial',...
     'FontUnits','points',...
     'FontSize',Log.UD.Ref.FontSize,...
     'FontWeight','normal',...
     'FontAngle','normal',...
     'Position',Fig.RestoreSize, ...
     'String','Default', ...
     'Style','pushbutton',...
     'Tag','Pushbutton1');
 Temp.File={
      'File'                       '                         '
     '>Load Variables...   '       'GetFile(''Load'')       '
     '>Save Variables...   '       'GetFile(''Save'')       '};
makemenu(Log.Steve.Figure,char(Temp.File(:,1)),char(Temp.File(:,2)));
Checkboxsize=[20 (FG_Size(4)-250) 125 20];    


  Checkboxsize=[20 (FG_Size(4)-360) 190 20];      
  Fig.Med=	uicontrol('Parent',Log.Steve.Figure, ...
			  'Units','pixels',...
			  'FontName','Arial',...
			  'FontUnits','points',...
			  'FontSize',Log.UD.Ref.FontSize,...
			  'FontWeight','normal',...
			  'FontAngle','normal',...
			  'Position',Checkboxsize,...
			  'Style','Checkbox',...
			  'String','Choose Baseline using Median value', ...
			  'callback','Zeng_Percent2(''Global'')',...  
			  'Value',1,...
			  'Tag','Pushbutton1'); 
  Checkboxsize=[20 (FG_Size(4)-390) 190 20];      
  Fig.Min=uicontrol('Parent',Log.Steve.Figure, ...
		      'Units','pixels',...
		      'FontName','Arial',...
		      'FontUnits','points',...
		      'FontSize',Log.UD.Ref.FontSize,...
		      'FontWeight','normal',...
		      'FontAngle','normal',...
		      'Position',Checkboxsize,...
		      'Style','Checkbox',...
		      'String','Choose Baseline using Minimum value', ...
		      'callback','Zeng_Percent2(''Local'')',...  
		      'Value',0,...
		      'Tag','Pushbutton1'); 
  Checkboxsize=[20 (FG_Size(4)-430) 220 20];      
  Fig.Save=uicontrol('Parent',Log.Steve.Figure, ...
		      'Units','pixels',...
		      'FontName','Arial',...
		      'FontUnits','points',...
		      'FontSize',Log.UD.Ref.FontSize,...
		      'FontWeight','normal',...
		      'FontAngle','normal',...
		      'Position',Checkboxsize,...
		      'Style','Checkbox',...
		      'String','Save Channel/Bas/Max Values in ASCII Format', ...
		      'Value',0,...
		      'Tag','Pushbutton1'); 
 Checkboxsize=[20 (FG_Size(4)-460) 220 20];      
 Fig.Output=uicontrol('Parent',Log.Steve.Figure, ...
		      'Units','pixels',...
		      'FontName','Arial',...
		      'FontUnits','points',...
		      'FontSize',Log.UD.Ref.FontSize,...
		      'FontWeight','normal',...
		      'FontAngle','normal',...
		      'Position',Checkboxsize,...
		      'Style','Checkbox',...
		      'String','Output Bas and Max values to Waveform Window', ...
		      'Value',0,...
		      'Tag','Pushbutton1'); 
  




 Checkboxsize=[20 (FG_Size(4)-430) 190 20];      
 Fig.Exist=	uicontrol('Parent',Log.Steve.Figure, ...
         'Units','pixels',...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Checkboxsize,...
		   'Style','Checkbox',...
         'String','Use Existing Bas/Max Annotations', ...
		   'Value',0,...
         'Tag','Pushbutton1'); 
Fig.AnnoteSelect = uicontrol('Parent',Log.Steve.Figure, ...
   'Units','pixels', ...
   'Callback','Zeng_Percent2(''Annote'')',...
	'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',[155 FG_Size(4)-250 125 20], ...
	'String',' ', ...
	'Style','popupmenu', ...
   'Tag','PopupMenu1', ...
   'visible','off',...
	'Value',1);

if isfield(Log,'Defaults')
   if ~isfield(Log.Defaults,'Parameter1') | isempty(Log.Defaults.Parameter1) 
        set(Fig.Restore,'Value',1)
     elseif isempty(Log.Defaults.Parameter2)
        set(Fig.Restore,'Value',1)
     elseif isempty(Log.Defaults.Parameter3)
        set(Fig.Restore,'Value',1)
     elseif isempty(Log.Defaults.Parameter4)
        set(Fig.Restore,'Value',1)
     elseif ~isfield(Log.Defaults,'ParP5')
        set(Fig.Parameter1,'String',num2str(Log.Defaults.Parameter1));
        set(Fig.Parameter2,'String',num2str(Log.Defaults.Parameter2));
        set(Fig.Parameter3,'String',num2str(Log.Defaults.Parameter3));
        set(Fig.Parameter4,'String',num2str(Log.Defaults.Parameter4));
%        set(Fig.Restore,'Value',1)
%     elseif isempty(Log.Defaults.Par6)
%        set(Fig.Restore,'Value',1)
%     elseif isempty(Log.Defaults.Par7)
%        set(Fig.Restore,'Value',1)
else
        set(Fig.Parameter1,'String',num2str(Log.Defaults.Parameter1));
        set(Fig.Parameter2,'String',num2str(Log.Defaults.Parameter2));
        set(Fig.Parameter3,'String',num2str(Log.Defaults.Parameter3));
        set(Fig.Parameter4,'String',num2str(Log.Defaults.Parameter4));
        set(Fig.Parameter5,'String',num2str(Log.Defaults.ParP5));
        set(Fig.Parameter6,'String',num2str(Log.Defaults.ParP6));
        set(Fig.Parameter7,'String',num2str(Log.Defaults.ParP7));
     end
  end
Fig.Data=Data{2};
if ~isempty(Fig.Annote)
   count=1;
   types=char(Fig.Annote(:,3:5));
   [x y]=size(types);
   Fig.LabelOut(1,:)=types(1,:);
   for q=1:x
      label=types(q,:);
      if label(1,1)~=Fig.LabelOut(count,1) | label(1,2)~=Fig.LabelOut(count,2) | label(1,3)~=Fig.LabelOut(count,3);
         count=count+1;
         Fig.LabelOut(count,:)=label;
      end
   end
set(Fig.AnnoteSelect,'String',Fig.LabelOut);   
end   

if isempty(Fig.Annote)
   set(Fig.Exist,'Visible','off')
else
Temp.index=strmatch('Bas',char(Fig.Annote(:,3:(2+Stripchart.Annote.ShowLength))));
if isempty(Temp.index)
   set(Fig.Exist,'Visible','off')
%   set(Fig.AnnoteSelect,'Visible','off')
end
end



  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
 case 'Global'
  set(Fig.Med,'Value',1);
  set(Fig.Min,'Value',0);
   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
 case 'Local'
  set(Fig.Min,'Value',1);
  set(Fig.Med,'Value',0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  
   
   
   
   
   
case 'Run'
   
NewData=Data{2};
NewAnnote1=[];
NewAnnote2=[];
NewAnnote3=[];
sign=str2num(get(Fig.Parameter4,'String'));
sign=sign/abs(sign);

%%%%%%%%%%%%%%%%%%%%%    ERROR CHEKCING GOES IN THE LINES BELOW

Log.Defaults.Parameter1=str2num(get(Fig.Parameter1,'String'));
  if isempty(Log.Defaults.Parameter1) | Log.Defaults.Parameter1<0 | rem(Log.Defaults.Parameter1,2)==0
     close(Log.Steve.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
     return
  end
  Log.Defaults.Parameter2=str2num(get(Fig.Parameter2,'String'));
  if isempty(Log.Defaults.Parameter2) | Log.Defaults.Parameter2<0
     close(Log.Steve.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
     return
  end
  Log.Defaults.Parameter3=str2num(get(Fig.Parameter3,'String'));
  if isempty(Log.Defaults.Parameter3) | Log.Defaults.Parameter2<0
     close(Log.Steve.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
      return
 end
  Log.Defaults.Parameter4=str2num(get(Fig.Parameter4,'String'));
  if isempty(Log.Defaults.Parameter4)
     close(Log.Steve.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
     return
  end
    Log.Defaults.ParP5=str2num(get(Fig.Parameter5,'String'));
  if isempty(Log.Defaults.ParP5)
     close(Log.Steve.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
     return
  end
  Log.Defaults.ParP6=str2num(get(Fig.Parameter6,'String'));
  if isempty(Log.Defaults.ParP6)
     close(Log.Steve.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
     return
  end
  Log.Defaults.ParP7=str2num(get(Fig.Parameter7,'String'));
  if isempty(Log.Defaults.ParP7)
     close(Log.Steve.Figure)
     warndlg('VALUES WERE INCORRECT. PROGRAM ABORTED')
     return
  end

%%%%%%%%%%%%%%%%%%%%      END ERROR CHECKING
if ~get(Fig.Exist,'Value')
   TPRATIO=[];
if Log.Defaults.ParP7>=Log.Head.SRate/2-0.02*2/Log.Head.SRate;
   Log.Defaults.ParP7=round(Log.Head.SRate/2-(0.0200001/2*Log.Head.SRate));
elseif Log.Defaults.ParP7<=0
   Log.Defaults.ParP7=0.0001;
end
Rp=1;
Rs=.1;
f = [0 Log.Defaults.ParP7*2/Log.Head.SRate Log.Defaults.ParP7*2/Log.Head.SRate+0.02 1];
m = [1  1  0 0];
devs = [ (10^(Rp/20)-1)/(10^(Rp/20)+1)  10^(-Rs/20) ];
w = [1 1]*max(devs)./devs;
order=30;
B=firls(order,f,m,w);

Label=['R',num2str(Log.Defaults.ParP6)];
Comment=['Repol Time',num2str(round(Log.Defaults.ParP6))];
blockout=Log.Head.SRate/1000;
Window=round(Log.Defaults.ParP5/2);
  
h=waitbar(0,'Calculating Percent Repolarization Times');
X1=[Fig.X1X2(1):Fig.X1X2(2)];
X2=[Fig.X1X2(1):Fig.X1X2(2)-1];
offset=round(Log.Defaults.ParP5/2);

for i=1:(length(Fig.ChLabel(:,1))-1)
  fiducialX=[];
  % USER SELECTABLE OPTIONS %
  channel = Fig.ChLabel(i,2);
  DataCh=NewData(channel,X1);
  datadiff=diff(-sign*Fig.Data(channel,:));
  temp=PeakDetection(NewData(channel,X1),Log.Head.SRate,Log.Defaults.Parameter1,Log.Defaults.Parameter2,Log.Defaults.Parameter3,Log.Defaults.Parameter4);
 if temp~=0
   fiducialX = X1(temp);
    fidx1=fiducialX-Fig.X1X2(1);
    for count=1:length(fiducialX);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% More than 1 Activation Time per channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          if fidx1(count)-Window<=0 % This takes care of the case where the window would go before the dataset.
              startingtimeoffset=length(DataCh(1:fidx1(count)))-1;
          else
              startingtimeoffset=offset;
          end
     if length(fiducialX)>count & (fiducialX(count)+blockout)<length(DataCh)+Fig.X1X2(1)-10 & ~isempty(find(datadiff(fiducialX(count)-startingtimeoffset:fiducialX(count))>=0)) %& fiducialX(count)-Window>0 
        if fiducialX(count)+startingtimeoffset<fiducialX(count+1) & fidx1(count)~=0 %& fidx1(count)-Window>0 % 0
         Temp=-sign*DataCh;
         DataCh=Temp-min(Temp(fidx1(count)-startingtimeoffset:fidx1(count)+Window));
      	offset=round(Log.Defaults.ParP5/2);
         baseline=find(datadiff(fiducialX(count)-startingtimeoffset:fiducialX(count))>=0);
         baseline=baseline+fidx1(count)-startingtimeoffset;
         if get(Fig.Med,'Value')  % 1
           if baseline(end)-startingtimeoffset<=0 % This takes care of the case where the window would go before the dataset.
              startingtimeoffset2=baseline(end)-1;
           else
              startingtimeoffset2=startingtimeoffset;
           end
	      bv=Fig.Data(channel,[baseline(end)-startingtimeoffset2]:baseline(end)-1);
         [bv1 bv1i]=sort(bv);  
         if isempty(bv1)
            medianbaselinevalue=median(DataCh(1:fidx1(count))); 
            [YY,sortedmedian]=sort(DataCh(1:fidx1(count)));
            medianbaseline=sortedmedian(round(length(sortedmedian)/2));
         else
            medianbaseline=bv1i(round(length(bv1i)/2));
            medianbaselinevalue=DataCh(baseline(end)-medianbaseline);
         end
         

        else % This gets the minimum for the baseline value
           if baseline(end)-startingtimeoffset<=0 % This takes care of the case where the window would go before the dataset.
              startingtimeoffset2=baseline(end)-1;
           else
              startingtimeoffset2=startingtimeoffset;
           end
%       [medianbaselinevalue,medianbaseline]=max(-sign*DataCh([baseline(end)-startingtimeoffset2]:baseline(end)-1));
       [medianbaselinevalue,medianbaseline]=max(DataCh([baseline(end)-startingtimeoffset2]:fidx1(count)));
       
%          figure(200)
%          plot(sign*DataCh([baseline(end)-startingtimeoffset2]:fidx1(count)))
%          title(['Channel ',num2str(channel-1),' ',num2str(medianbaselinevalue)])
%          medianbaselinevalue
%          pause
   
       
       
       
    end     % end 1
         [Y a]=min(DataCh(fidx1(count):fidx1(count)+Log.Defaults.ParP5));
      	a=a+fidx1(count)-1;
         Amplitude=medianbaselinevalue;
         % This filters the data for repolarization
         if Log.Defaults.ParP7<Log.Head.SRate/2-50
            DataCh=filter(B,1,DataCh);
         end
     	 	Repol=find(DataCh(fidx1(count)+round(Log.Defaults.ParP5/2):length(DataCh))>=Log.Defaults.ParP6/100*Amplitude);
            if length(Repol)>=1; % 2
              NewAnnote3=[NewAnnote3;Fig.ChLabel(i,1) Repol(1)+fiducialX(count)+round(Log.Defaults.ParP5/2) Label];
              if get(Fig.Output,'Value')
			  NewAnnote1=[NewAnnote1;Fig.ChLabel(i,1) Fig.X1X2(1)+baseline(end)+medianbaseline-startingtimeoffset2-2 'Bas'];  
			  NewAnnote2=[NewAnnote2;Fig.ChLabel(i,1) Fig.X1X2(1)+a-1 'Max'];  
              end
         end   %end 2
        end  %end 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  1 Activation Time per channel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif fidx1(count)+Window<length(DataCh) & ~isempty(find(datadiff(fiducialX(count)-startingtimeoffset:fiducialX(count))>=0)) %& fidx1(count)-Window>0 
         if Log.Defaults.ParP7<Log.Head.SRate/2-50
            DataCh=filter(B,1,DataCh);
         end
     Temp=-sign*DataCh;
      DataCh=Temp-min(Temp(fidx1(count)-startingtimeoffset:fidx1(count)+Window));

      baseline=find(datadiff(fiducialX(count)-startingtimeoffset:fiducialX(count))>=0);
      baseline=baseline+fidx1(count)-startingtimeoffset;

      
      if get(Fig.Med,'Value')
           if baseline(end)-startingtimeoffset<=0 % This takes care of the case where the window would go before the dataset.
              startingtimeoffset2=baseline(end)-1;
           else
              startingtimeoffset2=startingtimeoffset;
           end
	         bv=Fig.Data(channel,[baseline(end)-startingtimeoffset2]:baseline(end)-1);
            [bv1 bv1i]=sort(bv);
            if round(length(bv1i/2))>1
               medianbaseline=bv1i(round(length(bv1i)/2));
            else
               medianbaseline=0;
            end
            medianbaselinevalue=DataCh(baseline(end)-medianbaseline);
      else
           if baseline(end)-startingtimeoffset<=0 % This takes care of the case where the window would go before the dataset.
              startingtimeoffset2=baseline(end)-1;
           else
              startingtimeoffset2=startingtimeoffset;
           end
 	     [medianbaselinevalue,medianbaseline]=max(DataCh([baseline(end)-startingtimeoffset2]:fidx1(count)));   
         
        % figure(200)
        % plot(sign*DataCh([baseline(end)-startingtimeoffset2]:fidx1(count)))
        % title(['Channel ',num2str(channel-1),' ',num2str(medianbaselinevalue)])
        % medianbaselinevalue
        % pause
         
  end
      [Y a]=min(DataCh(fidx1(count):fidx1(count)+Log.Defaults.ParP5/2));
      a=a+fidx1(count)-1;
		Amplitude=medianbaselinevalue;
         % This filters the data for repolarization
%          if Log.Defaults.ParP7<Log.Head.SRate/2-50
%             DataCh=filter(B,1,DataCh);
%          end
	  		Repol=find(DataCh(fidx1(count)+round(Log.Defaults.ParP5/2):length(DataCh))>=Log.Defaults.ParP6/100*Amplitude)-1;
% 	  		Repol=find(DataCh(fidx1(count):length(DataCh))>=Log.Defaults.ParP6/100*Amplitude)-1;

         if length(Repol)>=1;
              NewAnnote3=[NewAnnote3;Fig.ChLabel(i,1) Repol(1)+Fig.X1X2(1)+fidx1(count)+round(Log.Defaults.ParP5/2) Label];
			  if get(Fig.Output,'Value')
              NewAnnote1=[NewAnnote1;Fig.ChLabel(i,1) Fig.X1X2(1)+baseline(end)+medianbaseline-startingtimeoffset2-2 'Bas'];  
			  NewAnnote2=[NewAnnote2;Fig.ChLabel(i,1) Fig.X1X2(1)+a-1 'Max'];  
              end
%               if channel==147 | channel==584
%                   Amplitude
%                   bbb=Repol(1)+fidx1(count)+round(Log.Defaults.ParP5/2);
%                   figure(100)
%                   plot(DataCh)
%                   
%               end
        end
 if 1==2;
     figure(100)
     plot(DataCh)
     Amplitude
     PAmp=Amplitude*Log.Defaults.ParP6/100
  line([baseline(end)-medianbaseline baseline(end)-medianbaseline],[max(DataCh) min(DataCh)]);
  %line([Repol(1)+fidx1(count)+round(Log.Defaults.ParP5/2) Repol(1)+fidx1(count)+round(Log.Defaults.ParP5/2)],[max(DataCh) min(DataCh)]);
 % line([Repol(1)+fiducialX(count)-Fig.X1X2(1) Repol(1)+fiducialX(count)-Fig.X1X2(1)],[max(DataCh) min(DataCh)]);
 pause
end
       
      end
  end
waitbar(i/length(Fig.ChLabel(:,1)),h);
end
end
close(h)
if  get(Fig.Output,'Value')
    Fig.Annote=[Fig.Annote;NewAnnote1];
    Zeng_Analysis('Existing Check',Stripchart.Figure,'Bas','Baseline',Fig.Annote)
    Fig.Annote=[Stripchart.Annote.Array;NewAnnote2];
    Zeng_Analysis('Existing Check',Stripchart.Figure,'Max','Maximum',Fig.Annote)
end
Fig.Annote=[Stripchart.Annote.Array;NewAnnote3];
Zeng_Analysis('Existing Check',Stripchart.Figure,Label,Comment,Fig.Annote)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ANNOTATION DATA ALREADY EXISTS                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
   NewAnnote3=[];
   Label=['R',num2str(Log.Defaults.ParP6)];
   Comment=['Repol Time',num2str(round(Log.Defaults.ParP6))];
   Temp.index=strmatch('Bas',char(Fig.Annote(:,3:(2+Stripchart.Annote.ShowLength))));
if Log.Defaults.ParP7>=Log.Head.SRate/2-0.02*2/Log.Head.SRate;
   Log.Defaults.ParP7=round(Log.Head.SRate/2-(0.0200001/2*Log.Head.SRate));
elseif Log.Defaults.ParP7<=0
   Log.Defaults.ParP7=0.0001;
end
Rp=1;
Rs=.1;
f = [0 Log.Defaults.ParP7*2/Log.Head.SRate Log.Defaults.ParP7*2/Log.Head.SRate+0.02 1];
m = [1  1  0 0];
devs = [ (10^(Rp/20)-1)/(10^(Rp/20)+1)  10^(-Rs/20) ];
w = [1 1]*max(devs)./devs;
order=30;
B=firls(order,f,m,w);

   if ~isempty(Temp.index)  %2
      Temp.ChB=find(Fig.Annote(Temp.index,2)>=Fig.X1X2(1) & Fig.Annote(Temp.index,2)<=Fig.X1X2(2));
      Baselines=Fig.Annote(Temp.index(Temp.ChB),:);
   end
   Temp.index=strmatch('Max',char(Fig.Annote(:,3:(2+Stripchart.Annote.ShowLength))));
   if ~isempty(Temp.index)  %2
      Temp.ChM=find(Fig.Annote(Temp.index,2)>=Fig.X1X2(1) & Fig.Annote(Temp.index,2)<=Fig.X1X2(2));
      Maxs=Fig.Annote(Temp.index(Temp.ChM),:);
   end
   [x y]=size(NewData);
   for i=0:x-1
   DataCh=NewData(i+1,Fig.X1X2(1):Fig.X1X2(2));
   bChannelMaximums=find(Maxs(:,1)==i);
   ChannelB=Maxs(bChannelMaximums,2);
   for count=1:length(ChannelB)
      if  ~isempty(ChannelB)
   DataCh=Log.Defaults.Parameter4/-abs(Log.Defaults.Parameter4)*(DataCh-DataCh(ChannelB(count)-Fig.X1X2(1)));
   aChannelBaseline=find(Baselines(:,1)==i);
   ChannelM=Baselines(aChannelBaseline,2);
if ~isempty(aChannelBaseline) & ~isempty(bChannelMaximums) & ~isempty(ChannelB) & count<=length(aChannelBaseline) & count<=length(bChannelMaximums)
   bbb=Baselines(aChannelBaseline(count),2);
   if bbb>Fig.X1X2(1)
   BaselineValue=DataCh(Baselines(aChannelBaseline(count),2)-Fig.X1X2(1)+1);
   MaximumValue=DataCh(Maxs(bChannelMaximums(count),2)-Fig.X1X2(1)+1);
   Amplitude=abs(BaselineValue-MaximumValue);
  
   % This filters the data for repolarization
   if Log.Defaults.ParP7<Log.Head.SRate/2-50
      DataCh=filter(B,1,DataCh);
   end
   DataCh=DataCh-BaselineValue;
   %round((100-Log.Defaults.ParP6)/100*-Amplitude)
   Repol=find(DataCh(ChannelB(count)-Fig.X1X2(1):length(DataCh))>=round((100-Log.Defaults.ParP6)/100*-Amplitude));
   if ~isempty(Repol)
      %     NewAnnote3=[NewAnnote3;i Repol(1)+ChannelB(count)-Fig.X1X2(1)-1 Label];
      NewAnnote3=[NewAnnote3;i Repol(1)+ChannelB(count)-1 Label];
   end
   
end
end
end
end
end
	Fig.Annote=[Fig.Annote;NewAnnote3];
   Zeng_Analysis('Existing Check',Stripchart.Figure,Label,Comment,Fig.Annote)
end


	output=[];
   if get(Fig.Save,'Value')
      Temp.index=strmatch('Bas',char(Fig.Annote(:,3:(2+Stripchart.Annote.ShowLength))));
    Temp.index2=find(Fig.Annote(Temp.index,2)>=Fig.X1X2(1) & Fig.Annote(Temp.index,2)<=Fig.X1X2(2));
    a=double(Fig.Annote(Temp.index(Temp.index2),1));
    b=double(Fig.Annote(Temp.index(Temp.index2),2));
      
      for i=1:length(a)
         output(a(i)+1,1)=a(i);
         output(a(i)+1,2)=NewData(a(i)+1,b(i));
      end
    Temp.index=strmatch('Max',char(Fig.Annote(:,3:(2+Stripchart.Annote.ShowLength))));
    Temp.index2=find(Fig.Annote(Temp.index,2)>=Fig.X1X2(1) & Fig.Annote(Temp.index,2)<=Fig.X1X2(2));
    ap=double(Fig.Annote(Temp.index(Temp.index2),1));
    bp=double(Fig.Annote(Temp.index(Temp.index2),2));
   for i=1:length(ap)
      output(ap(i)+1,1)=ap(i);
      output(ap(i)+1,3)=NewData(ap(i)+1,bp(i));
   end
   Zeng_Save('Raw',output,Log);
end
clear Log.Steve.Figure
close(Log.Steve.Figure)
% Saves the Channel Number, Maximum and Minimum Values.   

case 'Cancel'
   close(Log.Steve.Figure)
     
case 'Restore'
	set(Fig.Parameter1,'String','3');
   set(Fig.Parameter2,'String','5');
   set(Fig.Parameter3,'String','200');
   set(Fig.Parameter4,'String','-1.1');
   set(Fig.Parameter5,'String','50');
   set(Fig.Parameter6,'String','85');
   set(Fig.Parameter7,'String','450');
end





