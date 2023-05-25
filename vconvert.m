%This program was written by Sharon George on 08/01/2014 to be able to read
%files from the Utah (Micam), Ultima and the Redshirt cameras.



function [] = vconvert(Newpath,Path,fname,binning,corv,camera);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Utah camera file conversion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(camera,'Utah')==1 
    
%%%%%%%%%%%%%%%%%%%%%%%%
% READ THE HEADER FILE %
%%%%%%%%%%%%%%%%%%%%%%%%
ratio=2;
% cd(path)
% [Filename Path]=uigetfile('C:\Prog\*.gsh','Load Micam File');
Filename = horzcat(Path,fname);
fid = fopen([Filename]);
fileloc=fgets(fid);
% Acdate=fgets(fid);
Datasize=fgets(fid);
temp=find(Datasize=='(');
temp1=find(Datasize==',');
temp2=find(Datasize==')');
xdim1=str2num(Datasize(temp(1)+1:temp1(1)-1));
ydim1=str2num(Datasize(temp1(1)+1:temp2(1)-1));
Samples=fgets(fid);
temp=find(Samples=='=');
frames=str2num(Samples(temp(1)+1:end))+1;
srate=fgets(fid);
temp=find(srate=='=');
temp1=find(srate=='c');
srate=str2num(srate(temp(1)+1:temp1(1)-5))*1000;
Averaging=fgets(fid);
Comments=fgets(fid);
temp=find(Comments==':');
Comments=Comments(temp(1)+2:end);
fclose(fid);
temp=find(Filename=='.');
Filename=[Filename(1:temp(1)),'gsd'];



%%%%%%%%%%%%%%%%%%%%%%%%
% READ THE GSD FILE    %
%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen([Filename]);
n=xdim1*ydim1;
headercrap = fread(fid,972);
dsize = ydim1*xdim1*frames;
bulkdata = fread(fid,dsize,'int16');
Data=reshape(bulkdata,n,frames);
frdata = reshape(bulkdata,xdim1,ydim1,frames);
breakthefile=1;
broken=0;
onward=1;
frdataoriginal=frdata;
oframes=frames;

while breakthefile==1 & onward==1;
%     if broken>0;
%         frdata=frdataoriginal;
%     end
%     
if oframes>6000 & onward==1;
    if broken+1:broken+5000<frames;
        frdata=frdataoriginal(:,:,broken*5000+1:broken*5000+5000);
        frames=5000;
    else
        clear frdata fbdata
        frdata=frdataoriginal(:,:,broken*5000+1:end);  
        [x,y,frames]=size(frdata);
        onward=0;
    end
    breakthefile==1;
    broken=broken+1;
    changefilename=1;
else
    breakthefile==0;
    changefilename=0;
    onward=0;
end

if binning>1    
for col=1:ydim1/binning 
    for row=1:xdim1/binning
        rngr1=binning*(row-1)+1;
        rngr2=binning*(row-1)+binning;
        rngc1=binning*(col-1)+1;
        rngc2=binning*(col-1)+binning;
        if corv==2
            if fname(end-4)=='A'
                tmp=squeeze(sum(sum(frdata(rngr1:rngr2,rngc1:rngc2,:)))/binning^2);
%                 tmp(2:end)=tmp(2:end)-tmp(1);
                tmp(2:end)=tmp(2:end);
                fbdata(row,col,:)=tmp;
                fbdata(row,col,1)=0;
                if row==6 & 1==6
                    figure(3)
                    plot(tmp-max(tmp(2:end)))
                end
                
            else
                tmp=sum(sum(frdata(rngr1:rngr2,rngc1:rngc2,:)))/binning^2;
%                 fbdata(row,col,:)=tmp-min(tmp(2:end))+1;
                fbdata(row,col,:)=tmp;
                fbdata(row,col,1)=1;
            end
        else
            fbdata(row,col,:)=sum(sum(frdata(rngr1:rngr2,rngc1:rngc2,:)))/binning^2;
            fbdata(row,col,:)=sum(sum(frdata(rngr1:rngr2,rngc1:rngc2,:)))/binning^2+frdata(row,col,1);
            fbdata(row,col,1)=fbdata(row,col,2);
        end
    end
