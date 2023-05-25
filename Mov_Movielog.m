function Mov_Movielog(varargin)
global UD
global Movielog
global Log
global Data
global Movs
global axishd
global Stripchart
global LUTDisplay
global Norm
global Filters

action = varargin{1};
switch action
%---------------------------------------------------   

case 'Initial'
   Movielog.GorL=1;	
   Movielog.ContentsG=num2str([]);
   Movielog.ContentsL=num2str([]);
   Movielog.pointer.Global=2;
   Movielog.pointer.Local=1;
   Movielog.Figure=figure;
   Movielog.Load=1;
   Movielog.ApplyL=0;
   Movielog.ApplyG=0;
   UD.Ref.FontSize=8;
   FG_Size(3:4)=[275 400];
  	FG_Size(1:2)=[Log.UD.ScreenSize(1)-FG_Size(3)*1.4 Log.UD.ScreenSize(2)-FG_Size(4)*1.1-25 ];

   %FG_Size=[590 339 275 400];   
   set(Movielog.Figure,...
         'Color',[0.8 0.8 0.8], ...
       	'DeleteFcn','Mov_Movie(''Delete'')',...
         'menu','none',...
         'Name','Image Process Log',...
         'NumberTitle','off',...
         'Position',FG_Size, ...
         'Tag','Movielog');
      
   Movielog.ListBoxSz=[5 200 190 180];
   Movielog.ListBoxG = uicontrol('Parent',Movielog.Figure, ...
         'Units','pixels',...
         'BackgroundColor',[1 1 1], ...
		 'callback','Mov_Movielog(''GBox'')',...
         'FontName','times',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',Movielog.ListBoxSz, ...
         'Style','listbox', ...
         'value',0,...
         'Tag','Listbox1');
	Movielog.ListBoxL = uicontrol('Parent',Movielog.Figure, ...
         'Units','pixels',...
         'BackgroundColor',[1 1 1], ...
		 'callback','Mov_Movielog(''LBox'')',...
         'FontName','times',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[5 3 190 180], ...
		 'String',' ',...
         'Style','listbox', ...
         'value',1,...
         'Tag','Listbox2');
   Movielog.Button.Save = uicontrol('Parent',Movielog.Figure, ...
         'Units','pixels',...
         'FontName','times',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[210 350 60 22], ...
         'String','Save', ...
         'callback','Mov_Movielog(''Save'')',...  
         'Tag','Pushbutton1');
   Movielog.Button.Load = uicontrol('Parent',Movielog.Figure, ...
         'Units','pixels',...
         'FontName','times',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[210 315 60 22], ...
         'String','Load', ...
         'callback','Mov_Movielog(''Loading'')',...  
         'Tag','Pushbutton1');
   Movielog.Button.ApplyA = uicontrol('Parent',Movielog.Figure, ...
         'Units','pixels',...
		   'Enable','off',...
         'FontName','times',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[210 280 60 22], ...
         'String','Apply', ...
         'callback','Mov_Movielog(''Apply'')',...  
         'Tag','Pushbutton1');
		 
   Movielog.Button.Clear=	uicontrol('Parent',Movielog.Figure, ...
         'Units','pixels',...
         'FontName','times',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[210 165 65 25],...
         'String','Clear', ...
         'callback','Mov_Movielog(''ClearA'')',...  
         'Tag','Pushbutton1'); 

   Movielog.Button.Undol=	uicontrol('Parent',Movielog.Figure, ...
         'Units','pixels',...
         'FontName','times',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[210 205 65 25],...
         'String','Undo', ...
         'callback','Mov_Movie(''Undo'')',...  
         'Tag','Pushbutton1'); 
		
