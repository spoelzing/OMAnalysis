% Connexin Calculation Program
% Written By Steven Poelzing
% To start, type cxcalc('I')

function [varargout]=cxcalc(Action,varargin);
global Fig
global Log

if ~exist('Action')
   Action='I';
end

switch Action
   
case 'I'
   Fig.Line=[];
   Fig.Line1=[];
   Fig.SaveValue=0;
 	   FG_Size(3:4)=[700 500];
    	FG_Size(1:2)=[100 100];
      Fig.Figure=figure(5);
    set(Fig.Figure,...
       'Color',[0.8 0.8 0.8], ...
       'DeleteFcn','cxcalc(''Exit'');',...
         'Menu','none',...
         'Name','Cx Quantification',...
         'NumberTitle','off',...
         'Position',FG_Size, ...
         'Tag','Log');

   AxisSize=[60 30 FG_Size(3)-200 FG_Size(4)-100];
   Fig.Axis = axes('Parent',Fig.Figure, ...
     'FontName','Arial',...
     'FontUnits','points',...
     'FontWeight','normal',...
     'FontAngle','normal',...
     'NextPlot','replace',...
     'DrawMode','fast',...%     'XTickLabel',[],...
     'XTickLabelMode','auto',...
     'xtickmode','auto',...%it has to be manual after ploting
     'XTickLabelMode','auto',...
     'YTickLabel',[],...
     'Units','pixels',...
   'Color',[1 1 1], ...
	'Position',AxisSize, ...
	'Tag','Axes1', ...
	'XColor',[0 0 0], ...
	'YColor',[0 0 0], ...
   'ZColor',[0 0 0]);

%%%%%%%%%%%%%%%%%%%%%%% CHANNEL CHANGING INTERFACE
  Channel_LabelSz=[10 AxisSize(4)+45 40 20];  
  Fig.Channel_Label =uicontrol('Parent',Fig.Figure, ...
      'Units','pixels',...
		'BackgroundColor',[0.8 0.8 0.8], ...
      'FontName','Arial',...
      'FontUnits','points',...
      'FontSize',10,...
      'FontWeight','normal',...
      'FontAngle','normal',...
      'HorizontalAlignment','right', ...
		'Position',Channel_LabelSz, ...
		'String','HighT', ...
		'Style','text', ...
      'Tag','StaticText1');
Channel_LabelSz=[50 AxisSize(4)+45 50 20];  
Fig.Channel = uicontrol('Parent',Fig.Figure, ...
   'Units','pixels', ...
   'BackgroundColor',[1 1 1], ...
   'callback','cxcalc Channel',...
   'ListboxTop',0, ...
   'Position',Channel_LabelSz, ...
   'Style','edit', ...
   'Tag','EditText2');
Channel_LabelSz=[140 AxisSize(4)+45 50 20];  
Fig.PercentMax = uicontrol('Parent',Fig.Figure, ...
   'Units','pixels', ...
   'BackgroundColor',[1 1 1], ...
   'callback','cxcalc PercentMax',...
   'ListboxTop',0, ...
   'Position',Channel_LabelSz, ...
   'Style','edit', ...
   'String','75',...
   'Tag','EditText2');
Channel_LabelSz=[220 AxisSize(4)+45 40 20];  
Fig.Quant_Label =uicontrol('Parent',Fig.Figure, ...
      'Units','pixels',...
		'BackgroundColor',[0.8 0.8 0.8], ...
      'FontName','Arial',...
      'FontUnits','points',...
      'FontSize',10,...
      'FontWeight','normal',...
      'FontAngle','normal',...
      'HorizontalAlignment','right', ...
		'Position',Channel_LabelSz, ...
		'String','Quant:', ...
		'Style','text', ...
      'Tag','StaticText1');
Channel_LabelSz=[270 AxisSize(4)+45 70 20];  
Fig.Quant = uicontrol('Parent',Fig.Figure, ...
   'Units','pixels', ...
   'BackgroundColor',[1 1 1], ...
   'ListboxTop',0, ...
   'Position',Channel_LabelSz, ...
   'Style','edit', ...
   'String',' ',...
   'Tag','EditText2');
Channel_LabelSz=[10 AxisSize(4)+75 40 20];  
Fig.Label =uicontrol('Parent',Fig.Figure, ...
      'Units','pixels',...
		'BackgroundColor',[0.8 0.8 0.8], ...
      'FontName','Arial',...
      'FontUnits','points',...
      'FontSize',10,...
      'FontWeight','normal',...
      'FontAngle','normal',...
      'HorizontalAlignment','right', ...
		'Position',Channel_LabelSz, ...
		'String','LowT:', ...
		'Style','text', ...
      'Tag','StaticText1');
