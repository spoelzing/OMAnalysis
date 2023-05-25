clear all
close all
fclose all;

[Filename2 Path2]=uigetfile('d:\*.*','Load DATA file');
fid2=fopen([Path2 Filename2],'r');
header=fread(fid2,22);
channels=str2num(char(fread(fid2,3)'));
header=fread(fid2,5);
data1=fread(fid2,'uint16')';
samples=length(data1)/channels;
fclose(fid2);
fid2=fopen([Path2 Filename2],'r');
header=fread(fid2,31);
setstr(header')
data1=fread(fid2,[samples channels],'uint16')';

for i=1:256
   tdata=data1(i,:);
   plot(tdata)
   break
end       
break
[Filename1 Path]=uigetfile('c:\temp\*.ant','Load Annote file');
   
   fid1=fopen([Path Filename1],'r');
   
   header=fread(fid1,21);
   
[t1,channel1,type1]=textread([Path Filename1],'%d %d %s');
filelength=length(t1);
maxlocation=strmatch('Max',type1);
minlocation=strmatch('Min',type1);
max1(channel1(maxlocation)+1)=t1(maxlocation);
min1(channel1(minlocation)+1)=t1(minlocation);
fclose(fid1);

   magnitude(i)=tdata(max1(i))-tdata(min1(i));
   magnitude
