clear all
global Ca
CalciumP('Initial')
[Filename1 Path]=uigetfile('c:\windows\desktop\*.ant','Load 1st AF DAT file');
   
   [Ca.t1,Ca.Channel1,Ca.type1]=textread([Path Filename1],'%d %d %s');
   previous_label='ooo';
   Ca.type1= char(Ca.type1);
   [Ca.type2 I]=sortrows(Ca.type1);
   Ca.t1=Ca.t1(I);
   Ca.Channel1=Ca.Channel1(I);
counter=1;
Ca.labels=char([]);
for count=1:length(Ca.t1)
   if previous_label(1)~=Ca.type2(count,1) | previous_label(2)~=Ca.type2(count,2) | previous_label(3)~=Ca.type2(count,3)
      if Ca.type2(count,:)=='Z1 '
      else
         Ca.labels(counter,:)=Ca.type2(count,:);
         previous_label=Ca.type2(count,:);
         counter=counter+1;
      end
      end
   end
   
   
   set(Ca.listbox,'String',Ca.labels);
   set(Ca.listbox2,'String',Ca.labels);
   break
%   endoffile=length(segmenCa.t1)/3;
%segmenCa.t1=fscanf(fid1,'%c')
filelength=length(Ca.t1);
   atlocation=strmatch('AT',Ca.type1);
   rtlocation=strmatch('RT',Ca.type1);
       aCa.t1(Ca.Channel1(atlocation)+1)=Ca.t1(atlocation);
       rCa.t1(Ca.Channel1(rtlocation)+1)=Ca.t1(rtlocation);
       
 [t2,channel2,type2]=textread([Path Filename2],'%d %d %s');
	  atlocation=strmatch('AT',type2);
      rtlocation=strmatch('RT',type2);
       at2(channel2(atlocation)+1)=t2(atlocation);
       rt2(channel2(rtlocation)+1)=t2(rtlocation);
       
       apd1=rCa.t1-aCa.t1;
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



