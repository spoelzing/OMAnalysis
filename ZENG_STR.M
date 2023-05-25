function [varargout]=Zeng_Stripchart(varargin)
action = varargin{1};
global Log
global Data

switch action
%================================================================
case 'initial'
  Stripchart.Figure=figure;
  %  figure(Stripchart.Figure)
  if 0
     FG_Size=Log.UD.Ref.Position(Log.UD.HD.Stripchart.Figure,:);
  elseif 0
     FG_Size=[Log.UD.ScreenSize(1)-Log.UD.HD.Stripchart.FG_Limit(1) 35 Log.UD.HD.Stripchart.FG_Limit];
  elseif 0
     FG_Size=[1 35 Log.UD.HD.Stripchart.FG_Limit];
  elseif 1
     FG_Size=[1 35 680 120];
  end
  
  set(Stripchart.Figure,'Units','points', ...
     'Color',[0.8 0.8 0.8], ...%     'HandleVisibility','off',...
     'DeleteFcn','Zeng_Stripchart(''DeleteFcn'');',...
     'menu','none',...
     'Name','Stripchart',...
     'NumberTitle','off',...
     'Units','pixels',...
     'PaperPositionMode','auto',...If auto,pagedlg won't work
     'Position',FG_Size, ...
     'selected','on',...
     'Tag','Stripchart');
  
  
  Stripchart.AxesSz=[40 19 (FG_Size(3)-55) (FG_Size(4)-50)];
  Stripchart.Axes = axes('Parent',Stripchart.Figure, ...
    'box','off',...
     'Color',[1 1 1], ...%'xlabel',[],...%     	
     'FontName','Arial',...
     'FontUnits','points',...
     'FontSize',Log.UD.Ref.FontSize,...
     'FontWeight','normal',...
     'FontAngle','normal',...
     'NextPlot','add',...
     'DrawMode','fast',...%     'XTickLabel',[],...
     'XTickLabelMode','auto',...
     'xtickmode','auto',...%it has to be manual after ploting
     'XTickLabelMode','auto',...
     'YTickLabel',[],...
     'Units','pixels',...
     'Position',Stripchart.AxesSz);
   %1=Bi, 2=M1 3=M2
  axes(Stripchart.Axes)
  %Stripchart.Plot(1)=plot(1:1000,1:1000,...               
  Stripchart.Plot(1)=plot(1,1,...                    'erasemode','background');             %'Plot');%,
     'erasemode','normal');
  Stripchart.Edit.Channel_LabelSz=[1 Stripchart.AxesSz(2)+Stripchart.AxesSz(4)+5 25 20];  
  Stripchart.Edit.Channel_Label =uicontrol('Parent',Stripchart.Figure, ...
      'Units','pixels',...
		'BackgroundColor',[0.8 0.8 0.8], ...
      'FontName','Arial',...
      'FontUnits','points',...
      'FontSize',Log.UD.Ref.FontSize,...
      'FontWeight','normal',...
      'FontAngle','normal',...
      'HorizontalAlignment','right', ...
		'Position',Stripchart.Edit.Channel_LabelSz, ...
		'String','Ch :', ...
		'Style','text', ...
      'Tag','StaticText1');

  	Stripchart.Edit.ChannelSz=[30 Stripchart.AxesSz(2)+Stripchart.AxesSz(4)+5 40 20];  
   Stripchart.Edit.Channel = uicontrol('Parent',Stripchart.Figure, ...
        'Units','pixels',...
   	  'BackgroundColor',[1 1 1], ...
        'FontName','Arial',...
        'FontUnits','points',...
        'FontSize',Log.UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
	     'Position',Stripchart.Edit.ChannelSz, ...
   	  'Style','edit', ...
	     'Tag','EditCh',...
   	  'callback',[...
        '   Stripchart=get(gcf,''userdata'');',...
        '   Current_Ch=str2num(get(Stripchart.Edit.Channel,''string''));',...
        '   if isempty(Current_Ch);',...
        '      set(Stripchart.Edit.Channel,''string'',Stripchart.Current_ch);',...
        '      Zeng_Error(''I prefer a number, You know?'');',...
        '   elseif ceil(Current_Ch)~=fix(Current_Ch)',...
	     '      set(Stripchart.Edit.Channel,''string'',Stripchart.Current_ch);',...
        '      Zeng_Error(''I prefer an integer number, You know?'');',...
        '   else;',...
        '      index=find(Stripchart.ChLabel(:,1)==Current_Ch);',...
        '      if isempty(index);',... Current_Ch>0 & Current_Ch <= Stripchart.Head.Chans/Stripchart.Head.Help.DataType',...
     	  '         set(Stripchart.Edit.Channel,''string'',Stripchart.Current_ch);',...%
        '         Zeng_Error(''You do not have this channel number'');',...
        '      else;',...
        '         Stripchart.Current_ch=Current_Ch;',...
        '         axes(Stripchart.Axes);',...
        '         set(Stripchart.Axes,''xlim'',[Stripchart.Time1 Stripchart.Time2]);',...
		  '   	   set(Stripchart.Figure,''userdata'',Stripchart);',...
        '         Zeng_Stripchart(''Up grade patch'');',...
        '      end;',...
        '   end']);
   %-------------------------------------

   Stripchart.Text.IntervalSz=[FG_Size(3)-(60+10)-(96+5)-(45+5)-(45+5)-(45+5) Stripchart.AxesSz(2)+Stripchart.AxesSz(4)+5 45 20];  
	Stripchart.Text.Interval=uicontrol('Parent',Stripchart.Figure, ...
      'Units','pixels',...
		'BackgroundColor',[0.8 0.8 0.8], ...
      'FontName','Arial',...
      'FontUnits','points',...
      'FontSize',Log.UD.Ref.FontSize,...
      'FontWeight','normal',...
      'FontAngle','normal',...
      'HorizontalAlignment','right', ...
		'Position',Stripchart.Text.IntervalSz, ...
		'String','Interval :', ...
		'Style','text', ...
      'Tag','Interval',...
      'visible','off');
   Stripchart.Text.RangeSz=[90 Stripchart.AxesSz(2)+Stripchart.AxesSz(4)+5 100 20];  
	Stripchart.Text.Range=uicontrol('Parent',Stripchart.Figure, ...
      'Units','pixels',...
		'BackgroundColor',[0.8 0.8 0.8], ...
		'FontName','Arial',...
      'FontUnits','points',...
      'FontSize',Log.UD.Ref.FontSize,...
      'FontWeight','normal',...
      'FontAngle','normal',...
		'HorizontalAlignment','left', ...
		'Position',Stripchart.Text.RangeSz, ...
      'Style','text', ...
      'Tag','Interval');
  	Stripchart.Edit.Time1Sz=[FG_Size(3)-(60+10)-(96+5)-(45+5)-(45+5) Stripchart.AxesSz(2)+Stripchart.AxesSz(4)+5 45 20];  
	Stripchart.Edit.Time1 = uicontrol('Parent',Stripchart.Figure, ...
        'Units','pixels',...
        'BackgroundColor',[1 1 1], ...
        'FontName','Arial',...
        'FontUnits','points',...
        'FontSize',Log.UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
	     'Position',Stripchart.Edit.Time1Sz, ...
        'Style','edit', ...
        'string',' ',...
	     'Tag','EditT',...   	  'visible','off',...
        'callback',[...
             'global Log;',...
             'Stripchart=get(gcf,''userdata'');',...
             'Time1=round(str2num(get(Stripchart.Edit.Time1,''string'')));',...
             'Time2=round(str2num(get(Stripchart.Edit.Time2,''string'')));',...
             'if isempty(Stripchart.Patch.HD);',...
             '   Zeng_Error(''I will do it when you activate a segment for me.'');',...
             '   set(Stripchart.Edit.Time1,''string'','' '');',...
             '   set(Stripchart.Edit.Time2,''string'','' '');',...
             'else;',...
             '   HD_Old=findobj(Stripchart.Patch.HD,''linewidth'',Log.UD.Ref.ThickLine);',...
             '   if isempty(HD_Old);',...
             '      Zeng_Error(''I will do it when you activate a segment for me.'');',...
             '      set(Stripchart.Edit.Time1,''string'','' '');',...
             '      set(Stripchart.Edit.Time2,''string'','' '');',...
             '   else;',...
             '      index=find(Stripchart.Patch.HD==HD_Old);',...
             '      if isempty(Time1) |isempty(Time2);',...
             '         Zeng_Error(''Why did not you add numbers for both ?'');',...
             '         set(Stripchart.Edit.Time1,''string'',num2str(Stripchart.Patch.X(index(1),1)));',...
             '         set(Stripchart.Edit.Time2,''string'',num2str(abs(diff(Stripchart.Patch.X(index(1),[2 1])))));',...
             '      elseif Time1<1 | Time2<1;',...
             '         Zeng_Error(''I prefer bigger numbers. :(.'');',...
             '         set(Stripchart.Edit.Time1,''string'',num2str(Stripchart.Patch.X(index(1),1)));',...
             '         set(Stripchart.Edit.Time2,''string'',num2str(abs(diff(Stripchart.Patch.X(index(1),[2 1])))));',...
             '      elseif (Time1+Time2)>Stripchart.Head.Samples;',...
             '         Zeng_Error(''Your segment position is out of range. :(.'');',...
             '         set(Stripchart.Edit.Time1,''string'',num2str(Stripchart.Patch.X(index(1),1)));',...
             '         set(Stripchart.Edit.Time2,''string'',num2str(abs(diff(Stripchart.Patch.X(index(1),[2 1])))));',...
             '      elseif strcmp(''Unlock'',get(Stripchart.Button.Segment(1),''string''));',...
             '         Zeng_Error(''You are locking me.'');',...
             '      else;',...
             '         X_Old=Stripchart.Patch.X(index(1),:);',...
             '         Stripchart.Patch.X(index(1),:)=[Time1 Time1+abs(diff(X_Old))];',...
             '         set(Stripchart.Figure,''userdata'',Stripchart);',...
             '         set(HD_Old,''xdata'',[Stripchart.Patch.X(index(1),[1 2 2 1])],''FaceColor'',''none'');',...
             '         set(Stripchart.Edit.Time1,''string'',num2str(Time1));',...
             '         set(Stripchart.Edit.Time2,''string'',num2str(Time2));',...
				 '         Zeng_Stripchart(''Update WaveForm Axes'',Stripchart.Patch.HD(index));',...
             '      end;',...
             '   end;',...
             'end;']);
       
       
       
   Stripchart.Edit.Time2Sz=[FG_Size(3)-(60+10)-(96+5)-(45+5) Stripchart.AxesSz(2)+Stripchart.AxesSz(4)+5 45 20];  
	Stripchart.Edit.Time2 = uicontrol('Parent',Stripchart.Figure, ...
        'Units','pixels',...
        'BackgroundColor',[1 1 1], ...
	     'FontName','Arial',...
        'FontUnits','points',...
        'FontSize',Log.UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',Stripchart.Edit.Time2Sz, ...
        'Style','edit', ...
        'string',' ',...
	     'Tag','EditT',...        'visible','off',...
   	  'callback',[...
             'global Log;',...
             'Stripchart=get(gcf,''userdata'');',...
             'Time1=round(str2num(get(Stripchart.Edit.Time1,''string'')));',...
             'Time2=round(str2num(get(Stripchart.Edit.Time2,''string'')));',...
             'if isempty(Stripchart.Patch.HD);',...
             '   Zeng_Error(''I will do it when you activate a segment for me.'');',...
             '   set(Stripchart.Edit.Time1,''string'','' '');',...
             '   set(Stripchart.Edit.Time2,''string'','' '');',...
             'else;',...
             '   HD_Old=findobj(Stripchart.Patch.HD,''linewidth'',Log.UD.Ref.ThickLine);',...
             '   if isempty(HD_Old);',...
             '      Zeng_Error(''I will do it when you activate a segment for me.'');',...
             '      set(Stripchart.Edit.Time1,''string'','' '');',...
             '      set(Stripchart.Edit.Time2,''string'','' '');',...
             '   else;',...
             '      index=find(Stripchart.Patch.HD==HD_Old);',...
             '      if isempty(Time1) |isempty(Time2);',...
             '         Zeng_Error(''Why did not you add numbers for both ?'');',...
             '         set(Stripchart.Edit.Time1,''string'',num2str(Stripchart.Patch.X(index(1),1)));',...
             '         set(Stripchart.Edit.Time2,''string'',num2str(abs(diff(Stripchart.Patch.X(index(1),[2 1])))));',...
             '      elseif Time1<1 | Time2<1;',...
             '         Zeng_Error(''I prefer bigger numbers. :(.'');',...
             '         set(Stripchart.Edit.Time1,''string'',num2str(Stripchart.Patch.X(index(1),1)));',...
             '         set(Stripchart.Edit.Time2,''string'',num2str(abs(diff(Stripchart.Patch.X(index(1),[2 1])))));',...
             '      elseif (Time1+Time2)>Stripchart.Head.Samples;',...
             '         Zeng_Error(''Your segment position is out of range. :(.'');',...
             '         set(Stripchart.Edit.Time1,''string'',num2str(Stripchart.Patch.X(index(1),1)));',...
             '         set(Stripchart.Edit.Time2,''string'',num2str(abs(diff(Stripchart.Patch.X(index(1),[2 1])))));',...
             '      elseif strcmp(''Unlock'',get(Stripchart.Button.Segment(1),''string''));',...
             '         Zeng_Error(''You are locking me.'');',...
             '      else;',...
             '         X_Old=Stripchart.Patch.X(index(1),:);',...
             '         Stripchart.Patch.X(index(1),2)=X_Old(1)+Time2;',...
             '         set(Stripchart.Figure,''userdata'',Stripchart);',...
             '         set(HD_Old,''xdata'',[Stripchart.Patch.X(index(1),[1 2 2 1])],''FaceColor'',''none'');',...
             '         set(Stripchart.Edit.Time1,''string'',num2str(Time1));',...
             '         set(Stripchart.Edit.Time2,''string'',num2str(Time2));',...
				 '         Zeng_Stripchart(''Update WaveForm Axes'',Stripchart.Patch.HD(index));',...
             '      end;',...
             '   end;',...
             'end;']);
	%Create Zoom group button
   icons = {['[ line([.15 .15 NaN .85 .85 NaN .15 .85],[.3 .7 NaN .3 .7 NaN .5 .5]                             ,''color'',''b'')]';
             '[ line([.4 .1 .4  NaN  .6 .9 .6 NaN .1 .9],[.3 .5 .7  NaN .3 .5 .7 NaN .5 .5]                    ,''color'',''b'')]';
             '[ line([.1 .4 .1 NaN .9 .6 .9 NaN .05 .4 NaN .6 .95],[.3 .5 .7  NaN .3 .5 .7 NaN .5 .5 NaN .5 .5],''color'',''b'')]']};
   callbacks = ['Zeng_Stripchart(''zoomfull'')';
                'Zeng_Stripchart(''zoom in '')';
                'Zeng_Stripchart(''zoom out'')'];
   PressType=['flash ';'flash ';'flash '];
         
   Stripchart.Button.ZoomGroupSz=[FG_Size(3)-60-10 Stripchart.AxesSz(2)+Stripchart.AxesSz(4)+5 60 20];
   Stripchart.Button.ZoomGroup = btngroup('GroupID','zoomgroup',...
            'IconFunctions',str2mat(icons{:}),...
            'ButtonID',['z1';'z2';'z3'],...
            'PressType',PressType,...
            'Callbacks',callbacks,...
            'GroupSize',[1 3],...
            'BevelWidth',.075,...
            'units','pixels',...
            'Position',Stripchart.Button.ZoomGroupSz ,...
            'Orientation','horizontal');
   %-------------------------------------------------
	% Create scroll bar button group
         
   icons = {['[ line([.1 .1 NaN .85 .35 .85],[.1 .9 NaN .1 .5 .9],      ''color'',''r'',''linewidth'',1.4)] ';
             '[ line([.6 .1 .6 NaN .85 .35 .85],[.1 .5 .9 NaN .1 .5 .9],''color'',''r'',''linewidth'',1.4)] ';
		       '[ line([.85 .35 .85],[.1 .5 .9],                          ''color'',''r'',''linewidth'',1.4)] ';
		       '[ line([.15 .65 .15],[.1 .5 .9],                          ''color'',''r'',''linewidth'',1.45)]';
		       '[ line([.15 .65 .15 NaN .4 .9 .4],[.1 .5 .9 NaN .1 .5 .9],''color'',''r'',''linewidth'',1.45)]';
	          '[ line([.15 .65 .15 NaN .9 .9 ],[.1 .5 .9 NaN .1 .9 ],    ''color'',''r'',''linewidth'',1.45)]']};
   callbacks=['Zeng_Stripchart(''Move Left  2''    )';
			     'Zeng_Stripchart(''Move Left   '',.90)';
   		     'Zeng_Stripchart(''Move Left   '',.05)';
              'Zeng_Stripchart(''Move Right  '',.05)';
              'Zeng_Stripchart(''Move Right  '',.90)';
              'Zeng_Stripchart(''Move Right 2''    )'];
           
   PressType=['flash';'flash';'flash';'flash';'flash';'flash'];
   Stripchart.Button.ScrollBarSz=[FG_Size(3)-96-10-Stripchart.Button.ZoomGroupSz(3)-5 Stripchart.AxesSz(2)+Stripchart.AxesSz(4)+5 96 20];
   Stripchart.Button.ScrollBar=	btngroup('ButtonID',['B1';'B2';'B3';'B4';'B5';'B6'],...
            'Callbacks',callbacks,...
   	      'IconFunctions',str2mat(icons{:}),...
      	   'GroupID', 'ViewGraph',...
         	'GroupSize',[1 6],...   
	         'PressType',PressType,...
   	      'BevelWidth',.075,...
      	   'units','pixels',...
         	'Position',   Stripchart.Button.ScrollBarSz ,...
	         'Orientation','horizontal');
         
   %---------------------------------
   Stripchart.Button.SegmentSz=[200 Stripchart.AxesSz(2)+Stripchart.AxesSz(4)+5 50 20];
   Stripchart.Button.Segment(1)= uicontrol('Parent',Stripchart.Figure, ...
         'Units','pixels',...
         'enable','off',...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Stripchart.Button.SegmentSz, ...
         'String','Lock', ...
         'callback','Zeng_Stripchart(''Lock Patch'')',...  
         'Tag','Pushbutton1');
      
   Stripchart.Button.Segment(2)= uicontrol('Parent',Stripchart.Figure, ...
      'Units','pixels',...
      'enable','off',...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[Stripchart.Button.SegmentSz + [51 0 0 0]], ...
         'String','Delete', ...
         'callback','Zeng_Stripchart(''Delete Patch'')',...  
         'Tag','Pushbutton1');
   Stripchart.Button.Segment(3)= uicontrol('Parent',Stripchart.Figure, ...
         'Units','pixels',...
         'enable','off',...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[Stripchart.Button.SegmentSz + [102 0 0 0]], ...
         'String','Remember', ...
         'callback','Zeng_Stripchart(''Save Patch'')',...  
         'Tag','Pushbutton1');
      

      
      Stripchart.Button.Segment(4)= uicontrol('Parent',Stripchart.Figure, ...
         'Units','pixels',...
         'enable','off',...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[Stripchart.Button.SegmentSz + [153 0 0 0]], ...
         'String','Restore', ...
         'callback','Zeng_Stripchart(''Load Patch'')',...  
         'Tag','Pushbutton1');
      set(Stripchart.Button.Segment,'enable','on');
       
 
   %-------------------------------------------------
	%Create Changing channel button group
	icons = {['[ line([.2 .9 .5 .2 ],[.2 .2 .9 .2 ],''color'',''k'')]';
   	       '[ line([.1 .9 .5 .1 ],[.8 .8 .1 .8 ],''color'',''k'')]']};
    
	callbacks=['Zeng_Stripchart(''Increase Ch'')';'Zeng_Stripchart(''Decrease Ch'')'];
   PressType=['flash ';'flash '];
   
   
   Stripchart.Button.ChnlChangingSz= [70 Stripchart.AxesSz(2)+Stripchart.AxesSz(4)+5 16 20];
   Stripchart.Button.ChnlChanging=	btngroup('ButtonID',['S1';'S2'],...
	         'Callbacks',callbacks,...
   	      'IconFunctions',str2mat(icons{:}),...
      	   'GroupID', 'School',...
	         'GroupSize',[2 1],...   
   	      'PressType',PressType,...
      	   'BevelWidth',.1,...
         	'units','pixels',...
            'Position',   Stripchart.Button.ChnlChangingSz);%,...
         
	%         'Orientation','vertical')
   %-------------------------------------------------
	%Create DeletePatch button group
   icons = {['[line([.2 .8 NaN .2 .8],[.8 .2 NaN .2 .8],''color'',''k'')]']};
 	callbacks=['Zeng_Stripchart(''Delete Patch'')'];
   PressType=['flash'];
   if 1
   Stripchart.Button.DeletePatchSz= [90 Stripchart.AxesSz(2)+Stripchart.AxesSz(4)+5 60 20];
   Stripchart.Button.DeletePatch = uicontrol('Parent',Stripchart.Figure, ...
         'Units','pixels',...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Stripchart.Button.DeletePatchSz, ...
         'String','Del segment', ...
         'callback','Zeng_Stripchart(''Delete Patch'')',...  
         'Tag','Pushbutton1',...
         'visible','off');
   else
   icons = {['[ line([.1 .4 .6 .9 nan .2 .8],[.1 .9 .9 .1 nan .4 .4],''color'',''k'')]']};
   Stripchart.Button.DeletePatchSz= [90 Stripchart.AxesSz(2)+Stripchart.AxesSz(4)+5 60 20];
   Stripchart.Button.DeletePatch=btngroup('ButtonID','1',...%Tag=ButtonID  Log.UD=step of buttons  
               'IconFunctions','text(0,.5,''Del Seg'')',...
               'GroupID','P',...%L=line C=channel A=annote P=Patch
		         'GroupSize',[1 1],...   
		         'PressType','toggle',...
		         'BevelWidth',.05,...
		         'units','pixels',...
		         'Position',Stripchart.Button.DeletePatchSz);%,...
   end  
   
   
   set([findobj(Stripchart.Figure,'type','text')],'fontsize',Log.UD.Ref.FontSize)
   %================================================================
   %multi analysis initialization
      %The data in this variable is the 8 letter word, each of whose line idendify the current 
      %analysis you have used so far .  Ex  ['WaveForm';'Contour ';'FunMovie'];
      %The way to find if the analysis is beeing used is 
      %  ~isempty(strmatch('Contour ',Stripchart.CurrentAnalysis))
      %Stripchart.CurrentAnalysis=[];
      
   %For auxilary
   %Stripchart.Head.Help.DataType is used in  "Stripchart.Head.Chans/Stripchart.Head.Help.DataType"
   %   to check if it is bipolar or not, if it is over the num of channel
   Stripchart.Head.Help.DataType=[]; %1= optical(mono) , 2=extra cell(Bi)
      
       
   %For Unit
   Stripchart.Unit='msec';   
   %For analysis
   Stripchart.Annote.Array=[]; %[ Ch  Time Label(3) ]
   Stripchart.Annote.Show=[];
   Stripchart.Annote.ShowLength=3;%when you want to chang the label length
   Stripchart.Annote.ShowComment={};
   Stripchart.Annote.Current=[];
   Stripchart.Annote.Index=[];
   Stripchart.Annote.Figure=[];
   Stripchart.Annote.FileName=[];
   Stripchart.Annote.Path=[];
   Stripchart.Annote.Changed=0;%0=Unchanged, 1=changed
   Stripchart.Annote.IncludeSM=1;%0=No Segment, 1=Yes Segment   
   Stripchart.Annote.IncludeInf=0;%0=No header, 1=Yes header   
   %Changed when.
   %1)CLick analysis 2)Move status=5(Annote-'Existing Check') 
   %Unchanged when 
   % 1)Load. 2)Save in Annote
   %================================================================
   %For the Data infor client in the future.
   Stripchart.Data_Info=[];
   %For the WaveForm client in the future.
   Stripchart.WaveForm.Figure=[];
   %================================================================
   %For Conduction Figure
   Stripchart.Conduction=[];
   %For LUTDisplay Figure
   Stripchart.LUTDisplay=[];
   %For Contour
   Stripchart.Contour=[];
   
   %for color ref
   %Stripchart color
   Stripchart.Color.Index=zeros(1,7);
   %Stripchart.Color.Ref=[0 0 0;1 0 0;0 1 0;0 0 1;
   %                      1 1 0;1 0 1;0 1 1];
   Stripchart.Color.Ref=[1 .5 .5; 0.5 1 .5;1   1   .5;
                         1 0.5 1; 0.5 1  1;.75 0.75 0;0 .75 .75];
   %================================================================
   %Moving hand initialization
  	axes(Stripchart.Axes);
   Current_Axis=axis;
   Stripchart.Patch.X=[];
   Stripchart.Patch.Y=[0 0 1 1];
   Stripchart.Patch.HD=[];
   Stripchart.Patch.HD_Old=[];
   %Segment
   Stripchart.Segment.Position=[];
   %Move
   Stripchart.Move.status=0;
   Stripchart.Move.Current_Pointer=0;
   %set(Stripchart.Figure,'PointerShapeCData',Log.UD.Icon.BigHand)
   set(Stripchart.Figure,'WindowButtonMotionFcn','Zeng_Stripchart(''Mouse Move'')')
   set(Stripchart.Figure,'WindowButtonDownFcn','Zeng_Stripchart(''Mouse Down'')')
   set(Stripchart.Figure,'userdata',Stripchart);
   %================================================================
      
   set(Stripchart.Figure,'ResizeFcn','Zeng_Stripchart(''ResizeFcn'')');
  %You have to set userdata before set(resize) the same as menu.
  %--------------
   Temp.File={
     'File       '                '                            '   'Menu_Annot       '
     '>Load analysis...   '       'Zeng_Annote(''Load'',gcf)   '   'Menu_ActTime_Load'
     '>Save analysis...   '       'Zeng_Annote(''Save'')       '   'Menu_ActTime_Save'
     '>Save analysis as...'       'Zeng_Annote(''Save'',''as'')'   'Menu_ActTime_Save'
     '>------'                    ' '                              ' '%     '>Page Setup...'             'pagedlg'                        ' '     '>Print Setup...'            'print -dsetup'                  ' '
     '>Print...'                  'printdlg'                    ' '
     '>------'                    ' '                              ' '};
  Stripchart.Menu.File=makemenu(gcf,char(Temp.File(:,1)),char(Temp.File(:,2)), char(Temp.File(:,3)));
  
  set(Stripchart.Menu.File(2),'callback',[...
        'Zeng_Annote(''Edit'',gcbf);',...
        'Zeng_Annote(''Load'',gcbf);']);
  set(Stripchart.Menu.File(3),'enable','off');
       
  Temp.Hm_Setting={
     'Setting      '                   '                                             ' ' '
     '>unit..      '                   '                                             ' ' '
     '>>msec       '                   'Zeng_Stripchart(''Unit Setting'',''msec'')   ' 'unit_msec'
     '>>sample     '                   'Zeng_Stripchart(''Unit Setting'',''sample'') ' 'unit_Sample'
     '>------'                         ' '                                           ' '
     '>Fonts   ...'                 'Zeng_Share(''Fonts Setting'')                   ' 'Fonts'};
  Stripchart.Menu.Setting=makemenu(gcf,char(Temp.Hm_Setting(:,1)),char(Temp.Hm_Setting(:,2)), char(Temp.Hm_Setting(:,3)));
  
  Temp.Hm_Window={
     'Windows'                         ' '                             'Windows'
     '>Log...'                         'Zeng_Log(''Log'')'              ' '
     '>Annotation'                     'Zeng_Annote(''Edit'',gcf)'      'Menu_Annot'
     '>Data information..'             'Zeng_Data_Info(''Data_Info'')'  ' '
     '>------'                         ' '                              ' '
     '>Wave forms...     '             'Zeng_WaveForm(''Initial'')'     ' '
     '>Contour...        '             'Zeng_Contour(''Initial'')'      ' '};

  %WaveForm.Menu.Annote=makemenu(gcf,char(Hm_Annote(:,1)),char(Hm_Annote(:,2)));

  
  makemenu(gcf,char(Temp.Hm_Window(:,1)),char(Temp.Hm_Window(:,2)), char(Temp.Hm_Window(:,3)));
  
  
  
  Temp.Hm_Analysis={
       'Analysis'                       ' '                                  'Windows'
       '>Activation Time'               'global Log;Zeng_Analysis(Log.Annote.Label{1})' ' '
       '>Repolarization Time'           'global Log;Zeng_Analysis(Log.Annote.Label{2})' ' '      
       '>ActionPotential Duration'      'global Log;Zeng_Analysis(Log.Annote.Label{3})' ' '     
       '>Other....'                     'Zeng_Analysis(''Other Method'')'    ' '      };
  makemenu(gcf,char(Temp.Hm_Analysis(:,1)),char(Temp.Hm_Analysis(:,2)), char(Temp.Hm_Analysis(:,3)));

  %Ckeck msec-Unit
  set(findobj(Stripchart.Menu.Setting,'tag','unit_msec'),'Checked','on')
  
  set(findobj(Stripchart.Menu.Setting,'tag','Fonts'),'callback',[...
        'Zeng_Share(''Fonts Setting'');',...
        'Zeng_Stripchart(''ResizeFcn'');']);
  

  set(Stripchart.Figure,'userdata',Stripchart);
  figure(Stripchart.Figure) % set gcf=Stripchart so that Log can load it
  
 case 'DeleteFcn' 
   Stripchart=get(gcbf,'userdata');
   if Stripchart.Annote.Changed %0=Unchanged, 1=changed
      Temp.ButtonName=questdlg('Do you want to Save them before quit ?','Annote data exist !!! ','Yes','No','Yes');
      if strcmp('Yes',Temp.ButtonName)
         Zeng_Annote('Save','as');
      end
   end
   
   %Don't set it as [] because the step of Data will be ruined.
   Data{Stripchart.Figure}=0;
   if ~isempty(Stripchart.WaveForm.Figure);
      delete(Stripchart.WaveForm.Figure);
   end
   if ~isempty(Stripchart.LUTDisplay);
      delete(Stripchart.LUTDisplay);
   end
   if ~isempty(Stripchart.Annote.Figure)
      close(Stripchart.Annote.Figure);
   end
   if ~isempty(Stripchart.Contour);
      delete(Stripchart.Contour);
   end
   
