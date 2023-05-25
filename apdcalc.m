clear all
%close all



[Filename1 Path]=uigetfile('p:\analysis\*.ant','Load 1st AF DAT file');
   [Filename2 Path]=uigetfile('p:\analysis\*.ant','Load 2nd AF DAT file');
   
   fid2=fopen([Path Filename2],'r');
   
   header=fread(fid2,21);
   
   at1=zeros(1,256);
   at2=at1;
   rt1=at1;
   rt2=at1;
   %at1=zeros(1,256);
   %at2=zeros(1,256);
   %segment1=fgetl(fid1);
 [t1,channel1,type1]=textread([Path Filename1],'%d %d %s');
%   endoffile=length(segment1)/3;
%segment1=fscanf(fid1,'%c')
filelength=length(t1);
   atlocation=strmatch('AT',type1);
   rtlocation=strmatch('RT',type1);
       at1(channel1(atlocation)+1)=t1(atlocation);
       rt1(channel1(rtlocation)+1)=t1(rtlocation);
       
 [t2,channel2,type2]=textread([Path Filename2],'%d %d %s');
	  atlocation=strmatch('AT',type2);
      rtlocation=strmatch('RT',type2);
       at2(channel2(atlocation)+1)=t2(atlocation);
       rt2(channel2(rtlocation)+1)=t2(rtlocation);
       
       apd1=rt1-at1;
       apd2=rt2-at2;
       
       i=find(apd1==0);
       [v b z]=find(apd1);
       for count=1:length(i)
          apd1(i(count))=mean(z);
       end
       i=find(apd2==0);
       [v b z]=find(apd2);
       for count=1:length(i)
          apd2(i(count))=mean(z);
       end
       
       deltaapd=apd1-apd2;
       
load channels
%[a,b,c,d,channels]=textread(['cwru.tandem.256.ste'],'%d %d %d %d %d');

channel=channels+1;
nums=1:256;

arrayimage(nums)=deltaapd(channel);
arrayimage=reshape(arrayimage,16,16)';
for row=1:16
   finalimage(row,:)=arrayimage(17-row,:);
end

finalimage=interp2(finalimage,1);
%finalimage=conv2(1/25*ones(5),finalimage);
%finalimage=conv2(finalimage,[1/9 1/9 1/9;1/9 1/9 1/9;1/9 1/9 1/9],'same');
Interp=1;
figure(10)
%imagesc(finalimage)
contourf(finalimage,10,'k');
colormap(gray(256))
axis  off
title(['APD',[Filename1],' - APD',[Filename2]]);
colorbar



