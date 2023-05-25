%Author: Steven Poelzing
% October 25, 2007

clear all
fclose all;
close all;
wpath = pwd;

cd(wpath)
load BackgroundValueA
load BackgroundValueB


mornm=input('Is this the 2 box or 4 box system? (Default is 4)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  READ THE DATA FROM FILES A AND B                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
b_or_s=1;
load directory
% directory
[jname path]=uigetfile([directory,'*.h'],'Select a Zeng Format file');
l=length(jname);
jnamenew=[jname(1:l-3),'r.h'];
[newfilename newpath]=uiputfile([path jnamenew],'Select location for ratio files');
if jname~=0 & newfilename~=0;
        cd(path) % Move to target directory
        cont = dir('*b.h');
        [fnum junk] = size(cont); % Determine number of files in target directory
        for count = 1:fnum
            keepgoing=0;
            fname = cont(count).name;
            l = length(fname);
            temps=dir([fname(1:l-3),'a.h']); % Camera A is 405nm
            temps1=size(temps);              % Camera B is 485 nm
            if temps1>0
                keepgoing=1;
                l2=length(temps.name);
                filenameB=fname(1:l-2)
                fidB=fopen(fname(1:l-2),'r','b');
                fidA=fopen(temps.name(1:l2-2),'r','b');
                fidBheader=fopen(fname,'r');
                for count=1:6
                    headerdata=fgetl(fidBheader);
                end
                locat=find(headerdata=='s');
                samples=str2num(headerdata(locat(2)+2:length(headerdata)));
                headerdata=fgetl(fidBheader);
                locat=find(headerdata=='s');
                chans=str2num(headerdata(locat+2:length(headerdata)));
                
%                 BackgroundValueA=BackgroundValueA(1:chans-4)/7;
%                 BackgroundValueB=BackgroundValueB(1:chans-4)/7;
                BackgroundValueA=BackgroundValueA(1:chans-4);
                BackgroundValueB=BackgroundValueB(1:chans-4);
                
%                 BVA=BackgroundValueA(425)
%                 BVB=BackgroundValueB(425)
%                 break

                
disp(['Working on ',fname(1:l-2)]);
                % FOR FIDB --- The 405 nm Signal
                junk=fgetl(fidB);
                junk=fgetl(fidB);
                data1=fread(fidB,'int16')';
                fdataB=reshape(data1,chans,samples);
                fdataB=fdataB(1:chans-4,:);
                fclose(fidB);
                % FOR FIDA --- The 480 nm Signal
                junk=fgetl(fidA);
                junk=fgetl(fidA);
                data2=fread(fidA,'int16')';
                fdataA=reshape(data2,chans,samples);
                exchans=fdataA(chans-3:chans,:);
                fdataA=fdataA(1:chans-4,:);
                fclose(fidA);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BACKGROUND SUBTRACTION                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Tempvs2=BackgroundValueB'*ones(1,samples);
% figure(2)
% imagesc(Tempvs2)
% Tempvs2(1:10,1)
fdb=fdataB;
fda=fdataA;

whos
figure(1)
                plot(fdataB(425,:))
                hold
                plot(fdataA(425,:))
                hold off

                fdataA=fdataA-BackgroundValueA'*ones(1,samples); % 405
                fdataB=fdataB-BackgroundValueB'*ones(1,samples); % 485
                fdata=(fdataA./fdataB);
figure(2)
                plot(fdataB(425,:))
                hold
                plot(fdataA(425,:))
                hold off
figure(3)
                plot(fdata(425,:))
break
                
[xx yy]=size(fdata);
% whos
if chans==1324
   step=44;
elseif chans==334
    step= 22;
end
for i=step-1:step:xx
    fdata(i,:)=-0.1*ones(1,yy);
    fdata(i+1,:)=-0.1*ones(1,yy);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CCD SKEW CORRECTION
% The basline ratiometric values apparently drift by 2 A/D units per pixel
% from right to left.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if mornm==4 | isempty(mornm)
    drift=.002;
    if chans==1324
        step=44;
    elseif chans==334
        step= 22;
    end
        
    for col=1:step:chans-4 %%%%%%%%% EDIT THIS ENTIRE THING APPROPRIATELY.
%     temp=drift*[1:44]'*ones(1,samples);
%     size(fdata(col:col+44,:))
        fdata(col:col+step-1,:)=fdata(col:col+step-1,:)+drift*[step-1:-1:0]'*ones(1,samples);
    end
else
    drift=.002;
    for col=1:step:chans-4
%     temp=drift*[1:44]'*ones(1,samples);
%     size(fdata(col:col+44,:))
        fdata(col:col+step-1,:)=fdata(col:col+step-1,:)-drift*[0:step-1]'*ones(1,samples);
    end
end

   

  if 1==2
      whos
                chan=638
                BVB=BackgroundValueB(chan)
                BVA=BackgroundValueA(chan)
                subplot(3,1,1)
                plot(fdb(chan,100:1000))
%                 plot(fdataB(chan,:),'r')
                hold
%                 plot(fdataA(chan,:),'g')
                plot(fdataA(chan,100:1000),'g')
                hold off
                subplot(3,1,2)
                plot(fdata(chan,100:1000))
%                 plot(fdata(chan,:))
                axis tight
                subplot(3,1,3)
                plot(fdataB(chan,100:1000),fdataA(chan,100:1000))
  end
              
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SAVE DATA IN R FILE                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if keepgoing==1
            fdata=round(fdata*1000);

fdata(chans-3:chans,:)=exchans;
% plot(exchans(1,:))
jnamenew=[temps.name(1:l2-3),'R.h'];
copyfile(temps.name,jnamenew)
fid3=fopen([temps.name(1:l2-3),'R'],'w','b');
fprintf(fid3,'COLUMN BINARY FILE\n');
fprintf(fid3,'2t260c0c0e\n');
Dataw=fdata';
[x,y]=size(Dataw);
h=waitbar(0,'Processing Data');
for count=1:x
   waitbar(count/y,h)
   fwrite(fid3,Dataw(count,:),'int16');
end
fclose(fid3);
close(h)

  
            
            
            
end
end % END of the keepgoing if loop

end

fclose all;
disp('About to change directory')
cd(wpath) % Return to working directory




if 1==2
ssound=['dark1.wav'];
   [Y,FS,BITS]=wavread(ssound);
   sound(Y,FS,BITS)
end



