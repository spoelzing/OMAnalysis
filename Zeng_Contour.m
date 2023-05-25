% Changes by Steve Poelzing 1/18/00 listed at end of file
function [varargout]=Zeng_Contour(varargin)
action = varargin{1};
global Log
global Stripchart
global Qdr

% DEBUG
% if ~strcmp(action,'Mouse Move')
%   disp(action)
% end

switch action
%================================================================
  case 'Initial'
    xtemp=dir('ContourParams.mat');
    if isempty(xtemp)
      ContourParams.WaveformCheckbox=1;
      ContourParams.Quadrant=0;
      ContourParams.CheckLabel='Ch';
    else
      load ContourParams
    end
    save ContourParams ContourParams
    Stripchart=get(gcbf,'userdata'); %!!!!! FIX, SO WAVEFORM CAN OPEN CONTOUR
    if isempty(findobj(Stripchart.Axes,'type','patch','LineWidth',Log.UD.Ref.ThickLine))
      Zeng_Share('Error','Polite',[newline 'Please activate one window in stripchart axes by'],...
        [newline blanks(5) 'Click on any exist segment.. or'...
        newline blanks(5) '1: Click on the graph and hold down the mouse button'...
        sprintf('\n\n') blanks(5) '2: Move the mouse (still hold down the mouse button)'...
        sprintf('\n\n') blanks(5) '3: let the mouse button go up']);
    else
      Temp.Patch=findobj(Stripchart.Axes,'type','patch','LineWidth',Log.UD.Ref.ThickLine);
      Contour.Patch=Temp.Patch;
      Contour.X1X2=get(Contour.Patch,'xdata');
      Contour.X1X2=Contour.X1X2(1:2);
      Contour.Time=Contour.X1X2; %You need it for 'Plot TimeMap'
      Contour.DTime=[0 0];%for time different colorbar
      Contour.Color=get(Temp.Patch,'EdgeColor');
      Contour.Interval=3;
      if 0%isempty(Contour.WaveForm)
        Zeng_Error('I will work only when you have WaveForm window for me !!!');
        %elseif isempty(Stripchart.Annote.Array) | isempty(find(Stripchart.Annote.Show(:,3)==1))
        %   Zeng_Error('You do not have any annote in this segment for me !!!');
      else
        Contour.LUT=Stripchart.Head.LUT;
        %Contour.LUTExt=Stripchart.Head.LUTExt;
        Contour.DataType=Stripchart.Head.Help.DataType;
        [Contour.Ch_XY Contour.Interp_Segment]=Zeng_LUTDisplay('LUT Reading',Contour.LUT,'Ch_XY',Contour.DataType);
        %[Contour.Ch_XY Contour.Interp_Segment]=Zeng_LUTDisplay('LUT Reading',[Contour.LUT '.' Contour.LUTExt],'Ch_XY',Contour.DataType);
        
        if isempty(Contour.Ch_XY)
          Zeng_Error('Where is your LUT? !!!');
        else
          a=dir('contourfigure.mat');
          if ~isempty(a)
            load contourfigure
            if isfield(contourfigure,'FGSize')   %Fixes some unspecified problem of opening the figure when FGSize is not a defined field 040814
              [xx,yy]=size(contourfigure.FGSize);
              if xx>1
                contourfigure.FGSize=[];
                contourfigure.FGSize=[200 200 800 500];
              end
            else                                 %Fixes some unspecified problem of opening the figure when FGSize is not a defined field 040814
                contourfigure.colormap=flip(cbrewer('seq','YlGnBu',64));
                contourfigure.FGSize=[200 200 800 500];
                save contourfigure contourfigure
            end
          else
            contourfigure.FGSize=[200 200 800 500];
            contourfigure.colormap='jet';
            save contourfigure contourfigure
          end
          
          FG_Size=contourfigure.FGSize;
          %             FG_Size=[200 200 800 500];
          Contour.Figure=figure;
          Contour.Parent=Stripchart.Figure;
          Stripchart.Contour=[Stripchart.Contour;Contour.Figure];
          set(Stripchart.Figure,'userdata',Stripchart);
          
% Primary Contour Figure --------------------------------------------------
          set(Contour.Figure,'Units','pixels', ...
            'Color',Contour.Color,...%     'HandleVisibility','off',...
            'DeleteFcn','Zeng_Contour(''DeleteFcn'');',...
            'menu','none',...
            'Name',[Stripchart.Head.FileName ':Contour'],...
            'NumberTitle','off',...
            'unit','pixel',...
            'PaperPositionMode','auto',...If you make it auto, pagedlg won't work
            'Position',FG_Size, ...
            'selected','on',...
            'Tag','Contour',...
            'visible','off');
          
% Contour Plot Panel ------------------------------------------------------
          Contour.AxesSz=[5 140 FG_Size(3)-10 FG_Size(4)-140];
          Contour.AxesPanel = uipanel('Parent',Contour.Figure,...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Units','pixel',...
            'Position',Contour.AxesSz); % NOTE: no tag!
          
          % contour plot limits
          Contour.Xlim=[min(Contour.Ch_XY(:,2))-.5 max(Contour.Ch_XY(:,2))+.5];
          Contour.Ylim=[min(Contour.Ch_XY(:,3))-.5 max(Contour.Ch_XY(:,3))+.5];
          %Contour.AxesSz=[5 180 FG_Size(3)-10 FG_Size(4)-200];
          
          % contour axes
          Contour.AxesActualSz = [5 30 Contour.AxesSz(3)-30 Contour.AxesSz(4)-40];
          Contour.Axes = axes('Parent',Contour.AxesPanel, ...
            'box','off',...
            'Color',[1 1 1], ...%'xlabel',[],...%
            'FontName','Arial',...
            'FontUnits','points',...
            'FontSize',Log.UD.Ref.FontSize,...
            'FontWeight','normal',...
            'FontAngle','normal',...
            'NextPlot','add',...%To add the colorbar
            'DrawMode','fast',...%     'XTickLabel',[],...
            'xlim',Contour.Xlim,...
            'ylim',Contour.Ylim,...
            'XTickLabel',[],...
            'XTickLabelMode','manual',...
            'XTickMode','manual',...
            'YDir','reverse',...
            'YTickLabel',[],...
            'YTickLabelMode','manual',...
            'YTickMode','manual',...
            'Units','pixel',...
            'Position',Contour.AxesActualSz);
          
          % set colorbar (and other stuff?)
          axes(Contour.Axes)
          Contour.HDColorbar=colorbar; % colorbar
          Contour.YDir=-1;
          %set(Contour.Axes,'xlim',[min(Contour.Ch_XY(:,2))-.5 max(Contour.Ch_XY(:,2))+.5],'ylim',[min(Contour.Ch_XY(:,3))-.5 max(Contour.Ch_XY(:,3))+.5]);
          
