function [varargout]=Zeng_Annote(varargin)
%Annote.Show = [ sh/unsh Label(1:3)]
%Annote.Array= [   Ch    Time    Label(1:3)]
global Log
action = varargin{1};

switch action
case 'Edit'
   if strcmp(get(varargin{2},'tag'),'Stripchart');
      %Set visible off if came from stripchart.
      Stripchart=get(varargin{2},'userdata');
   else
      %Set visible on if came from WaveForm.
      WaveForm=get(gcbf,'userdata');
      Stripchart=get(WaveForm.Parent,'userdata');
   end
   
   
   if ~isempty(Stripchart.Annote.Figure)
      figure(Stripchart.Annote.Figure);
   else
    xtemp=dir('annotefigure.mat');
    if isempty(xtemp)
         FG_Size=[10 200 250 500];
    else
        load annotefigure
       FG_Size=annotefigure.Position;
       close(gcf)
    end     

      EditAnnote.Figure=figure;
      EditAnnote.Parent=Stripchart.Figure;
      Stripchart.Annote.Figure=EditAnnote.Figure;
      set(EditAnnote.Figure,...
         'Units','points', ...
         'Color',[0.8 0.8 0.8], ...%     'HandleVisibility','off',...       
         'DeleteFcn','Zeng_Annote(''DeleteFcn'');',...
         'menu','none',...
         'name',[Stripchart.Head.FileName ':Edit Annote'],...
         'NumberTitle','off',...
         'Units','pixels',...
         'Position',FG_Size, ...
         'selected','on',...
         'Tag','EditAnnote');
      if 0
         EditAnnote.Frame.Local = uicontrol('Parent',EditAnnote.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.9 0.9 0.9], ...
            'ListboxTop',0, ...
            'BackgroundColor',[0.847058823529412 0.8 0.7215686274509801], ...
            'ListboxTop',0, ...
            'Position',[6 101 280 58], ...
            'String','Show it', ...
            'Style','frame', ...
            'Tag','Frame1');
      end

      %Move to be in Stripchart window
      if 0
	      Hm_Setting={
		   	'Setting          '                '             '                              ' '
      	   '>Include segments'                'Zeng_Annote(''Include Setting'',''IncludeSM'')'   'IncludeSM'
         	'>Include Information'             'Zeng_Annote(''Include Setting'',''IncludeInf'')'  'IncludeInf'};
	      EditAnnote.Menu.Setting=makemenu(EditAnnote.Figure,char(Hm_Setting(:,1)),char(Hm_Setting(:,2)),char(Hm_Setting(:,3)));
   	   if Stripchart.Annote.IncludeSM
      	   TheOne=findobj(EditAnnote.Menu.Setting,'tag','IncludeSM');
         	set(TheOne,'Checked','on')
         end
         
      end
      EditAnnote.Text.TitleSz=[1 FG_Size(4)-30 FG_Size(3) 20];
      EditAnnote.Text.Title=uicontrol('Parent',EditAnnote.Figure, ...
         'Units','pixels',...
         'BackgroundColor',[0.8 0.8 0.8], ...
         'HorizontalAlignment','left', ...
         'ListboxTop',0, ...
         'Position',[1 FG_Size(4)-30 FG_Size(3) 20], ...
         'String','Hidden    Label            Comment', ...
         'Style','text', ...
         'Tag','StaticText1');
      EditAnnote.ListBox.Show = uicontrol('Parent',EditAnnote.Figure, ...
         'Units','pixels',...
         'BackgroundColor',[1 1 1], ...
         'callback','Zeng_Annote(''List Selecting'');',...         'Position',[4 170 284 226], ...
         'Position',[5 170 (FG_Size(3)-5) (FG_Size(4)-200)], ...
         'String',' ', ...
         'Style','listbox', ...
         'Tag','Listbox1', ...
         'Value',1);
      %first   
      EditAnnote.Text.Local = uicontrol('Parent',EditAnnote.Figure, ...
         'Units','pixels',...
         'BackgroundColor',[0.8 0.8 0.8], ...
         'HorizontalAlignment','left', ...
         'ListboxTop',0, ...
         'Position',[6 141 150 18], ...
         'String','Edit Annotation', ...
         'Style','text', ...
         'Tag','StaticText3');
      EditAnnote.Opt.Show = uicontrol('Parent',EditAnnote.Figure, ...
         'Units','pixels',...
         'BackgroundColor',[0.8 0.8 0.8], ...
         'callback','Zeng_Annote(''Update Show'')',...
         'ListboxTop',0, ...
         'Position',[12 118 75 17], ...
         'String','Hide it', ...
         'Style','radiobutton', ...
         'Tag','Radiobutton1');
      %Second
      EditAnnote.Frame.Global = uicontrol('Parent',EditAnnote.Figure, ...
         'Units','pixels',...
         'BackgroundColor',[0.9 0.9 0.9], ...
         'ListboxTop',0, ...
         'Position',[6 6 (FG_Size(3)-12) 92], ...
         'Style','frame', ...
         'Tag','Frame1');
      Edit.Text.Global = uicontrol('Parent',EditAnnote.Figure, ...
         'Units','pixels',...
         'BackgroundColor',[0.9 0.9 0.9], ...
         'HorizontalAlignment','left', ...
         'ListboxTop',0, ...
         'Position',[10 69 100 27], ...
         'String','Add Annotation', ...
         'Style','text', ...
         'Tag','StaticText3');
      
      EditAnnote.Text.Titile2 = uicontrol('Parent',EditAnnote.Figure, ...
         'Units','pixels',...
         'BackgroundColor',[0.9 0.9 0.9], ...
         'HorizontalAlignment','left', ...
         'ListboxTop',0, ...
         'Position',[14 55 178 22], ...
         'String','Label            Comment', ...
         'Style','text', ...
         'Tag','StaticText1');
      
      EditAnnote.Button.New = uicontrol('Parent',EditAnnote.Figure, ...
         'Units','pixels',...
         'callback','Zeng_Annote(''New'');',...
         'ListboxTop',0, ...
         'Position',[ FG_Size(3)/4-40 10 80 21], ...
         'string','New Label',...
         'Tag','Pushbutton1');
      EditAnnote.Button.DelAll = uicontrol('Parent',EditAnnote.Figure, ...
         'Units','pixels',...
         'callback','Zeng_Annote(''Del'');',...
         'ListboxTop',0, ...
         'Position',[153 10 124 21], ...
         'Position',[ FG_Size(3)*3/4-40 10 80 21], ...
         'string','Del Label',...
         'Tag','Pushbutton2');
      EditAnnote.Edit.Annote = uicontrol('Parent',EditAnnote.Figure, ...
         'Units','pixels',...
         'BackgroundColor',[1 1 1], ...
         'ListboxTop',0, ...
         'Position',[12 35 51 22], ...
         'Style','edit', ...
         'Tag','EditText1');
      EditAnnote.Edit.Comment = uicontrol('Parent',EditAnnote.Figure, ...
         'Units','pixels',...
         'BackgroundColor',[1 1 1], ...
         'ListboxTop',0, ...
         'Position',[68 35 (FG_Size(3)-68-6-6) 20], ...
         'Style','edit', ...
         'Tag','EditText2');
      
      icons = {['[ text(.2,.4,''add'')] ';
            '[ text(.2,.4,''del'')] ']};
      callbacks = ['Zeng_Annote(''AddDel'',''Add'')';
         'Zeng_Annote(''AddDel'',''Del'')'];
      PressType=['toggle';'toggle'];
      EditAnnote.Button.AddDelSz=[100 118 80 20];
      EditAnnote.Button.AddDel=	btngroup(EditAnnote.Figure,'ButtonID',['B1';'B2'],...
         'IconFunctions',str2mat(icons{:}),...
         'Callbacks',callbacks,...
         'GroupID', 'AddDel',...
         'GroupSize',[1 2],...   
         'InitialState',[0 0],...
         'PressType',PressType,...
         'BevelWidth',.075,...
         'units','pixels',...
         'Position',EditAnnote.Button.AddDelSz ,...
         'Orientation','horizontal');
      
      
      set(Stripchart.Figure,'userdata',Stripchart);
      set(EditAnnote.Figure,'userdata',EditAnnote);
      set(EditAnnote.Figure,'ResizeFcn','Zeng_Annote(''ResizeFcn'')');
      %Important
      figure(EditAnnote.Figure);
      %---------
      Zeng_Annote('Reset List',EditAnnote.Figure);
       annotefigure=get(EditAnnote.Figure);
       save annotefigure annotefigure

   end
