function [varargout]=Zeng_WaveForm(varargin)
% whenever you want to read axes of btngroup, do not forget to set(0,'showhiddenhandles','on')

%future
%set the ylimit of all annotce.
global Log
global Data
global Contour
global Stripchart

action = varargin{1};

switch action
%================================================================
case 'Initial' 
   %='initial'  only when you choose it from windows-analysis in each stripchart window
   if strcmp('Stripchart',get(gcbf,'tag'))
      %You click analysis-waveform
      Stripchart=get(gcbf,'userdata');
   elseif strcmp('Conduction',get(gcbf,'tag'))
      Conduction=get(gcbf,'userdata');
      Stripchart=get(Conduction.Parent,'userdata');
      Conduction=[];
   else
      %You click duplicate in wave form window.
      WaveForm=get(gcbf,'userdata');
      Stripchart=get(WaveForm.Parent,'userdata');
      WaveForm=[];
   end
   set(0,'showhiddenhandles','on');
   set(0,'showhiddenhandles','off');
   Continue=0;  
   if nargin == 1 | strcmp('Conduction',get(gcbf,'tag'))
      %you click either waveform-analysis or duplicate.
      if length(Stripchart.WaveForm.Figure)==4
         Zeng_Error('I would let you duplicate more if you used projector instead of monitor.   Understand!!!?');
      elseif isempty(findobj(Stripchart.Axes,'type','patch','LineWidth',Log.UD.Ref.ThickLine));
         Zeng_Stripchart('No Patch')
      else
         Temp.Patch=findobj(Stripchart.Axes,'type','patch','LineWidth',Log.UD.Ref.ThickLine);
         %if ~isempty( findobj(0,'name',[Stripchart.Head.FileName ':' 'WaveForm'],'color',color));
         if ~isempty( findobj(0,'tag','WaveForm','name',[Stripchart.Head.FileName ':' 'WaveForm'],'color',get(Temp.Patch,'edgecolor')));
            Zeng_Error('I let you have only one waveform windon for each segment!!!');
         else
            Continue=1;  
            %Add new children in Stripchart.
            WaveForm.Patch=Temp.Patch;
            WaveForm.Figure=figure;
            %Create the new userdata WaveForm valueable 
            WaveForm.Parent=Stripchart.Figure;
            WaveForm.ChLabel=Stripchart.ChLabel;
            %FG_Size=Log.UD.Ref.AnalysisSz; %Reference for Analysis window
            %You create waveform window from stripchart menu.
            Temp=get(Stripchart.Figure,'position');
            %FG_Size=Log.UD.Ref.Position(Log.UD.HD.WaveForm.Figure,:);
            %FG_Size=[Temp(1) Temp(2)+Temp(4) Temp(3) Log.UD.ScreenSize(2)-Temp(2)-Temp(4)-30];
            FG_Size=[5 Log.UD.ScreenSize(2)-Log.UD.HD.WaveForm.FG_Limit(2)*2-35 Log.UD.HD.WaveForm.FG_Limit*2];
            WaveForm.axises=4;% default Number of axis in this windows
            %if you want to change the name or tag, you have to change it in waveform also.
            WaveForm.Color=get(findobj(Stripchart.Axes,'type','patch','LineWidth',Log.UD.Ref.ThickLine),'edgecolor');
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   % Added 072909 to force program to remember size of waveform window
    xtemp=dir('WaveformParams.mat');
	LogPosition=get(Log.Figure,'Position');
    if isempty(xtemp)
         FG_Size=[Stripchart.AxesSz(1) LogPosition(2)-LogPosition(4)-30 Stripchart.AxesSz(3) LogPosition(4)*2];
    else
        load WaveformParams
       FG_Size=WaveformParams.FG_Size;
    end
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	         	
            WaveForm.Ref.AxisPostion=[ Log.UD.Ref.Ch_Box(1)*2.2 Log.UD.Ref.Ch_Box(2) FG_Size(3)-35-Log.UD.Ref.Ch_Box(1)*2.2 (FG_Size(4)-Log.UD.Ref.Ch_Box(2))];
            set(WaveForm.Figure,...
               'Units','pixels',...      	  'Color',get(findobj(Stripchart.Axes,'type','patch','LineWidth',Log.UD.Ref.ThickLine),'edgecolor'), ...
               'Color',WaveForm.Color, ...
               'DeleteFcn','Zeng_WaveForm(''DeleteFcn'')',...
               'MenuBar','none', ...
               'Name',[Stripchart.Head.FileName ':' 'WaveForm'],...
               'NumberTitle','off',...%               
               'PaperPositionMode','auto',...If you make it auto, pagedlg won't work
               'Position',FG_Size,...
               'tag','WaveForm');    
            %Set the tag  this way so that when you move the patch in stripchart, you can track which wave form window you want to change.
            %    the name     "                     "              "                             "  
            %-------------------------------------------------------------------------------
            %Create the activate check box.
            
            WaveForm.Text.Channel_Label= uicontrol('Parent',WaveForm.Figure, ...
               'BackgroundColor',get(WaveForm.Figure,'color'), ...%            
               'FontName','Arial',...
               'FontUnits','points',...
               'FontSize',Log.UD.Ref.FontSize,...
               'FontWeight','normal',...
               'FontAngle','normal',...
               'HorizontalAlignment','left', ...
               'Position',[1 FG_Size(4)-Log.UD.Ref.Ch_Box(2) WaveForm.Ref.AxisPostion(1)-2 Log.UD.Ref.Ch_Box(2)], ...
               'String','Fix  Channel', ...
               'Style','text');
            
            
            
            %cursor label
            WaveForm.Text.Cursor= uicontrol('Parent',WaveForm.Figure, ...
	            'BackgroundColor',get(WaveForm.Figure,'color'), ...%            
               'FontName','Arial',...
               'FontUnits','points',...
               'FontSize',Log.UD.Ref.FontSize,...
               'FontWeight','normal',...
               'FontAngle','normal',...
               'HorizontalAlignment','left', ...
               'Position',[FG_Size(3)-Log.UD.Ref.Ch_Box(1) FG_Size(4)-Log.UD.Ref.Ch_Box(2) Log.UD.Ref.Ch_Box],...
               'String','Cursor', ...
               'Style','text', ...
               'Tag','Cursor',...
               'visible','off');
            
            WaveForm.Button.CursorCallGlobal=btngroup(WaveForm.Figure,'ButtonID','1',...%Tag=ButtonID  Log.UD=step of buttons  
                'Callbacks','Zeng_WaveForm(''Call Global'')',...
                'IconFunctions','text(.1,.5,''G'')',...
                'GroupID','G',...%L=line C=channel
                'GroupSize',[1 1],...   
                'PressType','toggle',...
                'BevelWidth',.1,...
                'units','pixels',...
                'Position',[FG_Size(3)-20 1 15 15]);%,...
             %-------------------------------------------------
             % Create scroll bar button group
             icons = {['[ line([.2 .5 .8 nan .2 .8],[.2 .7 .2 nan .85 .85 ],''color'',''r'')]';
                      '[ line([.2 .5 .8 ],[.2 .8 .2 ]                     ,''color'',''r'')]';
                      '[ line([.2 .5 .8 ],[.8 .2 .8 ]                     ,''color'',''r'')]';
		                '[ line([.2 .5 .8 nan .2 .8],[.8 .3 .8 nan .15 .15 ],''color'',''r'')]']};
             WaveForm.Button.ChnlChanging_Grp_CBs=['Zeng_WaveForm(''Group Increase Ch 2'')';
                       'Zeng_WaveForm(''Group Increase Ch'')  ';
                       'Zeng_WaveForm(''Group Decrease Ch'')  ';
                       'Zeng_WaveForm(''Group Decrease Ch 2'')'];
         
             PressType=['flash';'flash';'flash';'flash'];
             WaveForm.Button.ChnlChanging_GrpSz=[20 1 Log.UD.Ref.Ch_Box(1)+20 Log.UD.Ref.Ch_Box(2)-4];
             WaveForm.Button.ChnlChanging_Grp=	btngroup(WaveForm.Figure,'ButtonID',['B1';'B2';'B3';'B4'],...
               'Callbacks',WaveForm.Button.ChnlChanging_Grp_CBs,...
               'IconFunctions',str2mat(icons{:}),...
               'GroupID', 'ViewGraph',...
               'GroupSize',[1 4],...   
               'PressType',PressType,...
               'BevelWidth',.075,...
               'units','pixels',...
               'Position',WaveForm.Button.ChnlChanging_GrpSz ,...
               'Orientation','horizontal');
            
            %set(WaveForm.Button.ChnlChanging_Grp,'visible','off')
             %------------------------------
             Stripchart.WaveForm.Figure=[Stripchart.WaveForm.Figure;WaveForm.Figure];
             set(Stripchart.Figure,'userdata',Stripchart);
             WaveForm.Check.GroupChange = uicontrol('Parent',WaveForm.Figure, ... 
               'FontName','Arial',...
	         	'FontUnits','points',...
		         'FontSize',Log.UD.Ref.FontSize,...
		         'FontWeight','normal',...
	   	      'FontAngle','normal',...
	      	   'Units','pixels', ...
		         'BackgroundColor',[0.8 0.8 0.8], ...
		         'Position',[85 1 100 15],...%25=WaveForm.Ch.Edit.ChannelSz(num,1)
	   	      'String','Group Change', ...
	      	   'Style','checkbox', ...
	         	'Tag','Chk_Activate',...
               'visible','off',...
               'enable','off',...
		         'value',0);	   
            if Stripchart.Head.Help.DataType==1
               WaveForm.Ch.Gain=ones(Stripchart.ELTPoint,1);
               WaveForm.Ch.Offset=zeros(Stripchart.ELTPoint,1);
            else
               WaveForm.Ch.Gain=ones(Stripchart.ELTPoint,3);
               WaveForm.Ch.Offset=zeros(Stripchart.ELTPoint,3);
            end
            %Annote Lable Y position
            WaveForm.Ant_Label_Y=1/3;
				%For filter
            WaveForm.HP=20;
            WaveForm.LP=250;
            
				%For moving----------------------------------------------------
            WaveForm.Move.Status=0;
            WaveForm.Move.OldIndex=0;
            WaveForm.Move.Current_Pointer=0;
            %WaveForm.Patch.X=[];
            %WaveForm.Patch.HD_Old=[];
            %WaveForm.Patch.HD=[];
            %--------------------------------------------------------------
                        %-----------------------------------------------------------------
            TFile={
               'File'                            ' '                                  ' '
               '>Save Waveforms'                 'Zeng_WaveForm2(''Save WaveForm'')'  ' '
               '>------        '                 '                                 '  ' '%               '>Page Setup... '                 'pagedlg(gcbf)                    '  ' '
               '>Print...      '                 'printdlg                         '  ' '
               '>Print Setup.. '                 'print -dsetup                    '  ' '  
               '>------        '                 '                                 '  ' '
               '>Export        '                 '                                 '  ' '
               '>>JPG          '                 'Zeng_Share(''Export'',''jpg'')   '  '-djpeg100'
               '>>Pict         '                 'Zeng_Share(''Export'',''pic'')   '  '-dpict'};
            WaveForm.Menu.File=makemenu(WaveForm.Figure,char(TFile(:,1)),char(TFile(:,2)), char(TFile(:,3)));
            
            if ~strcmp('MAC2',computer)
               set(findobj(WaveForm.Menu.File,'tag','-dpict'),'enable','off')   
            end
         
            Hm_Setting={
               'Setting'             ' '                                          'Setting'
               '>Filters'            'Zeng_WaveForm2(''Filters'')'                'Filter'
               '>Inverting Yaxis'    'Zeng_WaveForm2(''Inverting'')'              'Inverting'      
               '>No.of waveforms'    '  '                                         'AxesNumber'
               '>>1         '        'Zeng_WaveForm(''Setting Axes'')  '          '1'
               '>>2         '        'Zeng_WaveForm(''Setting Axes'')  '          '2'
               '>>3         '        'Zeng_WaveForm(''Setting Axes'')  '          '3'
               '>>4         '        'Zeng_WaveForm(''Setting Axes'')  '          '4'
               '>>5         '        'Zeng_WaveForm(''Setting Axes'')  '          '5'
               '>>6         '        'Zeng_WaveForm(''Setting Axes'')  '          '6'
               '>>7         '        'Zeng_WaveForm(''Setting Axes'')  '          '7'
               '>>8         '        'Zeng_WaveForm(''Setting Axes'')  '          '8'
               '>>9         '        'Zeng_WaveForm(''Setting Axes'')  '          '9'
               '>>10        '        'Zeng_WaveForm(''Setting Axes'')  '          '10'
               '>------'              ' '                               ' '
               '>Fonts   ...'      'Zeng_Share(''Fonts Setting'')'      'Fonts'};
            WaveForm.Menu.Setting=makemenu(WaveForm.Figure,char(Hm_Setting(:,1)),char(Hm_Setting(:,2)), char(Hm_Setting(:,3)));
            
            TempObjVar=findobj(WaveForm.Menu.Setting,'tag','AxesNumber');
            set(get(TempObjVar(end),'children'),'checked','off');
            set(findobj(TempObjVar(end),'tag',num2str(WaveForm.axises)),'checked','on')
		               
         end
         
      	end%	      if length(Stripchart.WaveForm.Figure)==3
	   elseif nargin == 2 %you changed the axis number.
      	Continue=1;  
      	WaveForm=get(gcbf,'userdata');
      	FG_Size=get(gcbf,'position');
         WaveForm.Ref.AxisPostion=[ Log.UD.Ref.Ch_Box(1)*2.2 Log.UD.Ref.Ch_Box(2) FG_Size(3)-35-Log.UD.Ref.Ch_Box(1)*2.2 (FG_Size(4)-Log.UD.Ref.Ch_Box(2))];
         delete(WaveForm.Ch.Text.Y2);          
         delete(WaveForm.Ch.Text.X2);
         delete(WaveForm.Ch.Text.dX1);
         delete(WaveForm.Ch.Text.dX2);
         delete(WaveForm.Ch.Button.CursorCall);
         delete(WaveForm.Ch.Button.ChnlChanging)
         if ~isempty(findobj(WaveForm.Figure,'tag','V1'));
            delete(WaveForm.Ch.Button.View)
         end
         
         delete(WaveForm.Ch.Edit.Channel)
         delete(WaveForm.Ch.CheckBox.Fix)
         delete(WaveForm.Ch.Axes)
         delete(WaveForm.Ch.Button.Del)
         WaveForm.Ch=[];
         
      end
      if Continue      
         %--------------------------------------------------------------------------------
         set(WaveForm.Figure,'userdata',WaveForm);
         index=find(Stripchart.Patch.HD==Stripchart.Patch.HD_Old);
         Zeng_WaveForm('Ch Creation',WaveForm.Figure,1:WaveForm.axises,WaveForm.ChLabel(1:WaveForm.axises,1),Stripchart.Patch.X(index,1:2));
         WaveForm=get(WaveForm.Figure,'userdata');
         
         
         
         set(WaveForm.Ch.Axes(WaveForm.axises),'XColor',[0 0 0]);
         
         set(WaveForm.Figure,'Renderer','zbuffer','backingstore','off')
         set(WaveForm.Figure,'WindowButtonMotionFcn','Zeng_WaveForm(''Mouse Move'')')
		   set(WaveForm.Figure,'WindowButtonDownFcn','Zeng_WaveForm(''Mouse Down'')')
         set(WaveForm.Figure,'WindowButtonUp','')
         set(WaveForm.Figure,'ResizeFcn','Zeng_WaveForm(''ResizeFcn'')');
         
	      
        set(Stripchart.Figure,'userdata',Stripchart);	
   
         %Zeng_Stripchart('Data Type Plot',WaveForm.Parent,WaveForm.Ch.Plot(num,1),num)   
         
         % Zeng_Stripchart('Unit Axis Setting',WaveForm.Figure);
         if ~isempty(Stripchart.Annote.Show)
            Zeng_WaveForm('Adjust Annote',WaveForm.Figure,1:length(WaveForm.Ch.Axes));
         end
         Zeng_Stripchart('Unit Axis Setting',WaveForm.Figure);

         set(findobj(WaveForm.Figure,'type','text'),'fontsize',Log.UD.Ref.FontSize)         
         Temp=findobj(0,'tag','Conduction','color',WaveForm.Color,'name',[Stripchart.Head.FileName ':' 'Conduction']);
         if ~isempty(Temp)
            Zeng_Conduction('Refresh Axes',Temp,-1,WaveForm.Ch.Current_ch)
               %-1 = all
         end

   
      end%if Continue      
