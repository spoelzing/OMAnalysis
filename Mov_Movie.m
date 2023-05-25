function [varargout]=Mov_Movie(varargin)
action = varargin{1};
warning('off')

% Changes in Zeng's Stripchart program. Added a subroutine called movies which is called from the Stripchart Menu. The subroutine is as follows:
%case 'Movies'
%	save Data Data
%	clear Data
%	Mov_Movie Initial

% Changes in Zeng_Log
% Changed Log.UD.Path= to the directory where the data can be found

% Added following lines to Zeng_Stripchart under the headings of Delete Patch and Upgrade Patch
%    if ~isempty(Movs)
%	    Mov_Movie 'Update All'
%    end 
%
% Also added global Movs, to Zeng_Stripchart
global UD
global Log
global Data
global Movs
global axishd
global Stripchart
global Movielog
global LUTDisplay
%global originaldata
switch action
%================================================================
case 'Initial'
   Movs.Badpic=[];
   Stripchart=get(gcbf,'userdata');
   Movs.FR=1;
   Movs.countI=0;
   Movs.Signal.True=0;
   Movs.Last=0;
   Movs.Interp=0;
   Movs.Deriv=0;
   Movs.Pass=1;
   Movs.count=1;
   UD.Ref.FontSize=8;
   Movs.Filter=5;
   Movs.Threshold=0;
   Movs.Overlap=0;
[row,col]=size(Data);
for count=1:col
    if ~isempty(Data{count})
        Movs.strct=count;
    end
end

if Log.Head.Chans==144
     Movs.xydim=[12,12];
     Movs.Head.Chans=Log.Head.Chans;
elseif Log.Head.Chans>5270 & Log.Head.Chans<5290
     Movs.xydim=[88,60];
     Movs.Head.Chans=5280;
elseif Log.Head.Chans>1319 & Log.Head.Chans<1839;
     Movs.xydim=[44,30];
     Movs.Head.Chans=1320;
elseif Log.Head.Chans>1839 & Log.Head.Chans<1850 % HS02 46x40 VT
     Movs.xydim=[46,40];
     Movs.Head.Chans=1840;
elseif Log.Head.Chans>1000
    Movs.xydim=[floor(sqrt(Log.Head.Chans)) floor(sqrt(Log.Head.Chans))];
    Movs.Head.Chans=Movs.xydim(1)^2;
elseif Log.Head.LUT=='ultima25x25'
    Movs.xydim=[25,25];
    Movs.Head.Chans=625;
end


   if isempty(findobj(Stripchart.Axes,'type','patch','LineWidth',Log.UD.Ref.ThickLine));
      Movs.Display.X1X2=[1;Log.Head.Samples];
  else
      Temp.Patch=findobj(Stripchart.Axes,'type','patch','LineWidth',Log.UD.Ref.ThickLine);
      Movs.Display.X1X2=get(Temp.Patch,'xdata');
      Movs.Display.X1X2=round(Movs.Display.X1X2(1:2));
	  Movs.count=Movs.Display.X1X2(1);
      LUTDisplay.Color=get(Temp.Patch,'EdgeColor');
      LUTDisplay.WaveForm=findobj(0,'type','figure','tag','WaveForm','name',[Stripchart.Head.FileName ':' 'WaveForm'],'color',LUTDisplay.Color);
   end
     %if isempty(LUTDisplay.WaveForm)
         %Mov('Error','I will work only when you have WaveForm window for me !!!');
         %else
         if nargin==1
            %'initial'
            Temp.Type='Movie Display';
         elseif nargin==2
            %'initial' & 'Contour'
            Temp.Type='Contour';
         end
%         FG_Size=[3 325 UD.HD.LUTDisplay.FG_Limit];
 	   FG_Size(3:4)=[570 440];
    	FG_Size(1:2)=[Log.UD.ScreenSize(1)-FG_Size(4)*2.2 Log.UD.ScreenSize(2)-FG_Size(4)*1.1-40 ];
      %   FG_Size=[10 280 570 440];
         Movs.Display.Figure=figure;
         figure(Movs.Display.Figure)   

         LUTDisplay.Parent=Movs.Display.Figure;
         Stripchart.LUTDisplay=[Stripchart.LUTDisplay;Movs.Display.Figure];
         set(Movs.Display.Figure,'userdata',Stripchart);
         set(Movs.Display.Figure,'Units','points', ...
            'DeleteFcn','Mov_Movie(''Delete'');',...
            'menu','none',...
            'Name',[Stripchart.Head.FileName ':' Temp.Type],...
            'NumberTitle','off',...
            'Units','pixels',...
            'Position',FG_Size, ...
            'selected','on',...
            'Tag',Temp.Type,...
            'visible','off');
         Axissize=[17.1/FG_Size(3) 136.4/FG_Size(4) 0.47 0.63];
         Movs.Axes = axes('Parent',Movs.Display.Figure, ...
            'box','off',...
            'Color',[1 1 1], ...%'xlabel',[],...%  
            'FontName','Arial',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','normal',...
            'FontAngle','normal',...
		  		'NextPlot','replace',...
				'DrawMode','fast',...%     'XTickLabel',[],...
     			'XTickLabelMode','auto',...
 		    	'xtickmode','auto',...%it has to be manual after ploting
 		    	'XTickLabelMode','auto',...
            'Units','normalized',...
            'Position',Axissize);
         if ~strcmp(Stripchart.Head.Sys_Ver,'Optical Mapping System')
            set(Movs.Axes,'YDir','reverse')
         end
         
         
         Axissize=[11.4/FG_Size(3) 4.4/FG_Size(4) 0.98 0.2];
         Movs.Plot = axes('Parent',Movs.Display.Figure, ...
            'box','off',...
            'Color',[1 1 1], ...%'xlabel',[],...%
            'FontName','Arial',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','normal',...
            'FontAngle','normal',...
            'NextPlot','add',...%To add the colorbar
            'DrawMode','fast',...%     'XTickLabel',[],...
            'XTickLabel',[],...
            'XTick',[],...
            'XTickLabelMode','manual',...
            'XTickMode','manual',...
            'YTickLabel',[],...
            'YTick',[],...
            'YTickLabelMode','manual',...
            'YTickMode','manual',...
			   'Ylim',[0 256],...
            'Units','normalized',...
            'Position',Axissize);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %   FRAMES                             %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Movs.Frame(1) = uicontrol('Parent',Movs.Display.Figure, ...
			 'Position',[FG_Size(3)/1.95 (FG_Size(3)-305) (FG_Size(3)-300) 1], ...
          'Style','frame');
    Movs.Frame(2) = uicontrol('Parent',Movs.Display.Figure, ...
			 'Position',[FG_Size(3)/1.95 (FG_Size(3)-185) (FG_Size(3)-300) 1], ...
          'Style','frame');
    Movs.Frame(3) = uicontrol('Parent',Movs.Display.Figure, ...
			 'Position',[FG_Size(3)/1.95 (FG_Size(3)-305) 1 (FG_Size(4)-320)], ...
          'Style','frame');
    Movs.Frame(4) = uicontrol('Parent',Movs.Display.Figure, ...
			 'Position',[FG_Size(3)/1.015 (FG_Size(3)-305) 1 (FG_Size(4)-320)], ...
          'Style','frame');
       
%***********************************
%  THE SMOOTHING STUFF
%**********************************
   Axissize=[FG_Size(3)/1.9 FG_Size(4)/1.25 69 25];
   Movs.Button.Smooth=	uicontrol('Parent',Movs.Display.Figure, ...
         'Units','pixels',...
         'FontName','times',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Axissize,...
         'String','Smooth', ...
         'callback','Mov_Movie(''Smooth'')',...  
         'Tag','Pushbutton1'); 
  	icons = {['[ line([.2 .9 .5 .2 ],[.2 .2 .9 .2 ],''color'',''k'')]';
   	       '[ line([.1 .9 .5 .1 ],[.8 .8 .1 .8 ],''color'',''k'')]']};
   callbacks=['Mov_Movie(''IncreaseSm'')';'Mov_Movie(''DecreaseSm'')'];
   PressType=['flash ';'flash '];
   Size1=[FG_Size(3)/1.33 FG_Size(4)/1.25 16 20]; 
   Movs.Button.SmoothChanging=btngroup(Movs.Display.Figure,...
         'ButtonID',['Smooth1';'Smooth2'],...
       	'GroupID', 'smooth2',...
        'Callbacks',callbacks,...
   	   'IconFunctions',str2mat(icons{:}),...
	      'GroupSize',[2 1],...   
         'PressType',PressType,...
      	'BevelWidth',.1,...
         'units','pixels',...
         'Position',Size1);  
       
 %******************************************
 %    ALL TEXT
 %******************************************
