%This program was written by Sharon George on 08/01/2014 to be able to read
%files from the Utah (Micam), Ultima and the HS02 cameras.


function varargout = projectz3(varargin)
% projectz3 M-file for projectz3.fig
%      projectz3, by itself, creates a new projectz3 or raises the existing
%      singleton*.
%
%      H = projectz3 returns the handle to a new projectz3 or the handle to
%      the existing singleton*.
%
%      projectz3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in projectz3.M with the given input arguments.
%
%      projectz3('Property','Value',...) creates a new projectz3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before projectz3_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to projectz3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help projectz3

% Last Modified by GUIDE v2.5 07-Jan-2015 14:25:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @projectz3_OpeningFcn, ...
                   'gui_OutputFcn',  @projectz3_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);          
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% -------------------------------------------------------------------------
%************** OPENING FUNCTION **********************
function projectz3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user datafile_buttongroup (see GUIDATA)
% varargin   command line arguments to projectz3 (see VARARGIN)

% **************TESTER GLOBAL VARIABLES*************************

handles.processDataCompleted = 0;

set(handles.figure1,'CloseRequestFcn',@closeGUI);
% Choose default command line output for projectz3
handles.output = hObject;

global newpath
global pathname
global input_file


% Update handles structure
guidata(hObject, handles);

bs_exist=dir('batch_state.mat');
if ~isempty(bs_exist)
    load batch_state
    binning=batch_state{1};
    corv=batch_state{2};
    camera=batch_state{3};  %%%%%%%
   else
    binning=3;
    corv=2;
    camera=3;   %%%%%%
end

handles=get(gcf,'Children');
binhandle=get(handles(5),'Children');
if binning==1
    set(binhandle(1),'Value',1)
elseif binning==2
    set(binhandle(2),'Value',1)
elseif binning==3
    set(binhandle(3),'Value',1) 
end
cvhandle=get(handles(4),'Children');
if corv==1
    set(cvhandle(1),'Value',1)
elseif corv==2
    set(cvhandle(2),'Value',1)
end

%included to use the same program to batch Utah, Ultima, HS02,and HS02
%camera files
camhandle=get(handles(1),'Children');
if camera==1
    set(camhandle(1),'Value',1)
elseif camera==2
    set(camhandle(2),'Value',1)
elseif camera==3
    set(camhandle(3),'Value',1) 
end

% UIWAIT makes projectz3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% -------------------------------------------------------------------------


