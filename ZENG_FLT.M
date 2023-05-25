function [Dataf]=Zeng_FltLP_Return(Z,X1X2,LP)
global Data

[N D]=butter(4,LP/500,'low');
if 0
   Dataf=filter(N,D,Data{Z}(:,[X1X2(1):X1X2(2)])')';
else
   Dataf=filtfilt(N,D,Data{Z}(:,[X1X2(1):X1X2(2)])')';
end


