function [varargout]=Zeng_Share(varargin)
action=varargin{1};
global Log
global Data

switch action
%=====================================================================================
case 'Common Menu'
%=====================================================================================
%=====================================================================================
   

Hm_File={
   'File'                            ' '                        'filemenu'
   '>Open...'                        'Zeng_Log(''FromOpen'',''Read'');'  ' '%   '>>Both...'                       ' '                        ' '%   '>>FIrst..'                       ' '                        ' '   '>>Second.'                       ' '                        ' '
   '>------'                         ' '                        ' '
   '>Save ...'                       ' '                        ' '
   '>>as jpg...'                     'print -djpeg100 -noui a '  ' '
   '>>as deps...'                    'print -deps -noui a '     ' '
   '>>as Bitmap...'                  'print -dbitmap -noui a'    ' '
   '>------'                         ' '                        ' '
   '>Page Setup...'                  'pagedlg'                  ' '
   '>Print Setup...'                 'print -dsetup'            ' '
   '>------'                         ' '                        ' '
   '>Print...'                       'print -noui'              ' '
   '>------'                         ' '                        ' '
   '>Close...'                       'close(gcf)'               ' '
   '>Exit....'                       'close(get(0,''children''));clear all;set(0,''userdata'',[])'               ' '};
Hm_Setting={
   'Setting'                         ' '                        'Setting'
   '>Default Positions'              'Zeng_Share(''Pos Setting'')'    ' ' };

if strcmp('WaveForm',get(gcf,'tag'))
	makemenu(gcf,char([Hm_File(1,1);Hm_File(4:15,1)]),char([Hm_File(1,2);Hm_File(4:15,2)]), char([Hm_File(1,3);Hm_File(4:15,3)]));
   
else
	makemenu(gcf,char(Hm_File(:,1)),char(Hm_File(:,2)), char(Hm_File(:,3)));
	makemenu(gcf,char(Hm_Setting(:,1)),char(Hm_Setting(:,2)), char(Hm_Setting(:,3)));
end

%=====================================================================================
%=====================================================================================
case 'Specific Menu'
%=====================================================================================
%=====================================================================================
if 0
Stripchart=get(gcf,'userdata');
Hm_Window={
   'Windows'                         ' '                        'Windows'
   '>Log...'                         'Zeng_Share(''Log'')'            ' '
   '>------'                         ' '                        ' '
   '>Data information..'             'Zeng_Share(''Data_Info'')'      ' '};

Hm_Analysis={
   'Analysis'                         ' '                        'Windows'
   '>Wave forms...'                  'Zeng_WaveForm(''Initial'')'       ' '};


makemenu(gcf,char(Hm_Window(:,1)),char(Hm_Window(:,2)), char(Hm_Window(:,3)));

%makemenu(gcf,char(Hm_Analysis(:,1)),char(Hm_Analysis(:,2)), char(Hm_Analysis(:,3)));
Stripchart.Menu.Analysis=uimenu('Label','Analysis');
Stripchart.Menu.Analysis.WaveForm=uimenu(Stripchart.Menu.Analysis,'Label','Wave Form',...
   'callback','Zeng_WaveForm(''Initial'')');
set(gcf,'userdata',Stripchart);
end
%=====================================================================================
%=====================================================================================
case 'Future Menu'
%=====================================================================================
%=====================================================================================
Hm_Window={
   'Windows'                         ' '                        'Windows'
   '>Log...'                         'Zeng_Share(''Log'')'            ' '
   '>Stripchart...'                  'Zeng_Share(''Stripchart'')'     ' '
   '>Wave forms...'                  'Zeng_Share(''WaveForms'')'       ' '
   '>One file...'                    'Zeng_Share(''Look_One'')'       ' '
   '>------'                         ' '                        ' '
   '>Data information..'             'Zeng_Share(''Data_Info'')'      ' '};
Hm_ActTime={
   'ActivationTime..'                     ' '                        'Activation time'
   '>Calculate...'                         'Zeng_WaveForms(''act time cal'')'            ' '
   '>Parameter Setting..'                    'Zeng_WaveForms(''act time set'')'      ' '};