Axissize=[FG_Size(3)/1.9 FG_Size(3)-340 100 15];
Movs.text1 =uicontrol('Parent',Movs.Display.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','times',...
            'FontUnits','points',...
            'FontSize',8,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',Axissize, ...
            'String','PROCESSING ', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','off');
Axissize=[FG_Size(3)/1.2955 FG_Size(4)/.9068 120 15];
Movs.text2 =uicontrol('Parent',Movs.Display.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','times',...
            'FontUnits','points',...
            'FontSize',8,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',Axissize, ...
            'String','DATA VIEWING ', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','off');
   Axissize=[FG_Size(3)/1.55 FG_Size(3)-150 145 15];
   Movs.text3 =uicontrol('Parent',Movs.Display.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','times',...
            'FontUnits','points',...
            'FontSize',8,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',Axissize, ...
            'String','DATA PROCESSING ', ...
            'Style','text', ...
            'Tag','StaticText3',...
            'visible','off');
     
%******************       
% COLOR MAPS
%******************
         
     values = {['Gray          ';'Black Red     ';'Black Blue    ';'Jet           ';'Blue Black Red']};
    Axissize=[FG_Size(3)/1.3 FG_Size(4)/2.15 100 22];
    Movs.Colormaps = uicontrol('Parent',Movs.Display.Figure, ...
        'Units','pixels', ...
        'BackgroundColor',[0.733333 0.733333 0.733333], ...
   	  'callback','Mov_Movie ClrMaps',...
        'Enable','on', ...
        'ListboxTop',0, ...
        'Position',Axissize, ...
        'String',values, ...
        'Style','popupmenu', ...
        'Tag','PopupMenu1', ...
        'Value',1);
Axissize=[FG_Size(3)/1.3 FG_Size(4)/1.9 60 12];
Movs.text.Colormaps =uicontrol('Parent',Movs.Display.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','Arial',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',Axissize, ...
            'String','ColorMaps ', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
         
LUTDisplay.LUT=Stripchart.Head.LUT;
axes(Movs.Plot);
         LUTDisplay.Colorbar=colorbar;
         set(LUTDisplay.Colorbar,'YTickLabelMode','manual');
         set(LUTDisplay.Colorbar,'YTickMode','manual');
         LUTDisplay.CurrentAxes=1;%for number running in waveForm
         
   
   % TEXT FOR FRAME RATE BOX
 Axissize=[FG_Size(3)/2.85 FG_Size(4)/4.3 33 13];
 Movs.Edit.Channel_Label =uicontrol('Parent',Movs.Display.Figure, ...
      'Units','pixels',...
	  'BackgroundColor',[0.8 0.8 0.8], ...
      'FontName','times',...
      'FontUnits','points',...
      'FontSize',UD.Ref.FontSize,...
      'FontWeight','normal',...
      'FontAngle','normal',...
      'HorizontalAlignment','center', ...
      'Position',Axissize, ...
	  'String','Slow', ...
	  'Style','text', ...
      'Tag','StaticText1');
% ACTUAL INFORMATION INSIDE THE FRAME RATE EDIT BOX
 Axissize=[FG_Size(3)/2.4051 FG_Size(4)/4.4 30 22];
 Movs.Edit.Channel = uicontrol('Parent',Movs.Display.Figure, ...
        'Units','pixels',...
   	  'BackgroundColor',[1 1 1], ...
        'FontName','times',...
        'FontUnits','points',...
        'FontSize',UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',Axissize, ...
        'String',Movs.FR, ...
   	  'Style','edit', ...
	     'Tag','EditCh',...
   	  'callback','Mov_Movie(''EdBox'')');      
     
     %########################    ()()()()()()()()()()()()()()()()()
     % INTERPOLATE BUTTONS          ALL OTHER BUTTONS AS WELL
     %########################    ()()()()()()()()()()()()()()()()()()
     
  
 Axissize=[FG_Size(3)/1.9 FG_Size(4)/2.15 69 25];
 Movs.Button.Interpolate=	uicontrol('Parent',Movs.Display.Figure, ...
         'Units','pixels',...
         'FontName','times',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Axissize,...
         'String','Interpolate', ...
         'callback','Mov_Movie(''Interpolate'')',...  
         'Tag','Pushbutton1'); 

  Axissize=[FG_Size(3)/1.9 FG_Size(4)/1.38 69 25];
  Movs.Button.Derivs1=	uicontrol('Parent',Movs.Display.Figure, ...
         'Units','pixels',...
         'FontName','times',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Axissize,...
         'String','dV/dt', ...
         'callback','Mov_Movie(''Derivs'')',...  
         'Tag','Pushbutton1'); 

   Axissize=[FG_Size(3)/1.9 FG_Size(4)/1.54 69 25];
   Movs.Button.DerivsA=	uicontrol('Parent',Movs.Display.Figure, ...
         'Units','pixels',...
	  	 	'Enable','on',...
         'FontName','times',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Axissize,...
         'String','dV/dt +V', ...
         'callback','Mov_Movie(''Add Deriv'')',...  
         'Tag','Pushbutton1'); 

   Axissize=[FG_Size(3)/1.9 FG_Size(4)/2.6 70 25];
   Movs.Button.Invert=	uicontrol('Parent',Movs.Display.Figure, ...
         'Units','pixels',...
         'FontName','times',...
         'FontUnits','points',...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Axissize,...
         'String','Invert', ...
         'callback','Mov_Movie(''Invert'')',...
         'Style','checkbox',...
         'Value',1,...
         'Tag','Pushbutton1'); 		 
      
   Axissize=[FG_Size(3)/1.20 FG_Size(4)/1.38 69 25];
   Movs.Button.Thresh=	uicontrol('Parent',Movs.Display.Figure, ...
         'Units','pixels',...
		 'Enable','on',...
         'FontName','times',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Axissize,...
         'String','Threshold ...', ...
         'callback','Mov_Normalize(''Initial'')',...  
         'Tag','Pushbutton1'); 

   Axissize=[FG_Size(3)/1.20 FG_Size(4)/1.25 69 25];
   Movs.Button.Filters=	uicontrol('Parent',Movs.Display.Figure, ...
         'Units','pixels',...
         'FontName','times',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Axissize,...
         'String','Filters ...', ...
         'callback','Mov_Filters(''Initial'')',...  
         'Tag','Pushbutton1'); 

   Axissize=[FG_Size(3)/1.55 FG_Size(3)-180 45 25];
    Movs.Button.Global=	uicontrol('Parent',Movs.Display.Figure, ...
         'Units','pixels',...
         'FontName','times',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Axissize,...
		   'Style','togglebutton',...
         'String','Global', ...
         'callback','Mov_Movielog(''Global'')',...  
		   'Value',1,...
         'Tag','Pushbutton1'); 
   Axissize=[FG_Size(3)/1.35 FG_Size(3)-180 45 25];
   Movs.Button.Local=	uicontrol('Parent',Movs.Display.Figure, ...
         'Units','pixels',...
         'FontName','times',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Axissize,...
		   'Style','togglebutton',...
         'String','Local', ...
         'callback','Mov_Movielog(''Local'')',...  
         'Value',0,...
	  	   'Tag','Pushbutton1');  
		 
         
         
   % SHOW CHANNELS BUTTON 
   icons = {['[ text(0.0,0.5,''Channels''   ,''HorizontalAlignment'',''left'',''VerticalAlignment'',''middle'',''color'')] ']};
     Size1=[FG_Size(3)/1.2955 FG_Size(4)/3 100 25]; 
     Movs.Button.Channels= uicontrol('Parent',Movs.Display.Figure,...
            'Callback','Mov_Movie(''Channels'')',...
            'units','pixels',...
            'String','Show Channels',...
            'Style','checkbox', ...
            'Tag','Channels',...
            'Position', Size1);
			
  Size1=[FG_Size(3)/1.9 FG_Size(4)/3.2 70 25]; 
  Movs.Button.FS= uicontrol('Parent',Movs.Display.Figure,...
            'Callback','Mov_Movie(''FullScale'')',...
            'units','pixels',...
            'String','Full Scale',...
            'Style','checkbox', ...
            'Tag','FullScale',...
 			   'value',1,...
            'Position', Size1);
         
     %-------------------------------------------------
     % THE UP DOWN BUTTONS FOR THE FRAME RATE       
     %-------------------------------------------------
	%Create Changing channel button group
   
  	icons = {['[ line([.2 .9 .5 .2 ],[.2 .2 .9 .2 ],''color'',''k'')]';
   	       '[ line([.1 .9 .5 .1 ],[.8 .8 .1 .8 ],''color'',''k'')]']};
  callbacks=['Mov_Movie(''IncreaseFR'')';'Mov_Movie(''DecreaseFR'')'];
   PressType=['flash ';'flash '];
   Size1=[FG_Size(3)/2.1111 FG_Size(4)/4.4 16 20]; 
   Movs.Button.Threshchange=	btngroup(Movs.Display.Figure,...
           'ButtonID',['T1';'T2'],...
	        'Callbacks',callbacks,...
   	     'IconFunctions',str2mat(icons{:}),...
      	  'GroupID', 'ViewGraph',...
	        'GroupSize',[2 1],...   
   	     'PressType',PressType,...
      	  'BevelWidth',.075,...
           'units','pixels',...
           'Position',Size1);    
			  % TEXT 

  Size1=[FG_Size(3)/1.5405 FG_Size(4)/1.25 33 26]; 
  Movs.Edit.Smoothchange =uicontrol('Parent',Movs.Display.Figure, ...
      'Units','pixels',...
	  'BackgroundColor',[0.8 0.8 0.8], ...
      'FontName','times',...
      'FontUnits','points',...
      'FontSize',UD.Ref.FontSize,...
      'FontWeight','normal',...
      'FontAngle','normal',...
      'HorizontalAlignment','left', ...
	  'Position',Size1, ...
	  'String','Point Filter', ...
	  'Style','text', ...
      'Tag','StaticText2');
         % ACTUAL INFORMATION INSIDE THE SMOOTH BOX
 Size1=[FG_Size(3)/1.4250 FG_Size(4)/1.25 25 22]; 
 Movs.Edit.Smooth = uicontrol('Parent',Movs.Display.Figure, ...
        'Units','pixels',...
   	    'BackgroundColor',[1 1 1], ...
		'Enable','off',...
        'FontName','times',...
        'FontUnits','points',...
        'FontSize',UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',Size1, ...
        'String',Movs.Filter, ...
   	    'Style','edit', ...
	    'Tag','EditCh',...
		'callback','Movs.Filter=Movs.Filter');   
			
		  
 %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^	  
 % THE PLAY PAUSE STOP BUTTONS
 %^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
         icons = {['[ line([.15 .65 .15 .15],[.1 .5 .9 .1],                   ''color'',''r'',''linewidth'',1.45)]';
                   '[ line([.25 .25 NaN .65 .65],[.15 .85 NaN .85 .15],       ''color'',''r'',''linewidth'',1.4 )]';
                   '[ line([.8 .3 .8 NaN .3 .3],[.1 .5 .9 NaN .9 .1],         ''color'',''r'',''linewidth'',1.45)]';
                   '[ line([.8 .3 .8],[.1 .5 .9],                             ''color'',''r'',''linewidth'',1.4)] ';
		     	       '[ line([.15 .65 .15],[.1 .5 .9],                          ''color'',''r'',''linewidth'',1.45)]']};
   callbacks=['Mov_Movie(''Play''        )';
   		     'Mov_Movie(''Pause''       )';
			  'Mov_Movie(''Stop''        )';
              'Mov_Movie(''FrameBack''   )';
              'Mov_Movie(''FrameForward'')'];
           
   PressType=['flash';'flash';'flash';'flash';'flash'];
    Movs.Button.ScrollBarSz=[FG_Size(3)/7.125 FG_Size(4)/4.444 96 20];
  Movs.Button.ScrollBar=	btngroup(Movs.Display.Figure,...
      	  'ButtonID',['B1';'B2';'B3';'B4';'B5'],...
           'Callbacks',callbacks,...
   	     'IconFunctions',str2mat(icons{:}),...
      	  'GroupID', 'MovieControl',...
	        'GroupSize',[1 5],...   %
	        'PressType',PressType,...
  	        'BevelWidth',.075,...
      	  'units','pixels',...
           'Position',   Movs.Button.ScrollBarSz ,...%
	        'Orientation','horizontal');
         
         
%**************************************************************************         
% THE MENU BARS           THE MENU BARS              THE MENU BARS
%__________________________________________________________________________
  Temp.Datproc={
     'File                 '              ' '                        'Windows'
	  '>Save Data           '              'Mov_Movie(''Save'')          '     ' '
     '>Make Movie          '              'Mov_Movie(''Qtime'')         '     ' '};
%	  '>Overlap Trace     '              'Mov_Movie(''Overlap'')       '     ' '
%    '>Print             '              'Mov_Movie(''Print'')         '     ' ' 
  makemenu(Movs.Display.Figure,char(Temp.Datproc(:,1)),char(Temp.Datproc(:,2)), char(Temp.Datproc(:,3)));
  Temp.Datproc2={
     'Setting               '              ' '                        'Windows'
	  '>Expand Decimated Data'              'Mov_Movie(''Fillin'')          '     ' '
	  '>Change LUT           '              'Mov_Movie(''LUT Change'')          '     ' '};
%	  '>Overlap Trace     '              'Mov_Movie(''Overlap'')       '     ' '
%    '>Print             '              'Mov_Movie(''Print'')         '     ' ' 
  makemenu(Movs.Display.Figure,char(Temp.Datproc2(:,1)),char(Temp.Datproc2(:,2)), char(Temp.Datproc2(:,3)));
z=Mov_Movie('Wait'); %Mov_Movie('LUT Reading',LUTDisplay.LUT);
      LUTDisplay.Ch_XY=Mov_Movie('LUT Reading',LUTDisplay.LUT);
      if isempty(LUTDisplay.Ch_XY)
         close(Movs.Display.Figure)
      else
            set(Movs.Display.Figure,'userdata',LUTDisplay);
            set(Movs.Display.Figure,'WindowButtonMotionFcn','Mov_Movie(''Mouse Move'')')
            set(Movs.Display.Figure,'WindowButtonDownFcn','Mov_Movie(''Mouse Down'')')
            set(Movs.Display.Figure,'visible','on');
            set(Movs.Display.Figure,'ResizeFcn','Mov_Movie(''ResizeFcn'')');
            
            if nargin==1
               Mov_Movie('Plot TimeMap',Movs.Display.Figure);
            elseif nargin==2
               varargout{1}=LUTDisplay;
            end
         end
   axes(Movs.Plot)      
   Movs.Signal.Plot=plot(0,'Parent',Movs.Plot); % NEW 1/28
	set(Movs.Signal.Plot,'Erasemode','xor'); % NEW 1/28
	set(Movs.Plot,'YTickLabel',[]);
   set(Movs.Plot,'YTick',[]);
   set(Movs.Plot,'XTick',[]);

	Movs.a=line([0 0],[0 256],'tag','Line','color','r','LineWidth',2); % NEW 1/28
    set(Movs.a,'EraseMode','xor'); % NEW 1/28
      

    Mov_Movie 'Stop'
    Mov_Movielog 'Initial'
    Mov_Movielog('Colormaps','Gray                          ');
	figure(Movs.Display.Figure)
close(z)  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Look Up Table Reading				 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'LUT Reading'
    LUT=varargin{2};
    Temp.Continue=0;
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
      Ch_XY=[];
      if Temp.Continue==1 %*.tab
         Temp.Ch=1;
         while  length(Line)==6 %feof(FID)==0 
            Ch_XY=[Ch_XY;Temp.Ch Line([2 1])];
            Temp.Ch=Temp.Ch+1;
            Line=fgetl(FID);
            Line=str2num(Line);
         end
      else  %=2    *.lut
         Ch_XY=[Ch_XY;Line([5 1 2])];
         Temp.XSpace=inf;
         Temp.YSpace=inf;
         while  feof(FID)==0 %|length(Line)==5%
            Line=fgetl(FID);
            Line=str2num(Line);
            if isempty(find(Ch_XY(:,2)==Line(1)))
               Temp.XSpace=[Temp.XSpace abs(Line(1)-Ch_XY(1,2))];
            end
            if isempty(find(Ch_XY(:,3)==Line(2)))
               Temp.YSpace=[Temp.YSpace abs(Line(2)-Ch_XY(1,3))];
            end
            Ch_XY=[Ch_XY;Line([5 1 2])];
         end
         Ch_XY(:,1)=Ch_XY(:,1)+1;
         Ch_XY(:,2:3)=[(Ch_XY(:,2)-min(Ch_XY(:,2)))/min(Temp.XSpace)+1 (Ch_XY(:,3)-min(Ch_XY(:,3)))/min(Temp.YSpace)+1];
      end
      %To open all head file
      fclose(FID);
      varargout(1)={Ch_XY};  

   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %  PLOT THE TIME MAP                 %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'Plot TimeMap'
   LUTDisplay.Image=[];
   LUTDisplay.Image=nan*ones(max(LUTDisplay.Ch_XY(:,2)),max(LUTDisplay.Ch_XY(:,3)));
   axes(Movs.Axes);
if Movs.Head.Chans==144
      %set(Movs.Axes,'xlim',[min(LUTDisplay.Ch_XY(:,2))-.5 max(LUTDisplay.Ch_XY(:,2))-.5],'ylim',[min(LUTDisplay.Ch_XY(:,3))-.5 max(LUTDisplay.Ch_XY(:,3))+.5]);
      %% THE PROGRAM WAS ORIGINALLY WRITTEN TO ACCEPT ARRAYS OF 
      %% EITHER 144 OR 256. DR. LAURITA DECIMATED HIS ARRAY AND
      %% USED A NON-STANDARD SIZE LOOK UP TABLE
      %% THE NEXT LINE IS CHANGED
      %Ending=124;
      [Ending,aaa]=size(LUTDisplay.Ch_XY);
      [xsize ysize]=size(Data{Movs.strct});
      if xsize>250 & xsize<1000
         xsize=256;
      end
	  Movs.newarray=0*ones(length(Data{Movs.strct}),Movs.Head.Chans);
	  lengthorig=length(Data{Movs.strct});
      orig=1-Data {2}';
      Movs.Range=0*ones(1,Movs.Head.Chans);
   else
    %  set(Movs.Axes,'xlim',[min(LUTDisplay.Ch_XY(:,2))-.5 max(LUTDisplay.Ch_XY(:,2))+.5],'ylim',[min(LUTDisplay.Ch_XY(:,3))-.5 max(LUTDisplay.Ch_XY(:,3))+.5]);
      %Ending=256;
      [Ending,aaa]=size(LUTDisplay.Ch_XY);
      [xsize ysize]=size(Data{Movs.strct});
      if xsize>250 & xsize<1000
         xsize=256;
      elseif xsize>1319 & xsize<1325
          xsize=1320;
      elseif xsize>1839 & xsize<1850
          xsize=Log.Head.Chans-4;    
          ysize=Log.Head.Samples;
      else
          xsize=floor(sqrt(xsize))^2;         
      end
     Movs.newarray=0*ones(ysize,xsize);
     lengthorig=length(Data{Movs.strct});
     orig=1-Data {2}';
     Movs.Range=0*ones(1,Ending);
     if Movs.Head.Chans>250 & Movs.Head.Chans<512
        Movs.Head.Chans=256;
     end
   end
       axishd=image(LUTDisplay.Image');
      set(axishd,'Erasemode','xor');
 if Movs.Head.Chans==1320
     Movs.newarray=orig(:,1:1320);
 elseif Movs.Head.Chans==1840
     Movs.newarray=orig(1:ysize,1:xsize);
 else
      for i=1:Ending
         temp=orig(:,LUTDisplay.Ch_XY(i,1));
     %     col=((Movs.xydim(1)-LUTDisplay.Ch_XY(i,2))*Movs.xydim(2)+LUTDisplay.Ch_XY(i,3));
     %      col=((LUTDisplay.Ch_XY(i,2))+(Movs.xydim(2)-LUTDisplay.Ch_XY(i,3))*Movs.xydim(2));
     % THE Y AXIS SEEMED FLIPPED
      col=((LUTDisplay.Ch_XY(i,2))+(-1+LUTDisplay.Ch_XY(i,3))*Movs.xydim(2));
      Movs.newarray(:,col)=temp';
      Movs.Range(col)=max(Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),col))-min(Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),col));
      Movs.newarray=Movs.newarray;
