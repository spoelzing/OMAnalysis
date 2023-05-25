close all

[Filename1, Pathname1] = uigetfile([Pathname1,'\*.dat'], 'Open Time');
[Filename, Pathname] = uigetfile([Pathname,'\*.dat'], 'Open Data');
a=dlmread([Pathname Filename])';
x=dlmread([Pathname1 Filename1])';

dx=x(2)-x(1);
plot(x,a)
hold
da=diff(a);
i=find(da==max(da));
plot(x(1:end-1),100*da-90,'r')
das=conv2(da,1/25*ones(1,25),'same');
dda=500*diff(das)-50;
%plot(x(1:end-2),dda)
%line([x(i+9000) x(i+9000)],[max(a) min(a)])
b=max(dda(i+9000:end));
amplitude=max(a)-min(a);
[maximum maxindex]=max(a);
baseline=min(a);
percent=maximum-amplitude*.95;
repol=find(a(maxindex:end)<=percent)+maxindex;
repoltime=x(repol(1));
i2=find(dda(i+9900:end)==b);
line([repoltime repoltime],[max(a) min(a)])

apd=abs(x(i)-repoltime)
%[x2 y]=ginput(1)
%apd2=x2-x(i)

hold off
first=1;