end
else
    fbdata=frdata;
    jump=(squeeze(fbdata(:,:,2)-fbdata(:,:,1)));
    mjump=mean(mean(jump));
    sjump=std(std(jump));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Voltage or Calcium. Calcium has a mirror shift      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[xdim, ydim, frames]=size(fbdata);

% if corv==1
%     for count=1:xdim
% %         count
%         fbdatatemp(count,:,:)=fbdata(xdim+1-count,:,:);
%     end
%     fbdata=fbdatatemp;
% end

% imagesc(fbdata(:,:,1))
% pause

exchdata = fread(fid,inf,'int16');
csize = size(exchdata);
chsize = csize(1)/4;
Data=reshape(fbdata,[xdim*ydim],frames);
n=xdim*ydim;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To Read The Extra Channels %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

exchan1 = exchdata(1:chsize);
exchan2 = exchdata((chsize+1):(2*chsize));
exchan3 = exchdata((2*chsize+1):(3*chsize));
exchan4 = exchdata((3*chsize+1):(4*chsize));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TO RESAMPLE THE EXTRA CHANNELS AT A LOWER FREQUENCY %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rat = round(chsize/frames);
counter2 = 1;
for counter = 1:rat:chsize
    echan1(counter2) = exchan1(counter);
    echan2(counter2) = exchan2(counter);
    echan3(counter2) = exchan3(counter);
    echan4(counter2) = exchan4(counter);
    counter2 = counter2 + 1;
end
if length(echan1)> frames
    echan1 = echan1(1:frames);
    echan2 = echan2(1:frames);
    echan3 = echan3(1:frames);
    echan4 = echan4(1:frames);
elseif length(echan1)< frames
    echan1(frames) = exchan1(chsize);
    echan2(frames) = exchan2(chsize);
    echan3(frames) = exchan3(chsize);
    echan4(frames) = exchan4(chsize);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SAVE HEADER FILE                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Filename = horzcat(Newpath,fname);
temp=find(Filename=='.');
if changefilename==1;
    Filenameh=[Filename(1:temp-2),'_',num2str(broken),Filename(temp-1:temp),'h'];
else
    Filenameh=[Filename(1:temp),'h'];
end
fid1=fopen(Filenameh,'w');
fprintf(fid1,['subject ',Comments]);
fprintf(fid1,'preparation unknown\n');
fprintf(fid1,'data 00/00/00 00:00 PM\n');
fprintf(fid1,'gain 0\n');
fprintf(fid1,'srate %i\n',srate);
fprintf(fid1,'samples %i\n',frames);
fprintf(fid1,'chans %i\n',n+4);
fprintf(fid1,['comment ',Comments]);
if binning==1
    fprintf(fid1,'lut /usr/local/lut/micam\n');
elseif binning==2
    fprintf(fid1,'lut /usr/local/lut/micam44x30\n');
elseif binning==4
    fprintf(fid1,'lut /usr/local/lut/micam22x15\n');