case 'Include segments'   
   EditAnnote=get(gcbf,'userdata');
   Stripchart=get(EditAnnote.Parent,'userdata');
   TheOne=findobj(EditAnnote.Menu.Setting,'tag','Include segments');
   if strcmp('on',get(TheOne,'Checked'));
      set(TheOne,'Checked','off')
      Stripchart.Annote.IncludeSM=0;
   else
      set(TheOne,'Checked','on')
      Stripchart.Annote.IncludeSM=1;
   end
   set(Stripchart.Figure,'userdata',Stripchart);
case 'Include Setting'   
   EditAnnote=get(gcbf,'userdata');
   Stripchart=get(EditAnnote.Parent,'userdata');
   TheOne=findobj(EditAnnote.Menu.Setting,'tag',varargin{2});
   if strcmp('on',get(TheOne,'Checked'));
      set(TheOne,'Checked','off')
      eval(['Stripchart.Annote.' varargin{2} '=0;']);
   else
      set(TheOne,'Checked','on')
      eval(['Stripchart.Annote.' varargin{2} '=1;']);
   end
   set(Stripchart.Figure,'userdata',Stripchart);

case 'ResizeFcn'
   Temp.ResizeFcn=get(gcbf,'ResizeFcn');
   set(gcbf,'ResizeFcn','');
   EditAnnote=get(gcbf,'userdata');
   FG_Size=get(gcbf,'position');
   FG_Size(3)=max(FG_Size(3),Log.UD.HD.EditAnnote.FG_Limit(1));
   FG_Size(4)=max(FG_Size(4),Log.UD.HD.EditAnnote.FG_Limit(2));
   %set(gcbf,'position',FG_Size);
   set(EditAnnote.Text.Title,'Position',[1 FG_Size(4)-30 FG_Size(3) 20]);
   set(EditAnnote.ListBox.Show,'Position',[5 170 (FG_Size(3)-5) (FG_Size(4)-200)]);
   set(EditAnnote.Frame.Global,'Position',[6 6 (FG_Size(3)-12) 92]);
   set(EditAnnote.Edit.Comment,'Position',[68 35 (FG_Size(3)-68-6-6) 20]);
   set(EditAnnote.Text.Title,'position',[1 FG_Size(4)-30 FG_Size(3) 20]);
   set(EditAnnote.Button.New,'Position',[ FG_Size(3)/4-40 10 80 21]);
   set(EditAnnote.Button.DelAll,'Position',[ FG_Size(3)*3/4-40 10 80 21]);
   set(gcbf,'ResizeFcn',Temp.ResizeFcn);
   annotefigure=get(EditAnnote.Figure);
   save annotefigure annotefigure