Channel_LabelSz=[50 AxisSize(4)+75 50 20];  
Fig.LowT = uicontrol('Parent',Fig.Figure, ...
   'Units','pixels', ...
   'BackgroundColor',[1 1 1], ...
   'ListboxTop',0, ...
   'Position',Channel_LabelSz, ...
   'Style','edit', ...
   'String','12.4',...
   'Tag','EditText2');
Channel_LabelSz=[360 AxisSize(4)+45 40 20];  
Fig.Label =uicontrol('Parent',Fig.Figure, ...
      'Units','pixels',...
		'BackgroundColor',[0.8 0.8 0.8], ...
      'FontName','Arial',...
      'FontUnits','points',...
      'FontSize',10,...
      'FontWeight','normal',...
      'FontAngle','normal',...
      'HorizontalAlignment','right', ...
		'Position',Channel_LabelSz, ...
		'String','%A:', ...
		'Style','text', ...
      'Tag','StaticText1');
Channel_LabelSz=[410 AxisSize(4)+45 70 20];  
Fig.Percent = uicontrol('Parent',Fig.Figure, ...
   'Units','pixels', ...
   'BackgroundColor',[1 1 1], ...
   'ListboxTop',0, ...
   'Position',Channel_LabelSz, ...
   'Style','edit', ...
   'String',' ',...
   'Tag','EditText2');
Channel_LabelSz=[120 AxisSize(4)+75 50 20];  
Fig.Label =uicontrol('Parent',Fig.Figure, ...
      'Units','pixels',...
		'BackgroundColor',[0.8 0.8 0.8], ...
      'FontName','Arial',...
      'FontUnits','points',...
      'FontSize',10,...
      'FontWeight','normal',...
      'FontAngle','normal',...
      'HorizontalAlignment','right', ...
		'Position',Channel_LabelSz, ...
		'String','Max Val', ...
		'Style','text', ...
      'Tag','StaticText1');
Channel_LabelSz=[175 AxisSize(4)+75 40 20];  
Fig.MaxVal = uicontrol('Parent',Fig.Figure, ...
   'Units','pixels', ...
   'BackgroundColor',[.9 .9 .9], ...
   'ListboxTop',0, ...
   'Position',Channel_LabelSz, ...
   'Style','text', ...
   'String',' ',...
   'Tag','EditText2');
Channel_LabelSz=[250 AxisSize(4)+75 60 22];
Fig.Continue = uicontrol('Parent',Fig.Figure, ...
	'Units','pixels', ...
   'Callback','cxcalc Load',...
   'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
   'ListboxTop',0, ...
	'Position',Channel_LabelSz, ...
	'String','Load', ...
   'Style','Pushbutton', ...
   'Value',0,...
   'Tag','Pushbutton1');
%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FULL SCALE CHECK BOX
%%%%%%%%%%%%%%%%%%%%%%%%
Checkboxsize=[400 470 190 20];      
  Fig.Binary=	uicontrol('Parent',Fig.Figure, ...
     		  'Units','pixels',...
     		  'Callback','cxcalc toggle',...
			  'FontName','Arial',...
			  'FontUnits','points',...
			  'FontWeight','normal',...
			  'FontAngle','normal',...
			  'Position',Checkboxsize,...
			  'Style','Checkbox',...
			  'String','Binary Image', ...
			  'Value',1,...
			  'Tag','Pushbutton1'); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  CONNEXIN SIZE & QUANTITY CALCULATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Checkboxsize=[580 400 70 20];      
   Fig.Calc=	uicontrol('Parent',Fig.Figure, ...
         'Units','pixels',...
         'FontName','times',...
         'FontUnits','points',...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Checkboxsize,...
         'String','CxCalculator', ...
         'callback','cxcalc Calc',...  
         'Tag','Pushbutton1'); 
Channel_LabelSz=[560 370 60 20];  
Fig.Label =uicontrol('Parent',Fig.Figure, ...
      'Units','pixels',...
		'BackgroundColor',[0.8 0.8 0.8], ...
      'FontName','Arial',...
      'FontUnits','points',...
      'FontSize',10,...
      'FontWeight','normal',...
      'FontAngle','normal',...
      'HorizontalAlignment','right', ...
		'Position',Channel_LabelSz, ...
		'String','# Cx43', ...
		'Style','text', ...
      'Tag','StaticText1');
      
