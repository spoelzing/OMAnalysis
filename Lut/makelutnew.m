% a=[5280;2080;2080];
a=[2500;2080;2080];
count=0;
for row=1:50
   for col=1:50
      b(count+1,:)=[col row 2 2 count];
      count=count+1;
   end
end

[file path]=uiputfile('c:\matlabr11\work\*.*','LUT placement');
% fid=fopen([path file],'w');
% fwrite(fid,a);

dlmwrite([path file],a,'\t');
% for i=1:5280
   dlmwrite([path file],b,'-append','delimiter','\t');
% end
% fclose(fid)