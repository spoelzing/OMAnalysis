% This file converts an .ant file into a format for use with Exels
% Surface plotting algorithm. 


[Filename2 Path2]=uigetfile('z:\applications\zeng\lut\*.*','Load LUT');
lutfid=fopen([Path2 Filename2],'r');
[Filename1 Path]=uigetfile('c:\*.ant','Load annotation file');
[data,channel,label]=textread([Path Filename1],'%d %f %s');
Line=fgetl(lutfid);
%To get rid of the titile
      while ~isempty(find(Line==35)) %35= '#' :Tab sysbol
         Line=fgetl(lutfid);
      end
     Line=str2num(Line);
     while length(Line)==1 %9='tab', 32=space bar
         Line=str2num(fgetl(lutfid));
      end
         Ch_XY=[];
         Ch_XY=[Ch_XY;Line([5 1 2])];
         Temp.XSpace=inf;
         Temp.YSpace=inf;
         while  feof(lutfid)==0 %|length(Line)==5%
            Line=fgetl(lutfid);
            Line=str2num(Line);
            if isempty(find(Ch_XY(:,2)==Line(1)))
               Temp.XSpace=[Temp.XSpace abs(Line(1)-Ch_XY(1,2))];
            end
            if isempty(find(Ch_XY(:,3)==Line(2)))
               Temp.YSpace=[Temp.YSpace abs(Line(2)-Ch_XY(1,3))];
            end
            Ch_XY=[Ch_XY;Line([5 1 2])];
         end
         Ch_XY(:,1)=Ch_XY(:,1);
         Ch_XY(:,2:3)=[(Ch_XY(:,2)-min(Ch_XY(:,2)))/min(Temp.XSpace)+1    (Ch_XY(:,3)-min(Ch_XY(:,3)))/min(Temp.YSpace)+1];
         fclose(lutfid);
         arrayimage=0*ones(16);
         
         
         
         
for i=1:length(channel)
   if channel(i)==165
      find(Ch_XY(:,1)==channel(i))
   end
   loc=find(Ch_XY(:,1)==channel(i));
   if ~isempty(loc)
      arrayimage(Ch_XY(loc,3),Ch_XY(loc,2))=data(i);
   end
end
arrayimage=flipud(arrayimage);
[Filename3 Pathname3]=uiputfile([Path,'\',Filename1(1:end-4),'.ent'],'Save the Excel Format');
dlmwrite([Pathname3 Filename3],arrayimage,'\t');
