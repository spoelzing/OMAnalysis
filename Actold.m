function act(varargin)
global Act
action = varargin{1};
switch action
%---------------------------------------------------   

case 'Initial'
   close all
   Act.Saved=0;
Act.Order.AT=1;
Act.Order.RT=1;
Act.LowCutoff.AT=60;
Act.LowCutoff.RT=60;
Act.HighCutoff.AT=120;
Act.HighCutoff.RT=120;
Act.PassRipple.AT=1;
Act.PassRipple.RT=1;
Act.StopRipple.AT=1;
Act.StopRipple.RT=1;
Act.Name.AT='bu';
Act.Name.RT='bu';
Act.Type.AT='low ';
Act.Type.RT='low ';
Act.Apply=0;
Act.Boxcar.AT=13;
Act.Boxcar.RT=13;
Act.Blockout=100;
UD.Ref.FontSize=9;
   Act.Figure=figure;
   FG_Size=[250 90 370 500];   
   set(Act.Figure,...
         'Color',[0.8 0.8 0.8], ...
       	'DeleteFcn','',...
         'menu','none',...
         'Name','Activation Repolarization Time',...
         'NumberTitle','off',...
         'Position',FG_Size, ...
         'Tag','Movielog');
  %______________________________
  %   	SCHEME NAME	
  %------------------------------
  Act.schemename =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','Times',...
            'FontUnits','points',...
            'FontSize',9,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[5 470 120 15], ...
            'String','Scheme Name ', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
[values atf att ato atl ath atp ats atb rtf rtt rto rtl rth rtp rts rtb atbo]=textread('arfilters.dat','%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s');
values=strvcat('  - New -',char(values));
         %values = {['  -New-        ']};
Act.Scheme = uicontrol('Parent',Act.Figure, ...
        'Units','points', ...
        'BackgroundColor',[0.733333 0.733333 0.733333], ...
   	  'callback','act Scheme',...
        'Enable','on', ...
        'ListboxTop',0, ...
        'Position',[5 330 90 15], ...
        'String',values, ...
        'Style','popupmenu', ...
        'Tag','PopupMenu1', ...
        'Value',length(values)); 
     
     %  SAVE BUTTON
        Filter.Button.Save = uicontrol('Parent',Act.Figure, ...
         'Units','pixels',...
         'FontName','Times',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[160 440 60 22], ...
         'String','SAVE', ...
         'callback','act(''Save'')',...  
         'Tag','Pushbutton1');

 Act.text1 =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','Times',...
            'FontUnits','points',...
            'FontSize',9,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[5 400 120 15], ...
            'String','Activation Time Filter ', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
  Act.text1 =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','Times',...
            'FontUnits','points',...
            'FontSize',9,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[220 400 150 15], ...
            'String','Repolarization Time Filter', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
    
 % FILTER NAMES BOTH    
 Act.text1 =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','Times',...
            'FontUnits','points',...
            'FontSize',9,...
            'FontWeight','normal',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[130 355 120 15], ...
            'String','Filter Name ', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
         values = {['Butterworth';'Chebychev 1';'Chebychev 2';'Elliptical ';'Boxcar     ']};
Act.Filters.AT = uicontrol('Parent',Act.Figure, ...
        'Units','points', ...
        'BackgroundColor',[0.733333 0.733333 0.733333], ...
   	  'callback','act FilterNameAT',...
        'Enable','on', ...
        'ListboxTop',0, ...
        'Position',[5 265 70 15], ...
        'String',values, ...
        'Style','popupmenu', ...
        'Tag','PopupMenu1', ...
        'Value',1); 