case 'List Selecting'
   EditAnnote=get(gcbf,'userdata');
   Stripchart=get(EditAnnote.Parent,'userdata');
   Temp.Show  =get(EditAnnote.ListBox.Show,'string');
   Temp.Current_File=get(EditAnnote.ListBox.Show,'value');
   if Temp.Current_File>0 & iscell(Temp.Show) &length(Temp.Show)>0;
      Temp.Current_String=Temp.Show{Temp.Current_File};
      if Temp.Current_String(1)=='x'+0;
         set(EditAnnote.Opt.Show,'value',1);
         Stripchart.Annote.Show(Temp.Current_File,1)=0;
      else
         set(EditAnnote.Opt.Show,'value',0);
         Stripchart.Annote.Show(Temp.Current_File,1)=1;
      end;
      set(Stripchart.Figure,'userdata',Stripchart);
   else
	   set(EditAnnote.Opt.Show,'value',0);
   end
case 'Update Show'
   if nargin==1
      %From itself
      EditAnnote=get(gcbf,'userdata');
   else
      %From WaveForm  - Add annote
      EditAnnote=get(varargin{2},'userdata');
   end
   
   Stripchart=get(EditAnnote.Parent,'userdata');
   Temp.Show  =get(EditAnnote.ListBox.Show,'string');
   Temp.Current_File=get(EditAnnote.ListBox.Show,'value');
   if Temp.Current_File>0 & iscell(Temp.Show) &length(Temp.Show)>0;
      Temp.Current_String=Temp.Show{Temp.Current_File};
      if ~get(EditAnnote.Opt.Show,'value');
         if Temp.Current_String(1)=='x'+0;
            Temp.Current_String(1)=' ';
            Stripchart.Annote.Show(Temp.Current_File,1)=1;
            set(Stripchart.Figure,'userdata',Stripchart);
            Zeng_Annote('Update WaveForm Show',Stripchart.Annote.Show(Temp.Current_File,2:Stripchart.Annote.ShowLength+1)+0)
         end;
      else;
         if Temp.Current_String(1)~='x'+0;
            Temp.Current_String(1)='x';
            Stripchart.Annote.Show(Temp.Current_File,1)=0;
            set(Stripchart.Figure,'userdata',Stripchart);
            Zeng_Annote('Update WaveForm UnShow',Stripchart.Annote.Show(Temp.Current_File,2:Stripchart.Annote.ShowLength+1)+0);

         end;
      end;
      Temp.Show{Temp.Current_File}=Temp.Current_String;
      set(EditAnnote.ListBox.Show,'string',Temp.Show);
   end;
case 'AddDel'
   if strcmp(varargin{2},'Add');
      if btnstate(gcbf,'AddDel','B1');
         btnup(gcbf,'AddDel','B2');
      end;
   else;
      if btnstate(gcbf,'AddDel','B2');
         btnup(gcbf,'AddDel','B1');
      end;
   end;
case 'Reset List'
   EditAnnote=get(varargin{2},'userdata');
   Stripchart=get(EditAnnote.Parent,'userdata');
   if ~isempty(Stripchart.Annote.Show)
      %for the future when you want to change the label length
      Temp.a={};
      for i=1:length(Stripchart.Annote.Show(:,1))
         if Stripchart.Annote.Show(i,1)
            Temp.Show=' ';
         else
            Temp.Show='x';
         end
         
         Temp.b=[Temp.Show blanks(9)  char(Stripchart.Annote.Show(i,2:Stripchart.Annote.ShowLength+1)) blanks(10) Stripchart.Annote.ShowComment{i}];
         Temp.a=[Temp.a;{Temp.b}];
      end
      set(EditAnnote.ListBox.Show,'value',1,'string',Temp.a);
      if ~Stripchart.Annote.Show(1,1)
         set(EditAnnote.Opt.Show,'value',1);
      end
   end
   

   
case 'Update List'
   
   if nargin==1
      %from itself
      EditAnnote=get(gcbf,'userdata');
   else
      EditAnnote=get(varargin{2},'userdata');
   end
   
   Stripchart=get(EditAnnote.Parent,'userdata');
   Temp.List=get(EditAnnote.ListBox.Show,'string');
   if ~iscell(Temp.List);
      Temp.List={Temp.List};
   end
   Temp.Last=length(Stripchart.Annote.Show(:,1));
   if Temp.Last==1;
      Temp.List={};
      set(EditAnnote.ListBox.Show,'value',1);
   end
   Temp.Add={[blanks(10)  char(Stripchart.Annote.Show(Temp.Last,2:Stripchart.Annote.ShowLength+1)) blanks(10) Stripchart.Annote.ShowComment{Temp.Last}]};
   Temp.List=[Temp.List;Temp.Add];
   set(EditAnnote.ListBox.Show,'string',Temp.List);
case 'DeleteFcn'
   if strcmp(get(gcbf,'tag'),'Stripchart');
      %Delete when you opened *.ant, but you canceled it later
      Stripchart=get(gcbf,'userdata');
   else
      EditAnnote=get(gcbf,'userdata');
      Stripchart=get(EditAnnote.Parent,'userdata');
   end
   Stripchart.Annote.Figure=[];
   set(Stripchart.Figure,'userdata',Stripchart);
