% This Program is called by Impulse.M from Zeng's Program
% The Program calculates the AP Amplitude, delta Vm, and APD
% based on a repolarization percent entered.
function [varargout]=ImpulseA(varargin)
action = varargin{1};
%load ID
global Data
global ID
global Log
switch action
case 'Initial'
   ID.Computed=0;
   ID.LUT=varargin{6};
   ID.currentpoint=[];
ID.Figure = figure('Color',[0.8 0.8 0.8], ...
	'PaperPosition',[18 180 576 432], ...
	'PaperUnits','points', ...
	'Position',[420 251 560 420], ...
	'Tag','Fig1', ...
   'ToolBar','none');
dim=get(ID.Figure,'Position');   
ID.AxisE = axes('Parent',ID.Figure, ...
	'Units','pixels', ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'Position',[ 35 .05*dim(4) 500 97], ...
	'Tag','Axes1', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
	'ZColor',[0 0 0]);
ID.Axis = axes('Parent',ID.Figure, ...
	'Units','pixels', ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'Position',[35 .5*dim(4) 500 97], ...
	'Tag','Axes1', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
	'ZColor',[0 0 0]);
h2 = text('Parent',ID.Axis, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.498046875 -0.25 9.160254037844386], ...
	'Tag','Axes1Text4', ...
	'VerticalAlignment','cap');
set(get(h2,'Parent'),'XLabel',h2);
h2 = text('Parent',ID.Axis, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[-0.0546875 0.4895833333333335 9.160254037844386], ...
	'Rotation',90, ...
	'Tag','Axes1Text3', ...
	'VerticalAlignment','baseline');
set(get(h2,'Parent'),'YLabel',h2);
h2 = text('Parent',ID.Axis, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','right', ...
	'Position',[-0.052734375 4.125 9.160254037844386], ...
	'Tag','Axes1Text2');
set(get(h2,'Parent'),'ZLabel',h2);
h2 = text('Parent',ID.Axis, ...
	'Color',[0 0 0], ...
	'HandleVisibility','off', ...
	'HorizontalAlignment','center', ...
	'Position',[0.498046875 1.072916666666667 9.160254037844386], ...
	'Tag','Axes1Text1', ...
	'VerticalAlignment','bottom');
set(get(h2,'Parent'),'Title',h2);
ID.Text = uicontrol('Parent',ID.Figure, ...
	'Units','points', ...
   'BackgroundColor',[0 1 0], ...
   'callback','ImpulseA AlignFrames',...
	'ListboxTop',0, ...
	'Position',[.45*dim(3) .6*dim(4) 65 25], ...
	'String','Analyze', ...
	'Tag','Pushbutton1');
ID.Text = uicontrol('Parent',ID.Figure, ...
	'Units','points', ...
   'BackgroundColor',[0.6 0.6 0.6], ...
   'callback','ImpulseA Compile',...
	'ListboxTop',0, ...
	'Position',[.6*dim(3) .605*dim(4) 60 20], ...
	'String','Compile', ...
	'Tag','Pushbutton1');

%              Pacing Stuff        
ID.Pacing = uicontrol('Parent',ID.Figure, ...
	'Units','points', ...
   'BackgroundColor',[1 1 1], ...
   'callback','ImpulseA Pacing',...
	'ListboxTop',0, ...
	'Position',[.05*dim(3) .57*dim(4) 30.75 16.5], ...
   'Style','edit', ...
   'String','262',...
	'Tag','EditText2');
ID.TextP = uicontrol('Parent',ID.Figure, ...
	'Units','points', ...
   'callback','ImpulseA Pacing',...
	'BackgroundColor',[0.9 0.2 0.2], ...
	'ListboxTop',0, ...
   'Position',[19.5 .62*dim(4) 65 15], ...
	'String','Pacing Channel', ...
   'Tag','StaticText3');
icons = {['[ line([.2 .9 .5 .2 ],[.2 .2 .9 .2 ],''color'',''k'')]';
   	       '[ line([.1 .9 .5 .1 ],[.8 .8 .1 .8 ],''color'',''k'')]']};
callbacks=['ImpulseA(''Increase Ch'')';'ImpulseA(''Decrease Ch'')'];
PressType=['flash ';'flash '];
ChnlChanging=	btngroup('ButtonID',['S1';'S2'],...
	      'Callbacks',callbacks,...
   	      'IconFunctions',str2mat(icons{:}),...
      	   'GroupID', 'School',...
	      'GroupSize',[2 1],...   
   	      'PressType',PressType,...
      	   'BevelWidth',.1,...
          'units','pixels',...
          'Position',[.15*dim(3) .75*dim(4) 20 30]);
       
       
%              SIGNAL Stuff        
ID.Signal = uicontrol('Parent',ID.Figure, ...
	'Units','points', ...
   'BackgroundColor',[1 1 1], ...
   'callback','ImpulseA ETC',...
	'ListboxTop',0, ...
	'Position',[.06*dim(3) .22*dim(4) 30.75 16.5], ...
   'Style','edit', ...
   'String','261',...
	'Tag','EditText2');
ID.TextS = uicontrol('Parent',ID.Figure, ...
   'Units','points', ...
   'Callback','ImpulseA ETC',...
   'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
   'Value',1,...
	'ListboxTop',0, ...
	'Position',[.05*dim(3) .28*dim(4) 65 15], ...
	'String','ETC Channel', ...
   'Tag','StaticText3');
icons = {['[ line([.2 .9 .5 .2 ],[.2 .2 .9 .2 ],''color'',''k'')]';
   	       '[ line([.1 .9 .5 .1 ],[.8 .8 .1 .8 ],''color'',''k'')]']};
callbacks=['ImpulseA(''Increase ChE'')';'ImpulseA(''Decrease ChE'')'];
PressType=['flash ';'flash '];
ChnlChanging=	btngroup('ButtonID',['S1';'S2'],...
	      'Callbacks',callbacks,...
   	      'IconFunctions',str2mat(icons{:}),...
      	   'GroupID', 'TWO',...
	      'GroupSize',[2 1],...   
   	      'PressType',PressType,...
      	   'BevelWidth',.1,...
          'units','pixels',...
          'Position',[.16*dim(3) .285*dim(4) 20 30]);
       