Channel_LabelSz=[640 370 50 20];  
Fig.NumCx = uicontrol('Parent',Fig.Figure, ...
   'Units','pixels', ...
   'BackgroundColor',[.9 .9 .9], ...
   'ListboxTop',0, ...
   'Position',Channel_LabelSz, ...
   'Style','text', ...
   'String',' ',...
   'Tag','EditText2');
Channel_LabelSz=[560 340 60 20];  
Fig.Label =uicontrol('Parent',Fig.Figure, ...
      'Units','pixels',...
		'BackgroundColor',[0.8 0.8 0.8], ...
      'FontName','Arial',...
      'FontUnits','points',...
      'FontSize',10,...
      'FontWeight','normal',...
      'FontAngle','normal',...
      'HorizontalAlignment','right', ...
		'Position',Channel_LabelSz, ...
		'String','Avg Size', ...
		'Style','text', ...
      'Tag','StaticText1');
Channel_LabelSz=[640 340 50 20];  
Fig.AvgCxSize = uicontrol('Parent',Fig.Figure, ...
   'Units','pixels', ...
   'BackgroundColor',[.9 .9 .9], ...
   'ListboxTop',0, ...
   'Position',Channel_LabelSz, ...
   'Style','text', ...
   'String',' ',...
   'Tag','EditText2');
Channel_LabelSz=[560 310 80 20];  
Fig.Label =uicontrol('Parent',Fig.Figure, ...
      'Units','pixels',...
		'BackgroundColor',[0.8 0.8 0.8], ...
      'FontName','Arial',...
      'FontUnits','points',...
      'FontSize',10,...
      'FontWeight','normal',...
      'FontAngle','normal',...
      'HorizontalAlignment','right', ...
		'Position',Channel_LabelSz, ...
		'String','Median Size', ...
		'Style','text', ...
      'Tag','StaticText1');
Channel_LabelSz=[640 310 50 20];  
Fig.MedCxSize = uicontrol('Parent',Fig.Figure, ...
   'Units','pixels', ...
   'BackgroundColor',[.9 .9 .9], ...
   'ListboxTop',0, ...
   'Position',Channel_LabelSz, ...
   'Style','text', ...
   'String',' ',...
   'Tag','EditText2');
Channel_LabelSz=[560 280 80 20];  
Fig.Label =uicontrol('Parent',Fig.Figure, ...
      'Units','pixels',...
		'BackgroundColor',[0.8 0.8 0.8], ...
      'FontName','Arial',...
      'FontUnits','points',...
      'FontSize',10,...
      'FontWeight','normal',...
      'FontAngle','normal',...
      'HorizontalAlignment','right', ...
		'Position',Channel_LabelSz, ...
		'String','Stdev Size', ...
		'Style','text', ...
      'Tag','StaticText1');
Channel_LabelSz=[640 280 50 20];  
Fig.StdvCxSize = uicontrol('Parent',Fig.Figure, ...
   'Units','pixels', ...
   'BackgroundColor',[.9 .9 .9], ...
   'ListboxTop',0, ...
   'Position',Channel_LabelSz, ...
   'Style','text', ...
   'String',' ',...
   'Tag','EditText2');

Checkboxsize=[580 250 70 20];      
Fig.Save=	uicontrol('Parent',Fig.Figure, ...
         'Units','pixels',...
         'FontName','times',...
         'FontUnits','points',...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Checkboxsize,...
         'String','Save Data', ...
         'callback','cxcalc Save',...  
         'Tag','Pushbutton1'); 
Checkboxsize=[580 200 70 20];      
Fig.All=	uicontrol('Parent',Fig.Figure, ...
         'Units','pixels',...
         'FontName','times',...
         'FontUnits','points',...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Checkboxsize,...
         'String','Calc Directory', ...
         'callback','cxcalc All',...  
         'Tag','Pushbutton1'); 

figure(Fig.Figure)
icons = {['[ line([.2 .9 .5 .2 ],[.2 .2 .9 .2 ],''color'',''k'')]';
   	       '[ line([.1 .9 .5 .1 ],[.8 .8 .1 .8 ],''color'',''k'')]']};
