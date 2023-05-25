

disp('Set to 3 pixels around point')
disp(' ')
disp(' ')
channel1=271;
channel2=249;
channel3=1020;
channel4=1130;
% channel1=input('RVB?');
% channel2=input('LVB?');
% channel3=input('RVA?');
% channel4=input('LVA?');
offset=input('Offset? ');
Side=1;
load junk
row=ceil(channel1/44)
col=mod(channel1,44)
RVB=mean(mean(bsteve(row-2:row+2,col-2:col+2)));
row=ceil(channel2/44);
col=mod(channel2,44);
LVB=mean(mean(bsteve(row-2:row+2,col-2:col+2)));
row=ceil(channel3/44);
col=mod(channel3,44);
RVA=mean(mean(bsteve(row-2:row+2,col-2:col+2)));
row=ceil(channel4/44)
col=mod(channel4,44)
LVA=mean(mean(bsteve(row-2:row+2,col-2:col+2)));

[RVB LVB RVA LVA]'-offset