makemenu(gcf,char(Hm_ActTime(:,1)),char(Hm_ActTime(:,2)), char(Hm_ActTime(:,3)));
makemenu(gcf,char(Hm_Window(:,1)),char(Hm_Window(:,2)), char(Hm_Window(:,3)));

%=====================================================================================
case 'Pos Setting'
%=====================================================================================
%=====================================================================================
if 0
Current_Fg=get(0,'children');
Stripchart_Fg=findobj('tag','Stripchart');
for i= 1:length(Stripchart_Fg)
   figure(Stripchart_Fg(i));%Set it to be the current fg first so that resizefn will work well
   set(Stripchart_Fg(i),'position',[UD.Ref.Position(2,1:2)+(i-1)*30 UD.Ref.Position(2,3:4)]);
end
Log_Fg=findobj('tag','Log');
set(Log_Fg,'position',UD.Ref.Position(1,:));
end
%=====================================================================================
%=====================================================================================
case 'Error'
%=====================================================================================
%=====================================================================================
   E = dialog('name','Error',...
      'Position',[Log.UD.ScreenSize(1)/2-320/2 Log.UD.ScreenSize(2)/2-160/2 320 160],...
      'tag','ZengError');
   Temp.FG_Size=get(E,'position');
   action=varargin{2};
   switch action
      %================================ 
   case 'Uhm...Some of them'
      uicontrol('Parent',E, ...
         'BackgroundColor',get(E,'Color'), ...
         'Position',[1 120 320 20], ...
         'String',varargin{2}, ...
         'Style','text');
      uicontrol('Parent',E, ...
         'BackgroundColor',get(E,'Color'), ...
         'Position',[1 40 320 60], ...
         'String',varargin{3}, ...
         'Style','text');
      uicontrol('Parent',E, ...
         'callback','close',...
         'Units','points', ...
         'Position',[90 15 57.75 24],...
         'string','OK');
      
   case 'Polite'
      uicontrol('Parent',E, ...
         'BackgroundColor',get(E,'Color'), ...
         'Position',[1 Temp.FG_Size(4)-30 Temp.FG_Size(3) 30], ...
         'String',varargin{3}, ...
         'Style','text');
      if nargin>3
      uicontrol('Parent',E, ...
         'BackgroundColor',get(E,'Color'), ...
         'HorizontalAlignment','left',...
         'Position',[1 30 320 100], ...
         'Position',[1 30 Temp.FG_Size(3) Temp.FG_Size(4)-60], ...
         'String',varargin{4}, ...
         'Style','text');
      end
         
      uicontrol('Parent',E, ...
         'callback','close',...
         'Units','points', ...
         'Position',[90 5 57.75 20],...
         'string','OK');
      
   case 'No head files'
      uicontrol('Parent',E, ...
         'BackgroundColor',get(E,'Color'), ...
         'Position',[1 120 320 20], ...
         'String',varargin{2}, ...
         'Style','text');
      uicontrol('Parent',E, ...
         'BackgroundColor',get(E,'Color'), ...
         'Position',[1 80 320 20], ...
         'String','I recommend you create a head file', ...
         'Style','text');
      uicontrol('Parent',E, ...
         'Units','points', ...
         'Position',[60 22.5 57.75 24],...
         'string','OK',...
         'callback',[...
            'close;',...
            'Zeng_Log(''Create head file'');',...
            'Zeng_Share(''Data_Info'',''No head files'');']);
      uicontrol('Parent',E, ...
         'Units','points', ...
         'Position',[150 22.5 57.75 24],...
         'string','Cancel',...
         'callback','close');
      
   %================================   
   case 'Are you sure to change the comment ???'
      uicontrol('Parent',E, ...
         'BackgroundColor',get(E,'Color'), ...
         'Position',[1 120 320 20], ...
         'String',varargin{2}, ...
         'Style','text');
      uicontrol('Parent',E, ...
         'Units','points', ...
         'Position',[30 22.5 57.75 24],...
         'string','OK',...
         'callback',[...
            'Stripchart.Head.Comment=get(Log.UD.HD.Data_Info.Text.Comment,''String'');',...
            'close;']);
      uicontrol('Parent',E, ...
         'Units','points', ...
         'Position',[150 22.5 57.75 24],...
         'string','Cancel',...
         'callback','close');
   otherwise  % when button is clicked but the data are out of range
      disp('please contact Zeng')
   end
   