%  TEXT
		Movielog.text1 =uicontrol('Parent',Movielog.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[5 380 120 15], ...
            'String','Global Processing ', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
		Movielog.text1 =uicontrol('Parent',Movielog.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[5 185 120 15], ...
            'String','Local Processing ', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');	
			
%======================================
%  CHECK BOXES
%=====================================
   Movielog.Button.Global= uicontrol('Parent',Movielog.Figure,...
            'Callback','Mov_movielog(''Global'')',...
            'units','pixels',...
            'Style','checkbox', ...
            'Tag','Channels',...
				'value',1,...
            'Position',[115,385,14,14] );
   Movielog.Button.Local= uicontrol('Parent',Movielog.Figure,...
            'Callback','Mov_movielog(''Local'')',...
            'units','pixels',...
            'Style','checkbox', ...
            'Tag','Channels',...
			'value',0,...
            'Position',[115,186,14,14] );
   %=====================================================================================
   %=====================================================================================
   
case 'Colormaps'
   set(Movielog.ListBoxG,'value',1);
    Movielog.ContentsG(1,1:30)=varargin{2};
    set(Movielog.ListBoxG,'string',num2str(Movielog.ContentsG));

case 'Add'
   Movs.Last=1;
   set(Movielog.Button.Global,'value',1);
   set(Movielog.Button.Local,'Value',0);
   set(Movielog.ListBoxG,'value',1);
   Movielog.ContentsG(Movielog.pointer.Global,1:length(varargin{2}))=varargin{2};
   set(Movielog.ListBoxG,'String',Movielog.ContentsG);
   Movielog.pointer.Global=Movielog.pointer.Global+1;
   Movs.Interp=0;
   Movielog.Load=0;
   Movielog.GorL=1;
   set(Movielog.ListBoxG,'value',Movielog.pointer.Global-1);
   
case 'Add Local'
   Movs.Last=1;
   set(Movielog.ListBoxL,'value',1);
   set(Movielog.Button.Global,'value',0);
   set(Movielog.Button.Local,'Value',1);
   Movielog.ContentsL(Movielog.pointer.Local,1:length(varargin{2}))=varargin{2};
   set(Movielog.ListBoxL,'string',Movielog.ContentsL);
   Movielog.pointer.Local=Movielog.pointer.Local+1;
   Movs.Interp=0;  
   Movielog.Load=0;
   Movielog.GorL=2;
   set(Movielog.ListBoxL,'value',Movielog.pointer.Local-1);
   Mov_Movielog 'Global'
   
   
case 'Close'
%   Movielog.ContentsG=[];
%   Movielog.ContentsL=[];
   set(Movielog.ListBoxG,'string',Movielog.ContentsG);
   set(Movielog.ListBoxL,'string',Movielog.ContentsL);
   Movielog.pointer.Global=2;
   Movielog.pointer.Local=1;
   
   
case 'ClearA'
set(Movielog.Button.ApplyA,'Enable','on');
check=get(Movielog.Button.Global,'value');
check2=get(Movielog.Button.Local,'value');
   Movielog.ContentsG=[];
   Movielog.ContentsL=[];
   set(Movielog.ListBoxG,'string',Movielog.ContentsG);
   set(Movielog.ListBoxL,'string',Movielog.ContentsL);
   Movielog.pointer.Global=2;
   Movielog.pointer.Local=1;
   Mov_Movielog 'Global'
   set(Movielog.Button.ApplyA,'Enable','off');
	Mov_Movie 'ClrMaps'  
%   temp=num2str(Movielog.pointer.Global);
%   Movielog.Contents=strvcat(temp,Movielog.ContentsG,Movielog.ContentsL);
   Movielog.Contents=strvcat(Movielog.ContentsG,Movielog.ContentsL);
   Mov_Movie 'Undo All' 
  
case 'Save'
   [newiplfile Log.Temp.Path]=uiputfile('*.IPL', 'Save IPL File As');
   if newiplfile~=0
   datafile2=[Log.Temp.Path newiplfile '.ipl'];  
   fid = fopen(datafile2,'w');
   temp=num2str(Movielog.pointer.Global);
   Movielog.Contents=strvcat(temp,Movielog.ContentsG,Movielog.ContentsL);
       fwrite(fid,Movielog.Contents','char');   
       fclose(fid);
   end
   

case 'Loading'
	set(Movielog.Button.ApplyA,'Enable','on');
  	Movielog.ApplyL=0;
	Movielog.ApplyG=0;
	Movielog.Load=1;
	Mov_Movielog 'Load'
	set(Movielog.Button.Global,'value',1)
	set(Movielog.Button.Local,'value',0)
%	Mov_Movielog 'Apply'
	
       
case 'Load'
	set(Movielog.Button.ApplyA,'Enable','on');
   Movs.Interp=0;
   Movs.Last=0;
   %fid=fopen([matlabroot,'\bin\','origdata'],'r'); 
   %z=Mov_Movie('Wait');
   %Movs.newarray=fread(fid); 
   %Movs.newarray=reshape(Movs.newarray,length(Movs.newarray)/Movs.xydim(1)^2,Movs.xydim(1)^2);
   %fclose(fid);
   clear originaldata;
   Mov_Movie 'Undo All'
  
  if Movielog.Load==1;
      [filename Log.Temp.Path]=uigetfile('*.IPL', 'Load IPL File:');
      datafile2=[Log.Temp.Path filename];
  else
	  datafile2=['drkfile.bak'];
  end
  Movielog.Load=1;
  fid = fopen(datafile2);
  if filename~=0
  F=fread(fid,[30,inf],'char');
  Movielog.Contents= char(F');
  fclose(fid);
  [row,col]=size(Movielog.Contents);
   if Movielog.Contents(1,2)~=' '
	   Gvar=str2num(Movielog.Contents(1,1:2));
	   countstart=3;
   else
	   Gvar=str2num(Movielog.Contents(1,1));
	   countstart=2;
   end
   Movielog.ContentsG=Movielog.Contents(countstart:Gvar,:);
   Movielog.ContentsL=Movielog.Contents(Gvar+1:row,:);
   set(Movielog.ListBoxG,'string',Movielog.ContentsG);
   set(Movielog.ListBoxL,'string',Movielog.ContentsL);
   else
	  	Mov('Error','Inappropriate File Selection');
end
	   
	   
	   
	   
  %$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     
  %   THE LOADING/APPLYING PART OF THE WHOLE THING     
  %   The Colormap   
case 'Apply'
Gvar=str2num(Movielog.Contents(1,1:2));
Movielog.pointer.Local=1;
Movielog.pointer.Global=2;
check=get(Movielog.Button.Global,'value');
check2=get(Movielog.Button.Local,'value');
%if check==1 & check2==1
if 1==1 
   [row,col]=size(Movielog.Contents);
	if Movielog.ApplyG==0 & Movielog.ApplyL==0
		start=3;
		ending=row;
		Movielog.ApplyG=1;
		Movielog.ApplyL=1;
	elseif Movielog.ApplyG==1 & Movielog.ApplyL==0
	   start=Gvar+1;
	   ending=start+row-1;
	   Movielog.ApplyL=1;
	else
		start=2;
		ending=2;
	end
elseif check==1 & check2~=1
   [row,col]=size(Movielog.ContentsG);
	if Movielog.ApplyG==0
	   start=3;
   	   ending=row+1;
   	   Movielog.ApplyG=1;
   else
	   start=2;
	   ending=2;
   end
elseif check~=1 & check2==1
   [row,col]=size(Movielog.ContentsL);
   [row2,col2]=size(Movielog.ContentsG);
   if Movielog.ApplyL==0
	   start=Gvar+1;
	   ending=start+row-1;
	   Movielog.ApplyL=1;
   else
      start=row2
	   ending=row+row2;
   end
end

%********************************
%    COLORMAPS
%********************************
   Clrmap=Movielog.Contents(2);
   load ctable
   switch Clrmap 
   case 'G',   
      figure(Movs.Display.Figure)
      colormap(gray)
      set(Movs.text.Colormaps,'Value',1);
   case 'B',
       figure(Movs.Display.Figure)
     if Movielog.Contents(1,7)=='R'
         colormap(BlackRed)
         set(Movs.text.Colormaps,'Value',2);
      end
      if Movielog.Contents(1,7)=='B'
         colormap(BlackBlue)
         set(Movs.text.Colormaps,'Value',3);
      end
      if Movielog.Contents(1,7)=='l'
         colormap(BlackRed)
         set(Movs.text.Colormaps,'Value',5);
      end
   case 'J',
      figure(Movs.Display.Figure)
      colormap(jet)
      set(Movs.text.Colormaps,'Value',4);
   end   
   
   %  Everything Else
   clear Movs.Badpic
   [row,col]=size(Movielog.ContentsL);
   [row2,col2]=size(Movielog.ContentsG);
for count=start:ending
   Todo=Movielog.Contents(count,1);
      if count>row2+1
         set(Movs.Button.Local,'Value',1)
         set(Movs.Button.Global,'Value',0)
      end
      switch Todo
      case 'I'
		 if Movielog.Contents(count,3)=='v'
			  Mov_Movie 'Invert'
	%....................................................
	%	INTERPOLATION
		 else	
         	Movs.Badpic=str2num(Movielog.Contents(count,20:25));
		 end
      Mov_Movie 'Interpolate'

	  case 'T'
		   if isempty(str2num(Movielog.Contents(count,21:26)))  
          		Mov_Movie 'Derivs'
	  		else
		  		Temp.currentpoint=str2num(Movielog.Contents(count,21:26));
				if Movs.Signal.True==1
					Temp.pastpoint=Movs.Current_ch;
				end
				Movs.Current_ch=Temp.currentpoint(1)+Movs.xydim(2)*(Temp.currentpoint(2)-1);
				Mov_Movielog 'Local'
				Mov_Movie 'Derivs'
				if Movs.Signal.True==1
					Mov_Movie 'Signal'
					Movs.Current_ch=Temp.pastpoint;
				end
				
			end
			
	  case 'D' 
		   if isempty(str2num(Movielog.Contents(count,23:27)))  
       			  Mov_Movie 'Add Deriv'
	  		else
		  		Movs.Badpic=str2num(Movielog.Contents(count,23:27));
				Mov_Movielog 'Local'
				Mov_Movie 'Add Deriv'
			end
         
     case 'S'
        Filterlength=char(Movielog.Contents(count,11:13));
         Filterlength=double(Filterlength);
       if Filterlength(2)==32
			 Movs.Filter=Filterlength(1)-48;
       else
			 Movs.Filter=(Filterlength(1)-48)*10+Filterlength(2)-48;
       end
          set(Movs.Edit.Smooth,'String',num2str(Movs.Filter))
		   Movs.Badpic=str2num(Movielog.Contents(count,20:25));
		   if ~isempty(Movs.Badpic)
		      Movs.Current_ch=Movs.Badpic(1)+Movs.xydim(2)*(Movs.Badpic(2)-1);
		   end
		    Mov_Movie 'Smooth'
     case 'B'
         Mov_Movie 'Threshold'
%!!!!!!!!!!!!!!!!!!!!!!!!!
%   FILTER APPLICATION
%_________________________
	  case 'F'
	     filtspecs=char(Movielog.Contents(count,6:30));
		 if filtspecs(1)=='c'
			 if filtspecs(2)=='1'
			     Filters.name='c1';
			 else
				 Filters.name='c2';
			 end
		 else
			 Filters.name=filtspecs(1);
		 end
	     type=filtspecs(4);
		 switch type
		 case 'l'
			 Filters.Type='low ';
		 case 'h'
			 Filters.Type='high';
		 case 'p'
			 Filters.Type='pass';
		 case 's'
			 Filters.Type='stop';
		 end
		fspecs=str2num(filtspecs(9:length(filtspecs)));
	 	 Filters.Order=fspecs(1);
		 Filters.LowCuttoff=fspecs(2);
	 	 Filters.HighCuttoff=fspecs(3);	
		 Filters.PassRipple=fspecs(4);
		 Filters.StopRipple=fspecs(5);
	if ~isempty(filtspecs(6:7))
    	 Mov_Filters 'Loaded'
	else
		 Movs.Current_ch=Temp.currentpoint(1)+Movs.xydim(2)*(Temp.currentpoint(2)-1); % WRONG
		 Mov_Movielog 'Local'
		 Mov_Filters 'Loaded'
	 end
 
 	case 'N'
	   normspecs=char(Movielog.Contents(count,11:30));
		normparams=str2num(Movielog.Contents(count,17:30));
		Norm.Func1=normspecs(1:2);
		Norm.Func2=normspecs(4:5);
	 	Norm.mb=normparams(1);
		Norm.mm=normparams(2);
		 if Norm.Func1=='ab' | Norm.Func2=='am'
			 if normparams(3)==0
				Mov_Movielog 'Global'
			else
				Mov_Movielog 'Local'
				Movs.Badpic=normparams(4:5);
		 Movs.Current_ch=Movs.Badpic(1)+Movs.xydim(2)*(Movs.Badpic(2)-1); 
			end
			Mov_Normalize 'Loaded'
		elseif Norm.Func1=='mb' | Norm.Func2=='mm'
			if normparams(3)==0
				 Mov_Movielog 'Global'
			 else
				Mov_Movielog 'Local'
				Temp.currentpoint=normparams(4:5);
		      Movs.Current_ch=Movs.Badpic(1)+Movs.xydim(2)*(Movs.Badpic(2)-1); 
			end
  		   Mov_Normalize 'Loaded'
	 	end

		
 
	 
	end % Swicthes
end	 %For Loop
 


 
case 'Undo Last'
if get(Movielog.Button.Global,'value')==1;
   if Movielog.pointer.Global>1
      Movielog.ContentsG=Movielog.Contents;
      Movs.Last=0;
  end
else get(Movielog.Button.Local,'value')==1;
	  Movielog.ContentsL=Movielog.Contents;
      Movs.Last=0;
end	
      
       
case 'Undo'
   Movielog.Button.Global
if get(Movielog.Button.Global,'value')==1
   if Movielog.pointer.Global>1
      Movielog.pointer.Global=Movielog.pointer.Global-1;
      Movielog.ContentsG(Movielog.pointer.Global)=NaN*ones(1,length(Movielog.ContentsG(Movielog.pointer.Global)));
      set(Movielog.ListBoxG,'string',Movielog.ContentsG);
      Movs.Last=0;
  end
else get(Movielog.Button.Local,'value')==1
	disp('Hey I is here')
      Movielog.pointer.Local=Movielog.pointer.Local-1;
      Movielog.ContentsL(Movielog.pointer.Local)=NaN*ones(1,length(Movielog.ContentsL(Movielog.pointer.Local)));
      set(Movielog.ListBoxL,'string',Movielog.ContentsL);
      Movs.Last=0;
end	

case 'GBox'
	Movielog.GorL=1;
	set(Movielog.Button.Global,'value',1);
	set(Movielog.Button.Local,'value',0);

case 'LBox'
	Movielog.GorL=2;
	set(Movielog.Button.Global,'value',0);
	set(Movielog.Button.Local,'value',1);
	
case 'Global'
	Movielog.GorL=1;
	set(Movs.Button.Local,'value',0);
	set(Movs.Button.Global,'value',1);
	
case 'Local'
	Movielog.GorL=2;
	set(Movs.Button.Global,'value',0);
	set(Movs.Button.Local,'value',1);

   end %   switch action