%   Movs.newarray(:,col)=256*(Movs.newarray(:,col)-ones(lengthorig,1)*min(Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),col)))./(Movs.Range(col));
end
end

   Movs.Ch_XY=LUTDisplay.Ch_XY;
   Mov_Movie('FullScale')
	imagedata=reshape(Movs.newarray(Movs.Display.X1X2(1),:),Movs.xydim(1),Movs.xydim(2))';
	colormap(gray)
	set(axishd,'cdata',imagedata);
	set(axishd,'Erasemode','xor')
       originaldata=Movs.newarray;
% 
%        fid=fopen([matlabroot,'\bin\','origdata.dat'],'w')
%        fwrite(fid,originaldata);
%        fclose(fid);
save originaldata originaldata


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%   CHANGING THE LUT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'LUT Change'
 [Temp.NewLUT Temp.Path]=uigetfile([Log.UD.Path Log.UD.CD 'lut' Log.UD.CD '*.*']);
 if max([Temp.NewLUT Temp.Path]) ~= 0%if you do not click cancel
    if ishandle(Movielog.Figure)
       Mov_Movielog('ClearA')
 	    Mov_Movie('Undo All')
   end
   Contour.LUT=Temp.NewLUT;
    FID=fopen([Temp.Path Temp.NewLUT],'r');
    Line=fgetl(FID);
      %To get rid of the titile
      while ~isempty(find(Line==35)) %35= '#' :Tab sysbol
         Line=fgetl(FID);
      end
      Line=str2num(Line);
      
      while length(Line)==1 %9='tab', 32=space bar
         Line=str2num(fgetl(FID));
      end
      Ch_XY=[];
         Ch_XY=[Ch_XY;Line([5 1 2])];
         Temp.XSpace=inf;
         Temp.YSpace=inf;
         while  feof(FID)==0 %|length(Line)==5%
            Line=fgetl(FID);
            Line=str2num(Line);
            if isempty(find(Ch_XY(:,2)==Line(1)))
               Temp.XSpace=[Temp.XSpace abs(Line(1)-Ch_XY(1,2))];
            end
            if isempty(find(Ch_XY(:,3)==Line(2)))
               Temp.YSpace=[Temp.YSpace abs(Line(2)-Ch_XY(1,3))];
            end
            Ch_XY=[Ch_XY;Line([5 1 2])];
         end
         Ch_XY(:,1)=Ch_XY(:,1)+1;
         Ch_XY(:,2:3)=[(Ch_XY(:,2)-min(Ch_XY(:,2)))/min(Temp.XSpace)+1    (Ch_XY(:,3)-min(Ch_XY(:,3)))/min(Temp.YSpace)+1];
      %To open all head file
      fclose(FID);
      LUTDisplay.Ch_XY=Ch_XY;  
      
      
   LUTDisplay.Image=[];
   LUTDisplay.Image=nan*ones(max(LUTDisplay.Ch_XY(:,3)),max(LUTDisplay.Ch_XY(:,2)));
   axes(Movs.Axes);
if Movs.Head.Chans==144
      %set(Movs.Axes,'xlim',[min(LUTDisplay.Ch_XY(:,2))-.5 max(LUTDisplay.Ch_XY(:,2))-.5],'ylim',[min(LUTDisplay.Ch_XY(:,3))-.5 max(LUTDisplay.Ch_XY(:,3))+.5]);
      %% THE PROGRAM WAS ORIGINALLY WRITTEN TO ACCEPT ARRAYS OF 
      %% EITHER 144 OR 256. DR. LAURITA DECIMATED HIS ARRAY AND
      %% USED A NON-STANDARD SIZE LOOK UP TABLE
      %% THE NEXT LINE IS CHANGED
      %Ending=124;
     [Ending,aaa]=size(LUTDisplay.Ch_XY);
	  Movs.newarray=0*ones(length(Data{Movs.strct}),Movs.Head.Chans);
	  lengthorig=length(Data{Movs.strct});
     orig=-1*Data{3}';
     Movs.Range=0*ones(1,Movs.Head.Chans);
else 
      %set(Movs.Axes,'xlim',[min(LUTDisplay.Ch_XY(:,2))-.5 max(LUTDisplay.Ch_XY(:,2))+.5],'ylim',[min(LUTDisplay.Ch_XY(:,3))-.5 max(LUTDisplay.Ch_XY(:,3))+.5]);
      %Ending=256;
      [Ending,aaa]=size(LUTDisplay.Ch_XY);
	  Movs.newarray=0*ones(length(Data{Movs.strct}),256);
     lengthorig=length(Data{Movs.strct});
     orig=-1*Data{Movs.strct}';
     Movs.Range=0*ones(1,256);
     if Movs.Head.Chans>250 & Movs.Head.Chans<1000
        Movs.Head.Chans=256;
     end
   end
      axishd=image(LUTDisplay.Image);
      set(axishd,'Erasemode','xor');
for i=1:Ending
     temp=orig(:,LUTDisplay.Ch_XY(i,1));
     col=((LUTDisplay.Ch_XY(i,2))+(-1+LUTDisplay.Ch_XY(i,3))*Movs.xydim(2));
     Movs.newarray(:,col)=temp;
     Movs.Range(col)=max(Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),col))-min(Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),col));
