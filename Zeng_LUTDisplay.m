function [varargout]=Zeng_LUTDisplay(varargin)
global Log
action = varargin{1};
switch action
%================================================================
case 'Initial'
   Zeng_Error('Please contact Zeng')
   
case 'DeleteFcn'
   if ~strcmp('Stripchart',get(gcbf,'tag'))
      LUTDisplay=get(gcbf,'userdata');
      Stripchart=get(LUTDisplay.Parent,'userdata');
      Stripchart.LUTDisplay(find(Stripchart.LUTDisplay==LUTDisplay.Figure))=[];
      set(Stripchart.Figure,'userdata',Stripchart);
   end
case 'Histrogram'
   LUTDisplay=get(gcbf,'userdata');
   figure('MenuBar','none')
   hist(LUTDisplay.Annote(:,2))
case 'Refresh'
   if 0
   LUTDisplay=get(gcbf,'userdata');
   Stripchart=get(LUTDisplay.Parent,'userdata');
   Temp.Show=find(Stripchart.Annote.Show(:,3)==1);
   Temp.Annote=find(Stripchart.Annote.Array(:,2)>=LUTDisplay.X1X2(1) & Stripchart.Annote.Array(:,2)<=LUTDisplay.X1X2(2) );
   LUTDisplay.Annote=[];
   for i=1:length(Temp.Show);
      Temp.index=strmatch(Stripchart.Annote.Show(Temp.Show(i),1:2),char(Stripchart.Annote.Array(Temp.Annote,3:4)));
      LUTDisplay.Annote=[LUTDisplay.Annote;Stripchart.Annote.Array(Temp.Annote(Temp.index),:)];
   end
   set(LUTDisplay.Figure,'userdata',LUTDisplay);
   Zeng_LUTDisplay('LUT Reading',LUTDisplay.Figure,LUTDisplay.LUT);
   Zeng_LUTDisplay('Plot TimeMap',LUTDisplay.Figure);
   set(findobj(LUTDisplay.Figure,'type','text'),'fontsize',Log.UD.Ref.FontSize);         
   end