Act.Filters.RT = uicontrol('Parent',Act.Figure, ...
        'Units','points', ...
        'BackgroundColor',[0.733333 0.733333 0.733333], ...
   	  'callback','act FilterNameRT',...
        'Enable','on', ...
        'ListboxTop',0, ...
        'Position',[165 265 70 15], ...
        'String',values, ...
        'Style','popupmenu', ...
        'Tag','PopupMenu1', ...
        'Value',1); 
     
 % FILTER TYPE BOTH    
  Act.text1 =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','Times',...
            'FontUnits','points',...
            'FontSize',9,...
            'FontWeight','normal',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[130 310 120 15], ...
            'String','Filter Type ', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
    
  values = {['Low Pass ';'High Pass';'Band Pass';'Band Stop';]};
  Act.Types.AT = uicontrol('Parent',Act.Figure, ...
        'Units','points', ...
        'BackgroundColor',[0.733333 0.733333 0.733333], ...
   	  'callback','act FilterTypeAT',...
        'Enable','on', ...
        'ListboxTop',0, ...
        'Position',[5 230 70 15], ...
        'String',values, ...
        'Style','popupmenu', ...
        'Tag','PopupMenu1', ...
        'Value',1); 	
 Act.Types.RT = uicontrol('Parent',Act.Figure, ...
        'Units','points', ...
        'BackgroundColor',[0.733333 0.733333 0.733333], ...
   	  'callback','act FilterTypeAT',...
        'Enable','on', ...
        'ListboxTop',0, ...
        'Position',[165 230 70 15], ...
        'String',values, ...
        'Style','popupmenu', ...
        'Tag','PopupMenu1', ...
        'Value',1); 	
% ORDER BOTH     
  Act.Text.Order =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','Times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','normal',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[140 275 50 15], ...
            'String','Order ', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');			
  Act.Box.Order.AT = uicontrol('Parent',Act.Figure, ...
        'Units','pixels',...
		  'callback','act(''IntCheck'')',...
   	  'BackgroundColor',[1 1 1], ...
        'FontName','Times',...
        'FontUnits','points',...
        'FontSize',UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',[55 270 30 22], ...
        'String',Act.Order.AT, ...
   	  'Style','edit', ...
	     'Tag','EditOrder');
   Act.Box.Order.RT = uicontrol('Parent',Act.Figure, ...
        'Units','pixels',...
		  'callback','act(''IntCheck'')',...
   	  'BackgroundColor',[1 1 1], ...
        'FontName','Times',...
        'FontUnits','points',...
        'FontSize',UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',[220 270 30 22], ...
        'String',Act.Order.RT, ...
   	  'Style','edit', ...
        'Tag','EditOrder');
     
%  LOW CUTOFF BOTH     
   Act.Text.Cutoff.Low =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','Times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','normal',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[125 230 80 25], ...
            'String','Low Cut-Off ', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
 Act.Box.Cutoff.Low.AT = uicontrol('Parent',Act.Figure, ...
        'Units','pixels',...
   	  'BackgroundColor',[1 1 1], ...
        'FontName','Times',...
        'FontUnits','points',...
        'FontSize',UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',[55 235 30 22], ...
        'String',Act.LowCutoff.AT, ...
        'Style','edit', ...
        'Tag','EditOrder');
 Act.Cutofflow.AT =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
         'FontName','Times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[90 230 30 25], ...
            'String','Hz', ...
            'Style','text');
  Act.Box.Cutoff.Low.RT = uicontrol('Parent',Act.Figure, ...
        'Units','pixels',...
   	  'BackgroundColor',[1 1 1], ...
        'FontName','Times',...
        'FontUnits','points',...
        'FontSize',UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',[220 235 30 22], ...
        'String',Act.LowCutoff.RT, ...
        'Style','edit', ...
        'Tag','EditOrder');
 Act.Cutofflow.RT =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
         'FontName','Times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[255 230 30 25], ...
            'String','Hz', ...
            'Style','text');
         
         
         
  % HIGH CUTOFF
   Act.Text.Cutoff.High =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','Times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','normal',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[125 195 70 25], ...
            'String','High Cut-Off ', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');	
  Act.Box.Cutoff.High.AT = uicontrol('Parent',Act.Figure, ...
        'Units','pixels',...
   	  'BackgroundColor',[1 1 1], ...
		  'Enable','off',...
        'FontName','Times',...
        'FontUnits','points',...
        'FontSize',UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',[55 200 30 22], ...
        'String',Act.HighCutoff.AT, ...
        'Style','edit', ...
	     'Tag','EditOrder');	
  Act.Cutoffhigh.AT =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
         'Enable','off',...   
         'FontName','Times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[90 193 15 25], ...
            'String','Hz', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
   Act.Box.Cutoff.High.RT = uicontrol('Parent',Act.Figure, ...
        'Units','pixels',...
   	  'BackgroundColor',[1 1 1], ...
		  'Enable','off',...
        'FontName','Times',...
        'FontUnits','points',...
        'FontSize',UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',[220 200 30 22], ...
        'String',Act.HighCutoff.RT, ...
        'Style','edit', ...
	     'Tag','EditOrder');	
  Act.Cutoffhigh.RT =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
         'Enable','off',...   
         'FontName','Times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[255 193 15 25], ...
            'String','Hz', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
         
