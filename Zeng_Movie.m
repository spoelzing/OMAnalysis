function [varargout]=Zeng_Movie(varargin)
global UD
global Log
global Data

action = varargin{1};
Stripchart=get(gcbf,'userdata');
Temp.P=findobj(Stripchart.Axes,'type','patch','LineWidth',UD.Ref.ThickLine);
if isempty(Temp.P)
   Zeng('Error',' ');
else
   Temp.X=get(Temp.P,'xdata');
   Temp.X=round(Temp.X(1:2));
   if Stripchart.Head.Help.DataType==1 %Optical Data (Mono , inverse data)
      [Label,Comment,Ch_Time]=Zeng_MonoDerNeg(Stripchart.Figure,Stripchart.Head.Chans,Temp.X);
      Zeng_Analysis('Existing Check',Stripchart.Figure,Label,Comment,Ch_Time)
   elseif Stripchart.Head.Help.DataType==2 %Extracellular Data (Bipolar data)
      
      
   else
      Zeng('Error','Your data file is weird');
   end
end %if isempty(Temp.P)