case 'Unit Setting'
   Stripchart=get(gcbf,'userdata');
   Temp.Unit=varargin{2};
   if ~strcmp(Stripchart.Unit,Temp.Unit)
      Stripchart.Unit=Temp.Unit;
      set(gcbf,'userdata',Stripchart);
      Stripchart.Unit
      if strcmp(Stripchart.Unit,'msec');
         %set(Stripchart.Menu.Setting(5),'Checked','on')
         %set(Stripchart.Menu.Setting(6),'Checked','off')
         set(findobj(Stripchart.Menu.Setting,'tag','unit_msec'),'Checked','on')
         set(findobj(Stripchart.Menu.Setting,'tag','unit_Sample'),'Checked','off')
      else%if strcmp(Stripchart.Unit,'sample');
         set(findobj(Stripchart.Menu.Setting,'tag','unit_msec'),'Checked','off')
         set(findobj(Stripchart.Menu.Setting,'tag','unit_Sample'),'Checked','on')
      end  
      set(Stripchart.Text.Range,'string',['File Length: ' num2str(round(Stripchart.Head.Samples*Zeng_Stripchart('Unit Convert',Stripchart.Figure))) ' ' Stripchart.Unit]);
      Zeng_Stripchart('Unit Axis Setting',Stripchart.Figure);
      if ~isempty(Stripchart.WaveForm.Figure);
         for i=1:length(Stripchart.WaveForm.Figure);
            WaveForm=get(Stripchart.WaveForm.Figure(i),'userdata');
            for j=1:WaveForm.axises
               Zeng_WaveForm('Call Cursor',1,WaveForm.Figure,j)
               Zeng_WaveForm('Call Cursor',2,WaveForm.Figure,j)
            end
            Zeng_Stripchart('Unit Axis Setting',WaveForm.Figure);
         end
      end
      
   end