case 'ShowMe'
   WaveForm=get(gcbf,'userdata');
   num=(str2num(get(gcbo,'tag')));
   Temp1=findobj(0,'name',[Stripchart.Head.FileName ':' 'Contour']);
   Temp.Contour=findobj(0,'tag','Contour','color',WaveForm.Color,'name',[Stripchart.Head.FileName ':' 'Contour']);
if isempty(Temp.Contour)
    warndlg('Open Contour Window First')
return
end

   Contour.LUT=Stripchart.Head.LUT;
   Contour.DataType=Stripchart.Head.Help.DataType;
   [Contour.Ch_XY Contour.Interp_Segment]=Zeng_LUTDisplay('LUT Reading',Contour.LUT,'Ch_XY',Contour.DataType);
   currentpoints=Contour.Ch_XY(find(Contour.Ch_XY(:,1)==WaveForm.Ch.Current_ch(num)),2:3);
SContour=get(Temp.Contour,'userdata');
for i=1:5
    LastMarker=findobj(SContour.Axes,'type','patch','Marker','+','MarkerEdgeColor',[1 0 0]);
    if ~isempty(LastMarker)
        delete(LastMarker)
        pause(0.1)
    end
    Zeng_Contour('Marker',Temp.Contour,WaveForm.Ch.Current_ch(num),currentpoints)
    pause(0.1)
end

   WaveForm.Ch.Current_ch(num);
%================================================================
case 'Del Ch'
   WaveForm=get(gcbf,'userdata');
   if WaveForm.axises>1;
      Temp=[];
      %num of axes you want to del
      Temp.Del=varargin{2};
      Stripchart=get(WaveForm.Parent,'userdata');
      Temp.num=(WaveForm.axises-Temp.Del+1):WaveForm.axises;
      WaveForm.axises=WaveForm.axises-Temp.Del;
      Temp.Obj=[];
      Temp.Obj=[Temp.Obj WaveForm.Ch.Text.Y2(Temp.num)];          
      Temp.Obj=[Temp.Obj WaveForm.Ch.Text.X2(Temp.num)];          
      Temp.Obj=[Temp.Obj WaveForm.Ch.Text.dX1(Temp.num)];    
      Temp.Obj=[Temp.Obj WaveForm.Ch.Text.dX2(Temp.num)];
      Temp.Obj=[Temp.Obj WaveForm.Ch.Button.ChnlChanging(Temp.num)];
      Temp.Obj=[Temp.Obj reshape(WaveForm.Ch.Button.CursorCall(Temp.num,:),1,length(Temp.num)*2)];
      Temp.Obj=[Temp.Obj WaveForm.Ch.Button.F(Temp.num)];
      Temp.Obj=[Temp.Obj WaveForm.Ch.Button.ShowMe(Temp.num)];
      
      if ~isempty(findobj(WaveForm.Figure,'tag','V1'));
         Temp.Obj=[Temp.Obj WaveForm.Ch.Button.View(Temp.num)];
         
      end
      
      if ~isempty(findobj(WaveForm.Figure,'tag','Z1'));
         Temp.Obj=[Temp.Obj WaveForm.Ch.Button.AxesZoom(Temp.num)];
         WaveForm.Ch.Button.AxesZoom(Temp.num)=[];   
      end
      
      Temp.Obj=[Temp.Obj WaveForm.Ch.Edit.Channel(Temp.num)];
      Temp.Obj=[Temp.Obj WaveForm.Ch.CheckBox.Fix(Temp.num)];
      Temp.Obj=[Temp.Obj WaveForm.Ch.Axes(Temp.num)];
      Temp.Obj=[Temp.Obj WaveForm.Ch.Button.Del(Temp.num)];
      
      Temp.Fix=get(WaveForm.Ch.CheckBox.Fix,'value');
      if iscell(Temp.Fix);
         Temp.Fix=[Temp.Fix{1:length(Temp.Fix)}];
      end
      Temp.Ch.Current_ch=WaveForm.Ch.Current_ch;
      
      WaveForm.Ch.Button.ChnlChangingSz(Temp.num,:)=[];
      WaveForm.Ch.Button.ChnlChanging(Temp.num)=[];
      WaveForm.Ch.Button.CursorCall(Temp.num,:)=[];
      WaveForm.Ch.Button.DelSz(Temp.num,:)=[];
      WaveForm.Ch.Button.Del(Temp.num)=[];
      WaveForm.Ch.Edit.ChannelSz(Temp.num,:)=[];
      WaveForm.Ch.Edit.Channel(Temp.num)=[];
      WaveForm.Ch.Text.X2Sz(Temp.num,:)=[];
      WaveForm.Ch.Text.X2(Temp.num)=[];
      WaveForm.Ch.Text.Y2Sz(Temp.num,:)=[];
      WaveForm.Ch.Text.Y2(Temp.num)=[];
      WaveForm.Ch.Text.dX2Sz(Temp.num,:)=[];
      WaveForm.Ch.Text.dX2(Temp.num)=[];
      WaveForm.Ch.Text.dX1Sz(Temp.num,:)=[];
      WaveForm.Ch.Text.dX1(Temp.num)=[];
      
      WaveForm.Ch.CheckBox.FixSz(Temp.num,:)=[];
      WaveForm.Ch.CheckBox.Fix(Temp.num)=[];
      
      WaveForm.Ch.AxesSz(Temp.num,:)=[];
      WaveForm.Ch.Axes(Temp.num)=[];
      
      WaveForm.Ch.Plot(Temp.num,:)=[];
      
      WaveForm.Ch.Cursor(Temp.num,:)=[];
      WaveForm.Ch.Button.FSz(Temp.num,:)=[];
 	   WaveForm.Ch.Button.F(Temp.num)=[];
      
      if Stripchart.Head.Help.DataType~=1
	      WaveForm.Ch.Button.ViewSz(Temp.num,:)=[];
   	   WaveForm.Ch.Button.View(Temp.num)=[];
      end	
      
      %Special
      if strcmp('uimenu',get(gcbo,'type'))
         %You deleted from Menu
         num=Temp.num;
         WaveForm.Ch.Current_ch(num)=[];
         WaveForm.Ch.PlotData=WaveForm.Ch.PlotData(1:(num(1)-1));
         set(WaveForm.Figure,'userdata',WaveForm);
      else
         %You deleted from Button
         num=str2num(get(gco,'tag'));
         WaveForm.Ch.Current_ch(num)=[];
         
         Keep=1:(WaveForm.axises+1);
         Keep(num)=[];
         
         WaveForm.Ch.PlotData=WaveForm.Ch.PlotData(Keep);
         set(WaveForm.Figure,'userdata',WaveForm);
         Temp.Fix(num)=[];
         %[num WaveForm.axises]
         if num<=WaveForm.axises;
            %if you didn't delete the last one
            Zeng_WaveForm('Update WaveForm',WaveForm.Figure,num:WaveForm.axises);
            for i=num:WaveForm.axises
               set(WaveForm.Ch.CheckBox.Fix(i),'value',Temp.Fix(i));
            end
         end
      end
      Temp.Conduction=findobj(0,'tag','Conduction','color',WaveForm.Color,'name',[Stripchart.Head.FileName ':' 'Conduction']);
      if ~isempty(Temp.Conduction)
         for i=1:length(Temp.Conduction)
            Zeng_Conduction('Refresh Axes',Temp.Conduction(i),Temp.Ch.Current_ch(num),[])
         end
         
      end
          
      Zeng_WaveForm('ResizeFcn');
      delete(Temp.Obj);
 
 %NOTE THAT THERE IS A MISPELLING WITH WAVEFORM.AXISES 10/14/2020. Used to say WaveForm.axises     
	  set(WaveForm.Ch.Axes(WaveForm.axises),'XColor',[0 0 0],'XTickMode','auto','XTickLabelMode','auto','xlim',get(WaveForm.Ch.Axes(WaveForm.axes),'xlim'));
      TempObjVar=findobj(WaveForm.Menu.Setting,'tag','AxesNumber'); % FIX FOR CHILDREN 03152016
      set(get(TempObjVar(end),'children'),'checked','off');         % FIX FOR CHILDREN 03152016
%       Menu_axes=max(findobj(WaveForm.Menu.Setting,'tag','AxesNumber')); % May have to change this to a length instead of max for Matlab02014+
%       set(get(Menu_axes,'children'),'checked','off');
%       set(findobj(Menu_axes,'tag',num2str(WaveForm.axises)),'checked','on');
   set(gcbo,'checked','on');
      drawnow
   else
      Zeng_Error('One channel is low enough !!!');
   end
   
   
case 'Setting Axes'
   WaveForm=get(gcbf,'userdata');
   Temp.num=str2num(get(gcbo,'tag'));
   Temp.Delta=WaveForm.axises-Temp.num;

   TempObjVar=findobj(WaveForm.Menu.Setting,'tag','AxesNumber'); % FIX FOR CHILDREN 03152016
   set(get(TempObjVar(end),'children'),'checked','off');         % FIX FOR CHILDREN 03152016
%    set(get(max(findobj(WaveForm.Menu.Setting,'tag','AxesNumber')),'children'),'checked','off'); % ORIGINAL
   set(gcbo,'checked','on');
   if Temp.Delta>0      
      Zeng_WaveForm('Del Ch',Temp.Delta);
   elseif Temp.Delta<0
      set(WaveForm.Ch.Axes(WaveForm.axises),'XColor',[1 1 1]);      
      WaveForm.axises=Temp.num;
      set(WaveForm.Figure,'userdata',WaveForm);
      Zeng_WaveForm('Ch Creation',WaveForm.Figure,(Temp.num+Temp.Delta+1):Temp.num,min(max(WaveForm.ChLabel(:,1)),[max(WaveForm.Ch.Current_ch)+1:max(WaveForm.Ch.Current_ch)-Temp.Delta]),get(WaveForm.Ch.Axes(1),'xlim'))
      Zeng_WaveForm('ResizeFcn');
   end
   
case 'View'
   %2='Tag' of the line
   num=floor(str2num(get(gcbo,'tag'))/10);
   WaveForm=get(gcbf,'userdata');
   switch varargin{2}
   case 'M'
      if btnstate(WaveForm.Figure,['V' num2str(num)],num2str(num*10+1))
         set(WaveForm.Ch.Plot(num,1),'visible','on');
      else
         Temp=findobj(WaveForm.Ch.Plot(num,2:length(WaveForm.Ch.Plot(num,:))),'visible','on');
         set(Temp,'visible','off');
         set(WaveForm.Ch.Plot(num,1),'visible','off');
         set(Temp,'visible','on');
      end
      
   otherwise
      TheOne=findobj(WaveForm.Ch.Plot(num,:),'tag',varargin{2});
      switch varargin{2}
      case 'M1'
         Step=2;
      case 'M2'
         Step=3;
      end
      
      if btnstate(WaveForm.Figure,['V' num2str(num)],num2str(num*10+Step))
         %2=Stripchart.Figure 3=Line 4=Ch Num 5=Mono1-2 
         Mono=get(TheOne,'userdata');
         Zeng_Stripchart('Plot Mono',WaveForm.Parent,TheOne,WaveForm.Ch.Current_ch(num),Mono,WaveForm.Ch.Gain(num,Mono+1),WaveForm.Ch.Offset(num,Mono+1))   
      else
         Temp=WaveForm.Ch.Plot(num,:);
         Temp(find(Temp==TheOne))=[];
         Temp=findobj(Temp,'visible','on');
         set(Temp,'visible','off');
         set(TheOne,'visible','off');
         set(Temp,'visible','on');
      end
   end
   %================================================================
