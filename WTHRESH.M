function y = wthresh(x,sorh,t)
%WTHRESH Perform soft or hard thresholding. 
%       Y = WTHRESH(X,SORH,T) returns soft (if SORH = 's')
%       or hard (if SORH = 'h') T-thresholding  of the input 
%       vector or matrix X. T is the threshold value.
%
%       Y = WTHRESH(X,'s',T) returns Y = SIGN(X).(|X|-T)+, soft 
%       thresholding is shrinkage.
%
%       Y = WTHRESH(X,'h',T) returns Y = X.1_(|X|>T), hard
%       thresholding is a crude one.
%
%       See also WDEN, WDENCMP, WPDENCMP.

%       M. Misiti, Y. Misiti, G. Oppenheim, J.M. Poggi 12-Mar-96.
%	Last Revision: 01-Oct-97.
%       Copyright (c) 1995-98 by The MathWorks, Inc.
% $Revision: 1.3 $

% Check arguments.
if errargn(mfilename,nargin,[3],nargout,[0:1]), error('*'), end

if sorh=='s'        
        tmp = (abs(x)-t); tmp = (tmp+abs(tmp))/2;
        y   = sign(x).*tmp;
elseif sorh=='h'    
        y   = x.*(abs(x)>t); 
else    
        errargt(mfilename,'invalid argument value','msg'), error('*')
end
