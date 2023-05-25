function Mov_Normalize(varargin)
global UD
global Movielog
global Log
global Data
global Movs
global axishd
global Stripchart
global LUTDisplay
global Norm

action = varargin{1};
switch action
%---------------------------------------------------   

case 'Initial'
Norm.Old=Movs.newarray;
Norm.PercB=0;
Norm.PercM=100;
Norm.Apply=0;
Norm.old=Movs.newarray;
Movs.Mag=1;
	set(Movs.Button.Thresh,'Enable','off')

   Norm.Figure=figure;
   FG_Size=[100 100 405 130];   
   set(Norm.Figure,...
         'Color',[0.8 0.8 0.8], ...
       	 'DeleteFcn','',...
         'menu','none',...
         'Name','Digital Thresholding',...
         'NumberTitle','off',...
         'Position',FG_Size, ...
         'Tag','Movielog');

%@@@@@@@@@@@@@@@@@@@@@@@@@@@
%     TEXT
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@
 Norm.text1 =uicontrol('Parent',Norm.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','Geneva',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[5 70 200 15], ...
            'String','BASELINE THRESHOLDING', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');

 Norm.Text.Order =uicontrol('Parent',Norm.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','Geneva',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[5 110 200 15], ...
            'String','PEAK THRESHOLDING ', ...
            'Style','text', ...
            'Tag','StaticText2',...
			'visible','on');			

			
%--------------------
% APPLYING BUTTONS
%---------------------
   Norm.Button.AutoB = uicontrol('Parent',Norm.Figure, ...
         'Units','pixels',...
		 'callback','Mov_Normalize(''AutoB'')',...
         'FontName','Geneva',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[10 48 60 22], ...
         'String','Automatic', ...
		 'Style','togglebutton',...
         'Tag','Pushbutton1',...
		 'value',1);
			
   Norm.Button.AutoM = uicontrol('Parent',Norm.Figure, ...
         'Units','pixels',...
		 'callback','Mov_Normalize(''AutoM'')',...
         'FontName','Geneva',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[10 88 60 22], ...
         'String','Automatic', ...
		 'Style','togglebutton',...
         'Tag','Pushbutton1',...
		 'value',0);
   Norm.Button.ManualM = uicontrol('Parent',Norm.Figure, ...
         'Units','pixels',...
         'FontName','Geneva',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[100 88 60 22], ...
         'String','Manual', ...
		 'Style','togglebutton',...
         'callback','Mov_Normalize(''ManM'')',...  
         'Tag','Pushbutton1');
   Norm.Button.ManualB = uicontrol('Parent',Norm.Figure, ...
         'Units','pixels',...
         'FontName','Geneva',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[100 48 60 22], ...
         'String','Manual', ...
		 'Style','togglebutton',...
         'callback','Mov_Normalize(''ManB'')',...  
         'Tag','Pushbutton1');
 %######################
 % ALL EDIT BOXES
 %######################
 Norm.Box.PercM = uicontrol('Parent',Norm.Figure, ...
        'Units','pixels',...
   	    'BackgroundColor',[1 1 1], ...
		'Enable','off',...
        'FontName','Geneva',...
        'FontUnits','points',...
        'FontSize',UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',[200 88 30 22], ...
        'String',Norm.PercM, ...
   	    'Style','edit', ...
	    'Tag','EditOrder');
 Norm.Box.PercB = uicontrol('Parent',Norm.Figure, ...
        'Units','pixels',...
		'callback','Mov_Normalize(''IntCheck'')',...
   	    'BackgroundColor',[1 1 1], ...
		'Enable','off',...
        'FontName','Geneva',...
        'FontUnits','points',...
        'FontSize',UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',[200 48 30 22], ...
        'String',Norm.PercB, ...
   	    'Style','edit', ...
	    'Tag','EditOrder');
	

%--------------------
%  TEXT
%--------------------
 Norm.Text.PercB =uicontrol('Parent',Norm.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
			'Enable','off',...
            'FontName','Geneva',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[235 48 50 25], ...
            'String','% of Signal ', ...
            'Style','text', ...
            'Tag','StaticText2',...
			'visible','on');	
 Norm.Text.PercM =uicontrol('Parent',Norm.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
			'Enable','off',...
            'FontName','Geneva',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[235 88 50 25], ...
            'String','% of Signal ', ...
            'Style','text', ...
            'Tag','StaticText2',...		
            'visible','on');	
		%--------------------
		% APPLY BUTTON
		%--------------------
   Norm.Button.Apply = uicontrol('Parent',Norm.Figure, ...
         'Units','pixels',...
         'FontName','Geneva',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[150 1 60 22], ...
         'String','APPLY', ...
         'callback','Mov_Normalize(''Apply1'')',...  
         'Tag','Pushbutton1');
   Norm.Button.Preview = uicontrol('Parent',Norm.Figure, ...
         'Units','pixels',...
         'FontName','Geneva',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[50 1 60 22], ...
         'String','Preview', ...
         'callback','Mov_Normalize(''Preview'')',...  
         'Tag','Pushbutton1');
	Norm.Button.Cancel = uicontrol('Parent',Norm.Figure, ...
         'Units','pixels',...
         'FontName','Geneva',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[250 1 60 22], ...
         'String','Cancel', ...
         'callback','Mov_Normalize(''Cancel'')',...  
         'Tag','Pushbutton1');


   %=====================================================================================			
   %=====================================================================================
   %=====================================================================================
case 'Apply'
		 Norm.Func1='__';
		 Norm.Func2='__';
% GLOBAL APPLY		GLOBAL APPLY		GLOBAL APPLY		GLOBAL APPLY
if get(Movs.Button.Global,'value')==1
   if get(Norm.Button.AutoB,'value')==1
	for c=1:Movs.xydim(1)*Movs.xydim(2)
		 x=sort(Movs.newarray(:,c));
		Temp.Val=x(round(length(x)/3*1.8+5));
    	Movs.newarray(:,c)=wthresh(Movs.newarray(:,c),'s',Temp.Val)+Temp.Val;
	end  
	Norm.Func1='ab';
end
if get(Norm.Button.AutoM,'value')==1;
	for c=1:Movs.xydim(1)*Movs.xydim(2)
		 x=sort(Movs.newarray(:,c));
		Temp.Val=x(length(x)/4*3+5)*-1+63;
		Movs.newarray(:,c)=Movs.newarray(:,c)*-1+63;
    	Movs.newarray(:,c)=(wthresh(Movs.newarray(:,c),'s',Temp.Val)+Temp.Val)*-1+63;
	end  
	Norm.Func2='am';
end

if get(Norm.Button.ManualB,'value')==1
	for c=1:Movs.xydim(1)*Movs.xydim(2)
		Temp.Val=round(str2num(get(Norm.Box.PercB,'string'))*.63);
	    Movs.newarray(:,c)=wthresh(Movs.newarray(:,c),'s',Temp.Val)+Temp.Val;
	end
	Norm.Func1='mb';
end
if get(Norm.Button.ManualM,'value')==1;
	for c=1:Movs.xydim(1)*Movs.xydim(2)
		Temp.Val=round(str2num(get(Norm.Box.PercM,'string'))*-.64+63);
		Movs.newarray(:,c)=Movs.newarray(:,c)*-1+63;
    	Movs.newarray(:,c)=(wthresh(Movs.newarray(:,c),'s',Temp.Val)+Temp.Val)*-1+63;
	end  
	Norm.Func2='mm';
end
	for c=1:Movs.xydim(1)*Movs.xydim(2)
  	    Movs.newarray(:,c)=63*(Movs.newarray(:,c)-ones(length(Movs.newarray(:,c)),1)*min(Movs.newarray(:,c)))./(max(Movs.newarray(:,c))-min(Movs.newarray(:,c)));
	end
%	LOCAL APPLY			LOCAL APPLY			LOCAL APPLY			LOCAL APPLY			LOCAL APPLY
elseif get(Movs.Button.Local,'value')==1
	c=Movs.Current_ch;
if get(Norm.Button.AutoB,'value')==1
		 x=sort(Movs.newarray(:,c));
		Temp.Val=x(length(x)/3+5);
    	Movs.newarray(:,c)=wthresh(Movs.newarray(:,c),'s',Temp.Val)+Temp.Val;
	Norm.Func1='ab';
end
if get(Norm.Button.AutoM,'value')==1;
		 x=sort(Movs.newarray(:,c));
		Temp.Val=x(length(x)/4*3+5)*-1+63;
		Movs.newarray(:,c)=Movs.newarray(:,c)*-1+63;
    	Movs.newarray(:,c)=(wthresh(Movs.newarray(:,c),'s',Temp.Val)+Temp.Val)*-1+63;
	Norm.Func2='am';
end

if get(Norm.Button.ManualB,'value')==1
		Temp.Val=round(str2num(get(Norm.Box.PercB,'string'))*.64);
	    Movs.newarray(:,c)=wthresh(Movs.newarray(:,c),'s',Temp.Val)+Temp.Val;
	Norm.Func1='mb';
end
if get(Norm.Button.ManualM,'value')==1;
		Temp.Val=round(str2num(get(Norm.Box.PercM,'string'))*-.64+63);
		Movs.newarray(:,c)=Movs.newarray(:,c)*-1+63;
    	Movs.newarray(:,c)=(wthresh(Movs.newarray(:,c),'s',Temp.Val)+Temp.Val)*-1+63;
	 Norm.Func2='mm';
end
  	    Movs.newarray(:,c)=63*(Movs.newarray(:,c)-ones(length(Movs.newarray(:,c)),1)*min(Movs.newarray(:,c)))./(max(Movs.newarray(:,c))-min(Movs.newarray(:,c)));
end
			Mov_Normalize 'Close'		
	Mov_Movie 'Refresh Axes'
	if Movs.Signal.True==1;
       Mov_Movie 'Signal'
   end
   if Norm.Apply==0
			Movs.newarray=Norm.Old;
			clear temparray;
		end
		if Norm.Apply==1
		if get(Movs.Button.Global,'value')==1
			Mov_Movielog('Add',['Normalize ',Norm.Func1,' ',Norm.Func2,' ',get(Norm.Box.PercB,'string'),' ',get(Norm.Box.PercM,'string'),' 0']);
			close(Norm.Figure)
		elseif get(Movs.Button.Local,'value')==1
			Mov_Movielog('Add Local',['Normalize ',Norm.Func1,' ',Norm.Func2,' ',get(Norm.Box.PercB,'string'),' ',get(Norm.Box.PercM,'string'),' 1 ',num2str(Movs.Badpic)]);
			Mov_Normalize 'Revert'
		end
		end
		set(Movs.Button.Thresh,'Enable','on')

		
case 'Cancel'
	Movs.newarray=Norm.Old;
	Mov_Normalize 'Close'
Mov_Movie 'Refresh Axes'
	if Movs.Signal.True==1;
       Mov_Movie 'Signal'
	end
	close(Norm.Figure)
	set(Movs.Button.Thresh,'Enable','on')

case 'Apply1'
        z=Mov_Movie('Wait');
	     Norm.Apply=1;
        Temparray=Movs.newarray;
        save Temparray Temparray;
        close(z)
        Mov_Normalize 'Apply'
	
case 'Preview'
   z=Mov_Movie('Wait');
	Norm.Apply=0;
	Mov_Normalize 'Apply'
   close(z);
   
case 'Revert'
   z=Mov_Movie('Wait');
	Mov_Normalize 'AutoB'
	Mov_Normalize 'AutoM'
	set(Norm.Button.AutoM,'value',0)
	set(Norm.Button.AutoB,'value',0)
	set(Norm.Button.AutoB,'value',1)
	Mov_Movielog 'Local'
	close(z);

case 'AutoB'
	set(Norm.Button.ManualB,'value',0)
	set(Norm.Text.PercB,'enable','off')
	
case 'AutoM'
	set(Norm.Button.ManualM,'value',0);
	set(Norm.Text.PercM,'enable','off')
   
case 'ManM'
%	set(Norm.Button.ManualM,'value',1);
if get(Norm.Button.ManualM,'value')==1
Mov_Normalize 'Reset'
	set(Norm.Button.AutoM,'value',0)
	set(Norm.Text.PercM,'enable','on')
	yval=max(Movs.newarray(:,Movs.Current_ch))*.95;
	C=findobj(Movs.Display.Figure,'tag','line3');
	if isempty(C)
		C=line([Movs.Display.X1X2(1) Movs.Display.X1X2(2)],[yval yval],'Parent',Movs.Plot,'LineWidth',2,'Erasemode','xor','tag','line3');
%		C=line([Movs.Display.X1X2(1) Movs.Display.X1X2(2)],[yval yval],'Parent',Movs.Plot,'color','y','LineWidth',2,'Erasemode','xor','tag','line3');
	else
		set(C,'xdata',[Movs.Display.X1X2(1) Movs.Display.X1X2(2)],'ydata',[yval yval])
	end 
	figure(Movs.Display.Figure)
	Movs.Mag=1;
	Movs.Threshold=1;
	set(Norm.Figure,'Visible','off')
end
	
case 'ManB'
%	set(Norm.Button.ManualB,'value',1);
if get(Norm.Button.ManualB,'value')==1
Mov_Normalize 'Reset'
	set(Norm.Button.AutoB,'value',0);	
	set(Norm.Text.PercB,'enable','on')
	yval=max(Movs.newarray(:,Movs.Current_ch))*.05;
	B=findobj(Movs.Display.Figure,'tag','line2');
	if isempty(B)
		B=line([Movs.Display.X1X2(1) Movs.Display.X1X2(2)],[yval yval],'Parent',Movs.Plot,'LineWidth',2,'Erasemode','xor','tag','line2');
%		B=line([Movs.Display.X1X2(1) Movs.Display.X1X2(2)],[yval yval],'Parent',Movs.Plot,'color','b','LineWidth',2,'Erasemode','xor','tag','line2');
	else
		set(B,'xdata',[Movs.Display.X1X2(1) Movs.Display.X1X2(2)],'ydata',[yval yval])
	end 
	figure(Movs.Display.Figure)
	Movs.Mag=2;
	Movs.Threshold=1;
	set(Norm.Figure,'Visible','off')
end

case 'on'
if Movs.Threshold==1;
		set(Norm.Figure,'Visible','on')
		B=findobj(Movs.Display.Figure,'tag','line2');
		C=findobj(Movs.Display.Figure,'tag','line3');
		if ~isempty(B)
			temp=get(B,'ydata');
			Norm.PercB=round(temp(1)/63*100);
			set(Norm.Box.PercB,'string',num2str(Norm.PercB))
		end
		if ~isempty(C)
			temp=get(C,'ydata');
			Norm.PercM=round(temp(1)/63*100);
			set(Norm.Box.PercM,'string',num2str(Norm.PercM))
		end
	end

case 'Reset'
	Movs.newarray=Norm.Old;
Mov_Movie 'Refresh Axes'
	if Movs.Signal.True==1;
       Mov_Movie 'Signal'
	end	
	
case 'Close'
		B=findobj(Movs.Display.Figure,'tag','line2');
		C=findobj(Movs.Display.Figure,'tag','line3');
if ~isempty(B)
		delete(B)
end
if ~isempty(C)
		delete(C)	
end	




case 'Loaded'
	% GLOBAL APPLY		GLOBAL APPLY		GLOBAL APPLY		GLOBAL APPLY
if get(Movs.Button.Global,'value')==1
	if Norm.Func1=='ab'
		for c=1:Movs.xydim(1)*Movs.xydim(2)
			 x=sort(Movs.newarray(:,c));
			Temp.Val=x(length(x)/3+5);
	    	Movs.newarray(:,c)=wthresh(Movs.newarray(:,c),'s',Temp.Val)+Temp.Val;
		end  
	end
	if Norm.Func2=='am';
		for c=1:Movs.xydim(1)*Movs.xydim(2)
			 x=sort(Movs.newarray(:,c));
			Temp.Val=x(length(x)/4*3+5)*-1+63;
			Movs.newarray(:,c)=Movs.newarray(:,c)*-1+63;
	    	Movs.newarray(:,c)=(wthresh(Movs.newarray(:,c),'s',Temp.Val)+Temp.Val)*-1+63;
		end  
	end

	if Norm.Func1=='mb'
      for c=1:Movs.xydim(1)*Movs.xydim(2)
         Temp.Val=Norm.mb;
		    Movs.newarray(:,c)=wthresh(Movs.newarray(:,c),'s',Temp.Val)+Temp.Val;
		end
	end
	if Norm.Func2=='mm';
		for c=1:Movs.xydim(1)*Movs.xydim(2)
			Temp.Val=Norm.mm*-.64+63;
			Movs.newarray(:,c)=Movs.newarray(:,c)*-1+63;
	    	Movs.newarray(:,c)=(wthresh(Movs.newarray(:,c),'s',Temp.Val)+Temp.Val)*-1+63;
		end  
   end
   
	for c=1:Movs.xydim(1)*Movs.xydim(2)
  	    Movs.newarray(:,c)=63*(Movs.newarray(:,c)-ones(length(Movs.newarray(:,c)),1)*min(Movs.newarray(:,c)))./(max(Movs.newarray(:,c))-min(Movs.newarray(:,c)));
	end
%	LOCAL APPLY			LOCAL APPLY			LOCAL APPLY			LOCAL APPLY			LOCAL APPLY
elseif get(Movs.Button.Local,'value')==1
		c=Movs.Current_ch;
	if Norm.Func1=='ab'
			x=sort(Movs.newarray(:,c));
			Temp.Val=x(length(x)/3+5);
	    	Movs.newarray(:,c)=wthresh(Movs.newarray(:,c),'s',Temp.Val)+Temp.Val;
	end
	if 	Norm.Func2=='am'
			 x=sort(Movs.newarray(:,c));
			Temp.Val=x(length(x)/4*3+5)*-1+63;
			Movs.newarray(:,c)=Movs.newarray(:,c)*-1+63;
	    	Movs.newarray(:,c)=(wthresh(Movs.newarray(:,c),'s',Temp.Val)+Temp.Val)*-1+63;
	end

	if Norm.Func1=='mb'
			Temp.Val=Norm.mb*.64;
		    Movs.newarray(:,c)=wthresh(Movs.newarray(:,c),'s',Temp.Val)+Temp.Val;
	end
	if 	Norm.Func2=='mm'
			Temp.Val=Norm.mm*-.64+63;
			Movs.newarray(:,c)=Movs.newarray(:,c)*-1+63;
	    	Movs.newarray(:,c)=(wthresh(Movs.newarray(:,c),'s',Temp.Val)+Temp.Val)*-1+63;
	end
   Movs.newarray(:,c)=63*(Movs.newarray(:,c)-ones(length(Movs.newarray(:,c)),1)*min(Movs.newarray(:,c)))./(max(Movs.newarray(:,c))-min(Movs.newarray(:,c)));	
end
	Mov_Movie 'Refresh Axes'
	if Movs.Signal.True==1;
       Mov_Movie 'Signal'
   end
		if get(Movs.Button.Global,'value')==1
			Mov_Movielog('Add',['Normalize ',Norm.Func1,' ',Norm.Func2,' ',num2str(Norm.mb),' ',num2str(Norm.mm),' 0']);
		elseif get(Movs.Button.Local,'value')==1
			Mov_Movielog('Add Local',['Normalize ',Norm.Func1,' ',Norm.Func2,' ',num2str(Norm.mb),' ',num2str(Norm.mm),' 1 ',num2str(Movs.Badpic)]);
			Mov_Normalize 'Revert'
		end
		end
end
