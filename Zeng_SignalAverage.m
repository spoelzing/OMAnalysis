% AUTHOR: STEVEN POELZING
% DATE LAST MODIFIED: 09/20/00
function [Label,Comment,Annote_Out]=Zeng_SignalAverage(Z,X1X2,ChLabel,Annote)
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

% load PDefaults
% 
% P1Default=PDefaults(1); COMMENTED OUT ON 10/25/2011 BY SP
% P2Default=PDefaults(2);
% P3Default=PDefaults(3);
% P4Default=PDefaults(4);
% P5Default=PDefaults(5);
% P6Default=PDefaults(6);
% P7Default=PDefaults(7);
% P8Default=100;

P1Default=1;
P2Default=1;
P3Default=120;
P4Default=10;
P5Default=120;
P6Default=-60;
P7Default=1320;
P8Default=1320;
PDefaults=[P1Default;P2Default;P3Default;P4Default;P5Default;P6Default;P7Default;P8Default];

global Log
global Data
global PARAMETERSTRING Parameter4 TPRATIO
global Fig
global Stripchart

Label='AVG';
Comment='Average Fiducials';
Annote_Out=[]; 
Fig.X1X2=X1X2;
SAProgram('Initial',Parameter1Description,Parameter2Description,Parameter3Description,Parameter4Description,Parameter5Description,Parameter6Description,Parameter7Description,Parameter8Description,PDefaults,ChLabel,X1X2,Annote);


Label=[];
Comment=[];
Annote_Out=[];