annotefigure=get(EditAnnote.Figure);
save annotefigure annotefigure
case 'Update WaveForm Show'
   EditAnnote=get(gcbf,'userdata');
   Stripchart=get(EditAnnote.Parent,'userdata');
   Temp.Letters = varargin{2};
   for k=1:length(Stripchart.WaveForm.Figure)
      WaveForm=get(Stripchart.WaveForm.Figure(k),'userdata');
      Zeng_WaveForm('Adjust Annote',WaveForm.Figure,1:length(WaveForm.Ch.Axes));
   end
case 'Update WaveForm UnShow'
   EditAnnote=get(gcbf,'userdata');
   Stripchart=get(EditAnnote.Parent,'userdata');
   Temp.Letters = varargin{2};
   for k=1:length(Stripchart.WaveForm.Figure)
      WaveForm=get(Stripchart.WaveForm.Figure(k),'userdata');   
      Temp.Annote.Label=findobj(WaveForm.Figure,'tag','Label Annote','string',char(Temp.Letters));
      for i=1:length(Temp.Annote.Label)
         delete(get(Temp.Annote.Label(i),'userdata'));
         delete(Temp.Annote.Label(i));
      end
   end
case 'New'
   EditAnnote=get(gcbf,'userdata');
   Stripchart=get(EditAnnote.Parent,'userdata');
   Temp.Letters=get(EditAnnote.Edit.Annote,'string');
   Temp.Comment=get(EditAnnote.Edit.Comment,'string');
   
   Temp.Length=length(Temp.Letters);
   if Temp.Length<1
      Zeng_Error(['Please enter some letters' char(13) 'OK!!!']);
   else
      if Temp.Length<3
         Temp.Letters=[Temp.Letters 32*ones(1,(3-Temp.Length))];
      else
         Temp.Letters=Temp.Letters(1:3);
      end
      if  ~isempty(Stripchart.Annote.Show) & ~isempty(strmatch(char(Temp.Letters(1:3)),char(Stripchart.Annote.Show(:,2:Stripchart.Annote.ShowLength+1))));
         Zeng_Error('You alreadly had me !!!');
      else;
         Stripchart.Annote.Show=[Stripchart.Annote.Show;[1 Temp.Letters(1:3)+0]];%the 1st column shows if it is shown or hidden
         Stripchart.Annote.ShowComment=[Stripchart.Annote.ShowComment;{Temp.Comment}];
         Stripchart.Annote.Changed=1;

         set(Stripchart.Figure,'userdata',Stripchart);
         Zeng_Annote('Update List');
         
         %update contour menu
         if ~isempty(Stripchart.Contour)
            Zeng_Contour('Update Menu',Stripchart.Contour,Stripchart.Annote.Show,Temp.Letters,'on');
         end
      end
   end;
case 'Del'
   EditAnnote=get(gcbf,'userdata');
   Stripchart=get(EditAnnote.Parent,'userdata');
   Temp.Show=get(EditAnnote.ListBox.Show,'string');
  	Current_File=get(EditAnnote.ListBox.Show,'value');
   Total_File=length(Temp.Show);
   if Total_File>0 & ~strcmp(Temp.Show(1),' ') ;
      Temp.Letters=Temp.Show{Current_File};
         
      Ant=Temp.Letters(11:13);
      if strcmp('Yes',questdlg(['Are you sure to delete "' Ant '"   Annote ?'   ] ,'Delete that annote','Yes','No','No'));  
         if Current_File==Total_File;
            set(EditAnnote.ListBox.Show,'value',Current_File-1);
            set(EditAnnote.ListBox.Show,'string',Temp.Show(1:Current_File-1));
         else
            Temp.Show(Current_File:Total_File-1)=Temp.Show(Current_File+1:Total_File);
            Temp.Show(Total_File)=[];
            set(EditAnnote.ListBox.Show,'string',Temp.Show);
         end
      
         %Temp.Letters=Temp.Letters(1:2)+0;
         Temp.Letters=Temp.Letters(11:13)+0;%blanks(10)
         index=strmatch(Temp.Letters(1:3),char(Stripchart.Annote.Show(:,2:1+Stripchart.Annote.ShowLength)));
         Stripchart.Annote.Show(index,:)=[];
         Stripchart.Annote.ShowComment(index)=[];
         Stripchart.Annote.Changed=1;

         set(Stripchart.Figure,'userdata',Stripchart);      
         if ~isempty(Stripchart.Annote.Array);
%           index=find(Stripchart.Annote.Array(:,3)==Temp.Letters(1) & Stripchart.Annote.Array(:,4)==Temp.Letters(2) & Stripchart.Annote.Array(:,5)==Temp.Letters(3) );
            index=strmatch(Temp.Letters(1:3),char(Stripchart.Annote.Array(:,3:(2+Stripchart.Annote.ShowLength))));
            Stripchart.Annote.Array(index,:)=[];
            set(Stripchart.Figure,'userdata',Stripchart);      
            for k=1:length(Stripchart.WaveForm.Figure);
               WaveForm=get(Stripchart.WaveForm.Figure(k),'userdata');   
               Temp.Annote.Label=findobj(WaveForm.Figure,'tag','Label Annote','string',char(Temp.Letters));
               for i=1:length(Temp.Annote.Label)
                  delete(get(Temp.Annote.Label(i),'userdata'));
                  delete(Temp.Annote.Label(i));
               end
            end
         end
         Zeng_Annote('List Selecting');
         
         %update contour menu
         if ~isempty(Stripchart.Contour)
            Zeng_Contour('Update Menu',Stripchart.Contour,Stripchart.Annote.Show,Temp.Letters,'off');
         end
      end%   if strcmp('Yes',questdlg('I love you','Delete that annote','Yes','No','No'))  
   else
      Zeng_Error('You have no annote on the list to delete');
   end	