case 'Data Type Return Y'
   %old   %2=Stripchart.Figure 3=X 4=Ch 5=num of axis
   %new   %2=WaveForm.Figure 3=X 4=Ch 5=num of axis
   WaveForm=get(varargin{2},'userdata');
   Stripchart=get(WaveForm.Parent,'userdata');
   index=find(Stripchart.ChLabel(:,1)==varargin{4});
   if isempty(findobj(gcbf,'tag','V1'))
      varargout{1}=WaveForm.Ch.PlotData{varargin{5}}(1,varargin{3});
      
   else
      num=varargin{5};
      if ~isempty(findobj(WaveForm.Ch.Axes(num),'tag','M','type','line','visible','on'))
         %varargout(1)={[Data{varargin{2}}(Stripchart.ChLabel(index,2),varargin{3})-Data{varargin{2}}(Stripchart.ChLabel(index,3),varargin{3})]};
         varargout{1}=WaveForm.Ch.PlotData{varargin{5}}(1,varargin{3});
      elseif ~isempty(findobj(WaveForm.Ch.Axes(num),'tag','M1','type','line','visible','on'))
         %varargout(1)={Data{varargin{2}}(Stripchart.ChLabel(index,2),varargin{3})};
         varargout{1}=WaveForm.Ch.PlotData{varargin{5}}(2,varargin{3});
      
      elseif ~isempty(findobj(WaveForm.Ch.Axes(num),'tag','M2','type','line','visible','on'))
         %varargout(1)={Data{varargin{2}}(Stripchart.ChLabel(index,3),varargin{3})};
         varargout{1}=WaveForm.Ch.PlotData{varargin{5}}(3,varargin{3});
      else
         varargout{1}={0};
      end
   end  
   
case 'Call Cursor'
   if nargin==3
      %from button itself
      %1)'Call Cursor 2)Cursor 3)WaveForm.Figure
      num=str2num(get(gcbo,'tag'));
   elseif nargin==4 
      %from unit setting
      %Move
      %1)'Call Cursor' 2)Cursor 3)WaveForm.Figure 4)num
      num=varargin{4};
   else
      a='Zeng, there is an error in Call cursor';
   end
   %If nargin~=3, I won't reset the cursor position
   Cursor=varargin{2};
   
   WaveForm=get(varargin{3},'userdata');
   Temp=[];
   Temp.CVT=Zeng_Stripchart('Unit Convert',WaveForm.Parent);
   if btnstate(WaveForm.Figure,['L' num2str((num-1)*2+Cursor)],num2str(num))
      %'Button down'
      Current_Point=get(WaveForm.Ch.Cursor(num,Cursor),'xdata');
      Current_Axis=get(WaveForm.Ch.Axes(num),'xlim');
      if nargin~=3 || (Current_Point(1)>Current_Axis(1) && Current_Point(1)<Current_Axis(2))
         
      else
         %to .33 for Cursor1 and .66 for Cursor2
         Current_Point(:)=Current_Axis(1)+(Current_Axis(2)-Current_Axis(1))*.33*(Cursor);
      end
      set(WaveForm.Ch.Cursor(num,Cursor),'visible','on','xdata',Current_Point)
      %Set Global first for more beauty
      if btnstate(WaveForm.Figure,'G','1')
         %For update WaveForm purpose
         set(WaveForm.Ch.Cursor(num,[3]),'visible','on')
         set(eval(['WaveForm.Ch.Text.dX' num2str(Cursor) '(' num2str(num) ')']),'visible','on','string',['dx' num2str(Cursor) ': ' num2str(round(Temp.CVT*(Current_Point(1)-max(get(WaveForm.Ch.Cursor(num,3),'xdata')))))])
         if nargin==5 && btnstate(WaveForm.Figure,['L' num2str((num)*2+1-Cursor)],num2str(num))
            Current_Point=get(WaveForm.Ch.Cursor(num,(3-Cursor)),'xdata');
            set(eval(['WaveForm.Ch.Text.dX' num2str(3-Cursor) '(' num2str(num) ')']),'visible','on','string',['dx' num2str(3-Cursor) ': ' num2str(round(Temp.CVT*(Current_Point(1)-max(get(WaveForm.Ch.Cursor(num,3),'xdata')))))])
         end
      end
      
      if btnstate(WaveForm.Figure,['L' num2str((num-1)*2+1)],num2str(num)) && btnstate(WaveForm.Figure,['L' num2str((num-1)*2+2)],num2str(num))
         %Down both
         %For update WaveForm purpose
         set(WaveForm.Ch.Cursor(num,[1 2]),'visible','on')
         if Cursor==1% | nargin~=3
            set(WaveForm.Ch.Text.X2(num),'visible','on','string',['dx: ' num2str(round(Temp.CVT*(max(get(WaveForm.Ch.Cursor(num,2),'xdata'))-Current_Point(1))))])
            Temp.Y2=Zeng_WaveForm('Data Type Return Y',WaveForm.Figure,round(max(get(WaveForm.Ch.Cursor(num,2),'xdata'))),WaveForm.Ch.Current_ch(num),num);
            Temp.Y1=Zeng_WaveForm('Data Type Return Y',WaveForm.Figure,round(Current_Point(1)),WaveForm.Ch.Current_ch(num),num);
            set(WaveForm.Ch.Text.Y2(num),'visible','on','string',['dy: ' num2str(round(Temp.Y2-Temp.Y1))])
         end
         if Cursor==2% | nargin~=3
            set(WaveForm.Ch.Text.X2(num),'visible','on','string',['dx: ' num2str(round(Temp.CVT*(Current_Point(1)-max(get(WaveForm.Ch.Cursor(num,1),'xdata')))))])
            Temp.Y2=Zeng_WaveForm('Data Type Return Y',WaveForm.Figure,round(Current_Point(1)),WaveForm.Ch.Current_ch(num),num);
            Temp.Y1=Zeng_WaveForm('Data Type Return Y',WaveForm.Figure,round(max(get(WaveForm.Ch.Cursor(num,1),'xdata'))),WaveForm.Ch.Current_ch(num),num);
            set(WaveForm.Ch.Text.Y2(num),'visible','on','string',['dy: ' num2str(round(Temp.Y2-Temp.Y1))])
         end
      else
         %Down only one cursor
         set(WaveForm.Ch.Text.X2(num),'visible','on','string',['x: ' num2str(round(Temp.CVT*Current_Point(1)))])
         Temp.Y=Zeng_WaveForm('Data Type Return Y',WaveForm.Figure,round(Current_Point(1)),WaveForm.Ch.Current_ch(num),num);
         set(WaveForm.Ch.Text.Y2(num),'visible','on','string',['y: ' num2str(round(Temp.Y))])

      end
   else
      %Button UP
      set(WaveForm.Ch.Cursor(num,Cursor),'visible','off')
      if btnstate(WaveForm.Figure,['L' num2str((num)*2-Cursor+1)],num2str(num))
         %the other is down
         Current_Point=get(WaveForm.Ch.Cursor(num,3-Cursor),'xdata');
         set(WaveForm.Ch.Text.X2(num),'visible','on','string',['x: ' num2str(round(Temp.CVT*Current_Point(1)))])
         Temp.Y=Zeng_WaveForm('Data Type Return Y',WaveForm.Figure,round(Current_Point(1)),WaveForm.Ch.Current_ch(num),num);
         set(WaveForm.Ch.Text.Y2(num),'visible','on','string',['y: ' num2str(round(Temp.Y))])
      else
         set(WaveForm.Ch.Text.X2(num),'visible','off')
         set(WaveForm.Ch.Text.Y2(num),'visible','off')
      end
      set(eval(['WaveForm.Ch.Text.dX' num2str(Cursor) '(' num2str(num) ')']),'visible','off')
   end
   %================================================================
case 'Call Global'		   
   WaveForm=get(gcbf,'userdata');
   if btnstate(gcbf,'G','1')
     %Button down
      Temp.CVT=Zeng_Stripchart('Unit Convert',WaveForm.Parent);
      Current_Point=get(WaveForm.Ch.Cursor(1,3),'xdata');
      Current_Axis=get(WaveForm.Ch.Axes(1),'xlim');
      %WaveForm.Ch.Cursor(num,Cursor)      
      if Current_Point(1)>Current_Axis(1) & Current_Point(1)<Current_Axis(2)
         
      else
         %to .33 for Cursor1 and .66 for Cursor2
         Current_Point(:)=Current_Axis(1)+(Current_Axis(2)-Current_Axis(1))*.5;
      end
   	set(WaveForm.Ch.Cursor(:,3),'visible','on','xdata',Current_Point)
      for num=1:WaveForm.axises
   		if btnstate(gcbf,['L' num2str((num-1)*2+1)],num2str(num))
         	set(WaveForm.Ch.Text.dX1(num),'visible','on','string',['dx1: ' num2str(round(Temp.CVT*(max(get(WaveForm.Ch.Cursor(num,1),'xdata')-Current_Point(1)))))])
         end
   		if btnstate(gcbf,['L' num2str((num-1)*2+2)],num2str(num))
            set(WaveForm.Ch.Text.dX2(num),'visible','on','string',['dx2: ' num2str(round(Temp.CVT*(max(get(WaveForm.Ch.Cursor(num,2),'xdata')-Current_Point(1)))))])
         end
      end
   else
   	set(WaveForm.Ch.Cursor(:,3),'visible','off')
      set(WaveForm.Ch.Text.dX1,'visible','off')
      set(WaveForm.Ch.Text.dX2,'visible','off')
   end
 %================================================================
case 'DeleteFcn'   
   WaveForm=get(gcbf,'userdata');
   if isempty(get(0,'children')==WaveForm.Parent);
   	%You close stripchart   
   else
      %You close itself.
      Stripchart=get(WaveForm.Parent,'userdata');
    	num=find(Stripchart.WaveForm.Figure==WaveForm.Figure);
      Stripchart.WaveForm.Figure(num)=[];
      set(Stripchart.Figure,'userdata',Stripchart);
   end
FG_Size=get(WaveForm.Figure,'position');
WaveformParams.FG_Size=FG_Size;
save WaveformParams WaveformParams
   %================================================================
%======================================   
case 'One Increase'
   WaveForm=get(gcbf,'userdata');
   %---------------
   Temp.UD=get(WaveForm.Button.ChnlChanging_Grp,'userdata');
   Temp.UD.callbacks=[' ';' ';' ';' '];
   set(WaveForm.Button.ChnlChanging_Grp,'userdata',Temp.UD);
   %---------------
   Stripchart=get(WaveForm.Parent,'userdata');
   num=ceil(str2num(get(gcbo,'tag'))/2);
   if WaveForm.Ch.Current_ch(num) < max(WaveForm.ChLabel(:,1)) 
      WaveForm.Ch.Current_ch(num)=WaveForm.Ch.Current_ch(num)+1;
      set(WaveForm.Figure,'userdata',WaveForm);
      Zeng_WaveForm('Update WaveForm',WaveForm.Figure,num)
      Temp.Conduction=findobj(0,'tag','Conduction','color',WaveForm.Color,'name',[Stripchart.Head.FileName ':' 'Conduction']);
      if ~isempty(Temp.Conduction)
         Zeng_Conduction('Refresh Axes',Temp.Conduction,WaveForm.Ch.Current_ch(num)-1,WaveForm.Ch.Current_ch)
      end
      Temp=[];
   else
      Zeng_Error('This is already the last channel');
   end
   %================================================================
case 'Update WaveForm'
   WaveForm=get(varargin{2},'userdata');
   %Stripchart=get(WaveForm.Parent,'userdata');
   num = varargin{3};
   %delete([findobj(WaveForm.Ch.Axes(num),'tag','Annote')'  findobj(WaveForm.Ch.Axes(num),'tag','Label Annote')'])
   for i=1:length(num)
      set(WaveForm.Ch.Edit.Channel(num(i)),'string',WaveForm.Ch.Current_ch(num(i)));
      
      set(WaveForm.Ch.Cursor(num(i),:),'visible','off')
      delete([findobj(WaveForm.Ch.Axes(num(i)),'tag','Annote')'  findobj(WaveForm.Ch.Axes(num(i)),'tag','Label Annote')'])
      
      Temp.Bi=findobj(WaveForm.Figure,'tag','V1');
      if ~isempty(Temp.Bi)
         Temp.M1=findobj(WaveForm.Ch.Plot(num(i),:),'userdata',1,'visible','on');
         set(Temp.M1,'visible','off')
         
         Temp.M2=findobj(WaveForm.Ch.Plot(num(i),:),'userdata',2,'visible','on');
         set(Temp.M2,'visible','off')
      end
      
      Zeng_Stripchart('Data Type Plot',WaveForm.Parent,WaveForm.Ch.Plot(num(i),1),WaveForm.Ch.Current_ch(num(i)),1,WaveForm.Ch.Gain(num(i),1),WaveForm.Ch.Offset(num(i),1))   
      Zeng_WaveForm('Adjust Annote',WaveForm.Figure,num(i));
      if ~isempty(Temp.Bi)
         %Vnum = tag of W.Ch.Button.View , the axis of btngroup.
         for j=1:length(Temp.M1)
            Zeng_Stripchart('Plot Mono',WaveForm.Parent,Temp.M1(j),WaveForm.Ch.Current_ch(num(i)),1,WaveForm.Ch.Gain(num(i),2),WaveForm.Ch.Offset(num(i),2))   
         end
         for j=1:length(Temp.M2)
            Zeng_Stripchart('Plot Mono',WaveForm.Parent,Temp.M2(j),WaveForm.Ch.Current_ch(num(i)),2,WaveForm.Ch.Gain(num(i),3),WaveForm.Ch.Offset(num(i),3))   
         end
      end
      
      %I just need to set one of them. 
      %please do it when all the plot are visible
      if btnstate(WaveForm.Figure,['L' num2str((num(i)-1)*2+1)],num2str(num(i)))
         Zeng_WaveForm('Call Cursor',1,WaveForm.Figure,num(i))
      elseif btnstate(WaveForm.Figure,['L' num2str((num(i)-1)*2+2)],num2str(num(i)))
         Zeng_WaveForm('Call Cursor',2,WaveForm.Figure,num(i))
      elseif  btnstate(WaveForm.Figure,'G','1')
         set(WaveForm.Ch.Cursor(num(i),3),'visible','on')
      end 
      
   end
   %Annote adjustment
   %Zeng_WaveForm('Adjust Annote',WaveForm.Figure,num);