ID.Line=[];
if nargout > 0, fig = ID.Figure; end
ID.ChLabel=varargin{4};
ID.Z=varargin{2};
ID.X1X2=varargin{3};
ID.Annote=varargin{5};
ID.Data=Data{2}(:,ID.X1X2(1):ID.X1X2(2));
ID.Channel=str2num(get(ID.Pacing,'String'))+1;
ID.DataCh=ID.Data(ID.Channel,:);
plot(ID.DataCh,'Parent',ID.Axis);
axis tight
set(ID.Axis,'XTickLabel',num2str(round(str2num(get(ID.Axis,'XTickLabel'))/Log.Head.SRate*1000)))
plot(ID.Data(str2num(get(ID.Signal,'String'))+1,:),'Parent',ID.AxisE);
axis tight
set(ID.AxisE,'XTickLabel',num2str(round(str2num(get(ID.AxisE,'XTickLabel'))/Log.Head.SRate*1000)))
   
case 'Pacing'
   ID.Channel=str2num(get(ID.Pacing,'String'))+1;
   set(ID.TextP,'BackgroundColor', [0.9 0.2 0.2])
   set(ID.TextS,'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588])
   [x y]=size(ID.Data);
   if ID.Channel<=x & ID.Channel>=0
      ID.DataCh=ID.Data(ID.Channel,:);
      temp=get(ID.TextP,'BackgroundColor');
      if temp(1)==.9
         plot(ID.DataCh,'Parent',ID.Axis);
	     set(ID.Axis,'XTickLabel',num2str(round(str2num(get(ID.Axis,'XTickLabel'))/Log.Head.SRate*1000)))
      else
         plot(ID.DataCh,'Parent',ID.AxisE);
	     set(ID.AxisE,'XTickLabel',num2str(round(str2num(get(ID.Axis,'XTickLabel'))/Log.Head.SRate*1000)))
      end
      
      %axis tight
   end
   if ~isempty(ID.Line)
      Current_Axis=axis;
      ID.Line=line([ID.Position1 ID.Position1],[Current_Axis(3) Current_Axis(4)]);
      set(ID.Line,'Color','r','LineWidth',.5,'EraseMode','xor');   
   end
   
   
case 'ETC'
   ID.ETCChannel=str2num(get(ID.Signal,'String'))+1;
   set(ID.TextP,'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588])
   set(ID.TextS,'BackgroundColor', [0.9 0.2 0.2])
   [x y]=size(ID.Data);
   if ID.Channel<=x & ID.ETCChannel>=0
      ID.DataCh=ID.Data(ID.ETCChannel,:);
      temp=get(ID.TextP,'BackgroundColor');
      if temp(1)==.9
         plot(ID.DataCh,'Parent',ID.Axis);
	     set(ID.Axis,'XTickLabel',num2str(round(str2num(get(ID.Axis,'XTickLabel'))/Log.Head.SRate*1000)))
      else
         plot(ID.DataCh,'Parent',ID.AxisE);
	     set(ID.AxisE,'XTickLabel',num2str(round(str2num(get(ID.Axis,'XTickLabel'))/Log.Head.SRate*1000)))
      end
   end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AUTOMATICALLY ALIGN FRAMES                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'AlignFrames'
%   ID.Computed=1;
      ID.Channel=str2num(get(ID.Pacing,'String'))+1;
      ID.DataCh=ID.Data(ID.Channel,:);
      ID.Sights=[];
      Sights=[];
%      Sights = find(diff(ID.DataCh)>.05*max(diff(ID.DataCh)))
      Sights = find((ID.DataCh)>.5*max((ID.DataCh)))
      index=1;
      first=1;
%  Finds the Pacing Sight Based on what channel is in the pacing window
   for count=1:length(Sights)-1;
      Difference=Sights(count+1)-Sights(count);
      if Difference==1 & first==1;
         ID.Sights(index)=Sights(count);
         index=index+1;
         first=0;
      elseif Difference>1 & first==0;
         first=1;
      elseif Difference>1 & first==1;
         ID.Sights=Sights;
      end
   end
   old=ID.Data(:,ID.Sights(1):ID.Sights(2)-1);
   ID.NewData=old;
   ImpulseA('Shai',ID.NewData,ID.Sights(1));
   gap=abs(ID.Sights(1)-ID.Sights(2)+1);
   %   Starts to sort out each AP   
   h=waitbar(0,'Calculating APs Paremeters');
   waitbar(1/length(ID.Sights),h);
   for count=2:length(ID.Sights);
      if (ID.Sights(count)+gap)<length(ID.Data);
         new=ID.Data(:,ID.Sights(count):ID.Sights(count)+gap);
         ImpulseA('Shai',new,ID.Sights(count));
         [x y]=size(ID.NewData);
      end
      ID.NewData=old+new;
      old=ID.NewData;
      waitbar(count/length(ID.Sights),h);
   end
   close(h)
   fclose(ID.fid);  % The file was opened in ImpulseA 'Shai'


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SHAI'S PROGRAM                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'Shai'
data = [];
PaceSight = [];
flen=5000;
data = varargin{2};
warning off
APDLevel=0.5;  % This means APD50  at 50% of the max value after depolarization
APDUpstroke=0.1;
for p=1:256
   a=median(data(p,:));
   b=mean(data(p,:));
   s=.3*std(data(p,:));
   if a>b-s & a<b+s
      data(p,:)=0*ones(1,length(data(p,:)));
   end
%   data(p,:)=100*(data(p,:)-min(data(p,:)))/(max(data(p,:))-min(data(p,:)));
data(p,:)=(data(p,:)-min(data(p,:)));
end
% normalize values
[s L]=size(data);
pace = [];
if s(1)>262 %Sort out the Pacing & Recording Sights
   PaceSight=str2num(get(ID.Pacing,'String'))+1;
   SignalSight=str2num(get(ID.Signal,'String'))+1;
   pace = varargin{3};
   ETC = find(diff(data(SignalSight,:))>100);
   ETC=ETC(1);
end
   if ~isempty(ETC) 
      ETCDuration = length(find(data(SignalSight,:)>.5*max(data(SignalSight,:))));
   else
      [I ETC]=min(diff(data(1,:)));
      ETC=ETC+50/Log.Head.SRate*1000;
      ETCDuration=ETC/2+5;
   end
   % All Action Potentials are inverted in optical mapping so intuitively max and min are switched
   Baseline=mean(data(1:256,1:3)');
   APD10Up=[];
   APD10Down=[];
   if 1==1 % Does the pacing artifact come before the ETC  %3
      MaxBeforeETC=mean(data(:,ETC-1:ETC)');
     AmpAfterETC = min(data(:,ETC+3:ETC+ETCDuration-5)'); % positive artifact is the maximal value after ETC
     for channel=1:256  %  4
        temp2= find(data(channel,1:ETC)<=Baseline(channel)*APDUpstroke); 
        temp3= find(data(channel,ETC+ETCDuration+5:end)>=Baseline(channel)*APDLevel)+ETC+ETCDuration+2;
        if length(temp2)>0 & temp2(1)>1  %  5.0
            temp22=polyfit([data(channel,temp2(1)-1) data(channel,temp2(1)) data(channel,temp2(1)+1)],[temp2(1)-1 temp2(1) temp2(1)+1],1);
            temp23=polyval(temp22,APDUpstroke*Baseline(channel));
           if temp2(1)<ID.Signal  % 5.1
            temp24=polyfit([temp2(1)-1 temp2(1) temp2(1)+1],[data(channel,temp2(1)-1) data(channel,temp2(1)) data(channel,temp2(1)+1)],1);
            temp2Value=polyval(temp24,temp23);
            APD10Up(channel)=temp23(1);
               if AmpAfterETC(channel)>MaxBeforeETC(channel)  % 5.2
                  AmpAfterETC(channel)=max(conv2(data(channel,ETC+3:ETC+ETCDuration+5),[1/3 1/3 1/3],'same')');
               end    % end 5.2
            end   % end 5.1
         else
            APD10Up(channel)=0;
         end   % end 5.0
         if length(temp3)>0  %  6
            temp32=polyfit([data(channel,temp3(1)-1) data(channel,temp3(1)) data(channel,temp3(1)+1)],[temp3(1)-1 temp3(1) temp3(1)+1],1);
            temp33=polyval(temp32,Baseline(channel)*APDLevel);
            temp34=polyfit([temp3(1)-1 temp3(1) temp3(1)+1],[data(channel,temp3(1)-1) data(channel,temp3(1)) data(channel,temp3(1)+1)],1);
            temp3Value=polyval(temp34,temp33);
            APD10Down(channel)=temp33(1);
         else
            APD10Down(channel)=0;
         end  % end 6
         
       if  1==2 % 7
       figure(9)
       plot(data(channel,:),'x')
       a=line([APD10Up(channel) APD10Up(channel)],[max(data(channel,:)) min(data(channel,:))]);
       b=line([APD10Down(channel) APD10Down(channel)],[max(data(channel,:)) min(data(channel,:))]);
       set(b,'Color',[1 0 0])
       pause
    end % end 7
u=    APD10Up(channel);
d=   APD10Down(channel);
a(channel)=d-u;
      end % end 4
      Artifact=MaxBeforeETC-AmpAfterETC;
      APD=(APD10Down-APD10Up)/Log.Head.SRate*1000;
      APD(find(isnan(APD)))=0;
      APD(find(APD>500))=0;
     % APD=-wthresh(-APD-min(-APD),'h',-500);
      Amplitude= Baseline-min(data(1:256,1:ETC-2)');  % previously val
   if ID.Computed==0
	   [Filename Pathname]=uiputfile('c:\*.ste','Save the file');    
       ID.Computed=1;
       ID.fid = fopen([Pathname Filename],'w');
   end
  fprintf(ID.fid,'%s \n',num2str(round(Artifact)));
  fprintf(ID.fid,'%s \n',num2str(round(APD)));
  fprintf(ID.fid,'%s \n',num2str(round(Amplitude)));
end  % 3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  COMPILE THE DATA                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'Compile Window'
    ID.Figure2 = figure('Color',[0.8 0.8 0.8], ...
	'PaperUnits','points', ...
	'Position',[100 251 580 500], ...
	'Tag','Fig1', ...
   'ToolBar','none');
dim=get(ID.Figure,'Position');   
ID.ImageAxis1 = axes('Parent',ID.Figure2, ...
	'Units','pixels', ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'Position',[ 35 .38*dim(4) 250 250], ...
	'Tag','Axes1', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
ID.ImageAxis2 = axes('Parent',ID.Figure2, ...
	'Units','pixels', ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'Position',[ 300 .38*dim(4) 250 250], ...
	'Tag','Axes1', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
%axis off
ID.Axis2 = axes('Parent',ID.Figure2, ...
	'Units','pixels', ...
	'CameraUpVector',[0 1 0], ...
	'Color',[1 1 1], ...
	'Position',[35 .08*dim(4) 520 97], ...
	'Tag','Axes1', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);
values = {['Artifact ';'APD      ';'Amplitude']};
    ID.Maps = uicontrol('Parent',ID.Figure2, ...
        'Units','pixels', ...
        'BackgroundColor',[0.733333 0.733333 0.733333], ...
   	  'callback','ImpulseA MapSelect',...
        'Enable','on', ...
        'ListboxTop',0, ...
        'Position',[35 430 80 22], ...
        'String',values, ...
        'Style','popupmenu', ...
        'Tag','PopupMenu1', ...
        'Value',1);
     ID.Button.Show=	uicontrol('Parent',ID.Figure2, ...
         'BackgroundColor',[1 0 0], ...
         'Units','pixels',...
         'FontName','times',...
         'FontUnits','points',...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[415 430 70 25],...
	  	   'Style','togglebutton',...
         'String','Show Marks', ...
         'callback','ImpulseA(''Show Marks'')',...  
         'Value',0,...
		 'Tag','Pushbutton1');  
ID.Button.Interp=	uicontrol('Parent',ID.Figure2, ...
         'Units','pixels',...
         'FontName','times',...
         'FontUnits','points',...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[150 430 70 25],...
	  	   'Style','pushbutton',...
         'String','Interpolate', ...
         'callback','ImpulseA(''Interpolate'')',...  
         'Value',0,...
		 'Tag','Pushbutton1');  
ID.Button.Save=	uicontrol('Parent',ID.Figure2, ...
         'Units','pixels',...
         'FontName','times',...
         'FontUnits','points',...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[250 440 70 25],...
	  	   'Style','pushbutton',...
         'String','Save Final', ...
         'callback','ImpulseA(''Save Final'')',...  
         'Value',0,...
         'Tag','Pushbutton1');  
ID.TextIII = uicontrol('Parent',ID.Figure2, ...
	'Units','points', ...
   'callback','ImpulseA Pacing',...
	'ListboxTop',0, ...
   'Position',[25 .24*dim(4) 75 15], ...
	'String','0 0', ...
   'Tag','StaticText3');


set(ID.Figure2,'WindowButtonDownFcn','ImpulseA(''Mouse Down'')');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  SHOW MARKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'Show Marks'
   if get(ID.Button.Show,'Value')
data = [];
PaceSight = [];
flen=5000;
warning off
APDLevel=0.5;  % This means APD50  at 50% of the max value after depolarization
APDUpstroke=0.5;
channel=ID.Ch;
p=channel;
data=ID.Data(:,ID.Sights(1):ID.Sights(2)-1);
a=median(data(p,:));
b=mean(data(p,:));
s=.3*std(data(p,:));
   if a>b-s & a<b+s
      data(p,:)=0*ones(1,length(data(p,:)));
   end
data(p,:)=(data(p,:)-min(data(p,:)));
% normalize values
[s L]=size(data);
pace = [];
if s(1)>262 %Sort out the Pacing & Recording Sights
   PaceSight=str2num(get(ID.Pacing,'String'))+1;
   SignalSight=str2num(get(ID.Signal,'String'))+1;
%   pace = varargin{3};
   pace = 0;
   ETC = find(diff(data(SignalSight,:))>100);
   ETC=ETC(1);
end
if ~isempty(ETC) 
      ETCDuration = length(find(data(SignalSight,:)>.5*max(data(SignalSight,:))));
else
      [I ETC]=min(diff(data(1,:)));
      ETC=ETC+50/Log.Head.SRate*1000;
      ETCDuration=ETC/2+5;
end
   % All Action Potentials are inverted in optical mapping so intuitively max and min are switched
   Baseline=mean(data(1:256,1:3)');
   APD10Up=[];
   APD10Down=[];
   MaxBeforeETC=mean(data(:,ETC-1:ETC)');
   AmpAfterETC = min(data(:,ETC+3:ETC+ETCDuration-5)'); % positive artifact is the maximal value after ETC
   temp2= find(data(channel,1:ETC+ETCDuration)<=Baseline(channel)*APDUpstroke); 
   temp3= find(data(channel,ETC+ETCDuration+5:end)>=Baseline(channel)*APDLevel)+ETC+ETCDuration+2;
        if length(temp2)>0 & temp2(1)>1  %  5.0
            temp22=polyfit([data(channel,temp2(1)-1) data(channel,temp2(1)) data(channel,temp2(1)+1)],[temp2(1)-1 temp2(1) temp2(1)+1],1);
            temp23=polyval(temp22,APDUpstroke*Baseline(channel));
           if temp2(1)<ID.Signal  % 5.1
            temp24=polyfit([temp2(1)-1 temp2(1) temp2(1)+1],[data(channel,temp2(1)-1) data(channel,temp2(1)) data(channel,temp2(1)+1)],1);
            temp2Value=polyval(temp24,temp23);
            APD10Up(channel)=temp23(1);
               if AmpAfterETC(channel)>MaxBeforeETC(channel)  % 5.2
                  AmpAfterETC(channel)=max(conv2(data(channel,ETC+3:ETC+ETCDuration+5),[1/3 1/3 1/3],'same')');
               end    % end 5.2
            end   % end 5.1
         else
            APD10Up(channel)=0;
         end   % end 5.0
         if length(temp3)>0  %  6
            temp32=polyfit([data(channel,temp3(1)-1) data(channel,temp3(1)) data(channel,temp3(1)+1)],[temp3(1)-1 temp3(1) temp3(1)+1],1);
            temp33=polyval(temp32,Baseline(channel)*APDLevel);
            temp34=polyfit([temp3(1)-1 temp3(1) temp3(1)+1],[data(channel,temp3(1)-1) data(channel,temp3(1)) data(channel,temp3(1)+1)],1);
            temp3Value=polyval(temp34,temp33);
            APD10Down(channel)=temp33(1);
         else
            APD10Down(channel)=0;
         end  % end 6
         
       if  1==2 % 7
       figure(9)
       plot(data(channel,:),'x')
       a=line([APD10Up(channel) APD10Up(channel)],[max(data(channel,:)) min(data(channel,:))]);
       b=line([APD10Down(channel) APD10Down(channel)],[max(data(channel,:)) min(data(channel,:))]);
       set(b,'Color',[1 0 0])
       pause
    end % end 7
    axes(ID.Axis2)
    endx=-ID.Sights(1)+ID.Sights(2);
    ys=[max(data(ID.Ch,:)) min(data(ID.Ch,:))];
    a=line([temp2(1) temp2(1)],ys,'Tag','Line1');
   set(a,'Color',[1 0 0],'LineWidth',3)
    b=line([temp3(1) temp3(1)],ys,'Tag','Line2');
   set(b,'LineWidth',3);
   c=line([0 endx],[MaxBeforeETC(channel) MaxBeforeETC(channel)]);
   set(c,'Color',[1 0 1],'LineWidth',3,'Tag','Line3')
   d=line([0 endx],[AmpAfterETC(channel) AmpAfterETC(channel)]);
   set(d,'Color',[0 1 0],'LineWidth',3,'Tag','Line4')
   axis tight
else
   axes(ID.Axis2)
   delete(findobj(gca,'Tag','Line1'))
   delete(findobj(gca,'Tag','Line2'))
   delete(findobj(gca,'Tag','Line3'))
   delete(findobj(gca,'Tag','Line4'))

  end 
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % SAVE FINAL                     %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'Save Final'
   artifact=reshape(ID.arrayimageAr,1,256);
   artifacts=reshape(ID.arrayimageArs,1,256);
   amplitude=reshape(ID.arrayimageAm,1,256);
   amplitudes=reshape(ID.arrayimageAms,1,256);
   apd=reshape(ID.arrayimageAp,1,256);
   apds=reshape(ID.arrayimageAps,1,256);
   x=[16:-1:1]';
   xtemp=ones(1,16);
   xprime=x*xtemp;
   xnew=reshape(xprime,1,256);
   y=[1:16];
   ytemp=ones(16,1);
   yprime=ytemp*y;
   ynew=reshape(yprime,1,256);
   [Filename Pathname]=uiputfile('c:\*.fin','Save the file');    
   M=[xnew' ynew' artifact' artifacts' apd' apds' amplitude' amplitudes'];
 dlmwrite([Pathname Filename],M,'\t');
  
   
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   MOUSE DOWN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'Mouse Down'
   LUTDisplay=get(gcbf,'userdata');
   b=findobj(ID.ImageAxis1,'Tag','patch1');
   delete(b)
   b=findobj(ID.ImageAxis2,'Tag','patch1');
   delete(b)
   Temp.currentpoint=round(get(gca,'currentpoint'));
   ID.currentpoint=Temp.currentpoint;
   Temp.currentpoint=Temp.currentpoint(1,1:2);
   Temp.Ch=find(ID.Ch_XY(:,2)==Temp.currentpoint(1) &  ID.Ch_XY(:,3)==Temp.currentpoint(2));
   Current_Axis=axis;
   if (Temp.currentpoint(1,2)>=round(Current_Axis(3)) & Temp.currentpoint(1,1)<(Current_Axis(4))) & (gca==ID.ImageAxis1 | gca==ID.ImageAxis2)
      set(ID.TextIII,'String',[num2str(Temp.currentpoint(1)),'   ',num2str(Temp.currentpoint(2)),'   Chan:  ',num2str(ID.Ch_XY(Temp.Ch))]);
      axes(ID.ImageAxis1)
      b=patch(...
      	'CData',[],...
         'CDataMapping','scaled',...
         'LineWidth',3,...
  		   'FaceVertexCData',[],...
			'EdgeColor','r',...
			'EraseMode','xor',...
			'Faces',[1 2 3 4 5],...
			'MarkerEdgeColor','auto',...
			'MarkerFaceColor','none',...
         'MarkerSize',[12],...
         'Tag','patch1',...
			'XData',[Temp.currentpoint(1)+.5 Temp.currentpoint(1)+.5 Temp.currentpoint(1)-.5 Temp.currentpoint(1)-.5],...
			'YData',[Temp.currentpoint(2)+.5 Temp.currentpoint(2)-.5 Temp.currentpoint(2)-.5 Temp.currentpoint(2)+.5]);   
      %			'FaceColor','r',...
      axes(ID.ImageAxis2)
	   b=patch(...
      	'CData',[],...
         'CDataMapping','scaled',...
         'LineWidth',3,...
  		   'FaceVertexCData',[],...
			'EdgeColor','r',...
			'EraseMode','xor',...
			'Faces',[1 2 3 4 5],...
			'MarkerEdgeColor','auto',...
			'MarkerFaceColor','none',...
         'MarkerSize',[12],...
         'Tag','patch1',...
			'XData',[Temp.currentpoint(1)+.5 Temp.currentpoint(1)+.5 Temp.currentpoint(1)-.5 Temp.currentpoint(1)-.5],...
			'YData',[Temp.currentpoint(2)+.5 Temp.currentpoint(2)-.5 Temp.currentpoint(2)-.5 Temp.currentpoint(2)+.5]);   
      %			'FaceColor','r',...
      ID.Ch=ID.Ch_XY(Temp.Ch);
      ImpulseA('Trace',Temp.Ch)
   elseif (Temp.currentpoint(1,2)>=(Current_Axis(3)) & Temp.currentpoint(1,1)<(Current_Axis(4))) & gca==ID.Axis2
   111   
   end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %   SHOWS THE TRACE OF A SIGNAL     %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'Trace'
   old=ID.Data(ID.Ch,ID.Sights(1):ID.Sights(2)-1);
   old=old-min(old);
   plot(old,'Parent',ID.Axis2)
  if get(ID.Button.Show,'Value')
     ImpulseA('Show Marks')
  end
  
   
   
%              Pacing Stuff        
       
case 'MapSelect'
%      figure(10)
check=get(ID.Maps,'Value');
switch check
case 1
   imagesc(ID.arrayimageAr,'Parent',ID.ImageAxis1)
   axes(ID.ImageAxis1)
   axis off
   imagesc(ID.arrayimageArs,'Parent',ID.ImageAxis2)
   axes(ID.ImageAxis2)
   axis off
case 2   
   imagesc(ID.arrayimageAp,'Parent',ID.ImageAxis1)
   axes(ID.ImageAxis1)
   axis off
   imagesc(ID.arrayimageAps,'Parent',ID.ImageAxis2)
   axes(ID.ImageAxis2)
   axis off
case 3
   imagesc(ID.arrayimageAm,'Parent',ID.ImageAxis1)
   axes(ID.ImageAxis1)
   axis off
   imagesc(ID.arrayimageAms,'Parent',ID.ImageAxis2)
   axes(ID.ImageAxis2)
   axis off
   colormap(jet)
end
colormap(jet)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
case 'Compile'
   APD=[];
   ID.Ch_XY=ImpulseA('LUT Reading');
   channel=ID.Ch_XY(:,1);
   nums=1:256;
   [Filename Pathname]=uigetfile('c:\*.ste','Open the file');  
   if Filename~=0
   ImpulseA('Compile Window')
   fid= fopen([Pathname Filename]);
   acount=1;
   first=1;
   while ~feof(fid);
      if first==1;
         Artifact(acount,:)=str2num(fgetl(fid));
         APD(acount,:)=str2num(fgetl(fid));
         Amplitude(acount,:)=str2num(fgetl(fid));
         first=2;
      else
         b=str2num(fgetl(fid));
         c=str2num(fgetl(fid));
         d=str2num(fgetl(fid));
         Artifact(acount,:)=0*zeros(1,length(Artifact(acount-1,:)));
         APD(acount,:)=0*zeros(1,length(APD(acount-1,:)));
         Amplitude(acount,:)=0*zeros(1,length(Amplitude(acount-1,:)));
         Artifact(acount,1:length(b))=b;
         APD(acount,1:length(c))=c;
         Amplitude(acount,1:length(d))=d;
      end
      
      acount=acount+1;
   end
  fclose(fid);
  MArtifact=mean(Artifact);
  ArtifactOutliers1=find(MArtifact>(5*std(MArtifact)+mean(MArtifact)));
  ArtifactOutliers2=find(MArtifact<(-5*std(MArtifact)+mean(MArtifact)));
  % This sorts out any very positive outliers from the Artifact signal
  for count=1:length(ArtifactOutliers1)
     MArtifact(ArtifactOutliers1(count))=mean(MArtifact);
  end
  for count=1:length(ArtifactOutliers2)
     MArtifact(ArtifactOutliers2(count))=mean(MArtifact);
  end
  
  % Sorts out all the noisy pixels
  SArtifact=std(Artifact);
  arrayimage1(nums)=MArtifact(channel);
  arrayimage11(nums)=SArtifact(channel);
  MAPD=mean(APD);
  SAPD=std(APD);
  arrayimage2(1,nums)=MAPD(channel);
  arrayimage22(nums)=SAPD(channel);
  ID.arrayimageAp=reshape(arrayimage2,16,16);
  ID.arrayimageAps=reshape(arrayimage22,16,16);
  MAmplitude=mean(Amplitude);
  SAmplitude=std(Amplitude);
  arrayimage3(1,nums)=MAmplitude(channel);
  arrayimage33(nums)=SAmplitude(channel)./(max(arrayimage3(1:256))-min(arrayimage3(1:256)))*100;
  ID.arrayimageAm=reshape(arrayimage3,16,16);
  ID.arrayimageAms=reshape(arrayimage33,16,16);
  ID.arrayimageAr=reshape(arrayimage1,16,16);
  arrayimage11=arrayimage11./arrayimage3;
  ID.arrayimageArs=reshape(arrayimage11,16,16);
  [row,col,val]=find(isnan(ID.arrayimageAp));
  for count=1:length(row)
    if row<17 & col<17 & row>0 & col>0 
        ID.arrayimageAr(row(count),col(count))=nanmean(arrayimage1);
        ID.arrayimageAp(row(count),col(count))=nanmean(arrayimage2);
        ID.arrayimageAm(row(count),col(count))=nanmean(arrayimage3);
        temp11=conv2(ID.arrayimageAr,[1/8 1/8 1/8;1/8 0 1/8;1/8 1/8 1/8],'same'); 
        temp22=conv2(ID.arrayimageAp,[1/8 1/8 1/8;1/8 0 1/8;1/8 1/8 1/8],'same'); 
        temp33=conv2(ID.arrayimageAm,[1/8 1/8 1/8;1/8 0 1/8;1/8 1/8 1/8],'same'); 
        ID.arrayimageAr(row(count),col(count))=temp11(row(count),col(count));
        ID.arrayimageAp(row(count),col(count))=temp22(row(count),col(count));
        ID.arrayimageAm(row(count),col(count))=temp33(row(count),col(count));
     end
  end

  
  
  
  
  ID.arrayimageAr=ID.arrayimageAr./ID.arrayimageAm*100;  % Takes the percentage change of Artifact from AP amplitude
  ID.arrayimageAm=(ID.arrayimageAm)/(max(max(ID.arrayimageAm(1:256)))-min(min(arrayimage3(1:256))))*100;
  imagesc(ID.arrayimageAr,'Parent',ID.ImageAxis1)
  axes(ID.ImageAxis1)
   axis off
   imagesc(ID.arrayimageArs,'Parent',ID.ImageAxis2)
   axes(ID.ImageAxis2)
   axis off
  
 
end % Checknig if File exists  


  

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOOK UP TABLE READING   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'LUT Reading'
 %  [a,b,c,d,channels]=textread([Log.UD.Path,'\LUT\',ID.LUT],'%d %d %d %d %d');
 Temp.Continue=0;
 LUT=ID.LUT;
      Temp.LUT=dir([Log.UD.Path Log.UD.CD 'lut' Log.UD.CD LUT '.lut']);
      if isempty(Temp.LUT)
      else
        Temp.Continue=2;
      end
      FID=fopen([Log.UD.Path Log.UD.CD 'lut' Log.UD.CD LUT],'r');
      Line=fgetl(FID);
      %To get rid of the titile
      while ~isempty(find(Line==35)) %35= '#' :Tab sysbol
         Line=fgetl(FID);
      end
      Line=str2num(Line);
      
      while length(Line)==1 %9='tab', 32=space bar
         Line=str2num(fgetl(FID));
      end
      ID.Ch_XY=[];
      if Temp.Continue==1 %*.tab
         Temp.Ch=1;
         while  length(Line)==6 %feof(FID)==0 
            ID.Ch_XY=[ID.Ch_XY;Temp.Ch Line([2 1])];
            Temp.Ch=Temp.Ch+1;
            Line=fgetl(FID);
            Line=str2num(Line);
         end
      else  %=2    *.lut
         ID.Ch_XY=[ID.Ch_XY;Line([5 1 2])];
         Temp.XSpace=inf;
         Temp.YSpace=inf;
         while  feof(FID)==0 %|length(Line)==5%
            Line=fgetl(FID);
            Line=str2num(Line);
            if isempty(find(ID.Ch_XY(:,2)==Line(1)))
               Temp.XSpace=[Temp.XSpace abs(Line(1)-ID.Ch_XY(1,2))];
            end
            if isempty(find(ID.Ch_XY(:,3)==Line(2)))
               Temp.YSpace=[Temp.YSpace abs(Line(2)-ID.Ch_XY(1,3))];
            end
            ID.Ch_XY=[ID.Ch_XY;Line([5 1 2])];
         end
         ID.Ch_XY(:,1)=ID.Ch_XY(:,1)+1;
         ID.Ch_XY(:,2:3)=[(ID.Ch_XY(:,2)-min(ID.Ch_XY(:,2)))/min(Temp.XSpace)+1    (ID.Ch_XY(:,3)-min(ID.Ch_XY(:,3)))/min(Temp.YSpace)+1];
      end
      %To open all head file
      fclose(FID);
      varargout(1)={ID.Ch_XY};  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   INCREASE CHANNEL NUMBER 		  								      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'Increase Ch'
   ID.Channel=str2num(get(ID.Pacing,'String'))+1;
   set(ID.TextP,'BackgroundColor', [0.9 0.2 0.2])
   set(ID.TextS,'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588])
      [x y]=size(ID.Data);
      if ID.Channel<x 
         set(ID.Pacing,'String',ID.Channel);
         ImpulseA('Pacing')
      else
         set(ID.Pacing,'String',x-1)
      end
      
case 'Decrease Ch'
      ID.Channel=str2num(get(ID.Pacing,'String'))-1;
   set(ID.TextP,'BackgroundColor', [0.9 0.2 0.2])
   set(ID.TextS,'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588])
      [x y]=size(ID.Data);
      if ID.Channel>=0 
         set(ID.Pacing,'String',ID.Channel);
         ImpulseA('Pacing')
      else
         set(ID.Pacing,'String',0)
      end
case 'Increase ChE'
   ID.ETCChannel=str2num(get(ID.Signal,'String'))+1;
   set(ID.TextP,'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588])
   set(ID.TextS,'BackgroundColor',[0.9 0.2 0.2])
      [x y]=size(ID.Data);
      if ID.ETCChannel<x 
         set(ID.Signal,'String',ID.ETCChannel);
         ImpulseA('ETC')
      else
         set(ID.Signal,'String',x-1)
      end
      
case 'Decrease ChE'
      ID.ETCChannel=str2num(get(ID.Signal,'String'))-1;
   set(ID.TextP,'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588])
   set(ID.TextS,'BackgroundColor',[0.9 0.2 0.2])
      [x y]=size(ID.Data);
      if ID.ETCChannel>=0 
         set(ID.Signal,'String',ID.ETCChannel);
         ImpulseA('ETC')
      else
         set(ID.Signal,'String',0)
      end

      
case 'Interpolate'
   if ~isempty(ID.currentpoint)
         yb=ID.currentpoint(1,1); 
			xb=ID.currentpoint(1,2);
if xb==1 & yb==1   
				ID.arrayimageAr(xb,yb)=(ID.arrayimageAr(xb+1,yb)+ID.arrayimageAr(xb,yb+1)+ID.arrayimageAr(xb+1,yb+1))/3;
				ID.arrayimageAm(xb,yb)=(ID.arrayimageAm(xb+1,yb)+ID.arrayimageAm(xb,yb+1)+ID.arrayimageAm(xb+1,yb+1))/3;
				ID.arrayimageAp(xb,yb)=(ID.arrayimageAp(xb+1,yb)+ID.arrayimageAp(xb,yb+1)+ID.arrayimageAp(xb+1,yb+1))/3;
			elseif xb==1 & yb==16 
				ID.arrayimageAr(xb,yb)=(ID.arrayimageAr(xb,yb-1)+ID.arrayimageAr(xb+1,yb-1)+ID.arrayimageAr(xb+1,yb))/3;
				ID.arrayimageAm(xb,yb)=(ID.arrayimageAm(xb,yb-1)+ID.arrayimageAm(xb+1,yb-1)+ID.arrayimageAm(xb+1,yb))/3;
				ID.arrayimageAp(xb,yb)=(ID.arrayimageAp(xb,yb-1)+ID.arrayimageAp(xb+1,yb-1)+ID.arrayimageAp(xb+1,yb))/3;
			elseif yb==1 & xb==16       
				ID.arrayimageAr(xb,yb)=(ID.arrayimageAr(xb-1,yb)+ID.arrayimageAr(xb-1,yb+1)+ID.arrayimageAr(xb,yb+1))/3;
				ID.arrayimageAm(xb,yb)=(ID.arrayimageAm(xb-1,yb)+ID.arrayimageAm(xb-1,yb+1)+ID.arrayimageAm(xb,yb+1))/3;
				ID.arrayimageAp(xb,yb)=(ID.arrayimageAp(xb-1,yb)+ID.arrayimageAp(xb-1,yb+1)+ID.arrayimageAp(xb,yb+1))/3;
			elseif xb==16 & yb==16  
				ID.arrayimageAr(xb,yb)=(ID.arrayimageAr(xb,yb-1)+ID.arrayimageAr(xb-1,yb-1)+ID.arrayimageAr(xb-1,yb))/3;	
				ID.arrayimageAm(xb,yb)=(ID.arrayimageAm(xb,yb-1)+ID.arrayimageAm(xb-1,yb-1)+ID.arrayimageAm(xb-1,yb))/3;	
				ID.arrayimageAp(xb,yb)=(ID.arrayimageAp(xb,yb-1)+ID.arrayimageAp(xb-1,yb-1)+ID.arrayimageAp(xb-1,yb))/3;	
			elseif xb==1 & yb~=16    
				ID.arrayimageAr(xb,yb)=(ID.arrayimageAr(xb,yb-1)+ID.arrayimageAr(xb+1,yb+1)+ID.arrayimageAr(xb+1,yb))/3;	
				ID.arrayimageAm(xb,yb)=(ID.arrayimageAm(xb,yb-1)+ID.arrayimageAm(xb+1,yb+1)+ID.arrayimageAm(xb+1,yb))/3;	
				ID.arrayimageAp(xb,yb)=(ID.arrayimageAp(xb,yb-1)+ID.arrayimageAp(xb+1,yb+1)+ID.arrayimageAp(xb+1,yb))/3;	
			elseif yb==1 & xb~=1     
				ID.arrayimageAr(xb,yb)=(ID.arrayimageAr(xb-1,yb)+ID.arrayimageAr(xb+1,yb)+ID.arrayimageAr(xb+1,yb+1))/3;	
				ID.arrayimageAm(xb,yb)=(ID.arrayimageAm(xb-1,yb)+ID.arrayimageAm(xb+1,yb)+ID.arrayimageAm(xb+1,yb+1))/3;	
				ID.arrayimageAp(xb,yb)=(ID.arrayimageAp(xb-1,yb)+ID.arrayimageAp(xb+1,yb)+ID.arrayimageAp(xb+1,yb+1))/3;	
			elseif yb==16 & xb~=16    
				ID.arrayimageAr(xb,yb)=(ID.arrayimageAr(xb-1,yb)+ID.arrayimageAr(xb+1,yb)+ID.arrayimageAr(xb,yb-1))/3;	
				ID.arrayimageAm(xb,yb)=(ID.arrayimageAm(xb-1,yb)+ID.arrayimageAm(xb+1,yb)+ID.arrayimageAm(xb,yb-1))/3;	
				ID.arrayimageAp(xb,yb)=(ID.arrayimageAp(xb-1,yb)+ID.arrayimageAp(xb+1,yb)+ID.arrayimageAp(xb,yb-1))/3;	
			elseif xb==16 & yb~=16      
				ID.arrayimageAr(xb,yb)=(ID.arrayimageAr(xb-1,yb+1)+ID.arrayimageAr(xb-1,yb-1)+ID.arrayimageAr(xb-1,yb)+ID.arrayimageAr(xb,yb+1)+ID.arrayimageAr(xb,yb-1))/5;	
				ID.arrayimageAm(xb,yb)=(ID.arrayimageAm(xb-1,yb+1)+ID.arrayimageAm(xb-1,yb-1)+ID.arrayimageAm(xb-1,yb)+ID.arrayimageAm(xb,yb+1)+ID.arrayimageAm(xb,yb-1))/5;	
				ID.arrayimageAp(xb,yb)=(ID.arrayimageAp(xb-1,yb+1)+ID.arrayimageAp(xb-1,yb-1)+ID.arrayimageAp(xb-1,yb)+ID.arrayimageAp(xb,yb+1)+ID.arrayimageAp(xb,yb-1))/5;	
			else
				ID.arrayimageAr(xb,yb)=(ID.arrayimageAr(xb,yb-1)+ID.arrayimageAr(xb+1,yb+1)+ID.arrayimageAr(xb-1,yb+1)+ID.arrayimageAr(xb-1,yb-1)+ID.arrayimageAr(xb-1,yb)+ID.arrayimageAr(xb+1,yb+1)+ID.arrayimageAr(xb+1,yb-1)+ID.arrayimageAr(xb+1,yb))/8; 
				ID.arrayimageAm(xb,yb)=(ID.arrayimageAm(xb,yb-1)+ID.arrayimageAm(xb+1,yb+1)+ID.arrayimageAm(xb-1,yb+1)+ID.arrayimageAm(xb-1,yb-1)+ID.arrayimageAm(xb-1,yb)+ID.arrayimageAm(xb+1,yb+1)+ID.arrayimageAm(xb+1,yb-1)+ID.arrayimageAm(xb+1,yb))/8; 
				ID.arrayimageAp(xb,yb)=(ID.arrayimageAp(xb,yb-1)+ID.arrayimageAp(xb+1,yb+1)+ID.arrayimageAp(xb-1,yb+1)+ID.arrayimageAp(xb-1,yb-1)+ID.arrayimageAp(xb-1,yb)+ID.arrayimageAp(xb+1,yb+1)+ID.arrayimageAp(xb+1,yb-1)+ID.arrayimageAp(xb+1,yb))/8; 
         end
         ImpulseA('MapSelect')
end
      
      
case 'Good Debugging Code'
    %       figure(9)
 %           plot(data(channel,:),'x')
 %      a=line([0 length(data(channel,:))],[temp2Value temp2Value]);
 %      b=line([0 length(data(channel,:))],[temp3Value temp3Value]);
		% b=line([0 length(data(channel,:))],[MaxBeforeETC(channel) MaxBeforeETC(channel)]);
   %      set(b,'Color',[1 0 0])
       %  line([ETC ETC],[max(data(channel,:)) min(data(channel,:))])
       %  line([ETC+ETCDuration ETC+ETCDuration],[max(data(channel,:)) min(data(channel,:))])
    %     pause
 case 'lines (503)'
[row,col,val]=find(ID.arrayimageArs>3*nanstd(arrayimage11)+nanmean(arrayimage11));
 for count=1:length(row)
    if row(count)<17 & col(count)<17 & row(count)>0 & col(count)>0 
        ID.arrayimageAr(row(count),col(count))=nanmean(arrayimage1);
        ID.arrayimageAp(row(count),col(count))=nanmean(arrayimage2);
        ID.arrayimageAm(row(count),col(count))=nanmean(arrayimage3);
        temp11=conv2(ID.arrayimageAr,[1/8 1/8 1/8;1/8 0 1/8;1/8 1/8 1/8],'same'); 
        temp22=conv2(ID.arrayimageAp,[1/8 1/8 1/8;1/8 0 1/8;1/8 1/8 1/8],'same'); 
        temp33=conv2(ID.arrayimageAm,[1/8 1/8 1/8;1/8 0 1/8;1/8 1/8 1/8],'same'); 
        ID.arrayimageAr(row(count),col(count))=temp11(row(count),col(count));
        ID.arrayimageAp(row(count),col(count))=temp22(row(count),col(count));
        ID.arrayimageAm(row(count),col(count))=temp33(row(count),col(count));
     end
  end
  [row,col,val]=find(ID.arrayimageAps>1*nanstd(arrayimage22)+nanmean(arrayimage22));
  for count=1:length(row)
     if row(count)<17 & col(count)<17 & row(count)>0 & col(count)>0 
        if row(count)==16 | col(count)==16 | row(count)==1 | col(count)==1
           if (row(count)==1 & col(count)==1)|(row(count)==16 & col(count)==1)|(row(count)==1 & col(count)==16)|(row(count)==16 & col(count)==16)
               ID.arrayimageAp(row(count),col(count))=nanmean(arrayimage2)+100*nanstd(arrayimage2);
          else
              ID.arrayimageAp(row(count),col(count))=nanmean(arrayimage2)+50*nanstd(arrayimage2);
              ID.arrayimageAm(row(count),col(count))=nanmean(arrayimage3)+4*nanstd(arrayimage3);
           end
     	 end   
        temp11=conv2(ID.arrayimageAr,[1/8 1/8 1/8;1/8 0 1/8;1/8 1/8 1/8],'same'); 
        temp22=conv2(ID.arrayimageAp,[1/8 1/8 1/8;1/8 0 1/8;1/8 1/8 1/8],'same'); 
        temp33=conv2(ID.arrayimageAm,[1/8 1/8 1/8;1/8 0 1/8;1/8 1/8 1/8],'same'); 
        temp11=conv2(temp11,[1/8 1/8 1/8;1/8 0 1/8;1/8 1/8 1/8],'same'); 
        temp22=conv2(temp22,[1/8 1/8 1/8;1/8 0 1/8;1/8 1/8 1/8],'same'); 
        temp33=conv2(temp33,[1/8 1/8 1/8;1/8 0 1/8;1/8 1/8 1/8],'same'); 
        ID.arrayimageAr(row(count),col(count))=temp11(row(count),col(count));
        ID.arrayimageAp(row(count),col(count))=temp22(row(count),col(count));
        ID.arrayimageAm(row(count),col(count))=temp33(row(count),col(count));
     end
  end

end
