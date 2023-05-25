% AUTHOR: STEVEN POELZING
% DATE LAST MODIFIED: 09/20/00
function [Label,Comment,Annote_Out]=SignalAverage(Z,X1X2,ChLabel,Annote)
%-----------------------------


% ENTER DESCRIPTION FOR PARAMTERS
Parameter1Description=('Length of the boxcar filter (Positive Odd Numbers)');
Parameter2Description=('Number of consecutive sample points defining a peak (Positive Numbers)(Sample Points)');
Parameter3Description=('Blockout interval after detection of peak (Positive Numbers)(msec)');
Parameter4Description=('Peak amplitude and direction multplier factor (-5 to 5)');
Parameter5Description=('Averaging window duration (percent of cycle length)');
Parameter6Description=('Averaging window shift (msec)');
Parameter7Description=('');
Parameter8Description=('Channel to use for global fiducial point (Channel Number) ');

% ENTER PARAMETER DEFAULTS
P1Default=3;
P2Default=5;
P3Default=200;
P4Default=-1.1;
P5Default=100;
P6Default=-40;
P7Default=0;
P8Default=0;


PDefaults=[P1Default;P2Default;P3Default;P4Default;P5Default;P6Default;P7Default;P8Default];

global Log
global Data
global PARAMETERSTRING Parameter4 TPRATIO
global Fig
global Stripchart
if exist('Fig') 
   if isfield(Fig,'Figure')
   if ishandle(Fig.Figure)
      close(Fig.Figure)
   end
   end
end
clear Fig
Label='AVG';
Comment='Average Fiducials';
Annote_Out=[]; 
Fig.X1X2=X1X2;
Alternans('Initial',Parameter1Description,Parameter2Description,Parameter3Description,Parameter4Description,Parameter5Description,Parameter6Description,Parameter7Description,Parameter8Description,PDefaults,ChLabel,X1X2,Annote,Z);


Label=[];
Comment=[];
Annote_Out=[];