end
   Movs.Ch_XY=LUTDisplay.Ch_XY;
   Mov_Movie('FullScale')
	imagedata=reshape(Movs.newarray(Movs.Display.X1X2(1),:),Movs.xydim(1),Movs.xydim(2));
	set(axishd,'cdata',imagedata);
	set(axishd,'Erasemode','xor')
end

   


 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %   PLAY                          %
 %   STOP                          %
 %   FRAME FORWARD                 %
 %   FRAME BACKWARD                %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'Play'
 if 1==1
     bmov=reshape(Movs.newarray(1:Movs.Display.X1X2(2),:),Movs.Display.X1X2(2),Movs.xydim(1),Movs.xydim(2));
     save bmov bmov
 end
 
   LUTDisplay=get(Movs.Display.Figure,'userdata');
if Movs.Signal.True==1;
   set(Movs.a,'Xdata',[Movs.count Movs.count],'Ydata',[0 256]);
   Movs.true=1;
   while (Movs.true==1)&(Movs.count<Movs.Display.X1X2(2))
      set(Movs.a,'xdata',[Movs.count Movs.count],'Ydata',[0 256])
      wimage=reshape(Movs.newarray(Movs.count,1:Movs.Head.Chans),Movs.xydim(1),Movs.xydim(2))';
      set(axishd,'Cdata',wimage);
      pause(0.005*Movs.FR);
      Movs.count=Movs.count+1;
 end
if Movs.count>Movs.Display.X1X2(2);
   Movs.count=Movs.Display.X1X2(1);
end
else
   Movs.true=1;
   LUTDisplay=get(gcbf,'userdata');
   set(axishd,'EraseMode','xor');
   while (Movs.true==1)&(Movs.count<Movs.Display.X1X2(2))
   wimage=reshape(Movs.newarray(Movs.count,1:Movs.Head.Chans),Movs.xydim(1),Movs.xydim(2))';
   set(axishd,'Cdata',wimage);
   pause(0.005*Movs.FR);
   Movs.count=Movs.count+1;
   end
   Movs.count=Movs.Display.X1X2(1);
end
   
case 'Stop'
   Movs.count=Movs.Display.X1X2(1); 
   %set(Movs.a,'xdata',[Movs.count+8 Movs.count+8],'ydata',[0 256]);
   Movs.true=2;
   wimage=reshape(Movs.newarray(Movs.count,1:Movs.Head.Chans),Movs.xydim(1),Movs.xydim(2))';
   set(axishd,'Cdata',wimage);

case 'Pause'
   Movs.true=2;
   
case 'FrameBack'   
   Movs.true=2;
   if ~isempty(Movs.a);
   if Movs.count>Movs.Display.X1X2(1)
%       Movs.count=Movs.count-Movs.FR;
      wimage=reshape(Movs.newarray(Movs.count,1:Movs.Head.Chans),Movs.xydim(1),Movs.xydim(2))';
      set(axishd,'Cdata',wimage);
      set(Movs.a,'xdata',[Movs.count Movs.count],'ydata',[0 256])
   end
else
   if Movs.count>Movs.Display.X1X2(1)
%       Movs.count=Movs.count-Movs.FR;
      wimage=reshape(Movs.newarray(Movs.count,1:Movs.Head.Chans),Movs.xydim(1),Movs.xydim(2))';
      set(axishd,'Cdata',wimage);
   end
end


case 'FrameForward'   
   Movs.true=2;
   if ~isempty(Movs.a);
   if Movs.count<Movs.Display.X1X2(2)
%       Movs.count=Movs.count+Movs.FR;
      wimage=reshape(Movs.newarray(Movs.count,1:Movs.Head.Chans),Movs.xydim(1),Movs.xydim(2))';
      set(axishd,'Cdata',wimage);
      set(Movs.a,'xdata',[Movs.count Movs.count],'ydata',[0 256])
   end
else
   if Movs.count<Movs.Display.X1X2(2)
%       Movs.count=Movs.count+Movs.FR;
      wimage=reshape(Movs.newarray(Movs.count,1:Movs.Head.Chans),Movs.xydim(1),Movs.xydim(2))';
      set(axishd,'Cdata',wimage);
   end
end

   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %   MOUSE MOVE                            %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case 'Mouse Move'
if Movs.Threshold==1;
	if Movs.Mag==1;
		  C=findobj(gcbf,'Tag','line3');
          Temp.currentpoint=round(get(Movs.Plot,'currentpoint'));
          Temp.currentpoint=Temp.currentpoint(1,1:2);
	      set(C,'ydata',[Temp.currentpoint(2) Temp.currentpoint(2)])
	  else 
		  B=findobj(gcbf,'Tag','line2');
          Temp.currentpoint=round(get(Movs.Plot,'currentpoint'));
          Temp.currentpoint=Temp.currentpoint(1,1:2);
	      set(B,'ydata',[Temp.currentpoint(2) Temp.currentpoint(2)])
	  end
end

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %   MOUSE DOWN                            %
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
case 'Mouse Down'
   LUTDisplay=get(gcbf,'userdata');
   axes(Movs.Axes);
   b=findobj(gca,'Tag','patch1');
   delete(b)
   Temp.currentpoint=round(get(gca,'currentpoint'));
   Temp.currentpoint=Temp.currentpoint(1,1:2);
   Temp.Ch=find(LUTDisplay.Ch_XY(:,2)==Temp.currentpoint(1) &  LUTDisplay.Ch_XY(:,3)==Temp.currentpoint(2));
   Current_Axis=axis;
   if (Temp.currentpoint(1,2)>=round(Current_Axis(3)) & Temp.currentpoint(1,1)<(Current_Axis(2))) & Temp.currentpoint(1,2)<round(Current_Axis(4)) & Temp.currentpoint(1,1)>=round(Current_Axis(1))
	   Mov_Movie 'Refresh Axes'
	   b=patch(...
      	'CData',[],...
	      'CDataMapping','scaled',...
  		   'FaceVertexCData',[],...
			'EdgeColor','r',...
			'EraseMode','xor',...
			'Faces',[1 2 3 4 5],...
			'MarkerEdgeColor','auto',...
			'MarkerFaceColor','auto',...
         'MarkerSize',[12],...
         'LineWidth',4,...
         'Tag','patch1',...
			'XData',[Temp.currentpoint(1)+.5 Temp.currentpoint(1)+.5 Temp.currentpoint(1)-.5 Temp.currentpoint(1)-.5],...
         'YData',[Temp.currentpoint(2)+.5 Temp.currentpoint(2)-.5 Temp.currentpoint(2)-.5 Temp.currentpoint(2)+.5]); 
   Movs.Current_ch=Temp.currentpoint(1)+Movs.xydim(2)*(Temp.currentpoint(2)-1);
   Mov_Movie 'Signal';   
   Movs.Badpic=Temp.currentpoint;
 else % end
    Temp.currentpoint=round(get(gcf,'currentpoint'));
    FG_Size=get(Movs.Display.Figure,'Position');
    ttt=get(Movs.Plot,'Position');
    xlimit=ttt(3)*FG_Size(3);
    ylimit=ttt(4)*FG_Size(4);
  if (Temp.currentpoint(1,2)<=ylimit & Temp.currentpoint(1,2)>1) & Temp.currentpoint(1,1)<=xlimit & Temp.currentpoint(1,1)>=1 & Movs.Threshold==0
      Mov_Movie 'NewFrame'
  elseif Movs.Threshold==1
      set(gcf,'WindowButtonUpFcn','Mov_Movie(''Mouse Up'')');
   end