case 'Unit Axis Setting'
   Temp=[];
   Temp.Figure=varargin{2};
   if strcmp('Stripchart',get(Temp.Figure,'tag'))
      Stripchart=get(Temp.Figure,'userdata');
      Temp.Axes=Stripchart.Axes;
      Temp.Xlim=get(Temp.Axes,'xlim');
      Temp.Tick=get(Temp.Axes,'xtick');
   elseif strcmp('WaveForm',get(Temp.Figure,'tag'))
      WaveForm=get(Temp.Figure,'userdata');
      Temp.Axes=WaveForm.Ch.Axes(1);
      Stripchart=get(WaveForm.Parent,'userdata');
      Temp.Xlim=get(Temp.Axes,'xlim');
      Temp.Tick=get(Temp.Axes,'xtick');
   end
   Temp.Convertor=Zeng_Stripchart('Unit Convert',Stripchart.Figure);
   set(Temp.Axes,'XTick',Temp.Tick,'XTickLabel',Temp.Tick*Temp.Convertor,'XTickMode','auto')
   
   
case 'Unit Convert'
   Temp.Figure=varargin{2};
   Stripchart=get(Temp.Figure,'userdata');
   if strcmp(Stripchart.Unit,'msec');
      varargout(1)={1000/Stripchart.Head.SRate};
   else
      varargout(1)={1};
   end  
   