callbacks=['cxcalc(''Increase Ch'')';'cxcalc(''Decrease Ch'')'];
PressType=['flash ';'flash '];
iconsize=[105 AxisSize(4)+45 15 25];
Fig.ChnlChanging=	btngroup('ButtonID',['S1';'S2'],...
	         'Callbacks',callbacks,...
   	      'IconFunctions',str2mat(icons{:}),...
      	   'GroupID', 'School',...
	         'GroupSize',[2 1],...   
   	      'PressType',PressType,...
      	   'BevelWidth',.1,...
         	'units','pixels',...
            'Position',iconsize);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Cx Ratio Buttons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Checkboxsize=[580 150 70 20];      
    Fig.Length=	uicontrol('Parent',Fig.Figure, ...
         'Units','pixels',...
         'FontName','times',...
         'Callback','cxcalc Length',...
         'FontUnits','points',...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Checkboxsize,...
		   'Style','togglebutton',...
         'String','Length', ...
		   'Value',0,...
         'Tag','Pushbutton1'); 
    Checkboxsize=[580 120 70 20];      
    Fig.Width=	uicontrol('Parent',Fig.Figure, ...
         'Units','pixels',...
         'Callback','cxcalc Width',...
         'FontName','times',...
         'FontUnits','points',...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Checkboxsize,...
		   'Style','togglebutton',...
         'String','Width', ...
		   'Value',0,...
         'Tag','Pushbutton1'); 
Channel_LabelSz=[560 90 60 20];  
Fig.Label =uicontrol('Parent',Fig.Figure, ...
      'Units','pixels',...
		'BackgroundColor',[0.8 0.8 0.8], ...
      'FontName','Arial',...
      'FontUnits','points',...
      'FontSize',10,...
      'FontWeight','normal',...
      'FontAngle','normal',...
      'HorizontalAlignment','right', ...
		'Position',Channel_LabelSz, ...
		'String','L/W Ratio', ...
		'Style','text', ...
      'Tag','StaticText1');
Channel_LabelSz=[630 90 40 20];  
Fig.LWratio= uicontrol('Parent',Fig.Figure, ...
   'Units','pixels', ...
   'BackgroundColor',[.9 .9 .9], ...
   'ListboxTop',0, ...
   'Position',Channel_LabelSz, ...
   'Style','text', ...
   'String',' ',...
   'Tag','EditText2');
Channel_LabelSz=[560 60 50 20];  
Fig.Label =uicontrol('Parent',Fig.Figure, ...
      'Units','pixels',...
		'BackgroundColor',[0.8 0.8 0.8], ...
      'FontName','Arial',...
      'FontUnits','points',...
      'FontSize',10,...
      'FontWeight','normal',...
      'FontAngle','normal',...
      'HorizontalAlignment','right', ...
		'Position',Channel_LabelSz, ...
		'String','Angle', ...
		'Style','text', ...
      'Tag','StaticText1');
Channel_LabelSz=[630 60 40 20];  
Fig.Angle = uicontrol('Parent',Fig.Figure, ...
   'Units','pixels', ...
   'BackgroundColor',[.9 .9 .9], ...
   'ListboxTop',0, ...
   'Position',Channel_LabelSz, ...
   'Style','text', ...
   'String',' ',...
   'Tag','EditText2');
Channel_LabelSz=[560 30 50 20];  
Fig.Label =uicontrol('Parent',Fig.Figure, ...
      'Units','pixels',...
		'BackgroundColor',[0.8 0.8 0.8], ...
      'FontName','Arial',...
      'FontUnits','points',...
      'FontSize',10,...
      'FontWeight','normal',...
      'FontAngle','normal',...
      'HorizontalAlignment','right', ...
		'Position',Channel_LabelSz, ...
		'String','Length', ...
		'Style','text', ...
      'Tag','StaticText1');
Channel_LabelSz=[630 30 40 20];  
Fig.LengthV = uicontrol('Parent',Fig.Figure, ...
   'Units','pixels', ...
   'BackgroundColor',[.9 .9 .9], ...
   'ListboxTop',0, ...
   'Position',Channel_LabelSz, ...
   'Style','text', ...
   'String',' ',...
   'Tag','EditText2');


 Temp.File={
     'File'                       '                         '
     '>Save Data   '          'cxcalc(''Save'')       '
     '>Export Single Channel' 'cxcalc(''SaveRaw'')    '
     '>Exit        '          'cxcalc(''Exit'')       '};
  makemenu(Fig.Figure,char(Temp.File(:,1)),char(Temp.File(:,2)));
  set(Fig.Figure,'ResizeFcn','cxcalc(''ResizeFcn'')');