end

case 'Mouse Up'
if Movs.Threshold==1;
	Mov_Normalize 'on'
	Movs.Threshold=0;
end

	  
case 'NewFrame'
   Temp.currentpoint=round(get(Movs.Plot,'currentpoint'));
   Temp.currentpoint=Temp.currentpoint(1,1:2);
   Movs.count=Temp.currentpoint(1,1);
	    set(Movs.a,'xdata',[Movs.count Movs.count],'ydata',[0 256]);
		wimage=reshape(Movs.newarray(Movs.count,1:Movs.Head.Chans),Movs.xydim(1),Movs.xydim(2))';
		set(axishd,'Cdata',wimage);


   
   
case 'Signal'
   figure(Movs.Display.Figure)
   LUTDisplay=get(gcf,'userdata');
   set(Movs.Signal.Plot,'xdata',[],'ydata',[]);
   set(Movs.Plot,'xlim',[Movs.Display.X1X2(1) Movs.Display.X1X2(2)],'ylim',[0 256])
% New 3/29/99
   set(Movs.Signal.Plot,'xdata',[],'ydata',[]);
   set(Movs.Signal.Plot,'visible','on','ydata',Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),Movs.Current_ch));
  set(Movs.Signal.Plot,'ydata',Movs.newarray(:,Movs.Current_ch));
   set(Movs.Signal.Plot,'visible','on','EraseMode','Normal','xdata',Movs.Display.X1X2(1):Movs.Display.X1X2(2),'ydata',Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),Movs.Current_ch));
   set(Movs.a,'xdata',[Movs.count Movs.count],'ydata',[0 256]);
   Movs.Signal.True=1;

  
case 'IncreaseFR'
   Movs.FR=Movs.FR+1;
   Current_Ch=str2num(get(Movs.Edit.Channel,'String'));
   if ceil(Current_Ch)~=fix(Current_Ch)
	      set(Movs.Edit.Channel,'String',Current_Ch);
         Zeng_Error('Integer Numbers Only');
      elseif Current_Ch>0         
         set(Movs.Edit.Channel,'String',Movs.FR);
      else;
         set(Movs.Edit.Channel,'String',Current_Ch);
         Zeng_Error('The number is out of range');
      end
  

   
  
case 'DecreaseFR'
   Movs.FR=Movs.FR-1;
   Current_Ch=str2num(get(Movs.Edit.Channel,'String'));
   if ceil(Current_Ch)~=fix(Current_Ch)
	      set(Movs.Edit.Channel,'String',Current_Ch);
         Zeng_Error('Integer Numbers Only');
      elseif Current_Ch>1
         set(Movs.Edit.Channel,'String',Movs.FR);
      else;
	      Movs.FR=1;
   		Current_Ch=str2num(get(Movs.Edit.Channel,'String'));
         set(Movs.Edit.Channel,'String',Current_Ch);
         Zeng_Error('The number is out of range');
      end

case 'EdBox'
   Current_Ch=str2num(get(Movs.Edit.Channel,'String'));
   if ceil(Current_Ch)~=fix(Current_Ch)
	      set(Movs.Edit.Channel,'String',Current_Ch);
         Zeng_Error('Integer Numbers Only');
      elseif Current_Ch>0
		set(Movs.Edit.Channel,'String',Current_Ch);
         Movs.FR=Current_Ch;
      else;
		 set(Movs.Edit.Channel,'String',Current_Ch);
         Zeng_Error('The number is out of range');
      end

  case 'ClrMaps'
   figure(Movs.Display.Figure)
   load ctable
   LUTDisplay=get(gcf,'userdata');
   Clrmap=get(Movs.Colormaps,'Value');
   switch Clrmap 
   case 1,       
      colormap(gray)
      Mov_Movielog ('Colormaps','Gray                          ')
   case 2,
      colormap(BlackRed)
      Mov_Movielog ('Colormaps','Black Red                     ')
   case 3,       
      colormap(BlackBlue)
      Mov_Movielog ('Colormaps','Black Blue                    ')
   case 4,
      colormap(jet)
      Mov_Movielog ('Colormaps','Jet                           ')
  case 5,
	  colormap(BlueRed)
	  Mov_Movielog ('Colormaps','Blue Black Red                ')

  end   


  
case 'FullScale'
   [x,y]=size(Movs.newarray);
if 1==1
	if get(Movs.Button.FS,'value')==1
      for i=1:Movs.xydim(1)*Movs.xydim(2)
      	Range=max(Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),i))-min(Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),i));
         if Range~=0
            Movs.newarray(:,i)=256*(Movs.newarray(:,i)-min(Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),i)))/Range;
         else
            Movs.newarray(:,i)=min(Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),i));
			end            
		end
	else
      for i=1:Movs.xydim(1)*Movs.xydim(2)
         if Movs.Range(i)==0
            Movs.Range(i)=max(Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),i))-min(Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),i));
         end
          Movs.newarray(:,i)=Movs.newarray(:,i)/max(Movs.Range)*Movs.Range(i);;
		end	
	end		
end

  	  Mov_Movie 'Refresh Axes'
      if Movs.Signal.True==1;
     	  Mov_Movie 'Signal'
	end  

	
   
case 'Channels'   
   LUTDisplay=get(gcbf,'userdata');
   a=findobj(gcf,'Tag','Channels');
   b=get(a,'value');
   axes(Movs.Axes);
if b==1;
   for i=1:Movs.Head.Chans
      Movs.x(i)=text(LUTDisplay.Ch_XY(i,2)-.3,LUTDisplay.Ch_XY(i,3),num2str(LUTDisplay.Ch_XY(i,1)),'erasemode','xor','FontSize',7);
   end
else
   for i=1:Movs.Head.Chans
      delete(Movs.x(i))   
   end
   
end

   
case 'Refresh Axes'
    
   wimage=reshape(Movs.newarray(Movs.count,1:Movs.Head.Chans),Movs.xydim(1),Movs.xydim(2))';
   set(axishd,'Cdata',wimage);
  
  Movs.countI=0;
   LUTDisplay=get(gcbf,'userdata');











%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%		UNDO		UNDO		UNDO		UNDO		UNDO		UNDO		UNDO		UNDO
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~   
case 'Undo All'
   load originaldata
   z=Mov_Movie('Wait');
   Movs.newarray=originaldata; 
   Movs.newarray=reshape(Movs.newarray,length(Movs.newarray)/Movs.xydim(1)^2,Movs.xydim(1)^2);
   fclose(fid);
   clear originaldata;
	for i=Movs.countI:-1:1
      delete(Movs.I(i))
	end
   Mov_Movie 'Refresh Axes'
   if Movs.Signal.True==1;
      Mov_Movie 'Signal'
   end
   Mov_Movielog 'Close'
   Mov_Movie 'ClrMaps'
   Movs.Deriv=0;
   close(z)

case 'Undo Last'
z=Mov_Movie('Wait');
if Movs.Last==1;
    load Temparray
    Movs.newarray=Temparray;
% h=fopen([matlabroot,'\bin\','Temparray'],'r');
% Movs.newarray=fread(h);
Movs.newarray=reshape(Movs.newarray,length(Movs.newarray)/Movs.xydim(1)^2,Movs.xydim(1)^2);
fclose(h);
   Mov_Movie 'Refresh Axes'
    if Movs.Signal.True==1;
       Mov_Movie 'Signal'
    end
	Mov_Movielog 'Undo Last'
	Mov_Movie 'ClrMaps'
end
Movs.Last=0;
close(z)





case 'Undo'
z=Mov_Movie('Wait');
if get(Movielog.Button.Global,'value')==1 & get(Movielog.Button.Local,'value')==1
	Zeng_Error('Please Select a Value');
else
if get(Movielog.Button.Global,'Value')
	Movielog.pointer.Global=Movielog.pointer.Global-1;
	Movielog.point=Movielog.pointer.Global;
	vals=get(Movielog.ListBoxG,'Value');
	Movielog.ListBox=Movielog.ListBoxG;
	[rows,x]=size(Movielog.ContentsG);
	start=1;
	Movielog.Contents=Movielog.ContentsG;
elseif get(Movielog.Button.Local,'Value')
	Movielog.pointer.Local=Movielog.pointer.Local-1;
	Movielog.point=Movielog.pointer.Local;
	vals=get(Movielog.ListBoxL,'Value');
	Movielog.ListBox=Movielog.ListBoxL;
	[rows,x]=size(Movielog.ContentsL);
	start=0;
	Movielog.Contents=Movielog.ContentsL;
end
%	count=start+1;
count=vals;
% Not at the beginning, xor(Not the last value, just loaded)
%if vals>start & No last action ;
if vals>start & xor(vals<Movielog.point,Movs.Last~=1);
	while count~=rows
		 Movielog.Contents(count,:)=NaN*ones(1,x);
     	 Movielog.Contents(count,:)=Movielog.Contents(count+1,:);
     	 set(Movielog.ListBox,'string',Movielog.Contents);
	  	 count=count+1;
    end
	    Movielog.Contents(count,:)=NaN*ones(1,x);
     	 set(Movielog.ListBox,'string',Movielog.Contents);
		 Movielog.ContentsG=get(Movielog.ListBoxG,'string');
		 Movielog.ContentsL=get(Movielog.ListBoxL,'string');
       Movs.Last=1;
	 	 datafile2=['drkfile.bak'];  
  		 fid = fopen(datafile2,'w');
		 temp=num2str(Movielog.pointer.Global);
   	 Movielog.Contents=strvcat(temp,Movielog.ContentsG,Movielog.ContentsL);
       fwrite(fid,Movielog.Contents','char');   
       fclose(fid);
       Movielog.Load=0;
       %     Mov_Movielog 'Load'
       set(Movielog.Button.Global,'Value',1)
       set(Movielog.Button.Local,'Value',1)
       Mov_Movielog 'Apply'
		% Not at the beginnig, the pointer=selected, not just loaded, Truly the last action
elseif vals>start & vals==Movielog.point & Movielog.Load==0 & Movs.Last==1 ; 
	Movielog.Contents(vals,:)=NaN*ones(1,x);
	set(Movielog.ListBox,'string',Movielog.Contents);
     Mov_Movie 'Undo Last'
	 Movielog.Load=1;	 
	 
end 
end %If at the top of the UNDO case
%-------------------------------------------------------------------------------------------------------------------------
%	SIGNAL PROCESSING	SIGNAL PROCESSING	SIGNAL PROCESSING	SIGNAL PROCESSING	SIGNAL PROCESSING	SIGNAL PROCESSING
%-------------------------------------------------------------------------------------------------------------------------

case 'Interpolate'
   z=Mov_Movie('Wait');
   setptr(Movs.Display.Figure,'watch');
	set(Movs.Button.Local,'value',1)
	set(Movs.Button.Global,'value',0)
%   if Movs.Head.Chans==144
      if ~isempty(Movs.Badpic)
         Temparray=Movs.newarray;
         save Temparray Temparray
%          h=fopen([matlabroot,'\bin\','Temparray'],'w');
%          fwrite(h,Movs.newarray);
%          fclose(h);
         yb=Movs.Badpic(1,1); 
         xb=Movs.Badpic(1,2);
			if xb==1 & yb==1   
				Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,xb*Movs.xydim(2)+yb)+Movs.newarray((xb-1)+yb+1)+Movs.newarray(:,xb*Movs.xydim(2)+yb+1))/3;
			elseif xb==1 & yb==Movs.xydim(2) 
				Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb-1)+Movs.newarray(:,xb*Movs.xydim(2)+yb-1)+Movs.newarray(:,xb*Movs.xydim(2)+yb))/3;
			elseif yb==1 & xb==Movs.xydim(1)       
				Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb)+Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb+1)+Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb+1))/3;
			elseif xb==Movs.xydim(1) & yb==Movs.xydim(2)  
				Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb-1)+Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb-1)+Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb))/3;	
			elseif xb==1 & yb~=Movs.xydim(2)    
				Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb-1)+Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb+1)+Movs.newarray(:,xb*Movs.xydim(2)+yb))/3;	
			elseif yb==1 & xb~=1     
				Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb)+Movs.newarray(:,xb*Movs.xydim(2)+yb)+Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb+1))/3;	
			elseif yb==Movs.xydim(2) & xb~=Movs.xydim(1)    
				Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb)+Movs.newarray(:,xb*Movs.xydim(2)+yb)+Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb-1))/3;	
			elseif xb==Movs.xydim(1) & yb~=Movs.xydim(2)      
				Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb+1)+Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb-1)+Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb)+Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb+1)+Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb-1))/5;	
			else
	Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb-1)+Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb+1)+Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb+1)+Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb-1)+Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb)+Movs.newarray(:,xb*Movs.xydim(2)+yb+1)+Movs.newarray(:,xb*Movs.xydim(2)+yb-1)+Movs.newarray(:,xb*Movs.xydim(2)+yb))/8; 
			end
      if Movs.Signal.True==1
         Mov_Movie 'Signal'
      end
      
      wimage=reshape(Movs.newarray(Movs.count,1:Movs.Head.Chans),Movs.xydim(1),Movs.xydim(2))';
      set(axishd,'Cdata',wimage);
      LUTDisplay=get(Movs.Display.Figure,'userdata');
      axes(Movs.Axes);
      Mov_Movielog('Add Local',['Interpolated Pixel ',int2str(Movs.Badpic)])
      Movs.Interp=1;  