%   set(WaveForm.Figure,'Renderer','zbuffer','backingstore','off')
%   drawnow
   
   %---------------
   Temp.UD=get(WaveForm.Button.ChnlChanging_Grp,'userdata');
   Temp.UD.callbacks=WaveForm.Button.ChnlChanging_Grp_CBs;
   set(WaveForm.Button.ChnlChanging_Grp,'userdata',Temp.UD);
   %---------------
   %================================================================
case 'One Decrease'
   WaveForm=get(gcbf,'userdata');
   %---------------
   Temp.UD=get(WaveForm.Button.ChnlChanging_Grp,'userdata');
   Temp.UD.callbacks=[' ';' ';' ';' '];
   set(WaveForm.Button.ChnlChanging_Grp,'userdata',Temp.UD);
   %---------------
    Stripchart=get(WaveForm.Parent,'userdata');
    %num=number of axes you want to adjust
    num=ceil(str2num(get(gcbo,'tag'))/2);
    if WaveForm.Ch.Current_ch(num) > min(WaveForm.ChLabel(:,1)) 
       WaveForm.Ch.Current_ch(num)=WaveForm.Ch.Current_ch(num)-1;
       set(WaveForm.Figure,'userdata',WaveForm);
       Zeng_WaveForm('Update WaveForm',WaveForm.Figure,num);
       Temp.Conduction=findobj(0,'tag','Conduction','color',WaveForm.Color,'name',[Stripchart.Head.FileName ':' 'Conduction']);
       if ~isempty(Temp.Conduction)
          Zeng_Conduction('Refresh Axes',Temp.Conduction,WaveForm.Ch.Current_ch(num)+1,WaveForm.Ch.Current_ch)
       end
       Temp=[];
    else;
       Zeng_Error('This is already your first channel');
    end
 %================================================================
case 'Group Increase Ch 2'
   WaveForm=get(gcbf,'userdata');
      %---------------
   Temp.UD=get(WaveForm.Button.ChnlChanging_Grp,'userdata');
   Temp.UD.callbacks=[' ';' ';' ';' '];
   set(WaveForm.Button.ChnlChanging_Grp,'userdata',Temp.UD);
   %---------------

   Stripchart=get(WaveForm.Parent,'userdata');
   Current_Ch=[];
   for num=1:length(WaveForm.Ch.Edit.Channel)
      if ~get(WaveForm.Ch.CheckBox.Fix(num),'value')
         Current_Ch=[Current_Ch;[num  WaveForm.Ch.Current_ch(num)]];
      end
   end
   if max(Current_Ch(:,2))==max(WaveForm.ChLabel(:,1))
      Zeng_Error('You already reached the last channel');
      Temp.UD=get(WaveForm.Button.ChnlChanging_Grp,'userdata');
      Temp.UD.callbacks=WaveForm.Button.ChnlChanging_Grp_CBs;
      set(WaveForm.Button.ChnlChanging_Grp,'userdata',Temp.UD);
      
   else
      Temp.Off=WaveForm.Ch.Current_ch;
      Step=max(WaveForm.ChLabel(:,1))-max(Current_Ch(:,2));
      Temp.UpdateAxes=[];
      
      for num = 1:length(Current_Ch(:,1))
         if (WaveForm.Ch.Current_ch(Current_Ch(num,1))+Step) <= max(WaveForm.ChLabel(:,1))
            Temp.UpdateAxes=[Temp.UpdateAxes;Current_Ch(num,1)];
            WaveForm.Ch.Current_ch(Current_Ch(num,1))=WaveForm.Ch.Current_ch(Current_Ch(num,1))+Step;
         end;
      end
      set(WaveForm.Figure,'userdata',WaveForm);           
      Zeng_WaveForm('Update WaveForm',WaveForm.Figure,Temp.UpdateAxes);
      Temp.On=WaveForm.Ch.Current_ch;
      Temp.Conduction=findobj(0,'tag','Conduction','color',WaveForm.Color,'name',[Stripchart.Head.FileName ':' 'Conduction']);
      if ~isempty(Temp.Conduction)
         Zeng_Conduction('Refresh Axes',Temp.Conduction,Temp.Off,Temp.On)
      end
      Temp=[];
      
   end
   Current_Ch=[];
	%================================================================
case 'Group Increase Ch'
   WaveForm=get(gcbf,'userdata');
   %---------------
   Temp.UD=get(WaveForm.Button.ChnlChanging_Grp,'userdata');
   Temp.UD.callbacks=[' ';' ';' ';' '];
   set(WaveForm.Button.ChnlChanging_Grp,'userdata',Temp.UD);
   %---------------
   
   Stripchart=get(WaveForm.Parent,'userdata');
   Temp.Off=WaveForm.Ch.Current_ch;
   Step=length(findobj(WaveForm.Ch.CheckBox.Fix,'value',0));
   Temp.UpdateAxes=[];
   for num = 1: WaveForm.axises
      if (WaveForm.Ch.Current_ch(num)+Step) <= max(WaveForm.ChLabel(:,1)) & ~get(WaveForm.Ch.CheckBox.Fix(num),'value')
         WaveForm.Ch.Current_ch(num)=WaveForm.Ch.Current_ch(num)+Step;
         Temp.UpdateAxes=[Temp.UpdateAxes;num];
      end;
   end
   set(WaveForm.Figure,'userdata',WaveForm);           
   Zeng_WaveForm('Update WaveForm',WaveForm.Figure,Temp.UpdateAxes);
   Temp.On=WaveForm.Ch.Current_ch;
   Temp.Conduction=findobj(0,'tag','Conduction','color',WaveForm.Color,'name',[Stripchart.Head.FileName ':' 'Conduction']);
   if ~isempty(Temp.Conduction)
      Zeng_Conduction('Refresh Axes',Temp.Conduction,Temp.Off,Temp.On)
   end
   Temp=[];
   %================================================================
case 'Group Decrease Ch'
   WaveForm=get(gcbf,'userdata');
   %---------------
   Temp.UD=get(WaveForm.Button.ChnlChanging_Grp,'userdata');
   Temp.UD.callbacks=[' ';' ';' ';' '];
   set(WaveForm.Button.ChnlChanging_Grp,'userdata',Temp.UD);
   %---------------
   Stripchart=get(WaveForm.Parent,'userdata');
   Step=length(findobj(WaveForm.Ch.CheckBox.Fix,'value',0));
   Updategraph=0;
   Temp.UpdateAxes=[];
   Temp.Off=WaveForm.Ch.Current_ch;
   for num = 1: WaveForm.axises
      if (WaveForm.Ch.Current_ch(num)-Step) >=min(WaveForm.ChLabel(:,1)) & ~get(WaveForm.Ch.CheckBox.Fix(num),'value')
         Updategraph=Updategraph+1;
         WaveForm.Ch.Current_ch(num)=WaveForm.Ch.Current_ch(num)-Step;
         Temp.UpdateAxes=[Temp.UpdateAxes;num];
      end; %if (WaveForm.Ch.Current_ch(num)-Step) >=1 & ~get(WaveForm.Ch.CheckBox.Fix(num),'value')
   end %                     for num = 1: WaveForm.axises
   set(WaveForm.Figure,'userdata',WaveForm);           
   Zeng_WaveForm('Update WaveForm',WaveForm.Figure,Temp.UpdateAxes);
   Temp.On=WaveForm.Ch.Current_ch;
   Temp.Conduction=findobj(0,'tag','Conduction','color',WaveForm.Color,'name',[Stripchart.Head.FileName ':' 'Conduction']);
   if ~isempty(Temp.Conduction)
      Zeng_Conduction('Refresh Axes',Temp.Conduction,Temp.Off,Temp.On)
   end
   %================================================================
case 'Group Decrease Ch 2'
   WaveForm=get(gcbf,'userdata');
   %---------------
   Temp.UD=get(WaveForm.Button.ChnlChanging_Grp,'userdata');
   Temp.UD.callbacks=[' ';' ';' ';' '];
   set(WaveForm.Button.ChnlChanging_Grp,'userdata',Temp.UD);
   %---------------
   Stripchart=get(WaveForm.Parent,'userdata');
   Current_Ch=[];
   for num=1:length(WaveForm.Ch.Edit.Channel)
      if ~get(WaveForm.Ch.CheckBox.Fix(num),'value')
         Current_Ch=[Current_Ch;[num  WaveForm.Ch.Current_ch(num)]];
      end
   end
   if min(Current_Ch(:,2))==min(WaveForm.ChLabel(:,1))
      Zeng_Error('You already reached the first channel');
      Temp.UD=get(WaveForm.Button.ChnlChanging_Grp,'userdata');
      Temp.UD.callbacks=WaveForm.Button.ChnlChanging_Grp_CBs;
      set(WaveForm.Button.ChnlChanging_Grp,'userdata',Temp.UD);
      
   else
      Step=min(Current_Ch(:,2))-min(WaveForm.ChLabel(:,1));
      Temp.Off=WaveForm.Ch.Current_ch;
      Temp.UpdateAxes=[];
      Updategraph=0;
      for num = 1:length(Current_Ch(:,1))
         if (WaveForm.Ch.Current_ch(Current_Ch(num,1))-Step) >=min(WaveForm.ChLabel(:,1))
            Updategraph=Updategraph+1;
            Temp.UpdateAxes=[Temp.UpdateAxes;Current_Ch(num,1)];
            WaveForm.Ch.Current_ch(Current_Ch(num,1))=WaveForm.Ch.Current_ch(Current_Ch(num,1))-Step;
         end;
      end
      set(WaveForm.Figure,'userdata',WaveForm);           
      Zeng_WaveForm('Update WaveForm',WaveForm.Figure,Temp.UpdateAxes);
      Temp.On=WaveForm.Ch.Current_ch;
      Temp.Conduction=findobj(0,'tag','Conduction','color',WaveForm.Color,'name',[Stripchart.Head.FileName ':' 'Conduction']);
      if ~isempty(Temp.Conduction)
         Zeng_Conduction('Refresh Axes',Temp.Conduction,Temp.Off,Temp.On)
      end
      Temp=[];
      if Updategraph==0;
         Zeng_Error('Which channels do you want to change?');
      end;
   end
	%===============================================================
case 'ResizeFcn'
   if nargin==1
      %From itself
      WaveForm=get(gcbf,'userdata');
   elseif nargin==2
      %From "Font-setting" from somewhere else
      WaveForm=get(varargin{2},'userdata');
   end
 	%Stripchart=get(WaveForm.Parent,'userdata');
   FG_Size=get(WaveForm.Figure,'position');  %Figure Size
   FG_Size(3)=max(FG_Size(3),Log.UD.HD.WaveForm.FG_Limit(1));
   FG_Size(4)=max(FG_Size(4),Log.UD.HD.WaveForm.FG_Limit(2));

   set(WaveForm.Button.CursorCallGlobal,'Position',[FG_Size(3)-20 1 15 15]);
   set(WaveForm.Text.Cursor,'Position',[FG_Size(3)-Log.UD.Ref.Ch_Box(1) FG_Size(4)-Log.UD.Ref.Ch_Box(2) Log.UD.Ref.Ch_Box]);
   WaveForm.Ref.AxisPostion=[Log.UD.Ref.Ch_Box(1)*2.2 Log.UD.Ref.Ch_Box(2) FG_Size(3)-35-Log.UD.Ref.Ch_Box(1)*2.2 (FG_Size(4)-Log.UD.Ref.Ch_Box(2))];
   set(WaveForm.Figure,'userdata',WaveForm);
   Temp.Edit.ChannelSz([1 3 4])=[WaveForm.Ch.Edit.ChannelSz(1) Log.UD.Ref.Ch_Box];
   for num = 1: WaveForm.axises
      AxesSz=[WaveForm.Ref.AxisPostion(1) sum(WaveForm.Ref.AxisPostion([2 4]))-num*WaveForm.Ref.AxisPostion(4)/WaveForm.axises WaveForm.Ref.AxisPostion(3) WaveForm.Ref.AxisPostion(4)/WaveForm.axises]; %   (4) 6= base 24= space betw axes
      Temp.Edit.ChannelSz(2)=AxesSz(2)+30;
      
      set(WaveForm.Ch.Axes(num),'Position',AxesSz);
      set(WaveForm.Ch.Edit.Channel(num),'Position',[Temp.Edit.ChannelSz]);
      
      set(WaveForm.Ch.Button.F(num),'position',[33 Temp.Edit.ChannelSz(2)-31 30 15 ]);
      if ~isempty(findobj(WaveForm.Figure,'tag','V1'));
         set(WaveForm.Ch.Button.View(num),'position',[33 Temp.Edit.ChannelSz(2)-16 45 15 ]);
         
      end 
      set(WaveForm.Ch.Button.ChnlChanging(num),'Position',[sum(Temp.Edit.ChannelSz([1 3]))+1 Temp.Edit.ChannelSz(2) 16 Temp.Edit.ChannelSz(4)]);
      set(WaveForm.Ch.CheckBox.Fix(num),'Position',[1 Temp.Edit.ChannelSz(2) 20 20]);
      set(WaveForm.Ch.Cursor(num,:),'ydata',[nan nan]);
      set(WaveForm.Ch.Cursor(num,:),'ydata',get(WaveForm.Ch.Axes(num),'ylim'));
      set(WaveForm.Ch.Button.Del(num),'position',[1 Temp.Edit.ChannelSz(2)-16 30 15 ]);
      set(WaveForm.Ch.Text.Y2(num),'Position',[AxesSz(1)+Log.UD.Ref.Time_Box(1) AxesSz(2)+1  Log.UD.Ref.Time_Box]);
      set(WaveForm.Ch.Text.X2(num),'Position',[AxesSz(1)+1 AxesSz(2)+1  Log.UD.Ref.Time_Box]);
      set(WaveForm.Ch.Text.dX1(num),'Position',[AxesSz(1)+AxesSz(3)-Log.UD.Ref.Time_Box(1)*2 AxesSz(2)+1  Log.UD.Ref.Time_Box]);
      set(WaveForm.Ch.Text.dX2(num),'Position',[AxesSz(1)+AxesSz(3)-Log.UD.Ref.Time_Box(1)   AxesSz(2)+1  Log.UD.Ref.Time_Box]);
      set(WaveForm.Ch.Button.CursorCall(num,1),'Position',[15+WaveForm.Ref.AxisPostion(1)+WaveForm.Ref.AxisPostion(3) AxesSz(2)+30 15 15 ])
      set(WaveForm.Ch.Button.CursorCall(num,2),'Position',[15+WaveForm.Ref.AxisPostion(1)+WaveForm.Ref.AxisPostion(3) AxesSz(2)+15 15 15 ])
      set(WaveForm.Ch.Button.ShowMe(num),'Position', [AxesSz(1)-83 AxesSz(2)+50 50 15 ]);
      
      