set(Fig.Figure,'WindowButtonDownFcn','CxCalc(''Mouse Down'')')


  [Fig.Filename, Fig.Pathname] = uigetfile('E:\*.jpg', 'Open Tiff');
  set(Fig.Figure,'Name',['Cx Quantification:  ',Fig.Filename]);
  if Fig.Pathname~=0
     [x,y]=imread([Fig.Pathname Fig.Filename]);
   [a1,a2,a3]=size(x);
   if a3>1
     x=rgb2gray(x);
   end
      x=double(x);
    loval=min(min(x));
  x=x-loval;
  Fig.image=x;
  Fig.hival=max(max(x));
  set(Fig.MaxVal,'String',num2str(Fig.hival));
  %  y=wthresh(Fig.image,'h',.75*Fig.hival);
  temp=Fig.image;
  temp(find(Fig.image<.75*Fig.hival))=0;
  y=temp;
  Fig.yp=im2bw(y,0.5);
  set(Fig.Quant,'String',num2str(sum(sum(Fig.yp))));
  FG_Size=get(Fig.Figure,'Position');
  if get(Fig.Binary,'Value')
     imagesc(Fig.yp,'Parent',Fig.Axis);
  else
     imagesc(Fig.image,'Parent',Fig.Axis);
  end
  colormap(gray)
  set(Fig.Channel,'String',num2str(Fig.hival*.75))
  sumhigh=sum(sum(Fig.yp));
  Threshlow=str2num(get(Fig.LowT,'String'));
%  y2=wthresh(Fig.image,'s',Threshlow);
  temp=Fig.image;
  temp(find(Fig.image<Threshlow))=0;
  y2=temp;

  yp2=im2bw(y2);
  sumlow=sum(sum(yp2));
  set(Fig.Percent,'String',num2str(sumhigh/sumlow*100));
end % Ends the if ~isempty(Fig.Filename)


case 'Length'
   set(Fig.Width,'Value',0);
   
case 'Width'
   set(Fig.Length,'Value',0);


case 'Load'
   Fig.Line=[];
   Fig.Line1=[];
   [Fig.Filename, Fig.Pathname] = uigetfile([Fig.Pathname,'\*.jpg'], 'Open Tiff');
   if Fig.Filename~=0
  [x,jet]=imread([Fig.Pathname Fig.Filename]);
   [a1,a2,a3]=size(x);
   if a3>1
      x=rgb2gray(x);
   end
      x=double(x);
 
  set(Fig.Figure,'Name',['Cx Quantification:  ',Fig.Filename]);
  loval=min(min(x));
  x=x-loval;
  Fig.image=x;
  Fig.hival=max(max(x));
  Thresh=str2num(get(Fig.Channel,'String'))+1;
  %  y=wthresh(Fig.image,'s',Thresh);
  temp=Fig.image;
  temp(find(Fig.image<Thresh))=0;
  y=temp;
  Fig.yp=im2bw(y,0.5);
  set(Fig.Quant,'String',num2str(sum(sum(Fig.yp))));
  if get(Fig.Binary,'Value')
     imagesc(Fig.yp,'Parent',Fig.Axis);
     colormap(gray)
 else
     imagesc(Fig.image,'Parent',Fig.Axis);
     colormap jet
  end

  sumhigh=sum(sum(Fig.yp));
  Threshlow=str2num(get(Fig.LowT,'String'));
  % y2=wthresh(Fig.image,'s',Threshlow);
  temp=Fig.image;
  temp(find(Fig.image<Threshlow))=0;
  y2=temp;
  
  yp2=im2bw(y2);
  sumlow=sum(sum(yp2));
  set(Fig.Percent,'String',num2str(sumhigh/sumlow*100));
else
   disp('NO FILE LOADED')
end
cxcalc('ResizeFcn')
  %cxcalc('Calc');
  %cxcalc('Save');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   INCREASE CHANNEL NUMBER 													  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'Channel'
  Thresh=str2num(get(Fig.Channel,'String'));
  % y=wthresh(Fig.image,'s',Thresh);
  temp=Fig.image;
  temp(find(Fig.image<Thresh))=0;
  y=temp;
  
  Fig.yp=im2bw(y);
  set(Fig.Quant,'String',num2str(sum(sum(Fig.yp))));
  if get(Fig.Binary,'Value')
     imagesc(Fig.yp,'Parent',Fig.Axis);
  else
     imagesc(Fig.image,'Parent',Fig.Axis);
  end

  
  
  sumhigh=sum(sum(Fig.yp));
  Threshlow=str2num(get(Fig.LowT,'String'));
%  y2=wthresh(Fig.image,'s',Threshlow);
  temp=Fig.image;
  temp(find(Fig.image<Threshlow))=0;
  y2=temp;
  
  yp2=im2bw(y2);
    
  sumlow=sum(sum(yp2));
  set(Fig.Percent,'String',num2str(sumhigh/sumlow*100));
  set(Fig.PercentMax,'String',num2str(round(Thresh/Fig.hival*100)));
  
  

case 'Increase Ch'
  Thresh=str2num(get(Fig.Channel,'String'))+1;
  set(Fig.Channel,'String',num2str(Thresh));