case 'LUT Reading'
   %2)LUT name + Ext
   %3)Ch_XY or ChLabel
   %4)Version    1) Optical Tab  2)Extra cellular Mapping Tab
   %5)Chans.... used only for Optical data
   %LUTDisplay=get(varargin{2},'userdata');
   FID=fopen([Log.UD.Path Log.UD.CD 'lut' Log.UD.CD varargin{2}],'r');
   if FID>0
      switch varargin{3}
      case 'Ch_XY'
         Line=fgetl(FID);
         %To get rid of the titile
         while ~isempty(find(Line==35)) %35= '#' :Tab sysbol
            Line=fgetl(FID);
         end
         Line=str2num(Line);
         while length(Line)==1 %9='tab', 32=space bar
            Line=str2num(fgetl(FID));
         end
         Ch_XY=[];
         %if Temp.Continue==1 %*.tab
         if varargin{4}==2  %
            Temp.Ch=1;
            while  length(Line)==6 % 
               Ch_XY=[Ch_XY;Line([2 1])];
               Line=fgetl(FID);
               Line=str2num(Line);
            end
            Ch_XY=[(1:length(Ch_XY(:,1)))' Ch_XY];
            
           	Interp_Segment=[];   
            Line=num2str(Line);  
            while  length(Line)>3 % 
               Line=str2num(Line);
              	Interp_Segment=[Interp_Segment;Line([2 1 4 3])];   
               Line=fgetl(FID);
            end

         else  %    Optical data
            Ch_XY=[Ch_XY;Line([5 1 2])];
            Temp.XSpace=inf;
            Temp.YSpace=inf;
            while  feof(FID)==0 %|length(Line)==5%
               Line=fgetl(FID);
               Line=str2num(Line);
               if isempty(find(Ch_XY(:,2)==Line(1)))
                  Temp.XSpace=[Temp.XSpace abs(Line(1)-Ch_XY(1,2))];
               end
               if isempty(find(Ch_XY(:,3)==Line(2)))
                  Temp.YSpace=[Temp.YSpace abs(Line(2)-Ch_XY(1,3))];
               end
               Ch_XY=[Ch_XY;Line([5 1 2])];
            end
            Ch_XY(:,2:3)=[(Ch_XY(:,2)-min(Ch_XY(:,2)))/min(Temp.XSpace)+1    (Ch_XY(:,3)-min(Ch_XY(:,3)))/min(Temp.YSpace)+1];
         	Interp_Segment=[];   
         end
         varargout(1)={Ch_XY};
         varargout(2)={Interp_Segment};   

      case 'ChLabel'
         %if Temp.Continue==1 %*.tab
         if varargin{4}==1  %Optical data
            ChLabel=[(0:(varargin{5}-1))' (1:varargin{5})'];
            
         else  %=2    extra cellular
            %Get rid of the  1 line
            Line=fgetl(FID);
            Ch=str2num(fgetl(FID));
            Board=str2num(fgetl(FID));  %no of Board
            Amp=str2num(fgetl(FID));    %no of Amplifier
            %Get rid of the first 5-6 line
            Line=fgetl(FID);Line=fgetl(FID);
            ChLabel=zeros(Ch,3);
            
            Line=fgetl(FID);
            Line=str2num(Line);
            counter=1;
            while  length(Line)==6 %feof(FID)==0 
               ChLabel(counter,:)=[counter Line(3)*Amp+Line(4)+1 Line(5)*Amp+Line(6)+1];
               Line=fgetl(FID);
               Line=str2num(Line);
               counter=counter+1;
            end
         end
         varargout(1)={ChLabel};      
      end
      %To open all head file
      fclose(FID);
   else
      varargout(1)={[]};
      Zeng_Error(['I did not see the look-up-table "' varargin{2}  '" !!! ' 13 13 'Please save it in my program folder "\lut"'])
   end
case 'Plot TimeMap'
   LUTDisplay=get(varargin{2},'userdata');
   Stripchart=get(LUTDisplay.Parent,'userdata');
   %I have to plot blank image first to add Text Ch
   %From LUT display
   LUTDisplay.Image=[];
   LUTDisplay.Image=nan*ones(max(LUTDisplay.Ch_XY(:,3)),max(LUTDisplay.Ch_XY(:,2)));
   axes(LUTDisplay.Axes);
   delete(get(LUTDisplay.Axes,'children'));
  
   set(LUTDisplay.Axes,'xlim',[min(LUTDisplay.Ch_XY(:,2))-.5 max(LUTDisplay.Ch_XY(:,2))+.5],'ylim',[min(LUTDisplay.Ch_XY(:,3))-.5 max(LUTDisplay.Ch_XY(:,3))+.5]);
   LUTDisplay.ImageHD=image(LUTDisplay.Image);
   set(LUTDisplay.ImageHD,'Tag','LUTImage')
   LUTDisplay.Image(LUTDisplay.Ch_XY(:,3),LUTDisplay.Ch_XY(:,2))=256;
   for i=1:length(LUTDisplay.Ch_XY(:,1))
      text(LUTDisplay.Ch_XY(i,2)-.4,LUTDisplay.Ch_XY(i,3),num2str(LUTDisplay.Ch_XY(i,1)),'erasemode','xor','fontsize',Log.UD.Ref.FontSize)
   end
   set(LUTDisplay.ImageHD,'cdata',LUTDisplay.Image);
   set(LUTDisplay.Figure,'userdata',LUTDisplay);
   
case 'Mouse Down'
   LUTDisplay=get(gcbf,'userdata');
   
   if strcmp(LUTDisplay.CurrentPlot,'Contour')
		Interp=str2num(get(LUTDisplay.Pop.Interp,'string'));
   	Interp=1+Interp(get(LUTDisplay.Pop.Interp,'value'));
   else
	   Interp=1;
	end
   Temp.currentpoint=get(LUTDisplay.Axes,'currentpoint');
   Temp.currentpoint=round((Temp.currentpoint(1,1:2)+Interp-1)/Interp)
   Temp.currentpoint(1)=Temp.currentpoint(1);

   
   %Temp.currentpoint=round(get(LUTDisplay.Axes,'currentpoint'));
   %Temp.currentpoint=Temp.currentpoint(1,1:2);
   
   Temp.Ch=find(LUTDisplay.Ch_XY(:,2)==Temp.currentpoint(1) &  LUTDisplay.Ch_XY(:,3)==Temp.currentpoint(2));
   if ~isempty(Temp.Ch)
      Temp.Ch=LUTDisplay.Ch_XY(Temp.Ch,1);
      Stripchart=get(LUTDisplay.Parent,'userdata');
      Temp.WaveForm=findobj(0,'tag','WaveForm','color',LUTDisplay.Color,'name',[Stripchart.Head.FileName ':' 'WaveForm']);
      if isempty(Temp.WaveForm)
         Zeng_Error(['I will work when you have WaveForm window.' char(13) 'Remove "Show Waveform option" or Create a WaveForm window for me.. ' 'OK'])
      else
         WaveForm=get(Temp.WaveForm,'userdata');
         Temp.UnFix=findobj(WaveForm.Ch.CheckBox.Fix,'value',0);
         Temp.LengthUnFix=length(Temp.UnFix);
         if Temp.LengthUnFix<1
         else
            Temp.CurrentAxes=rem(LUTDisplay.CurrentAxes,Temp.LengthUnFix);
            if Temp.CurrentAxes==0
               Temp.CurrentAxes=Temp.LengthUnFix; 
            end
            Temp.CurrentAxes=find(WaveForm.Ch.CheckBox.Fix==Temp.UnFix(Temp.CurrentAxes));
            LUTDisplay.CurrentAxes=LUTDisplay.CurrentAxes+1;
            if LUTDisplay.CurrentAxes>Temp.LengthUnFix;
               LUTDisplay.CurrentAxes=LUTDisplay.CurrentAxes-Temp.LengthUnFix;
            end
            WaveForm.Ch.Current_ch(Temp.CurrentAxes)=Temp.Ch;
            set(WaveForm.Figure,'userdata',WaveForm);
            set(LUTDisplay.Figure,'userdata',LUTDisplay);
            set(WaveForm.Ch.Edit.Channel(Temp.CurrentAxes),'string',Temp.Ch);
            Zeng_WaveForm('Update WaveForm',WaveForm.Figure,Temp.CurrentAxes)
            
         end%         if Temp.LengthUnFix<1
      end%      if isempty(Temp.WaveForm)
   end%if ~isempty(Temp.Ch)
case 'Refresh Axes'
   Temp.LUTDisplay=varargin{2}';
   for i=1:length(Temp.LUTDisplay);
      LUTDisplay=get(Temp.LUTDisplay(i),'userdata');
      if isempty(varargin{3}) | varargin{3}>0
         Temp.Off=LUTDisplay.Text.Ch(varargin{3});
      else%(-1 = all channel)
         Temp.Off=LUTDisplay.Text.Ch;
      end
      set(Temp.Off,'visible','off');
      set(LUTDisplay.Text.Ch(varargin{4}),'visible','on');
   end
   Temp=[];
case 'Setting'
   Zeng_Error('Please contact Zeng')
end%Switch
   
