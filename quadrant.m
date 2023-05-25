% This program sums the column values of the most recent Zeng_Contour
% Use: column(num)
% num is the location of the epicardium 1: left, 2: right
function [varargout]=temp(Side);

disp('Set to analyze 3rds')
Side=1;
load junk
a=[];
c=[];
[xx yy]=size(bsteve);
qs=2;
%%%%%%%% New Code%%%%%%%%%%%%
bstevemod(1:xx,1:yy)=0;
nsteve = xx*yy;
for count = 1:xx
    for count2 = 1:yy
        if isnan(bsteve(count,count2))==1
            bstevemod(count,count2)=0;
            nsteve = nsteve-1;
        else
            bstevemod(count,count2)=bsteve(count,count2);
        end
    end
end
meanovrl = sum(sum(bstevemod))/nsteve;
stdovrl = mean(std(bstevemod));
stdovrl3 = std(bsteve);
npts = length(stdovrl);
for count = 1:length(stdovrl3);
    if isnan(stdovrl3(count))==1
        stdovrl3(count)=0;
        npts = npts-1;
    end
end
stdovrl2 = sum(stdovrl3)/npts;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% bsteve=bsteve';
% [xx yy]=size(bsteve);
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
            if row<xx/qs & col<yy/qs
                q1(c1)=bsteve(row,col);
                c1=c1+1;
            elseif row<xx/qs & col>yy/(1-qs)
                q2(c2)=bsteve(row,col);
                c2=c2+1;
             elseif row>xx/(1-qs) & col<yy/qs
                q3(c3)=bsteve(row,col);
                c3=c3+1;
             elseif row>xx/(1-qs) & col>yy/(1-qs)
                q4(c4)=bsteve(row,col);
                c4=c4+1;
            end
            qall(call)=bsteve(row,col);
            call=call+1;
        end
    end
end


       

[rdim cdim]=size(bsteve);
% disp(['Quadrant averages: ',num2str(mean(q1)),' ',num2str(mean(q2)),' ',num2str(mean(q3)),' ',num2str(mean(q4))])
% disp(['Quadrant median: ',num2str(median(q1)),' ',num2str(median(q2)),' ',num2str(median(q3)),' ',num2str(median(q4))])
% disp(['Quadrant std: ',num2str(std(q1)),' ',num2str(std(q2)),' ',num2str(std(q3)),' ',num2str(std(q4))])disp(['Quadrant averages: ',num2str(mean(q1)),' ',num2str(mean(q2)),' ',num2str(mean(q3)),' ',num2str(mean(q4))])
disp(['Quadrant averages: 1. RVB, 2. LVB, 3. RVA 4. LVA'])
% Q_Avg=[mean(q1) mean(q2) mean(q3) mean(q4)]'
% disp(['Quadrant median: '])
Q_Med=[round(median(q1)) round(median(q2)) round(median(q3)) round(median(q4))]'
% disp(['Quadrant std: '])
% Q_Std=[std(q1) std(q2) std(q3) std(q4)]'

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
% disp(['Max95 ',num2str(mean(c(round(a*.95):end)))])
% disp(['Min95 ',num2str(mean(c(1:4)))])
% max_dispersion=mean(c(round(a*.95):end))-mean(d(1:4))
% disp(['t-test (0 no diff, 1 diff) RVB-LVB:',num2str(ttest2(q1,q2)),' RVB-RVA:',num2str(ttest2(q1,q3)),' RVB-LVA:',num2str(ttest2(q1,q4))]);
% disp(['Overall standard deviation of APD: ',num2str(stdovrl)]);
% disp(['Overall standard deviation of APD: ',num2str(stdovrl2)]);
% disp(['Overall mean APD: ',num2str(meanovrl)]);