%  y=wthresh(Fig.image,'s',Thresh);
  temp=Fig.image;
  temp(find(Fig.image<Threshlow))=0;
  y=temp;
  
  Fig.yp=im2bw(y);
  set(Fig.Quant,'String',num2str(sum(sum(Fig.yp))));
  if get(Fig.Binary,'Value')
     imagesc(Fig.yp,'Parent',Fig.Axis);
  else
     imagesc(Fig.image,'Parent',Fig.Axis);
  end
 
  sumhigh=sum(sum(Fig.yp));
  Threshlow=str2num(get(Fig.LowT,'String'));
%  y2=wthresh(Fig.image,'s',Threshlow);
  temp=Fig.image;
  temp(find(Fig.image<Threshlow))=0;
  y=temp;

  yp2=im2bw(y2);
  sumlow=sum(sum(yp2));
  set(Fig.Percent,'String',num2str(sumhigh/sumlow*100));
  set(Fig.PercentMax,'String',num2str(round(Thresh/Fig.hival*100)));
  
case 'Thresh'
  temp=Fig.image;
  temp(find(Fig.image<Thresh))=0;
  y=temp;

      
case 'Decrease Ch'
  Thresh=str2num(get(Fig.Channel,'String'))-1;
  set(Fig.Channel,'String',num2str(Thresh));
%  y=wthresh(Fig.image,'s',Thresh);
  temp=Fig.image;
  temp(find(Fig.image<Thresh))=0;
  y=temp;

  Fig.yp=im2bw(y);
  set(Fig.Quant,'String',num2str(sum(sum(Fig.yp))));
  if get(Fig.Binary,'Value')
     imagesc(Fig.yp,'Parent',Fig.Axis);
  else
     imagesc(Fig.image,'Parent',Fig.Axis);
  end
 set(Fig.Axis,'Position',[60 30 600 400]);
  
  sumhigh=sum(sum(Fig.yp));
  Threshlow=str2num(get(Fig.LowT,'String'));
  %  y2=wthresh(Fig.image,'s',Threshlow);
  temp=Fig.image;
  temp(find(Fig.image<Threshlow))=0;
  y2=temp;

  yp2=im2bw(y2);
  sumlow=sum(sum(yp2));
  set(Fig.Percent,'String',num2str(sumhigh/sumlow*100));
  set(Fig.PercentMax,'String',num2str(round(Thresh/Fig.hival*100)));
  
  
case 'PercentMax'
   percent=str2num(get(Fig.PercentMax,'String'));
   set(Fig.Channel,'String',num2str(percent/100*Fig.hival))
   cxcalc('Channel')

case 'ResizeFcn'
  	FG_Size=get(Fig.Figure,'position');  %Figure Size
   AxisSize=[60 30 FG_Size(3)-225 FG_Size(4)-100];
   set(Fig.Axis,'Position',AxisSize)
   Channel_LabelSz=[10 AxisSize(4)+45 25 20];  
   set(Fig.Channel_Label,'Position',Channel_LabelSz)
   Channel_LabelSz=[40 AxisSize(4)+45 50 20];  
   set(Fig.Channel,'Position',Channel_LabelSz); 
   iconsize=[95 AxisSize(4)+45 15 25];
   set(Fig.ChnlChanging,'position',iconsize);
   LabelSz=[150 AxisSize(4)+45 300 20];  
%    set(Fig.Error,'Position',LabelSz);
   
case 'toggle'
  Thresh=str2num(get(Fig.Channel,'String'));
  set(Fig.Channel,'String',num2str(Thresh));
%  y=wthresh(Fig.image,'s',Thresh);
  temp=Fig.image;
  temp(find(Fig.image<Thresh))=0;
  y=temp;

  Fig.yp=im2bw(y);
  set(Fig.Quant,'String',num2str(sum(sum(Fig.yp))));
  if get(Fig.Binary,'Value')
     imagesc(Fig.yp,'Parent',Fig.Axis);
     colormap gray
  else
     imagesc(Fig.image,'Parent',Fig.Axis);
     colormap jet
  end
  
  
case 'Calc'
% First we want search through the first row to see where connexins start
   [x y]=size(Fig.yp);
   NewFig=double(Fig.yp);
   count2=1;
h=waitbar(0,'Please Wait');   
for Row=1:x;
   waitbar(Row/x,h)
  count=1;