% PASS RIPPLE
Act.Text.PRipple =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','Times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','normal',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[128 160 70 25], ...
            'String','Pass Ripple ', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
Act.Box.PRipple.AT = uicontrol('Parent',Act.Figure, ...
        'Units','pixels',...
   	  'BackgroundColor',[1 1 1], ...
	     'Enable','off',...
        'FontName','Times',...
        'FontUnits','points',...
        'FontSize',UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',[55 165 30 22], ...
        'String',Act.PassRipple.AT, ...
   	  'Style','edit', ...
	     'Tag','EditOrder');	
Act.Passripple.AT =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
         'Enable','off',...   
         'FontName','Times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[90 159 20 25], ...
            'String','dB', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
Act.Box.PRipple.RT = uicontrol('Parent',Act.Figure, ...
        'Units','pixels',...
   	  'BackgroundColor',[1 1 1], ...
	     'Enable','off',...
        'FontName','Times',...
        'FontUnits','points',...
        'FontSize',UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',[220 165 30 22], ...
        'String',Act.PassRipple.RT, ...
   	  'Style','edit', ...
	     'Tag','EditOrder');	
Act.Passripple.RT =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
         'Enable','off',...   
         'FontName','Times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[255 159 20 25], ...
            'String','dB', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
         
  % STOP RIPPLE
  Act.Text.SRipple =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','Times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','normal',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[128 125 70 25], ...
            'String','Stop Ripple ', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
Act.Box.SRipple.AT = uicontrol('Parent',Act.Figure, ...
        'Units','pixels',...
   	  'BackgroundColor',[1 1 1], ...
        'FontName','Times',...
        'FontUnits','points',...
        'FontSize',UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',[55 128 30 22], ...
        'String',Act.StopRipple.AT, ...
        'Style','edit', ...
	     'Tag','EditOrder');	
Act.Stopripple.AT =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
           'Enable','off',...   
          'FontName','Times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[90 123 15 25], ...
            'String','dB', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
Act.Box.SRipple.RT = uicontrol('Parent',Act.Figure, ...
        'Units','pixels',...
   	  'BackgroundColor',[1 1 1], ...
		  'Enable','off',...
        'FontName','Times',...
        'FontUnits','points',...
        'FontSize',UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',[220 128 30 22], ...
        'String',Act.StopRipple.RT, ...
        'Style','edit', ...
	     'Tag','EditOrder');	
Act.Stopripple.RT =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
           'Enable','off',...   
          'FontName','Times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[255 123 15 25], ...
            'String','dB', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
         
         
 % BOX CAR
  Act.Text.Boxcar =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
            'FontName','Times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','normal',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[134 85 70 25], ...
            'String','Box Car ', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
Act.Box.Boxcar.AT = uicontrol('Parent',Act.Figure, ...
        'Units','pixels',...
   	  'BackgroundColor',[1 1 1], ...
		  'Enable','off',...
        'FontName','Times',...
        'FontUnits','points',...
        'FontSize',UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',[55 90 30 22], ...
        'String',Act.Boxcar.AT, ...
        'Style','edit', ...
	     'Tag','EditOrder');	
Act.Boxcar.AT =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
          'Enable','off',...   
           'FontName','Times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[90 85 15 25], ...
            'String','Pts.', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
Act.Box.Boxcar.RT = uicontrol('Parent',Act.Figure, ...
        'Units','pixels',...
   	  'BackgroundColor',[1 1 1], ...
		  'Enable','off',...
        'FontName','Times',...
        'FontUnits','points',...
        'FontSize',UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',[220 90 30 22], ...
        'String',Act.Boxcar.RT, ...
        'Style','edit', ...
	     'Tag','EditOrder');	
Act.Boxcar.RT =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
          'Enable','off',...   
           'FontName','Times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[255 85 15 25], ...
            'String','Pts.', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
	
Act.text.Blockout =uicontrol('Parent',Act.Figure, ...
            'Units','pixels',...
            'BackgroundColor',[0.8 0.8 0.8], ...
           'FontName','Times',...
            'FontUnits','points',...
            'FontSize',UD.Ref.FontSize,...
            'FontWeight','bold',...
            'FontAngle','normal',...
            'HorizontalAlignment','left', ...
            'Position',[10 50 100 25], ...
            'String','Blockout Period', ...
            'Style','text', ...
            'Tag','StaticText2',...
            'visible','on');
