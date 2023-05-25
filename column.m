% This program sums the column values of the most recent Zeng_Contour
% Use: column(num)
% num is the location of the epicardium 1: left, 2: right
function [varargout]=temp(Side);


load junk
a=[];
c=[];
[xx yy]=size(bsteve);
%bsteve=bsteve';
if ~exist('Side')
    Side=1;
end

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

% a'
% c'
c1=1;
c2=1;
c3=1;
c4=1;
call=1;
q1=[];
q2=[];
q3=[];
q4=[];
for col=1:yy
    for row=1:xx
        if bsteve(row,col)>0
            if row<=xx/2 & col<=yy/2
                q1(c1)=bsteve(row,col);
                c1=c1+1;
            elseif row<=xx/2 & col>yy/2
                q2(c2)=bsteve(row,col);
                c2=c2+1;
             elseif row>xx/2 & col<yy/2
                q3(c3)=bsteve(row,col);
                c3=c3+1;
             elseif row>xx/2 & col>yy/2
                q4(c4)=bsteve(row,col);
                c4=c4+1;
            end
            qall(call)=bsteve(row,col);
            call=call+1;
        end
    end
end


       

[rdim cdim]=size(bsteve);
disp(['All Data:          RVB  LVB  RVA  LVA'])
disp(['Quadrant averages: ',num2str(mean(q1)),' ',num2str(mean(q2)),' ',num2str(mean(q3)),' ',num2str(mean(q4))])
disp(['Quadrant median: ',num2str(median(q1)),' ',num2str(median(q2)),' ',num2str(median(q3)),' ',num2str(median(q4))])
disp(['Quadrant std: ',num2str(std(q1)),' ',num2str(std(q2)),' ',num2str(std(q3)),' ',num2str(std(q4))])

disp(['Average APD ',num2str(mean(qall))]);
disp(['Stdev APD ',num2str(std(qall))]);
xx=(max(bsteve'));
xx=sort(xx);
yy=min(bsteve');
yy=sort(yy);
c=xx(find(xx<4000));
d=yy(find(yy<4000));
a=length(c);
b=length(c);
disp(['Max95 ',num2str(mean(c(round(a*.95):end)))])
disp(['Min95 ',num2str(mean(c(1:4)))])
max_dispersion=mean(c(round(a*.95):end))-mean(d(1:4))
disp(['t-test (0 no diff, 1 diff) RVB-LVB:',num2str(ttest2(q1,q2)),' RVB-RVA:',num2str(ttest2(q1,q3)),' RVB-LVA:',num2str(ttest2(q1,q4))]);

