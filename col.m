% This program sums the column values of the most recent Zeng_Contour
% Use: column(num)
% num is the location of the epicardium 1: left, 2: right
function [varargout]=temp(Side);


load junk
a=[];
c=[];
[xx yy]=size(bsteve);
bsteve=bsteve;

if Side==1
for col=1:yy
   data=bsteve(:,col);
   b=find(data>0);
   if ~isempty(b)
  		 a(col)=round(mean(data(b)));
   	 c(col)=round(std(data(b)));
   end
end
else
for col=1:yy
   data=bsteve(:,col);
   b=find(data>0);
   if ~isempty(b)
  		 a(yy+1-col)=round(mean(data(b)));
   	 c(yy+1-col)=round(std(data(b)));
   end
end
end

a'
c'
disp(['Average APD ',num2str(mean(a))]);
disp(['Stdev APD ',num2str(mean(c))]);
xx=(max(bsteve'));
xx=sort(xx);
yy=min(bsteve');
yy=sort(yy);
c=xx(find(xx<1000));
d=yy(find(yy<1000));
a=length(c);
b=length(c);

max_dispersion=mean(c(round(a*.95):end))-mean(d(1:4))
