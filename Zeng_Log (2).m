function Zeng_Log(varargin)
global Log
global Data

action = varargin{1};
switch action
%---------------------------------------------------   
case 'Initial'
	%='initial'
   set(0,'userdata',[]);
	Zeng_Share('DeleteFcn','Initial')
   clear All
   global Log
   global Data

	Log.UD.ScreenSize=max(reshape(get(0,'screensize'),2,2)');
	%Default setting..
	%Donot change any position, especially with UD.HD.Default.Figure
	% Please keep it be the first setting.
	Continue=1;
	if strcmp('PCWIN',computer);
   	Log.UD.CD='\';
   	Log.UD.Path=cd;
	elseif strcmp('MAC2',computer)
   	Log.UD.CD=':';
   	Log.UD.Path=cd;
   	Log.UD.Path(length(Log.UD.Path))=[];%to remove the ':'
	else
   	Zeng_Error('I like either PC or Mac');
   	Continue=0;
	end
	if Continue
      addpath([cd Log.UD.CD 'M' ])
      %eval(['addpath ' Log.UD.Path]);
   	%eval(['addpath ' Log.UD.Path Log.UD.CD 'M']);
   	%-----------------------------------------------------------
   	%Data subdirectory, I will add it when you choose Dic in Log.
   	%We need it for saving any file.
   	Log.UD.DataCD=[];
      Log.UD.Default.Derv_Thresh=  15;   
   	Log.UD.Default.Volt_Thresh=2200;
   	Log.UD.Default.RefacPeriod=100;
   	Log.UD.HD.Default=Log.UD.Default;
   	%-----------------------------------------------------------------
   	%------------------------------------------------------------------
   	% [X Y] (There are usually [800 600])
	   %------------------------------------------------------------------
   	Log.UD.HD.Log.FG_Limit        =[160 160];
	   Log.UD.HD.Stripchart.FG_Limit =[640 110];
   	Log.UD.HD.WaveForm.FG_Limit   =[200 150];
	   Log.UD.HD.EditAnnote.FG_Limit   =[200 290];
   	Log.UD.HD.Connection.FG_Limit   =[290 290];
	   Log.UD.HD.LUTDisplay.FG_Limit   =[290 290];
   	Log.UD.HD.Data_Info.FG_Limit  =max([Log.UD.ScreenSize/2],[400 300]);
	   Log.UD.HD.Default.FG_Limit    =max([Log.UD.ScreenSize/2],[400 300]);
   	%Log.UD.HD.Log.FG_Limit        =[280 300];
	   %Log.UD.HD.Stripchart.FG_Limit =[Log.UD.ScreenSize(1)/2 120];
   	%Log.UD.HD.WaveForm.FG_Limit   =min([Log.UD.ScreenSize/2],[400 300]);
	   %Log.UD.HD.Data_Info.FG_Limit  =max([Log.UD.ScreenSize/2],[400 300]);
   	%Log.UD.HD.Default.FG_Limit    =max([Log.UD.ScreenSize/2],[400 300]);
   
	   if sum(Log.UD.ScreenSize >= [ 800 600])==2 % for big screen
   	   %Please be careful figure number and Ref.Position( *,:)
      	Log.UD.HD.Log.Figure        =1;Log.UD.Ref.Position(1,:) =[0.59875*Log.UD.ScreenSize(1) 0.323333333333333*Log.UD.ScreenSize(2) 0.35*Log.UD.ScreenSize(1) 0.566666666666667*Log.UD.ScreenSize(2) ];
	      Log.UD.HD.Stripchart.Figure =2;Log.UD.Ref.Position(2,:) =[0.05125*Log.UD.ScreenSize(1) 0.045*Log.UD.ScreenSize(2) Log.UD.HD.Stripchart.FG_Limit ];
   	   %Log.UD.HD.WaveForm.Figure =3;Log.UD.Ref.Position(3,:) =[Log.UD.ScreenSize(1)/2-720/2 Log.UD.ScreenSize(2)/2-255   720 520]; %[ 0.05 0.323333333333333 0.8925 0.526666666666667 ]
	      Log.UD.HD.Common.Figure     =4;
   	   Log.UD.HD.Data_Info.Figure  =5;Log.UD.Ref.Position(5,:) =[Log.UD.ScreenSize(1)/2-400/2 Log.UD.ScreenSize(2)/2-300/2 400 300];
	      Log.UD.HD.Default.Figure    =6;Log.UD.Ref.Position(6,:) =[Log.UD.ScreenSize(1)/2-400/2 Log.UD.ScreenSize(2)/2-300/2 400 300];
   	   Log.UD.HD.EditAnnote.Figure =7;Log.UD.Ref.Position(7,:) =[0 0 Log.UD.ScreenSize(1)/3 Log.UD.ScreenSize(2)/3];
	   else                                   % for small screen
   	   Log.UD.HD.Log.Figure        =1;Log.UD.Ref.Position(1,:) =[0.59875*Log.UD.ScreenSize(1) 0.323333333333333*Log.UD.ScreenSize(2) 0.35*Log.UD.ScreenSize(1) 0.566666666666667*Log.UD.ScreenSize(2) ];
      	Log.UD.HD.Stripchart.Figure =2;Log.UD.Ref.Position(2,:) =[0.05125*Log.UD.ScreenSize(1) 0.045*Log.UD.ScreenSize(2) Log.UD.HD.Stripchart.FG_Limit ];
	      %Log.UD.Ref.Position = analysis position default.
   	   Log.UD.Ref.Position(3,:) =[Log.UD.ScreenSize(1)/2-720/2 Log.UD.ScreenSize(2)/2-155   720 520];
      	%Log.UD.HD.WaveForms.Figure  =3;Log.UD.Ref.Position(3,:) =[Log.UD.ScreenSize(1)/2-720/2 Log.UD.ScreenSize(2)/2-155   720 390];
	      Log.UD.HD.Common.Figure=4;
   	   Log.UD.HD.Data_Info.Figure  =5;Log.UD.Ref.Position(5,:) =[Log.UD.ScreenSize(1)/2-400/2 Log.UD.ScreenSize(2)/2-300/2 400 300];
      	Log.UD.HD.Default.Figure    =6;Log.UD.Ref.Position(6,:) =[Log.UD.ScreenSize(1)/2-400/2 Log.UD.ScreenSize(2)/2-300/2 400 300];
	      Log.UD.HD.EditAnnote.Figure =7;Log.UD.Ref.Position(7,:) =[Log.UD.ScreenSize(1)/2-400/2 Log.UD.ScreenSize(2)/2-300/2 Log.UD.ScreenSize/2];
	     
   	end
	   %----------------------------------------------
   	Log.UD.Ref.ThickLine=6;
	   Log.UD.Ref.ThinLine=2;
	   %The relation between Fontsize on Edit box size is that
	   %Edit box height = Fontsize+3 for text,not edit   %Do not forget to set the font unit  to be pixels
   	%Edit box width  = 6*Digit
	   %                = [56 +(fontsize-7)*8   12.5+(fontsize-7)*3.5]
   	%point:pixels =1.3333:1
	   %
   
   	Log.UD.Ref.FontSize=7;
   
	   Log.UD.Ref.Ch_Box=[38 18];   %[38+(Fontsize-7)*3.5) (for 4 digits),18+(Fontsize-7)*2]
   	Log.UD.Ref.Time_Box=[56 14];
	   Log.UD.Ref.AxesSz=[50 20 640 70]; %base stripchart for each stripchart window
   	Log.UD.Ref.AnalysisSz=[Log.UD.ScreenSize(1)/2-720/2 Log.UD.ScreenSize(2)/2-260   720 520];
	   Log.Annote.Label{1}='AT ';
   	Log.Annote.Label{2}='RT ';
	   Log.Annote.Label{3}='APD';
   
   	%=================================================================
	   %_________________________________________________________________
   
	   % Log.UD.=[]; is important,  Using for checking in "Data_Info" if Head exits.
   
	   Log.UD.Head=[]; 
   	%Log.UD.Stripchart=[];
	   %Log.UD.Data=[];
   	%_________________________________________________________________

	   %------------------------------------
   	Log.Figure=figure;
	   %-----------------------------------
   	%Important: using in reading only and transfering UD.Head back here from there
	   Log.Object=[];
   	%-----------------------------------
	   FG_Size(3:4)=[280 300];
   	FG_Size(1:2)=[Log.UD.ScreenSize(1)-FG_Size(3) Log.UD.ScreenSize(2)-FG_Size(4)-40 ];
   
	   set(Log.Figure,...
   	   'Color',[0.8 0.8 0.8], ...
      	'DeleteFcn','Zeng_Log(''DeleteFcn'')',...
         'menu','none',...
         'Name','Log in',...
         'NumberTitle','off',...
         'Position',FG_Size, ...
         'Tag','Log');
      
   	Log.ListBoxSz=[5 37 (FG_Size(3)-10) (FG_Size(4)-70)];
   	Log.ListBox = uicontrol('Parent',Log.Figure, ...
         'Units','pixels',...
         'BackgroundColor',[1 1 1], ...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Log.ListBoxSz, ...
         'Style','listbox', ...
         'value',0,...
         'Tag','Listbox1');
   	Log.Button.LoadSz=[FG_Size(3)/4-60/2 10 60 22];
 	   Log.Button.Load = uicontrol('Parent',Log.Figure, ...
         'Units','pixels',...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Log.Button.LoadSz, ...
         'String','Directory', ...
         'callback','Zeng_Log(''Open Directory'')',...  
         'Tag','Pushbutton1');
	   Log.Button.DisplaySz=[FG_Size(3)*3/4-60/2 10 60 22];
   	Log.Button.Display = uicontrol('Parent',Log.Figure, ...
         'Units','pixels',...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Log.Button.DisplaySz, ...
         'String','Load', ...
         'callback','Zeng_Log(''Display'')',...  
         'Tag','Pushbutton1');
	   Log.Button.DeleteSz=[FG_Size(3)*3/4-60/2 10 60 22];
   	Log.Button.Delete = uicontrol('Parent',Log.Figure, ...
         'Units','pixels',...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Log.Button.DeleteSz, ...
         'String','Remove', ...
         'callback','Zeng_Log(''Selected'',''Delete'')',...  
         'visible','off',...
         'enable','off',...
         'Tag','Pushbutton1');
      
	   Log.Text.FileSz=[10 (FG_Size(4)-30) 60 22];
   	Log.Text.File = uicontrol('Parent',Log.Figure, ...
         'BackgroundColor',[0.8 .8 .8],...
         'FontName','Arial',...
         'FontUnits','points',...
         'FontSize',Log.UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Units','pixels',...
         'Position',Log.Text.FileSz, ...
         'String','File Name',...
         'style','text');
      
	   Log.Text.CommentSz=[(FG_Size(3)*2/4) (FG_Size(4)-30) 60 22];
   	Log.Text.Comment = uicontrol('Parent',Log.Figure, ...
      	'BackgroundColor',[0.8 .8 .8],...
	      'FontName','Arial',...
   	   'FontUnits','points',...
      	'FontSize',Log.UD.Ref.FontSize,...
	      'FontWeight','normal',...
   	   'FontAngle','normal',...
      	'Units','pixels',...
	      'Position',Log.Text.CommentSz, ...
   	   'String','Comment',...
      	'style','text');
	   %set(Log.Figure,'userdata',Log);
   	%-----------------------------------------------------------
	   %Zeng_Share('Common Menu');
   	if 0
      	Hm_File={
         	'File'                            ' '                               'filemenu'
	         '>Open...'                        ' '                               ' '
   	      '>>a file...'                     'Zeng_Log(''Read'',''FromLog'')'  ' '
      	   '>>List    ...'                   'Zeng_Log(''Open List'')'         ' '
         	'>>Directory.'                    'Zeng_Log(''Open Directory'')'    ' '
	         '>Delete...'                      ' '                               ' '
   	      '>>All ...'                       'Zeng_Log(''All'',''Delete'')'  ' '
      	   '>>All but selected ...'          'Zeng_Log(''All but selected'',''Delete'')'  ' '
         	'>>Ten from selected ...'         'Zeng_Log(''Ten from selected'',''Delete'')'  ' '
	         '>>Seleted ...'                   'Zeng_Log(''Selected'',''Delete'')'  ' '
   	      '>------'                         ' '                               ' '
      	   '>Save ...'                       ' '                               ' '
         	'>>List...'                       'Zeng_Log(''Save Lise'')'  ' '
	         '>>as jpg...'                     'print -djpeg100 -noui a'   ' '
   	      '>>as deps...'                    'print -deps -noui a'      ' '
      	   '>>as Bitmap...'                  'print -dbitmap -noui a'   ' '
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
   	   makemenu(Log.Figure,char(Hm_File(:,1)),char(Hm_File(:,2)), char(Hm_File(:,3)));
      	makemenu(Log.Figure,char(Hm_Setting(:,1)),char(Hm_Setting(:,2)), char(Hm_Setting(:,3)));
      	Hm_User={
	   	   'User'                  ' '                             
   	   	'>Load...'              'Zeng_Log(''Load User'')'        
	      	'>Save...'              'Zeng_Log(''Save User'')'};
		   makemenu(Log.Figure,char(Hm_User(:,1)),char(Hm_User(:,2)));%, char(Hm_Setting(:,3)));
	   end %if 0	

		%-----------------------------------------------------------
	   set(Log.Figure,'ResizeFcn','Zeng_Log(''ResizeFcn'')');
   	if 0 
			%to load user file automatically
			Zeng_Log('Load User','dif 0:\')
   	elseif 0
			Zeng_Log('Open Directory','User','d:\data\');
	   elseif 1
			%Zeng_Log('Open Directory','User','c:\project\iofile\data2\');
			%Zeng_Log('Open Directory','User','c:\matlab\zeng\alldata\');
	   end
	   %=====================================================================================
      %=====================================================================================
   end %if Continue
   
case 'Log'
   %Call Log from windows-log
   Temp=findobj('type','figure','tag','Log');
   if isempty(Temp)
      Zeng_Log('Initial'); 
   else
      figure(Temp);
   end
case 'Read'
   %Sys_Ver influences how to open the annote file in EditAnnote.
   ShowHiddenHandles=get(0,'ShowHiddenHandles');
   set(0,'ShowHiddenHandles','on')
   if strcmp(varargin{2},'Open List') | strcmp(varargin{2},'Open Directory')
      %Open list from Log.
      %Log=get(gcbf,'userdata');
      FileName=Log.Temp.FileName;
      Path=Log.Temp.Path;
   elseif strcmp(varargin{2},'Open Common Group')
      Common=get(gcbf,'userdata');
      FileName=Common.Temp.FileName;
      Path=Common.Path;
   elseif strcmp(varargin{2},'FromDisplay')
      FileName=Log.Object(Log.Current_File).FileName;
      Path    =Log.Object(Log.Current_File).Path;
   else
      Zeng_Error('Error in "Reading Head File" in Log')
   end
   
   %Change pointer
   Children_FG=get(0,'children');
   set(Children_FG,'pointer','watch');
   
   if max([FileName Path]) ~= 0%if you do not click cancel
      if ~isempty(find(FileName=='.'));
         FileName=FileName(1:find(FileName=='.')-1);
      end
      %Change the letters to be the small one
      Temp=find(FileName>=65 &  FileName<=90);
      FileName(Temp)=FileName(Temp)+32;
      
      FID=fopen([Path FileName '.h']);
      if FID > -1 & ~isstr(FID);           %If .h exists.
         Head_Data=fread(FID,inf,'uchar');
         fclose(FID);
         %----------------------------------------      
         %Log.UD.Temp.Old_Head=Log.UD.Head;
         %----------------------------------------      
         Log.Head=[];
         Log.Head.FileName=FileName;
         Log.Head.Path=Path;
         Log.Temp.GoodFile=0;%to check if we can open it
         if isempty(find(Head_Data==0));
            % The head file was saved in ascii format.
            % the Ver is either  3rd System  (Optic) data  or Zeng's version
            FID=fopen([Path FileName '.h']);
            
            while feof(FID)==0
               Line=fgets(FID);
               Temp.Swarp=find(Line>=65 & Line<=90);
               %Convert them to all small characters
               Line(Temp.Swarp)=Line(Temp.Swarp)+32;
               Start=find(Line==char(9) | Line==(32));%Char(9) = space between tile and value
               Stop=find(Line==char(13));%Char(13)= New line
               if isempty(Stop);
                  Stop=find(Line==char(10));%Char(13)= New line
               end
               if ~isempty(strmatch('subject',Line));
                  %Log.Head.Subject =string(Line(Start(1)+1:Stop(length(Stop))-1)')';
                  Log.Head.Subject =char(Line(Start(1)+1:Stop(length(Stop))-1)')';
               elseif  ~isempty(strmatch('date',Line));
                  %Log.Head.Date =string(Line(Start(1)+1:Stop(length(Stop))-1)')';
                  Log.Head.Date =char(Line(Start(1)+1:Stop(length(Stop))-1)')';
               elseif ~isempty(strmatch('gain',Line));
                  %Log.Head.Gain =str2num(string(Line(Start(1)+1:Stop(length(Stop))-1)')');
                  Log.Head.Gain =str2num(char(Line(Start(1)+1:Stop(length(Stop))-1)')');
               elseif ~isempty(strmatch('srate',Line));
                  %Log.Head.SRate =str2num(string(Line(Start(1)+1:Stop(length(Stop))-1)')');
                  Log.Head.SRate =str2num(char(Line(Start(1)+1:Stop(length(Stop))-1)')');
               elseif ~isempty(strmatch('samples',Line));
                  %Log.Head.Samples =str2num(string(Line(Start(1)+1:Stop(length(Stop))-1)')');
                  Log.Head.Samples =str2num(char(Line(Start(1)+1:Stop(length(Stop))-1)')');
               elseif ~isempty(strmatch('chans',Line));
                  %Log.Head.Chans =str2num(string(Line(Start(1)+1:Stop(length(Stop))-1)')');
                  Log.Head.Chans =str2num(char(Line(Start(1)+1:Stop(length(Stop))-1)')');
               elseif ~isempty(strmatch('comment',Line));
                  %Log.Head.Comment =string(Line(Start(1)+1:Stop(length(Stop))-1)')';
                  Log.Head.Comment =char(Line(Start(1)+1:Stop(length(Stop))-1)')';
               elseif ~isempty(strmatch('lut',Line));
                  %Log.Head.LUT =string(Line(Start(1)+1:Stop(length(Stop))-1)')';
                  Log.Head.LUT =char(Line(Start(1)+1:Stop(length(Stop))-1)')';
               elseif ~isempty(strmatch('Sys_Ver',Line));
                  %Log.Head.Sys_Ver =string(Line(Start(1)+1:Stop(length(Stop))-1)')';
                  Log.Head.Sys_Ver =char(Line(Start(1)+1:Stop(length(Stop))-1)')';
               end
            end
            Log.Head.RawDataVer=0;
            %Log.Head.LUTExt='lut';
            Temp=find(Log.Head.LUT== '/' | Log.Head.LUT=='\'  | Log.Head.LUT==':');
            if ~isempty(Temp)
               Log.Head.LUT(1:max(Temp))=[];
            end
            
            if ~isfield(Log.Head,'Sys_Ver')
               %if the head file doesn't include the system version
               Log.Head.Sys_Ver='Optical Mapping System';   
            end
            Log.Head.Help.DataType=1;
            
            fclose(FID);
            Log.Temp.GoodFile=1;
            
         elseif length(Head_Data)==480 %         if isempty(find(Head_Data==0));
            if Head_Data(91)==0;               %Ver 1st data.
            	%Common values
	            %Log.Head.Subject =string(Head_Data(1:4)');
   	         %Log.Head.Date    =string(Head_Data(5:14)');
      	      Log.Head.Subject =char(Head_Data(1:4)');
         	   Log.Head.Date    =char(Head_Data(5:14)');
            	Log.Head.Gain    =Head_Data(473)+Head_Data(474)*256;
	            Log.Head.SRate   =Head_Data(475)+Head_Data(476)*256;
   	         Log.Head.Samples =500*(Head_Data(471)+Head_Data(472)*256);
      	      Log.Head.Chans   =Head_Data(469)+Head_Data(470)*256;
         	   Log.Head.Comment =char(Head_Data(61:90)');
	            Log.Head.LUT     =[char(Head_Data(59:60)') '.tab'];
	            Log.Head.Sys_Ver ='CWRU Extra cellular 1';
            
   	         %Log.Head.LUTExt='tab';
      	      Log.Head.Help.DataType=2;
         	   Log.Head.RawDataVer=1;
            
            	%uncommon values
	            %         Log.Head.LFreq   =fread(FID,1,'float');
   	         %         Log.Head.Name    ='Mr. Dog';
      	      %         Log.Head.Study   =string(Head_Data(49:53)');
         	   Log.Temp.GoodFile=1;
            
         	else %Head_Data(91)==48;%Ver 2nd data.
            	%Common values
	            %Log.Head.Subject  =string(Head_Data(91:95)');
   	         %Log.Head.Date    =string(Head_Data(137:177)');
      	      Log.Head.Subject  =char(Head_Data(91:95)');
         	   Log.Head.Date    =char(Head_Data(137:177)');
	            Log.Head.Gain    =Head_Data(473)+Head_Data(474)*256;
   	         Log.Head.SRate   =Head_Data(475)+Head_Data(476)*256;
      	      Log.Head.Samples =512*(Head_Data(471)+Head_Data(472)*256);
         	   Log.Head.Chans   =Head_Data(469)+Head_Data(470)*256;
            	Log.Head.Comment =char(Head_Data(178:218)');
	            Log.Head.LUT     =[char(Head_Data(240:243)') '.tab'];
               
               Log.Head.Sys_Ver ='CWRU Extra cellular 2';
            	
	            LUT=Log.Head.LUT;            
            
            	Log.Head.LUT(find(Log.Head.LUT<33 | Log.Head.LUT>125))=[]; 
	            %Log.Head.LUTExt='tab';
   	         Log.Head.RawDataVer=2;
      	      Log.Head.Help.DataType=2;
            
         	   %The channel data from head file are not correct.
			   	FID2=fopen([Log.UD.Path Log.UD.CD 'lut' Log.UD.CD Log.Head.LUT],'r');
				   if FID2>0
   	            Log.Head.Chans=str2num(fgetl(FID));
      	         Log.Temp.GoodFile=1;
         	      fclose(FID2);
	            else
   	            %Log.Head.LUT;
      	         %No information from the head file of the 2nd version.
         	      % I will fix it by channel=( raw data side / samples) in Zeng_Share('read raw')
            	   %Log.Head.Chans='No infomation';
	            end

	            %uncommon values
   	         %         Log.Head.LFreq   =Head_Data(477)+Head_Data(478)*256;
      	      %         Log.Head.Name    =string(Head_Data(96:136)');
         	   %         Log.Head.Study   =string(Head_Data(219:239)');
            	%         Log.Head.ECG1    =Head_Data(467)+Head_Data(468)*256;
	            %         Log.Head.ECG2    =Head_Data(465)+Head_Data(466)*256;
   	         %         Log.Head.Mark1   =Head_Data(463)+Head_Data(464)*256;
      	      %         Log.Head.Mark2   =Head_Data(461)+Data1(462)*256;
         	end %If ==0
         end;  %       if isempty(find(Head_Data==0));

         %Stripchart.Head.Help.DataType is used in  "Stripchart.Head.Chans/Stripchart.Head.Help.DataType"
         %   to check if it is bipolar or not, if it is over the num of channel
         %1= optical(mono) , 2=extra cell(Bi)
         if Log.Temp.GoodFile
            Temp.Junk=find(Log.Head.LUT<32 | Log.Head.LUT>126);
            Log.Head.LUT(Temp.Junk)=[];
            
            % nargin=2 when Log wants to read only head file.
            %set(Log.Figure,'userdata',Log);%Read_Only_Head=1;
            if strcmp(varargin{2},'FromOpen');
               Zeng_Log('Read Raw','FromOpen');
            elseif strcmp(varargin{2},'FromDisplay')
               Zeng_Log('Read Raw','FromDisplay');
            else %strcmp(varargin{2},'FromLog'); %strcmp(varargin{2},'Open List');'
               Log.Temp.Head.FileName=Log.Head.FileName;
               Log.Temp.Head.Path    =Log.Head.Path;
               Log.Temp.Head.Comment =Log.Head.Comment;
               if isempty(Log.Object);
                  Log.Object=Log.Temp.Head;
               else
                  Log.Object=[Log.Object;Log.Temp.Head];%Log.Head.FileName=Temp;
               end
               Log.Temp=[];
               %set(Log.Figure,'userdata',Log);%Read_Only_Head=1;
               Zeng_Log('Update List')
            end         
         end
      else; %No head file....
         % nargin=2 when Log wants to read only head file.
         if strcmp(varargin{2},'Open List') | strcmp(varargin{2},'Open Directory')
            Zeng_Share('Error','Uhm...Some of them','I didn''t see it');
         elseif strcmp(varargin{1},'Open Common Group')
         else
            %Log.UD.Temp.Head.FileName=FileName;
            %Log.UD.Temp.Head.Path    =Path;
            Zeng_Error('No head files');
         end
         
         
      end %If FID>-1 & ~isstr(FID)
      
   end  %If You click cancel
   
   set(0,'ShowHiddenHandles',ShowHiddenHandles)
   set(Children_FG,'pointer','arrow');
   
   %=====================================================================================      
   %=====================================================================================
case 'Read Raw'
   %=====================================================================================
   ShowHiddenHandles=get(0,'ShowHiddenHandles');
   set(0,'ShowHiddenHandles','on')
   %Log=get(gcbf,'userdata');
   if strcmp(get(gcf,'tag'),'Stripchart')
      %Change the Data in the current stripchart.
      OpenStyle=2;
      %We have to add the new file name in the list, and delete the old one also.
   elseif strcmp(varargin{2},'FromOpen');
      % Open-Menu New stripchart from Log.
      OpenStyle=1;
   elseif strcmp(varargin{2},'FromDisplay')
      OpenStyle=0;
   end
   
   ChLabel=Zeng_LUTDisplay('LUT Reading',Log.Head.LUT ,'ChLabel',Log.Head.Help.DataType,Log.Head.Chans);
   if isempty(ChLabel)
      Log.Temp.GoodFile=0;
   elseif ~isempty(findobj('name',[Log.Head.FileName ':Stripchart']));
      Zeng_Error('You already had me');
   else
      %Change pointer
      Children_FG=get(0,'children');
      set(Children_FG,'pointer','watch');
      
      Bad_Raw_File=0;
      FID=fopen([Log.Head.Path Log.Head.FileName]);
      if FID > -1 & ~isstr(FID) % if raw data exits.
      	fseek(FID,-1,'eof');%for checking the file size.
      	if 0 %ftell(FID)>5000000
            fclose(FID);
            Zeng_Error(['Your file is too big' char([10 10]) 'Please buy more RAM'])
         else
            frewind(FID)
	         %1)Format_Check=char(fread(FID,19,'char')');    % Check the first 20 bytes if it is MIT head format.
   	      %2)Format_Check=(fread(FID,7,'char')')    % Check the first 20 bytes if it is MIT head format.
      	   Format_Check=(fread(FID,7,'uchar')');    % Check the first 20 bytes if it is MIT head format.
         	fclose(FID);
         	%1)if ~strcmp(Format_Check,'COLUMN BINARY FILE')
         	%2)if ~strcmp(char(Format_Check),'COLUMN')
         	%                    [ C  O  L  U  M  N ]
         	Zeng_Stripchart('initial');
	      	Stripchart=get(gcf,'userdata');
   	      set(Stripchart.Figure,'visible','off');
      
      	   if ~sum(Format_Check-[3 67 79 76 85 77 78])==0
	            % Not MIT file
   	         FID=fopen([Log.Head.Path Log.Head.FileName],'r');
      	      %waiting bar-----------
         	   if 0
            	   h = waitbar(0,'Please wait...');
               	for i=(1:Log.Head.Chans)/Log.Head.Chans,
                  	% computation here %
	                  Data=[Data fread(FID,Log.Head.Samples,'int16')'];
   	               
      	            waitbar(i)
         	      end
            	   close(h)
	            end	  
               %----------------------
      	      Data{Stripchart.Figure}=zeros(Log.Head.Chans,Log.Head.Samples);
         	   if 1
            	   for i=1:Log.Head.Chans
               	   Data{Stripchart.Figure}(i,:)=fread(FID,Log.Head.Samples,'uint16')';
	               end	
   	         else
      	         Data{Stripchart.Figure}=fread(FID,[Log.Head.Chans,Log.Head.Samples],'uint16')';
         	   end
            	if Log.Head.RawDataVer==2; %
                  Data{Stripchart.Figure}=bitand(Data{Stripchart.Figure},hex2dec('0fff'));
               end
               if 0% length(Temp.Data)~=Log.Head.Chans*Log.Head.Samples  %[Log.Head.Samples Log.Head.Chans]
               	if Log.Head.Chans=='No infomation';
                  	Log.Head.Chans=length(Temp.Data)/Log.Head.Samples;
	                  Data=reshape(Temp.Data,Log.Head.Samples,Log.Head.Chans)';
   	            else
      	            Bad_Raw_File=1;
         	      end
            	   
	            elseif 0
   	            Data=reshape(Temp.Data,Log.Head.Samples,Log.Head.Chans)';
               end
               
               

         	else
	            % YES It is!!!
   	         FID=fopen([Log.Head.Path Log.Head.FileName],'r','b');
      	      % Get rid of the first 2 lines
         	   Head=fgetl(FID);
            	Head=[Head fgetl(FID)];
	            if 1
   	            Data{Stripchart.Figure}=zeros(Log.Head.Chans,Log.Head.Samples);
      	         if 1
         	         for i=1:Log.Head.Samples
            	         Data{Stripchart.Figure}(:,i)=fread(FID,Log.Head.Chans,'int16')';
               	   end	
	               else
   	               Data{Stripchart.Figure}=fread(FID,[Log.Head.Chans,Log.Head.Samples],'int16')';
         	      end
	            else
   	            for i=1:Log.Head.Chans
         	         Data{Stripchart.Figure}=zeros(Log.Head.Chans,Log.Head.Samples);
            	      for i=1:Log.Head.Samples
               	      Data{Stripchart.Figure}(:,i)=fread(FID,Log.Head.Chans,'int16')';
                  	end	
	               end
   	         end	
      	   end
         	fclose(FID);
            Temp=[];
            
   	      if ~Bad_Raw_File
      	      %Show the raw data in the stripchart windows.

					Stripchart.Head=Log.Head;
               Stripchart.ChLabel=ChLabel;
               
               %[Label MEM-Position]
               %Please make the Label be order
               Stripchart.Current_ch=Stripchart.ChLabel(1,1);
	            Stripchart.Time1=1;
   	         Stripchart.Time2=Log.Head.Samples;
      	      set(Stripchart.Axes,'xlim',[1 Stripchart.Head.Samples]);
         	   set(Stripchart.Edit.Channel,'string',Stripchart.Current_ch);
         	   if OpenStyle ==2
            	   axes(Stripchart.Axes);
               	delete(Stripchart.Patch.HD);
	               delete(findobj(gca,'type','line'))
   	            Current_Axis=axis;
      	         Stripchart.Patch.X=[];
         	      Stripchart.Patch.Y=[Current_Axis(3) Current_Axis(3) Current_Axis(4) Current_Axis(4)];
            	   Stripchart.Patch.HD=[];
               	Stripchart.Patch.HD_Old=[];
	               Stripchart.Move.status=0;
   	            if ~isempty(Stripchart.WaveForm.Figure);
      	            for num = 1: Stripchart.WaveForm.axises
         	            Stripchart.WaveForm.Ch.Current_ch(num)=num;
            	         set(Stripchart.WaveForm.Ch.Edit.Channel(num),'string',num)
               	      axes( Stripchart.WaveForm.Ch.Axes(num)),delete(get(Stripchart.WaveForm.Ch.Axes(num),'children')),plot(Data{Stripchart.Figure}(Stripchart.WaveForm.Ch.Current_ch(num),:))
	                  end
   	               set(Stripchart.WaveForm.Ch.Axes(1:num),'XLim',[1 Stripchart.Head.Samples])
      	         end
         	   end
            	%axes(Stripchart.Axes),plot(Data{Stripchart.Figure}(Stripchart.Current_ch,:)),set(Stripchart.Axes,'xlim',[Stripchart.Time1 Stripchart.Time2]);
	            set(Stripchart.Figure,'name',[Stripchart.Head.FileName ':Stripchart']);
   	         set(Stripchart.Figure,'userdata',Stripchart);
      	      Stripchart.ELTPoint=Stripchart.Head.Chans/Zeng_Stripchart('Data Type Check',Stripchart.Figure,1);

               set(Stripchart.Figure,'userdata',Stripchart);
            	Zeng_Stripchart('Data Type Plot',Stripchart.Figure,Stripchart.Plot(1),Stripchart.Current_ch,0,1,0)%6=gain, 7=offset   
            
            	if OpenStyle ==1 | OpenStyle ==2
               	%Up date the list in Log in windows    
	               Zeng_Share('Log')
      
      	         if isempty(Log.UD.HD.Log.Object);
         	         Log.UD.HD.Log.Object=Stripchart.Head; %Log.UD.HD.Log.Object.FileName=FileName;
            	   else;
               	   Log.UD.HD.Log.Object=[Log.UD.HD.Log.Object;Stripchart.Head];%Log.UD.Head.FileName=Temp;
	               end;
      	         Zeng_Log('Update List')
         	   end
            	set(Stripchart.Text.Range,'string',['File Length: ' num2str(round(Stripchart.Head.Samples*Zeng_Stripchart('Unit Convert',Stripchart.Figure))) ' ' Stripchart.Unit]);
	            Zeng_Stripchart('Unit Axis Setting',Stripchart.Figure)
   	         %               set(Stripchart.Axes,'xtickmode','manual')
      	      set(Stripchart.Figure,'visible','on');
         	   
	         else %if ~Bad_Raw_File
   	         Zeng_Error('Head file does not match with raw data');
      	   end
	      end%if ftell(FID)>5000000
      else 
         Zeng_Error('You have no raw data file for me');
      end %if raw data exits
	   set(Children_FG,'pointer','arrow');
   end % if ~isempty(findobj('name',[Log.UD.Head.FileName ':Stripchart']));
case 'Delete'
   %----------------------------------------------------------   
   global Log
   %Log=get(gcbf,'userdata');
   List=get(Log.ListBox,'string');
   Current_File=get(Log.ListBox,'value');
   Total_File=length(List);
   if Current_File>0 & ~isempty(Log.Object)
      switch action
      case 'All'
         Log.Object=[];
         set(Log.ListBox,'value',1);
         set(Log.ListBox,'string','');
      case 'All but selected'
         Log.Object=Log.Object(Current_File);
         set(Log.ListBox,'value',1);
         set(Log.ListBox,'string',List(Current_File));
      case 'Ten from selected'
         if Current_File+9<Total_File
            Log.Object(Current_File:Current_File+9)=[];
            List(Current_File:Current_File+9)=[];
            set(Log.ListBox,'value',Current_File-1);
            set(Log.ListBox,'string',List);
         else
            Log.Object(Current_File:Total_File)=[];
            set(Log.ListBox,'value',Current_File-1);
            set(Log.ListBox,'string',List([1:Current_File-1]));
         end
      case 'Selected'
         Log.Object(Current_File)=[];
         if Current_File==Total_File
            set(Log.ListBox,'value',Current_File-1);
            set(Log.ListBox,'string',List(1:Current_File-1));
         else
            List(Current_File:Total_File-1)=List(Current_File+1:Total_File);
            List(Total_File)=[];
            set(Log.ListBox,'string',List);
         end
      end
   else
      Zeng_Error('There is no data in the list');
   end	
   %To update  Log.Object
   %set(Log.Figure,'userdata',Log);
   
case 'DeleteFcn'
   set(0,'userdata',[]);
   Zeng_Share('DeleteFcn');
case 'ResizeFcn'
   global Log
   %Log=get(gcbf,'userdata');
   FG_Size=get(Log.UD.HD.Log.Figure,'position');  %Figure Size
   FG_Size(3)=max(FG_Size(3),Log.UD.HD.Log.FG_Limit(1));
   FG_Size(4)=max(FG_Size(4),Log.UD.HD.Log.FG_Limit(2));
   
   set(Log.ListBox,'Position',[5 37 (FG_Size(3)-10) (FG_Size(4)-70)]);
   set(Log.Button.Load,'Position',[FG_Size(3)/4-60/2 10 60 22]);
   set(Log.Button.Display,'Position',[FG_Size(3)*3/4-60/2 10 60 22]);
   %set(Log.Button.Delete,'Position',[FG_Size(3)*3/4-60/2 10 60 22]);
   set(Log.Text.File,'position',[10 (FG_Size(4)-30) 60 22])
   set(Log.Text.Comment,'position',[(FG_Size(3)*2/4) (FG_Size(4)-30) 60 22])
   %------------------------------------------------------------------------------------------------------   
case 'Load File'
   Zeng_Log('Read','FromLog');
   %------------------------------------------------------------------------------------------------------   
   %------------------------------------------------------------------------------------------------------   
case 'Open Directory'      
   global Log
 	Continue=0;
    
   if nargin==1; 
      Temp=Log.UD.Path;
      CDmark=find(Log.UD.Path==Log.UD.CD);
      if ~isempty(CDmark)
         [FileName Path]=uigetfile([Log.UD.Path(1:(max(CDmark))) '*.*']);
      else
         [FileName Path]=uigetfile('*.*');
      end
      
   	if max([FileName Path]) ~= 0;%if you do not click cancel
      	Continue=1;
	   end	
   else strcmp(varargin{2},'User');
      Path=varargin{3};
   	Continue=1;
   end
   
   if Continue
      Log.UD.DataCD=Path;
      Last=length(Log.UD.DataCD);
      if Log.UD.DataCD(Last)==Log.UD.CD;
			Log.UD.DataCD(Last)=[];
      end
      
      Temp.AllFiles=dir(Path);
      Temp.AllFileNames={};
      for i=1:length(Temp.AllFiles);
         Temp.AllFileNames=[Temp.AllFileNames;{Temp.AllFiles(i).name}];
      end
      Temp.AllFileNames=strvcat(Temp.AllFileNames);
      [Temp.row Temp.col]=size(Temp.AllFileNames);
      Temp.col=Temp.col+1;
      % add the tail to seperate each file name
      Temp.AllFileNames(:,Temp.col)=32;
      Temp.AllFileNames_OneLine=reshape(Temp.AllFileNames',[1 Temp.row*(Temp.col)]);
      index=findstr(Temp.AllFileNames_OneLine,['.h' char(32)]);
      index=ceil([index findstr(Temp.AllFileNames_OneLine,'.H ')]/Temp.col);
      Temp.AllFileNames=Temp.AllFileNames(index,:);
      [Temp.row,Temp.col]=size(Temp.AllFileNames);
      
      for i=1:Temp.row
         %FileName=AllFileNames(i,1:find(AllFileNames(i,:)=='.')-1);
         %Log=get(gcbf,'userdata');   
         Log.Temp.FileName=Temp.AllFileNames(i,:);
         Log.Temp.Path=Path;
         %set(Log.Figure,'userdata',Log);
         Zeng_Log('Read','Open Directory');
      end % for i=1:length(AllFileNames)  	
   end
%------------------------------------------------------------------------------------------------------   
case 'Load User'
	if nargin==1 %from menu
	  [FileName Path]=uigetfile('*.usr');
	else
	  FileName=varargin{2};
        Path=varargin{3};
		
	end


  if max([FileName Path]) ~= 0%if you do not click cancel
     FID=fopen([Path FileName],'r');
     if FID>0
        Line=fgetl(FID);
	     Black_Slash=find(Line=='/');
        Line(Black_Slash)='\';
   	  Zeng_Log('Open Directory','User',Line);
   
     else
        Zeng_Error('You don''t have such a file');
     end
  end
   
   
%------------------------------------------------------------------------------------------------------   
case 'Save User'
	[FILENAME, PATHNAME] = uiputfile('ILoveYou.usr', 'Work hard, not hardly');    
   if ~strcmp('0',num2str(FILENAME)) & ~strcmp('0',num2str(PATHNAME))
   	YMDHMS=clock;
     	dlmwrite([PATHNAME FILENAME],'');
      FID=fopen([PATHNAME FILENAME],'w');
      DefaultDir=cd;
    	Black_Slash=find(DefaultDir=='\');
      DefaultDir(Black_Slash)='/';
      fprintf(FID,[DefaultDir '/' '\n']);
      fprintf(FID,['\n']);%You need it to show.. Trust me on that
      Status=fclose(FID);
   end
   
%------------------------------------------------------------------------------------------------------   
case 'Open List'      
  global Log
   %Log=get(gcbf,'userdata');   
  [FileName Path]=uigetfile('*.lst');
  if max([FileName Path]) ~= 0%if you do not click cancel
     FID=fopen([Path FileName],'r');
     if FID>0
        Line=0;
        %To get rid of the titile
        while isempty(find(Line==9)) %9= '\t' :Tab sysbol
           Line=fgetl(FID);
        end
        %To open all head file
        while feof(FID)==0
 	         Black_Slash=find(Line=='/');
            Line(Black_Slash)='\';
            Tab=find(Line==char(9));%Char(9) = space between tile and value
            Log.Temp.FileName=Line(1:(Tab(1)-1));
				Log.Temp.Path=Line((Tab(1)+1):(Tab(2)-1));
            %set(gcbf,'userdata',Log);
            Zeng_Log('Read','Open List');
            %   Zeng_Share('Log');
            %----------------------------------------------------
			  Line=fgets(FID);
        end
        fclose(FID);
        Log.Temp=[];
     else
        Zeng_Error('You don''t have such a file');
     end
  end
  
     
        
  %------------------------------------------------------------------------------------------------------   
case 'Save Lise'      
   global Log

   %   Log=get(gcbf,'userdata'); 
   if isempty(Log.Object)
      Zeng_Error('I don''t let you save blank')
   else %isempty(Log.Object.FileName)
      [FILENAME, PATHNAME] = uiputfile('ILoveYou.lst', 'Work hard, not hardly');    
      if ~strcmp('0',num2str(FILENAME)) & ~strcmp('0',num2str(PATHNAME))
         YMDHMS=clock;
         dlmwrite([PATHNAME FILENAME],'');
         FID=fopen([PATHNAME FILENAME],'w');
         fprintf(FID,'====================================\n');
         fprintf(FID,'CWRU Cardio Mapping System List file\n');
         fprintf(FID,'====================================\n');
         fprintf(FID,['Date(Y/M/D):' num2str(YMDHMS(1)) '/' num2str(YMDHMS(2)) '/' num2str(YMDHMS(3)) '\n']);
         fprintf(FID,['Time(H/M/S):' num2str(YMDHMS(4)) ':' num2str(YMDHMS(5)) ':' num2str(YMDHMS(6)) '\n']);
         fprintf(FID,['---------------\n']);
         fprintf(FID,['FileName   Path\n']);
         fprintf(FID,['---------------\n']);
         for i=1:length(Log.Object)
            %I have to trick the computer because it doesn't allow to save the '\'
            FILENAME=Log.Object(i).FileName;
            PATHNAME=Log.Object(i).Path;
            Black_Slash=find(FILENAME=='\');
            FILENAME(Black_Slash)='/';
            Black_Slash=find(PATHNAME=='\');
            PATHNAME(Black_Slash)='/';
            fprintf(FID,[FILENAME '\t' PATHNAME '\t\n']);
         end
         fprintf(FID,['\n']);%You need it to show.. Trust me on that
         Status=fclose(FID);
      end
   end %isempty(Log.Object.FileName)
case 'Update List'
   global Log
   %Log=get(gcbf,'userdata');
   After_Load=length(Log.Object);
   List=get(Log.ListBox,'string');
   %Current_File=get(Log.ListBox,'value');
   Total_File=length(List);
   if Total_File==0;
      set(Log.ListBox,'value',1);
   end
   
   if 0
      a=sprintf('--\t--');
      List(Total_File+1)={[Log.Object(After_Load).FileName  a '|' a  Log.Object(After_Load).Comment]};
            set(Log.ListBox,'string',List);
         elseif 1      
            %Space=blanks(8-length(Log.Object(After_Load).FileName));
            Space=char([32* ones(1,2*(10-length(Log.Object(After_Load).FileName)))]);
   
   %   	   List(Total_File+1)={[Log.Object(After_Load).FileName '|' blanks(5) Log.Object(After_Load).Comment]};
   List(Total_File+1)={[Log.Object(After_Load).FileName Space '|' blanks(5) Log.Object(After_Load).Comment]};
         set(Log.ListBox,'string',List);
      end
      %------------------------------------------------------------------------------------------------------   
case 'Display'
   global Log

   %Log=get(gcbf,'userdata');
   Log.Current_File=get(Log.ListBox,'value');
   if Log.Current_File>0 & ~isempty(Log.Object)
      %set(Log.Figure,'userdata',Log);
      Zeng_Log('Read','FromDisplay');
   else
      Zeng_Error('There is no data in the list');
   end
         
  %=====================================================================================
case 'Create head file'
   FID=fopen([Log.UD.Temp.Head.Path Log.UD.Temp.Head.FileName]);         % filename Temp from Read
   Head=fread(FID,40,'int8'); % read the head portion in the raw data file.
   Title_End=find(Head==10)'; % check if there are 2 head line.   
   if length(Title_End)==2
      %Assume it is the optical mapping system.
      %COLUMN BINARY FILE2t144c0c0e
      fclose(FID);
      FID=fopen([Log.UD.Temp.Head.Path Log.UD.Temp.Head.FileName],'r','b');
      Head=fgetl(FID);
      Head=[Head fgetl(FID)];
         
      E=find(Head=='E');
      t=find(Head=='t');
      c=find(Head=='c');
            
      Log.UD.Temp.Data=fread(FID,inf,'int16')';
      fclose(FID);

      Samples =length(Log.UD.Temp.Data)/str2num(Head(t+1:c(1)-1)); 
      if fix(Samples)~=ceil(Samples)
         break
      else
         %Log.UD.HD.Stripchart.Current_ch=0;
         Log.UD.Temp.Head.Subject =' ';
         Log.UD.Temp.Head.Date    =' ';
         Log.UD.Temp.Head.Gain    =' ';
         Log.UD.Temp.Head.SRate   =' ';
         Log.UD.Temp.Head.Samples =Samples; 
         Log.UD.Temp.Head.Chans   =str2num(Head(t+1:c(1)-1));
         Log.UD.Temp.Head.LUT     =' ';
         Log.UD.Temp.Head.Sys_Ver ='CWRU optical system';
         Log.UD.Temp.Head.Comment=[num2str(length(Log.UD.Data)) ' = data size = Samples x Channels'];
      end
   else % It is not MIT head file
      FID=fopen([Log.UD.Temp.Head.Path Log.UD.Temp.Head.FileName]);         % filename Temp from Read
      Log.UD.Temp.Data=fread(FID,inf,'int16');
      fclose(FID);
      %Log.UD.HD.Stripchart.Current_ch=0;
      
      Log.UD.Temp.Head.Subject =' ';
      Log.UD.Temp.Head.Date    =' ';
      Log.UD.Temp.Head.Gain    =' ';
      Log.UD.Temp.Head.SRate   =' ';
      Log.UD.Temp.Head.Samples =' ';
      Log.UD.Temp.Head.Chans   =' ';
      Log.UD.Temp.Head.LUT     =' ';
      Log.UD.Temp.Head.Sys_Ver =' ';
      Log.UD.Temp.Head.Comment=[num2str(length(Log.UD.Temp.Data)) ' = data size = Samples x Channels'];
   
   end % No automatic guess
   %=====================================================================================
   %====================================================================

   
end %   switch action