case 'Data Type Check'
   Stripchart=get(varargin{2},'userdata');
   if strcmp(Stripchart.Head.Sys_Ver,'Optical Mapping System');
      varargout(1)={varargin{3}};
   else
      varargout(1)={varargin{3}*2};
   end  
case 'Data Type Plot'
   %2=Stripchart.Figure 3=Line 4=Ch Num 5=auto scale 6=gain 7=offset 
   Stripchart=get(varargin{2},'userdata');
	index=find(Stripchart.ChLabel(:,1)==varargin{4});
	if isempty(index)
	 	Zeng_Share('Error','Polite','Error in Stripchart-Data Type Plot');   
   else
      if Stripchart.Head.Help.DataType==1;
   	%if strcmp(Stripchart.Head.Sys_Ver,'Optical Mapping System');
       	Temp.Ydata=Data{Stripchart.Figure}(Stripchart.ChLabel(index,2),:);
	   else
         Temp.Ydata=[Data{Stripchart.Figure}(Stripchart.ChLabel(index,2),:)-Data{Stripchart.Figure}(Stripchart.ChLabel(index,3),:)];
      end
      
      HD_Axes=get(varargin{3},'parent');
      HD_WaveForm=get(HD_Axes,'parent');
      if strcmp('Stripchart',get(HD_WaveForm,'tag'));
	      %Temp.Ydata=[Data{Stripchart.Figure}(Stripchart.ChLabel(index,2),:)-Data{Stripchart.Figure}(Stripchart.ChLabel(index,3),:)];
      else
         Axes_number=str2num(get(HD_Axes,'tag'));
         WaveForm=get(HD_WaveForm,'userdata');
         
	      if btnstate(HD_WaveForm,['F' num2str(Axes_number)],num2str(Axes_number*10+1)) & btnstate(HD_WaveForm,['F' num2str(Axes_number)],num2str(Axes_number*10+2))
   	    	%-----------------------------
            [N D]=butter(4,[WaveForm.HP WaveForm.LP]/Stripchart.Head.SRate/2);
	   		Temp.Ydata=round(filtfilt(N,D,[Temp.Ydata]')');
	   	elseif btnstate(HD_WaveForm,['F' num2str(Axes_number)],num2str(Axes_number*10+1)) 
				[N D]=butter(4,[WaveForm.HP]/Stripchart.Head.SRate/2,'high');
				Temp.Ydata=round(filtfilt(N,D,[Temp.Ydata]')');
	      elseif btnstate(HD_WaveForm,['F' num2str(Axes_number)],num2str(Axes_number*10+2))
				[N D]=butter(4,[WaveForm.LP]/Stripchart.Head.SRate/2);
            Temp.Ydata=round(filtfilt(N,D,[Temp.Ydata]')');
         end
         
         WaveForm.Ch.PlotData{Axes_number}(1,:)=Temp.Ydata;
			set(WaveForm.Figure,'userdata',WaveForm);         
	   end
      
      
      if 1% varargin{5}
         Range=round(get(get(varargin{3},'parent'),'xlim'));
         Temp.Ydata=(Temp.Ydata-min(Temp.Ydata(Range(1):Range(2))));
      	if max(Temp.Ydata(Range(1):Range(2)))>0
      		Temp.Ydata=(Temp.Ydata/max(Temp.Ydata(Range(1):Range(2))));
   		end	
      else
	      Temp.Ydata=(Temp.Ydata-min(Temp.Ydata));
   	   if max(Temp.Ydata)~=0
      		Temp.Ydata=(Temp.Ydata/max(Temp.Ydata));
   		end
   	end
      
      %Temp.Ydata=Temp.Ydata*varargin{6}+varargin{7};
      set(varargin{3},'xdata',[],'ydata',[]);
      set(varargin{3},'xdata',1:Stripchart.Head.Samples,'ydata',Temp.Ydata);
   end
   
case 'Plot Mono'
   %2=Stripchart.Figure 3=Line 4=Ch Num 5=Mono1-2 6=gain 7=offset 

   Stripchart=get(varargin{2},'userdata');
   index=find(Stripchart.ChLabel(:,1)==varargin{4});
   if isempty(index);
      Zeng_Error('You do not have this channel number');
   else
      
   	HD_Axes=get(varargin{3},'parent');
      HD_WaveForm=get(HD_Axes,'parent');
      Axes_number=str2num(get(HD_Axes,'tag'));
	   WaveForm=get(HD_WaveForm,'userdata');
      if btnstate(HD_WaveForm,['F' num2str(Axes_number)],num2str(Axes_number*10+1)) & btnstate(HD_WaveForm,['F' num2str(Axes_number)],num2str(Axes_number*10+2))
         %-----------------------------
			[N D]=butter(4,[WaveForm.HP WaveForm.LP]/Stripchart.Head.SRate/2);
			Temp.Ydata=round(filtfilt(N,D,Data{Stripchart.Figure}(Stripchart.ChLabel(index,varargin{5}+1),:)')');
      elseif btnstate(HD_WaveForm,['F' num2str(Axes_number)],num2str(Axes_number*10+1)) 
			[N D]=butter(4,[WaveForm.HP]/Stripchart.Head.SRate/2,'high');
			Temp.Ydata=round(filtfilt(N,D,Data{Stripchart.Figure}(Stripchart.ChLabel(index,varargin{5}+1),:)')');
         
      elseif btnstate(HD_WaveForm,['F' num2str(Axes_number)],num2str(Axes_number*10+2))
			[N D]=butter(4,[WaveForm.LP]/Stripchart.Head.SRate/2);
			Temp.Ydata=round(filtfilt(N,D,Data{Stripchart.Figure}(Stripchart.ChLabel(index,varargin{5}+1),:)')');
      else
	      Temp.Ydata=Data{Stripchart.Figure}(Stripchart.ChLabel(index,varargin{5}+1),:);
      end
      WaveForm.Ch.PlotData{Axes_number}(varargin{5}+1,:)=Temp.Ydata;
		set(WaveForm.Figure,'userdata',WaveForm);
      
      Range=round(get(get(varargin{3},'parent'),'xlim'));
      Temp.Ydata=(Temp.Ydata-min(Temp.Ydata(Range(1):Range(2))));
      if max(Temp.Ydata(Range(1):Range(2)))>0
         Temp.Ydata=(Temp.Ydata/max(Temp.Ydata(Range(1):Range(2))));
      end
      
   	
      %Temp.Ydata=Temp.Ydata*varargin{6}+varargin{7};
      set(varargin{3},'xdata',[],'ydata',[]);
   	set(varargin{3},'visible','on','xdata',1:Stripchart.Head.Samples,'ydata',Temp.Ydata);
   end
case 'ResizeFcn'
   if strcmp('Stripchart',get(gcf,'tag'))
      % You clicked setting default position from Log 
      Stripchart=get(gcf,'userdata');
	   FG_Size=get(Stripchart.Figure,'position');  %Figure Size
      FG_Size(3)=max(FG_Size(3),Log.UD.HD.Stripchart.FG_Limit(1));
      FG_Size(4)=max(FG_Size(4),Log.UD.HD.Stripchart.FG_Limit(2));
      set(Stripchart.Axes,'position',[Stripchart.AxesSz(1:2) (FG_Size(3)-55) (FG_Size(4)-50)]);
      Axes_Pst=get(Stripchart.Axes,'position');
      set(Stripchart.Edit.Channel_Label,'position',[Stripchart.Edit.Channel_LabelSz(1) Axes_Pst(2)+Axes_Pst(4)+5 Stripchart.Edit.Channel_LabelSz(3:4)]);
      set(Stripchart.Edit.Channel,'position',[Stripchart.Edit.ChannelSz(1) Axes_Pst(2)+Axes_Pst(4)+5 Stripchart.Edit.ChannelSz(3:4)]);
      set(Stripchart.Button.DeletePatch,'position',[Stripchart.Button.DeletePatchSz(1) Axes_Pst(2)+Axes_Pst(4)+5 Stripchart.Button.DeletePatchSz(3:4)]);
      set(Stripchart.Button.ZoomGroup,'position',[FG_Size(3)-Stripchart.Button.ZoomGroupSz(3)-10 Axes_Pst(2)+Axes_Pst(4)+5 Stripchart.Button.ZoomGroupSz(3:4)]);
      set(Stripchart.Button.ScrollBar,'position',[FG_Size(3)-Stripchart.Button.ZoomGroupSz(3)-10-(Stripchart.Button.ScrollBarSz(3)+5) Axes_Pst(2)+Axes_Pst(4)+5 Stripchart.Button.ScrollBarSz(3:4)]);
      set(Stripchart.Button.ChnlChanging,'position',[Stripchart.Button.ChnlChangingSz(1) Axes_Pst(2)+Axes_Pst(4)+5 Stripchart.Button.ChnlChangingSz(3:4)]);
      set(Stripchart.Text.Interval,'position',[FG_Size(3)-(60+10)-(96+5)-(45+5)-(45+5)-(45+5) Axes_Pst(2)+Axes_Pst(4)+5 Stripchart.Text.IntervalSz(3:4)]);
      %set(Stripchart.Edit.Time1,'position',[FG_Size(3)-(60+10)-(96+5)-(45+5)-(45+5) Axes_Pst(2)+Axes_Pst(4)+5 Stripchart.Edit.Time1Sz(3:4)]);
      %set(Stripchart.Edit.Time2,'position',[FG_Size(3)-(60+10)-(96+5)-(45+5) Axes_Pst(2)+Axes_Pst(4)+5 Stripchart.Edit.Time2Sz(3:4)]);
      set(Stripchart.Edit.Time1,'position',[Stripchart.Edit.Time1Sz(1) Axes_Pst(2)+Axes_Pst(4)+5 Stripchart.Edit.Time1Sz(3:4)]);
      set(Stripchart.Edit.Time2,'position',[Stripchart.Edit.Time2Sz(1) Axes_Pst(2)+Axes_Pst(4)+5 Stripchart.Edit.Time2Sz(3:4)]);
      set(Stripchart.Text.Range,'position',[90 Axes_Pst(2)+Axes_Pst(4)+5 135 20]);
      
      set(Stripchart.Button.Segment(1),'position',[Stripchart.Button.SegmentSz(1) Axes_Pst(2)+Axes_Pst(4)+5 50 20]);
      set(Stripchart.Button.Segment(2),'position',[Stripchart.Button.SegmentSz(1)+51 Axes_Pst(2)+Axes_Pst(4)+5 50 20]);
      set(Stripchart.Button.Segment(3),'position',[Stripchart.Button.SegmentSz(1)+102 Axes_Pst(2)+Axes_Pst(4)+5 50 20]);
      set(Stripchart.Button.Segment(4),'position',[Stripchart.Button.SegmentSz(1)+153 Axes_Pst(2)+Axes_Pst(4)+5 50 20]);
      
      %set(Stripchart.Text.FileName_Label,'position',[1 (FG_Size(4)-5-Stripchart.Text.FileName_LabelSz(4)) Stripchart.Text.FileName_LabelSz(3:4)]);
     %set(Stripchart.Text.FileName,'position',[Stripchart.Text.FileNameSz(1) (FG_Size(4)-5-Stripchart.Text.FileNameSz(4)) Stripchart.Text.FileNameSz(3:4)]);
 
      
   end   % if strcmp('Stripchart',get(gcf,'tag'))
	
   %================================================================
case 'Update Segment Botton'   
   if nargin==1
      Stripchart=get(gcbf,'userdata');
   else
      Stripchart=get(varargin{2},'userdata');
   end
   
   if ~isempty(Stripchart.Patch.HD_Old)
      if Log.UD.Ref.ThickLine==get(Stripchart.Patch.HD_Old,'linewidth');
         if strcmp(get(Stripchart.Patch.HD_Old,'marker'),'none')
            set(Stripchart.Button.Segment(1),'string','Lock');
         else
            set(Stripchart.Button.Segment(1),'string','Unlock');
         end
      else
         set(Stripchart.Button.Segment(1),'string','Lock');
         
      end
   end
   
   
   %================================================================
case 'Lock Patch'
   Stripchart=get(gcbf,'userdata');
   
   if isempty(Stripchart.Patch.HD)
      Zeng_Stripchart('No Patch')
   else
      axes(Stripchart.Axes);
      Temp.Current_Axis=axis;
      Temp.Current_Patch=findobj(Stripchart.Axes,'type','patch','LineWidth',Log.UD.Ref.ThickLine);
      if isempty(Temp.Current_Patch)
         Zeng_Error(['I will do it only with the thick edge segment !!!' char([9 13 9 13]) 'OK ?']);
      else
%         if strcmp(get(Temp.Current_Patch,'LineStyle'),'-')
         if strcmp(get(Temp.Current_Patch,'marker'),'none')
            set(Temp.Current_Patch,'Marker','+')
            %set(Temp.Current_Patch,'LineStyle','--','Marker','+')
            set(gco,'string','Unlock')
         else
            set(Temp.Current_Patch,'Marker','none')
            %set(Temp.Current_Patch,'LineStyle','-','Marker','none')
            set(gco,'string','Lock')
         end
      end
   end
   
   
   %================================================================
case 'Delete Patch'      
   Stripchart=get(gcbf,'userdata');
   if isempty(Stripchart.Patch.HD)
      Zeng_Stripchart('No Patch')
   else
      axes(Stripchart.Axes);
      Current_Axis=axis;
      Current_Patch=findobj(Stripchart.Axes,'type','patch','LineWidth',Log.UD.Ref.ThickLine);
      if isempty(Current_Patch)
         Zeng_Error(['I will do it only with the thick edge segment !!!' char([9 13 9 13]) 'OK ?']);
      else
         if ~strcmp(get(Current_Patch,'marker'),'none')
            Zeng_Error(['You are locking me !!!' char([9 13 9 13]) 'OK ?']);
         else
            
            index=find(Stripchart.Patch.HD==Current_Patch);
            Temp=get(Stripchart.Patch.HD(index(1)),'edgecolor');
            Stripchart.Color.Index(find(Stripchart.Color.Ref(:,1)==Temp(1) & Stripchart.Color.Ref(:,2)==Temp(2) & Stripchart.Color.Ref(:,3)==Temp(3)   )   )=0;
            
            Stripchart.Patch.HD(index,:)=[];
            Stripchart.Patch.X(index,:)=[];
            Stripchart.Move.status=0;
            Stripchart.Patch.HD_Old=[];
            %Update the axeses of wave form the be the current patch
            Temp.Color=get(Current_Patch,'edgecolor');
            if ~isempty(Stripchart.WaveForm.Figure)
               Temp.WF=findobj(Stripchart.WaveForm.Figure,'color',Temp.Color);
               if ~isempty(Temp.WF);
                  index=find(Stripchart.WaveForm.Figure==Temp.WF);
                  Stripchart.WaveForm.Figure(index)=[];
                  delete(Temp.WF)
               end
            end
            if ~isempty(Stripchart.Contour)
               Temp.CT=findobj(Stripchart.Contour,'color',Temp.Color);
               if ~isempty(Temp.CT);
                  for i=1:length(Temp.CT)
                     index=find(Stripchart.Contour==Temp.CT(i));
                     Stripchart.Contour(index)=[];
                  end
                  delete(Temp.CT)
               end
            end
            delete(Current_Patch);
            set(gcf,'pointer','arrow');
            set(Stripchart.Edit.Time1,'string',' ')
            set(Stripchart.Edit.Time2,'string',' ')

            set(Stripchart.Figure,'userdata',Stripchart);
         end  
      end
   end
      
   %================================================================
   
case 'Save Patch'
   Stripchart=get(gcbf,'userdata');
   if isempty(Stripchart.Patch.HD)
      Zeng_Stripchart('No Patch')
   else
      axes(Stripchart.Axes);
      Temp.Current_Axis=axis;
      Temp.Current_Patch=findobj(Stripchart.Axes,'type','patch','LineWidth',Log.UD.Ref.ThickLine);
      if isempty(Temp.Current_Patch)
         Zeng_Error(['I will do it only with the thick edge segment !!!' char([9 13 9 13]) 'OK ?']);
      else
         Temp.X=get(Temp.Current_Patch,'xdata')';
         if isempty(Stripchart.Segment.Position)
            Stripchart.Segment.Position=[Stripchart.Segment.Position;Temp.Current_Patch  Temp.X(1:2)];
         else
            Temp.STIndex=find(Stripchart.Segment.Position==Temp.Current_Patch);
            if isempty(Temp.STIndex)
               Stripchart.Segment.Position=[Stripchart.Segment.Position;Temp.Current_Patch  Temp.X(1:2)];
            else
               Stripchart.Segment.Position(Temp.STIndex,2:3)=[Temp.X(1:2)];
            end
         end
         %set(Temp.Current_Patch,'linestyle','--','FaceColor',get(Temp.Current_Patch,'edgecolor'));
         set(Temp.Current_Patch,'FaceColor',get(Temp.Current_Patch,'edgecolor'));
         set(Stripchart.Figure,'userdata',Stripchart);
         
      end
   end
   %================================================================
case 'Load Patch'
   Stripchart=get(gcbf,'userdata');
   if isempty(Stripchart.Patch.HD)
      Zeng_Stripchart('No Patch')
   else
      axes(Stripchart.Axes);
      Temp.Current_Axis=axis;
      Temp.Current_Patch=findobj(Stripchart.Axes,'type','patch','LineWidth',Log.UD.Ref.ThickLine);
      if isempty(Temp.Current_Patch)
         Zeng_Error(['I will do it only with the thick edge segment !!!' char([9 13 9 13]) 'OK ?']);
      else
         if ~strcmp(get(Temp.Current_Patch,'marker'),'none')
            Zeng_Error(['You are locking me !!!' char([9 13 9 13]) 'OK ?']);
         else
            if isempty(Stripchart.Segment.Position)
               Zeng_Error(['I will do it if you have saved it before !!!' char([9 13 9 13]) 'OK ?']);
            else
               Temp.STIndex=find(Stripchart.Segment.Position==Temp.Current_Patch);
               if isempty(Temp.STIndex)
                  Zeng_Error(['I will do it if you have saved it before !!!' char([9 13 9 13]) 'OK ?']);
               else
                  Temp.Index=find(Stripchart.Patch.HD==Temp.Current_Patch);
                  Stripchart.Patch.X(Temp.Index,:)=round(Stripchart.Segment.Position(Temp.STIndex,2:3));
                  set(Stripchart.Figure,'userdata',Stripchart);
                  set(Temp.Current_Patch,'xdata',Stripchart.Segment.Position(Temp.STIndex,[2 3 3 2]))
                  %set(Temp.Current_Patch,'linestyle','--');
                  set(Temp.Current_Patch,'FaceColor',get(Temp.Current_Patch,'edgecolor'));
                  Zeng_Stripchart('Update WaveForm Axes',Temp.Current_Patch);
               end
            end
         end
      end
   end
   
case 'No Patch'
      Zeng_Share('Error','Polite',[sprintf('\n') 'Please activate one window in stripchart axes by'],...
            [sprintf('\n') blanks(5) '1: Click on the graph and hold down the mouse button'...
               sprintf('\n\n') blanks(5) '2: Move the mouse (still hold down the mouse button)'...
               sprintf('\n\n') blanks(5) '3: let the mouse button go up']);
      
   
   
   
   
      %================================================================
case 'Increase Ch'
   Stripchart=get(gcf,'userdata');

   %if Stripchart.Current_ch < Stripchart.Head.Chans/Stripchart.Head.Help.DataType
   if Stripchart.Current_ch < max(Stripchart.ChLabel(:,1)) & ~isempty(find(Stripchart.ChLabel(:,1)==Stripchart.Current_ch))
      Stripchart.Current_ch=Stripchart.Current_ch+1;
      axes(Stripchart.Axes);
      set(Stripchart.Axes,'xlim',[Stripchart.Time1 Stripchart.Time2]);
    set(Stripchart.Figure,'userdata',Stripchart);
      Zeng_Stripchart('Up grade patch')
      set(Stripchart.Edit.Channel,'string',Stripchart.Current_ch);
   else;
      Zeng_Error('This is already the last channel');
   end;
%================================================================
case 'Decrease Ch'
   Stripchart=get(gcf,'userdata');
   %if Stripchart.Current_ch >1 
   if Stripchart.Current_ch > min(Stripchart.ChLabel(:,1))  & ~isempty(find(Stripchart.ChLabel(:,1)==Stripchart.Current_ch))
      Stripchart.Current_ch=Stripchart.Current_ch-1;
      axes(Stripchart.Axes);
      set(Stripchart.Axes,'xlim',[Stripchart.Time1 Stripchart.Time2]);
      set(Stripchart.Figure,'userdata',Stripchart);
      Zeng_Stripchart('Up grade patch')
      set(Stripchart.Edit.Channel,'string',Stripchart.Current_ch);
   else;
      Zeng_Error('This is already your first channel');
   end
%================================================================
case 'zoomfull'
   Stripchart=get(gcf,'userdata');
   axes(Stripchart.Axes);
   Current_Axis=[get(Stripchart.Axes,'xlim') get(Stripchart.Axes,'ylim')];
   if Current_Axis(1)==1 & Current_Axis(2)==Stripchart.Head.Samples
      %Zeng_Error('It was already full range !!!');
   else
      Stripchart.Time1=1;
      Stripchart.Time2=Stripchart.Head.Samples;
      set(Stripchart.Figure,'userdata',Stripchart);
      axes(Stripchart.Axes);
      set(Stripchart.Axes,'xlim',[Stripchart.Time1 Stripchart.Time2]);
      Zeng_Stripchart('Unit Axis Setting',Stripchart.Figure);
      Zeng_Stripchart('Up grade patch')
   end
   %Zeng_Stripchart('Unit Axis Setting',Stripchart.Figure);
%================================================================
case 'zoom in '        
   Stripchart=get(gcf,'userdata');
   Diff=(Stripchart.Time2-Stripchart.Time1);
   if Stripchart.Time2==Stripchart.Time1
      %Zeng_Error('What do you want to shrink !!!');
   else
      Stripchart.Time1=Stripchart.Time1+fix(Diff/6);
      Stripchart.Time2=Stripchart.Time2-fix(Diff/6);
      set(Stripchart.Figure,'userdata',Stripchart);
      axes(Stripchart.Axes);
      set(Stripchart.Axes,'xlim',[Stripchart.Time1 Stripchart.Time2]);
      Zeng_Stripchart('Unit Axis Setting',Stripchart.Figure);
      Zeng_Stripchart('Up grade patch')
   end
   %Zeng_Stripchart('Unit Axis Setting',Stripchart.Figure);
%================================================================
case 'zoom out'        
   Stripchart=get(gcf,'userdata');
   Diff=(Stripchart.Time2-Stripchart.Time1);
   if Stripchart.Time2==Stripchart.Head.Samples & Stripchart.Time1==1
      %Zeng_Error('What do you want to expand  !!! ?');
   else
      Stripchart.Time1=max(Stripchart.Time1-fix(Diff/4),1);
      Stripchart.Time2=min(Stripchart.Time2+fix(Diff/4),Stripchart.Head.Samples);
      set(Stripchart.Figure,'userdata',Stripchart);
      %axes(Stripchart.Axes);
      set(Stripchart.Axes,'xlim',[Stripchart.Time1 Stripchart.Time2]);
      Zeng_Stripchart('Unit Axis Setting',Stripchart.Figure);
      Zeng_Stripchart('Up grade patch')
   end
%================================================================
case 'Move Left   '
   Temp.Persent = varargin{2};
   Stripchart=get(gcf,'userdata');
   Diff=(Stripchart.Time2-Stripchart.Time1);
   %Move step is two-tenth of diff.
   if  Stripchart.Time1==1;
      %Zeng_Error('Where do you want to go ??');
   else
      if  (Stripchart.Time1-round(Diff*Temp.Persent))<1;
         Stripchart.Time1=1;
         Stripchart.Time2=Diff+1;
      else
         Stripchart.Time1=Stripchart.Time1-round(Diff*Temp.Persent);
         Stripchart.Time2=Stripchart.Time2-round(Diff*Temp.Persent);
      end
      set(Stripchart.Axes,'xlim',[Stripchart.Time1 Stripchart.Time2]);
      set(Stripchart.Figure,'userdata',Stripchart);
      Zeng_Stripchart('Unit Axis Setting',Stripchart.Figure);
      Zeng_Stripchart('Up grade patch')
   end
%================================================================
case 'Move Left  2'
   Stripchart=get(gcf,'userdata');
   Diff=(Stripchart.Time2-Stripchart.Time1);
   if  Stripchart.Time1==1;
      %Zeng_Error('Where do you want to go ??');
   else
      Stripchart.Time1=1;
      Stripchart.Time2=Diff+1;
      set(Stripchart.Axes,'xlim',[Stripchart.Time1 Stripchart.Time2]);
      set(Stripchart.Figure,'userdata',Stripchart);
      Zeng_Stripchart('Unit Axis Setting',Stripchart.Figure);
      Zeng_Stripchart('Up grade patch')
   end
%================================================================
case 'Move Right  '
   Temp.Persent = varargin{2};
   Stripchart=get(gcf,'userdata');
   Diff=(Stripchart.Time2-Stripchart.Time1);
   %Move step is two-tenth of diff.
   if  Stripchart.Time2==Stripchart.Head.Samples;
      %Zeng_Error('Where do you want to go ??');
   else
      if  (Stripchart.Time2+round(Diff*Temp.Persent))>Stripchart.Head.Samples;
         Stripchart.Time2=Stripchart.Head.Samples;
         Stripchart.Time1=Stripchart.Time2-Diff;
      else
         Stripchart.Time2=Stripchart.Time2+round(Diff*Temp.Persent);
         Stripchart.Time1=Stripchart.Time1+round(Diff*Temp.Persent);
      end
      set(Stripchart.Axes,'xlim',[Stripchart.Time1 Stripchart.Time2]);
      set(Stripchart.Figure,'userdata',Stripchart);
      Zeng_Stripchart('Unit Axis Setting',Stripchart.Figure);
      Zeng_Stripchart('Up grade patch')
   end
%================================================================
case 'Move Right 2'
   Stripchart=get(gcf,'userdata');
   Diff=(Stripchart.Time2-Stripchart.Time1);
   if  Stripchart.Time2==Stripchart.Head.Samples;
      %Zeng_Error('Where do you want to go ??');
   else
      Stripchart.Time2=Stripchart.Head.Samples;
      Stripchart.Time1=Stripchart.Time2-Diff;
      set(Stripchart.Axes,'xlim',[Stripchart.Time1 Stripchart.Time2]);
      set(Stripchart.Figure,'userdata',Stripchart);
      Zeng_Stripchart('Unit Axis Setting',Stripchart.Figure);
      Zeng_Stripchart('Up grade patch')
   end
%================================================================
case 'Mouse Move'
   if strcmp('Stripchart',get(gcbf,'tag'));
      Stripchart=get(gcbf,'userdata');
      Position=(get(Stripchart.Axes,'currentpoint'));
      Current_Axis=[Stripchart.Time1 Stripchart.Time2 Stripchart.Patch.Y(2:3)];
      %you can not use Current_Axis=axis in this case because edit-channel and time will not work then.
      if Position(1,2) <Current_Axis(4) & Position(1,2) >Current_Axis(3) & Position(1,1) <Current_Axis(2)+1 & Position(1,1) >Current_Axis(1)-1
         %Do not work where the pointer is over the axes so that you can click the edit.
         if ~isempty(Stripchart.Patch.X)
            axes(Stripchart.Axes);	      % use Current_Axis to fix 1)y axis position 2) flexible range of X of patch
            Position=round(Position);
            if Stripchart.Move.status==1 
               %You wanna move the patch
               index=find(Stripchart.Patch.HD==Stripchart.Patch.HD_Old);
               diffz=Position(1,1:2)-Stripchart.Move.firstclick_position(1:2);
               Current_Patch_XY=round([Stripchart.Move.X_Original+diffz(1)]);
               if Current_Patch_XY(1)>0 & Current_Patch_XY(2)<=Stripchart.Head.Samples
                  %set(Stripchart.Patch.HD(index(1)),'xdata',Current_Patch_XY,'ydata',Stripchart.Patch.Y,'linestyle','-');
                  set(Stripchart.Patch.HD(index(1)),'xdata',Current_Patch_XY,'ydata',Stripchart.Patch.Y,'FaceColor','none');
                  set(Stripchart.Edit.Time1,'string',num2str(Current_Patch_XY(1)))
                  if Current_Patch_XY(2)>Current_Axis(2) & Current_Patch_XY(2)<=Stripchart.Head.Samples
                     set(Stripchart.Axes,'xlim',Current_Axis(1:2)+(Current_Patch_XY(2)-Current_Axis(2)));
                     Stripchart.Time1=Stripchart.Time1+(Current_Patch_XY(2)-Current_Axis(2));
                     Stripchart.Time2=Stripchart.Time2+(Current_Patch_XY(2)-Current_Axis(2));
                  elseif Current_Patch_XY(1)<Current_Axis(1) & Current_Patch_XY(1)>=1
                     set(Stripchart.Axes,'xlim',Current_Axis(1:2)+(Current_Patch_XY(1)-Current_Axis(1)));
                     Stripchart.Time1=Stripchart.Time1+(Current_Patch_XY(1)-Current_Axis(1));
                     Stripchart.Time2=Stripchart.Time2+(Current_Patch_XY(1)-Current_Axis(1));
                  end
               end
            elseif Stripchart.Move.status==2
               %You wanna left expand
               %you can not make it too small
               index=find(Stripchart.Patch.HD==Stripchart.Patch.HD_Old);
               if Position(1)< (Stripchart.Patch.X(index,2)-(Current_Axis(2)-Current_Axis(1))/25)
                  %set(Stripchart.Patch.HD(index(1)),'xdata',[Position(1,1) Stripchart.Patch.X(index,[2 2]) Position(1,1)],'ydata',Stripchart.Patch.Y,'linestyle','-');
                  set(Stripchart.Patch.HD(index(1)),'xdata',[Position(1,1) Stripchart.Patch.X(index,[2 2]) Position(1,1)],'ydata',Stripchart.Patch.Y,'FaceColor','none');
                  set(Stripchart.Edit.Time1,'string',num2str(Position(1,1)))
                  set(Stripchart.Edit.Time2,'string',num2str(Stripchart.Patch.X(index(1),2)-Position(1,1)))
               end
            elseif Stripchart.Move.status==3
               %You wanna right expand
               index=find(Stripchart.Patch.HD==Stripchart.Patch.HD_Old);
               
               
               if Position(1)>Stripchart.Patch.X(index,1)+(Current_Axis(2)-Current_Axis(1))/25
                  %you can not make it too small
                  %set(Stripchart.Patch.HD(index(1)),'xdata',[ Stripchart.Patch.X(index,1) Position(1,[1 1]) Stripchart.Patch.X(index,1)],'ydata',Stripchart.Patch.Y,'linestyle','-');
                  set(Stripchart.Patch.HD(index(1)),'xdata',[ Stripchart.Patch.X(index(1),1) Position(1,[1 1]) Stripchart.Patch.X(index(1),1)],'ydata',Stripchart.Patch.Y,'FaceColor','none');
                  set(Stripchart.Edit.Time2,'string',num2str(Position(1,1)-Stripchart.Patch.X(index(1),1)))
              
               end
            elseif Stripchart.Move.status==4
               index=size(Stripchart.Patch.X);% the row of the lastest patch.
               set(Stripchart.Patch.HD(index(1)),'xdata',[Stripchart.Patch.X(index(1),1) Position(1,[1 1]) Stripchart.Patch.X(index(1),1)]);
            else % Stripchart.Move.status~=(1 2 3 4)
               % the pointer is inside the stripchart axis
               index=find(Stripchart.Patch.X(:,1)<Position(1,1) &Stripchart.Patch.X(:,2)>Position(1,1));
               if isempty(index)
                  if Stripchart.Move.Current_Pointer~=0;
                     set(gcf,'pointer','arrow');
                     Stripchart.Move.Current_Pointer=0;
                  end
               else
                  if ~isempty(Stripchart.Patch.HD_Old)
                     if sum(Stripchart.Patch.HD(index)==Stripchart.Patch.HD_Old)
                        index=find(Stripchart.Patch.HD==Stripchart.Patch.HD_Old);
                     end
                  end
                  
                  if  (Position(1,1)>=Stripchart.Patch.X(index(1),1)+(Current_Axis(2)-Current_Axis(1))/100) & (Position(1,1)<=Stripchart.Patch.X(index(1),2)-(Current_Axis(2)-Current_Axis(1))/100) 
                     % If the X position is inside the patch
                     %set(gcf,'pointer','custom');
                     if Stripchart.Move.Current_Pointer~=1;
                        Temp.SetData=setptr('hand');set(gcbf,Temp.SetData{:})
                        Stripchart.Move.Current_Pointer=1;
                     end
                  elseif Position(1,1)>(Stripchart.Patch.X(index(1),1)+(Current_Axis(2)-Current_Axis(1))/1000)& Position(1,1)<(Stripchart.Patch.X(index(1),1)+(Current_Axis(2)-Current_Axis(1))/100) 
                     %[1000 100 ] from edge.
                     %set(gcf,'pointer','left');	
                     if Stripchart.Move.Current_Pointer~=2;
                        Temp.SetData=setptr('lrdrag');set(gcbf,Temp.SetData{:})
                        Stripchart.Move.Current_Pointer=2;
                     end
                  elseif Position(1,1)>(Stripchart.Patch.X(index(1),2)-(Current_Axis(2)-Current_Axis(1))/100)& Position(1,1)<(Stripchart.Patch.X(index(1),2)-(Current_Axis(2)-Current_Axis(1))/1000) 
                     %[200 50 ] from edge.
                     %set(gcf,'pointer','Right');	
                     if Stripchart.Move.Current_Pointer~=3;
                        Temp.SetData=setptr('lrdrag');set(gcbf,Temp.SetData{:})
                        Stripchart.Move.Current_Pointer=3;
                     end
                  end
               end
   
            end;% else % Stripchart.Move.status==1
            set(Stripchart.Figure,'userdata',Stripchart);
         end % 		if ~isempty(Stripchart.Patch.X)
      else %if Position(1,2) <Current_Axis(4) & Position(1,2) >Current_Axis(3) & Position(1,1) <Current_Axis(2)+1 & Position(1,1) >Current_Axis(1)-1
         Current_Point=get(gcbf,'currentpoint');
         Position=get(gcbf,'position');
         if Stripchart.Move.status==4 
            Zeng_Stripchart('Create patch Up')            
         elseif Stripchart.Move.status~=0 
            Zeng_Stripchart('Mouse Move Up')            
         end
         set(gcf,'pointer','arrow');
      end
   end %   if strcmp('Stripchart',get(gcf,'tag'));

       
      
%------------------------------------------------------------------------------------------------------      
case 'Mouse Down'
   Stripchart=get(gcf,'userdata');
   axes(Stripchart.Axes);
   set(Stripchart.Figure,'WindowButtonMotionFcn','Zeng_Stripchart(''Mouse Move'')')
   % use Current_Axis to fix 1)y axis position 2) flexible range of X of patch
   Current_Axis=axis;
   Position=get(Stripchart.Axes,'currentpoint');
   if (Position(1,2)>Current_Axis(3) & Position(1,2)<Current_Axis(4))
      % You click in the axis area
      set(Stripchart.Figure,'WindowButtonDownFcn','')
      if isempty(Stripchart.Patch.X)
         Stripchart.Move.status=4;
         set(Stripchart.Figure,'userdata',Stripchart);
         set(Stripchart.Edit.Time1,'string',' ')
         set(Stripchart.Edit.Time2,'string',' ')
         Zeng_Stripchart('Create Patch');
         
      else
         Convered_Patch=find(Stripchart.Patch.X(:,1)<Position(1,1) & Stripchart.Patch.X(:,2)>Position(1,1));
         if isempty(Convered_Patch);
	         Stripchart.Move.status=4;
   	      set(Stripchart.Figure,'userdata',Stripchart);
         	set(Stripchart.Edit.Time1,'string',' ')
         	set(Stripchart.Edit.Time2,'string',' ')
         	Zeng_Stripchart('Create Patch');
	      else %if isempty(Stripchart.Patch.X)
            if isempty(Stripchart.Patch.HD_Old)
               index=Convered_Patch(1);
	            Stripchart.Patch.HD_Old=Stripchart.Patch.HD(index);  
            else
            	indexOld=find(Stripchart.Patch.HD==Stripchart.Patch.HD_Old);
               if isempty(find(Convered_Patch==indexOld))
                  set(Stripchart.Patch.HD_Old,'linewidth',Log.UD.Ref.ThinLine);
	               index=Convered_Patch(1);
		            Stripchart.Patch.HD_Old=Stripchart.Patch.HD(index);  
               else
                  index=indexOld;
               end
            end
            set(Stripchart.Patch.HD_Old,'linewidth',Log.UD.Ref.ThickLine);
            set(Stripchart.Edit.Time1,'string',num2str(Stripchart.Patch.X(index,1)))
            set(Stripchart.Edit.Time2,'string',num2str(diff(Stripchart.Patch.X(index,:))))
            
            %Temp.WaveForm=findobj(Stripchart.WaveForm.Figure,'color',get(Stripchart.Patch.HD_Old,'edgecolor'),'name',[Stripchart.Head.FileName ':' 'WaveForm']); 
            %if ~isempty(Temp.WaveForm)
            %   figure(Temp.WaveForm)
            %end
            %figure(Stripchart.Figure)
            
            %To	 change the color of plot in wavefom window
            %if strcmp(get(Stripchart.Patch.HD_Old,'LineStyle'),'-')
            if strcmp(get(Stripchart.Patch.HD_Old,'marker'),'none')
               %To show that you already change
               if   Stripchart.Move.Current_Pointer==1
                  %You wanna move the patch
                  Stripchart.Move.status=1;%Move the patch 
                  %s=1%Move the patch 
                  set(Stripchart.Figure,'WindowButtonUpFcn','Zeng_Stripchart(''Mouse Move Up'')');
                  Temp.SetData=setptr('closedhand');set(gcbf,Temp.SetData{:});
                  Stripchart.Move.firstclick_position=[Position(1,1) Position(1,2)];
                  Stripchart.Move.X_Original=get(Stripchart.Patch.HD(index(1)),'xdata');
               elseif  Stripchart.Move.Current_Pointer==2
                  %You wanna left expand
                  %s=2
                  Stripchart.Move.status=2;
                  set(Stripchart.Figure,'WindowButtonUpFcn','Zeng_Stripchart(''Mouse Move Up'')');
                  Stripchart.Move.firstclick_position=[Position(1,1) Position(1,2)];
                  Stripchart.Move.X_Original=get(Stripchart.Patch.HD(index(1)),'xdata');
                  %    	   elseif strcmp('right',get(gcf,'pointer')) 
               elseif  Stripchart.Move.Current_Pointer==3
                  %You wanna right expand
                  %s=3
                  Stripchart.Move.status=3;
                  set(Stripchart.Figure,'WindowButtonUpFcn','Zeng_Stripchart(''Mouse Move Up'')');
                  Stripchart.Move.firstclick_position=[Position(1,1) Position(1,2)];
                  Stripchart.Move.X_Original=get(Stripchart.Patch.HD(index(1)),'xdata');
               end
            end %if strcmp(get(Stripchart.Patch.HD_Old,'LineStyle'),'-')
            set(Stripchart.Figure,'userdata',Stripchart);
            Zeng_Stripchart('Update Segment Botton')
         end %if ~isempty(index)
      end %else %if isempty(Stripchart.Patch.X)
      set(Stripchart.Figure,'WindowButtonDownFcn','Zeng_Stripchart(''Mouse Down'')')
   end %if (Position(1,2)>Current_Axis(3) & Position(1,2)<Current_Axis(4))
%------------------------------------------------------------------------------------------------------      
case 'Mouse Move Up'
   Stripchart=get(gcbf,'userdata');
   Stripchart.Annote.Changed=1;
   set(gcbf,'WindowButtonUpFcn','');
   set(Stripchart.Figure,'WindowButtonDownFcn','Zeng_Stripchart(''Mouse Down'')')
   Temp.SetData=setptr('hand');set(gcbf,Temp.SetData{:})
   %set(gcf,'PointerShapeCData',Log.UD.Icon.BigHand);
   Position=get(Stripchart.Axes,'currentpoint');
   % use Current_Axis to fix 1)y axis position 2) flexible range of X of patch
   axes(Stripchart.Axes);
   Current_Axis=axis;
   index=find(Stripchart.Patch.HD==Stripchart.Patch.HD_Old);
   Current_Xdata=get(Stripchart.Patch.HD(index),'xdata');
   Stripchart.Patch.X(index,1:2)=round([max(1,Current_Xdata(1)), min(Stripchart.Head.Samples,Current_Xdata(2))]);
   set(Stripchart.Patch.HD(index),'xdata',Stripchart.Patch.X(index,[1 2 2 1]));
   Stripchart.Move.status=0;
   set(Stripchart.Figure,'userdata',Stripchart);
   %Update the axeses of wave form the be the current patch
   Zeng_Stripchart('Update WaveForm Axes',Stripchart.Patch.HD(index));
  %----------------------------------------------------------------------------------------------------      