case 'Check Annote'
   EditAnnote=get(varargin{2},'userdata');
   Stripchart=get(EditAnnote.Parent,'userdata');
   %if ~isempty(Stripchart.Annote.Array) | ~isempty(Stripchart.Annote.Show) 
   if  Stripchart.Annote.Changed

      Temp.ButtonName=questdlg('Do you want to Save them before loading ?','Annote data exist','Yes','No','Cancel','Cancel');
      if strcmp('Yes',Temp.ButtonName)
         Zeng_Annote('Save');
         varargout{1}=1;
      elseif strcmp('No',Temp.ButtonName)
         varargout{1}=1;
      elseif strcmp('Cancel',Temp.ButtonName)
         varargout{1}=0;
      end
   else
      varargout{1}=1;
   end
case 'Load'
   if strcmp('EditAnnote',get(varargin{2},'tag'));
      EditAnnote=get(varargin{2},'userdata');
      Stripchart=get(EditAnnote.Parent,'userdata');
   else
      Stripchart=get(varargin{2},'userdata');
      EditAnnote=get(Stripchart.Annote.Figure,'userdata');
   end
   
   if 1
      Temp.Check=Zeng_Annote('Check Annote',EditAnnote.Figure);
   elseif  0%nargin==2
      %From Check 
      a='Please check me at Zeng_Annote-Load'
      Temp.Check=varargin{2};      
   end
   if Temp.Check
      Continue=0;
 %     [Temp.FileName Temp.Path]=uigetfile([Log.UD.DataCD Log.UD.CD '*.ant']);
 % STEVE POELZING ADDED THESE LINES
 a=dir('annotepath.mat');
 if ~isempty(a)
    load annotepath
    [Temp.FileName Log.UD.DataCD]=uigetfile([annotepath Stripchart.Head.FileName,'.ant']);
 else
    [Temp.FileName Log.UD.DataCD]=uigetfile([Stripchart.Head.FileName,'.ant']);
 end
    annotepath=Log.UD.DataCD;
    save annotepath annotepath
 Temp.Path=Log.UD.DataCD;
     if max([Temp.FileName Temp.Path]) ~= 0%if you do not click cancel
         FID=fopen([Temp.Path Temp.FileName],'r');
         if FID>0
            %Start detecting the file type
            set(Stripchart.Menu.File(3),'enable','on');
            Stripchart.Annote.FileName=Temp.FileName;
            Stripchart.Annote.Path=Temp.Path;
            Stripchart.Annote.Changed=0;
            set(Stripchart.Figure,'userdata',Stripchart);
     
            Temp.Line=fgetl(FID);
            fclose(FID);
                                          
 if Stripchart.Head.Help.DataType==1
               Tab=find(Temp.Line==9);
              if length(Tab)>1 & sum(Temp.Line(1:Tab(2)))~0;
                  %Second version 1)['Ch  Position Label'] or 2)[T Ch A]  
                  %Zeng_Annote('Load second type',EditAnnote.Figure,[Temp.Path Temp.FileName]);
                  Temp.Dot=find(Temp.FileName=='.');
                 if isempty(Temp.Dot)
                     Zeng('Error','Your file extension is weird');
                  else
                     Continue=1;
                               Zeng_Annote('Load second type 2',EditAnnote.Figure,[Temp.Path Temp.FileName]);

                  end
               else
                  Continue=1;
                  Zeng_Annote('Load Zeng Annote',EditAnnote.Figure,[Temp.Path Temp.FileName]);
               end	
            elseif Stripchart.Head.Help.DataType==2%
               %Extra cellular Mapping
               Temp.Dot=find(Temp.FileName=='.');
               if isempty(Temp.Dot)
                  Zeng('Error','Your file extension is weird');
               else
                  Continue=1;
                  if strcmpi(Temp.FileName((Temp.Dot+1):length(Temp.FileName)),'ant') 
                     Tab=find(Temp.Line==9);
                     if length(Tab)>1 & sum(Temp.Line(1:Tab(2)))~0
                        %Second version 1)['  Position Ch Label']
                        Zeng_Annote('Load second type 2',EditAnnote.Figure,[Temp.Path Temp.FileName]); 
                     else
                        Zeng_Annote('Load Zeng Annote',EditAnnote.Figure,[Temp.Path Temp.FileName]);
                     end	
                  else
                     %First version
                     if 0
                        %a='[X Y Position]:arranged my channel'
                        Zeng_Annote('Load first type',EditAnnote.Figure,[Temp.Path Temp.FileName]);
                     else %.a
                        Zeng_Annote('Load first type2',EditAnnote.Figure,[Temp.Path Temp.FileName]);
                     end
                  end
               end
               
            end
         else
            if 0% strcmp('Stripchart',get(varargin{2},'tag'));
               %You came from Stripchart-open, but you canceled
               Zeng_Annote('DeleteFcn');          

               return
            end
            
         end%   if FID>0
      else
         if 0% strcmp('Stripchart',get(varargin{2},'tag'));
            %You came from Stripchart-open, but you canceled
               Zeng_Annote('DeleteFcn');
               return
         end
         
      end%  if max([Temp.FileName Temp.Path]) ~= 0%if you do not click cancel
      if Continue;
         Stripchart=get(Stripchart.Figure,'userdata');
         for k=1:length(Stripchart.WaveForm.Figure)
            WaveForm=get(Stripchart.WaveForm.Figure(k),'userdata');   
            for i=1:length(WaveForm.Ch.Axes)
               Zeng_WaveForm('Adjust Annote',WaveForm.Figure,i);
            end
         end
      else
      %   Zeng_Error('Unsuccessful in opening your ant file')
      end
      
   else
      %Zeng_Annote('DeleteFcn')
   end %if Temp.check

