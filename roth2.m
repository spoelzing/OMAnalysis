clear all
close all
%[Filename1, Pathname1] = uigetfile([Pathname1 '\*.dat'], 'Open Time');
[Filename, Pathname] = uigetfile([Pathname,'\*.dat'], 'Open Data');
a=dlmread([Pathname Filename])';
b=reshape(a,101,101);
%imagesc(b)
b(50,50)=0;
pixelsize=1;
sz=floor(pixelsize/2);
row=1;
for x=4:pixelsize:(101-floor(pixelsize/2))
col=1;
for y=4:pixelsize:(101-floor(pixelsize/2))
   [x,y];

      image2(row,col)=mean(mean(b(x-sz:x+sz,y-sz:y+sz)));
      col=col+1;
   end
   row=row+1;
end
figure(1)
imagesc(image2)
figure(2)
aa=round(101/pixelsize/2);
disc=image2(aa,aa:end)';
disc=disc/max(disc)
plot(disc)
full=b(50,51:end)';
full=full/max(full);

fullvalues=full(1+floor(pixelsize/2):pixelsize:end);
SSE=sum((disc-fullvalues).^2);
Rsquared=(1-SSE).^2