WaveformParams.FG_Size=FG_Size;
save WaveformParams WaveformParams
      
      if ~isempty(findobj(WaveForm.Figure,'tag','Z1'));
         set(WaveForm.Ch.Button.AxesZoom(num),'position',[WaveForm.Ref.AxisPostion(1)+WaveForm.Ref.AxisPostion(3) AxesSz(2)+15 15 60 ]);
      end 
         
   end % for i=1:4
   set(WaveForm.Text.Channel_Label,'Position',[1 FG_Size(4)-Log.UD.Ref.Ch_Box(2) WaveForm.Ref.AxisPostion(1)-2 Log.UD.Ref.Ch_Box(2)]);

   Zeng_WaveForm('Adjust Annote',WaveForm.Figure,1:WaveForm.axises);
   %================================================================
case 'Add Annote'
      WaveForm=get(gcbf,'userdata');
      Stripchart=get(WaveForm.Parent,'userdata');
      Temp.EditAnnote=findobj(0,'name',[Stripchart.Head.FileName ':Edit Annote']);
      if ~isempty(Temp.EditAnnote) & btnstate(Temp.EditAnnote,'AddDel','B1');
         Temp.EditAnnote=get(Temp.EditAnnote,'userdata');
         Temp.Show =get(Temp.EditAnnote.ListBox.Show,'string');
         Temp.Current_File=get(Temp.EditAnnote.ListBox.Show,'value');
         if Temp.Current_File>0 & iscell(Temp.Show) &length(Temp.Show)>0;
            Temp.Letters=Temp.Show{Temp.Current_File};
            Temp.Letters=Temp.Letters(11:10+Stripchart.Annote.ShowLength);%Blanks(10)
            Temp.Ptr=getptr(gcbf);
            if strcmp('arrow',Temp.Ptr{2});
                Current_Point=round(get(gca,'currentpoint'));
                Temp.Line=line(...
                   'parent',gca,... 
                   'Color',[.5 .5 .5],...                 
                   'EraseMode','xor',...						 'EraseMode','background',...
                   'LineStyle','-',...
                   'LineWidth',Log.UD.Ref.ThinLine,...
                   'Marker','none',...
                   'MarkerEdgeColor','auto',...
                   'MarkerFaceColor','none',...
                   'MarkerSize',[6],...
                   'tag','Annote',...               'userdata',['**' num2str(Temp.Num)],...
                   'visible','on',...               
                   'XData',[(Current_Point(1,1))*ones(1,2)],...               'xdata',[nan nan],...
                   'YData',get(gca,'ylim'));
                Temp.Label= text(...              
                   'EraseMode','xor',...						 'EraseMode','background',...
                   'FontName','Arial',...
                   'FontUnits','points',...
                   'FontSize',Log.UD.Ref.FontSize,...
                   'FontWeight','normal',...
                   'FontAngle','normal',...
                   'position',[Current_Point(1,1)+diff(get(gca,'xlim'))/100,WaveForm.Ant_Label_Y],...
                   'string',Temp.Letters,...
                   'tag','Label Annote');  
                set(Temp.Line,'userdata',Temp.Label);
                set(Temp.Label,'userdata',Temp.Line);
                Stripchart.Annote.Array=[Stripchart.Annote.Array; str2num(get(WaveForm.Ch.Edit.Channel(str2num(get(gca,'tag'))),'string')) Current_Point(1,1) Temp.Letters+0 ];
                set(Stripchart.Figure,'userdata',Stripchart);
                Zeng_WaveForm('Update Annote');
                if get(Temp.EditAnnote.Opt.Show,'value')
                   set(Temp.EditAnnote.Opt.Show,'value',0)
                   Zeng_Annote('Update Show',Temp.EditAnnote.Figure)
                end
             end %          if strcmp('arrow',Temp.Ptr{2});
          else
             Zeng_Share('Error','Polite','You Have to create an new annote first before adding');
             
          end %  if ~isempty(Temp.Show(Temp.Current_File))
       end % if ~isempty(Temp.EditAnnote)
           
%--------------------------------------------------------------------------------
case 'Axes Setting'   
   WaveForm=get(gcbf,'userdata');
   prompt={'the axes number:'};
   def={num2str(WaveForm.axises)};
   title='the axes number setting';
   lineNo=1;
   answer=inputdlg(prompt,title,lineNo,def);
   if ~isempty(answer)
      answer=str2num(answer{1});
	   if isempty(answer)
	      Zeng_Error('Don''t you like a number !!! ?');
	   elseif  ceil(answer)~=fix(answer) 
   	   Zeng_Error('Don''t you like an integer !!! ?');
	   elseif answer<1
         Zeng_Error('How many graphs do you want ??....Less than 1?');
      elseif length(answer)>1
         Zeng_Error('I just need one number !!!');
      elseif answer>=9
         Zeng_Error('Let use a projector with this amount !!!');
      else
            WaveForm.axises=answer;
            Stripchart=get(WaveForm.Parent,'userdata');
            set(gcbf,'userdata',WaveForm);
            Zeng_WaveForm('Initial','From axis setting');
            WaveForm=get(gcbf,'userdata');
            Zeng_WaveForm('Adjust Annote',WaveForm.Figure,1:length(WaveForm.Ch.Axes));
      end
   end