case 'Load first type'
   FID=fopen(varargin{3});
   [Temp.HeartData, Temp.COUNT] = fread(FID);
   fclose(FID);
   Temp.HeartData=char(Temp.HeartData');
   Temp.HeartData=str2num(Temp.HeartData);
   EditAnnote=get(varargin{2},'userdata');
   Stripchart=get(EditAnnote.Parent,'userdata');
   if ~isempty(Temp.HeartData);
      Stripchart.Annote.Show=[1 'AT '+0 ];
      Stripchart.Annote.ShowComment={'Activation time'};
      Stripchart.Annote.Array=[];
      for i=1:length(Temp.HeartData(:,1));
         Stripchart.Annote.Array=[Stripchart.Annote.Array;A6('XY2Ch',Temp.HeartData(i,[1 2])) Temp.HeartData(i,3) Stripchart.Annote.Show(1,1:2)];
      end
      set(EditAnnote.Figure,'userdata',EditAnnote);
      set(Stripchart.Figure,'userdata',Stripchart);
   end
   Zeng_Annote('Reset List',EditAnnote.Figure);
case 'Load first type2'
   %*.a binary file format
   EditAnnote=get(varargin{2},'userdata');
   Stripchart=get(EditAnnote.Parent,'userdata');
   
   %----------------------------------------------
   FID=fopen(varargin{3});
   if FID > -1 & ~isstr(FID);           %If .h exists.
      a=fread(FID,inf,'float32');
      act.ref=a(123);
      act.wind_time=a(121);
      act.wind_size=a(122)*500;
      act.ref_time=a(act.ref);
   end
   a(act.ref)=0;
   t=a(122)*(a(1:(Stripchart.Head.Chans/2))+act.ref_time)+act.wind_time;
   ch=(1:length(t))';
   %----------------------------------------------
   Stripchart.Annote.Show=[1 'AT '+0];
   Stripchart.Annote.ShowComment={'Activation time'};
   Stripchart.Annote.Array=[ch t];  
   Junk=find(Stripchart.Annote.Array(:,2)>5000);
   Stripchart.Annote.Array(Junk,:)=[];
   
   if isempty(Stripchart.Annote.Array)
   else
      Stripchart.Annote.Array=[Stripchart.Annote.Array ones(1,length(Stripchart.Annote.Array(:,1)))'*Stripchart.Annote.Show(1,2:length(Stripchart.Annote.Show))];
      set(Stripchart.Figure,'userdata',Stripchart);
      Zeng_Annote('Reset List',EditAnnote.Figure);
      Zeng_Stripchart('Load Patch from File',Stripchart.Figure,[act.wind_time+[1 act.wind_size-1]]);
   end
case 'Load second type'   
   
   Type.EditAnnote=varargin{2};   
   Type.FileName=varargin{3};   
   Temp=get(Type.EditAnnote,'position');
   Type.Figure = dialog('Color',[0.8 0.8 0.8], ...
      'name',['Choose File format'],...
      'NumberTitle','off',...
      'Position',[Temp(1) sum(Temp([2 4]))-150  200 150], ...
      'Units','pixel', ...
      'Tag','Fig1');
   Type.Opt.Zeng = uicontrol('Parent',Type.Figure , ...
      'Units','pixels',...
      'BackgroundColor',[0.8 0.8 0.8], ...
      'ListboxTop',0, ...
      'Position',[10 120 100 30], ...
      'String','[ Ch Time Annote ]', ...
      'Style','radiobutton', ...
      'Tag','Opt.Zeng',...
      'value',1,...
      'callback',[...
         'set(findobj(gcbf,''tag'',''Opt.Old'',''style'',''radiobutton''),''value'',0);',...
         'set(gcbo,''value'',1)']);
   Type.Opt.Old = uicontrol('Parent',Type.Figure , ...
      'Units','pixels',...
      'BackgroundColor',[0.8 0.8 0.8], ...
      'ListboxTop',0, ...
      'Position',[10 80 100 30], ...
      'String','[ Time Ch Annote ]', ...
      'Style','radiobutton', ...
      'Tag','Opt.Old',...
      'value',0,...
      'callback',[...
         'set(findobj(gcbf,''tag'',''Opt.Zeng'',''style'',''radiobutton''),''value'',0);',...
         'set(gcbo,''value'',1)']);
   
   %I will send 4 varargouts if I have to swarp to be [T C A]
   Type.Button.Ok = uicontrol('Parent',Type.Figure, ...
      'Units','pixel', ...
      'ListboxTop',0, ...
      'Position',[40 5 45 23.25], ...
      'String','OK',...
      'Tag','Pushbutton1',...
      'callback',[...
         'Type=get(gcbf,''userdata'');',...
         'if get(Type.Opt.Zeng,''value'');',...
         '   Zeng_Annote(''Load second type 2'',Type.EditAnnote,Type.FileName,1);',...
         'else;',...
         '   Zeng_Annote(''Load second type 2'',Type.EditAnnote,Type.FileName,2);',...
         'end;',...
         'close(gcbf);']);
   
   Type.Button.Cannel = uicontrol('Parent',Type.Figure, ...
      'Units','pixel', ...
      'ListboxTop',0, ...
      'Position',[100 5 41.25 21.75], ...
      'String','Cancel',...
      'callback','close(gcbf)');
   set(Type.Figure,'userdata',Type);
   
case 'Load second type 2'
   %2)=EditAnnote,3)Filename
   %-----------
   FID=fopen(varargin{3});
   EditAnnote=get(varargin{2},'userdata');
   Stripchart=get(EditAnnote.Parent,'userdata');
   
   
   Stripchart.Annote.Array=[];
   Stripchart.Annote.Show=[];
   Stripchart.Annote.ShowComment={};
   
   
   Temp.Patch=[];
   Temp.Line=fgetl(FID);
   while ~strcmp(char(9),Temp.Line)% & Temp.Line~=-1%(EOF)
      Temp.Int=find(Temp.Line==9);
      %Time Ch Ant
      Temp.Test=str2num([Temp.Line((Temp.Int(1)+1):Temp.Int(2))  Temp.Line(1:Temp.Int(1))]);
      %Ch Time Ant 
      Temp.Length=length(Temp.Line((Temp.Int(2)+1):length(Temp.Line)));
      if Temp.Length>Stripchart.Annote.ShowLength
         Temp.Letter=Temp.Line((Temp.Int(2)+1):(Temp.Int(2)+Stripchart.Annote.ShowLength));
      elseif Temp.Length<Stripchart.Annote.ShowLength
         Temp.Letter=[Temp.Line((Temp.Int(2)+1):length(Temp.Line)) 32*ones(1,Stripchart.Annote.ShowLength-Temp.Length)];
      else
         Temp.Letter=Temp.Line((Temp.Int(2)+1):length(Temp.Line));
      end
      
      
      if Temp.Test(1)>-1
         Stripchart.Annote.Array=[Stripchart.Annote.Array;[Temp.Test Temp.Letter+0]];
         if length(strmatch(Temp.Letter,Stripchart.Annote.Array(:,3:length(Stripchart.Annote.Array(1,:)))))==1
            Stripchart.Annote.Show=[Stripchart.Annote.Show; 1 Temp.Letter+0];
            Stripchart.Annote.ShowComment=[Stripchart.Annote.ShowComment;{'No Comment'}];
         end
      else
         Temp.Patch=[Temp.Patch Temp.Test(2)]; 
      end
      if feof(FID)
         break
      else
         Temp.Line=fgetl(FID);
      end
      
   end
   fclose(FID);
   
   
   
   set(EditAnnote.Figure,'userdata',EditAnnote);
   set(Stripchart.Figure,'userdata',Stripchart);
   Zeng_Annote('Reset List',EditAnnote.Figure);
   if ~isempty(Temp.Patch);
      Temp.Length=length(Temp.Patch);
      if mod(Temp.Length,2)
      else
         Temp.Patch=reshape(Temp.Patch,[2 Temp.Length/2])';
         Zeng_Stripchart('Load Patch from File',Stripchart.Figure,Temp.Patch);
      end
   end
   