Act.Box.Blockout = uicontrol('Parent',Act.Figure, ...
        'Units','pixels',...
   	  'BackgroundColor',[1 1 1], ...
        'FontName','Times',...
        'FontUnits','points',...
        'FontSize',UD.Ref.FontSize,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','right',...
        'Position',[100 55 30 22], ...
        'String',Act.Blockout, ...
        'Style','edit', ...
	     'Tag','EditOrder');	
		
  % CLOSE BUTTON
     
  Filter.Button.Preview = uicontrol('Parent',Act.Figure, ...
         'Units','pixels',...
         'FontName','Times',...
         'FontUnits','points',...
         'FontSize',UD.Ref.FontSize,...
         'FontWeight','normal',...
         'FontAngle','normal',...
         'Position',[150 15 60 22], ...
         'String','Close', ...
         'callback','act(''close'')',...  
         'Tag','Pushbutton1');
   %=====================================================================================			
   %=====================================================================================
   %=====================================================================================
   
% PROGRAM   
   
   
case 'FilterNameAT'
   Act.Saved=0;
   Filtname=get(Act.Filters.AT,'Value');
   switch Filtname 
   case 1,       
		Act.name.AT=['bu'];
	   set(Act.Box.PRipple.AT,'Enable','off');
		set(Act.Passripple.AT,'Enable','off');
      set(Act.Box.SRipple.AT,'Enable','off');
      set(Act.Boxcar.AT,'Enable','off');
      set(Act.Box.Boxcar.AT,'Enable','off');
		set(Act.Stopripple.AT,'Enable','off');
   case 2,
		Act.name.AT=['c1'];
		set(Act.Box.PRipple.AT,'Enable','on');
		set(Act.Passripple.AT,'Enable','on');
		set(Act.Box.SRipple.AT,'Enable','off');
		set(Act.Boxcar.AT,'Enable','off');
      set(Act.Box.Boxcar.AT,'Enable','off');
		set(Act.Stopripple.AT,'Enable','off');
   case 3,       
		Act.name.AT=['c2']; 
		set(Act.Box.PRipple.AT,'Enable','on');
		set(Act.Passripple.AT,'Enable','on');
		set(Act.Box.SRipple.AT,'Enable','off');
		set(Act.Boxcar.AT,'Enable','off');
      set(Act.Box.Boxcar.AT,'Enable','off');
		set(Act.Stopripple.AT,'Enable','off');
   case 4,
		Act.name.AT=['el'];
		set(Act.Box.PRipple.AT,'Enable','on');
		set(Act.Passripple.AT,'Enable','on');
		set(Act.Box.SRipple.AT,'Enable','on');
  		set(Act.Boxcar.AT,'Enable','off');
      set(Act.Box.Boxcar.AT,'Enable','off');
      set(Act.Stopripple.AT,'Enable','on');
   case 5
  		Act.name.AT=['bo'];
		set(Act.Box.PRipple.AT,'Enable','off');
		set(Act.Passripple.AT,'Enable','off');
		set(Act.Box.SRipple.AT,'Enable','off');
      set(Act.Stopripple.AT,'Enable','off');
		set(Act.Boxcar.AT,'Enable','on');
      set(Act.Box.Boxcar.AT,'Enable','on');

   end   
   
   