%  disp('------------------------------------------------------')
%  disp('------------------------------------------------------')
 %    Row
  cxlocation=find(NewFig(Row,:));
  %if Row==718
  %   cxlocation
  %   end
   if ~isempty(cxlocation)
      index=1;
      Locations(count,:)=[Row,cxlocation(1)];
      [rows,cols]=size(Locations);
      count=count+1;
   while index<=rows
      % We start at the first found connexin, and start looking for neighbors
      % 6:00 
    StartLocation=Locations(index,:);
    cxlocation(1)=StartLocation(1,2);
      row=StartLocation(1,1);
      if row<x & NewFig(row+1,cxlocation(1))~=0
         Locations(count,:)=[row+1,cxlocation(1)];
         NewFig(row+1,cxlocation(1))=0;
         count=count+1;
      end
      % 7:30 position   
      if cxlocation(1)>1 & row<x & NewFig(row+1,cxlocation(1)-1)~=0
         Locations(count,:)=[row+1, cxlocation(1)-1];
         NewFig(row+1,cxlocation(1)-1)=0;
         count=count+1;
      end
      % 4:30 position   
      if cxlocation(1)<y & row<x & NewFig(row+1,cxlocation(1)+1)~=0
         Locations(count,:)=[row+1, cxlocation(1)+1];
         NewFig(row+1,cxlocation(1)+1)=0;
         count=count+1;
      end
      % 3:00 position   
      if cxlocation(1)<y & NewFig(row,cxlocation(1)+1)~=0
         Locations(count,:)=[row, cxlocation(1)+1];
         NewFig(row,cxlocation(1)+1)=0;
         count=count+1;
      end
      index=index+1;
      [rows,cols]=size(Locations);
     % Locations
      end  % while
      [num,asdf]=size(Locations);
      Connexin(count2)=num;
      count2=count2+1;
  end
  cxlocation=find(NewFig(Row,:));
  count=1;
  Locations=[];
end
Connexins=Connexin(find(Connexin>=5));
set(Fig.AvgCxSize,'String',num2str(mean(Connexins)))
set(Fig.NumCx,'String',num2str(length(Connexins)))    
set(Fig.MedCxSize,'String',num2str(median(Connexins)))
set(Fig.StdvCxSize,'String',num2str(std(Connexins)))
close(h)
   
case 'Save'
   if Fig.SaveValue==0;
      [Filename, Pathname] = uiputfile('c:\windows\desktop\*.*', 'Save File');
      if Filename~=0  % 2
         Fig.fid=fopen([Pathname Filename],'wb');
         first=['Filename,Percent Cx43,Area of Cells,Cx43 Quantity,Average Cx43 Size,Stdev Cx43 Size,Number of Gap Junctions,Median Cx43 Size'];
         fprintf(Fig.fid,'%s \n',first);
         Fig.SaveValue=1;
      end
   end
if Fig.SaveValue~=0
  Thresh=str2num(get(Fig.LowT,'String'))-1;
%  y=wthresh(Fig.image,'s',Thresh);
  temp=Fig.image;
  temp(find(Fig.image<Thresh))=0;
  y=temp;
  
  Fig.yp=im2bw(y);
  a1=(get(Fig.Percent,'String'));
  a=num2str(sum(sum(Fig.yp)));
  b=(get(Fig.Quant,'String'));
  c=(get(Fig.AvgCxSize,'String'));
  c1=(get(Fig.StdvCxSize,'String'));
  d=(get(Fig.NumCx,'String'));    
  e=(get(Fig.MedCxSize,'String'));
  second=[Fig.Filename,',',a1,',',a,',',b,',',c,',',c1,',',d,',',e,];
  fprintf(Fig.fid,'%s \n',second);
end

   
case 'All'
[Fig.Filename, Fig.Pathname] = uigetfile([Fig.Pathname,'\*.jpg'], 'Open Tiff');
filenames=dir([Fig.Pathname,'\*.jpg']);
Temp.AllFiles=filenames;
Temp.AllFileNames={};
x=[1:length(Temp.AllFiles)];
index=1;

for i=1:length(Temp.AllFiles);
      Temp.AllFileNames=[Temp.AllFileNames;{[Temp.AllFiles(i).name]}];
end
a=strvcat(Temp.AllFileNames);
b=a;
%b=sort(a)
%return

for i=1:length(Temp.AllFiles);
   [x,y]=imread([Fig.Pathname b(i,:)]);
   [a1,a2,a3]=size(x);
   if a3==3
     x=rgb2gray(x);
   end
     x=double(x);


   Fig.Filename=b(i,:);
   set(Fig.Figure,'Name',['Cx Quantification:  ',b(i,:)]);
   loval=min(min(x));
   x=x-loval;
   Fig.image=x;
   Fig.hival=max(max(x));
   Thresh=str2num(get(Fig.Channel,'String'))+1;
