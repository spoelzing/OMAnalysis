function [varargout]=Zeng_Analysis(varargin)
global Log
global Data
global Stripchart
%action = varargin{1};
aaa=get(gcbf,'userdata');
if isempty(Stripchart) | ~isempty(aaa)
   Stripchart=get(gcbf,'userdata');
else
   Stripchart=get(varargin{2},'userdata');
end


Temp.P=findobj(Stripchart.Axes,'type','patch','LineWidth',Log.UD.Ref.ThickLine);
if isempty(Temp.P)
   Zeng_Error('Please activate one segment for me. ');
else
Temp.X=get(Temp.P,'xdata');
Temp.X=round(Temp.X(1:2));
action=varargin{1};
switch action
case Log.Annote.Label(1) 
   %Output =1)Lable 2)Comment 3)Ch_Time
   if Stripchart.Head.Help.DataType==1 %Optical Data (Mono , inverse data)
      [Label,Comment,AnnoteArray]=Zeng_Monoderneg(Stripchart.Figure,Temp.X,Stripchart.ChLabel,Stripchart.Annote.Array);
      Zeng_Analysis('Existing Check',Stripchart.Figure,Label,Comment,AnnoteArray)
   elseif Stripchart.Head.Help.DataType==2 %Extracellular Data (Bipolar data)
      [Label,Comment,AnnoteArray]=Zeng_BiPeak(Stripchart.Figure,Temp.X,Stripchart.ChLabel,Stripchart.Annote.Array);
      Zeng_Analysis('Existing Check',Stripchart.Figure,Label,Comment,AnnoteArray)
   else
      Zeng_Error('Your data file is weird');
   end
case Log.Annote.Label(2)
   %Output =1)Lable 2)Comment 3)Ch_Time
   if Stripchart.Head.Help.DataType==1 %Optical Data (Mono , inverse data)
      [Label,Comment,AnnoteArray]=Zeng_MonoDerPos(Stripchart.Figure,Temp.X,Stripchart.ChLabel,Stripchart.Annote.Array);
      Zeng_Analysis('Existing Check',Stripchart.Figure,Label,Comment,AnnoteArray)
   elseif Stripchart.Head.Help.DataType==2 %Extracellular Data (Bipolar data)
      if 1
         Zeng_Share('Error','Polite', 'I am sorry. Repolarization is not available')
      else
      %[Label,Comment,Ch_Time]=Zeng_BiDerPos(Stripchart.Figure,Temp.X,Stripchart.ChLabel);
      %Zeng_Analysis('Existing Check',Stripchart.Figure,Label,Comment,Ch_Time)
      [FileName, Path] = uigetfile([Log.UD.Path Log.UD.CD 'M' Log.UD.CD '*.m'], 'Please select your algorithm');
      if max([FileName Path]) ~= 0%if you do not click cancel
         if nargout(FileName)==3 & nargin(FileName)==4
            FileName=FileName(1:find(FileName=='.')-1);
            eval(['[Label,Comment,AnnoteArray]=' FileName '(Stripchart.Figure,Temp.X,Stripchart.ChLabel,Stripchart.Annote.Array);']);
            Label=Log.Annote.Label{2};
            Zeng_Analysis('Existing Check',Stripchart.Figure,Label,Comment,AnnoteArray)
         else
            Zeng_Error('Your file is weird');
         end
      end
   end
end
   
   
case Log.Annote.Label(3)
   Zeng_Analysis(Log.Annote.Label{1})
   Zeng_Analysis(Log.Annote.Label{2})
case 'SignalAverage'
   Zeng_SignalAverage(Stripchart.Figure,Temp.X,Stripchart.ChLabel,Stripchart.Annote.Array);
case 'Percent Repol'
   [Label,Comment,AnnoteArray]=Zeng_Percent(Stripchart.Figure,Temp.X,Stripchart.ChLabel,Stripchart.Annote.Array);
   Zeng_Analysis('Existing Check',Stripchart.Figure,Label,Comment,AnnoteArray);
case 'Alternans'
   Zeng_Alternans(Stripchart.Figure,Temp.X,Stripchart.ChLabel,Stripchart.Annote.Array);
case 'Calcium1'
   Steve_Calcium(Stripchart.Figure,Temp.X,Stripchart.ChLabel,Stripchart.Annote.Array);
case 'Calcium2'
   Steve_Calcium_Tau(Stripchart.Figure,Temp.X,Stripchart.ChLabel,Stripchart.Annote.Array);
case 'Calcium3'
   Steve_SecondWave(Stripchart.Figure,Temp.X,Stripchart.ChLabel,Stripchart.Annote.Array);
case 'Calcium3'
   Steve_SecondWave(Stripchart.Figure,Temp.X,Stripchart.ChLabel,Stripchart.Annote.Array);
case 'RiseTime'
   Steve_RiseTime(Stripchart.Figure,Temp.X,Stripchart.ChLabel,Stripchart.Annote.Array);