case 'Load Zeng Annote'
   FID=fopen(varargin{3});
   EditAnnote=get(varargin{2},'userdata');
   Stripchart=get(EditAnnote.Parent,'userdata');
   %Get rid of the title
   Temp.Line=1;
   while ~strcmp('Show:',Temp.Line)
      Temp.Line=fgetl(FID);
   end
   Stripchart.Annote.Show=[];
   Stripchart.Annote.ShowComment={};
   Temp.Line=fgetl(FID);
   while ~strcmp(char(9),Temp.Line) %\t\n=9
      Stripchart.Annote.Show=[Stripchart.Annote.Show;[1 Temp.Line+0]];
      Stripchart.Annote.ShowComment=[Stripchart.Annote.ShowComment;{fgetl(FID)}];
      Temp.Line=fgetl(FID);
   end
   %Get rid of the Annote title
   Temp.Line=fgetl(FID);
   %---------------------------------------
   Stripchart.Annote.Array=[];
   Temp.Patch=[];
   Temp.Line=fgetl(FID);
   while ~strcmp(char(9),Temp.Line) 
      Temp.Int=find(Temp.Line==9);
      %Time Ch Ant
      Temp.Test=[str2num([Temp.Line((Temp.Int(1)+1):Temp.Int(2)) Temp.Line(1:Temp.Int(1))]) Temp.Line((Temp.Int(2)+1):length(Temp.Line))+0]; 
      %Ch Time Ant
      if Temp.Test(1)<0 %Time Ch Ant
         Temp.Patch=[Temp.Patch Temp.Test(2)]; 
      else
         Stripchart.Annote.Array=[Stripchart.Annote.Array;Temp.Test];
      end
      Temp.Line=fgetl(FID);
   end
   fclose(FID);
   set(EditAnnote.Figure,'userdata',EditAnnote);
   set(Stripchart.Figure,'userdata',Stripchart);
   if ~isempty(Temp.Patch);
      Temp.Length=length(Temp.Patch);
      if mod(Temp.Length,2)
      else
         Temp.Patch=reshape(Temp.Patch,[2 Temp.Length/2])';
         Zeng_Stripchart('Load Patch from File',Stripchart.Figure,Temp.Patch);
      end
   end
   
   Zeng_Annote('Reset List',EditAnnote.Figure);
   