case 'Update WaveForm Axes'
   Stripchart=get(gcbf,'userdata');
   if ~isempty(Stripchart.WaveForm.Figure)
      %num=WaveForm window HD.
      num=findobj(0,'color',get(varargin{2},'edgecolor'),'tag','WaveForm','name',[Stripchart.Head.FileName ':' 'WaveForm'])';
      index=find(Stripchart.Patch.HD==varargin{2});
      if ~isempty(num);
         figure(num);
         WaveForm=get(num,'userdata');
         %set(WaveForm.Ch.Cursor ,'ydata',[nan nan]),set(WaveForm.Ch.Annote.ActTime,'ydata',[nan nan]);
         %set(WaveForm.Ch.Cursor ,'ydata',[nan nan]);
         for num=1:WaveForm.axises
            for m=0:(length(WaveForm.Ch.Plot(1,:))-1)
               Line=findobj(WaveForm.Ch.Axes(num),'type','line','userdata',m,'visible','on');
               if ~isempty(Line)
                  for o=1:length(Line)
                     Ydata=get(Line(o),'ydata');
                     Ydata=Ydata-min([Ydata(Stripchart.Patch.X(index,1):Stripchart.Patch.X(index,2))]);
                     if max([Ydata(Stripchart.Patch.X(index,1):Stripchart.Patch.X(index,2))])>0
                        Ydata=Ydata/max([Ydata(Stripchart.Patch.X(index,1):Stripchart.Patch.X(index,2))]);
                        set(Line(o),'ydata',Ydata)
                     end
                  end
               end
            end
         
            %set(WaveForm.Ch.Cursor(num,:),'ydata',get(WaveForm.Ch.Axes(num),'ylim'));
            set(WaveForm.Ch.Cursor(num,:),'ydata',[0 1]);
            %You have to set xlim before adjust addnot
            set(WaveForm.Ch.Axes(num),'xlim',[Stripchart.Patch.X(index,1:2)])
            Zeng_WaveForm('Adjust Annote',WaveForm.Figure,num);
         end
         %set(WaveForm.Ch.Axes(1:WaveForm.axises),'xlim',[Stripchart.Patch.X(index,1:2)]);
         Zeng_Stripchart('Unit Axis Setting',WaveForm.Figure);
      end
   end
   %----------------------------------------------------------------------------------------------------      