end
%end
      setptr(Movs.Display.Figure,'arrow')
		close(z)
      Mov_Movie('FullScale')

      
      
case 'Derivs'
         z=waitbar(0,'Calculating Derivative. WAIT');
         Temparray=Movs.newarray;
         save Temparray Temparray
%          h=fopen([matlabroot,'\bin\','Temparray'],'w');
%          fwrite(h,Movs.newarray);
%          fclose(h);
			set(Movs.Button.FS,'value',0)
		if get(Movs.Button.Global,'value')==1
        	Movs.Deriv=1;
           [rows,col]=size(Movs.newarray);
           for row=1:col;
              Movs.newarray(1:end-1,row)=diff(Movs.newarray(:,row));
              waitbar(row/col,z)
           end
			temp=Movs.Display.X1X2;
         Movs.Display.X1X2=[1,Movs.Display.X1X2(2)-Movs.Display.X1X2(1)-1];
         Movs.Display.X1X2=temp;
	  		Mov_Movielog('Add','Temporal Derivative ');
            derivdata2=Movs.newarray;
            save derivdata2
%          h=fopen([matlabroot,'\bin\','derivdata2'],'w');
%          fwrite(h,Movs.newarray);
%          fclose(h);
	   		Movs.Pass=1;
		 elseif get(Movs.Button.Local,'value')==1 | Movs.Signal.True==1;
			Movs.newarray(:,Movs.Current_ch)=gradient(Movs.newarray(:,Movs.Current_ch));
			i=Movs.Current_ch;
  	      Movs.newarray(:,i)=256*(Movs.newarray(:,i)-ones(length(Movs.newarray(:,i)),1)*min(Movs.newarray(:,i)))./(max(Movs.newarray(:,i))-min(Movs.newarray(:,i)));
  			Mov_Movielog('Add Local',['Temporal Derivative ',int2str(Movs.Badpic)]);
            derivdata2=Movs.newarray;
            save derivdata2
%          h=fopen([matlabroot,'\bin\','derivdata2'],'w');
%          fwrite(h,Movs.newarray);
%          fclose(h);
 			Movs.Pass=1;
		end
   Mov_Movie 'Refresh Axes'
   if Movs.Signal.True==1;
      Mov_Movie 'Signal'
   end
   set(Movs.Button.FS,'Value',0)   
   Mov_Movie 'FullScale'
   set(Movs.Button.FS,'Value',1)
   Mov_Movie('FullScale')
close(z)


   
case 'Add Deriv'   
z=Mov_Movie('Wait');
[row,y]=size(Movielog.ContentsL);
x=Movielog.pointer.Local-1;
set(Movs.Button.FS,'value',1)
if get(Movs.Button.Global,'value')==1
         Temparray=Movs.newarray;
         save Temparray Temparray
%          h=fopen([matlabroot,'\bin\','Temparray'],'w');
%          fwrite(h,Movs.newarray);
%          fclose(h);
         [rows,col]=size(Movs.newarray);
         temp=conv2(diff(Movs.newarray-ones(rows,1)*mean(Movs.newarray(1:10,:))),1/13*ones(13,1),'same');
         temp=[0*ones(1,col);temp];
         Movs.newarray=Movs.newarray+temp*3;
		   Mov_Movie 'Refresh Axes'
     if Movs.Signal.True==1;
     	  Mov_Movie 'Signal'
 	  end
      Mov_Movielog('Add','Deriv. + Prev. Signal');
elseif get(Movs.Button.Local,'value')
         Temparray=Movs.newarray;
         save Temparray Temparray
%          h=fopen([matlabroot,'\bin\','Temparray'],'w');
%          fwrite(h,Movs.newarray);
%          fclose(h);
         temp=Movs.newarray(:,Movs.Current_ch)-mean(Movs.newarray(1:10,Movs.Current_ch));
         temp=conv2(gradient(temp),1/13*ones(13,1),'same');
         Movs.newarray(:,Movs.Current_ch)=Movs.newarray(:,Movs.Current_ch)+temp*3;
         Mov_Movielog('Add Local',['Deriv. + Prev. Signal ',int2str(Movs.Badpic)]);
end % If at the top of the Add Derivative case  
   set(Movs.Button.FS,'Value',0)   
   Mov_Movie 'FullScale'
   set(Movs.Button.FS,'Value',1)
   Mov_Movie('FullScale')

close(z)
   
   
case 'Smooth'   
   z=Mov_Movie('Wait');
         Temparray=Movs.newarray;
         save Temparray Temparray
%    h=fopen([matlabroot,'\bin\','Temparray'],'w');
%    fwrite(h,Movs.newarray);
%    fclose(h);
   set(Movs.Button.FS,'value',1)
Rp=1;
Rs=.1;
f = [0 200*2/Log.Head.SRate 200*2/Log.Head.SRate+0.02 1];
m = [1  1  0 0];
devs = [ (10^(Rp/20)-1)/(10^(Rp/20)+1)  10^(-Rs/20) ];
w = [1 1]*max(devs)./devs;
%order=Log.Defaults.Parameter6;
order=30;
% B=firls(order,f,m,w);
Movs.Filter=str2num(get(Movs.Edit.Smooth,'String'));
   smoothefilter=ones(1,Movs.Filter);
if get(Movs.Button.Global,'value')==1
%    Movs.newarray=filter(smoothefilter,1,Movs.newarray);
   Movs.newarray=conv2(Movs.newarray',smoothefilter,'same')';
   for i=1:Movs.xydim(1)*Movs.xydim(2)
     if mean(Movs.newarray(:,i))==0
     else
         Movs.newarray(:,i)=256/max(Movs.newarray(:,i)).*Movs.newarray(:,i);
      end
   end
      Mov_Movielog('Add',['Smoothing ',int2str(Movs.Filter), ' points']);
elseif get(Movs.Button.Local,'value')==1
    		Movs.newarray(:,Movs.Current_ch)=conv2(Movs.newarray(:,Movs.Current_ch)',smoothefilter,'same')';
			i=Movs.Current_ch;
    	    Movs.newarray(:,i)=256*(Movs.newarray(:,i)-ones(length(Movs.newarray(:,i)),1)*min(Movs.newarray(:,i)))./(max(Movs.newarray(:,i))-min(Movs.newarray(:,i)));
  			Mov_Movielog('Add Local',['Smoothing ',int2str(Movs.Filter),' points ',int2str(Movs.Badpic)]);
            derivdata2=Movs.newarray;
            save derivdata2
%          h=fopen([matlabroot,'\bin\','derivdata2'],'w');
%          fwrite(h,Movs.newarray);
%          fclose(h);
   			Movs.Pass=1;
end %If at top of Smooth case	  
      Mov_Movie 'Refresh Axes'
   if Movs.Signal.True==1;
       Mov_Movie 'Signal'
    end
   set(Movs.Button.FS,'Value',0)   
   Mov_Movie 'FullScale'
   set(Movs.Button.FS,'Value',1)
   Mov_Movie('FullScale')

close(z)



case 'Invert'
			set(Movs.Button.FS,'value',1)
	Movs.newarray=-1*Movs.newarray;
for i=1:Movs.xydim(1)*Movs.xydim(2)
    %  if Movs.newarray(1,i)==0
    % else
         Movs.newarray(:,i)=256*(Movs.newarray(:,i)-ones(length(Movs.newarray(:,i)),1)*min(Movs.newarray(:,i)))./(max(Movs.newarray(:,i))-min(Movs.newarray(:,i)));
    %  end
end
	if Movs.Signal.True==1;
       Mov_Movie 'Signal'
   end
      


%
 %     end
%  end    
  			
   	
%------------------------------------------------------------------------
% 					MISCELLANEOUS
%------------------------------------------------------------------------
case 'Save'
[Filename, Pathname] = uiputfile('c:\windows\desktop\*.*', 'Save File');
if Filename~=0  % 2
fid1=fopen(strcat(Log.Head.Path,Log.Head.FileName,'.h'));
junk=fread(fid1);


temp1=junk';
done=0;
for count=1:length(junk)
   temp2=setstr(temp1(count));
     if temp2=='l'
        if setstr(temp1(count+1))=='e'
           if setstr(temp1(count+2))=='s'
%              for index=4:9
					for index=4:20
   				setstr(temp1(count+index:count+index+1))
               if setstr(temp1(count+index:count+index+1))=='co' & done==0;
                  done=1;
                  stop=index;
                 elseif done==0;
                    temp3(index-3)=setstr(temp1(count+index));
                    stop=index-1;
               end
              end
              pointer=count;
           end
        end
     end
  end
fclose(fid1);
filenameh=[Pathname Filename '.h'];
fids=fopen(strcat(Log.Head.Path,Log.Head.FileName),'r');
header=fread(fids,31,'int8');
%header1=['COLUMN BINARY FILE'];
%header2=['2t260c0c0e'];
fclose(fids);
fid2=fopen(filenameh,'w');
fwrite(fid2,junk(1:pointer+3));
Ben.NewData1=Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2)-1,:);
[row,col]=size(Ben.NewData1);
fwrite(fid2,num2str(y),'char');
fprintf(fid2,'%s\n',num2str(Movs.Display.X1X2(2)-Movs.Display.X1X2(1)));
fprintf(fid2,'chans\t%s\n',num2str(col));
fwrite(fid2,junk(pointer+stop:length(junk)));
fclose(fid2);
fid3=fopen([Pathname Filename],'w','b');
fwrite(fid3,header,'int8');
temp=Ben.NewData1;
for i=1:col
   col=(16-Movs.Ch_XY(i,3))*Movs.xydim(2)+Movs.Ch_XY(i,2);
   if col>0
      Ben.NewData1(:,Movs.Ch_XY(i,1))=-1*temp(:,col);
   end
end

for count=1:row
   fwrite(fid3,Ben.NewData1(count,:),'int16');
end

fclose(fid3);
end % 2
  
   
   
   
case 'Old Save Program'   
   %load Data
set(Movs.Button.FS,'value',0)
Mov_Movie 'FullScale'
[row,cols]=size(Data{Movs.strct});
   if Movs.Head.Chans==144
      Ending=124;
%	  Movs.newarray=0*ones(length(Data{Movs.strct}),Movs.Head.Chans);
	  lengthorig=length(Data{Movs.strct});
%      orig=1-Data {2}';
%      Movs.Range=0*ones(1,Movs.Head.Chans);
	  Data1=Data{Movs.strct}*-1;
	  Data1(1:16,:)=Data{Movs.strct}(1:16,:)*-1;
  else 
	     Ending=256;
 	   Data1=Data{Movs.strct}*-1;
   end
clear Data
for i=1:Ending
    col=((LUTDisplay.Ch_XY(i,2)-1)*Movs.xydim(2)+LUTDisplay.Ch_XY(i,3));
    temp=Movs.newarray(:,col);
    Data1(LUTDisplay.Ch_XY(i,1),:)=temp'*-1;
end

    cd(Log.Head.Path)
    [newfile Log.Temp.Path]=uiputfile('*', 'Save Data File As');
 	 cd('Power HD:Applications:MATLAB 5:movies')
    datafile3=[Log.Temp.Path newfile];  
    fid = fopen(datafile3,'w');
    fwrite(fid,Data1','int16');   
	fclose(fid);
	fid=fopen(strcat(Log.Head.Path,Log.Head.FileName,'.h'));
	headdata=setstr(fread(fid,'char')');
	fclose(fid);
	datafile4=strcat(datafile3,'.h');
	fid2=fopen(datafile4,'w');
	fwrite(fid2,headdata,'char');
	fclose(fid2);
	%	Log.Head
set(Movs.Button.FS,'value',1)
Mov_Movie 'FullScale'
	
   
   
case 'Qtime' 
%   path(path,[matlabroot,'\bin']);
if (Movs.Display.X1X2(2)-Movs.count)/Movs.FR>3000
	Zeng_Error('Cannot make Movie. Too many frames. Try increasing the Skip Frame or decreasing the number of frames');
else
LUTDisplay=get(gcf,'userdata');
   Clrmap=get(Movs.Colormaps,'Value');  
%   close all
load ctable;
   switch Clrmap 
   case 1,       
		cmap=gray;
	case 2,
	  cmap=BlackRed;
   case 3,       
	  cmap=BlackBlue;
   case 4,
      cmap=jet;
   case 5
      cmap=BlueRed;   
  end 
  Movs.count=Movs.Display.X1X2(1);
%z=Movs.Display.X1X2(2)
%clear
%close all
fgsize=[200 200 200 200];
moviecollect=figure('Position',fgsize,'menu','none');
bsize=[fgsize(3)-190 fgsize(4)-70 50 20];
interp1= uicontrol('Parent',moviecollect, ...
	'Units','pixels', ...
   'BackgroundColor',[1 1 1], ...
	'ListboxTop',0, ...
	'Position',bsize, ...
   'Style','edit', ...
   'String','0',...
   'Tag','EditText2');
bsize=[fgsize(3)-190 fgsize(4)-50 70 30];
label =uicontrol('Parent',moviecollect, ...
			       'Units','pixels',...
			       'BackgroundColor',[0.8 0.8 0.8], ...
			       'FontName','Arial',...
			       'FontUnits','points',...
			       'FontSize',9,...
			       'FontWeight','normal',...
			       'FontAngle','normal',...
			       'HorizontalAlignment','left', ...
			       'Position',bsize, ...
			       'String','Spatial Interpolation', ...
			       'Style','text', ...
			       'Tag','StaticText1');
bsize=[fgsize(3)-190 fgsize(4)-150 120 20];
Continue = uicontrol('Parent',moviecollect, ...
	'Units','points', ...
   'BackgroundColor',[0.752941176470588 0.752941176470588 0.752941176470588], ...
   'ListboxTop',0, ...
	'Position',bsize, ...
	'String','Create Movie', ...
   'Style','togglebutton', ...
   'Value',0,...
   'Tag','Checkbox1');


   
   
value=0;
while value==0 & value~=2;
   pause(0.1)
   if gcf==moviecollect
      value=get(Continue,'Value');
   else
      value=2;
   end
end

[newmovfile pathname]=uiputfile('*.avi', 'Save avi File As');
datafile2=[pathname newmovfile];  
 if datafile2~=0
   if length(datafile2)>4
      if datafile2(end-3:end)~='.avi';
         datafile2=[datafile2,'.avi'];
      end
   else
      datafile2=[datafile2,'.avi'];
   end

if value==1
  	pos=[400,250,500,500];
   aaa=figure('Position',pos);
   set(aaa,'menu','none')
	colormap(cmap)
   wimage=reshape(Movs.newarray(Movs.count,1:Movs.Head.Chans),Movs.xydim(1),Movs.xydim(2))';
   ival=round(str2num(get(interp1,'String')));
    axis image
   if ival>0
	   Z=wimage;
      [X Y]=meshgrid(1:Movs.xydim(1),1:Movs.xydim(2));
      [xi,yi] = meshgrid(1:1/ival:Movs.xydim(1),1:1/ival:Movs.xydim(1));
      whos
      Z1=interp2(X,Y,Z,xi,yi);
      wimage=(Z1);
   end
   close(moviecollect)
   [x y]=size(wimage);


   vidObj = VideoWriter(datafile2);
   open(vidObj);
   figure(aaa)
   axishd2=image(wimage);
   colormap hot
%    colormap(cmap)    
   set(axishd2,'Erasemode','xor');
   axis off

count=1;
Movs.true=1;
while (Movs.true==1)&(Movs.count<Movs.Display.X1X2(2))
      wimage=reshape(Movs.newarray(Movs.count,1:Movs.Head.Chans),Movs.xydim(1),Movs.xydim(2))';
   if ival>0
      Z=wimage;
      [X Y]=meshgrid(1:Movs.xydim(1),1:Movs.xydim(2));
      [xi,yi] = meshgrid(1:1/ival:Movs.xydim(1),1:1/ival:Movs.xydim(1));
      
     Z1=interp2(X,Y,Z,xi,yi);
      wimage=(Z1);
%  	  wimage=flipud(rot90(wimage));
   end
 
      image(wimage)
      axis off
      pause(0.001);
%       Movs.count=Movs.count+Movs.FR;
	  currFrame=getframe;
      writeVideo(vidObj,currFrame);
	  count=count+1;
  end


  

% close all
z=Mov_Movie('Wait');
close(vidObj)

close(z)
end

end
end




		
   case 'Delete'
      if ishandle(Movielog.Figure)
         delete(Movielog.Figure)
      end
   
      
	%close all
	%clear all
%	    close(Movs.Display.Figure)
%		close(Movielog.Figure)
%		clear Movs
%		clear Movielog
   		
case 'IncreaseSm'
 	 Movs.Filter=Movs.Filter+2;
    set(Movs.Edit.Smooth,'String',Movs.Filter);


case 'DecreaseSm'
	if Movs.Filter>3
		Movs.Filter=Movs.Filter-2;
        set(Movs.Edit.Smooth,'String',Movs.Filter);
	end	

case 'Update All'

  if isempty(findobj(Stripchart.Axes,'type','patch','LineWidth',Log.UD.Ref.ThickLine));
      Movs.Display.X1X2=[1;Log.Head.Samples];
  else
      Temp.Patch=findobj(Stripchart.Axes,'type','patch','LineWidth',Log.UD.Ref.ThickLine);
      Movs.Display.X1X2=get(Temp.Patch,'xdata');
      Movs.Display.X1X2=round(Movs.Display.X1X2(1:2));
	  Movs.count=Movs.Display.X1X2(1);
      LUTDisplay.Color=get(Temp.Patch,'EdgeColor');
      LUTDisplay.WaveForm=findobj(0,'type','figure','tag','WaveForm','name',[Stripchart.Head.FileName ':' 'WaveForm'],'color',LUTDisplay.Color);
  end
    Mov_Movie 'FullScale'
   if Movs.Signal.True==1;
       Mov_Movie 'Signal'
   end
	Mov_Movie 'Stop'

	
case 'Print'
print -djpeg signal.jpg

%case 'Junk'
	

	   Clrmap=get(Movs.Colormaps,'Value');  
%   close all
load ctable;

   switch Clrmap 
   case 1,       
		cmap=gray;
	  case 2,
	  cmap=BlackRed;
    case 3,       
	  cmap=BlackBlue;
   case 4,
	  cmap=jet;
    end 
  colormap(cmap)
     wimage2=reshape(Movs.newarray(Movs.count,1:Movs.Head.Chans),Movs.xydim(1),Movs.xydim(2));
	 figure(12)
    image(wimage2)
plot(Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),Movs.Current_ch))   
    axis off

	 %	print(Movs.Display.Figure)
%     pause
    print -djpeg a24.jpg
    
 case 'Overlap'
    if Movs.Overlap==0
       figure('Position',[100,100,700,300])
       signal1=Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),Movs.Current_ch);
       %save signal1
       Movs.Overlap=1;
       plot(Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),Movs.Current_ch))   
    else
       figure(5)
       hold
    signal2=Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),Movs.Current_ch);
    %save signal2
    plot(Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),Movs.Current_ch),'r')   
    hold off
    Movs.Overlap=0;
 end    
 
case 'Wait'
   
   saying(1,:)= ['Please Wait                                 '];
%    saying(1,:)= ['Hey Man, Program is thinking                '];
   saying(2,:)= ['Try not to be in such a hurry               '];
   saying(3,:)= ['I love you man, but I can`t work any faster '];
   saying(4,:)= ['Hot Damn, This might take a while           '];
   saying(5,:)= ['You might think Matlab is stuck, but it isnt'];
   saying(6,:)= ['You are not qualified to use this program   '];
   saying(7,:)= ['Good things come to those who wait          '];
   saying(8,:)= ['Ever wonder if the program is frozen?       '];
   saying(9,:)= ['Comments added for Poelzing`s amusement     '];
   saying(10,:)=['Comedy is in the eye of the beholder. Ha Ha '];
   ssound(1,:)=['fart1.wav'];
   ssound(2,:)=['homer.wav'];
   ssound(3,:)=['dark1.wav'];
   ssound(4,:)=['crapp.wav'];
   ssound(5,:)=['help1.wav'];
   ssound(6,:)=['shock.wav'];
   ssound(7,:)=['reprs.wav'];
   ssound(8,:)=['dead1.wav'];
   ssound(9,:)=['dead1.wav'];
   ssound(10,:)=['dead1.wav'];
   rnum=round(9*rand(1))+1;
   
 if 1==2  
   [Y,FS,BITS]=wavread(ssound(rnum,:));
   sound(Y,FS,BITS)
end

   
  h=figure(100);
  set(h,'Position',[300,400,100,100],'MenuBar','none','Color',[1 0 0]);  
  texts=uicontrol('Parent',h,...
     'FontSize',10,...
     'FontWeight','bold',...
     'BackgroundColor',[1 1 1],...
            'Position',[12 10 80 80], ...
            'String',saying(1,:), ...
            'Style','text', ...
            'visible','on');
         pause(.00000001)
         varargout{1}=h;
         
         
         
         
case 'Fillin'
	set(Movs.Button.FS,'value',0)
   Mov_Movie 'FullScale';
   z=Mov_Movie('Wait');
   setptr(Movs.Display.Figure,'watch');
         Temparray=Movs.newarray;
         save Temparray Temparray
%          h=fopen([matlabroot,'\bin\','Temparray'],'w');
%          fwrite(h,Movs.newarray);
%          fclose(h);
   for i=1:Movs.xydim(1)*Movs.xydim(2)
      	Range=max(Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),i))-min(Movs.newarray(Movs.Display.X1X2(1):Movs.Display.X1X2(2),i));
         if Range==0
         yb=i-floor((i-1)/Movs.xydim(2))*Movs.xydim(2);
         xb=floor((i-1)/Movs.xydim(2))+1; 
			if xb==1 & yb==1   
				Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,xb*Movs.xydim(2)+yb)+Movs.newarray((xb-1)+yb+1)+Movs.newarray(:,xb*Movs.xydim(2)+yb+1))/3;
			elseif xb==1 & yb==Movs.xydim(2) 
				Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb-1)+Movs.newarray(:,xb*Movs.xydim(2)+yb-1)+Movs.newarray(:,xb*Movs.xydim(2)+yb))/3;
			elseif yb==1 & xb==Movs.xydim(1)       
				Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb)+Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb+1)+Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb+1))/3;
			elseif xb==Movs.xydim(1) & yb==Movs.xydim(2)  
				Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb-1)+Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb-1)+Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb))/3;	
			elseif xb==1 & yb~=Movs.xydim(2)    
				Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb-1)+Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb+1)+Movs.newarray(:,xb*Movs.xydim(2)+yb))/3;	
			elseif yb==1 & xb~=1     
				Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb)+Movs.newarray(:,xb*Movs.xydim(2)+yb)+Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb+1))/3;	
			elseif yb==Movs.xydim(2) & xb~=Movs.xydim(1)    
				Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb)+Movs.newarray(:,xb*Movs.xydim(2)+yb)+Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb-1))/3;	
			elseif xb==Movs.xydim(1) & yb~=Movs.xydim(2)      
				Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb+1)+Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb-1)+Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb)+Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb+1)+Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb-1))/5;	
			else
				Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb)=(Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb-1)+Movs.newarray(:,(xb-1)*Movs.xydim(2)+yb+1)+Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb+1)+Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb-1)+Movs.newarray(:,(xb-2)*Movs.xydim(2)+yb)+Movs.newarray(:,xb*Movs.xydim(2)+yb+1)+Movs.newarray(:,xb*Movs.xydim(2)+yb-1)+Movs.newarray(:,xb*Movs.xydim(2)+yb))/8; 
			end
         end