%================================================================
case 'Mouse Move'
   if strcmp('WaveForm',get(gcbf,'tag'))
      %To check if the current object is a waveform window
      WaveForm=get(gcbf,'userdata');
      Current_Point=round(get(gcbf,'currentpoint'));
      if Current_Point(1,1)>WaveForm.Ref.AxisPostion(1) & Current_Point(1,1)<WaveForm.Ref.AxisPostion(1)+WaveForm.Ref.AxisPostion(3) & Current_Point(1,2)>WaveForm.Ref.AxisPostion(2) & Current_Point(1,2)<WaveForm.Ref.AxisPostion(2)+WaveForm.Ref.AxisPostion(4)
         index=(WaveForm.axises+1)-ceil(  (Current_Point(1,2)-WaveForm.Ref.AxisPostion(2))/WaveForm.Ref.AxisPostion(4)*WaveForm.axises  );
         Current_Point=round(get(WaveForm.Ch.Axes(index),'currentpoint'));
         if WaveForm.Move.Status==0;
            Current_Axis=[get(WaveForm.Ch.Axes(index),'xlim') get(WaveForm.Ch.Axes(index),'ylim')];
            %get xdata cursor twise
            %1=for the first cursor
            if strcmp('on',get(WaveForm.Ch.Cursor(index,1),'visible'))
               Cursor_Point=[round(get(WaveForm.Ch.Cursor(index,1),'xdata'))];
            else
               Cursor_Point=[nan nan];
            end
            %2=for the second cursor
            if strcmp('on',get(WaveForm.Ch.Cursor(index,2),'visible'))
               Cursor_Point=[Cursor_Point;round(get(WaveForm.Ch.Cursor(index,2),'xdata'))];
            else
               Cursor_Point=[Cursor_Point;nan nan];
            end
            %3=for the global
            if strcmp('on',get(WaveForm.Ch.Cursor(index,3),'visible'))
	            Cursor_Point=[Cursor_Point;round(get(WaveForm.Ch.Cursor(index,3),'xdata'))];
            else
               Cursor_Point=[Cursor_Point;nan nan];
            end
            %4->N =for annote
            Temp.Annote=[findobj(WaveForm.Ch.Axes(index),'tag','Annote')']'; 
            if ~isempty(Temp.Annote);
               for i=1:length(Temp.Annote);
                  Cursor_Point=[Cursor_Point;round(get(Temp.Annote(i),'xdata'))];
               end
            else
               Cursor_Point=[Cursor_Point;nan nan];
            end
            Temp.Range=(Current_Axis(2)-Current_Axis(1))/100;
            if abs(Current_Point(1,1)-Cursor_Point(3,1))< Temp.Range
               %global
               if WaveForm.Move.Current_Pointer~=4;
                  Temp.SetData=setptr('hand');
                  Temp.a=Temp.SetData{4};
                  Temp.a(8:14,8:11)=[  2   1   1   1   ;
                                       1   2   2   1   ;
                                       1   2   2   2   ;
                                       1   2   1   1   ;
                                       1   2   2   1   ;
                                       1   2   2   1   ;
                                       2   1   1   1   ];
                  Temp.SetData{4}=Temp.a;
                  set(gcbf,Temp.SetData{:})
                  WaveForm.Move.Current_Pointer=4;
               end
            elseif abs(Current_Point(1,1)-Cursor_Point(1,1))< Temp.Range
               %Left cursor
               if WaveForm.Move.Current_Pointer~=1;
                  Temp.SetData=setptr('hand1');set(gcbf,Temp.SetData{:})
                  WaveForm.Move.Current_Pointer=1;
               end
            elseif abs(Current_Point(1,1)-Cursor_Point(2,1))< Temp.Range
               %Right cursor
               if WaveForm.Move.Current_Pointer~=2;
                  Temp.SetData=setptr('hand2');set(gcbf,Temp.SetData{:})
                  WaveForm.Move.Current_Pointer=2;
               end
            elseif length(Cursor_Point(:,1))>3 & sum(abs(Current_Point(1,1)-Cursor_Point(4:length(Cursor_Point(:,1)),1))< Temp.Range)
               %Annote
               % its position must be before "both"
               if WaveForm.Move.Current_Pointer~=5;
                  Temp.SetData=setptr('hand');
                  Temp.Inside=Temp.SetData{4};
                  Temp.Inside(8:14,8:11)=[  2   1   1   2   ;
                                            1   2   2   1   ;
                                            1   2   2   1   ;
                                            1   2   2   1   ;
                                            1   1   1   1   ;
                                            1   2   2   1   ;
                                            1   2   2   1   ];
                  Temp.SetData{4}=Temp.Inside;
                  set(gcbf,Temp.SetData{:})
                  WaveForm.Move.Current_Pointer=5;
               end
            elseif Current_Point(1,1)> Cursor_Point(1,1)+Temp.Range & Current_Point(1,1)< Cursor_Point(2,1)-Temp.Range
               %Both cursor
               if WaveForm.Move.Current_Pointer~=3;
                  Temp.SetData=setptr('hand');set(gcbf,Temp.SetData{:})
                  WaveForm.Move.Current_Pointer=3;
               end
            elseif Current_Point(1,1)< Cursor_Point(1,1)- Temp.Range & Current_Point(1,1)> Cursor_Point(2,1)+Temp.Range
               %Both cursor
               if WaveForm.Move.Current_Pointer~=3;
                  Temp.SetData=setptr('hand');set(gcbf,Temp.SetData{:})
                  WaveForm.Move.Current_Pointer=3;
               end
            else
               if WaveForm.Move.Current_Pointer~=0;
                  Temp.SetData=setptr('arrow');set(gcbf,Temp.SetData{:})
                  WaveForm.Move.Current_Pointer=0;
               end
            end
            set(gcbf,'userdata',WaveForm);
         elseif WaveForm.Move.Status==4;
            %4=Globar
            Temp.CVT=Zeng_Stripchart('Unit Convert',WaveForm.Parent);
            set(WaveForm.Ch.Cursor(:,3),'xdata',[Current_Point(1)   Current_Point(1)])
            for num=1:length(WaveForm.Ch.Axes)
               if strcmp('on',get(WaveForm.Ch.Cursor(num,1),'visible'))
                  set(WaveForm.Ch.Text.dX1(num),'string',['dx1: ' num2str(round(Temp.CVT*(max(get(WaveForm.Ch.Cursor(num,1),'xdata'))-Current_Point(1))))]);
               end
               if strcmp('on',get(WaveForm.Ch.Cursor(num,2),'visible'))
                  set(WaveForm.Ch.Text.dX2(num),'string',['dx2: ' num2str(round(Temp.CVT*(max(get(WaveForm.Ch.Cursor(num,2),'xdata'))-Current_Point(1))))]);
               end
            end
         else%if WaveForm.Move.Status==0;
            Temp.CVT=Zeng_Stripchart('Unit Convert',WaveForm.Parent);
            if isempty(index) | isempty(WaveForm.Move.OldIndex) | index~=WaveForm.Move.OldIndex
               %you move out of axis
               Zeng_WaveForm('Mouse Move Up');
            else
               Stripchart=get(WaveForm.Parent,'userdata');
               if WaveForm.Move.Status==1;
                  %1=Left cursor
                  set(WaveForm.Ch.Cursor(index,1),'xdata',[Current_Point(1)   Current_Point(1)])
                  Zeng_WaveForm('Call Cursor',1,WaveForm.Figure,index)
               elseif WaveForm.Move.Status==2;
                  %2=Right cursor
                  set(WaveForm.Ch.Cursor(index,2),'xdata',[Current_Point(1)   Current_Point(1) ])
                  Zeng_WaveForm('Call Cursor',2,WaveForm.Figure,index)
                  
		         elseif WaveForm.Move.Status==3;
                  %3=Both cursor
                  %Temp.X=[x1 x1 x2 x2]
                  Temp.X=round(WaveForm.Move.X_Original+Current_Point(1)-WaveForm.Move.firstclick_position);
                  if sum(Temp.X>0)==4 & sum(Temp.X<=Stripchart.Head.Samples)==4
                     Temp.X3=round(max(get(WaveForm.Ch.Cursor(1,3),'xdata')));
                     set(WaveForm.Ch.Cursor(index,1),'xdata',Temp.X(1:2))
                     set(WaveForm.Ch.Cursor(index,2),'xdata',Temp.X(3:4))
                     
                     Temp.Y2=Zeng_WaveForm('Data Type Return Y',WaveForm.Figure,round(Temp.X(3)),WaveForm.Ch.Current_ch(index),index);
                     Temp.Y1=Zeng_WaveForm('Data Type Return Y',WaveForm.Figure,round(Temp.X(1)),WaveForm.Ch.Current_ch(index),index);
                     set(WaveForm.Ch.Text.Y2(index),'visible','on','string',['dy: ' num2str(round(Temp.Y2-Temp.Y1))])
                     
                     set(WaveForm.Ch.Text.dX1(index),'string',['dx1: ' num2str(round(Temp.CVT*((Temp.X(1))-Temp.X3)))]);
                     set(WaveForm.Ch.Text.dX2(index),'string',['dx2: ' num2str(round(Temp.CVT*((Temp.X(3))-Temp.X3)))]);
                  end
               elseif WaveForm.Move.Status==5;
                  %5=Annote
                  set(Stripchart.Annote.Current,'xdata',[Current_Point(1)   Current_Point(1)])
                  set(get(Stripchart.Annote.Current,'userdata'),'position',[Current_Point(1,1)+diff(get(gca,'xlim'))/100,WaveForm.Ant_Label_Y])          
                  %set(findobj(WaveForm.Ch.Axes(index),'type','text','userdata',get(Temp.Annote(Temp.Cursor),'userdata')),'position',[Current_Point(1,1)+diff(get(gca,'xlim'))/100,min(get(gca,'ylim'))+diff(get(gca,'ylim'))/10])
                  Stripchart.Annote.Array(Stripchart.Annote.Index,2)=Current_Point(1);
                  set(Stripchart.Figure,'userdata',Stripchart)
             end
      
            end
         end
      elseif WaveForm.Move.Status~=0
         WaveForm.Move.Current_Pointer=0;
         %to tell that you move out of axes
		   %set(gcbf,'userdata',WaveForm);
         Zeng_WaveForm('Mouse Move Up');
      else
         Temp.SetData=setptr('arrow');set(gcbf,Temp.SetData{:})
         WaveForm.Move.Current_Pointer=0;
		   set(gcbf,'userdata',WaveForm);
      end
      
   end %    if strcmp('WaveForm',get(gcbf,'tag'));
%------------------------------------------------------------------------------------------------------      
case 'Mouse Down'
   WaveForm=get(gcbf,'userdata');
   if WaveForm.Move.Current_Pointer==0
   else
      index=find(WaveForm.Ch.Axes==gca);
      WaveForm.Move.OldIndex=index;
      WaveForm.Move.X_Original=[get(WaveForm.Ch.Cursor(index,1),'xdata') get(WaveForm.Ch.Cursor(index,2),'xdata')];
      
      %WaveForm.Move.Current_Pointer=5 is different from others in that we must not to set the 'MouseMoveUp' 
      if WaveForm.Move.Current_Pointer==5
         %Please don't change the number
         %'5  Annote'  

         Stripchart=get(WaveForm.Parent,'userdata');
         Stripchart.Annote.Changed=1;  %0=Unchanged, 1=changed
    
         WaveForm.Move.Status=5;
         set(gcbf,'userdata',WaveForm);
         Temp.SetData=setptr('closedhand');set(gcbf,Temp.SetData{:});
         %initialize the current annote
         %Current_Point=get(gcbf,'currentpoint');
         %index=(WaveForm.axises+1)-ceil(  (Current_Point(1,2)-WaveForm.Ref.AxisPostion(2))/WaveForm.Ref.AxisPostion(4)*WaveForm.axises  )
         Current_Point=round(get(WaveForm.Ch.Axes(index),'currentpoint'));
         Temp.Annote=[findobj(WaveForm.Ch.Axes(index),'tag','Annote')' ]'; 
         Temp.Position=[];
         for i=1:length(Temp.Annote)
            Temp.Position=[Temp.Position;round(min(get(Temp.Annote(i),'xdata')))]; 
         end
         Temp.Diff=abs(Current_Point(1,1)-Temp.Position);
         Temp.Cursor=find(Temp.Diff==min(Temp.Diff));
         if ~isempty(Temp.Cursor)
            Stripchart.Annote.Current=Temp.Annote(Temp.Cursor(1));
            Temp.Label=get(get(Stripchart.Annote.Current,'userdata'),'string');
            Stripchart.Annote.Index=min(find(Stripchart.Annote.Array(:,1)==str2num(get(WaveForm.Ch.Edit.Channel(index),'string')) & Stripchart.Annote.Array(:,2)==min(get(Stripchart.Annote.Current,'xdata')) & Stripchart.Annote.Array(:,3)==Temp.Label(1)+0 & Stripchart.Annote.Array(:,4)==Temp.Label(2)+0));
            EditAnnote=findobj('type','figure','tag','EditAnnote','name',[Stripchart.Head.FileName ':Edit Annote']);
            if ~isempty(EditAnnote);
               EditAnnote=get(EditAnnote,'userdata');
               if btnstate(EditAnnote.Figure,'AddDel','B2');

                  delete(get(Stripchart.Annote.Current,'userdata'));
                  delete(Stripchart.Annote.Current);
                  Stripchart.Annote.Array(Stripchart.Annote.Index,:)=[];
                  WaveForm.Move.Status=0;
                  set(gcbf,'userdata',WaveForm);
                  %If you want to delete, you have to change the Status.
                  %Otherwise, you can not move the mouse
                  set(gcbf,'WindowButtonMotionFcn','');
                  set(Stripchart.Figure,'userdata',Stripchart);
                  Zeng_WaveForm('Mouse Move Up');
               else
                  set(gcbf,'WindowButtonUpFcn','Zeng_WaveForm(''Mouse Move Up'')');
               end
            else
               set(gcbf,'WindowButtonUpFcn','Zeng_WaveForm(''Mouse Move Up'')');
            end
set(Stripchart.Figure,'userdata',Stripchart); 
return
         end%if ~isempty(Temp.Cursor)
      else % WaveForm.Move.Current_Pointer==5
         if WaveForm.Move.Current_Pointer==1
            %1=Left
            WaveForm.Move.Status=1;
         	Temp.SetData=setptr('closedhand');set(gcbf,Temp.SetData{:});
         elseif WaveForm.Move.Current_Pointer==2
            %2=Right
            WaveForm.Move.Status=2;
            Temp.SetData=setptr('closedhand');set(gcbf,Temp.SetData{:});
         elseif WaveForm.Move.Current_Pointer==3
            %3=Both
            WaveForm.Move.Status=3;
            Position=get(WaveForm.Ch.Axes(index),'currentpoint');
            WaveForm.Move.firstclick_position=Position(1,1);
            Temp.SetData=setptr('closedhand');set(gcbf,Temp.SetData{:});
         elseif WaveForm.Move.Current_Pointer==4
            %4=Global
            WaveForm.Move.Status=4;
            Temp.SetData=setptr('closedhand');set(gcbf,Temp.SetData{:});
         end
         set(gcbf,'WindowButtonUpFcn','Zeng_WaveForm(''Mouse Move Up'')');
         set(gcbf,'userdata',WaveForm);
      end%if WaveForm.Move.Current_Pointer==5
   end %if WaveForm.Move.Current_Pointer==0
   
   %------------------------------------------------------------------------------------------------------      
case 'Mouse Move Up'
   set(gcbf,'WindowButtonUpFcn','');
   WaveForm=get(gcbf,'userdata');
   set(gcbf,'WindowButtonMotionFcn','');
   WaveForm.Move.Status=0;
   Temp.Current_Pointer=WaveForm.Move.Current_Pointer;
  %WaveForm.Move.Current_Pointer=0;
   %if you set it=0, you won't be able to move annotes
   set(WaveForm.Figure,'userdata',WaveForm);
   
   
   index=find(WaveForm.Ch.Axes==gca);
   if Temp.Current_Pointer==0
      %you move out of axes
      Temp.SetData=setptr('arrow');set(gcbf,Temp.SetData{:})
   else
	   if Temp.Current_Pointer==1
   	   Temp.SetData=setptr('hand1');set(gcbf,Temp.SetData{:})
	 	elseif Temp.Current_Pointer==2
   	   Temp.SetData=setptr('hand2');set(gcbf,Temp.SetData{:})
	   elseif Temp.Current_Pointer==3
   	   Temp.SetData=setptr('hand');set(gcbf,Temp.SetData{:})
	   elseif Temp.Current_Pointer==4
         Temp.SetData=setptr('hand');
         Temp.a=Temp.SetData{4};
         Temp.a(8:14,8:11)=[  2   1   1   1   ;
	                      1   2   2   1   ;
     					       1   2   2   2   ;
                         1   2   1   1   ;
                         1   2   2   1   ;
	                      1   2   2   1   ;
                         2   1   1   1   ];
         Temp.SetData{4}=Temp.a;
         set(gcbf,Temp.SetData{:})
      elseif Temp.Current_Pointer==5
         %Up date the Annote
         Stripchart=get(WaveForm.Parent,'userdata');
         EditAnnote=findobj('type','figure','tag','EditAnnote','name',[Stripchart.Head.FileName ':Edit Annote']);
         if ~isempty(EditAnnote);
            EditAnnote=get(EditAnnote,'userdata');
            if btnstate(EditAnnote.Figure,'AddDel','B2');
               %Special setting
               WaveForm.Move.Current_Pointer=0;
               set(WaveForm.Figure,'userdata',WaveForm);
               %---
               Temp.SetData=setptr('arrow');
            else
               Temp.SetData=setptr('hand');
               Temp.a=Temp.SetData{4};
               Temp.a(8:14,8:11)=[  2   1   1   2   ;
                                    1   2   2   1   ;
                                    1   2   2   1   ;
                                    1   2   2   1   ;
                                    1   1   1   1   ;
                                    1   2   2   1   ;
                                    1   2   2   1   ];
               Temp.SetData{4}=Temp.a;         
            end
         else
            Temp.SetData=setptr('hand');
            Temp.a=Temp.SetData{4};
            Temp.a(8:14,8:11)=[  2   1   1   2   ;
                                 1   2   2   1   ;
                                 1   2   2   1   ;
                                 1   2   2   1   ;
                                 1   1   1   1   ;
                                 1   2   2   1   ;
                                 1   2   2   1   ];
             Temp.SetData{4}=Temp.a;         
         end
         set(gcbf,Temp.SetData{:});
         Zeng_WaveForm('Update Annote');
         
         %Update the contour
         %There is a problem when you delete annote from waveform
         if 0%~isempty(Stripchart.Contour);
            for n=1:length(Stripchart.Contour);
               Contour=get(Stripchart.Contour(n),'userdata');
               if strcmp(Contour.Analysis,char(Stripchart.Annote.Array(Stripchart.Annote.Index,3:(2+Stripchart.Annote.ShowLength))))
                  Zeng_Contour(Contour.Analysis,Contour.Figure)
               end
               
            end
         end
         
      end%if Temp.Current_Pointer==1
   	
   end%   if Temp.Current_Pointer==0
   set(gcbf,'WindowButtonMotionFcn','Zeng_WaveForm(''Mouse Move'')')
%-----------------------------------------------
case 'Update Annote'
   WaveForm=get(gcbf,'userdata');   
   Stripchart=get(WaveForm.Parent,'userdata');
   index=find(WaveForm.Ch.Axes==gca);
   
   Temp.Ch=str2num(get(WaveForm.Ch.Edit.Channel(index),'string'));
   %Update the WaveFors.
   Temp.Edit.Channel=WaveForm.Ch.Edit.Channel;
   Temp.Edit.Channel(index)=[];
   Temp.index=findobj(Temp.Edit.Channel,'string',num2str(Temp.Ch));
   for i=1:length(Temp.index)
      Zeng_WaveForm('Adjust Annote',WaveForm.Figure,str2num(get(Temp.index(i),'tag')));
   end
   %Update other WaveForms.

   % SP REMOVED next line on 05/24/2023 bc it was preventing waveforms from updating 
   % after deleting an annote. Moving the waveform box around didn't work
   % anymore
%    Stripchart.WaveForm.Figure(find(Stripchart.WaveForm.Figure==WaveForm.Figure))=[];
   for k=1:length(Stripchart.WaveForm.Figure)
      WaveForm=get(Stripchart.WaveForm.Figure(k),'userdata');
      Temp.index=findobj(WaveForm.Ch.Edit.Channel,'string',num2str(Temp.Ch));
      for i=1:length(Temp.index)
         Zeng_WaveForm('Adjust Annote',Stripchart.WaveForm.Figure(k),str2num(get(Temp.index(i),'tag')));
      end
   end
%-----------------------------------------------
case 'Adjust Annote'
   WaveForm=get(varargin{2},'userdata');   
   Stripchart=get(WaveForm.Parent,'userdata');
   if ~isempty(Stripchart.Annote.Array)
      num=varargin{3};
      Temp.XLim=get(WaveForm.Ch.Axes(1),'xlim');
      for j=1:length(num);
         delete([findobj(WaveForm.Ch.Axes(num(j)),'tag','Annote')'  findobj(WaveForm.Ch.Axes(num(j)),'tag','Label Annote')'])
         Temp.Ch=find(Stripchart.Annote.Array(:,1)==str2num(get(WaveForm.Ch.Edit.Channel(num(j)),'string')) & Stripchart.Annote.Array(:,2)>=Temp.XLim(1) & Stripchart.Annote.Array(:,2)<=Temp.XLim(2));
         %Temp.Ch=find(Stripchart.Annote.Array(:,1)==WaveForm.Ch.Current_ch(num(j)) & Stripchart.Annote.Array(:,2)>=Temp.XLim(1) & Stripchart.Annote.Array(:,2)<=Temp.XLim(2));
         %WaveForm.Ch.Current_ch(num)
         if ~isempty(Temp.Ch)
            Temp.Show=[];
            if ~isempty(Stripchart.Annote.Show)
               Temp.Shown=find(Stripchart.Annote.Show(:,1)==1);
               if ~isempty(Temp.Shown)
                  for i=1:length(Temp.Shown)
                     %Temp.Show=[Temp.Show;find(Stripchart.Annote.Array(Temp.Ch,3)==Stripchart.Annote.Show(i,1) & Stripchart.Annote.Array(Temp.Ch,4)==Stripchart.Annote.Show(i,2))]
                     Temp.Show=[Temp.Show;strmatch(char(Stripchart.Annote.Show(Temp.Shown(i),2:Stripchart.Annote.ShowLength+1)),char(Stripchart.Annote.Array(Temp.Ch,3:2+Stripchart.Annote.ShowLength)))];   
                  end
               end
               Temp.Cursor=find(Stripchart.Annote.Array(Temp.Ch(Temp.Show),1)==str2num(get(WaveForm.Ch.Edit.Channel(num(j)),'string')));
            end
            if ~isempty(Temp.Cursor)
               for i=1:length(Temp.Cursor)
                  Temp.Line=line(...
                     'parent',WaveForm.Ch.Axes(num(j)),... 
                     'Color',[.5 .5 .5],...
                     'EraseMode','xor',...
                     'LineStyle','-',...
                     'LineWidth',Log.UD.Ref.ThinLine,...
                     'Marker','none',...
                     'MarkerEdgeColor','auto',...
                     'MarkerFaceColor','none',...
                     'MarkerSize',[6],...
                     'tag',['Annote'],...
                     'visible','on',...               
                     'XData',[Stripchart.Annote.Array(Temp.Ch(Temp.Show(Temp.Cursor(i))),2)*ones(1,2)],...               'xdata',[nan nan],...
                     'YData',get(WaveForm.Ch.Axes(num(j)),'ylim'));
                  Temp.Label= text(...
                     'parent',WaveForm.Ch.Axes(num(j)),... 
                     'FontName','Arial',...
                     'FontUnits','points',...
                     'FontSize',Log.UD.Ref.FontSize,...
                     'FontWeight','normal',...
                     'FontAngle','normal',...
                     'EraseMode','xor',...
                     'position',[Stripchart.Annote.Array(Temp.Ch(Temp.Show(Temp.Cursor(i))),2)+diff(get(WaveForm.Ch.Axes(num(j)),'xlim'))/100,WaveForm.Ant_Label_Y],...
                     'string',char(Stripchart.Annote.Array(Temp.Ch(Temp.Show(Temp.Cursor(i))),3:2+Stripchart.Annote.ShowLength)),...
                     'tag',['Label Annote']);  
                  set(Temp.Line,'userdata',Temp.Label);
                  set(Temp.Label,'userdata',Temp.Line);
               end %           for i=1:length(Temp.Cursor)
               %drawnow
            end
         end %         if ~isempty(Temp.Cursor)
      end %      for j=1:length(num);
   else
      %Come from Mouse move up -WaveForm when you delete the last annote
      delete([findobj(WaveForm.Figure,'tag','Annote')'  findobj(WaveForm.Figure,'tag','Label Annote')'])
   end %   if ~isempty(Stripchart.Annote.Show)
%--------------------------------------------   
case 'Ch Creation'
   WaveForm=get(varargin{2},'userdata');
   Stripchart=get(WaveForm.Parent,'userdata');
   Temp.num =varargin{3};
   Temp.Ch  =varargin{4};
   Temp.Ch=min(Temp.Ch,Stripchart.ELTPoint);
   Temp.Xlim=varargin{5};  % See next line. Adding SRate below destroys the dx calculation that somenhow takes into account the SRate without explicit variable reference.
%    Temp.Xlim=varargin{5}/Log.Head.SRate*1000;  % ADDED BY POELZING 10/14/20 TO ACCOUNT FOR CORRECT SRATE   
	Invert=findobj(WaveForm.Menu.Setting,'tag','Inverting');   
	if strcmp(get(Invert,'checked'),'on')
   	YDIR='reverse';
	else
   	YDIR='normal';
	end

   
   
   for i=1:length(Temp.num);
      WaveForm.Ch.Current_ch(Temp.num(i))=Temp.Ch(i);
      
      
      %Set the axis num in the tag.
      WaveForm.Ch.AxesSz(Temp.num(i),:)=[WaveForm.Ref.AxisPostion(1) sum(WaveForm.Ref.AxisPostion([2 4]))-Temp.num(i)*WaveForm.Ref.AxisPostion(4)/WaveForm.axises WaveForm.Ref.AxisPostion(3) WaveForm.Ref.AxisPostion(4)/WaveForm.axises]; %   (4) 6= base 24= space betw axes
      WaveForm.Ch.Axes(Temp.num(i)) = axes('Parent',WaveForm.Figure, ...
         'ButtonDownFcn','Zeng_WaveForm(''Add Annote'')',...
         'DrawMode','fast',...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Units','pixels', ...	            
         'nextplot','add',...
         'Position',WaveForm.Ch.AxesSz(Temp.num(i),:), ...
         'Tag',num2str(Temp.num(i)), ...%for adding annote
         'XColor',[1 1 1], ...          'XLimMode','auto',...
         'XTickLabelMode','auto',...
         'YColor',[1 1 1], ...
         'ydir',YDIR,...
         'Ylim',[0 1],...
         'YTick',[],...
         'YTickLabel',[],...
         'ZColor',[0 0 0]);
      %for tracking the axes from edit
      
      WaveForm.Ch.Edit.ChannelSz(Temp.num(i),:)=[20 WaveForm.Ch.AxesSz(Temp.num(i),2)+30 Log.UD.Ref.Ch_Box];%(2)+30 for Buttom.View
      WaveForm.Ch.Edit.Channel(Temp.num(i)) = uicontrol('Parent',WaveForm.Figure, ...
         'BackgroundColor',[1 1 1], ...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'HorizontalAlignment','right', ...
         'Position',WaveForm.Ch.Edit.ChannelSz(Temp.num(i),:), ...
         'String',WaveForm.Ch.Current_ch(Temp.num(i)), ...
         'Style','edit', ...
         'tag',num2str(Temp.num(i)),...
         'callback',[...
            'WaveForm=get(gcf,''userdata'');',...
            'Stripchart=get(WaveForm.Parent,''userdata'');',...
            'num = str2num(get(gcbo,''tag''));',...
            'Current_Ch=str2num(get(WaveForm.Ch.Edit.Channel(num),''string''));',...
            'if isempty(Current_Ch);',...
            '	 set(WaveForm.Ch.Edit.Channel(num),''string'',WaveForm.Ch.Current_ch(num));',...
            '   Zeng_Error(''I prefer a number, You know?'');',...
            'elseif ceil(Current_Ch)~=fix(Current_Ch);',...
            '	 set(WaveForm.Ch.Edit.Channel(num),''string'',WaveForm.Ch.Current_ch(num));',...
            '   Zeng_Error(''I prefer an integer number, You know?'');',...
            'else;',...
            '   index=find(WaveForm.ChLabel(:,1)==Current_Ch);',...
            '   if isempty(index);',... Current_Ch>0 & Current_Ch <= Stripchart.Head.Chans/Stripchart.Head.Help.DataType',...
            '	    set(WaveForm.Ch.Edit.Channel(num),''string'',WaveForm.Ch.Current_ch(num));',...%
            '      Zeng_Error(''The number is out of range'');',...
            '   else;',...
            '      Temp.Off=WaveForm.Ch.Current_ch(num);',...
            '      WaveForm.Ch.Current_ch(num)=Current_Ch;',...
            '      set(WaveForm.Figure,''userdata'',WaveForm);',...
            '      Zeng_WaveForm(''Update WaveForm'',WaveForm.Figure,num);',...
            '      Temp.On=WaveForm.Ch.Current_ch(num);',...
            '      Temp.Conduction=findobj(0,''tag'',''Conduction'',''color'',WaveForm.Color,''name'',[Stripchart.Head.FileName '':'' ''Conduction'']);',...
            '      if ~isempty(Temp.Conduction);',...
            '         Zeng_Conduction(''Refresh Axes'',Temp.Conduction,Temp.Off,Temp.On);',...
            '      end;',...
            '      Temp=[];',...
            '   end;',...
            'end;']);
      
      
      WaveForm.Ch.CheckBox.FixSz(Temp.num(i),:) =[1 WaveForm.Ch.Edit.ChannelSz(Temp.num(i),2) 20 20];
      WaveForm.Ch.CheckBox.Fix(Temp.num(i)) = uicontrol('Parent',WaveForm.Figure, ...
         'BackgroundColor',get(WaveForm.Figure,'color'), ...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position', WaveForm.Ch.CheckBox.FixSz(Temp.num(i),:), ...
         'String','', ...
         'Style','checkbox', ...
         'tag',['Nor' num2str(Temp.num(i))]);
      %Create Changing channel button group
      %I set the ID this way so that we can use these number to identify which axes you choose by = ceil(tag/2)
      icons = {['[ line([.2 .9 .5 .2 ],[.2 .2 .9 .2 ],''color'',''k'')]';
            '[ line([.1 .9 .5 .1 ],[.8 .8 .1 .8 ],''color'',''k'')]']};
      callbacks=['Zeng_WaveForm(''One Increase'')';'Zeng_WaveForm(''One Decrease'')'];
      PressType=['flash';'flash'];
      WaveForm.Ch.Button.ChnlChangingSz(Temp.num(i),:)= [sum(WaveForm.Ch.Edit.ChannelSz(Temp.num(i),[1 3])) WaveForm.Ch.Edit.ChannelSz(Temp.num(i),2) 16 WaveForm.Ch.Edit.ChannelSz(Temp.num(i),4)];
      WaveForm.Ch.Button.ChnlChanging(Temp.num(i))=btngroup(WaveForm.Figure,'ButtonID',strvcat(num2str(Temp.num(i)*2-1),num2str(Temp.num(i)*2)),...		         
         'Callbacks',callbacks,...		         
         'IconFunctions',str2mat(icons{:}),...%
         'GroupID', ['C' num2str(Temp.num(i))],...%L=line C=channel
         'GroupSize',[2 1],... 
         'PressType',PressType,...
         'BevelWidth',.1,...
         'units','pixels',...
         'Position',WaveForm.Ch.Button.ChnlChangingSz(Temp.num(i),:));%,...
      set(WaveForm.Ch.Edit.Channel(Temp.num(i)),'userdata',WaveForm.Ch.Axes(Temp.num(i)));
      WaveForm.Ch.Button.CursorCall(Temp.num(i),1)=btngroup(WaveForm.Figure,'ButtonID',num2str(Temp.num(i)),...%Tag=ButtonID  UD=step of buttons  
         'Callbacks','Zeng_WaveForm(''Call Cursor'',1,gcbf)',...		    
         'IconFunctions','text(.3,.5,''1'')',...
         'GroupID',['L' num2str(Temp.num(i)*2-1)],...%L=line C=channel
         'GroupSize',[1 1],...   
         'PressType','toggle',...
         'BevelWidth',.1,...
         'units','pixels',...
         'ButtonColor',[1 0 0],...
         'Position',[15+WaveForm.Ref.AxisPostion(1)+WaveForm.Ref.AxisPostion(3) WaveForm.Ch.AxesSz(Temp.num(i),2)+30 15 15]);%,...
      WaveForm.Ch.Button.CursorCall(Temp.num(i),2)=btngroup(WaveForm.Figure,'ButtonID',num2str(Temp.num(i)),...%Tag=ButtonID  UD=step of buttons  
         'Callbacks','Zeng_WaveForm(''Call Cursor'',2,gcbf)',...		    
         'IconFunctions','text(.3,.5,''2'')',...
         'GroupID',['L' num2str(Temp.num(i)*2)],...%L=line C=channel
         'GroupSize',[1 1],...   
         'PressType','toggle',...
         'BevelWidth',.1,...
         'units','pixels',...
         'ButtonColor',[0 1 1],...
         'Position',[15+WaveForm.Ref.AxisPostion(1)+WaveForm.Ref.AxisPostion(3) WaveForm.Ch.AxesSz(Temp.num(i),2)+15 15 15]);%,...
      axes(WaveForm.Ch.Axes(Temp.num(i)));%Don't remove it, trust me
      WaveForm.Ch.Plot(Temp.num(i),1)=plot(1:Stripchart.Head.Samples,0*ones(1,Stripchart.Head.Samples),...               
         'ButtonDownFcn','Zeng_WaveForm(''Add Annote'')',...                       
         'erasemode','background',...
         'tag','M',...%Main
         'userdata',[0]);%0=Bi, 1=M1,2=M2     
      
      
      %-----------------------------------------------
      %Cursors
      %-----------------------------------------------
      %1=red
      WaveForm.Ch.Cursor(Temp.num(i),1)=line(...
         'parent',WaveForm.Ch.Axes(Temp.num(i)),... 
         'Color',[1 0 0],...
         'EraseMode','xor',...
         'LineStyle','-',...
         'LineWidth',Log.UD.Ref.ThinLine,...
         'Marker','none',...
         'MarkerEdgeColor','auto',...
         'MarkerFaceColor','none',...
         'MarkerSize',[6],...
         'tag','Cursor',...
         'visible','off',...               
         'XData',[round(Stripchart.Head.Samples/3)*ones(1,2)],...               'xdata',[nan nan],...
         'YData',get(gca,'ylim'));
      %2=blue
      WaveForm.Ch.Cursor(Temp.num(i),2)=line(...
         'parent',WaveForm.Ch.Axes(Temp.num(i)),...
         'Color',[0 1  1],...
         'EraseMode','xor',...
         'LineStyle','-',...
         'LineWidth',Log.UD.Ref.ThinLine,...
         'Marker','none',...
         'MarkerEdgeColor','auto',...
         'MarkerFaceColor','none',...
         'MarkerSize',[6],...
         'tag','Cursor',...
         'visible','off',...
         'XData',round(Stripchart.Head.Samples/1.5)*ones(1,2),...               'xdata',[nan nan],...
         'YData',get(gca,'ylim'));
      %3=global
      WaveForm.Ch.Cursor(Temp.num(i),3)=line(...
         'parent',WaveForm.Ch.Axes(Temp.num(i)),...
         'Color',[0 0 0],...
         'EraseMode','xor',...
         'LineStyle','-',...
         'LineWidth',3,...
         'Marker','none',...
         'MarkerEdgeColor','auto',...
         'MarkerFaceColor','none',...
         'MarkerSize',[6],...
         'tag','Cursor',...
         'visible','off',...
         'XData',[round(Stripchart.Head.Samples/2)*ones(1,2)],...               'xdata',[nan nan],...
         'YData',get(gca,'ylim'));
      %-----------------------------------------------
      %Label
      WaveForm.Ch.Text.X2Sz(Temp.num(i),:) =[WaveForm.Ch.AxesSz(Temp.num(i),1)+1 WaveForm.Ch.AxesSz(Temp.num(i),2)+1 Log.UD.Ref.Time_Box];
      WaveForm.Ch.Text.X2(Temp.num(i)) = uicontrol('Parent',WaveForm.Figure, ...
         'BackgroundColor',[1 1 1], ...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'HorizontalAlignment','left', ...
         'Position',WaveForm.Ch.Text.X2Sz(Temp.num(i),:), ...
         'String',['X2: ' num2str(round(Stripchart.Head.Samples/1.5))], ...
         'Style','Text', ...
         'visible','off',...
         'Tag','TextText1');
      WaveForm.Ch.Text.Y2Sz(Temp.num(i),:)=[WaveForm.Ch.AxesSz(Temp.num(i),1)+Log.UD.Ref.Time_Box(1)+1 WaveForm.Ch.AxesSz(Temp.num(i),2)+1 Log.UD.Ref.Time_Box];
      WaveForm.Ch.Text.Y2(Temp.num(i))= uicontrol('Parent',WaveForm.Figure, ...
         'BackgroundColor',[1 1 1], ...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'HorizontalAlignment','left', ...
         'Position',WaveForm.Ch.Text.Y2Sz(Temp.num(i),:), ...	   	   %   'String',['Y2: ' num2str(round(Data{WaveForm.Parent}(Stripchart.ChLabel(find(Stripchart.ChLabel(:,1)==Temp.num(i)),2),round(Stripchart.Head.Samples/1.5))))], ...	      	   'Style','Text', ...
         'Style','Text', ...
         'visible','off',...
         'Tag','TextText1');
      WaveForm.Ch.Text.dX2Sz(Temp.num(i),:) =[WaveForm.Ch.AxesSz(Temp.num(i),1)+WaveForm.Ch.AxesSz(Temp.num(i),3)-Log.UD.Ref.Time_Box(1) WaveForm.Ch.AxesSz(Temp.num(i),2)+1 Log.UD.Ref.Time_Box];
      WaveForm.Ch.Text.dX2(Temp.num(i)) = uicontrol('Parent',WaveForm.Figure, ...
         'BackgroundColor',[1 1 1], ...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'HorizontalAlignment','left', ...
         'Position',WaveForm.Ch.Text.dX2Sz(Temp.num(i),:), ...
         'String',['dx2: ' num2str(round(-Stripchart.Head.Samples/6))], ...
         'Style','Text', ...
         'visible','off',...
         'Tag','TextText1');
      WaveForm.Ch.Text.dX1Sz(Temp.num(i),:) =[WaveForm.Ch.AxesSz(Temp.num(i),1)+WaveForm.Ch.AxesSz(Temp.num(i),3)-2*Log.UD.Ref.Time_Box(1) WaveForm.Ch.AxesSz(Temp.num(i),2)+1 Log.UD.Ref.Time_Box];
      WaveForm.Ch.Text.dX1(Temp.num(i)) = uicontrol('Parent',WaveForm.Figure, ...
         'BackgroundColor',[1 1 1], ...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'HorizontalAlignment','left', ...
         'Position',WaveForm.Ch.Text.dX1Sz(Temp.num(i),:), ...
         'String',['dx1: ' num2str(round(Stripchart.Head.Samples/6))], ...
         'Style','Text', ...
         'visible','off',...
         'Tag','TextText1');
      WaveForm.Ch.Button.DelSz(Temp.num(i),:)= [1 WaveForm.Ch.Edit.ChannelSz(Temp.num(i),2)-16 30 15 ];
      WaveForm.Ch.Button.Del(Temp.num(i)) = uicontrol('Parent',WaveForm.Figure, ...
         'callback','Zeng_WaveForm(''Del Ch'',1)',...		         
         'Units','pixels',...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',WaveForm.Ch.Button.DelSz(Temp.num(i),:), ...
         'String','Del', ...
         'Tag',num2str(Temp.num(i)));
     
      WaveForm.Ch.Button.ShowMeSz(Temp.num(i),:)= [1 WaveForm.Ch.Edit.ChannelSz(Temp.num(i),2)+20 50 15 ];
      WaveForm.Ch.Button.ShowMe(Temp.num(i)) = uicontrol('Parent',WaveForm.Figure, ...
         'callback','Zeng_WaveForm(''ShowMe'',6)',...		         
         'Units','pixels',...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',WaveForm.Ch.Button.ShowMeSz(Temp.num(i),:), ...
         'String','Show', ...
         'Tag',num2str(Temp.num(i)));

      icons = {['text(.5,.5,''H'',''fontsize'',7,''Horiz'',''center'',''color'',[0 0 0]) '];
		         ['text(.5,.5,''L'',''fontsize'',7,''Horiz'',''center'',''color'',[0 0 0]) ']};
      callbacks=['Zeng_WaveForm(''Update Filter'')';
   	           'Zeng_WaveForm(''Update Filter'')'];
      
      PressType=['toggle';'toggle'];
      WaveForm.Ch.Button.FSz(Temp.num(i),:)= [33 WaveForm.Ch.Edit.ChannelSz(Temp.num(i),2)-31 30 15 ];
      %I use ID to identify what axes you are
      WaveForm.Ch.Button.F(Temp.num(i))=btngroup(WaveForm.Figure,'ButtonID',strvcat(num2str(Temp.num(i)*10+1),num2str(Temp.num(i)*10+2)),...		         
            'Callbacks',callbacks,...		         
            'IconFunctions',str2mat(icons{:}),...%
            'GroupID', ['F' num2str(Temp.num(i))],...%="Tag"  L=line C=channel
            'GroupSize',[1 2],... 
            'InitialState',[0 0],...
            'PressType',PressType,...
            'BevelWidth',.1,...
            'units','pixels',...
            'Position',WaveForm.Ch.Button.FSz(Temp.num(i),:));%,...
      
   	index=find(Stripchart.ChLabel(:,1)==Temp.Ch(i));
      if Stripchart.Head.Help.DataType==1;
         WaveForm.Ch.PlotData{Temp.num(i)}=Data{Stripchart.Figure}(Stripchart.ChLabel(index,2),:);  

         
      else
	      WaveForm.Ch.PlotData{Temp.num(i)}(1,:)=[Data{Stripchart.Figure}(Stripchart.ChLabel(index,2),:)-Data{Stripchart.Figure}(Stripchart.ChLabel(index,3),:)];
         WaveForm.Ch.PlotData{Temp.num(i)}(2,:)=Data{Stripchart.Figure}(Stripchart.ChLabel(index,2),:);
         WaveForm.Ch.PlotData{Temp.num(i)}(3,:)=Data{Stripchart.Figure}(Stripchart.ChLabel(index,3),:);


         %1)when you add a new object, don't forget to add it in the del function
         %2)please change the color on the buttons manually.           
         
         Button_Color=[0 0   1;
                       0 .75 .75;
                       .75 0 .75];
                    
         %For Mono-Bi View
         %=============================================
         %The Step is very important of 'View'-WaveForm
         %=============================================
         icons = {['text(.5,.5,''Bi'',''fontsize'',7,''Horiz'',''center'',''color'',[0 0   1  ]) ';
                   'text(.5,.5,''M1'',''fontsize'',7,''Horiz'',''center'',''color'',[0 .75 .75]) ';
                   'text(.5,.5,''M2'',''fontsize'',7,''Horiz'',''center'',''color'',[.75 0 .75]) ']};
         callbacks=['Zeng_WaveForm(''View'',''M'')  ';
                    'Zeng_WaveForm(''View'',''M1'') ';
                    'Zeng_WaveForm(''View'',''M2'') '];
         PressType=['toggle';'toggle';'toggle'];
         WaveForm.Ch.Button.ViewSz(Temp.num(i),:)= [33 WaveForm.Ch.Edit.ChannelSz(Temp.num(i),2)-16 45 15 ];
         %I use ID to identify what axes you are
         WaveForm.Ch.Button.View(Temp.num(i))=btngroup(WaveForm.Figure,'ButtonID',strvcat(num2str(Temp.num(i)*10+1),num2str(Temp.num(i)*10+2),num2str(Temp.num(i)*10+3)),...		         
            'Callbacks',callbacks,...		         
            'IconFunctions',str2mat(icons{:}),...%
            'GroupID', ['V' num2str(Temp.num(i))],...%="Tag"  L=line C=channel
            'GroupSize',[1 3],... 
            'InitialState',[1 0 0],...
            'PressType',PressType,...
            'BevelWidth',.1,...
            'units','pixels',...
            'Position',WaveForm.Ch.Button.ViewSz(Temp.num(i),:));%,...
         
         
         
         
         
         
         
         
         if 0
         %AxesZoom
         icons = {['line([.1 .9 nan .5 .5],[.5 .5 nan .1 .9])';
               'line([.1 .9],[.5 .5])                    ';
               'line([.1 .9 nan .5 .5],[.5 .5 nan .1 .9])';
               'line([.1 .9],[.5 .5])                    ']};
         callbacks=['Zeng_WaveForm2(''AxesZoom'',''in'')  ';
                    'Zeng_WaveForm2(''AxesZoom'',''out'') ';
                    'Zeng_WaveForm2(''AxesZoom'',''up'')  ';
                    'Zeng_WaveForm2(''AxesZoom'',''down'')'];
         PressType=['flash';'flash';'flash';'flash'];
         WaveForm.Ch.Button.AxesZoom(Temp.num(i))=btngroup(WaveForm.Figure,'ButtonID',strvcat(num2str(Temp.num(i)*10+1),num2str(Temp.num(i)*10+2),num2str(Temp.num(i)*10+3),num2str(Temp.num(i)*10+4)),...		         
            'Callbacks',callbacks,...		         
            'IconFunctions',str2mat(icons{:}),...%
            'GroupID', ['Z' num2str(Temp.num(i))],...%="Tag"  L=line C=channel
            'GroupSize',[4 1],...             'InitialState',[1 1],...
            'PressType',PressType,...
            'BevelWidth',.1,...
            'units','pixels',...
            'Position',[WaveForm.Ref.AxisPostion(1)+WaveForm.Ref.AxisPostion(3) WaveForm.Ch.AxesSz(Temp.num(i),2)+15 15 60]);%,...
         end
         axes(WaveForm.Ch.Axes(Temp.num(i)));%Don't remove it, trust me
         
         
         
         %Userdata and Tag are very important
         %Userdata tells if it is either M1 or M2 
         %For the Diff's one, The Tag has to start with D...(For Stripchart,"Plot Mono")
         WaveForm.Ch.Plot(Temp.num(i),2)=plot(1:Stripchart.Head.Samples,0*ones(1,Stripchart.Head.Samples),...               
            'ButtonDownFcn','Zeng_WaveForm(''Add Annote'')',...                              'erasemode','xor',...
            'color',Button_Color(2,:),...                  'erasemode','xor',...
            'erasemode','background',...
            'tag','M1',...%Mono 1
            'userdata',[1],...%0=Bi, 1=M1,2=M2     
            'visible','off');
         WaveForm.Ch.Plot(Temp.num(i),3)=plot(1:Stripchart.Head.Samples,0*ones(1,Stripchart.Head.Samples),...               
            'ButtonDownFcn','Zeng_WaveForm(''Add Annote'')',...                              'erasemode','xor',...
            'color',Button_Color(3,:),...                  'erasemode','xor',...
            'erasemode','background',...
            'tag','M2',...
            'userdata',[2],...%0=Bi, 1=M1,2=M2     
            'visible','off');
         
      end
      if Temp.num(i)~=WaveForm.axises 
         set(WaveForm.Ch.Axes(Temp.num(i)),'XTick',[],'XTickLabel',[],'XTickMode','manual');
      else
         set(WaveForm.Ch.Axes(Temp.num(i)),'Xcolor',[0 0 0]);
      end
   end%   for i=1:length(Temp.num(i));
   
   
   set(WaveForm.Ch.Axes(Temp.num),'Xlim',Temp.Xlim);
   set(WaveForm.Figure,'userdata',WaveForm);
   set(findobj(WaveForm.Ch.Button.Del,'string','Del'),'fontsize',Log.UD.Ref.FontSize)
   for i=1:length(Temp.num);
    
      Zeng_Stripchart('Data Type Plot',WaveForm.Parent,WaveForm.Ch.Plot(Temp.num(i),1),WaveForm.Ch.Current_ch(Temp.num(i)),1,WaveForm.Ch.Gain(Temp.num(i),1),WaveForm.Ch.Offset(Temp.num(i),1))   
   end  
case 'Update Filter'
  	%Zeng_WaveForm('Update WaveForm',WaveForm.Figure,num)
   %WaveForm=get(gcbf,'userdata');
	num=	fix(str2num(get(gcbo,'tag'))/10);
  	Zeng_WaveForm('Update WaveForm',gcbf,num)

otherwise
   
end