case 'Create Patch'
      Stripchart=get(gcf,'userdata');
      %Create a new patch and save it in Stripchart.Patch.HD_Old
      Index=find(Stripchart.Color.Index==0);
      if isempty(Index)
         set(Stripchart.Edit.Time1,'string',' ')
         set(Stripchart.Edit.Time2,'string',' ')
         Zeng_Error('I let you have only 7 segments !!!');
         Zeng_Stripchart('Mouse Move Up');
      else
         if ~isempty(Stripchart.Patch.HD_Old)
            set(Stripchart.Patch.HD_Old,'linewidth',Log.UD.Ref.ThinLine);
         end
         Position=get(Stripchart.Axes,'currentpoint');
         axes(Stripchart.Axes);
         Current_Axis=axis;
         Stripchart.Patch.X=round([Stripchart.Patch.X;[Position(1,1) Position(1,1)]]);
         Stripchart.Patch.Y=[Current_Axis(3) Current_Axis(3) Current_Axis(4) Current_Axis(4)];
         
         %0=unuse 1=exist 2=just create.
         %you have to change for 2 to 1 if created successfully ,or to 0 if unsuccessfully
         Stripchart.Color.Index(Index(1))=2;
         Stripchart.Patch.HD_Old=patch(...
            'CData',[],...
            'CDataMapping','scaled',...
            'FaceVertexCData',[],...	         'EdgeColor',[[0.5+[rand rand rand]/2]],...
            'EdgeColor',Stripchart.Color.Ref(Index(1),:),...
	         'EraseMode','xor',...
            'FaceColor','none',...
            'Faces',[1 2 3 4 5],...
            'LineStyle','--',...
            'LineWidth',Log.UD.Ref.ThinLine,...
            'Marker','none',...
            'MarkerEdgeColor','auto',...
            'MarkerFaceColor','none',...
            'MarkerSize',[6],...
            'XData',[Position(1,1) Position(1,1) Position(1,1) Position(1,1)],...
            'YData',Stripchart.Patch.Y);
         Stripchart.Patch.HD=[Stripchart.Patch.HD;Stripchart.Patch.HD_Old];
         set(Stripchart.Figure,'userdata',Stripchart);
         set(gcf,'WindowButtonUpFcn','Zeng_Stripchart(''Create patch Up'')');
         
      end
   %------------------------------------------------------------------------------------------------------      