end
  	set(Movs.Button.FS,'value',1)
   Mov_Movie('FullScale');
      if Movs.Signal.True==1
         Mov_Movie 'Signal'
      end
      wimage=reshape(Movs.newarray(Movs.count,1:Movs.Head.Chans),Movs.xydim(1),Movs.xydim(2))';
      set(axishd,'Cdata',wimage);
%end
      setptr(Movs.Display.Figure,'arrow')
		close(z)
        
      
case 'ResizeFcn'
FG_Size=get(Movs.Display.Figure,'Position');      
    Axissize=[FG_Size(3)/7.125 FG_Size(4)/4.444 96 20];
set(Movs.Button.ScrollBar,'Position',Axissize);
   Axissize=[FG_Size(3)/1.5405 FG_Size(4)/1.25 33 26]; 
set(Movs.Edit.Smooth,'Position',Axissize);
   Axissize=[FG_Size(3)/1.33 FG_Size(4)/1.25 16 20]; 
set(Movs.Edit.Smoothchange,'Position',Axissize);
   Axissize=[FG_Size(3)/1.9 FG_Size(4)/3.2 70 25]; 
set(Movs.Button.FS,'Position',Axissize);
   Axissize=[FG_Size(3)/1.2955 FG_Size(4)/3 100 25]; 