case '50Upstroke'
   Steve_50Upstroke(Stripchart.Figure,Temp.X,Stripchart.ChLabel,Stripchart.Annote.Array);
case 'Other Method'
   [FileName, Path] = uigetfile([Log.UD.Path Log.UD.CD 'M' Log.UD.CD '*.m'], 'Please select your algorithm');
   if max([FileName Path]) ~= 0%if you do not click cancel
      FileName=FileName(1:find(FileName=='.')-1);
      if nargout(FileName)==3 &  nargin(FileName)==4
         eval(['[Label,Comment,AnnoteArray]=' FileName '(Stripchart.Figure,Temp.X,Stripchart.ChLabel,Stripchart.Annote.Array);']);            
            if ~isempty(Label) & ~isempty(Comment) &~isempty(AnnoteArray)
               %for n=1:length(Log.Annote.Label)
                %  if strcmp(Label,Log.Annote.Label{n})
                %     Zeng_Error('This label has been reserved');
                %     return
                %  end
               %end
               Zeng_Analysis('Existing Check',Stripchart.Figure,Label,Comment,AnnoteArray)
            end
            else
            Zeng_Error('Your file is weird');
            end
       end
     
   case 'Existing Check'    
      %1)'Existing Check' 2)Figure 3)Label 4)Comment 5)AnnoteArray
      Continue=0;
      Label=varargin{3};
      Comment=varargin{4};
      AnnoteArray=round(varargin{5});
      if isempty(AnnoteArray)
         return
      end
      
      Temp.Length=length(Label);
      
      if Temp.Length<1
         Zeng_Error(['Your annote label has to be something!' char(13) 'OK!!!']);
      else
         if Temp.Length<3 
            Label=[Label 32*ones(1,(3-Temp.Length))];
         end	
         if isempty(Stripchart.Annote.Show) & ~isempty(AnnoteArray)%4
            Continue=1;
            %We need to put them here so that it won't get conflict if already existed
            Stripchart.Annote.Show=[Stripchart.Annote.Show;1 Label+0];
            Stripchart.Annote.ShowComment=[Stripchart.Annote.ShowComment;{Comment}];
         else
            if isempty(strmatch(Label,Stripchart.Annote.Show(:,2:(1+Stripchart.Annote.ShowLength)))) | isempty(AnnoteArray)%3
               Continue=2;
               if ~isempty(AnnoteArray)
               %We need to put them here so that it won't get conflict if already existed
               Stripchart.Annote.Show=[Stripchart.Annote.Show;1 Label+0];
               Stripchart.Annote.ShowComment=[Stripchart.Annote.ShowComment;{Comment}];
               end
            else
               Temp.index=strmatch(Label,Stripchart.Annote.Array(:,3:(2+Stripchart.Annote.ShowLength)));
               if isempty(Temp.index)  %2
                  Continue=3;
               else
                  Temp.Ch=find(Stripchart.Annote.Array(Temp.index,2)>=Temp.X(1) & Stripchart.Annote.Array(Temp.index,2)<=Temp.X(2));
                  if isempty(Temp.Ch)  %1
                     Continue=4 ; 
                  else
                     ButtonName=questdlg('Annote Data Already Exists',...
                        ' ',...
                        'Replace','Add','Cancel','Cancel');
                     switch ButtonName,
                     case 'Replace'
                        Continue=5; %The number 5,6 are used below too.
                     case 'Add',
                     	Continue=6;
                     end % switch
                  end % 1E
               end  %2E
            end %3E
         end %if isempty(Stripchart.Annote.Show)   %4E
         if Continue
            Stripchart.Annote.Changed=1;
            Stripchart.Annote.Array=AnnoteArray;
            if Continue==5;
               Stripchart.Annote.Array(Temp.index(Temp.Ch),:)=[];
            end
         	set(Stripchart.Figure,'userdata',Stripchart);   
         	Temp=findobj(0,'type','figure','tag','WaveForm','color',get(Temp.P,'EdgeColor'),'name',[Stripchart.Head.FileName ':' 'WaveForm']);
         	if ~isempty(Temp)
            	WaveForm=get(Temp(1),'userdata');
            	% Zeng_WaveForm('Adjust Annote',WaveForm.Figure,1:length(WaveForm.Ch.Axes));
            	Zeng_WaveForm('Adjust Annote',WaveForm.Figure,1: WaveForm.axises);
         	end
         	if ~isempty(Stripchart.Annote.Figure) & (Continue<3)
               Zeng_Annote('Update List',Stripchart.Annote.Figure);
            end
            
            %Update Menu
            if ~isempty(Stripchart.Contour)
               Zeng_Contour('Update Menu',Stripchart.Contour,Stripchart.Annote.Show,Label,'on')
            end
      	end
   	end %if Temp<1
   otherwise
      
   end
end %if isempty(Temp.P)