% Readings Panel ----------------------------------------------------------
          FG_Size=get(Contour.Figure,'position');
          num_children = 5; % num of children to share the readings panel
          RP_DivSz = (FG_Size(3)-10)/num_children;
          
          Contour.ReadingPanelSz=[0 0 FG_Size(3) 20]; % same width as contour plot
          Contour.ReadingPanel = uipanel('Parent',Contour.AxesPanel,...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Units','pixel',...
            'Position',Contour.ReadingPanelSz); % NOTE: no tag!
          
          Contour.Text.MeanSz = [0 0 RP_DivSz 20];
          Contour.Text.Mean = uicontrol('Parent',Contour.ReadingPanel, ...
            'HorizontalAlignment','center',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Text.MeanSz, ...
            'String','Mean = ', ...
            'Style','text', ...
            'visible','on',...
            'Tag','Average');
          
          Contour.Text.StdSz = [RP_DivSz 0 RP_DivSz 20];
          Contour.Text.Std = uicontrol('Parent',Contour.ReadingPanel, ...
            'HorizontalAlignment','center',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Text.StdSz, ...
            'String','Std = ', ...
            'Style','text', ...
            'visible','on',...
            'Tag','Average');
          
          Contour.Text.MinSz = [2*RP_DivSz 0 RP_DivSz 20];
          Contour.Text.Min = uicontrol('Parent',Contour.ReadingPanel, ...
            'HorizontalAlignment','center',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Text.MinSz, ...
            'String','Min = ', ...
            'Style','text', ...
            'visible','on',...
            'Tag','Average');

          Contour.Text.MaxSz = [3*RP_DivSz 0 RP_DivSz 20];
          Contour.Text.Max = uicontrol('Parent',Contour.ReadingPanel, ...
            'HorizontalAlignment','center',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Text.MaxSz, ...
            'String','Max = ', ...
            'Style','text', ...
            'visible','on',...
            'Tag','Average');
          
          % colorbar units label
          Contour.Text.UnitLabelSz = [4*RP_DivSz 0 RP_DivSz 20];
          Contour.Text.UnitLabel = uicontrol('Parent',Contour.ReadingPanel,...
            'HorizontalAlignment','center',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Text.UnitLabelSz, ...
            'String',['Colorbar Units: ' 'msec'], ... % should always be msec (I think)
            'Style','text', ...
            'visible','on'); % no tag ('Average' gets deleted somewhere
          
% Main Time Panel ---------------------------------------------------------
          Contour.Frame.MainSz = [5 27 130 103];
          Contour.Frame.Main = uipanel('Parent',Contour.Figure,...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Units','pixel',...
            'Position',Contour.Frame.MainSz, ...
            'Tag','Time Type');
          
          Contour.Text.TminSz = [5 72 65 20];
          Contour.Text.Tmin = uicontrol('Parent',Contour.Frame.Main, ...
            'BackgroundColor',[.8 .8 .8], ...
            'enable','off',...
            'ListboxTop',1, ...
            'Units','pixel',...
            'HorizontalAlignment','left',...
            'Position',Contour.Text.TminSz, ... % abs pos [10 99 30 20]
            'String','Tmin (msec)', ...
            'Style','text', ...
            'Tag','Time Type');
          
          Contour.Edit.TminSz = [75 72 50 20];
          Contour.Edit.Tmin = uicontrol('Parent',Contour.Frame.Main, ...
            'Units','pixel',...
            'enable','off',...
            'BackgroundColor',[1 1 1], ...
            'ListboxTop',0, ...
            'Position',Contour.Edit.TminSz, ... % abs pos [65 99 40 20]
            'string',num2str(Contour.Time(1)),...
            'Style','edit', ...
            'Tag','Time Type',...
            'callback','Zeng_Contour(''Apply'')');
          
          Contour.Text.TmaxSz = [5 49 65 20];
          Contour.Text.Tmax = uicontrol('Parent',Contour.Frame.Main, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'enable','off',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'HorizontalAlignment','left',...
            'Position',Contour.Text.TmaxSz, ... % abs pos [10 76 30 20]
            'String','Tmax (msec)', ...
            'Style','text', ...
            'Tag','Time Type');
          
          Contour.Edit.TmaxSz = [75 49 50 20];
          Contour.Edit.Tmax = uicontrol('Parent',Contour.Frame.Main, ...
            'BackgroundColor',[1 1 1], ...
            'enable','off',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Edit.TmaxSz, ... % abs pos [65 76 40 20]
            'string',num2str(Contour.Time(2)),...
            'Style','edit', ...
            'Tag','Time Type',...
            'callback','Zeng_Contour(''Apply'')');
          
          Contour.Check.OffsetSz = [5 3 60 20];
          Contour.Check.Offset = uicontrol('Parent',Contour.Frame.Main, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'enable','off',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Check.OffsetSz, ... % abs pos [10 30 60 20]
            'String','Offset', ...
            'Style','checkbox', ...
            'Tag','Time Type',...
            'callback','Zeng_Contour(''Offset'',gcbf)');
          
          Contour.Edit.OffsetSz = [75 3 50 20];
          Contour.Edit.Offset = uicontrol('Parent',Contour.Frame.Main, ...
            'Units','pixel',...
            'enable','off',...
            'BackgroundColor',[1 1 1], ...
            'ListboxTop',0, ...
            'Position',Contour.Edit.OffsetSz, ... % abs pos [65 30 40 20]
            'string','0',...
            'Style','edit', ...
            'Tag','Time Type',...
            'callback','Zeng_Contour(''Offset'',gcbf)');
          
          Contour.Text.InterpSz = [5 26 50 20];
          Contour.Text.Interp = uicontrol('Parent',Contour.Frame.Main, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'enable','off',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'HorizontalAlignment','left',...
            'Position',Contour.Text.InterpSz, ... % abs pos [10 53 40 20]
            'String','Interp', ...
            'Style','text', ...
            'Tag','Time Type');
          
          Contour.Pop.InterpSz = [75 26 50 20];
          Contour.Pop.Interp = uicontrol('Parent',Contour.Frame.Main, ...
            'Units','pixel', ...
            'BackgroundColor',[1 1 1],...
            'enable','off',...
            'HorizontalAlignment','right',...
            'ListboxTop',0, ...
            'Position',Contour.Pop.InterpSz, ... % abs pos [55 53 50 20]
            'String','None|   0|   2|   5|  10', ...
            'Style','popupmenu', ...
            'Tag','Time Type',...
            'Value',1,...
            'callback',[...
            'Contour=get(gcbf,''userdata'');',...
            'Zeng_Contour(''ContourType'',Contour.CurrentPlot);']);
          
          % Contour Control Panel ---------------------------------------------------
          %           Contour.Frame.ContourSz = [140 105 190 25];
          %           Contour.Frame.Contour = uipanel('Parent',Contour.Figure, ...
          %             'Units','pixel',...
          %             'BackgroundColor',[0.8 0.8 0.8], ...
          %             'Position',Contour.Frame.ContourSz, ...
          %             'Tag','Contour Type');
          
% Show Waveform Checkbox --------------------------------------------------
          Contour.CheckBox.WaveForm = uicontrol('Parent',Contour.Figure, ...
            'BackgroundColor',get(Contour.Figure,'Color'),...
            'FontName','Arial',...
            'FontUnits','points',...
            'FontSize',Log.UD.Ref.FontSize,...
            'FontWeight','normal',...
            'FontAngle','normal',...
            'Units','pixel',...
            'Position', [10 5 118 20], ...
            'String','Show WaveForm', ...
            'Style','checkbox', ...
            'tag','',...
            'value',ContourParams.WaveformCheckbox);
          
% Avg/Mag Control Panel ----------------------------------------------------
          Contour.Frame.VectorSz = [145 5 270 98];
          Contour.Frame.Vector = uipanel('Parent',Contour.Figure, ...
            'Units','pixel',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',Contour.Frame.VectorSz, ...
            'Tag','Vector Type');
          
          Contour.Text.VectorSz = [5 49 45 20];
          Contour.Text.Vector = uicontrol('Parent',Contour.Frame.Vector, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'ForegroundColor',[1 0 0],...
            'HorizontalAlignment','right',...
            'enable','off',...
            'Units','pixel',...
            'Position',Contour.Text.VectorSz, ... % abs pos [145 54 45 20]
            'String','Current', ...
            'Style','text', ...
            'Tag','Vector Type');
          
          Contour.Text.AverageLSz = [5 27 45 20];
          Contour.Text.AverageL = uicontrol('Parent',Contour.Frame.Vector, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'enable','off',...
            'HorizontalAlignment','right',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Text.AverageLSz, ... % abs pos [145 32 45 20]
            'String','Average', ...
            'Style','text', ...
            'Tag','Vector Type');
          
          Contour.Text.STDSz = [5 5 45 20];
          Contour.Text.STD = uicontrol('Parent',Contour.Frame.Vector, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'enable','off',...
            'HorizontalAlignment','right',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Text.STDSz, ... % abs pos [145 10 45 20]
            'String','STD', ...
            'Style','text', ...
            'Tag','Vector Type');
          
          Contour.Text.MagnitudeLSz = [55 71 60 20];
          Contour.Text.MagnitudeL = uicontrol('Parent',Contour.Frame.Vector, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'enable','off',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Text.MagnitudeLSz, ... % abs pos [195 76 60 20]
            'String','Mag (m/s)', ...
            'Style','text', ...
            'Tag','Vector Type');
          
          Contour.Text.AngleLSz = [120 71 60 20];
          Contour.Text.AngleL = uicontrol('Parent',Contour.Frame.Vector, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'enable','off',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Text.AngleLSz, ... % abs pos [260 76 60 20]
            'String','Angle (deg)', ...
            'Style','text', ...
            'Tag','Vector Type');
          
          Contour.Text.MagnitudeCSz = [55 49 60 20];
          Contour.Text.MagnitudeC = uicontrol('Parent',Contour.Frame.Vector, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'ListboxTop',0, ...
            'enable','on',...
            'Units','pixel',...
            'Position',Contour.Text.MagnitudeCSz, ... % abs pos [195 54 60 20]
            'String',' ', ...
            'Style','text', ...
            'Tag','Vector Type');
          
          Contour.Text.MagnitudeASz = [55 27 60 20];
          Contour.Text.MagnitudeA = uicontrol('Parent',Contour.Frame.Vector, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'enable','on',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Text.MagnitudeASz, ... % abs pos [195 32 60 20]
            'String',' ', ...
            'Style','text', ...
            'Tag','Vector Type');
          
          Contour.Text.MagnitudeSSz = [55 5 60 20];
          Contour.Text.MagnitudeS = uicontrol('Parent',Contour.Frame.Vector, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'enable','on',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Text.MagnitudeSSz, ... % abs pos [195 10 60 20]
            'String',' ', ...
            'Style','text', ...
            'Tag','Vector Type');
          
          Contour.Text.AngleCSz = [120 49 60 20];
          Contour.Text.AngleC = uicontrol('Parent',Contour.Frame.Vector, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'enable','on',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Text.AngleCSz, ... % abs pos [260 54 60 20]
            'String',' ', ...
            'Style','text', ...
            'Tag','Vector Type');
          
          Contour.Text.AngleASz = [120 27 60 20];
          Contour.Text.AngleA = uicontrol('Parent',Contour.Frame.Vector, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'enable','on',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Text.AngleASz, ... % abs pos [260 32 60 20]
            'String',' ', ...
            'Style','text', ...
            'Tag','Vector Type');
          
          Contour.Text.AngleSSz = [120 5 60 20];
          Contour.Text.AngleS = uicontrol('Parent',Contour.Frame.Vector, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'enable','on',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Text.AngleSSz, ... % abs pos [260 10 60 20]
            'String',' ', ...
            'Style','text', ...
            'Tag','Vector Type');
          
          Contour.Check.InverseSz = [208 5 60 20];
          Contour.Check.Inverse = uicontrol('Parent',Contour.Frame.Vector, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'enable','off',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Check.InverseSz, ... % abs pos [348 10 60 20]
            'String','1/x', ...
            'Style','checkbox', ...
            'Tag','Vector Type',...
            'callback','Zeng_Contour(''Vel Inverse'')');
          
          Contour.Check.ColorSz = [208 25 60 20];
          Contour.Check.Color = uicontrol('Parent',Contour.Frame.Vector, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'enable','off',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Check.ColorSz, ...
            'String','color', ...
            'Style','checkbox', ...
            'Tag','Contour Type',...
            'callback',[...
            'Contour=get(gcbf,''userdata'');',...
            'if strcmp(''on'',get(findobj(Contour.Menu.ContourType,''tag'',''Contour''),''check''));',...
            '   Zeng_Contour(''ContourType'',''Contour'');',...
            'end;']);
          
          Contour.Edit.IntervalSz = [208 45 40 20];
          Contour.Edit.Interval = uicontrol('Parent',Contour.Frame.Vector, ...
            'Units','pixel',...
            'BackgroundColor',[1 1 1], ...
            'enable','off',...
            'ListboxTop',0, ...
            'Position',Contour.Edit.IntervalSz, ...
            'string','3',...
            'Style','edit', ...
            'Tag','Contour Type',...
            'callback','Zeng_Contour(''Apply'')');
          
          Contour.Text.IntervalSz = [208 65 40 20];
          Contour.Text.Interval = uicontrol('Parent',Contour.Frame.Vector, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'enable','off',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'HorizontalAlignment','right',...
            'Position',Contour.Text.IntervalSz, ... % abs pos [145 103 45 20]
            'String','Interval', ...
            'Style','text', ...
            'Tag','Contour Type');
          
% Button Control Panel ----------------------------------------------------
          Contour.Button.PanelSz = [145 105 270 30];
          Contour.Button.Panel = uipanel('Parent',Contour.Figure,...
            'BackgroundColor',Contour.Color, ...
            'Units','pixel',...
            'BorderType','none',...
            'Position',Contour.Button.PanelSz, ...
            'Tag','Button');
          
          Contour.Button.DefaultSz = [0 5 60 20];
          Contour.Button.Default = uicontrol('Parent',Contour.Button.Panel,...
            'enable','off',...
            'ListboxTop',0, ...
            'Units','pixel',...
            'Position',Contour.Button.DefaultSz, ... % abs pos [350 110 60 20]
            'String','Reset', ...
            'tag','Button Default',...
            'callback',[...
            'Contour=get(gcbf,''userdata'');',...
            'Zeng_Contour(''Default'',Contour.Figure);']);
          
          Contour.Button.ApplySz = [65 5 60 20];
          Contour.Button.Apply = uicontrol('Parent',Contour.Button.Panel,...
            'ListboxTop',0, ...
            'enable','off',...
            'Units','pixel',...
            'Position',Contour.Button.ApplySz, ...
            'String','Apply', ...
            'tag','Button Apply',...
            'callback','Zeng_Contour(''Apply'')');
          
          Contour.Button.AutoSz = [130 5 60 20];
          Contour.Button.Auto = uicontrol('Parent',Contour.Button.Panel,...
            'ListboxTop',0, ...
            'enable','off',...
            'Units','pixel',...
            'Position',Contour.Button.AutoSz, ...
            'String','Auto Calc', ...
            'tag','Button Auto',...
            'callback','Steve_Contour(''Initial'')');
          
% Quadrant Control Panel --------------------------------------------------
          %-----------------------------
          %  QUADRANT ANALYSIS
          % Added 04/08/2008 S.P.
          %-----------------------------
          
          Contour.QuadrantPanelSz = [450 5 200 130];
          Contour.QuadrantPanel = uipanel('Parent',Contour.Figure, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Units','pixels',...
            'Position',Contour.QuadrantPanelSz);
          
          Contour.Button.QuadrantSz = [1 109 60 20];
          Contour.Button.Quadrant = uicontrol('Parent',Contour.QuadrantPanel,...
            'enable','off',...
            'Position',Contour.Button.QuadrantSz, ...
            'String','Quadrant', ...
            'Value',ContourParams.Quadrant, ...
            'callback','Zeng_Contour(''Quadrant'')');
          
          Contour.Text.TRBSz = [1 45 30 20];
          Contour.Text.TRB = uicontrol('Parent',Contour.QuadrantPanel, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',Contour.Text.TRBSz, ...
            'String','RVB: ', ...
            'Style','text');
          
          Contour.Text.RVBSz =[31 45 60 20];
          Contour.Text.RVB = uicontrol('Parent',Contour.QuadrantPanel, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',Contour.Text.RVBSz, ...
            'String','---',...
            'Style','text');
          
          Contour.Text.TLBSz = [100 45 30 20];
          Contour.Text.TLB = uicontrol('Parent',Contour.QuadrantPanel, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',Contour.Text.TLBSz, ...
            'String','LVB: ', ...
            'Style','text');
          
          Contour.Text.LVBSz = [130 45 60 20];
          Contour.Text.LVB = uicontrol('Parent',Contour.QuadrantPanel, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',Contour.Text.LVBSz, ...
            'String','---', ...
            'Style','text');
          
          Contour.TextTRASz = [1 5 30 20];
          Contour.Text.TRA = uicontrol('Parent',Contour.QuadrantPanel, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',Contour.TextTRASz, ...
            'String','RVA: ', ...
            'Style','text');
          
          Contour.Text.RVASz = [31 5 60 20];
          Contour.Text.RVA = uicontrol('Parent',Contour.QuadrantPanel, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',Contour.Text.RVASz, ...
            'String','---', ...
            'Style','text');
          
          Contour.Text.TLASz = [100 5 30 20];
          Contour.Text.TLA = uicontrol('Parent',Contour.QuadrantPanel, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',Contour.Text.TLASz, ...
            'String','LVA: ', ...
            'Style','text');
          
          Contour.Text.LVASz = [130 5 60 20];
          Contour.Text.LVA = uicontrol('Parent',Contour.QuadrantPanel, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',Contour.Text.LVASz, ...
            'String','---', ...
            'Style','text');
          
          Contour.Text.TFOffsetSz = [75 107 40 20];
          Contour.Text.TFOffset = uicontrol('Parent',Contour.QuadrantPanel, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',Contour.Text.TFOffsetSz, ...
            'String','Offset', ...
            'Value',1,...
            'Style','togglebutton');
          
          Contour.Text.OffsetSz = [115 107 60 20];
          Contour.Text.Offset = uicontrol('Parent',Contour.QuadrantPanel, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',Contour.Text.OffsetSz, ...
            'String','0', ...
            'Style','edit');
          
          Contour.Text.TAreaSz = [1 73 60 20];
          Contour.Text.TArea = uicontrol('Parent',Contour.QuadrantPanel, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',Contour.Text.TAreaSz, ...
            'String','Area: (nxn) ', ...
            'Style','text');
          
          Contour.TextAreaSz = [60 75 30 20];
          Contour.Text.Area = uicontrol('Parent',Contour.QuadrantPanel, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Position',Contour.TextAreaSz, ...
            'String','5',...
            'Style','edit');
          Contour.CheckBox.Area = uicontrol('Parent',Contour.QuadrantPanel, ...
            'BackgroundColor',[0.8 0.8 0.8],...
            'Position', [95 75 30 20], ...
            'Style','checkbox');          
          Qdr.wquad=1;
          Temp.P=findobj(Stripchart.Axes,'type','patch','LineWidth',Log.UD.Ref.ThickLine);
          if isempty(Temp.P)
            Zeng_Error('Please activate one segment for me. ');
          else
            Temp.X=get(Temp.P,'xdata');
            Temp.X=round(Temp.X(1:2));
            set(Contour.Text.Offset,'String',num2str(Temp.X(1)))
          end
          
% Array Arithmatic Panel --------------------------------------------------
          %-----------------------------
          %  ARRAY ARRITHMATIC
          % Added 04/11/2013
          % Steven Poelzing
          %_____________________________
          Arithm=['-';'+';'*';'/'];
          Contour.ArrayMathPanelSz = [660 100 250 30];
          Contour.ArrayMathPanel = uipanel('Parent',Contour.Figure, ...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'Units','pixels',...
            'Position',Contour.ArrayMathPanelSz);
          
          Contour.Button.LoadASz = [5 5 60 20];
          Contour.Button.LoadA = uicontrol('Parent',Contour.ArrayMathPanel,...
            'enable','on',...
            'Units','pixel',...
            'Position',Contour.Button.LoadASz, ...
            'String','LoadA', ...
            'tag','Button Default',...
            'callback',['Zeng_Contour(''ArrAr'',''A'',''Contour.Figure'')']);
          
          Contour.Button.ArithmSz = [70 5 60 20];
          Contour.Button.Arithm = uicontrol('Parent',Contour.ArrayMathPanel,...
            'enable','on',...
            'Units','pixel',...
            'Position',Contour.Button.ArithmSz, ...
            'String',Arithm, ...
            'Style','popupmenu', ...
            'tag','Button Default',...
            'callback',['Zeng_Contour(''ArrAr'',''R'',''Contour.Figure'')']);
          
          Contour.Button.LoadBSz = [135 5 60 20];
          Contour.Button.LoadB = uicontrol('Parent',Contour.ArrayMathPanel,...
            'enable','on',...
            'Units','pixel',...
            'Position',Contour.Button.LoadBSz, ...
            'String','LoadB', ...
            'tag','Button Default',...
            'callback',['Zeng_Contour(''ArrAr'',''B'',''Contour.Figure'')']);
          
          Contour.Button.EqualsSz = [200 5 20 20];
          Contour.Button.Equals = uicontrol('Parent',Contour.ArrayMathPanel,...
            'enable','on',...
            'Units','pixel',...
            'Position',Contour.Button.EqualsSz, ...
            'String','=', ...
            'tag','Button Default',...
            'callback',['Zeng_Contour(''ArrAr'',''E'',''Contour.Figure'')']);
          
%--------------------------------------------------------------------
          
          Contour.Image=[]; % for checking when saving RAW-XYZ.
          Contour.CurrentAxes=1;%for number running in waveForm
          Contour.XYT=[];% for checking the "Export-Raw XYT" if you have created anything.
          
          Temp.File={
            'File'                            ' '                               'filemenu'%               '>Page Setup...'                  'pagedlg'                   ' '               '>Print Setup...'                 'print -dsetup'             ' '
            '>Print...'                       'print -noui'                     ' '
            '>Print Setup.. '                 'print -dsetup                 '  ' '
            '>------'                         ' '                               ' '
            '>Export'                         ' '                               ' '
            '>>Adobe Illustrator'             'Zeng_Share(''Export'',''ai'')'   '-depsc'
            '>>JPG'                           'Zeng_Share(''Export'',''jpg'')'  '-djpeg100 -noui'
            '>>Pict'                          'Zeng_Share(''Export'',''pic'')'  '-dpict'
            '>>XYT'                           'Zeng_Contour(''xyt'')'           ''
            '>>XYT (full array)'              'Zeng_Contour(''xytfull'')'       ''};
          
          Temp=makemenu(Contour.Figure,char(Temp.File(:,1)),char(Temp.File(:,2)), char(Temp.File(:,3)));
          
          if ~strcmp('MAC2',computer)
            set(findobj(Temp,'tag','-dpict'),'enable','off')
          end
          
          %I use the Tag to set in the colormap()....   So, please make the label and the tag the same.
          %
          % The smooth boundary parameter is used in shaping the boundary of the interpolated
          % data region.  Increasing this parameter value makes the region more convex.  The preset
          % values below are the lengths of the hypotenuse of progressively larger triangles.  (1 x 1 x root 2,
          % root 2 x root 2 x 2 etc.) Increasing this parameter allows larger triangles to be
          % included in the contouring algorithm.  Doing so changes concave regions into convex ones
          % but can also serve to smooth the boundaries of of already convex areas.  Should the smoothing
          % effect not be sufficient, larger values can be included below.
          Hm_Setting={
               'Setting'                   ' '                                          'Setting'
               '>Change LUT'               'Zeng_Contour(''Setting'',''LUT'')'          ' '
               '>Vector parameters'      'Zeng_Contour(''Vel Setting'',gcbf)'         ' '
               '>Colormap'                 ''                                           'Colormap'
               '>>Jet'                     'Zeng_Contour(''Setting'',''ClrMap'')'       'Jet'
               '>>PuBu'                    'Zeng_Contour(''Setting'',''ClrMap'')'       'PuBu'        %added 20200715 by GB -- derived from cbrewer color scheme
               '>>YlOrRd'                  'Zeng_Contour(''Setting'',''ClrMap'')'       'YlOrRd'      %added 20200715 by GB -- derived from cbrewer color scheme
               '>>BuGnYl'                  'Zeng_Contour(''Setting'',''ClrMap'')'       'BuGnYl'      %added 20200715 by GB -- derived from cbrewer color scheme
               '>>YlGnBu'                  'Zeng_Contour(''Setting'',''ClrMap'')'       'YlGnBu'      %added 20210105 by GB -- derived from cbrewer color scheme
               '>>GnBu'                    'Zeng_Contour(''Setting'',''ClrMap'')'       'GnBu'        %added 20200715 by GB -- derived from cbrewer color scheme
               '>>BlackWhite'              'Zeng_Contour(''Setting'',''ClrMap'')'       'Gray'
               '>>WhiteBlack'              'Zeng_Contour(''Setting'',''ClrMap'')'       'WhiteBlack'
               '>>BlackRed'                'Zeng_Contour(''Setting'',''ClrMap'')'       'BlackRed'
               '>>BlackBlue'               'Zeng_Contour(''Setting'',''ClrMap'')'       'BlackBlue'
               '>>BlueRed'                 'Zeng_Contour(''Setting'',''ClrMap'')'       'BlueRed'
               '>Smooth Boundaries'        ''                                           'Edge_Max' %               '>>Auto'                    'Zeng_Contour(''Setting'',''Edge_Max'')'       'Auto'
               '>>1-2'                     'Zeng_Contour(''Setting'',''Edge_Max'')'       '2.2362'
               '>>2-2'                     'Zeng_Contour(''Setting'',''Edge_Max'')'       '2.8285'
               '>>1-3'                     'Zeng_Contour(''Setting'',''Edge_Max'')'       '3.1624'
               '>>2-3'                     'Zeng_Contour(''Setting'',''Edge_Max'')'       '3.6057'
               '>>3-3'                     'Zeng_Contour(''Setting'',''Edge_Max'')'       '4.2427'};
          
          Contour.Menu.Setting=makemenu(Contour.Figure,char(Hm_Setting(:,1)),char(Hm_Setting(:,2)), char(Hm_Setting(:,3)));
          set(findobj(Contour.Menu.Setting,'tag','Edge_Max'),'visible','off')
          set(findobj(Contour.Menu.Setting,'tag','Jet'),'check','on');
          %set(findobj(Contour.Menu.Setting,'tag','Auto'),'check','on');
          set(findobj(Contour.Menu.Setting,'tag','2.2362'),'check','on');
          
          Contour.Analysis='Mapping Array';
          Contour.CurrentPlot='Image';
          Contour.Interpolate=1;
          Contour.Type.Ch=[]; %The major variable for every type of Plot TimeMap.
          %----------------------
          Hm_CntrlVar={
            'Contour Variable'           ' '                                'Contour Variable'
            '>Mapping Array'             'Zeng_Contour(''CntrlVar'',gcbf)'  'Mapping Array'
            '>Difference'                'Zeng_Contour(''CntrlVar'',gcbf)'  'Difference'
            '>Anatomy Image'             'Zeng_Contour(''ImageRead'',gcbf)'  ' '
            '>---'							  ' '                                ' '
            '>Activation Time'           'Zeng_Contour(''CntrlVar'',gcbf)'  Log.Annote.Label{1}
            '>Repolarization Time'       'Zeng_Contour(''CntrlVar'',gcbf)'  Log.Annote.Label{2}
            '>---'							  ' '                                                  ' '};
          Contour.Menu.CntrlVar=makemenu(Contour.Figure,char(Hm_CntrlVar(:,1)),char(Hm_CntrlVar(:,2)), char(Hm_CntrlVar(:,3)));
          set(Contour.Menu.CntrlVar(2),'checked','on')
          %The makemenu can't set the tag properly
          %the order is important
          set(Contour.Menu.CntrlVar(5),'enable','off','tag',Log.Annote.Label{1})
          set(Contour.Menu.CntrlVar(6),'enable','off','tag',Log.Annote.Label{2})
          %I keep only the parent
          Contour.Menu.CntrlVar=Contour.Menu.CntrlVar(1);
          
          %----------------------
          Type={
            'ContourType'              ' '                 'Windows'
            '>Raw Data'                 'Zeng_Contour(''ContourType'')'   'Image'
            '>Isochrone'                'Zeng_Contour(''ContourType'')'  'Contour'
            '>Vectors..'                'Zeng_Contour(''ContourType'') '   'Vectors'};
          Contour.Menu.ContourType=makemenu(Contour.Figure,char(Type(:,1)),char(Type(:,2)), char(Type(:,3)));
          set(Contour.Menu.ContourType(2),'Checked','on')
          set(Contour.Menu.ContourType(1),'enable','off')
          
          Label2={ %Please set the tag to 'varargin{3}'
            'Label'              ' '                                        ' '
            '>Channels'          'Zeng_Contour(''Label'',gcbf,''Ch'')        ' 'Ch'
            '>Time..'            'Zeng_Contour(''Label'',gcbf,''Time'')      ' 'Time'
            '>Chan+Time'         'Zeng_Contour(''Label'',gcbf,''Ch+Time'')' 'Ch+Time'};
          Contour.Menu.Label=makemenu(Contour.Figure,char(Label2(:,1)),char(Label2(:,2)), char(Label2(:,3)));
          load ContourParams
          if isfield(ContourParams,'CheckLabel')
              action=ContourParams.CheckLabel;
              switch action
                  case 'Ch'
                  case 'Time'
                      ContourParams.CheckLabel='Label';
                  case 'Ch+Time'
                      ContourParams.CheckLabel='Label';
              end
          else
             ContourParams.CheckLabel='Label'; 
          end

          set(Contour.Menu.Label(2),'enable','off')
          set(Contour.Menu.Label(1),'enable','off')
          save ContourParams ContourParams
          
          TProcess={ %Please set the tag to  equal to 'varargin{3}'
            'Process'                  ' '                                            ' '
            '>Average Filter'          'Zeng_Contour(''Filter'',gcbf,''Mean'')        ' '1'
            '>Median Filter'           'Zeng_Contour(''Filter'',gcbf,''Median'')      ' '2'
            '>Auto Vector'             'Autocalc_Contour(''Initial'')                 ' '3'
            '>EMPTY'                   'Zeng_Contour(''Empty'',gcbf,''EMPTY'')' 'Ch+Time'};
          
          Contour.Menu.Process=makemenu(Contour.Figure,char(TProcess(:,1)),char(TProcess(:,2)),char(TProcess(:,3)));
          set(Contour.Menu.Process(1),'enable','off')
          % for analysis when you choose ARI
          Contour.AnalysisLabel=1;  %1= one, 2 two
          Contour.Time2=[];
          Contour.FGV=[]; %Velocity Figure
          
          %-------
          %Velocity Parameters
          Exist=dir([Log.UD.Path Log.UD.CD 'mat' Log.UD.CD 'VP' Log.UD.CD Stripchart.Head.LUT '.mat']);
          if size(dir([Log.UD.Path Log.UD.CD 'mat' Log.UD.CD 'VP' Log.UD.CD Stripchart.Head.LUT '.mat']),1)
            %if file exists
            eval(['load ' Log.UD.Path Log.UD.CD 'mat' Log.UD.CD 'VP' Log.UD.CD Stripchart.Head.LUT]);
            eval(['Contour.Default.VP=',Stripchart.Head.LUT,';']);
          else
            %              Contour.Default.VP.X=.318;
            % 	         Contour.Default.VP.Y=.318;
            %    	         Contour.Default.VP.how_nearxy=4; %only 1-3
            %        	     Contour.Default.VP.how_neart=200;
            %              Contour.Default.VP.how_many=12;
            % 	         Contour.Default.VP.resthresh=0.65;
            %          	 Contour.Default.VP.Vmin=0.01;
            % 	         Contour.Default.VP.Vmax=1;
            xtemp=dir('ContourParams.mat');
            if isempty(xtemp)
              %              Contour.Default.VP.X=.318;
              % 	         Contour.Default.VP.Y=.318;
              %    	         Contour.Default.VP.how_nearxy=4; %only 1-3
              %        	     Contour.Default.VP.how_neart=200;
              %              Contour.Default.VP.how_many=12;
              % 	         Contour.Default.VP.resthresh=0.65;
              %          	 Contour.Default.VP.Vmin=0.01;
              % 	         Contour.Default.VP.Vmax=1;
              %
              Contour.VP.X=.318;
              Contour.VP.Y=.318;
              Contour.VP.how_nearxy=4; %only 1-3
              Contour.VP.how_neart=200;
              Contour.VP.how_many=12;
              Contour.VP.resthresh=0.65;
              Contour.VP.Vmin=0.01;
              Contour.VP.Vmax=1;
              Contour.Default.VP=Contour.VP;
            else
              load ContourParams
              Contour.VP=ContourParams;
              if ~isfield(Contour.VP,'X')
                Contour.VP.X=0.318;
                Contour.VP.Y=0.318;
                Contour.VP.how_nearxy=4; %only 1-3
                Contour.VP.how_neart=200;
                Contour.VP.how_many=12;
                Contour.VP.resthresh=0.8;
                Contour.VP.Vmin=0.01;
                Contour.VP.Vmax=1;
                Contour.VP.VPosition=[75, 495, 328,305];
                Contour.Default.VP=Contour.VP;
              end
            end
          end
          
          Contour.Edge_Max=0;%default for Auto.
          Contour.VP.Srate=Stripchart.Head.SRate;
          %             Contour.Default.VP.Srate=Stripchart.Head.SRate;
          %             Contour.VP=Contour.Default.VP;
          set(Contour.Figure,'userdata',Contour);
          set(Contour.Figure,'WindowButtonDownFcn','Zeng_Contour(''Mouse Down'')')
          set(Contour.Figure,'visible','on');
          Zeng_Contour('Setting','ClrMap','Jet');
          set(Contour.Figure,'ResizeFcn','Zeng_Contour(''ResizeFcn'')');
          %-------------------------
          %To plot image
          Zeng_Contour('Label',Contour.Figure,ContourParams.CheckLabel)
          Zeng_Contour('Update Menu',Contour.Figure,Stripchart.Annote.Show)
        end
        %--------------------------------------------
      end
      
    end %if isempty(findobj(Stripchart.Axes,'type','patch','LineWidth',Log.UD.Ref.ThickLine));

%        colormap(flip(cbrewer('seq','YlGnBu',64)));%sets default colormap as BuGnYl (flipped YlGnBu) by GB 20210105
    % MATLAB R2014 changed the colormap to parula Edited March 2016
    eval(['load','([''',[Log.UD.Path Log.UD.CD,'Mat', Log.UD.CD, 'ctable'],'''])']); 
    ClrMap=findobj(Contour.Menu.Setting,'tag','Colormap');
    Type=contourfigure.colormap;
    set(get(ClrMap(1),'children'),'checked','off');
    set(findobj(ClrMap(1),'tag',Type),'check','on');
    if isnumeric(Type)
        eval(['colormap(Type)']);
    else
        switch Type
            case 'jet'
            case 'BuGnYl'
                load BuGnYl.mat  
        end
                eval(['colormap(' Type ')']);
        end
      


    
    
  case 'xyt'
    Contour=get(gcbf,'userdata');
    if isempty(Contour.Image)
      Zeng_Error('You have not created any thing!!!');
      return
      
    else
      Stripchart=get(Contour.Parent,'userdata');
      [Filename, Path]=uiputfile([Log.UD.DataCD Log.UD.CD  Stripchart.Head.FileName '.xyt'],'Select a file for your "XYT" ');
      if ~strcmp('0',num2str(Filename)) && ~strcmp('0',num2str(Path))
        %if you do not click cancel
        Out=[];
        Temp = size(Contour.Image);
        for x = 1:Temp(2)
          for y = 1:Temp(1)
            if ~isnan(Contour.Image(y,x))
              Out=[Out;x y Contour.Image(y,x)];
            end
          end
        end
        
        if get(Contour.Check.Offset,'value')
          Offset=str2num(get(Contour.Edit.Offset,'string'));
          if isempty(Offset)
            Zeng_Error(['Please add a  number for the offset' char(13) 'OK !!!'])
            return
          else
            Out(:,3)=Out(:,3)-Offset;
          end
        end
        
        %Adjust the file name..
        Big=find(Filename>=65 & Filename<=90);
        %Make them all small
        Filename(Big)=Filename(Big)+32;
        Filename_length=length(Filename);
        
        if Filename_length<5
          Filename=[Filename '.' varargin{2}];
        elseif ~strcmp(char([Filename((Filename_length-3):Filename_length)]), ['.xyt'])
          Filename=[Filename '.xyt'];
        end
        
        %dlmwrite([Path Filename],Out,'\t');
        save([Path Filename],'Out','-ASCII','-TABS');
      end
    end
  case 'xytfull'
    Contour=get(gcbf,'userdata');
    if isempty(Contour.Image)
      Zeng_Error('You have not created any thing!!!');
      return
      
    else
      Stripchart=get(Contour.Parent,'userdata');
      [Filename, Path]=uiputfile([Log.UD.DataCD Log.UD.CD  Stripchart.Head.FileName '.xyt'],'Select a file for your "XYT" ');
      if ~strcmp('0',num2str(Filename)) && ~strcmp('0',num2str(Path))
        %if you do not click cancel
        Out=[];
        Temp = size(Contour.Image);
        
        for x = 1:Temp(2)
          for y = 1:Temp(1)
            %if ~isnan(Contour.Image(y,x))
            Out=[Out;x y Contour.Image(y,x)];
            %end
          end
        end
        
        if get(Contour.Check.Offset,'value')
          Offset=str2num(get(Contour.Edit.Offset,'string'));
          if isempty(Offset)
            Zeng_Error(['Please add a  number for the offset' char(13) 'OK !!!'])
            return
          else
            Out(:,3)=Out(:,3)-Offset;
          end
        end
        
        %Adjust the file name..
        Big=find(Filename>=65 & Filename<=90);
        %Make them all small
        Filename(Big)=Filename(Big)+32;
        Filename_length=length(Filename);
        
        if Filename_length<5
          Filename=[Filename '.' varargin{2}];
        elseif ~strcmp(char([Filename((Filename_length-3):Filename_length)]), ['.xyt'])
          Filename=[Filename '.xyt'];
        end
        
        %dlmwrite([Path Filename],Out,'\t');
        save([Path Filename],'Out','-ASCII','-TABS');
      end
    end
    
  case 'Apply'
    Contour=get(gcbf,'userdata');
    if strcmp(Contour.Analysis,'Mapping Array')
      Zeng_Error('Apply what !!!')
    else
      Zeng_Contour('Plot TimeMap',Contour.Figure,Contour.Analysis,Contour.CurrentPlot);
    end
    
  case 'Update Menu'
    %2=Contour.Figure, 3=Stripchart.Annote.Show, 4=Current Annote ,5= 'off' or 'on'
    if nargin==3
      %initialize the Contour with Show
      Contour=get(varargin{2},'userdata');
      Show=varargin{3};
      if ~isempty(Show)
        Show(:,1)=[];
        Temp=strmatch(Log.Annote.Label{1},Show,'exact');
        %To set AT and RT
        if ~isempty(Temp)
          set(findobj(Contour.Menu.CntrlVar,'tag',Log.Annote.Label{1}),'enable','on');
          Show(Temp,:)=[];
        end
        Temp=strmatch(Log.Annote.Label{2},Show,'exact');
        if ~isempty(Temp)
          set(findobj(Contour.Menu.CntrlVar,'tag',Log.Annote.Label{2}),'enable','on');
          Show(Temp,:)=[];
        end
        %To set all the rest
        if ~isempty(Show)
          for i=1:length(Show(:,1))
            %'>Repolarization Time'       'Zeng_Contour(''CntrlVar'',gcbf)'  Log.Annote.Label{2}
            uimenu(Contour.Menu.CntrlVar,'callback','Zeng_Contour(''CntrlVar'',gcbf)','tag',char(Show(i,:)),'Label',char(Show(i,:)))
          end
          set(findobj(Contour.Menu.CntrlVar,'position',5),'Separator','on')
        end
      end
    else
      %4=Label  5='off' or 'on'
      for i=1:length(varargin{2})
        Contour=get(varargin{2}(i),'userdata');
        Temp.Menu=findobj(Contour.Menu.CntrlVar,'tag',char(varargin{4}));
        if isempty(Temp.Menu)
          if strcmp(varargin{5},'Off')
            Zeng_Error(['There is another in Contour' char(13) 'Please contact Zeng']);
          else
            uimenu(Contour.Menu.CntrlVar,'callback','Zeng_Contour(''CntrlVar'',gcbf)','tag',char(varargin{4}),'Label',varargin{4})
          end
        else
          %Sometimes Temp.menu's size = [1 2], but there are the same value
          %it is matlab bugs
          Temp.Order=get(Temp.Menu,'position');
          if Temp.Order < 5 %1-4 are reserved
            set(Temp.Menu,'enable',varargin{5})
          else
            delete(Temp.Menu)
          end
        end
        
        if length(get(Contour.Menu.CntrlVar,'children'))>4
          set(findobj(Contour.Menu.CntrlVar,'position',5),'separator','on')
        end
        
        if 0% strcmp(get(findobj(Contour.Menu.CntrlVar,'tag',varargin{4}),'Checked'),'on') | strcmp(get(findobj(Contour.Menu.CntrlVar,'tag','Difference'),'Checked'),'on')
          Zeng_Contour('CntrlVar',Contour.Figure,'Mapping Array')
        end
        
      end %for i=1:length(varargin{2})
    end
    
  case 'ResizeFcn'
    Contour=get(gcbf,'userdata');
    FG_Size=get(gcbf,'position');
    
    if FG_Size(3)>71 && FG_Size(4)>181 % what is this case?
      
      % change panel position
      Contour.AxesSz = [5 140 FG_Size(3)-10 FG_Size(4)-140];
      set(Contour.AxesPanel,'position',Contour.AxesSz);
      
      % change actual axes plot position
      Contour.AxesActualSz = [5 30 Contour.AxesSz(3)-80 Contour.AxesSz(4)-40];
      set(Contour.Axes,'position',Contour.AxesActualSz);
      
      % change colorbar location
      set(Contour.HDColorbar,'location','eastoutside');
      
      % reset reading panel
      Contour.ReadingPanelSz=[0 0 FG_Size(3) 20]; % same width as contour plot
      set(Contour.ReadingPanel,'Position',Contour.ReadingPanelSz);
      
      num_children = 5; % num of children to share the readings panel
      RP_DivSz = (FG_Size(3)-10)/num_children;
      set(Contour.Text.Mean,'Position',[5 0 RP_DivSz 20])
      set(Contour.Text.Std,'Position',[RP_DivSz 0 RP_DivSz 20])
      set(Contour.Text.Min,'Position',[2*RP_DivSz 0 RP_DivSz 20])
      set(Contour.Text.Max,'Position',[3*RP_DivSz 0 RP_DivSz 20])
      set(Contour.Text.UnitLabel,'Position',[4*RP_DivSz 0 RP_DivSz 20])
    end
    
    ContourParams.WaveformCheckbox=get(Contour.CheckBox.WaveForm,'Value');
    ContourParams.Quadrant=get(Contour.Button.Quadrant,'Value');
    save ContourParams ContourParams
    load contourfigure
    contourfigure.FGSize=get(Contour.Figure,'Position');
    save contourfigure contourfigure
    
  case 'Setting'
    %2=action 3=Type for clrMap
    action=varargin{2};
    Contour=get(gcbf,'userdata');
    
    switch action
      case 'LUT'
        Stripchart=get(Contour.Parent,'userdata');
        %Stripchart.Head.LUT
        %[Temp.NewLUT Temp.Path]=uigetfile([Log.UD.Path Log.UD.CD 'lut' Log.UD.CD '*.' Stripchart.Head.LUTExt],['Change from ' Contour.LUT]);
        [Temp.NewLUT, Temp.Path]=uigetfile([Log.UD.Path Log.UD.CD 'lut' Log.UD.CD '*.*'],['Change from ' Contour.LUT]);
        if max([Temp.NewLUT Temp.Path]) ~= 0%if you do not click cancel
          Contour.LUT=Temp.NewLUT;
          [Contour.Ch_XY, Contour.Interp_Segment]=Zeng_LUTDisplay('LUT Reading',Contour.LUT,'Ch_XY',Contour.DataType);
          Contour.Xlim=[min(Contour.Ch_XY(:,2))-.5 max(Contour.Ch_XY(:,2))+.5];
          Contour.Ylim=[min(Contour.Ch_XY(:,3))-.5 max(Contour.Ch_XY(:,3))+.5];
          set(Contour.Figure,'userdata',Contour);
          delete(get(Contour.Axes,'children'))
          Zeng_Contour('CntrlVar',Contour.Figure,Contour.Analysis)
        end%if max([Temp.NewLUT Temp.Path]) ~= 0%if you do not click cancel
      case 'ClrMap'
        if nargin==2
          Type=get(gcbo,'tag');
        else
          Type=varargin{3};
        end
        ClrMap=findobj(Contour.Menu.Setting,'tag','Colormap');
        if ~isempty(ClrMap)
          set(get(ClrMap(1),'children'),'checked','off');
          set(findobj(ClrMap(1),'tag',Type),'check','on');
          ContourParams.colormap=Type;
          eval(['load','([''',[Log.UD.Path Log.UD.CD,'Mat', Log.UD.CD, 'ctable'],'''])']); 
          switch Type
              case 'BuGnYl'
                  load BuGnYl.mat
          end
          eval(['colormap(' Type ')']);
          load contourfigure
          contourfigure.colormap=Type;
          save contourfigure contourfigure
        end
        
      case 'Edge_Max'
        Edge_Max_Value=get(gcbo,'tag');
        Edge_Max=findobj(Contour.Menu.Setting,'tag','Edge_Max');
        if ~isempty(Edge_Max)
          set(get(Edge_Max(1),'children'),'checked','off');
          set(findobj(Edge_Max(1),'tag',Edge_Max_Value),'check','on');
          
          if strcmp('Auto',Edge_Max_Value)
            Contour.Edge_Max=0;
          else
            Contour.Edge_Max=str2num(Edge_Max_Value);
          end
          
          set(Contour.Figure,'userdata',Contour);
          Zeng_Contour('ContourType',Contour.CurrentPlot)
        end
        %Auto
    end%Switch
    
  case 'DeleteFcn'
    if ~strcmp('Stripchart',get(gcbf,'tag'))
      Contour=get(gcbf,'userdata');
      Stripchart=get(Contour.Parent,'userdata');
      Stripchart.Contour(find(Stripchart.Contour==Contour.Figure))=[];
      set(Stripchart.Figure,'userdata',Stripchart);
      if ~isempty(Contour.FGV)
        delete(Contour.FGV.Figure)
      end
      %      Def=findobj(0,'type','figure','userdata',Contour.Figure,'tag','Definition')
      %      if ~isempty(Def)
      %         close(Def)
      %      end
      
    end
    load ContourParams
    ContourParams.WaveformCheckbox=get(Contour.CheckBox.WaveForm,'Value');
    ContourParams.Quadrant=get(Contour.Button.Quadrant,'Value');
    save ContourParams ContourParams
    load contourfigure
    contourfigure.FGSize=get(Contour.Figure,'Position');
    save contourfigure contourfigure
    
  case 'Default'
    Contour=get(varargin{2},'userdata');
    Stripchart=get(Contour.Parent,'userdata');
    Continue=0;
    
    if isempty(Stripchart.Annote.Array)
      Zeng_Error('You have no annote in this segment.');
      Zeng_Contour('CntrlVar',Contour.Figure,'Mapping Array');
      
    else
      Contour_BackUp=Contour;
      Contour.XYT=[];
      Contour.X1X2=round(get(Contour.Patch,'xdata'));
      Contour.X1X2=Contour.X1X2(1:2);
      set(Contour.Text.Offset,'String',num2str(Contour.X1X2(1)));
      Temp.Index3=find( Stripchart.Annote.Array(:,2)>=Contour.X1X2(1) & Stripchart.Annote.Array(:,2)<=Contour.X1X2(2));
      %==========================
      if nargin==3
        %when you change the analysis
        Contour.Analysis=varargin{3};
      end
      if strcmp(Contour.Analysis,'Mapping Array')
        %Do nothing. (It came from you hit itself)
      elseif strcmp(Contour.Analysis,'Difference')
        Temp.sort=[];
        for i=1:length(Contour.Ch_XY)
          Temp.Ch=find(Stripchart.Annote.Array(Temp.Index3,1)==Contour.Ch_XY(i,1));
          if length(Temp.Ch)>1 %at least 2
            %it is also in the LUT
            TSort=sort(Stripchart.Annote.Array(Temp.Index3(Temp.Ch),2));
            Temp.sort=[Temp.sort;TSort(1:2)'];
            
            Contour.XYT=[Contour.XYT;[Contour.Ch_XY(i,[2 3]) diff(TSort([1 2]))]];
          end
        end

        if isempty(Contour.XYT)
          Zeng_Error('You have no data in this segment');
        else
            Contour.Time=[min(Temp.sort(:,2)-Temp.sort(:,1)) max(Temp.sort(:,2)-Temp.sort(:,1))];
          Contour.DTime=[min(Contour.XYT(:,3)) max(Contour.XYT(:,3))];
          Continue=1;
        end
      else
        Temp.Index2=strmatch(Contour.Analysis,Stripchart.Annote.Array(Temp.Index3,3:(2+Stripchart.Annote.ShowLength)));
        Temp.Index=Temp.Index3(Temp.Index2);
        for i=1:length(Temp.Index)
          Temp.Ch=find(Contour.Ch_XY(:,1)==Stripchart.Annote.Array(Temp.Index(i),1));
          if ~isempty(Temp.Ch)
            %it is also in the LUT
            Contour.XYT=[Contour.XYT;[Contour.Ch_XY(Temp.Ch,[2 3]) Stripchart.Annote.Array(Temp.Index(i),2)]];
          end
        end
        
        if isempty(Contour.XYT)
          Zeng_Error('You have no data in this segment');
        else
          Contour.Time=[min(Contour.XYT(:,3)) max(Contour.XYT(:,3))];
          Continue=1;
        end
      end
      
      if Continue
        
        % set new values in panels
        set(Contour.Edit.Tmax,'string',num2str(Contour.Time(2)));
        set(Contour.Edit.Tmin,'string',num2str(Contour.Time(1)));
        %==========================
        if nargin==2
          Contour.Interval=5;
          set(Contour.Edit.Interval,'string',num2str(Contour.Interval));
          set(Contour.Check.Offset,'value',0);
          set(Contour.Check.Color,'value',0);
        end
        
        % something funky's happening here...
        set(Contour.Figure,'userdata',Contour);
        Continue=Zeng_Contour('Plot TimeMap',Contour.Figure,Contour.Analysis,Contour.CurrentPlot,'Default');
        if ~Continue
          set(Contour.Figure,'userdata',Contour_BackUp);
        end
      end
    end
    set(Contour.Check.Offset,'value',0);
    set(Contour.Edit.Offset,'string',num2str(Contour.Time(1)))
    Zeng_Contour('Offset',Contour.Figure)
    varargout{1}=Continue;
    
  case 'ImageRead'
    Contour=get(varargin{2},'userdata');
    if strcmp('off',get(Contour.Menu.Label(1),'Enable'))
      set(Contour.Menu.Label(1),'Enable','on')
      if strcmp('on',get(Contour.Menu.Label(2),'checked'))
        set(Contour.Menu.Label,'Checked','off')
        delete(findobj(gca,'type','text','tag','Label'));
      end
    end
    
    
    [filename, pathname]=uigetfile('C:\Data\Greg\*.da','Select Slave Image');
    if filename~=0
      disp('In Here')
      fid_master=fopen([pathname filename],'r');
      temp1=fread(fid_master, 2560,'int16');
      num_frame=temp1(5);
      num_column=temp1(385);
      num_row=temp1(386);
      first_frame=1;
      last_frame=num_frame;
      temp2=fread(fid_master,num_frame*num_column*num_row,'int16');
      channel_matrix = reshape(0:1:(128*128-1),128,128)';
      matrix=reshape(temp2,num_frame,num_column*num_row);
      matrix_master=matrix';
      fclose(fid_master);
      
      [filename, pathname]=uigetfile([pathname, '\*.da'],'Select Slave Dark Frame');
      fid_slave=fopen([pathname filename],'r');
      
      temp=fread(fid_slave, 2560,'int16');
      temp2=fread(fid_slave,num_frame*num_column*num_row,'int16');
      matrix=reshape(temp2,num_frame,num_column*num_row);
      matrix_slave=matrix';
      
      for i=round(num_frame*0.66)
        temp_master=reshape(matrix_master(:,i),num_column,num_row);
        temp_slave=reshape(matrix_slave(:,i),num_column,num_row);
        temp_master=temp_master-temp_slave;
        temp_master=temp_master';
        temp_master=rot90(rot90(temp_master));
        
        %%%%%% 2x2 binnning,comment out if you don't want binning, change 2's
        %%%%%% to something else if you want different sized binning
        [m,n]=size(temp_master);
        temp_master=sum(reshape(temp_master,2,[]),1);
        temp_master=reshape(temp_master,n/2,[]).'; %Note transpose
        temp_master=sum(reshape(temp_master,2,[]),1);
        temp_master=reshape(temp_master,m/2,[]).'; %Note transpose
        
        %%%%%%end binning
        temp_master=fliplr(temp_master);
        image(temp_master,'CDataMapping','scaled');
        %
        %     Contour.Image=temp_master;
        %     set(Contour.Figure,'userdata',Contour);
        colormap('gray')
      end
    end
    %----------------------------------------------
    %Analysis
    %----------------------------------------------
  case 'CntrlVar'
    Contour=get(varargin{2},'userdata');
    if nargin==2
      Label=get(gcbo,'tag');
    else %=3
      Label=varargin{3};
    end
    
    switch Label
      case 'Mapping Array'
        Continue=1;
        delete(get(Contour.Axes,'children'));
        % set(findobj(Contour.Figure,'Tag','Average'),'visible','on') 
        % keep visible!
        set(Contour.Axes,'xlim',[min(Contour.Ch_XY(:,2))-.5 max(Contour.Ch_XY(:,2))+.5],'ylim',[min(Contour.Ch_XY(:,3))-.5 max(Contour.Ch_XY(:,3))+.5]);
        Contour.Analysis='Mapping Array';
        Contour.Image=[];
        set(Contour.Figure,'userdata',Contour);
        Zeng_Contour('Label',Contour.Figure,'Ch');
        set([findobj(Contour.Frame,'tag','Time Type')' findobj(Contour.Figure,'Tag','Contour Type')' findobj(Contour.Frame,'tag','Vector Type')'],'enable','off');
        set([Contour.Button.Apply Contour.Button.Default],'enable','off');
        set(findobj(Contour.Menu.Label,'tag','Ch'),'Checked','on');
        
        set([Contour.Menu.ContourType Contour.Menu.Label],'enable','off');
      case 'Difference'
        Continue=Zeng_Contour('Default',Contour.Figure,Label);
        if Continue
          set([Contour.Button.Apply Contour.Button.Default],'enable','on');
          set([Contour.Menu.ContourType Contour.Menu.Label],'enable','on');
        end
      otherwise
        %Continue=Zeng_Contour('Plot TimeMap',Contour.Figure,Label,Contour.CurrentPlot);
        Continue=Zeng_Contour('Default',Contour.Figure,Label);
        if Continue
          set([Contour.Button.Apply Contour.Button.Default],'enable','on');
          set([Contour.Menu.ContourType Contour.Menu.Label],'enable','on');
        end
    end
    
    if Continue
      set(get(Contour.Menu.CntrlVar,'children'),'Checked','off');
      set(findobj(Contour.Menu.CntrlVar,'tag',Label),'Checked','on');
      set(Contour.Menu.Process,'enable','on');
    end
    
  case Log.Annote.Label(1)
    %Contour=get(gcbf,'userdata');
    Contour=get(varargin{2},'userdata');
    Continue=Zeng_Contour('Default',Contour.Figure,Log.Annote.Label{1});
    if Continue
      Contour=get(varargin{2},'userdata');
      set(Contour.Menu.CntrlVar,'Checked','off')
      set(Contour.Menu.CntrlVar(6),'Checked','on')
      Contour.Analysis=Log.Annote.Label{1};
      set(Contour.Figure,'userdata',Contour);
      Zeng_Contour('Default',Contour.Figure)
    end
  case Log.Annote.Label(2)
    %Contour=get(gcbf,'userdata');
    Contour=get(varargin{2},'userdata');
    
    Continue=Zeng_Contour('Default',Contour.Figure,Log.Annote.Label{2});
    %Continue=Zeng_Contour('Plot TimeMap',Contour.Figure,Log.Annote.Label{2},Contour.CurrentPlot);
    if Continue
      Contour=get(varargin{2},'userdata');
      set(Contour.Menu.CntrlVar,'Checked','off')
      set(Contour.Menu.CntrlVar(6),'Checked','on')
      Contour.Analysis=Log.Annote.Label{2};
      set(Contour.Figure,'userdata',Contour);
      Zeng_Contour('Default',Contour.Figure)
    end
    
  case Log.Annote.Label(3)
    %Contour=get(gcbf,'userdata');
    Contour=get(varargin{2},'userdata');
    Continue=Zeng_Contour('Default',Contour.Figure,{Log.Annote.Label{1},Log.Annote.Label{2}});
    %Continue=Zeng_Contour('Plot TimeMap',Contour.Figure,{Log.Annote.Label{1},Log.Annote.Label{2}},Contour.CurrentPlot);
    if Continue
      Contour=get(varargin{2},'userdata');
      set(Contour.Menu.CntrlVar,'Checked','off')
      set(Contour.Menu.CntrlVar(6),'Checked','on')
      Contour.Analysis={Log.Annote.Label{1},Log.Annote.Label{2}};
      set(Contour.Figure,'userdata',Contour);
      Zeng_Contour('Default',Contour.Figure)
    end
    
    %----------------------------------------------
    %ContourType
    %----------------------------------------------
  case 'ContourType'
    if nargin==1
      Type=get(gcbo,'tag');
    else
      Type=varargin{2};
    end
    Contour=get(gcbf,'userdata');
    
    Continue=Zeng_Contour('Plot TimeMap',Contour.Figure,Contour.Analysis,Type);
    if Continue
      set(Contour.Menu.ContourType,'Checked','off')
      set(findobj(Contour.Menu.ContourType,'tag',Type),'Checked','on')
    end
    %---------------------------------------------
    %Label
    %---------------------------------------------
  case 'Label'
    Contour=get(varargin{2},'userdata');
    axes(Contour.Axes);
    if nargin ==2
      %use the old one %called from LUTDisplay
      Temp=findobj(Contour.Menu.Label,'Checked','on');
      if isempty(Temp)
        Continue=0;
        %it is not showing anything
      else
        action=get(Temp(1),'tag');
        Continue=1;
      end
    else
      %use the new one
      delete(findobj(gca,'type','text','tag','Label'));
      if Contour.Menu.Label(1)==get(gcbo,'parent')
        %You called from "Label Menu", so you have to change it.
        if strcmp('on',get(gcbo,'checked'))
          Continue=0;
          set(Contour.Menu.Label,'Checked','off')
          %it is not showing anything
        else
          action=varargin{3};
          set(Contour.Menu.Label,'Checked','off')
          set(findobj(Contour.Menu.Label,'tag',action),'Checked','on')
          Continue=1;
        end
      else
        %You may call from CntrVar..Mapping Array..
        action=varargin{3};
        set(Contour.Menu.Label,'Checked','off')
        set(findobj(Contour.Menu.Label,'tag',action),'Checked','on')
        Continue=1;
      end
    end
    if Continue
      if strcmp(Contour.Analysis,'Mapping Array') || strcmp(Contour.CurrentPlot,'Vectors')
        Interp=1;
      else
        Choice=get(Contour.Pop.Interp,'value');
        if Choice==1
          Interp=1;
        else
          Interp=get(Contour.Pop.Interp,'string');
          Interp=1+str2num(Interp(Choice,:));
        end
      end
      Xlim=get(Contour.Axes,'xlim');
      Ylim=get(Contour.Axes,'ylim');
      ScaleX=diff(Xlim)/diff(Contour.Xlim);
      ScaleY=diff(Ylim)/diff(Contour.Ylim);
      switch action
        case 'Ch'
          for i=1:length(Contour.Ch_XY(:,1))
            text(Xlim(1)+(Contour.Ch_XY(i,2)-Contour.Xlim(1)-0.25)*ScaleX, Ylim(1)+(Contour.Ch_XY(i,3)-Contour.Ylim(1))*ScaleY,num2str(Contour.Ch_XY(i,1)),'tag','Label','fontsize',Log.UD.Ref.FontSize)
          end
        case 'Time'
          if get(Contour.Check.Offset,'value')
            Offset=str2num(get(Contour.Edit.Offset,'string'));
            if isempty(Offset)
              Zeng_Error(['Please add a  number for the offset' char(13) 'OK !!!'])
              return
            else
              T=Contour.XYT(:,3)-Offset;
            end
          else
            T=Contour.XYT(:,3);
          end
          
          for i = 1:length(Contour.Ch_XY(:,1))
            t2=find(Contour.XYT(:,1)==Contour.Ch_XY(i,2) & Contour.XYT(:,2)==Contour.Ch_XY(i,3) );
            text(Xlim(1)+(Contour.Ch_XY(i,2)-Contour.Xlim(1)-0.25)*ScaleX, Ylim(1)+(Contour.Ch_XY(i,3)-Contour.Ylim(1))*ScaleY,num2str(min(T(t2))),'tag','Label','fontsize',Log.UD.Ref.FontSize)
            
          end
          
        case 'Ch+Time'
          if get(Contour.Check.Offset,'value')
            Offset=str2num(get(Contour.Edit.Offset,'string'));
            if isempty(Offset)
              Zeng_Error(['Please add a  number for the offset' char(13) 'OK !!!'])
              return
            else
              T=Contour.XYT(:,3)-Offset;
            end
            
            
            %if Offset>=0
            %    T=Contour.XYT(:,3)-Offset;
            %else
            %   Zeng_Error(['Please add a positive number for the offset' char(13) 'OK !!!'])
            %   set(Contour.Check.Offset,'value',0)
            %		set(Contour.Menu.Label,'Checked','off')
            %    return
            %end
          else
            T=Contour.XYT(:,3);
          end
          for i=1:length(Contour.Ch_XY(:,1))
            text(Xlim(1)+(Contour.Ch_XY(i,2)-Contour.Xlim(1)-0.25)*ScaleX,Ylim(1)+(Contour.Ch_XY(i,3)-Contour.Ylim(1)-0.2)*ScaleY,num2str(Contour.Ch_XY(i,1)),'tag','Label','fontsize',Log.UD.Ref.FontSize)
            t2=find(Contour.XYT(:,1)==Contour.Ch_XY(i,2) & Contour.XYT(:,2)==Contour.Ch_XY(i,3) );
            text(Xlim(1)+(Contour.Ch_XY(i,2)-Contour.Xlim(1)-0.25)*ScaleX,Ylim(1)+(Contour.Ch_XY(i,3)-Contour.Ylim(1)+0.2)*ScaleY,num2str(min(T(t2))),'tag','Label','fontsize',Log.UD.Ref.FontSize)
          end
      end
    end
    load ContourParams
    ContourParams.CheckLabel=action;
    save ContourParams ContourParams





    %---------------------------------------------
  case 'Plot TimeMap'
    %2)Contour.Figure, 3)Label, 4)Contour.CurrentPlot, 5)nothing & 'default';
    %'Plot TimeMap' has 2 standard.
    %1)nothing = You have to do everything
    %2)default = You already have Contout.XYT
    Contour=get(varargin{2},'userdata');
    Continue=0;
    Temp.Tmax=round(str2num(get(Contour.Edit.Tmax,'string')));
    Temp.Tmin=round(str2num(get(Contour.Edit.Tmin,'string')));
    Temp.Interval=str2num(get(Contour.Edit.Interval,'string'));
    if isempty(Temp.Tmax)
      Zeng_Error(['Tmin should be a number']);
    elseif  isempty(Temp.Tmin)
      Zeng_Error(['Tmax should be a number']);
    elseif  isempty(Temp.Interval) || Temp.Interval<=0
      Zeng_Error(['Time interval should be a number']);
    elseif Temp.Tmin>=Temp.Tmax
      Zeng_Error(['Tmin must be lower than Tmax. ']);
    else
      Stripchart=get(Contour.Parent,'userdata');
      if isempty(Stripchart.Annote.Array)
        Zeng_Error('You have no annotations in this segment.')
      else
        Temp.Index3=find( Stripchart.Annote.Array(:,2)>=Temp.Tmin & Stripchart.Annote.Array(:,2)<=Temp.Tmax);
        if strcmp(varargin{3},'Difference')

          %Temp.Index=find(Stripchart.Annote.Array(:,2)>=Temp.Tmin & Stripchart.Annote.Array(:,2)<=Temp.Tmax);
          % 5/8/23 SP changed Temp.Index=Temp.Index3 to =1 because of empty
          % set created by not having the right Tmin and Tmax for AP's in a
          % specific window of time.
          Temp.Index=1;
        else
          Temp.Index2=strmatch(varargin{3},Stripchart.Annote.Array(Temp.Index3,3:(2+Stripchart.Annote.ShowLength)));
          Temp.Index=Temp.Index3(Temp.Index2);
          if ~isempty(Temp.Index)
            Temp.Index=Temp.Index(find(Stripchart.Annote.Array(Temp.Index,2)>=Temp.Tmin &  Stripchart.Annote.Array(Temp.Index,2)<=Temp.Tmax));
          end
        end
        if isempty(Temp.Index)
          Zeng_Error('You have no annote in this segment');
          Zeng_Contour('CntrlVar',Contour.Figure,'Mapping Array')
        else
          if strcmp('Contour',varargin{4})
            Contour.Interval=Temp.Interval;
          end
          Contour.XYT=[];
          if strcmp(varargin{3},'Difference')
            Temp.sort=[];
            for i=1:length(Contour.Ch_XY)
              Temp.Ch=find(Stripchart.Annote.Array(:,1)==Contour.Ch_XY(i,1));
              if length(Temp.Ch)>1 %at least 2
                %it is also in the LUT
                TSort=sort(Stripchart.Annote.Array(Temp.Ch,2));
%                 TSort=sort(Stripchart.Annote.Array(Temp.Index(Temp.Ch),2));
                Temp.sort=[Temp.sort;TSort(1:2)'];
                Contour.XYT=[Contour.XYT;[Contour.Ch_XY(i,[2 3]) diff(TSort([1 2]))]];
              end
            end
            if ~isempty(Contour.XYT)
              Contour.Time=[min(Temp.sort(:,1)) max(Temp.sort(:,2))];
              Contour.DTime=[min(Contour.XYT(:,3)) max(Contour.XYT(:,3))];
            end
            
          else
            %Contour.Time's from Diff and unDiff are different
            Contour.Time=[Temp.Tmin Temp.Tmax];
            for i=1:length(Temp.Index)
              Temp.Ch=find(Contour.Ch_XY(:,1)==Stripchart.Annote.Array(Temp.Index(i),1));
              if ~isempty(Temp.Ch)
                %it is also in the LUT
                Contour.XYT=[Contour.XYT;[Contour.Ch_XY(Temp.Ch,[2 3]) Stripchart.Annote.Array(Temp.Index(i),2)]];
              end
            end
          end
          %We also need the image for vectors for time labeling.
          if isempty(Contour.XYT)
            Zeng_Error('No data in this segment');
          else
            Continue=1;
            if strcmp(varargin{4},'Vectors')
              Interp=1;
              Choice=1;
            else
              Choice=get(Contour.Pop.Interp,'value');
              if Choice==1  %None
                Interp=1;
              else
                Interp=get(Contour.Pop.Interp,'string');
                Interp=1+str2num(Interp(Choice,:));
              end
            end
            
            % CONTOUR CHANGES MADE 8/19/99 by Raymond Hwang, rwhwang@mit.edu
            % this code was altered to improve the contouring of concave patch arrays.
            % griddata was replaced with a modified version ("griddatacc") that handles
            % concavity more gracefully.
            %
            % if problems are encountered, the following changes will restore the
            % original interpolation/contour code:
            %
            % 1. find both calls to "griddatacc" and remove the last input argument.
            % "griddatacc" is called twice in the outer "if" statement below.  both calls
            % are identified below.
            %
            % 2. replace both calls to "griddatacc" with "griddata".
            %
            % 3. that's it.
            
            % START CONTOUR CHANGES -------
            
            %Contour.Image=nan*ones(max(Contour.Ch_XY(:,3)),max(Contour.Ch_XY(:,2)));
            Contour.Image=nan*ones(length(1:(1/Interp):max(Contour.Ch_XY(:,3))),length(1:(1/Interp):max(Contour.Ch_XY(:,2))));
            if Choice==1
                for i=1:length(Contour.XYT(:,1))
                    Contour.Image(Contour.XYT(i,2),Contour.XYT(i,1))=Contour.XYT(i,3);
                end
            else

              if isempty(Contour.Interp_Segment)
                %For Optical system
                [X, Y]=meshgrid(1:(1/Interp):max(Contour.Ch_XY(:,2)),1:(1/Interp):max(Contour.Ch_XY(:,3)));
                % "griddatacc" called here (1)
                %Contour.Image=round(griddatacc(Contour.XYT(:,1),Contour.XYT(:,2),Contour.XYT(:,3),X,Y,'cubic',Contour.Edge_Max));
                
                Contour.Image=round(griddata(Contour.XYT(:,1),Contour.XYT(:,2),Contour.XYT(:,3),X,Y,'cubic'));
              else
               for i=1:length(Contour.Interp_Segment(:,1))
                  if chkline(Contour.Interp_Segment(i,:)) % checks for a line of electrodes (colinear nodes)
                    [X, Y]=meshgrid(Contour.Interp_Segment(i,1):(1/Interp):Contour.Interp_Segment(i,3),Contour.Interp_Segment(i,2):(1/Interp):Contour.Interp_Segment(i,4));
                    YX=size(X);
                    Contour.Image( (Y(1)-1)*Interp+(1:YX(1)),(X(1)-1)*Interp+(1:YX(2)))=round(griddata(Contour.XYT(:,1),Contour.XYT(:,2),Contour.XYT(:,3),X,Y,'cubic'));
                  else
                    [X, Y]=meshgrid(Contour.Interp_Segment(i,1):(1/Interp):Contour.Interp_Segment(i,3),Contour.Interp_Segment(i,2):(1/Interp):Contour.Interp_Segment(i,4));
                    YX=size(X);
                    % "griddatacc" called here (2)
                    %Contour.Image( (Y(1)-1)*Interp+(1:YX(1)),(X(1)-1)*Interp+(1:YX(2)))=round(griddatacc(Contour.XYT(:,1),Contour.XYT(:,2),Contour.XYT(:,3),X,Y,'cubic',Contour.Edge_Max));
                    Contour.Image( (Y(1)-1)*Interp+(1:YX(1)),(X(1)-1)*Interp+(1:YX(2)))=round(griddata(Contour.XYT(:,1),Contour.XYT(:,2),Contour.XYT(:,3),X,Y,'cubic'));
                  end
                end
              end
            end
            



            % END CONTOUR CHANGES -------
            
            delete(get(Contour.Axes,'children'));
            axes(Contour.Axes)
            
            ClrLength=size(get(Contour.Figure,'colormap'),1);
            Cmax=max(max(Contour.Image));
            Cmin=min(min(Contour.Image));
            Temp.Image=1+(ClrLength-1)*(Contour.Image-Cmin)/(Cmax-Cmin);
            Size_Image=size(Contour.Image);
            
            switch varargin{4}
              case 'Contour'
                if get(Contour.Check.Color,'value')
                  %[c d]=contourf(Contour.Image,length(Contour.Time(1):Contour.Interval:Contour.Time(2))-1);
                  %The following Lines were added to accomodate Difference Isochrones
                  a=get(Contour.Menu.CntrlVar);
                  b=get(a.Children(3),'Checked');
                  % The following commented out lines were removed by Steven Poelzing on January 21st 2002
                  if strcmp(b,'on')
                    [c, d]=contourf(Contour.Image,[min(min(Contour.Image)):Contour.Interval:max(max(Contour.Image))-1]);
                    a=Contour.Image;
                    %   save temp a
                  else
                    [c, d]=contourf(Contour.Image,[Contour.Time(1):Contour.Interval:(Contour.Time(2)-1)]);
                  end
                  
                else
                  %[c d]=contour(Contour.Image,length(Contour.Time(1):Contour.Interval:Contour.Time(2))-1,'k');
                  a=get(Contour.Menu.CntrlVar);
                  b=get(a.Children(3),'Checked');
                  if strcmp(b,'on')
                      % Commented out 02/17/23 by SP because I don't know
                      % why this doesn't consider interval
                      % [c, d]=contour(Contour.Image,'k');
                    [c, d]=contour(Contour.Image,[Contour.Time(1):Contour.Interval:(Contour.Time(2)-1)],'k');
                  else
                    [c, d]=contour(Contour.Image,[Contour.Time(1):Contour.Interval:(Contour.Time(2)-1)],'k');
                  end
                end
                set(findobj(Contour.Frame,'tag','Vector Type'),'enable','off');
                % set(findobj(Contour.Figure,'Tag','Average'),'visible','off');
                % keep visible!
                set(findobj(Contour.Figure,'tag','Contour Type'),'enable','on');
                set([Contour.Text.Tmin Contour.Edit.Tmin, Contour.Text.Tmax, Contour.Edit.Tmax Contour.Check.Offset Contour.Edit.Offset Contour.Text.Interp Contour.Pop.Interp],'enable','on');
                % Commented out 2021 by SP % set(findobj(Contour.Frame,'tag','Time Type'),'enable','on');
                
                %set(Contour.Axes,'xlim',[min(Contour.Ch_XY(:,2))-Interp*.5 Size_Image(2)+Interp*.5],'ylim',[min(Contour.Ch_XY(:,3))-Interp*.5 Size_Image(1)+Interp*.5]);
                set(Contour.Axes,'xlim',[min(Contour.Ch_XY(:,2))-.5 Size_Image(2)+0.5],'ylim',[min(Contour.Ch_XY(:,3))-.5 Size_Image(1)+.5]);
                %                   axis square
              case 'Image'
                bsteve=Contour.Image;
                %bsteve=temporary(find(temporary<100000))
                save junk bsteve
                set(Contour.Button.Quadrant,'Enable','on');
                Contour.ImageHD=imagesc(Contour.Image);
                %set(Contour.ImageHD,'EraseMode','xor')
                set(findobj(Contour.Frame,'tag','Vector Type'),'enable','off');
                % set(findobj(Contour.Figure,'Tag','Average'),'visible','off');
                % keep visible!
                set(findobj(Contour.Figure,'tag','Contour Type'),'enable','off');
                set([Contour.Text.Tmin Contour.Edit.Tmin, Contour.Text.Tmax, Contour.Edit.Tmax Contour.Check.Offset Contour.Edit.Offset Contour.Text.Interp Contour.Pop.Interp],'enable','on');
                % Commented out 2021 by SP % set(findobj(Contour.Frame,'tag','Time Type'),'enable','on');
                %set(Contour.Axes,'xlim',[min(Contour.Ch_XY(:,2))-Interp*.5 Size_Image(2)+Interp*.5],'ylim',[min(Contour.Ch_XY(:,3))-Interp*.5 Size_Image(1)+Interp*.5]);
                set(Contour.Axes,'xlim',[min(Contour.Ch_XY(:,2))-.5 Size_Image(2)+0.5],'ylim',[min(Contour.Ch_XY(:,3))-.5 Size_Image(1)+.5]);
                %                   axis square
                
              case 'Vectors'
                set(Contour.Button.Auto,'Enable','on');
                %use Contour.ImageHD for being a blackground when you click it and want to change the black ground color
                %         Contour.Image=Contour.Image*0+1;
                %         Contour.ImageHD=image(Contour.Image);
                %         set(Contour.ImageHD,'erasemode','xor');
                Contour.Type.Ch=[];
                Contour.Vector=Velcal(Contour.XYT,Contour.VP);
                if isempty(Contour.Vector.V)
                  Continue=0;
                else
                  if get(Contour.Check.Inverse,'value')
                    %Vector=quiver(Contour.Vector.X,Contour.Vector.Y,1./Contour.Vector.Vx,1./Contour.Vector.Vy);
                    Mag2=Contour.Vector.Vx.^2+Contour.Vector.Vy.^2;
                    Vector=quiver(Contour.Vector.X,Contour.Vector.Y,Contour.Vector.Vx./Mag2,Contour.Vector.Vy./Mag2);
                  else
                    Vector=quiver(Contour.Vector.X,Contour.Vector.Y,Contour.Vector.Vx,Contour.Vector.Vy);
                  end
                  
                  set(Vector(1),'color',[0 0 0])
                  % Line Below commented out by Poelzing 05/16/2006
                  %     set(Vector(2),'color',[0 0 0])
                  set(gca,'xtick',[],'ytick',[])
                  
                  set(Contour.Axes,'xlim',[min(Contour.Ch_XY(:,2))-.5 max(Contour.Ch_XY(:,2))+.5],'ylim',[min(Contour.Ch_XY(:,3))-.5 max(Contour.Ch_XY(:,3))+.5]);
                  %axis([-2 (XYTmax(1)+2) -2 (XYTmax(2)+2)])
                  Zeng_Contour('average label',Contour);
                  set([Contour.Text.Vector, Contour.Text.AverageL,  Contour.Text.STD, Contour.Text.MagnitudeL, Contour.Text.MagnitudeA, Contour.Text.MagnitudeS, Contour.Text.AngleL, Contour.Text.AngleC, Contour.Text.AngleA],'enable','on')

                  set(findobj(Contour.Figure,'Tag','Average'),'visible','on');
                  set(findobj(Contour.Frame,'tag','Vector Type'),'enable','on');
                  set(findobj(Contour.Figure,'tag','Contour Type'),'enable','off');
                  set(findobj(Contour.Frame,'tag','Time Type'),'enable','off');
                  
                  set(Contour.Text.MagnitudeC,'string',' ');
                  set(Contour.Text.AngleC,'string',' ');
                  set(Contour.Text.MagnitudeA,'string',' ');
                  set(Contour.Text.AngleA,'string',' ');
                  set(Contour.Text.MagnitudeS,'string',' ');
                  set(Contour.Text.AngleS,'string',' ');
                end%                  if isempty(Contour.Vector.V)
            end%switch varargin{4}
            
            if Continue
              axes(Contour.Axes)
              if strcmp(varargin{3},'Difference')
                caxis([Contour.DTime]);
              else
                caxis([Contour.Time]);
              end
              
              Contour.CurrentPlot=varargin{4};
              % Contour.HDColorbar=colorbar;
              set(Contour.Figure,'userdata',Contour);
              %Offset always has to be before Label
              Zeng_Contour('Offset',Contour.Figure)%,Contour.Check.Offset,Contour.HDColorbar,Contour.Time,Temp.ClrLength);
              if strcmp('off',get(findobj(Contour.Menu.Label,'tag','Time'),'checked'))
                Zeng_Contour('Label',Contour.Figure)
              end
            end %if Continue
          end %if isempty(Contour.XYT)
        end %if isempty(Temp.Index)
      end %   if isempty(Stripchart.Annote.Array)
    end %if
    
    bsteve=Contour.Image;
    %bsteve=temporary(find(temporary<100000))
    save junk bsteve
    set(Contour.Button.Quadrant,'Enable','on');
    varargout{1}=Continue;
    
    
      set(Contour.Text.RVB,'String',[]);
      set(Contour.Text.LVB,'String',[]);
      set(Contour.Text.RVA,'String',[]);
      set(Contour.Text.LVA,'String',[]);
      set(Contour.Text.Area,'String','5');
    
  case 'average label'
    Contour=varargin{2};
    axes(Contour.Axes)
    delete(findobj(gca,'tag','average label'))
    
    if get(Contour.Check.Inverse,'value')
      Inverse=-1;
    else
      Inverse=1;
    end
    
    Vmin=sprintf('%0.2f',min(min(Contour.Vector.V.^Inverse)));
    Vmax=sprintf('%0.2f',max(max(Contour.Vector.V.^Inverse)));
    Mean=sprintf('%0.2f',mean(Contour.Vector.V.^Inverse));
    StdV=sprintf('%0.3f',std(Contour.Vector.V.^Inverse));
    
    Xmax=max(get(gca,'xlim'));
    if Contour.YDir==1 %normal
      Zeng('Error',['Something bad in Contour "ydir"' char(13)  'Contact Zeng'])
    else
      Ymax=max(get(gca,'ylim'));
      set(Contour.Text.Mean,'string',['Mean = ' Mean ' m/s'])
      set(Contour.Text.Std,'string',['Std  = ' StdV ' m/s'])
      set(Contour.Text.Min,'string',['Vmin = ' Vmin ' m/s'])
      set(Contour.Text.Max,'string',['Vmax  = ' Vmax ' m/s'])
    end
    
  case 'Offset'
    %Zeng_Contour('Offset',Contour.Check.Offset,Contour.HDColorbar,Contour.Time,Temp.ClrLength);
    Contour=get(varargin{2},'userdata');
    axes(Contour.Axes);
    ClrLength=size(get(Contour.Figure,'colormap'),1);
    Temp.A=get(Contour.Axes,'position');
    Temp.F=get(Contour.Figure,'position');
    Contour.Time=[str2num(get(Contour.Edit.Tmin,'string')) str2num(get(Contour.Edit.Tmax,'string'))];
    Ylim=[Contour.Time(1), Contour.Time(2)];
    YTick=round(linspace(Contour.Time(1), Contour.Time(2),6));
    Offset=str2num(get(Contour.Edit.Offset,'string'));
    
    if strcmp(Contour.CurrentPlot,'Image') || (strcmp(Contour.CurrentPlot,'Contour') && get(Contour.Check.Color,'value'))
      %the Ylimit of colorbar is different between Image-color and contour-vector
      if get(Contour.Check.Offset,'value')
        Offset=str2num(get(Contour.Edit.Offset,'string'));
        if isempty(Offset)
          Zeng_Error(['Please add a  number for the offset' char(13) 'OK !!!'])
          return
        else
          Ylabel=YTick-Offset;
        end
        
        %   		if Offset>=0
        %         Ylabel=YTick-Ylim(1)-Offset;
        %         else
        %	         Zeng_Error(['Please add a positive number for the offset' char(13) 'OK !!!'])
        %            set(Contour.Check.Offset,'value',0)
        %            return
        %         end
      else
         Ylabel=YTick;
      end
      set(Contour.HDColorbar,'location','eastoutside') % ensures colorbar is to right of contour plot
    else %for contour-vector
      if get(Contour.Check.Offset,'value')
        Offset=str2num(get(Contour.Edit.Offset,'string'));
        if isempty(Offset)
          Zeng_Error(['Please add a  number for the offset' char(13) 'OK !!!'])
          return
        else
            Ylabel=YTick-Offset;
%           SP commented out 02/17/23 because it wasn't working correctly
%           Ylabel=round(YTick/(ClrLength)*(diff(Contour.Time))+Contour.Time(1)-Offset);
        end
        %   		if Offset>=0
        %     		Ylabel=round(YTick/(ClrLength)*(diff(Contour.Time))+Offset);
        %      	else
        %		      Zeng_Error(['Please add a positive number for the offset' char(13) 'OK !!!'])
        %      		set(Contour.Check.Offset,'value',0)
        %               return
        %         	end
      else
         Ylabel=YTick;
         % Commented out SP 02/17/23 because not sure why it was added
%         Ylabel=round(YTick/(ClrLength)*(diff(Contour.Time))+Contour.Time(1))
      end
      set(Contour.HDColorbar,'unit','pixel','position',[Temp.F(3)-50 Temp.A(2) 20 Temp.A(4)],'ytick',YTick,'YTickLabel',Ylabel);
    end
      set(Contour.HDColorbar,'unit','pixel','position',[Temp.F(3)-50 Temp.A(2) 20 Temp.A(4)],'ytick',YTick,'YTickLabel',Ylabel,'location','eastoutside');
    Temp=[findobj(Contour.Menu.Label,'checked','on','tag','Time') findobj(Contour.Menu.Label,'checked','on','tag','Ch+Time')];
    if ~isempty(Temp)
      delete(findobj(Contour.Axes,'tag','Label'))
      Zeng_Contour('Label',Contour.Figure);
    end
    
  case 'Mouse Down'
    Contour=get(gcbf,'userdata');
    if get(Contour.CheckBox.WaveForm,'Value')
      Zeng_Contour('Rotate WaveForm');
    end
    %I have to reload
    Contour=get(Contour.Figure,'userdata');
    
    figure(Contour.Figure);
    if ~strcmp(Contour.Analysis,'Mapping Array') && strcmp(Contour.CurrentPlot,'Vectors')
      Temp.currentpoint=get(Contour.Axes,'currentpoint');
      Temp.currentpoint=round(Temp.currentpoint(1,1:2));
      %Temp.Ch=find(Contour.Ch_XY(:,2)==Temp.currentpoint(1) &  Contour.Ch_XY(:,3)==Temp.currentpoint(2));
      V=[Contour.Vector.X Contour.Vector.Y];
      Temp.Ch=find(V(:,1)==Temp.currentpoint(1) &  V(:,2)==Temp.currentpoint(2));
      if ~isempty(Temp.Ch)
        if isempty(Contour.Type.Ch)
          %Plot the marker
          Zeng_Contour('Marker',Contour.Figure,Contour.Ch_XY(Temp.Ch,1),Temp.currentpoint);
        else
          Temp.Current=find(Contour.Type.Ch==Contour.Ch_XY(Temp.Ch,1));
          
          if  isempty(Temp.Current)
            Zeng_Contour('Marker',Contour.Figure,Contour.Ch_XY(Temp.Ch,1),Temp.currentpoint);
          else
            Contour.Type.Ch(Temp.Current)=[];
            set(Contour.Figure,'userdata',Contour);
            delete(findobj(Contour.Axes,'type','patch','tag',num2str(Contour.Ch_XY(Temp.Ch,1))))
            if isempty(findobj(Contour.Axes,'type','patch','Marker','+','MarkerEdgeColor',[1 0 0]));
              if ~isempty(Contour.Type.Ch)
                set(findobj('type','patch','Marker','+','tag',num2str(Contour.Type.Ch(length(Contour.Type.Ch)))),'MarkerEdgeColor',[1 0 0])
              end
            end
          end
        end
        Zeng_Contour('Vector Label',Contour.Figure)
        
      end%if ~isempty(Temp.Ch)
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ANALYZE QUADRANT INFORMATION
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if get(Contour.CheckBox.Area,'Value')==1 && get(Contour.Button.Quadrant,'Enable')=='on' 
        load junk;
      [rows,cols]=size(bsteve);
      Temp.currentpoint=get(Contour.Axes,'currentpoint');
      Temp.currentpoint=round(Temp.currentpoint(1,1:2));
      Areas=str2num(get(Contour.Text.Area,'String'));
      if mod(Areas,2)==0
        Contour.Range=Areas/2;
        set(Contour.Text.Area,'String',num2str(Areas+1));
      else
        Contour.Range=floor(Areas/2);
      end
      
      if Temp.currentpoint(1,2)-Contour.Range<1
        qrstart=1;
        qrend=Temp.currentpoint(1,2)+Contour.Range;
      elseif Temp.currentpoint(1,2)+Contour.Range>rows
        qrend=rows;
        qrstart=Temp.currentpoint(1,2)-Contour.Range;
      else
        qrstart=Temp.currentpoint(1,2)-Contour.Range;
        qrend=Temp.currentpoint(1,2)+Contour.Range;
      end
      if Temp.currentpoint(1,1)-Contour.Range<1
        qcstart=1;
        qcend=Temp.currentpoint(1,1)+Contour.Range;
      elseif Temp.currentpoint(1,1)+Contour.Range>cols
        qcend=cols;
        qcstart=Temp.currentpoint(1,1)-Contour.Range;
      else
        qcstart=Temp.currentpoint(1,1)-Contour.Range;
        qcend=Temp.currentpoint(1,1)+Contour.Range;
      end
      %
      % [qrstart qcstart]
      % [qrend qcend]
      % bsteve(qrstart:qrend,qcstart:qcend)
      temp2=bsteve(qrstart:qrend,qcstart:qcend);
      
      
      if Qdr.wquad==1
        Qdr.wquad=Qdr.wquad+1;
        TFOffset=get(Contour.Text.TFOffset,'Value');
        if TFOffset==1
          offset=str2num(get(Contour.Text.Offset,'String'));
        else
          offset=0;
        end
        RVB=mean(temp2(find(isfinite(temp2))))-offset;
        
        set(Contour.Text.RVB,'String',num2str(RVB));
      elseif Qdr.wquad==2
        Qdr.wquad=Qdr.wquad+1;
        TFOffset=get(Contour.Text.TFOffset,'Value');
        if TFOffset==1
          offset=str2num(get(Contour.Text.Offset,'String'));
        else
          offset=0;
        end
        LVB=mean(temp2(find(isfinite(temp2))))-offset;
        set(Contour.Text.LVB,'String',num2str(LVB));
      elseif Qdr.wquad==3
        Qdr.wquad=Qdr.wquad+1;
        TFOffset=get(Contour.Text.TFOffset,'Value');
        if TFOffset==1
          offset=str2num(get(Contour.Text.Offset,'String'));
        else
          offset=0;
        end
        RVA=mean(temp2(find(isfinite(temp2))))-offset;
        set(Contour.Text.RVA,'String',num2str(RVA));
      elseif Qdr.wquad==4
        Qdr.wquad=1;
        TFOffset=get(Contour.Text.TFOffset,'Value');
        if TFOffset==1
          offset=str2num(get(Contour.Text.Offset,'String'));
        else
          offset=0;
        end
        LVA=mean(temp2(find(isfinite(temp2))))-offset;
        set(Contour.Text.LVA,'String',num2str(LVA));
        RVB=str2num(get(Contour.Text.RVB,'String'));
        LVB=str2num(get(Contour.Text.LVB,'String'));
        RVA=str2num(get(Contour.Text.RVA,'String'));
        TFOffset=get(Contour.Text.TFOffset,'Value');
        if TFOffset==1
          offset=str2num(get(Contour.Text.Offset,'String'));
        else
          offset=0;
        end
        [RVB LVB RVA LVA]';
      else
        Qdr.wquad==1;
      end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 'Rotate WaveForm'
    Contour=get(gcbf,'userdata');
    if strcmp(Contour.Analysis,'Mapping Array') || strcmp(Contour.CurrentPlot,'Vectors')
      Interp=1;
    else
      Choice=get(Contour.Pop.Interp,'value');
      if Choice==1
        Interp=1;
      else
        Interp=get(Contour.Pop.Interp,'string');
        Interp=1+str2num(Interp(Choice,:));
      end
    end
    Temp.currentpoint=get(Contour.Axes,'currentpoint');
    Temp.currentpoint=round((Temp.currentpoint(1,1:2)+Interp-1)/Interp);
    Temp.currentpoint(1)=Temp.currentpoint(1);
    %Temp.currentpoint=round(get(LUTDisplay.Axes,'currentpoint'));
    %Temp.currentpoint=Temp.currentpoint(1,1:2);
    Temp.Ch=find(Contour.Ch_XY(:,2)==Temp.currentpoint(1) &  Contour.Ch_XY(:,3)==Temp.currentpoint(2));
    if ~isempty(Temp.Ch)
      Temp.Ch=Contour.Ch_XY(Temp.Ch,1);
      Stripchart=get(Contour.Parent,'userdata');
      Temp.WaveForm=findobj(0,'tag','WaveForm','color',Contour.Color,'name',[Stripchart.Head.FileName ':' 'WaveForm']);
      if isempty(Temp.WaveForm)
        Zeng_WaveForm('Initial')
      end
      Temp.WaveForm=findobj(0,'tag','WaveForm','color',Contour.Color,'name',[Stripchart.Head.FileName ':' 'WaveForm']);
      if isempty(Temp.WaveForm)
        Zeng_Error(['I will work when you have WaveForm window.' char(13) 'Remove "Show Waveform option" or Create a WaveForm window for me.. ' 'OK'])
      else
        WaveForm=get(Temp.WaveForm,'userdata');
        Temp.UnFix=findobj(WaveForm.Ch.CheckBox.Fix,'value',0);
        Temp.LengthUnFix=length(Temp.UnFix);
        if Temp.LengthUnFix<1
        else
          Temp.CurrentAxes=rem(Contour.CurrentAxes,Temp.LengthUnFix);
          if Temp.CurrentAxes==0
            Temp.CurrentAxes=Temp.LengthUnFix;
          end
          Temp.CurrentAxes=find(WaveForm.Ch.CheckBox.Fix==Temp.UnFix(Temp.CurrentAxes));
          Contour.CurrentAxes=Contour.CurrentAxes+1;
          if Contour.CurrentAxes>Temp.LengthUnFix
            Contour.CurrentAxes=Contour.CurrentAxes-Temp.LengthUnFix;
          end
          WaveForm.Ch.Current_ch(Temp.CurrentAxes)=Temp.Ch;
          set(WaveForm.Figure,'userdata',WaveForm);
          set(Contour.Figure,'userdata',Contour);
          set(WaveForm.Ch.Edit.Channel(Temp.CurrentAxes),'string',Temp.Ch);
          Zeng_WaveForm('Update WaveForm',WaveForm.Figure,Temp.CurrentAxes)
          
        end%         if Temp.LengthUnFix<1
      end%      if isempty(Temp.WaveForm)
    end%if ~isempty(Temp.Ch)
    
  case 'Marker'
    Contour=get(varargin{2},'userdata');
    Ch=varargin{3};
    XY=varargin{4};
    LastMarker=findobj(Contour.Axes,'type','patch','Marker','+','MarkerEdgeColor',[1 0 0]);
    if ~isempty(LastMarker)
      set(LastMarker,'MarkerEdgeColor',[0 0 1])
    end
    
    axes(Contour.Axes);
    Marker=patch(...
      'CData',[],...
      'CDataMapping','scaled',...
      'FaceVertexCData',[],...	         'EdgeColor',[[0.5+[rand rand rand]/2]],...
      'EraseMode','xor',...
      'FaceColor',[1 0 0],...
      'Faces',[1 2 3 4 5],...
      'LineStyle','-',...
      'LineWidth',4,...
      'Marker','+',...%Don't change
      'MarkerEdgeColor',[1 0 0],...%Don't change
      'MarkerFaceColor',[1 0 0],...%Don't change
      'MarkerSize',[6],...
      'tag',num2str(Ch),...
      'XData',[XY(1)],...
      'YData',[XY(2)]);
    Contour.Type.Ch=[Contour.Type.Ch;Ch];
    set(Contour.Figure,'userdata',Contour)
    
  case 'Vector Label'
    Contour=get(varargin{2},'userdata');
    %Vector=quiver(Contour.Vector.X,Contour.Vector.Y,Contour.Vector.Vx,Contour.Vector.Vy);
    CMarker=findobj(Contour.Axes,'type','patch','Marker','+','MarkerEdgeColor',[1 0 0]);
    if get(Contour.Check.Inverse,'value')
      Inverse=-1;
    else
      Inverse=1;
    end
    
    if ~isempty(CMarker)
      Ch=find( Contour.Vector.X==get(CMarker,'XData') & Contour.Vector.Y==get(CMarker,'YData'));
      if ~isempty(Ch)
        %a=sprintf('%0.5f',b)
        set(Contour.Text.MagnitudeC,'string',sprintf('%0.2f',Contour.Vector.V(Ch).^Inverse));
        TheAngle=round(180/pi*atan2(Contour.YDir*Contour.Vector.Vy(Ch),Contour.Vector.Vx(Ch)));
        if TheAngle<0
          TheAngle=360+TheAngle;
        end
        set(Contour.Text.AngleC ,'string',TheAngle);
      end
    else
      set(Contour.Text.MagnitudeC,'string','');
      set(Contour.Text.AngleC ,'string',' ');
      
    end
    
    if isempty(Contour.Type.Ch)
      set(Contour.Text.MagnitudeA,'string',' ');
      set(Contour.Text.AngleA,'string',' ');
    else
      Ch=[];
      for n=1:length(Contour.Type.Ch)
        Marker=findobj(Contour.Axes,'type','patch','Marker','+','tag',num2str(Contour.Type.Ch(n)));
        if ~isempty(Marker)
          Temp=find( Contour.Vector.X==get(Marker,'XData') & Contour.Vector.Y==get(Marker,'YData'));
          if ~isempty(Temp)
            Ch=[Ch Temp];
          end
        end
      end
      if ~isempty(Ch)
        set(Contour.Text.MagnitudeA,'string',sprintf('%0.2f',sum(Contour.Vector.V(Ch).^Inverse)/length(Ch)));
        set(Contour.Text.MagnitudeS,'string',sprintf('%0.3f',std(Contour.Vector.V(Ch).^Inverse)));
        
        TheAngle=round(180/pi*(atan2(Contour.YDir*Contour.Vector.Vy(Ch),Contour.Vector.Vx(Ch))));
        Swarp=find(TheAngle<0);
        if ~isempty(Swarp)
          TheAngle(Swarp)=360+TheAngle(Swarp);
        end
        set(Contour.Text.AngleA ,'string',sprintf('%d',round(sum(TheAngle)/length(Ch))));
        set(Contour.Text.AngleS ,'string',sprintf('%0.1f',std(TheAngle)));
        
      else
        set(Contour.Text.MagnitudeA,'string',' ');
        set(Contour.Text.AngleA,'string',' ');
        set(Contour.Text.MagnitudeS,'string',' ');
        set(Contour.Text.AngleS,'string',' ');
        
      end
      
    end
  case 'Vel Setting'
    Contour=get(varargin{2},'userdata');
    load ContourParams
    Contour.VP=ContourParams;
    if ~isfield(Contour.VP,'X')
      Contour.VP.X=0.38;
      Contour.VP.Y=0.38;
      Contour.VP.how_nearxy=4; %only 1-3
      Contour.VP.how_neart=200;
      Contour.VP.how_many=12;
      Contour.VP.resthresh=0.8;
      Contour.VP.Vmin=0.01;
      Contour.VP.Vmax=1;
      Contour.VP.VPosition=[75, 495, 328,305];
      %                 'Position',[FG_Size(1) sum(FG_Size([2 4]))-305 328 305], ...
      Contour.Default.VP=Contour.VP;
    end
    
    Contour.VP.Srate=Stripchart.Head.SRate;
    if ~isempty(Contour.FGV) && ishandle(Contour.FGV.Figure)
      figure(Contour.FGV.Figure);
    else
      Stripchart=get(Contour.Parent,'userdata');
      FG_Size=get(Contour.Figure,'position');
      Contour.FGV.Figure=figure;
      Color=get(Contour.Figure,'Color');
      set(Contour.FGV.Figure,'Units','pixels', ...
        'Color',Color, ...%     'HandleVisibility','off',...
        'DeleteFcn','Zeng_Contour(''VP DeleteFcn'');',...
        'menu','none',...
        'Name',[Stripchart.Head.FileName ':Contour'],...
        'NumberTitle','off',...
        'unit','pixel',...
        'PaperPositionMode','auto',...
        'Position',Contour.VP.VPosition, ...
        'Resize','off',...
        'selected','on',...
        'Tag','FGV',...
        'userdata',Contour.Figure);
      %-----------------------------
      Contour.FGV.Text.X = uicontrol('Parent',Contour.FGV.Figure, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','right', ...
        'ListboxTop',0, ...
        'Position',[12 200.5 199.5 24.75], ...
        'String','Distance between mapping sites - X  (mm) ', ...
        'Style','text', ...
        'Tag','StaticText1');
      
      Contour.FGV.Edit.X = uicontrol('Parent',Contour.FGV.Figure, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'ListboxTop',0, ...
        'Position',[213 211 30 15], ...
        'Style','edit', ...
        'String',num2str(Contour.VP.X), ...
        'Tag','StaticText1');
      
      Contour.FGV.Text.Y = uicontrol('Parent',Contour.FGV.Figure, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','right', ...
        'ListboxTop',0, ...
        'Position',[12 175.5 200 25], ...
        'String','Distance between mapping sites -Y  (mm) ', ...
        'Style','text', ...
        'Tag','StaticText1');
      Contour.FGV.Edit.Y = uicontrol('Parent',Contour.FGV.Figure, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'ListboxTop',0, ...
        'Position',[213 186 30 15], ...
        'String',num2str(Contour.VP.Y), ...
        'Style','edit', ...
        'Tag','StaticText1');
      
      Contour.FGV.Text.NearXY = uicontrol('Parent',Contour.FGV.Figure, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','right', ...
        'ListboxTop',0, ...
        'Position',[12 150.5 200 25], ...
        'String','Distance over which vectors are calculated (#pixels) ', ...
        'Style','text', ...
        'Tag','StaticText1');
      Contour.FGV.Pop.NearXY = uicontrol('Parent',Contour.FGV.Figure, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'ListboxTop',0, ...
        'Position',[213.75 160.5 33 15], ...
        'String','   1|   2|   3|   4 ', ...
        'Style','popupmenu', ...
        'Tag','PopupMenu1', ...
        'Value',Contour.VP.how_nearxy);
      
      Contour.FGV.Text.NearT = uicontrol('Parent',Contour.FGV.Figure, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','right', ...
        'ListboxTop',0, ...
        'Position',[12 125.5 200 25], ...
        'String','Time over which vectors are calculated (ms) ', ...
        'Style','text', ...
        'Tag','StaticText1');
      Contour.FGV.Edit.NearT = uicontrol('Parent',Contour.FGV.Figure, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'ListboxTop',0, ...
        'Position',[213 136 30 15], ...
        'Style','edit', ...
        'String',num2str(Contour.VP.how_neart), ...
        'Tag','StaticText1');
      
      Contour.FGV.Text.Many = uicontrol('Parent',Contour.FGV.Figure, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','right', ...
        'ListboxTop',0, ...
        'Position',[12 100.5 200 25], ...
        'String','Min number of sites to include  (#sites) ', ...
        'Style','text', ...
        'Tag','StaticText1');
      Contour.FGV.Edit.Many = uicontrol('Parent',Contour.FGV.Figure, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'ListboxTop',0, ...
        'Position',[213 111 30 15], ...
        'Style','edit', ...
        'String',num2str(Contour.VP.how_many), ...
        'Tag','EditText1');
      Contour.FGV.Text.Resthresh = uicontrol('Parent',Contour.FGV.Figure, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','right', ...
        'ListboxTop',0, ...
        'Position',[12 75.5 200 25], ...
        'String','Max allowable error for each vector (Red error) ', ...
        'Style','text', ...
        'Tag','StaticText1');
      Contour.FGV.Edit.Resthresh = uicontrol('Parent',Contour.FGV.Figure, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'ListboxTop',0, ...
        'Position',[213 85.5 30 15], ...
        'Style','edit', ...
        'String',num2str(Contour.VP.resthresh), ...
        'Tag','EditText1');
      Contour.FGV.Text.Vmin = uicontrol('Parent',Contour.FGV.Figure, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','right', ...
        'ListboxTop',0, ...
        'Position',[12 50.5 200 25], ...
        'String','Min allowable vector magnitude (m/s) ', ...
        'Style','text', ...
        'Tag','StaticText1');
      Contour.FGV.Edit.Vmin = uicontrol('Parent',Contour.FGV.Figure, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'ListboxTop',0, ...
        'Position',[213 61 30 15], ...
        'String',num2str(Contour.VP.Vmin), ...
        'Style','edit', ...
        'Tag','EditText1');
      Contour.FGV.Text.Vmax = uicontrol('Parent',Contour.FGV.Figure, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'HorizontalAlignment','right', ...
        'ListboxTop',0, ...
        'Position',[12 25.5 200 25], ...
        'String','Max allowable vector magnitude (m/s) ', ...
        'Style','text', ...
        'Tag','StaticText1');
      Contour.FGV.Edit.Vmax = uicontrol('Parent',Contour.FGV.Figure, ...
        'Units','points', ...
        'BackgroundColor',[1 1 1], ...
        'ListboxTop',0, ...
        'Position',[212.25 36 30 15], ...
        'Style','edit', ...
        'String',num2str(Contour.VP.Vmax), ...
        'Tag','EditText1');
      
      
      Contour.FGV.Button.Default = uicontrol('Parent',Contour.FGV.Figure, ...
        'ListboxTop',0, ...
        'Position',[20 12 45 20], ...
        'String','Default', ...
        'Tag','Pushbutton1',...
        'callback','Zeng_Contour(''Default V'')');
      Contour.FGV.Button.Apply = uicontrol('Parent',Contour.FGV.Figure,...
        'ListboxTop',0, ...
        'Units','pixel',...
        'Position',[80 12 45 20], ...
        'String','Apply', ...
        'callback','Zeng_Contour(''VP Check'',''Apply'')');
      Contour.FGV.Button.Ok = uicontrol('Parent',Contour.FGV.Figure,...
        'ListboxTop',0, ...
        'Units','pixel',...
        'Position',[150 12 45 20], ...
        'String','Ok', ...
        'callback','Zeng_Contour(''VP Check'',''Ok'')');
      Contour.FGV.Button.Cancel = uicontrol('Parent',Contour.FGV.Figure,...
        'ListboxTop',0, ...
        'Units','pixel',...
        'Position',[210 12 45 20], ...
        'String','Cancel', ...
        'callback','Zeng_Contour(''VP DeleteFcn'')');
      
      set(Contour.Figure,'userdata',Contour)
      
    end
    
    
  case 'VP Check'
    Contour.Figure=get(gcbf,'userdata');
    Contour=get(Contour.Figure,'userdata');
    Continue=1;
    
    Temp=str2num(get(Contour.FGV.Edit.X,'string'));
    if ~isempty(Temp)
      Contour.VP.X=Temp;
      Temp=str2num(get(Contour.FGV.Edit.Y,'string'));
      if ~isempty(Temp)
        Contour.VP.Y=Temp;
        Temp=get(Contour.FGV.Pop.NearXY,'value');
        if ~isempty(Temp)
          Contour.VP.how_nearxy=Temp;
          %Temp=str2num(get(Contour.FGV.Edit.NearY,'string'));
          %if ~isempty(Temp)
          %Contour.VP.how_nearY=Temp;
          Temp=str2num(get(Contour.FGV.Edit.NearT,'string'));
          if ~isempty(Temp)
            Contour.VP.how_neart=Temp;
            Temp=str2num(get(Contour.FGV.Edit.Many,'string'));
            if ~isempty(Temp)
              Contour.VP.how_many=Temp;
              Temp=str2num(get(Contour.FGV.Edit.Resthresh,'string'));
              if ~isempty(Temp)
                Contour.VP.resthresh=Temp;
                %Temp=str2num(get(Contour.FGV.Edit.Outliers,'string'));
                %if ~isempty(Temp)
                %Contour.VP.Outliers=Temp;
                %Temp=str2num(get(Contour.FGV.Edit.Mspersamp,'string'));
                %if ~isempty(Temp)
                %Contour.VP.mspersamp=Temp;
                Temp=str2num(get(Contour.FGV.Edit.Vmax,'string'));
                if ~isempty(Temp)
                  Contour.VP.Vmax=Temp;
                  Temp=str2num(get(Contour.FGV.Edit.Vmin,'string'));
                  if ~isempty(Temp)
                    Contour.VP.Vmin=Temp;
                  else
                    Continue='Vmin';
                  end
                else
                  Continue='Vmax';
                end
                %else
                %   Continue='Mspersamp';
                %end
                %else
                %   Continue='Outliers';
                %end
              else
                Continue='Resthresh';
              end
            else
              Continue='How many';
            end
          else
            Continue='Near T';
          end
          %else
          %      Continue='Near Y';
          %end
        else
          Continue='Near XY';
        end
      else
        Continue='Y';
      end
    else
      Continue='X';
    end
    
    if isnumeric(Continue)
      set(Contour.Figure,'userdata',Contour);
      if strcmp('Ok',varargin{2})
        Zeng_Contour('VP DeleteFcn');
      else %Apply
        Type='Vectors';
        Continue=Zeng_Contour('Plot TimeMap',Contour.Figure,Contour.Analysis,Type,'Old');
        if Continue
          Contour=get(Contour.Figure,'userdata');
          set(Contour.Menu.ContourType,'Checked','off')
          set(findobj(Contour.Menu.ContourType,'tag',Type),'Checked','on')
          Contour.CurrentPlot=Type;
          set(Contour.Figure,'userdata',Contour);
        end
        Zeng_Contour('Vector Label',Contour.Figure)
      end
    else
      Zeng_Error(['Please enter only number in' char(13) Continue char(13)]);
    end
    ContourParams=Contour.VP;
    ContourParams.Quadrant=get(Contour.Button.Quadrant,'Value');
    save ContourParams ContourParams
    load contourfigure
    contourfigure.FGSize=get(Contour.Figure,'Position');
    save contourfigure contourfigure
  case 'Default V'
    Contour.Figure=get(gcbf,'userdata');
    Contour=get(Contour.Figure,'userdata');
    %Contour.VP=Contour.Default.VP;
    %set(Contour.Figure,'userdata',Contour);
    set(Contour.FGV.Edit.X,'string',num2str(Contour.Default.VP.X));
    set(Contour.FGV.Edit.Y,'string',num2str(Contour.Default.VP.Y));
    set(Contour.FGV.Pop.NearXY,'value',Contour.Default.VP.how_nearxy);
    %set(Contour.FGV.Edit.NearY,'string',num2str(Contour.VP.how_neary));
    set(Contour.FGV.Edit.NearT,'string',num2str(Contour.Default.VP.how_neart));
    set(Contour.FGV.Edit.Many,'string',num2str(Contour.Default.VP.how_many));
    set(Contour.FGV.Edit.Resthresh,'string',num2str(Contour.Default.VP.resthresh));
    %set(Contour.FGV.Edit.Outliers,'string',num2str(Contour.VP.Outliers));
    %set(Contour.FGV.Edit.Mspersamp,'string',num2str(Contour.VP.mspersamp));
    set(Contour.FGV.Edit.Vmin,'string',num2str(Contour.Default.VP.Vmin));
    set(Contour.FGV.Edit.Vmax,'string',num2str(Contour.Default.VP.Vmax));
    
    
  case 'VP DeleteFcn'
    load ContourParams;
    Contour.VP=ContourParams;
    Contour.VP.VPosition=get(gcbf,'Position');
    ContourParams=Contour.VP;
    save ContourParams ContourParams
    delete(gcbf)
    
    Conttag=findobj('Tag','Contour');
    Contour=get(Conttag(1),'userdata');
    Contour.FGV=[];
    set(Contour.Figure,'userdata',Contour)
    Def=findobj(0,'type','figure','userdata',Contour.Figure,'tag','Definition');
    if ~isempty(Def)
      close(Def)
    end
    
    
    
  case 'Vel Inverse'
    Contour=get(gcbf,'userdata');
    if get(Contour.Check.Inverse,'value')
      set(Contour.Text.MagnitudeL,'String','Mag (s/m)')
    else
      set(Contour.Text.MagnitudeL,'String','Mag (m/s)')
    end
    Zeng_Contour('ContourType','Vectors');
    Zeng_Contour('Vector Label',Contour.Figure);
    Zeng_Contour('average label',Contour);
    
  case 'Filter'
    Contour=get(gcbf,'userdata');
    bsteve=[];
    bsteve=conv2(Contour.Image,1/9*ones(3),'same');
    Contour.ImageHD=imagesc(bsteve);
    save junk1 bsteve
    set(Contour.Button.Quadrant,'Enable','on');
    
    if 1==2
      for i=1:length(Contour.XYT(:,1))
        Contour.Image(Contour.XYT(i,2),Contour.XYT(i,1))=Contour.XYT(i,3);
      end
    end
    
  case 'Quadrant' %Added by Poelzing October 2021
      Contour=get(gcbf,'userdata');
      load junk
      [xx yy]=size(bsteve);
      qs=2; % Divides array into 2x2
      c=[1 1 1 1 1];
      for col=1:yy
          for row=1:xx
              if bsteve(row,col)>0
                  if row<xx/qs && col<yy/qs
                      q1(c(1))=bsteve(row,col);
                      c(1)=c(1)+1;
                  elseif row<xx/qs && col>yy/(1-qs)
                      q2(c(2))=bsteve(row,col);
                      c(2)=c(2)+1;
                  elseif row>xx/(1-qs) && col<yy/qs
                      q3(c(3))=bsteve(row,col);
                      c(3)=c(3)+1;
                  elseif row>xx/(1-qs) && col>yy/(1-qs)
                      q4(c(4))=bsteve(row,col);
                      c(4)=c(4)+1;
                  end
                  qall(c(5))=bsteve(row,col);
                  c(5)=c(5)+1;
              end
          end
      end
      [rdim cdim]=size(bsteve);
      disp(['Quadrant Median: 1. RVB, 2. LVB, 3. RVA 4. LVA']) % TODO
      Q_Med=[round(median(q1)) round(median(q2)) round(median(q3)) round(median(q4))]' % for copy-paste
      
      disp(['Average APD '])
      disp(num2str(mean(qall)));
      disp('')
      disp(['Stdev APD '])
      disp(num2str(std(qall)));
      
      Quadrants=[mean(q1) mean(q2) mean(q3) mean(q4)];
      Quad_dispersion=max(Quadrants)-min(Quadrants)
      
      disp(['t-test (0 no diff, 1 diff) RVB-LVB:',num2str(ttest2(q1,q2)),' RVB-RVA:',num2str(ttest2(q1,q3)),' RVB-LVA:',num2str(ttest2(q1,q4))]);
        
      set(Contour.Text.RVB,'String',num2str(mean(q1)));
      set(Contour.Text.LVB,'String',num2str(mean(q2)));
      set(Contour.Text.RVA,'String',num2str(mean(q3)));
      set(Contour.Text.LVA,'String',num2str(mean(q4)));
      set(Contour.Text.Area,'String',num2str(xx/qs));
      
  case 'ArrAr'
    Contour=get(gcbf,'userdata');
    if varargin{2}=='A'
      load junk;
      ArrayA=bsteve;
      Amean=num2str(nanmean(nanmean(ArrayA)));
      Amed=num2str(nanmedian(nanmedian(ArrayA)));
      Ast=num2str(nanstd(ArrayA(:)));
      disp(['Mean Med Stdv: ',Amean,' ',Amed,' ',Ast])
      save ArrayA ArrayA
    elseif varargin{2}=='B'
      load junk;
      ArrayB=bsteve;
      Bmean=num2str(nanmean(nanmean(ArrayB)));
      Bmed=num2str(nanmedian(nanmedian(ArrayB)));
      Bst=num2str(nanstd(ArrayB(:)));
      disp(['Mean Med Stdv: ',Bmean,' ',Bmed,' ',Bst])
      save ArrayB ArrayB
    elseif varargin{2}=='E'
      load junk
      Arithm=get(Contour.Button.Arithm,'value');
      load ArrayA
      load ArrayB
      % figure(10)
      %         ArrayA=medfilt2(ArrayA,[2,2]);
      %         ArrayB=medfilt2(ArrayB,[2,2]);
      if Arithm==1
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Edited by Grace Blair 6/11/20
    Data=(ArrayA)-(ArrayB);
    %imagesc(Data)

    [row,col]=size(ArrayA);
    valsA=reshape(ArrayA,row*col,1);
    valsB=reshape(ArrayB,row*col,1);


    save('bgrace','valsA','valsB')

    mdata=mean(nanmean(Data));
    sdata=std(nanstd(Data));
    %colorbar



    figure(11)
    plot(valsA, valsB,'o') %plot individual points

    title(['Correlation Between A and B is: '] ); 
    %get fitted values
    idxA=find(isfinite(valsA)); %indices of all Array A values that are not NaN
    idxB=find(isfinite(valsB)); %indices of all Array A values that are not NaN
    coeffs = polyfit(valsA(idxB), valsB(idxB), 1); %coefficients for polynomial that fits relationship bewteen A and B
    fittedX = linspace(min(valsA(idxB)), max(valsA(idxB))); %assemble min->mac A vector (only use indices of B because these indices may have unpaired A indices (AT with no APD))
    fittedY = polyval(coeffs, fittedX); % plug x values into fitted equation
    % Plot the fitted line
    hold on;
    plot(fittedX, fittedY, 'r-', 'LineWidth', 2);
    %find correlation coefficient
    PearsonR = corrcoef(valsA(idxB), valsB(idxB));
    Rsquared = PearsonR(2)*PearsonR(2);



    %             Title(['ArrayA - ArrayB. Mean= ',num2str(mdata),' +- ',num2str(sdata)])

    end

end 

    % figure(11)
    % [row,col]=size(bsteve);
    % temp=reshape(bsteve,1,row*col);
    % temp=temp-min(temp);
    % maxb=max(temp);
    % hist(temp,maxb)
    
  case 'HPatch' % GREG. A subroutine for making a flashing rectangle in contour window
    
    Marker=patch(...  %GREG figure out how to make this patch appear in the contour window.
      'CData',[],...
      'CDataMapping','scaled',...
      'FaceVertexCData',[],...
      'EdgeColor',[[0.5+[rand rand rand]/2]],...
      'EraseMode','xor',...
      'FaceColor',[1 0 0],...
      'Faces',[1 2 3 4 5],...
      'LineStyle','-',...
      'LineWidth',4,...
      'Marker','+',...%Don't change
      'MarkerEdgeColor',[1 0 0],...%Don't change
      'MarkerFaceColor',[1 0 0],...%Don't change
      'MarkerSize',[6],...
      'tag','HPatch',...
      'XData',[100],... % GREG change this parameter
      'YData',[100]); % GREG change this parameter
    
  otherwise
    
    
end%Switch


% At line 434 added the following
%          Contour.Button.Auto = uicontrol('Parent',Contour.Figure,...
%             'ListboxTop',0, ...
%             'enable','off',...
%             'Units','pixel',...
%             'Position',[350 50 60 20], ...
%             'String','Auto Calc', ...
%             'tag','Button Auto',...
%             'callback','Steve_Contour(''Initial'')');

% At line 1272 added the following
%             set(Contour.Button.Auto,'Enable','on');