% -------------------------------------------------------------------------
function varargout = projectz3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user datafile_buttongroup (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
function inputFiles_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to inputFiles_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user datafile_buttongroup (see GUIDATA)

% Hints: contents = get(hObject,'String') returns inputFiles_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from inputFiles_listbox
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
function inputFiles_listbox_CreateFcn(hObject, eventdata, handles)
global newpath
global pathname
global input_file

% hObject    handle to inputFiles_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
function addFiles_pushbutton_Callback(hObject, eventdata, handles)
global newpath
global pathname
global input_file

% hObject    handle to addFiles_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user datafile_buttongroup (see GUIDATA)

%gets input file(s) from user. the sample datafile_buttongroup files have extension .gsh
bs_exist=dir('batch_state.mat');
if ~isempty(bs_exist)
    load batch_state
    
%IMPORTANT: Selection of camera type should be made before clicking on the
%Add File button in order that only the files of the corect type will
%appear in the selection window.
    
chandles=get(gcf,'Children');
camera=get(chandles(1),'Children');
if get(camera(1),'Value')==1
    camname='HS02';
elseif get(camera(2),'Value')==1
    camname='Utah';
elseif get(camera(3),'Value')==1
    camname='Ultima';
end

    
   
    
% %     if batch_state{3}~=0
% %         if strcmp(camera,'Utah')==1
% %         pathname=[batch_state{4},'*.gsh'];
% %         end
% %         
% %         if strcmp(camera,'Ultima')==1
% %         pathname=[batch_state{4},'*.rsh'];
% %         end
% %         
% %         if strcmp(camera,'HS02')==1
% %         pathname=[batch_state{4},'*.da'];
% %         end
%         
%         
% %     else
        if strcmp(camname,'Utah')==1
        pathname=['c:\Data\*.gsh'];
        end
        
        if strcmp(camname,'Ultima')==1
        pathname=['c:\Data\*.rsh'];
        end
        
        if strcmp(camname,'HS02')==1
        pathname=['c:\Data\*.gsh'];
        end
        
% %     end
% % else
% %     pathname=['c:\Data\*.rsh'];
end
    


[input_file,pathname] = uigetfile(pathname,'Select any one of the Data Files','MultiSelect','on');

%Defines a location to write to
if iscell(input_file);
    tempfile=char(input_file(1));
else
    tempfile=char(input_file);
end
temp=find(tempfile=='.');
tempfile=[tempfile(1:temp-1),'.h'];
[newfilename newpath]=uiputfile([pathname tempfile],'Select location for converted files');

%if file selection is cancelled, pathname should be zero and nothing should happen
if pathname == 0
    return
end
 
%gets the selected file names inside the listbox
inputFileNames = get(handles.inputFiles_listbox,'String');

%if they only select one file, then the datafile_buttongroup will not be a cell
if iscell(input_file) == 0
    input_file=cellstr(input_file); 
    %add the most recent datafile_buttongroup file selected to the cell containing all the datafile_buttongroup file names
    inputFileNames{length(inputFileNames)+1} = [fullfile(pathname,input_file{1,1}),'     ->      ',newpath];
 
%else, datafile_buttongroup will be in cell format
else
    %stores full file path into inputFileNames
    for n = 1:length(input_file)
        inputFileNames{length(inputFileNames)+1} = [fullfile(pathname,input_file{n}),'     ->     ',newpath];
    end
end
 
%updates the gui to display all filenames in the listbox
set(handles.inputFiles_listbox,'String',inputFileNames);
 
%make sure first file is always selected so it doesn't go out of range
%the GUI will break if this value is out of range
set(handles.inputFiles_listbox,'Value',1);
 
% Update handles structure
guidata(hObject, handles);
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
function deleteFiles_pushbutton_Callback(hObject, eventdata, handles)
global newpath
global pathname
global input_file

% hObject    handle to deleteFiles_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user datafile_buttongroup (see GUIDATA)

%get the current list of file names from the listbox
inputFileNames = get(handles.inputFiles_listbox,'String');
 
%get the values for the selected file names
option = get(handles.inputFiles_listbox,'Value');
 
%is there is nothing to delete, nothing happens
if (isempty(option) == 1 || option(1) == 0 )
    return
end
 
%erases the contents of highlighted item in datafile_buttongroup array
inputFileNames(option) = [];
 
%updates the gui, erasing the selected item from the listbox
set(handles.inputFiles_listbox,'String',inputFileNames);
 
%moves the highlighted item to an appropiate value or else will get error
if option(end) > length(inputFileNames)
    set(handles.inputFiles_listbox,'Value',length(inputFileNames));
end
 
% Update handles structure
guidata(hObject, handles);
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
function reset_pushbutton_Callback(hObject, eventdata, handles)
global newpath
global pathname
global input_file

% hObject    handle to reset_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user datafile_buttongroup (see GUIDATA)
 
handles.processDataCompleted = 0;


 
%clears the contents of the listbox
set(handles.inputFiles_listbox,'String','');
set(handles.inputFiles_listbox,'Value',0);
 
%updates the handles structure
guidata(hObject, handles);
% -------------------------------------------------------------------------

% -------------------------------------------------------------------------
function analyze_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to analyze_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user datafile_buttongroup (see GUIDATA)
% get(eventdata.NewValue,'Tag')   % Get Tag of selected object
global newpath
global pathname
global input_file

binning=get(handles.binning_buttongroup,'Children');
if get(binning(1),'Value')==1
    binning=4;
elseif get(binning(2),'Value')==1
        binning=1;
elseif get(binning(3),'Value')==1
        binning=2;
end
        
corv=get(handles.DataType_buttongroup,'Children');
if get(corv(1),'Value')==1
    corv=2;
elseif get(corv(2),'Value')==1
        corv=1;
end

camera=get(handles.CameraType_buttongroup,'Children');
if get(camera(1),'Value')==1
    camera='HS02';
elseif get(camera(2),'Value')==1
        camera='Utah';
elseif get(camera(3),'Value')==1
        camera='Ultima';
end

if strcmp(camera,'Utah')==1
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % BATCH PROCESSING PROGRAM  -  UTAH                                              %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [x,fnum]=size(input_file);
            h=waitbar(0,'Processing Data');
            if ~iscell(input_file)
             fnum=1;
            end
            for count = 1:fnum
            waitbar(count/fnum,h)
            if iscell(input_file)
              fname = char(input_file(count));
            else
              fname=input_file;
              count=fnum;
            end
            l = length(fname);
            if l > 4 % make sure the file name is longer than 4 characters
                if fname(l-3:l) == '.gsh' % check if file has extension 'gsh'
                    vconvert(newpath,pathname,fname,binning,corv,camera)
                end
            end
            end

close(h)
end

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------

if strcmp(camera,'Ultima')==1
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % BATCH PROCESSING PROGRAM - ULTIMA         Altered on 12/15/2012 by Sharon George to batch the Ultima Camera data files.                                               %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [x,fnum]=size(input_file);
        h=waitbar(0,'Processing Data');

        while isempty(input_file)~=1
        [x,fnum]=size(input_file);
        %     temp_file={};
        for i=1:fnum
        ip_file=input_file{1,i};
        waitbar(i/fnum,h);
        vconvert(newpath,pathname,ip_file,binning,corv,camera);
        end
   
        input_file=[];
        end


        close(h)
        
end

 if strcmp(camera,'HS02')==1
            
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % BATCH PROCESSING PROGRAM - HS02       Altered on 01/07/2015 by Poelzing to batch the HS02 Camera data files.                                               %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [x,fnum]=size(input_file);
            h=waitbar(0,'Processing Data');
            if ~iscell(input_file)
             fnum=1;
            end
            for count = 1:fnum
            waitbar(count/fnum,h)
            if iscell(input_file)
              fname = char(input_file(count));
            else
              fname=input_file;
              count=fnum;
            end
            l = length(fname);
            if l > 4 % make sure the file name is longer than 4 characters
                if fname(l-3:l) == '.gsh' % check if file has extension 'gsh'
                    vconvert(newpath,pathname,fname,binning,corv,camera)
                end
            end
            end

close(h)
end
   
%----------------------------------------------------------------------------------

 

function closeGUI(src,evnt,handles)
global pathname
%src is the handle of the object generating the callback (the source of the event)
%evnt is the The event data structure (can be empty for some callbacks)

% TO SAVE SETTINGS
handles=get(gcf,'Children');
binning=get(handles(5),'Children');
if get(binning(1),'Value')==1
    binning=4;
elseif get(binning(2),'Value')==1
    binning=1;
elseif get(binning(3),'Value')==1
    binning=2;
end


corv=get(handles(4),'Children');
if get(corv(1),'Value')==1
    corv=1;
elseif get(corv(2),'Value')==1
        corv=2;
end


%Camera type added on 01/07/2015 to read Utah, Ultima and HS02 camera
%files
camera=get(handles(1),'Children');
if get(camera(1),'Value')==1
    camera='HS02';
elseif get(camera(2),'Value')==1
    camera='Utah';
elseif get(camera(3),'Value')==1
    camera='Ultima';
end
  
batch_state{1}=binning;
batch_state{2}=corv;
batch_state{3}=camera;
batch_state{4}=pathname;

save batch_state batch_state
        
        
% selection = questdlg('Really!!! Are you sure you want to go?',...
%                      'Close Request Function',...
%                      'Yes','No','Yes');
% switch selection,
%    case 'Yes',
    delete(gcf)
%    case 'No'
%      return
% end


% -------------------------------------------------------------------------

% -------------------------------------------------------------------------


% --- Executes during object creation, after setting all properties.
function selectHS02Cam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selectHS02Cam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