case 'Create patch Up'
   Stripchart=get(gcf,'userdata');
   set(gcf,'WindowButtonUpFcn','');
   set(Stripchart.Figure,'WindowButtonDownFcn','Zeng_Stripchart(''Mouse Down'')')
   Position=get(Stripchart.Axes,'currentpoint');
   Stripchart.Move.status=0;
   axes(Stripchart.Axes);
   Current_Axis=axis;  
   index=size(Stripchart.Patch.X);% the row of the lastest patch.
   %index =[row 4]
   if abs(Position(1,1)-Stripchart.Patch.X(index(1),1))>(Current_Axis(2)-Current_Axis(1))/50
      Stripchart.Color.Index(  find(Stripchart.Color.Index==2)   )=1;
      
      if Position(1,1)>Stripchart.Patch.X(index(1),1)
         %You move right
         Stripchart.Patch.X(index(1),2)=round(min(Position(1,1),Current_Axis(2)));
      else
         %You move left
         Stripchart.Patch.X(index(1),:)=round([max(Position(1,1),Current_Axis(1)) Stripchart.Patch.X(index(1),1)]);
      end
      set(Stripchart.Edit.Time1,'string',num2str(Stripchart.Patch.X(index(1),1)))
      set(Stripchart.Edit.Time2,'string',num2str(diff(Stripchart.Patch.X(index(1),:))))

      set(Stripchart.Patch.HD(index(1)),'LineWidth',Log.UD.Ref.ThickLine);
      set(Stripchart.Patch.HD(index(1)),'LineStyle','-','xdata',[Stripchart.Patch.X(index(1),:) Stripchart.Patch.X(index(1),2) Stripchart.Patch.X(index(1),1)]);
   else
      Stripchart.Color.Index(  find(Stripchart.Color.Index==2)   )=0;
      delete(Stripchart.Patch.HD(index(1)));
      Stripchart.Patch.X(index(1),:)=[];
      Stripchart.Patch.HD(index(1))=[];
      Stripchart.Patch.HD_Old=[];
      %Delete the first point click
   end
   set(Stripchart.Figure,'userdata',Stripchart);
   Zeng_Stripchart('Update Segment Botton')
   
   %================================================================