set(Movs.Button.Channels,'Position',Axissize);
   Axissize=[FG_Size(3)/1.35 FG_Size(3)-180 45 25];
set(Movs.Button.Local,'Position',Axissize);
   Axissize=[FG_Size(3)/1.55 FG_Size(3)-180 45 25];
set(Movs.Button.Global,'Position',Axissize);
   Axissize=[FG_Size(3)/1.20 FG_Size(4)/1.25 69 25];
set(Movs.Button.Filters,'Position',Axissize);
   Axissize=[FG_Size(3)/1.20 FG_Size(4)/1.38 69 25];
   set(Movs.Button.Thresh,'Position',Axissize);
   Axissize=[FG_Size(3)/2.1111 FG_Size(4)/4.4 16 20]; 
set(Movs.Button.Threshchange,'Position',Axissize);
   Axissize=[FG_Size(3)/1.9 FG_Size(4)/2.6 70 25];
set(Movs.Button.Invert,'Position',Axissize);
   Axissize=[FG_Size(3)/1.9 FG_Size(4)/1.54 69 25];
set(Movs.Button.DerivsA,'Position',Axissize);
	Axissize=[FG_Size(3)/1.9 FG_Size(4)/1.38 69 25];
set(Movs.Button.Derivs1,'Position',Axissize);
	Axissize=[FG_Size(3)/1.9 FG_Size(4)/2.15 69 25];
set(Movs.Button.Interpolate,'Position',Axissize);
	Axissize=[FG_Size(3)/2.4051 FG_Size(4)/4.4 30 22];
set(Movs.Edit.Channel,'Position',Axissize);
	Axissize=[FG_Size(3)/2.85 FG_Size(4)/4.4 33 26];
set(Movs.Edit.Channel_Label,'Position',Axissize);
	Axissize=[FG_Size(3)/1.3 FG_Size(4)/1.9 60 12];
set(Movs.text.Colormaps,'Position',Axissize);
    Axissize=[FG_Size(3)/1.3 FG_Size(4)/2.15 100 22];
set(Movs.Colormaps,'Position',Axissize);
   Axissize=[FG_Size(3)/1.55 FG_Size(3)-150 145 15];
set(Movs.text3,'Position',Axissize);
	Axissize=[FG_Size(3)/1.2955 FG_Size(4)/.9068 120 15];
set(Movs.text2,'Position',Axissize);
	Axissize=[FG_Size(3)/1.9 FG_Size(3)-340 100 15];
set(Movs.text1,'Position',Axissize);
   Axissize=[FG_Size(3)/1.33 FG_Size(4)/1.25 16 20]; 
set(Movs.Button.SmoothChanging,'Position',Axissize);
	Axissize=[FG_Size(3)/1.9 FG_Size(4)/1.25 69 25];
set(Movs.Button.Smooth,'Position',Axissize);
set(Movs.Frame(1),'Position',[FG_Size(3)/1.95 (FG_Size(3)-305) (FG_Size(3)-300) 1]);
set(Movs.Frame(2),'Position',[FG_Size(3)/1.95 (FG_Size(3)-185) (FG_Size(3)-300) 1]);
set(Movs.Frame(3),'Position',[FG_Size(3)/1.95 (FG_Size(3)-305) 1 (FG_Size(4)-320)]);
set(Movs.Frame(4),'Position',[FG_Size(3)/1.015 (FG_Size(3)-305) 1 (FG_Size(4)-320)]);



end