case 'FilterNameRT'
    Act.Saved=0;
  Filtname=get(Act.Filters.RT,'Value');
   switch Filtname 
   case 1,       
		Act.name.RT=['bu'];
	   set(Act.Box.SRipple.RT,'Enable','off');
		set(Act.Box.PRipple.RT,'Enable','off');
		set(Act.Passripple.RT,'Enable','off');
	   set(Act.Boxcar.RT,'Enable','off');
      set(Act.Box.Boxcar.RT,'Enable','off');
      set(Act.Stopripple.RT,'Enable','off');
   case 2,
		Act.name.RT=['c1'];
		set(Act.Box.PRipple.RT,'Enable','on');
		set(Act.Passripple.RT,'Enable','on');
		set(Act.Boxcar.RT,'Enable','off');
      set(Act.Box.Boxcar.RT,'Enable','off');
	   set(Act.Box.SRipple.RT,'Enable','off');
		set(Act.Stopripple.RT,'Enable','off');
   case 3,       
		Act.name.RT=['c2']; 
		set(Act.Box.PRipple.RT,'Enable','on');
		set(Act.Passripple.RT,'Enable','on');
		set(Act.Boxcar.RT,'Enable','off');
      set(Act.Box.Boxcar.RT,'Enable','off');
	   set(Act.Box.SRipple.RT,'Enable','off');
		set(Act.Stopripple.RT,'Enable','off');
   case 4,
		Act.name.RT=['el'];
		set(Act.Box.PRipple.RT,'Enable','on');
		set(Act.Passripple.RT,'Enable','on');
		set(Act.Boxcar.RT,'Enable','off');
      set(Act.Box.Boxcar.RT,'Enable','off');
		set(Act.Box.SRipple.RT,'Enable','on');
      set(Act.Stopripple.RT,'Enable','on');
   case 5
  		Act.name.RT=['bo'];
		set(Act.Box.PRipple.RT,'Enable','off');
		set(Act.Passripple.RT,'Enable','off');
		set(Act.Box.SRipple.RT,'Enable','off');
      set(Act.Stopripple.RT,'Enable','off');
      set(Act.Box.Boxcar.RT,'Enable','on');
		set(Act.Boxcar.RT,'Enable','on');
	end   


case 'FilterTypeAT'
   Act.Saved=0;
	FiltType=get(Act.Types.AT,'Value');
	switch FiltType
	case 1,
		Act.Type.AT='low ';
	   set(Act.Box.Cutoff.High.AT,'Enable','off');
		set(Act.Cutoffhigh.AT,'Enable','off');
		set(Act.Box.Cutoff.Low.AT,'Enable','on');
		set(Act.Cutofflow.AT,'Enable','on');
	case 2,
		Act.Type.AT='high';
	    set(Act.Box.Cutoff.High.AT,'Enable','on');
		set(Act.Cutoffhigh.AT,'Enable','on');
		set(Act.Box.Cutoff.Low.AT,'Enable','off');
		set(Act.Cutofflow.AT,'Enable','off');	
	case 3
		Act.Type.AT='pass';
		set(Act.Box.Cutoff.High.AT,'Enable','on');
		set(Act.Cutoffhigh.AT,'Enable','on');
		set(Act.Box.Cutoff.Low.AT,'Enable','on');
		set(Act.Cutofflow.AT,'Enable','on');
	case 4
		Act.Type.AT='stop';
		set(Act.Box.Cutoff.High.AT,'Enable','on');
		set(Act.Cutoffhigh.AT,'Enable','on');
		set(Act.Box.Cutoff.Low.AT,'Enable','on');
		set(Act.Cutofflow.AT,'Enable','on');
	end
	
case 'FilterTypeRT'
   Act.Saved=0;
	FiltType=get(Act.Types.RT,'Value');
	switch FiltType
	case 1,
		Act.Type.RT='low ';
	   set(Act.Box.Cutoff.High.RT,'Enable','off');
		set(Act.Cutoffhigh.RT,'Enable','off');
		set(Act.Box.Cutoff.Low.RT,'Enable','on');
		set(Act.Cutofflow.RT,'Enable','on');
	case 2,
		Act.Type.RT='high';
	    set(Act.Box.Cutoff.High.RT,'Enable','on');
		set(Act.Cutoffhigh.RT,'Enable','on');
		set(Act.Box.Cutoff.Low.RT,'Enable','off');
		set(Act.Cutofflow.RT,'Enable','off');	
	case 3
		Act.Type.RT='pass';
		set(Act.Box.Cutoff.High.RT,'Enable','on');
		set(Act.Cutoffhigh.RT,'Enable','on');
		set(Act.Box.Cutoff.Low.RT,'Enable','on');
		set(Act.Cutofflow.RT,'Enable','on');
	case 4
		Act.Type.RT='stop';
		set(Act.Box.Cutoff.High.RT,'Enable','on');
		set(Act.Cutoffhigh.RT,'Enable','on');
		set(Act.Box.Cutoff.Low.RT,'Enable','on');
		set(Act.Cutofflow.RT,'Enable','on');
	end





case 'IntCheck'

	  order=str2num(get(Act.Box.Order,'String'));
   if ceil(order)~=fix(order)
	      set(Act.Box.Order,'String',order);
         Mov('Error','Integer Numbers Only');
      elseif order>-1
         set(Act.Box.Order,'String',order);
         Act.Order=order;
      else;
         set(Act.Box.Order,'String',order);
         Mov('Error','The number is out of range');
      end
  
  
