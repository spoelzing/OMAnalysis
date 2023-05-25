function [Label,Comment,Annote_Out]=Zeng_Percent(Z,X1X2,ChLabel,Annote)


global Log
global Data
global PARAMETERSTRING Parameter4 TPRATIO
global Fig
global Stripchart
clear Fig
Parameter1Description=('Length of the boxcar filter (Positive Odd Numbers)');
Parameter2Description=('Number of consecutive sample points defining a peak (Positive Numbers)(Sample Points)');
Parameter3Description=('Blockout interval after detection of peak (Positive Numbers)(msec)');
Parameter4Description=('Peak amplitude and direction multplier factor (-5 to 5)');
Parameter5Description=('Window width around detected peaks for normalizing AP to 0% and 100% (Number of Samples)');
Parameter6Description=('Percent Repolarization (0% to 100%)');
Parameter7Description=(['Additional filtering for repolarization. Filter cutoff frequency.(0 to ',num2str(Log.Head.SRate/2),' Hz)']);

% ENTER PARAMETER DEFAULTS
P1Default=3;
P2Default=5;
P3Default=200;
P4Default=-1.1;
P5Default=80;
P6Default=85;
P7Default=Log.Head.SRate/2;
PDefaults=[P1Default;P2Default;P3Default;P4Default;P5Default;P6Default;P7Default];

Annote_Out=[]; 
Fig.X1X2=X1X2;
Zeng_Percent2('Initial',Parameter1Description,Parameter2Description,Parameter3Description,Parameter4Description,Parameter5Description,Parameter6Description,Parameter7Description,PDefaults,ChLabel,Fig.X1X2,Annote);

Label=[];
Comment=[];
Annote_Out=[];