case 'Save'
   if strcmp(get(gcbf,'tag'),'Stripchart');
      Stripchart=get(gcbf,'userdata');
      EditAnnote=get(Stripchart.Annote.Figure,'userdata');
      
   elseif strcmp(get(gcbf,'tag'),'EditAnnote');
      EditAnnote=get(gcbf,'userdata');
      Stripchart=get(EditAnnote.Parent,'userdata');
   else
      a='Err in Annote-Save'
      return
   end
   
   if nargin==1 %save
      if isempty(Stripchart.Annote.FileName)
         FILENAME=Stripchart.Annote.FileName;
         PATHNAME=Stripchart.Annote.Path;
      else
         FILENAME=Stripchart.Annote.FileName;
         PATHNAME=Stripchart.Annote.Path;
      end
   elseif nargin==2 %for save as
       if ~isempty(dir('annotepath.mat'))
       load annotepath
      [FILENAME, Log.UD.DataCD] = uiputfile([annotepath Stripchart.Head.FileName '.ant'], 'Save Annote ...(Work hard, not hardly)');
      PATHNAME=Log.UD.DataCD; 
      annotepath=Log.UD.DataCD;
      save annotepath annotepath
       else
      [FILENAME, Log.UD.DataCD] = uiputfile([pwd Stripchart.Head.FileName '.ant'], 'Save Annote ...(Work hard, not hardly)');
      PATHNAME=Log.UD.DataCD; 
      annotepath=Log.UD.DataCD; 
       end

   end
   if ~strcmp('0',num2str(FILENAME)) & ~strcmp('0',num2str(PATHNAME));
      %if you do not click cancel
      %Adjust the file name..
      Big=find(FILENAME>=65 & FILENAME<=90);
      %Make them all small
      FILENAME(Big)=FILENAME(Big)+32;
      FILENAME_length=length(FILENAME);
      if FILENAME_length<5;
         FILENAME=[FILENAME '.ant'];
      elseif ~strcmp(char([FILENAME((FILENAME_length-3):FILENAME_length)]),'.ant')
         FILENAME=[FILENAME '.ant'];
      end

      %
      %
      if isempty(Stripchart.Annote.Array) & ~Stripchart.Annote.IncludeSM;

         Zeng_Error('You have no annote');
      else
         if isempty(Stripchart.Annote.Array) & isempty(Stripchart.Patch.X)
            Zeng_Error('You have nothing to save');
            
         else
            set(Stripchart.Menu.File(3),'enable','on');
            Stripchart.Annote.Changed=0;
            Stripchart.Annote.FileName=FILENAME;
            Stripchart.Annote.Path=PATHNAME;
            
            set(Stripchart.Figure,'userdata',Stripchart);
            dlmwrite([PATHNAME FILENAME],'');
            FID=fopen([PATHNAME FILENAME],'w');

            if Stripchart.Annote.IncludeInf
               YMDHMS=clock;
               fprintf(FID,'=================================================\n');
               fprintf(FID,'CWRU Cardio Mapping System : Annotation file     \n');
               fprintf(FID,'=================================================\n');
               fprintf(FID,['Date(Y/M/D):' num2str(YMDHMS(1)) '/' num2str(YMDHMS(2)) '/' num2str(YMDHMS(3)) '\n']);
               fprintf(FID,['Time(H/M/S):' num2str(YMDHMS(4)) ':' num2str(YMDHMS(5)) ':' num2str(YMDHMS(6)) '\n']);
               fprintf(FID,['---------------\n']);
               fprintf(FID,['Show:\n']);
               if ~isempty(Stripchart.Annote.Show)
                  for i=1:length(Stripchart.Annote.Show(:,1));
                     fprintf(FID,[char(Stripchart.Annote.Show(i,2:(1+Stripchart.Annote.ShowLength))) '\n']);
                     fprintf(FID,[Stripchart.Annote.ShowComment{i} '\n']);
                  end
               end
               fprintf(FID,['\t\n']);
               fprintf(FID,[' Time \t Ch \t Annote \n']);
            end
            
            if Stripchart.Annote.IncludeSM
               for n=1:size(Stripchart.Patch.X,1)
                  fprintf(FID,[num2str(round(Stripchart.Patch.X(n,1))) '\t' num2str(-1) '\t' 'Z' num2str(n)   '\n']);
                  fprintf(FID,[num2str(round(Stripchart.Patch.X(n,2))) '\t' num2str(-1) '\t'   'Z' num2str(n)   '\n']);
               end
            end
            
            if ~isempty(Stripchart.Annote.Array)
               for i=1:length(Stripchart.Annote.Array(:,1));
                  fprintf(FID,[ num2str(round(Stripchart.Annote.Array(i,2))) '\t' num2str(Stripchart.Annote.Array(i,1)) '\t' char(Stripchart.Annote.Array(i,3:(2+Stripchart.Annote.ShowLength)))  '\n']);
               end
            end
            %TheOne=findobj(EditAnnote.Menu.Setting,'tag','Include segments');
            %if strcmp('on',get(TheOne,'Checked'));
            fprintf(FID,['\t\n']);
            Status=fclose(FID);
            if Status== -1;
               Zeng_Error('I Could not save  file for you');
            end
         end %         if isempty(Stripchart.Annote.Array) & isempty(Stripchart.Patch.X)
      end %      if isempty(Stripchart.Annote.Array) & ~Stripchart.Annote.IncludeSM
   end %      if ~strcmp('0',num2str(FILENAME)) & ~strcmp('0',num2str(PATHNAME))

end
   
   

   


