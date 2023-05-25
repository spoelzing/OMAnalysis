% This function is called from the Ca_Percent Program
% from Zeng's program.
function [varargout]=CalciumP(varargin)   
global APD
global Ca
junk=varargin{1};
switch junk
case 'Activation'
   set(APD.A_Checkbox,'Value',1);
   set(APD.R_Checkbox,'Value',0);
case 'Repolarization'
   set(APD.A_Checkbox,'Value',0);
   set(APD.R_Checkbox,'Value',1);
case 'Initial'
   %The FIRST LISTBOX
Ca.figure = figure('Color',[0.8 0.8 0.8], ...
	'Position',[200 80 450 350], ...
	'Tag','Fig1');
Ca.listbox = uicontrol('Parent',Ca.figure, ...
   'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[10 10 100 189], ...
	'String',' ', ...
	'Style','listbox', ...
	'Tag','Listbox1', ...
   'Value',1);
% SECOND LISTBOX
Ca.listbox2 = uicontrol('Parent',Ca.figure, ...
   'Units','points', ...
	'BackgroundColor',[1 1 1], ...
	'Position',[160 10 100 189], ...
	'String',' ', ...
	'Style','listbox', ...
	'Tag','Listbox2', ...
   'Value',1);
h1 = uicontrol('Parent',Ca.figure, ...
   'Units','points', ...
   'FontSize',25,...
   'FontWeight','bold',...
   'BackgroundColor',[0.8 0.8 0.8], ...
   'HorizontalAlignment','left',...
   'ListboxTop',0, ...
	'Position',[270 180 10 20], ...
	'String','=', ...
	'Style','text', ...
   'Tag','StaticText2');
Ca.Text = uicontrol('Parent',Ca.figure, ...
	'Units','points', ...
   'BackgroundColor',[1 0 0], ...
   'callback','CalciumP(''Subtract'')',...
	'ListboxTop',0, ...
	'Position',[115 150 40 20], ...
	'String','subtract', ...
   'Tag','Pushbutton1');

case 'Subtract'
   clear time1 time2;
   time1=zeros(1,261);
   time2=zeros(1,261);
   one=get(Ca.listbox,'Value');
   two=get(Ca.listbox2,'Value');
   temp1=get(Ca.listbox,'String');
   temp2=get(Ca.listbox2,'String');
   output1=temp1(one,:);
   output2=temp2(two,:);
   counter1=1;
   counter2=1;
for count=1:length(Ca.type1)
   if Ca.type1(count,1)==output1(1) & Ca.type1(count,2)==output1(2) & Ca.type1(count,3)==output1(3)
      time1(Ca.Channel1(count)+1)=Ca.t1(count);   
   end
   if Ca.type1(count,1)==output2(1) & Ca.type1(count,2)==output2(2) & Ca.type1(count,3)==output2(3)
      time2(Ca.Channel1(count)+1)=Ca.t1(count);
   end
end
a=time1-time2
end