case 'DeleteFcn'
   clear All

   delete(findobj('type','figure','Tag','Log'));
   delete(findobj('type','figure','Tag','Stripchart'));
   delete(findobj('type','figure','Tag','STSegment'));
   delete(findobj('type','figure','Tag','WaveForm'));
   delete(findobj('type','figure','Tag','EditAnnote'));
   delete(findobj('type','figure','Tag','Conduction'));
   delete(findobj('type','figure','Tag','LUTDisplay'));
   delete(findobj('type','figure','Tag','Contour'));
   delete(findobj('type','figure','Tag','Initial'));
   delete(findobj('type','figure','Tag','FGV'));
   
case 'Fonts Setting'
   Temp.UI_Control=findobj(gcbf,'type','uicontrol');
   s = uisetfont(Temp.UI_Control(1),'Don''t make it too big, OK?');
   if isstruct(s)  % Check for cancel
      Log.UD.Ref.FontSize=s.FontSize;
      Log.UD.Ref.Ch_Box(1)=(38+(s.FontSize-7)*3.5); 
      Log.UD.Ref.Time_Box(1)=(56+8*(s.FontSize-7));
      Log.UD.Ref.Ch_Box(2)=(18+(s.FontSize-7)*2);
      Log.UD.Ref.Time_Box(2)=( 12.5+(s.FontSize-7)*3.5);      
      %[38+(Fontsize-7)*3.5) (for 4 digits),18+(Fontsize-7)*2]
      %[56 +(fontsize-7)*8   12.5+(fontsize-7)*3.5]
      %I will set it in the resize function
      %for num=1:length(WaveForm.Ch.Axes)
      %   set(WaveForm.Ch.Cursor(num,:),'ydata',get(WaveForm.Ch.Axes(num),'ylim'));
      %end
      Temp.Figure=findobj('type','figure','tag','Log');
      Temp.Figure=[Temp.Figure findobj('type','figure','tag','Stripchart')'];
      Temp.Figure=[Temp.Figure findobj('type','figure','tag','WaveForm')'];
      Temp.Figure=[Temp.Figure findobj('type','figure','tag','EditAnnote')'];
      Temp.Figure=[Temp.Figure findobj('type','figure','tag','Conduction')'];
      Temp.Figure=[Temp.Figure findobj('type','figure','tag','LUTDisplay')'];
      Temp.Figure=[Temp.Figure findobj('type','figure','tag','Contour')'];
      for i=1:length(Temp.Figure)
         Temp.UI_Control=findobj(Temp.Figure(i),'type','uicontrol');
         Temp.UI_Axes   =findobj(Temp.Figure(i),'type','axes');
         Temp.UI_Text   =findobj(Temp.Figure(i),'type','text');
         %WaveForm=get(gcbf,'userdata');
         %set(WaveForm.Ch.Cursor,'ydata',[nan nan]);
         set(Temp.UI_Control,s);
         set(Temp.UI_Axes, s);
         set(Temp.UI_Text, s);
         if strcmp('Log',get(Temp.Figure(i),'tag'))
            
         elseif strcmp('Stripchart',get(Temp.Figure(i),'tag'))
            
         elseif strcmp('WaveForm',get(Temp.Figure(i),'tag'))
            Zeng_WaveForm('ResizeFcn',Temp.Figure(i));
         elseif strcmp('EditAnnote',get(Temp.Figure(i),'tag'))
            
         end
      end
      Temp=[];
   end
case 'Export'
   [Filename Path]=uiputfile([Log.UD.DataCD Log.UD.CD  '*.' varargin{2}],'Select a file for your waveform');
   if ~strcmp('0',num2str(Filename)) & ~strcmp('0',num2str(Path));
      %if you do not click cancel
      %eval(['print -noui ' get(gcbo,'tag') ' ' Path Filename])
      eval(['print ' get(gcbo,'tag') ' ' Path Filename])
   end
end% for switch