end    
fprintf(fid1,'fhigh 0\n');
fprintf(fid1,'user Steven Poelzing\n');
fprintf(fid1,'mag 0\n');
fprintf(fid1,'temp 0\n');
fprintf(fid1,'pressure 0\n');
fprintf(fid1,'flow 0\n');
fprintf(fid1,'stimulator SS\n');
fprintf(fid1,'timeing 00ms\n');
fprintf(fid1,'strength 0ms,0mA\n');
fclose(fid1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         SAVE DATA FILE                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if changefilename==1;
    Filenamef=[Filename(1:temp-2),'_',num2str(broken),Filename(temp-1:temp)];
else
    Filenamef=[Filename(1:temp)];
end
% Filename=[Filename(1:temp)];
% mesg=(['Processing ',Filenamef]);
% disp(mesg)
fid3=fopen(Filenamef,'w','b');
% The lines below have been causing errors with Zeng_Log. They have been
% removed on 10/26/2011 by SP. 
% fprintf(fid3,'COLUMN BINARY FILE\n');
% fprintf(fid3,'2t260c0c0e\n');
Data=Data';
Dataw = [Data,echan1',echan2',echan3',echan4'];
for count=1:frames
   fwrite(fid3,Dataw(count,:),'int16');
end
fclose(fid3);
end
fclose(fid);

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Ultima Camera file conversion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




if strcmp(camera,'Ultima')==1
%%%%%%%%%%%%%%%%%%%%%%%%
% READ THE HEADER FILE %
%%%%%%%%%%%%%%%%%%%%%%%%
% for f=1:size(fname,2)
%     namecomp=fname{1,f};
%     if strcmp(namecomp(end),'h')==1
%         hname=namecomp;
%     else
%         fname1{1,f}=namecomp;
%     end
% end
% fname=fname1;
hname=fname;
fid=fopen(fullfile(Path,hname),'r');
line=fgetl(fid);
line=fgetl(fid);
temp=find(line=='/');
xdim=str2num(line(temp(1,3)-3:temp(1,3)-1));    %x-dimension of data array
xdim1=xdim-28;
ydim1=str2num(line(temp(1,4)-3:temp(1,4)-1));    %y-dimension of data array
frpfile=str2num(line(end-2:end));               %Number of frames per file

line=fgetl(fid);
line=fgetl(fid);
temp=find(line=='=');
datetime=line(temp+1:end);

line=fgetl(fid);
temp=find(line=='=');
frames=str2num(line(temp+1:end));              %Total number of frames

line=fgetl(fid);
line=fgetl(fid);
temp=find(line=='=');
stime=line(temp+3:end-4);
srate=1/(str2num(stime)*10^-3);

line=fgetl(fid);
line=fgetl(fid);
line=fgetl(fid);
temp=find(line=='=');
gain=line(temp+1:end);% gain_mode=0

temp=find(hname=='.');
if hname(temp-1)=='A'||hname(temp-1)=='B'
    lines=19;
elseif hname(temp-1)~='A'||hname(temp-1)~='B'
    lines=20;
end
for tempcount=1:1:lines
    line=fgetl(fid);
end

temp=find(line=='=');
Comments=line(temp+1:end);

fclose(fid);




%%%%%%%%%%%%%%%%%%%%%%%%
% READ THE GSD FILE    %
%%%%%%%%%%%%%%%%%%%%%%%%
% fid = fopen([Filename]);
n=xdim1*ydim1;
ecg4=[];
file=[];
fname={};
fname1d={};
fname2d={};


fname1=dir(Path(1,1:end-1));
count=size(fname1,1);
fname1d={};
fname2d={};

for i=1:count
line=getfield(fname1(i,1),'name');
line=char(line);

ext='.rsd';

if length(line)>3 
    temp=(find(line=='('))-1;
    temp1=length(line)-3;
    
    if strcmp(line(1,temp1:end),ext)==1 
        temp2=find(line==')');
        digits=line(temp+2:temp2-1);
        
        if line(1:temp)==hname(1:end-4)
            if size(digits)==1
              fname1d=[fname1d line(1,1:end)];
            else
                fname2d=[fname2d line(1,1:end)];
            end
        end
    end
end
end
fname=[fname1d fname2d];
% htemp=find(hname,'.')
% i=1;
% fname1=[Path hname(htemp-1),'(i)'];
% while exist fname1
% i=i+1;
% fname=[fname fname1];
% end


for f=1:size(fname,2)
fid1=fopen(fullfile(Path,fname{1,f}),'r');
a=fread(fid1,'int16');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To Read The Extra Channels %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
count1=1;
count2=13;

while count2<=3276800
    ecg(1,count1)=a(count2,1);
    count1=count1+1;
    count2=count2+12800;    %SR=1/20th of recording SR.
end
ecg4=vertcat(ecg4,ecg');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To Read The Image %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

b=zeros(128,25600);

for n=1:1:25599
    for m=1:128
        b(m,n)=a((n*128+m),1);
    end
end
output=zeros(100,100,256);

i=0;


for k=1:256

       
        for j=1:100
            output(:,j,k)=b(20:119,i+j);
                   
        end
        
        
       
   i=i+100;
  
end

file=cat(3,[file],[output]);

end


frdata(:,:,:)=file(:,:,:);
% frdata=flipdim(frdata,1);
breakthefile=1;
broken=0;
onward=1;
frdataoriginal=frdata;
oframes=frames;


while breakthefile==1 & onward==1;
%     if broken>0;
%         frdata=frdataoriginal;
%     end
%     
if oframes>6000 & onward==1;
    if broken+1:broken+5000<frames;
        frdata=frdataoriginal(:,:,broken*5000+1:broken*5000+5000);
        ecg5=ecg4(broken*5000+1:broken*5000+5000,1);
        frames=5000;
    else
        clear frdata fbdata
        frdata=frdataoriginal(:,:,broken*5000+1:end); 
        ecg5=ecg4(broken*5000+1:end,1);
        [x,y,frames]=size(frdata);
        onward=0;
    end
    breakthefile==1;
    broken=broken+1;
    changefilename=1;
else
    breakthefile==0;
    changefilename=0;
    onward=0;
    ecg5=ecg4;
end

if binning>1
    for col=1:ydim1/binning 
        for row=1:xdim1/binning
            rngr1=binning*(row-1)+1;
            rngr2=binning*(row-1)+binning;
            rngc1=binning*(col-1)+1;
            rngc2=binning*(col-1)+binning;
            if corv==2
                if fname{end-4}=='A' | fname{end-4}=='B'  % for dual mapping
                    tmp=squeeze(sum(sum(frdata(rngr1:rngr2,rngc1:rngc2,:)))/binning^2);
%                   tmp(2:end)=tmp(2:end)-tmp(1);
                    tmp(2:end)=tmp(2:end);
                    fbdata(row,col,:)=tmp;
                    fbdata(row,col,1)=0;
                    
                    if row==6 & 1==6
                        figure(3)
                        plot(tmp-max(tmp(2:end)))
                    end
                
                else
                    tmp=sum(sum(frdata(rngr1:rngr2,rngc1:rngc2,:)))/binning^2;
%                   fbdata(row,col,:)=tmp-min(tmp(2:end))+1;
                    fbdata(row,col,:)=tmp;
                    fbdata(row,col,1)=1;
                   
                end
            else
                fbdata(row,col,:)=sum(sum(frdata(rngr1:rngr2,rngc1:rngc2,:)))/binning^2;
                fbdata(row,col,:)=sum(sum(frdata(rngr1:rngr2,rngc1:rngc2,:)))/binning^2+frdata(row,col,1);
                fbdata(row,col,1)=fbdata(row,col,2);
            end
        end
    end
else
    fbdata=frdata;
    jump=(squeeze(fbdata(:,:,2)-fbdata(:,:,1)));
    mjump=mean(mean(jump));
    sjump=std(std(jump));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Voltage or Calcium. Calcium has a mirror shift      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[xdim, ydim, frames]=size(fbdata);

% if corv==1
%     for count=1:xdim
% 
%         fbdatatemp(count,:,:)=fbdata(xdim+1-count,:,:);
%     end
%     fbdata=fbdatatemp;
% end

% imagesc(fbdata(:,:,1))
% pause


% csize = size(exchdata);
% chsize = csize(1)/4;
Data=reshape(fbdata,[xdim*ydim],frames);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         SAVE DATA FILE                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Filename = horzcat(Newpath,hname);
temp=find(Filename=='.');
if changefilename==1;
    Filenamef=[Filename(1:temp-1),'_',num2str(broken),Filename(temp)];
else
    Filenamef=[Filename(1:temp-1)];
end
% Filename=[Filename(1:temp)];
% mesg=(['Processing ',Filenamef]);
% disp(mesg)
fid3=fopen(Filenamef,'w','b');
% The lines below have been causing errors with Zeng_Log. They have been
% removed on 10/26/2011 by SP. 
% fprintf(fid3,'COLUMN BINARY FILE\n');
% fprintf(fid3,'2t260c0c0e\n');

Data=Data';

% Dataw = [Data,echan1',echan2',echan3',echan4'];

Dataw=[Data,ecg5];

for count=1:frames
   fwrite(fid3,Dataw(count,:),'int16');
end
fclose(fid3);

n=size(Dataw,2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SAVE HEADER FILE                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if changefilename==1
    Filenameh=[Filename(1:temp-1),'_',num2str(broken),'.h'];
else
    Filenameh=[Filename(1:temp-1),'.h'];
end
fid2=fopen(Filenameh,'w');

fprintf(fid2,['subject ',Comments,'\n']);
fprintf(fid2,'preparation unknown\n');
fprintf(fid2,'date %s\n',datetime);
fprintf(fid2,'gain %s\n', gain);
fprintf(fid2,'srate %i\n',srate);
fprintf(fid2,'samples %i\n',frames);
fprintf(fid2,'chans %i\n',n);
fprintf(fid2,['comment ',Comments,'\n']);
if binning==1
    fprintf(fid2,'lut /usr/local/lut/Ultima\n');
elseif binning==2
    fprintf(fid2,'lut /usr/local/lut/Ultima50x50\n');
elseif binning==4
    fprintf(fid2,'lut /usr/local/lut/Ultima25x25\n');
end    
fprintf(fid2,'fhigh 0\n');
fprintf(fid2,'user Steven Poelzing\n');
fprintf(fid2,'mag 0\n');
fprintf(fid2,'temp 0\n');
fprintf(fid2,'pressure 0\n');
fprintf(fid2,'flow 0\n');
fprintf(fid2,'stimulator SS\n');
fprintf(fid2,'timeing 00ms\n');
fprintf(fid2,'strength 0ms,0mA\n');
fclose(fid2);


end
fclose(fid1);

end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%MiCam HS02-VT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmp(camera,'HS02')==1
    
%%%%%%%%%%%%%%%%%%%%%%%%
% READ THE HEADER FILE %
%%%%%%%%%%%%%%%%%%%%%%%%
ratio=2;
Filename = horzcat(Path,fname);
fid = fopen([Filename]);
fileloc=fgets(fid);
Acdate=fgets(fid);
Datasize=fgets(fid);
temp=find(Datasize=='(');
temp1=find(Datasize==',');
temp2=find(Datasize==')');
xdim1=str2num(Datasize(temp(1)+1:temp1(1)-1));
ydim1=str2num(Datasize(temp1(1)+1:temp2(1)-1));
Samples=fgets(fid);
temp=find(Samples=='=');
frames=str2num(Samples(temp(1)+1:end))+1;
srate=fgets(fid);
temp=find(srate=='=');
temp1=find(srate=='c');
srate=str2num(srate(temp(1)+1:temp1(1)-5))*1000;
Averaging=fgets(fid);
Comments=fgets(fid);
temp=find(Comments==':');
Comments=Comments(temp(1)+2:end);
fclose(fid);
temp=find(Filename=='.');
Filename=[Filename(1:temp(1)),'gsd'];



%%%%%%%%%%%%%%%%%%%%%%%%
% READ THE GSD FILE    %
%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen([Filename]);
n=xdim1*ydim1;
headercrap = fread(fid,972);
dsize = ydim1*xdim1*frames;
bulkdata = fread(fid,dsize,'int16');
Data=reshape(bulkdata,n,frames);
frdata = reshape(bulkdata,xdim1,ydim1,frames);
breakthefile=1;
broken=0;
onward=1;
frdataoriginal=frdata;
oframes=frames;

while breakthefile==1 & onward==1;
if oframes>6000 & onward==1;
    if broken+1:broken+5000<frames;
        frdata=frdataoriginal(:,:,broken*5000+1:broken*5000+5000);
        frames=5000;
    else
        clear frdata fbdata
        frdata=frdataoriginal(:,:,broken*5000+1:end);  
        [x,y,frames]=size(frdata);
        onward=0;
    end
    breakthefile==1;
    broken=broken+1;
    changefilename=1;
else
    breakthefile==0;
    changefilename=0;
    onward=0;
end

if binning>1    
for col=1:ydim1/binning 
    for row=1:xdim1/binning
        rngr1=binning*(row-1)+1;
        rngr2=binning*(row-1)+binning;
        rngc1=binning*(col-1)+1;
        rngc2=binning*(col-1)+binning;
        if corv==2
            if fname(end-4)=='A'
                tmp=squeeze(sum(sum(frdata(rngr1:rngr2,rngc1:rngc2,:)))/binning^2);
                tmp(2:end)=tmp(2:end);
                fbdata(row,col,:)=tmp;
                fbdata(row,col,1)=0;
                if row==6 & 1==6
                    figure(3)
                    plot(tmp-max(tmp(2:end)))
                end
                
            else
                tmp=sum(sum(frdata(rngr1:rngr2,rngc1:rngc2,:)))/binning^2;
                fbdata(row,col,:)=tmp;
                fbdata(row,col,1)=1;
            end
        else
            fbdata(row,col,:)=sum(sum(frdata(rngr1:rngr2,rngc1:rngc2,:)))/binning^2;
            fbdata(row,col,:)=sum(sum(frdata(rngr1:rngr2,rngc1:rngc2,:)))/binning^2+frdata(row,col,1);
            fbdata(row,col,1)=fbdata(row,col,2);
        end
    end
end
else
    fbdata=frdata;
    jump=(squeeze(fbdata(:,:,2)-fbdata(:,:,1)));
    mjump=mean(mean(jump));
    sjump=std(std(jump));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Troubleshooting                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[xdim, ydim, frames]=size(fbdata);

% if corv==1
%     for count=1:xdim
% %         count
%         fbdatatemp(count,:,:)=fbdata(xdim+1-count,:,:);
%     end
%     fbdata=fbdatatemp;
% end

% imagesc(fbdata(:,:,1))
% pause

exchdata = fread(fid,inf,'int16');
csize = size(exchdata);
chsize = csize(1)/4;
Data=reshape(fbdata,[xdim*ydim],frames);
n=xdim*ydim;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To Read The Extra Channels %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

exchan1 = exchdata(1:chsize);
exchan2 = exchdata((chsize+1):(2*chsize));
exchan3 = exchdata((2*chsize+1):(3*chsize));
exchan4 = exchdata((3*chsize+1):(4*chsize));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TO RESAMPLE THE EXTRA CHANNELS AT A LOWER FREQUENCY %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rat = round(chsize/frames);
counter2 = 1;
for counter = 1:rat:chsize
    echan1(counter2) = exchan1(counter);
    echan2(counter2) = exchan2(counter);
    echan3(counter2) = exchan3(counter);
    echan4(counter2) = exchan4(counter);
    counter2 = counter2 + 1;
end
if length(echan1)> frames
    echan1 = echan1(1:frames);
    echan2 = echan2(1:frames);
    echan3 = echan3(1:frames);
    echan4 = echan4(1:frames);
elseif length(echan1)< frames
    echan1(frames) = exchan1(chsize);
    echan2(frames) = exchan2(chsize);
    echan3(frames) = exchan3(chsize);
    echan4(frames) = exchan4(chsize);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SAVE HEADER FILE                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Filename = horzcat(Newpath,fname);
temp=find(Filename=='.');
if changefilename==1;
    Filenameh=[Filename(1:temp-2),'_',num2str(broken),Filename(temp-1:temp),'h'];
else
    Filenameh=[Filename(1:temp),'h'];
end
fid1=fopen(Filenameh,'w');
fprintf(fid1,['subject ',Comments]);
fprintf(fid1,'preparation unknown\n');
fprintf(fid1,'data 00/00/00 00:00 PM\n');
fprintf(fid1,'gain 0\n');
fprintf(fid1,'srate %i\n',srate);
fprintf(fid1,'samples %i\n',frames);
fprintf(fid1,'chans %i\n',n+4);
fprintf(fid1,['comment ',Comments]);
if binning==1
    fprintf(fid1,'lut /usr/local/lut/Cmicam\n');
elseif binning==2
    fprintf(fid1,'lut /usr/local/lut/Cmicam46x40\n');
elseif binning==4
    fprintf(fid1,'lut /usr/local/lut/Cmicam23x20\n');
end    
fprintf(fid1,'fhigh 0\n');
fprintf(fid1,'user Steven Poelzing\n');
fprintf(fid1,'mag 0\n');
fprintf(fid1,'temp 0\n');
fprintf(fid1,'pressure 0\n');
fprintf(fid1,'flow 0\n');
fprintf(fid1,'stimulator SS\n');
fprintf(fid1,'timeing 00ms\n');
fprintf(fid1,'strength 0ms,0mA\n');
fclose(fid1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         SAVE DATA FILE                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if changefilename==1;
    Filenamef=[Filename(1:temp-2),'_',num2str(broken),Filename(temp-1:temp)];
else
    Filenamef=[Filename(1:temp)];
end
% Filename=[Filename(1:temp)];
% mesg=(['Processing ',Filenamef]);
% disp(mesg)
fid3=fopen(Filenamef,'w','b');
% The lines below have been causing errors with Zeng_Log. They have been
% removed on 10/26/2011 by SP. 
% fprintf(fid3,'COLUMN BINARY FILE\n');
% fprintf(fid3,'2t260c0c0e\n');
Data=Data';
Dataw = [Data,echan1',echan2',echan3',echan4'];
for count=1:frames
   fwrite(fid3,Dataw(count,:),'int16');
end
fclose(fid3);
end
fclose(fid);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Redshirt Camera File conversion
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


if strcmp(camera,'Redshirt')==1
                     
%%%%%%%%%%%%%%%%%%%%%%%%
% READ THE HEADER FILE %
%%%%%%%%%%%%%%%%%%%%%%%%

fid=fopen(fullfile(Path,fname),'r');
A=fread(fid,'int16');
xdim=A(386,1);
ydim=A(385,1);
frames=A(5,1);
Comments=[];
datetime=[];
gain=[];
stime=A(389,1)/1000;
srate=1000/stime;
n=xdim*ydim;
acqratio=A(392,1);
ecgframes=acqratio*frames;



%%%%%%%%%%%%%%%%%%%%%%%%
% READ THE DATA     %
%%%%%%%%%%%%%%%%%%%%%%%%

f=2560;
for j=1:ydim
    for i=1:xdim
        for k=1:frames
            Data(i,j,k)=A(f,1);
            f=f+1;
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%
% READ THE ECG CHANNEL     %
%%%%%%%%%%%%%%%%%%%%%%%%

ecg4=A(f:f+ecgframes-1);


frdata(:,:,:)=Data(:,:,:);
% frdata=flipdim(frdata,1);
breakthefile=1;
broken=0;
onward=1;
frdataoriginal=frdata;
oframes=frames;


while breakthefile==1 & onward==1;
%     if broken>0;
%         frdata=frdataoriginal;
%     end
%     
if oframes>6000 & onward==1;
    if broken+1:broken+5000<frames;
        frdata=frdataoriginal(:,:,broken*5000+1:broken*5000+5000);
        ecg5=ecg4(broken*5000+1:broken*5000+5000,1);
        frames=5000;
    else
        clear frdata fbdata
        frdata=frdataoriginal(:,:,broken*5000+1:end); 
        ecg5=ecg4(broken*5000+1:end,1);
        [x,y,frames]=size(frdata);
        onward=0;
    end
    breakthefile==1;
    broken=broken+1;
    changefilename=1;
else
    breakthefile==0;
    changefilename=0;
    onward=0;
    ecg5=ecg4;
end

if binning>1
    for col=1:ydim/binning 
        for row=1:xdim/binning
            rngr1=binning*(row-1)+1;
            rngr2=binning*(row-1)+binning;
            rngc1=binning*(col-1)+1;
            rngc2=binning*(col-1)+binning;
            if corv==2
                if fname(end-4)=='A'
                    tmp=squeeze(sum(sum(frdata(rngr1:rngr2,rngc1:rngc2,:)))/binning^2);
%                   tmp(2:end)=tmp(2:end)-tmp(1);
                    tmp(2:end)=tmp(2:end);
                    fbdata(row,col,:)=tmp;
                    fbdata(row,col,1)=0;
                    
                    if row==6 & 1==6
                        figure(3)
                        plot(tmp-max(tmp(2:end)))
                    end
                
                else
                    tmp=sum(sum(frdata(rngr1:rngr2,rngc1:rngc2,:)))/binning^2;
%                   fbdata(row,col,:)=tmp-min(tmp(2:end))+1;
                    fbdata(row,col,:)=tmp;
                    fbdata(row,col,1)=1;
                   
                end
            else
                fbdata(row,col,:)=sum(sum(frdata(rngr1:rngr2,rngc1:rngc2,:)))/binning^2;
                fbdata(row,col,:)=sum(sum(frdata(rngr1:rngr2,rngc1:rngc2,:)))/binning^2+frdata(row,col,1);
                fbdata(row,col,1)=fbdata(row,col,2);
            end
        end
    end
else
    fbdata=frdata;
    jump=(squeeze(fbdata(:,:,2)-fbdata(:,:,1)));
    mjump=mean(mean(jump));
    sjump=std(std(jump));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Voltage or Calcium. Calcium has a mirror shift      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[xdim, ydim, frames]=size(fbdata);

% if corv==1
%     for count=1:xdim
% 
%         fbdatatemp(count,:,:)=fbdata(xdim+1-count,:,:);
%     end
%     fbdata=fbdatatemp;
% end

% imagesc(fbdata(:,:,1))
% pause


% csize = size(exchdata);
% chsize = csize(1)/4;
Data=reshape(fbdata,[xdim*ydim],frames);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         SAVE DATA FILE                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Filename = horzcat(Newpath,fname);
temp=find(Filename=='.');
if changefilename==1;
    Filenamef=[Filename(1:temp-1),'_',num2str(broken),Filename(temp)];
else
    Filenamef=[Filename(1:temp-1)];
end
% Filename=[Filename(1:temp)];
% mesg=(['Processing ',Filenamef]);
% disp(mesg)
fid3=fopen(Filenamef,'w','b');
% The lines below have been causing errors with Zeng_Log. They have been
% removed on 10/26/2011 by SP. 
% fprintf(fid3,'COLUMN BINARY FILE\n');
% fprintf(fid3,'2t260c0c0e\n');

Data=Data';

% Dataw = [Data,echan1',echan2',echan3',echan4'];

Dataw=[Data,ecg5];
for count=1:frames
   fwrite(fid3,Dataw(count,:),'int16');
end
fclose(fid3);

n=size(Dataw,2);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SAVE HEADER FILE                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if changefilename==1
    Filenameh=[Filename(1:temp-1),'_',num2str(broken),'.h'];
else
    Filenameh=[Filename(1:temp-1),'.h'];
end
fid2=fopen(Filenameh,'w');

fprintf(fid2,['subject ',Comments,'\n']);
fprintf(fid2,'preparation unknown\n');
fprintf(fid2,'date %s\n',datetime);
fprintf(fid2,'gain %s\n', gain);
fprintf(fid2,'srate %i\n',srate);
fprintf(fid2,'samples %i\n',frames);
fprintf(fid2,'chans %i\n',n);
fprintf(fid2,['comment ',Comments,'\n']);
if binning==1
    fprintf(fid2,'lut /usr/local/lut/Redshirt\n');
elseif binning==2
    fprintf(fid2,'lut /usr/local/lut/Redshirt40x40\n');
elseif binning==4
    fprintf(fid2,'lut /usr/local/lut/Redshirt20x20\n');
end    
fprintf(fid2,'fhigh 0\n');
fprintf(fid2,'user Steven Poelzing\n');
fprintf(fid2,'mag 0\n');
fprintf(fid2,'temp 0\n');
fprintf(fid2,'pressure 0\n');
fprintf(fid2,'flow 0\n');
fprintf(fid2,'stimulator SS\n');
fprintf(fid2,'timeing 00ms\n');
fprintf(fid2,'strength 0ms,0mA\n');
fclose(fid2);


end


end
end
    