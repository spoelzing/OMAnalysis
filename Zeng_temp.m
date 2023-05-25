% AUTHOR: Your name here
% DATE LAST MODIFIED: 00/00/00
% This is a Skeleton program for use with Zeng's Analysis program. 
% You will enter your own description here.


% The first line in the program is the function that is going to be called.
% The left hand arguments between the [ ] are what Zeng's program expects to be returned
% The right hand arguments between the ( ) are what Zeng's program sends to the SKELETON
%    function
function [Label,Comment,Annote_Out]=SKELETON(Z,X1X2,ChLabel,Annote)
%The function name is SKELETON, and the filename is SKELETON.M



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  OUTPUTS	OUTPUTS	OUTPUTS	OUTPUTS	OUTPUTS	OUTPUTS %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% LABEL: Zeng's program expects a label back after the program is executed.
%        The label must be a 1x3 character array. Only one label can be returned per 
%          function
Label='SKE';
% In this case, the program returns the label "SKE"



% COMMENT: Zeng's program expects a Comment back after the program is executed.
% 			  The comment must be a 1x(any size) character array. This is the comment 
%				 that is viewed in Zeng's Annotation window.
Comment='SKELETON PROGRAM';
% In this case, the program will return the comment "SKELETON PROGRAM"



% ANNOTE_OUT: Zeng's program expects a variable called Annote_out which contains:
%					a channel number in the first column
%					a time in msec in the second column
%					a label in the third column
%				  
%				  Since the label is a character array, the entire output Annote_Out
%					is by default a character array. Zeng's stripchart program decodes
%					Annote_Out and parses it into valid numerical and character arrays.
Annote_Out=[];
% In this case, the program returns an empty set in Annote_Out which means that 
%	no information was generated


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS	INPUTS	INPUTS	INPUTS	INPUTS	INPUTS	INPUTS %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Z: Data is a structured array. If only one Data file is open, then
%    Z is one. If there are two Data files open, then Z can be 1 or 2 etc.

% X1X2: Zeng's program sends the start time and stop time of the window in msec. 
%					X1X2(1) is the start time
%					X1X2(2) is the stop time
% IMPORTANT. Remeber, that after you have determined a time to return in Annote out
% 					to add X1X2(1) to the column 2 of Annote_Out
% This can be done with the following line of code inserted at the end of the function.
%
%		Annote_Out(:,2)=Annote_Out(:,2)+X1X2(1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START OF PROGRAM 	START OF PROGRAM	START OF PROGRAM %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zeng's program does not send the raw data to these functions. The variable Data
%    is a global variable which can be seen by all programs if they have the following
%	  statement directly beneath the function call.
global Data
global Fig
% In order to use the data, you must have this line in your code.

NewData=Data{Z};
% NEVER change the contents of the variable Data since Zeng's program relies on its
%	never changing integrity to function.
% NewData is ROW oriented. Each channel is a single row. In order to extract
%	the fourth channel for example you would use the code:
imagesc(reshape(NewData(:,1),44,30))
FOURTHCHANNEL=NewData(4,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   GRAPHICAL USER INTERFACE SPECIFICATIONS   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Annote_Out(:,2)=Annote_Out(:,2)+X1X2(1);
Annote_Out=[Annote;Annote_Out];
