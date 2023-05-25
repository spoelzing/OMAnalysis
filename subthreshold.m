%a=[0 0 0 0 0 0 0 0 0;
%   0 0 0 3 19 20 12 0 0;
%   0 0 6 15 26 25 13 0 0;
%   6 14 24 35 35 28 15 5 0;
%   0 11 22 20 23 15 0 0 0;
%   0 9 11 9 11 5 0 0 0;
%	0 0 0 0 0 0 0 0 0;
%	0 0 0 0 0 0 0 0 0;
%	0 0 0 0 0 0 0 0 0];
a=[0 8 14 14 12 8 8 0 0;
   0 18 30 25 23 21 12 9 0;
   4 17 46 46 48 45 20 10 0;
   13 33 52 42 48 60 24 11 0;
   12 32 59 65 65 48 17 6 0;
   0 29 47 57 48 23 15 8 0;
   0 19 34 49 35 24 8 8 0;
   6 9 23 25 17 17 9 5 0;
   0 11 16 8 7 4 6 0 0];

a1=a;
a1(:,1:4)=0;
%a1(11,4)=1.5;
%for row=1:16
%for col=1:16
%   if a(row,col)<6
%		anew(row,col)=0;
%	else
%		anew(row,col)=a(row,col)-6;
%end
%end
%end
%anew(10,4)=.7;
anew=a1;
aflipped=flipud(anew);
%aflipped=rot90(aflipped);
%aflipped=rot90(aflipped);
%aflipped=rot90(aflipped);
%aflipped=conv2(aflipped,1/3*ones(1,3),'same');
figure(16)
%imagesc(a1)
contourf(flipud(a))
colorbar