%   y=wthresh(Fig.image,'s',Thresh);
   temp=Fig.image;
   temp(find(Fig.image<Thresh))=0;
   y=temp;
  
   Fig.yp=im2bw(y,0.5);
   set(Fig.Quant,'String',num2str(sum(sum(Fig.yp))));
   if get(Fig.Binary,'Value')
      imagesc(Fig.yp,'Parent',Fig.Axis);
   else
      imagesc(Fig.image,'Parent',Fig.Axis);
   end

   colormap(gray)
   sumhigh=sum(sum(Fig.yp));
   Threshlow=str2num(get(Fig.LowT,'String'));
   %  y2=wthresh(Fig.image,'s',Threshlow);
   temp=Fig.image;
   temp(find(Fig.image<Threshlow))=0;
   y2=temp;
   
   yp2=im2bw(y2);
   sumlow=sum(sum(yp2));
   set(Fig.Percent,'String',num2str(sumhigh/sumlow*100));
   cxcalc('Calc');
   cxcalc('Save');
end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   MOUSE DOWN                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

case 'Mouse Down'
    
   if get(Fig.Length,'Value');
     Current_Axis=axis;
     Position=get(Fig.Axis,'currentpoint');
     if (Position(1,2)>Current_Axis(3) & Position(1,2)<Current_Axis(4))
        Fig.Start=Position;
        if ~isempty(Fig.Line)
           delete(Fig.Line)
        end
        Fig.Line=line([Fig.Start(1,1) Fig.Start(1,1)],[Position(1,2) Position(1,2)]);
        set(Fig.Line,'EraseMode','xor')
        set(Fig.Line,'Color',[0 1 0])
        set(Fig.Figure,'WindowButtonMotionFcn','Cxcalc(''Mouse Move'')')
        set(Fig.Figure,'WindowButtonUpFcn','Cxcalc(''Mouse Move Up'')');
     end
  elseif get(Fig.Width,'Value');
     Current_Axis=axis;
     Position=get(Fig.Axis,'currentpoint');
     if (Position(1,2)>Current_Axis(3) & Position(1,2)<Current_Axis(4))
        Fig.Start=Position;
        if ~isempty(Fig.Line1)
           delete(Fig.Line1)
        end
        Fig.Line1=line([Fig.Start(1,1) Fig.Start(1,1)],[Position(1,2) Position(1,2)]);
        set(Fig.Line1,'EraseMode','xor')
        set(Fig.Figure,'WindowButtonMotionFcn','Cxcalc(''Mouse Move'')')
        set(Fig.Figure,'WindowButtonUpFcn','Cxcalc(''Mouse Move Up'')');
     end
  end
  
  
case 'Mouse Move'
   if get(Fig.Length,'Value');
     Position=get(Fig.Axis,'currentpoint');
     set(Fig.Line,'XData',[Fig.Start(1,1) Position(1,1)],'YData',[Fig.Start(1,2) Position(1,2)]);
  elseif get(Fig.Width,'Value');
     Position=get(Fig.Axis,'currentpoint');
     set(Fig.Line1,'XData',[Fig.Start(1,1) Position(1,1)],'YData',[Fig.Start(1,2) Position(1,2)]);
  end


case 'Mouse Move Up'
   set(Fig.Figure,'WindowButtonMotionFcn','Cxcalc('' '')');
   set(Fig.Figure,'WindowButtonUpFcn','Cxcalc('' '')');
   lengthx=get(Fig.Line,'XData');
   lengthy=get(Fig.Line,'YData');
   widthx=get(Fig.Line1,'XData');
   widthy=get(Fig.Line1,'YData');
   if get(Fig.Width,'Value')
      TotLength=sqrt((lengthx(1,1)-lengthx(1,2))^2+(lengthy(1,1)-lengthy(1,2))^2);
	   width=sqrt((widthx(1,1)-widthx(1,2))^2+(widthy(1,1)-widthy(1,2))^2);
      set(Fig.LWratio,'String',num2str(TotLength/width));
   end
   x=-(lengthx(1,1)-lengthx(1,2));
   y=(lengthy(1,1)-lengthy(1,2));
   VectorAngle=atan2(y,x)*180/pi;
   if VectorAngle<0
      VectorAngle=360+VectorAngle;
   end
   
   set(Fig.Angle,'String',num2str(VectorAngle));
   if get(Fig.Length,'Value')==1
      TotLength=sqrt((lengthx(1,1)-lengthx(1,2))^2+(lengthy(1,1)-lengthy(1,2))^2);
      set(Fig.LengthV,'String',num2str(TotLength));
   end
   
   
   
   
   
   
case 'Exit'
   close(Fig.Figure)
   fclose all;
  
end