case 'Load Patch from File'
   Stripchart=get(varargin{2},'userdata');
   delete(Stripchart.Patch.HD);
   delete(Stripchart.WaveForm.Figure);
   Stripchart.WaveForm.Figure=[];
   Stripchart.Patch.HD=[];
   
   Stripchart.Patch.X=round(varargin{3});
   Stripchart.Color.Index(1:length(Stripchart.Color.Index))=0;
   Stripchart.Color.Index(1:size(Stripchart.Patch.X,1))=1;
   Stripchart.Move.status=0;
   Stripchart.Move.Current_Pointer=0;
   
   axes(Stripchart.Axes)
   for n=1:size(Stripchart.Patch.X,1)
      Stripchart.Patch.HD_Old=patch(...
         'CData',[],...
         'CDataMapping','scaled',...
         'FaceVertexCData',[],...	         'EdgeColor',[[0.5+[rand rand rand]/2]],...
         'EdgeColor',Stripchart.Color.Ref(n,:),...
         'EraseMode','xor',...
         'FaceColor','none',...
         'Faces',[1 2 3 4 5],...
         'LineStyle','-',...
         'LineWidth',Log.UD.Ref.ThinLine,...
         'Marker','none',...
         'MarkerEdgeColor','auto',...
         'MarkerFaceColor','none',...
         'MarkerSize',[6],...
         'XData',[Stripchart.Patch.X(n,[1 2 2 1])],...
         'YData',Stripchart.Patch.Y);
      Stripchart.Patch.HD=[Stripchart.Patch.HD;Stripchart.Patch.HD_Old];
   end
   set(Stripchart.Patch.HD_Old,'LineWidth',Log.UD.Ref.ThickLine)
      
   set(Stripchart.Figure,'userdata',Stripchart);
   Zeng_Stripchart('Update Segment Botton',Stripchart.Figure)
   
case 'Up grade patch'
   Stripchart=get(gcbf,'userdata');
   Zeng_Stripchart('Data Type Plot',Stripchart.Figure,Stripchart.Plot(1),Stripchart.Current_ch,0,1,0) %6=gain ,7=offset   
   Stripchart.Patch.HD_Old=findobj(Stripchart.Patch.HD,'LineWidth',Log.UD.Ref.ThickLine);
   set(gca,'ylimmode','manual')
   set(Stripchart.Figure,'userdata',Stripchart);
   %================================================================
otherwise
      a='Error in Stripchart'
end
%================================================================
