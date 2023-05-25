function [varargout]=breakfile(Seconds);
% Created by: Steven Poelzing
% 10-24-02
%
% Use
% breakfile(Seconds)
%
% This program breaks a file into smaller consecutive files
% each with data length equal to the number of Seconds entered
% by the user.
%
% It names the new files with the same filename as the orginal
% file with an appended number at the end indicating its
% sequence in the original file.
% 
% New .h files are also created with the same naming convention.
%
% The new files can be read by Zeng.


[FileName Path]=uigetfile('f:\temp\*.*','Load a Zeng file');
FID=fopen([Path FileName '.h']);
if FID~=-1
in=1;
stop=0;
fids=fopen([Path FileName],'r');
header=fread(fids,31,'int8');
fclose(fids);

            while feof(FID)==0
               Line=fgets(FID);
               Temp.Swarp=find(Line>=65 & Line<=90);
               %Convert them to all small characters
               Line(Temp.Swarp)=Line(Temp.Swarp)+32;
               Start=find(Line==char(9) | Line==(32)); %Char(9) = space between tile and value
               Stop=find(Line==char(13));%Char(13)= New line
               if isempty(Stop);
                  Stop=find(Line==char(10));%Char(13)= New line
               end
               if ~isempty(strmatch('subject',Line));
                  %Log.Head.Subject =string(Line(Start(1)+1:Stop(length(Stop))-1)')';
                  Log.Head.Subject =char(Line(Start(1)+1:Stop(length(Stop))-1)')';
               elseif  ~isempty(strmatch('date',Line));
                  %Log.Head.Date =string(Line(Start(1)+1:Stop(length(Stop))-1)')';
                  Log.Head.Date =char(Line(Start(1)+1:Stop(length(Stop))-1)')';
               elseif ~isempty(strmatch('gain',Line));
                  %Log.Head.Gain =str2num(string(Line(Start(1)+1:Stop(length(Stop))-1)')');
                  Log.Head.Gain =str2num(char(Line(Start(1)+1:Stop(length(Stop))-1)')');
               elseif ~isempty(strmatch('srate',Line));
                  %Log.Head.SRate =str2num(string(Line(Start(1)+1:Stop(length(Stop))-1)')');
                  Log.Head.SRate =str2num(char(Line(Start(1)+1:Stop(length(Stop))-1)')');
               elseif ~isempty(strmatch('samples',Line));
                  %Log.Head.Samples =str2num(string(Line(Start(1)+1:Stop(length(Stop))-1)')');
                  Log.Head.Samples =str2num(char(Line(Start(1)+1:Stop(length(Stop))-1)')');
               elseif ~isempty(strmatch('chans',Line));
                  %Log.Head.Chans =str2num(string(Line(Start(1)+1:Stop(length(Stop))-1)')');
                  Log.Head.Chans =str2num(char(Line(Start(1)+1:Stop(length(Stop))-1)')');
               elseif ~isempty(strmatch('comment',Line));
                  %Log.Head.Comment =string(Line(Start(1)+1:Stop(length(Stop))-1)')';
                  Log.Head.Comment =char(Line(Start(1)+1:Stop(length(Stop))-1)')';
               elseif ~isempty(strmatch('lut',Line));
                  %Log.Head.LUT =string(Line(Start(1)+1:Stop(length(Stop))-1)')';
                  Log.Head.LUT =char(Line(Start(1)+1:Stop(length(Stop))-1)')';
               elseif ~isempty(strmatch('sys_ver',Line));
                  %Log.Head.Sys_Ver =string(Line(Start(1)+1:Stop(length(Stop))-1)')';
                  Log.Head.Sys_Ver =char(Line(Start(1)+1:Stop(length(Stop))-1)')';
               end
            end

fclose(FID);
Log.Head.Samples=Seconds*Log.Head.SRate;

FIDData=fopen([Path FileName],'r','b'); %big-endian
Format_Check=(fread(FIDData,7,'uchar')');    % Check the first 20 bytes if it is MIT head format.
Head=fgetl(FIDData);
Head=[Head fgetl(FIDData)];
h=waitbar(in/100,'Please Wait');
while feof(FIDData)==0 | stop==0
 Data=zeros(Log.Head.Chans,Log.Head.Samples);
 for i=1:Log.Head.Samples
      tempData=fread(FIDData,Log.Head.Chans,'int16');
      if ~isempty(tempData)
         Data(:,i)=tempData; 
      else 
         stop=1;
         temp=Data(:,1:i-1);
         Data=[];
         Data=temp;
			break
      end
end	
FID=fopen([Path FileName '.h']);
headerdata=fread(FID,'char');
fclose(FID);
if FileName~=0  % 1
   [x,y]=size(Data);
fid1=fopen(strcat(Path,FileName,'.h'));
junk=fread(fid1);
temp1=junk';
for count=1:length(junk) %2
   temp2=setstr(temp1(count));
     if temp2=='l'
        if setstr(temp1(count+1))=='e'
           if setstr(temp1(count+2))=='s'
              for index=4:9
                 if setstr(temp1(count+index))=='c'
                    stop=index-1;
                 elseif setstr(temp1(count+index+1))=='c'
                    stop=index;
                 elseif setstr(temp1(count+index+2))=='c'
                    stop=index+1;
                 else
                    temp3(index-3)=setstr(temp1(count+index));
                    stop=index-1;
                 end
              end
              pointer=count;
           end
        end
     end
  end %end %2
  fclose(fid1);
lastloc=find(header==101);
fid2=fopen([Path FileName,'_',num2str(in),'.h'],'w');
fwrite(fid2,junk(1:pointer+3));
fwrite(fid2,num2str(y),'char');
fwrite(fid2,junk(pointer+stop:length(junk)));
fclose(fid2);

fid3=fopen([Path FileName,'_',num2str(in)],'w','b');
fwrite(fid3,header(1:lastloc+1),'int8');
Data=Data';
for count=1:y
   fwrite(fid3,Data(count,:),'int16');
end
fclose(fid3);

in=in+1;
waitbar(in/100,h)
end % end %2

end % end while
close(h)
else
   warndlg('This is not an appropriate zeng datafile. PROGRAM ABORTED. What are you some sort of Fellow? At this point, you may want to call an Engineer. However, you hopefully will not be able to find the original writer of this source code. Good luck. You may also want to ask yourself if this is really a project you want to be working on.')
end