case 'Scheme'
   scheme=get(Act.Scheme,'Value');
   if scheme==2
    Act.E = dialog('name','Error',...
   'Position',[500 500 320 160],...
   'tag','ZengError');
Temp.FG_Size=get(Act.E,'position');
uicontrol('Parent',Act.E, ...
   'BackgroundColor',get(Act.E,'Color'), ...
   'fontsize',10,...
   'fontweight','bold',...
   'Position',[10 85 300 50], ... 
   'HorizontalAlignment','left',...
   'String','Name the new scheme. Do not use spaces or apostrophes in the name', ...
   'Style','text');
   Act.newname=uicontrol('Parent',Act.E, ...
        'Units','pixels',...
   	  'BackgroundColor',[1 1 1], ...
        'FontName','Times',...
        'FontUnits','points',...
        'FontSize',10,...
        'FontWeight','normal',...
        'FontAngle','normal',...
        'HorizontalAlignment','left',...
        'Position',[10 70 250 22], ...
        'String',[], ...
   	  'Style','edit', ...
        'Tag','EditOrder');

uicontrol('Parent',Act.E, ...
   'callback','act AddName',...
   'Units','points', ...
   'Position',[90 10 57.75 24],...
   'string','OK');




end

case 'Save'
   schemes=get(Act.Scheme,'String');
   %schemes=cell2mat(schemes);
   atf=cellstr(Act.Name.AT);
   att=cellstr(Act.Type.AT);
   ato=cellstr(get(Act.Box.Order.AT,'String'));
   atl=cellstr(get(Act.Box.Cutoff.Low.AT,'String'));
   ath=cellstr(get(Act.Box.Cutoff.High.AT,'String'));
   atp=cellstr(get(Act.Box.PRipple.AT,'String'));
   ats=cellstr(get(Act.Box.SRipple.AT,'String'));
   atb=cellstr(get(Act.Box.Boxcar.AT,'String'));
   rtf=cellstr(Act.Name.RT);
   rtt=cellstr(Act.Type.RT);
   rto=cellstr(get(Act.Box.Order.RT,'String'));
   rtl=cellstr(get(Act.Box.Cutoff.Low.RT,'String'));
   rth=cellstr(get(Act.Box.Cutoff.High.RT,'String'));
   rtp=cellstr(get(Act.Box.PRipple.RT,'String'));
   rts=cellstr(get(Act.Box.SRipple.RT,'String'));
   rtb=cellstr(get(Act.Box.Boxcar.RT,'String'));
   atbo=cellstr(get(Act.Box.Blockout,'String'));
   %data=cellplot(data);
   
     fid=fopen('arfilters.dat','a');
   [x,y]=size(schemes);
   for inc=3:x;
     temp=cellstr(schemes(inc));
     data=char([temp atf att ato atl ath atp ats atb rtf rtt rto rtl rth rtp rts rtb atbo]);
     fprintf(fid,[data(1,:) '\t' data(2,:) '\t' data(3,:) '\t' data(4,:) '\t' data(5,:) '\t' data(6,:) '\t' data(7,:) '\t' data(8,:) '\t' data(9,:) '\t' data(10,:) '\t' data(11,:) '\t' data(12,:) '\t' data(13,:) '\t' data(14,:) '\t' data(15,:) '\t' data(16,:) '\t' data(17,:) '\t' data(18,:) '\r']);
   end
   fclose(fid);

   [schemes atf att ato atl ath atp ats atb rtf rtt rto rtl rth rtp rts rtb atbo]=textread('arfilters.dat','%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s');

case 'AddName'
   
      schemes=get(Act.Scheme,'String');
      newone=get(Act.newname,'String');
      i=strmatch(newone,schemes);
    if isempty(i)
      schemes=[schemes;cellstr(newone)];
      set(Act.Scheme,'String',schemes);
      set(Act.Scheme,'Value',length(schemes));
      close(gcf);
   else
    uicontrol('Parent',Act.E, ...
   'BackgroundColor',get(Act.E,'Color'), ...
   'fontsize',10,...
   'fontweight','bold',...
   'Position',[10 145 300 15], ... 
   'HorizontalAlignment','left',...
   'String','Name already exists', ...
   'Style','text');
    end
   
end


