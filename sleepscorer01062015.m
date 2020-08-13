%##########################################################################
%                                SLEEP SCORER
%
%                                 Created by 
%                               Brooks A. Gross
%
%                            SLEEP AND MEMORY LAB
%                           UNIVERSITY OF MICHIGAN
%##########################################################################
% DESCRIPTION:
% This program loads the EEG/EMG data into the GUI and can be used to score 
% states.  The states recorded are automatically saved into an Excel file,
% whose name is specified within the program itself.  The output can be 
% used as a training template for the Auto-Scorer Program.
%##########################################################################
% VERSION 5b
% Modified by Brooks A. Gross on Nov-13-2012
% --Sleep Scorer can now import Plexon .PLX data files.
%   It will work on both the 32-bit and 64-bit version of MATLAB without
%   user intervention.
% --Loading for Correction now works for both manually scored and
%   auto-scored files.
% --Fixed issue with system locking up that was due to button callbacks'
%   default interruptible setting being 'On'.  Changed it to off for all
%   buttons and 
% VERSION 5
% Modified by Brooks A. Gross on Oct-24-2012
% --The CSC import code has been updated to work with the MEX files from Neuralynx.
%   It will work on both the 32-bit and 64-bit version of MATLAB without
%   user intervention.
% VERSION 4a
% Modified by Brooks A. Gross on Jan-15-2010
% --Layout has been modified.
% --Code optimization, including extraction of some sub-functions that are
%   now in separate m-files.
% VERSION 3a
% Modified by Brooks A. Gross on Oct-07-2009
% --Layout has been modified.
% --Added a scored history bar at the top for a 2 hour section. A black
%   indicator below represents location of the 2 minute history bar below.
% --Expanded the small history bar to be 2 minutes.
% 
% VERSION 2b
% Modified by Brooks A. Gross on Jan-23-2008
% --Filter information now in a separate file that is automatically named 
%   based on UI Training file name. It is automatically imported to
%   scorematic.m.
% --Fixed initialization of the filters and check boxes. *Appears to have
%   address the chart loading anomalies.
% 
% VERSION 2a
% Modified by Brooks A. Gross on Jan-10-2008
% --Added two optional customizable inputs
% --Header for .xls file now contains filter settings for EMG and EEG
%   inputs.
% Modified by Brooks A. Gross on Dec-7-2007
% --Added the ability to set/reset bandwidths of Delta, Theta, Sigma,& Beta
%   waves. User must push the 'Set/Reset' button upon opening the GUI.
%
% VERSION 1 
% Created by Apurva Turakhia on Jun-24-2003
%##########################################################################     
%%%%%Original Sleep Scorer Figure code
function varargout = sleepscorer(varargin)
%    Sleepscorer Application M-file for sleepscorer.fig
%    FIG = Sleepscorer launch sleepscorer GUI.
%    Sleepscorer('callback_name', ...) invoke the named callback.
global  Sleepstates Statecolors
Sleepstates=['Active Waking   '; ' Quiet Sleep    '; '     REM        ';'Quiet Waking    ';...
    '   Unhooked     '; '  Trans to REM  ';' Unidentifiable ';'Intermed Waking '];
Statecolors = [ 1 0.97 0; 0.1 0.3 1; 0.97 0.06 0; 0 1 0.1 ; 0 0 0; 0 1 1; 0.85 0.85 0.85; 1 1 1]; 
%Changed UNHOOKED to black to be consistent with Auto-Scorer colors.
if nargin == 0  % LAUNCH GUI
    
    fig = openfig(mfilename,'reuse');
    
    % Generate a structure of handles to pass to callbacks, and store it. 
    handles = guihandles(fig);
    guidata(fig, handles);
    
    if nargout > 0
        varargout{1} = fig;
    end
    
elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK
    
    try
        if (nargout)
            [varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
        else
            feval(varargin{:}); % FEVAL switchyard
        end
    catch ME
        errordlg(ME.message,ME.identifier);
    end
    
end
%%%%%%
% function varargout = sleepscorer(varargin)
% % sleepscorer M-file for sleepscorer.fig
% %      sleepscorer, by itself, creates a new sleepscorer or raises the existing
% %      singleton*.
% %
% %      H = sleepscorer returns the handle to a new sleepscorer or the handle to
% %      the existing singleton*.
% %
% %      sleepscorer('CALLBACK',hObject,eventData,handles,...) calls the local
% %      function named CALLBACK in sleepscorer.M with the given input arguments.
% %
% %      sleepscorer('Property','Value',...) creates a new sleepscorer or raises the
% %      existing singleton*.  Starting from the left, property value pairs are
% %      applied to the GUI before sleepscorer2_OpeningFcn gets called.  An
% %      unrecognized property name or invalid value makes property application
% %      stop.  All inputs are passed to sleepscorer2_OpeningFcn via varargin.
% %
% %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
% %      instance to run (singleton)".
% %
% % See also: GUIDE, GUIDATA, GUIHANDLES
% 
% % Edit the above text to modify the response to help sleepscorer
% 
% % Last Modified by GUIDE v2.5 31-Oct-2012 13:04:55
% 
% % Begin initialization code - DO NOT EDIT
% gui_Singleton = 1;
% gui_State = struct('gui_Name',       mfilename, ...
%                    'gui_Singleton',  gui_Singleton, ...
%                    'gui_OpeningFcn', @sleepscorer_OpeningFcn, ...
%                    'gui_OutputFcn',  @sleepscorer_OutputFcn, ...
%                    'gui_LayoutFcn',  [] , ...
%                    'gui_Callback',   []);
% if nargin && ischar(varargin{1})
%     gui_State.gui_Callback = str2func(varargin{1});
% end
% 
% if nargout
%     [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
% else
%     gui_mainfcn(gui_State, varargin{:});
% end
% % End initialization code - DO NOT EDIT
% 
% 
% % --- Executes just before sleepscorer is made visible.
% function sleepscorer_OpeningFcn(hObject, eventdata, handles, varargin)
% % This function has no output args, see OutputFcn.
% % hObject    handle to figure
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% % varargin   command line arguments to sleepscorer (see VARARGIN)
% 
% % Choose default command line output for sleepscorer
% handles.output = hObject;
% 
% % Update handles structure
% guidata(hObject, handles);
% 
% % UIWAIT makes sleepscorer wait for user response (see UIRESUME)
% % uiwait(handles.figure1);
% 
% 
% % --- Outputs from this function are returned to the command line.
% function varargout = sleepscorer_OutputFcn(hObject, eventdata, handles) 
% % varargout  cell array for returning output args (see VARARGOUT);
% % hObject    handle to figure
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Get default command line output from handles structure
% varargout{1} = handles.output;
%%%%%%
% global  Sleepstates Statecolors
% Sleepstates=['Active Waking   '; ' Quiet Sleep    '; '     REM        ';'Quiet Waking    ';...
%     '   Unhooked     '; '  Trans to REM  ';' Unidentifiable ';'Intermed Waking '];
% Statecolors = [ 1 0.97 0; 0.1 0.3 1; 0.97 0.06 0; 0 1 0.1 ; 0 0 0; 0 1 1; 0.85 0.85 0.85; 1 1 1]; 
% %Changed UNHOOKED to black to be consistent with Auto-Scorer colors.
% #########################################################################
% This section of code is executed when the 'Next Epoch' button is clicked.
function Nextframe_Callback(h, eventdata, handles, varargin) %#ok<*DEFNU>

global EPOCHSIZE EMG_TIMESTAMPS EPOCHSIZEOF10sec  EPOCHstate moveRight...
    EPOCH_StartPoint INDEX Sleepstates EPOCHnum LO_INDEX BoundIndex ISRECORDED ...
    TRACKING_INDEX  SAVED_index SLIDERVALUE Statecolors moveLeft EPOCHtime

if(length(EMG_TIMESTAMPS)-(EPOCH_StartPoint+EPOCHSIZE) <= 0)
    uiwait(errordlg('End of file reached.Scroll back or CLOSE the program', 'ERROR','modal'));
else
    handles=guihandles(sleepscorer);
    set(handles.emg_edit,'String','');
    set(handles.delta_edit,'String','');
    set(handles.theta_edit,'String','');
    set(handles.sigma_edit,'String','');
    set(handles.sigmatheta,'String','');
    set(handles.deltatheta,'String','');
    set(handles.beta_edit,'String','');
    EPOCHtime(INDEX) = EMG_TIMESTAMPS(EPOCH_StartPoint); %Added this to record epoch time stamps for unscored epochs.
    INDEX=INDEX+ round(EPOCHSIZE/EPOCHSIZEOF10sec);
    EPOCH_StartPoint =EPOCH_StartPoint + EPOCHSIZE;
    
    plot_epochdata_on_axes_in_GUI;
    SLIDERVALUE=(100*EPOCH_StartPoint)/length(EMG_TIMESTAMPS);
    set(handles.slider1, 'Value', SLIDERVALUE); 
    if ISRECORDED == 1 % If looking at the saved scored data
        if BoundIndex ~=1
            if isequal(SAVED_index(1,1), 1)
                ind=find(SAVED_index==INDEX);
            else
                ind=find((SAVED_index - LO_INDEX+1)==INDEX);
            end
%             ind=find((SAVED_index - LO_INDEX+1)==INDEX);
%                 if isempty(ind)==1
%                     ind=find(SAVED_index==INDEX);  % Changed to this in an attempt to fix the indexing.
%                 end
        else
            ind=find(SAVED_index==INDEX);
        end
        if isempty(ind)==1
            
            statenum(EPOCHstate(TRACKING_INDEX,:))
            set(handles.scoredstate,'String',Sleepstates(EPOCHnum(INDEX),:),...
                'backgroundcolor',Statecolors(EPOCHnum(INDEX),:));
        else
            statenum(EPOCHstate(ind,:))
            set(handles.scoredstate,'String',Sleepstates(EPOCHnum(INDEX),:),...
                'backgroundcolor',Statecolors(EPOCHnum(INDEX),:));
            TRACKING_INDEX=ind;
        end
    else
        if (INDEX>length(EPOCHnum)) || (EPOCHnum(INDEX)==0)
            st='NOT SCORED';
            set(handles.scoredstate,'String',st,...
                'backgroundcolor',Statecolors(7,:));
            
        else
            set(handles.scoredstate,'String',Sleepstates(EPOCHnum(INDEX),:),...
                'backgroundcolor',Statecolors(EPOCHnum(INDEX),:));
        end
        if (INDEX <= length(EPOCHnum)) 
            if (EPOCHnum(INDEX)==0)||(EPOCHnum(INDEX)==7)
                if isequal(INDEX, 1)
                    TRACKING_INDEX = 2;
                else
                    TRACKING_INDEX = 1 + find(((EPOCHnum(1:INDEX-1) ~= 0) & (EPOCHnum(1:INDEX-1) ~= 7)),1,'last');
                    if isempty(TRACKING_INDEX)
                        TRACKING_INDEX = 1;
                    end
                end
            else
                TRACKING_INDEX = INDEX-1 + find(((EPOCHnum(INDEX:length(EPOCHnum))==0) | (EPOCHnum(INDEX:length(EPOCHnum))==7)),1);
                if isempty(TRACKING_INDEX)
                    TRACKING_INDEX = length(EPOCHnum) +1;
                end

            end
        else
            TRACKING_INDEX = 1 + find(((EPOCHnum(1:length(EPOCHnum)) ~= 0) & (EPOCHnum(1:length(EPOCHnum)) ~= 7)),1,'last');
            if isempty(TRACKING_INDEX)
                TRACKING_INDEX = 1;
            end
        end
    end
end
DisplayStateColors;
viewStates;
if get(handles.PSDvaluescheckbox,'Value') == 1
        powerdensity_for_epoch;
end
moveRight = 1; moveLeft = 1;
guidata(handles.sleepscorer,handles);
% #########################################################################
% This section of code is executed when the 'Previous Epoch' button is clicked.
function Previousframe_Callback(h, eventdata, handles, varargin)

global EPOCHSIZE EMG_TIMESTAMPS EPOCHSIZEOF10sec  ISRECORDED TRACKING_INDEX ...
    EPOCHstate  EPOCH_StartPoint  INDEX Sleepstates  EPOCHnum  SAVED_index...
    LO_INDEX BoundIndex SLIDERVALUE Statecolors moveRight moveLeft
handles=guihandles(sleepscorer);
set(handles.emg_edit,'String','');
set(handles.delta_edit,'String','');
set(handles.theta_edit,'String','');
set(handles.sigma_edit,'String','');
set(handles.sigmatheta,'String','');
set(handles.deltatheta,'String','');
set(handles.beta_edit,'String','');
    
if EPOCH_StartPoint -EPOCHSIZE <=0
    EPOCH_StartPoint=1;
    if INDEX==0
        INDEX=1;
    end
    plot_epochdata_on_axes_in_GUI;
    SLIDERVALUE=(100*EPOCH_StartPoint)/length(EMG_TIMESTAMPS);
    set(handles.slider1, 'Value',SLIDERVALUE);
    uiwait(errordlg('Cannot plot the previous frame.This is the first frame',...
        'ERROR','modal'));
else
    INDEX=INDEX-round(EPOCHSIZE/EPOCHSIZEOF10sec);
    EPOCH_StartPoint =EPOCH_StartPoint-EPOCHSIZE;
    plot_epochdata_on_axes_in_GUI;
    SLIDERVALUE=(100*EPOCH_StartPoint)/length(EMG_TIMESTAMPS);
    set(handles.slider1, 'Value',SLIDERVALUE); 
end

if ISRECORDED ==1     % If looking at the saved scored data
    if BoundIndex ~=1
        if isequal(SAVED_index(1,1), 1)
            ind=find(SAVED_index==INDEX);
        else
            ind=find((SAVED_index - LO_INDEX+1)==INDEX);
        end
%             ind=find((SAVED_index - LO_INDEX+1)==INDEX);
%                 if isempty(ind)==1
%                     ind=find(SAVED_index==INDEX);  % Changed to this in an attempt to fix the indexing.
%                 end
                 
    else
        ind=find(SAVED_index==INDEX);
    end
    if isempty(ind)==0
        statenum(EPOCHstate(ind,:));
        set(handles.scoredstate,'String',Sleepstates(EPOCHnum(INDEX),:),...
            'backgroundcolor',Statecolors(EPOCHnum(INDEX),:));
        TRACKING_INDEX=ind;
    else
        if BoundIndex ~=1
            ind=find((SAVED_index - LO_INDEX+5)<=INDEX);
        else
            ind=find(SAVED_index<=INDEX);
        end
        TRACKING_INDEX=ind(end);
        statenum(EPOCHstate(TRACKING_INDEX,:));
        set(handles.scoredstate,'String',Sleepstates(EPOCHnum(INDEX),:),...
            'backgroundcolor',Statecolors(EPOCHnum(INDEX),:));
    end
else
    
    if isempty(EPOCHnum)== 0
        if INDEX >length(EPOCHnum)|| EPOCHnum(INDEX)==0
            st='NOT SCORED';
            set(handles.scoredstate,'String',st,...
                'backgroundcolor',Statecolors(7,:));
        else
            set(handles.scoredstate,'String',Sleepstates(EPOCHnum(INDEX),:),...
                'backgroundcolor',Statecolors(EPOCHnum(INDEX),:));
        end
        if (INDEX <= length(EPOCHnum))
            if(EPOCHnum(INDEX)==0)||(EPOCHnum(INDEX)==7)
                if isequal(INDEX, 1)
                    TRACKING_INDEX = 2;
                else
                    TRACKING_INDEX = 1 + find(((EPOCHnum(1:INDEX-1) ~= 0) & (EPOCHnum(1:INDEX-1) ~= 7)),1,'last');
                    if isempty(TRACKING_INDEX)
                        TRACKING_INDEX = 1;
                    end
                end
            else
                TRACKING_INDEX = INDEX-1 + find(((EPOCHnum(INDEX:length(EPOCHnum))==0) | (EPOCHnum(INDEX:length(EPOCHnum))==7)),1);
                if isempty(TRACKING_INDEX)
                    TRACKING_INDEX = length(EPOCHnum) + 1;
                end
            end
        else
            TRACKING_INDEX = 1 + find(((EPOCHnum(1:length(EPOCHnum)) ~= 0) & (EPOCHnum(1:length(EPOCHnum)) ~= 7)),1,'last');
            if isempty(TRACKING_INDEX)
                TRACKING_INDEX = 1;
            end
        end
    else
        st='NOT SCORED';
        set(handles.scoredstate,'String', st,'backgroundcolor', Statecolors(7,:));  
    end
end

DisplayStateColors;
viewStates;
if get(handles.PSDvaluescheckbox,'Value') == 1
    powerdensity_for_epoch;
end
moveRight = 1;  moveLeft = 1;
guidata(handles.sleepscorer,handles);
% #########################################################################
function Moveleft_Callback(h, eventdata, handles, varargin) %#ok<*INUSD>

global EMG_TIMESTAMPS EPOCH_StartPoint EPOCH_shiftsize  SLIDERVALUE moveLeft

handles= guihandles(sleepscorer);
start_point = EPOCH_StartPoint - (EPOCH_shiftsize*moveLeft);
if EPOCH_StartPoint<=0
    EPOCH_StartPoint =1;
end
plot_epochdata_on_axes_in_GUI(num2str(start_point));
SLIDERVALUE=(100*EPOCH_StartPoint)/length(EMG_TIMESTAMPS);
set(handles.slider1, 'Value',SLIDERVALUE); 
moveLeft=moveLeft + 1;
guidata(handles.sleepscorer,handles);
% #########################################################################
function Moveright_Callback(h, eventdata, handles, varargin)

global EMG_TIMESTAMPS EPOCH_StartPoint EPOCH_shiftsize SLIDERVALUE moveRight

start_point = EPOCH_StartPoint + (EPOCH_shiftsize * moveRight);
plot_epochdata_on_axes_in_GUI(num2str(start_point));
SLIDERVALUE=(100*EPOCH_StartPoint)/length(EMG_TIMESTAMPS);
set(handles.slider1, 'Value',SLIDERVALUE); 
viewStates;
moveRight = moveRight + 1;
guidata(handles.sleepscorer,handles);
% #########################################################################
% --- Executes on selection change in epochSizeMenu.
function epochSizeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to epochSizeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns epochSizeMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from epochSizeMenu
global EPOCHSIZE EPOCH_shiftsize EPOCHSIZEOF10sec epochVal
epochVal = get(handles.epochSizeMenu,'Value');

switch epochVal
    case 1.0
        % User selected 2 sec epoch
        EPOCHSIZE = round(EPOCHSIZEOF10sec * 0.2);
        EPOCH_shiftsize = 8;
        plot_epochdata_on_axes_in_GUI;
        
    case 2.0
        % User selected 10 sec epoch
        EPOCHSIZE = EPOCHSIZEOF10sec;
        EPOCH_shiftsize = 40;
        plot_epochdata_on_axes_in_GUI;
 
    case 3.0
        % User selected 30 sec epoch
        EPOCHSIZE = EPOCHSIZEOF10sec * 3;
        EPOCH_shiftsize = 120;
        plot_epochdata_on_axes_in_GUI;
        
    case 4.0 
        % User selected 1 min epoch
        EPOCHSIZE = EPOCHSIZEOF10sec * 6;
        EPOCH_shiftsize = 240;
        plot_epochdata_on_axes_in_GUI;
        
    case 5.0
        % User selected 2 min epoch
        EPOCHSIZE = EPOCHSIZEOF10sec * 12;
        EPOCH_shiftsize = 480;
        plot_epochdata_on_axes_in_GUI;
        
    case 6.0
        % User selected 4 min epoch
        EPOCHSIZE = EPOCHSIZEOF10sec * 24;
        EPOCH_shiftsize = 960;
        plot_epochdata_on_axes_in_GUI;
end
handles.moveright = 1;  handles.moveleft = 1;
guidata(handles.sleepscorer,handles);
% #########################################################################
function slider1_Callback(h, eventdata, handles, varargin)

global EMG_TIMESTAMPS SLIDERVALUE Statecolors EPOCHstate  EPOCHnum  SAVED_index EPOCHSIZEOF10sec...
    TRACKING_INDEX LO_INDEX BoundIndex EPOCH_StartPoint INDEX Sleepstates ISRECORDED moveLeft moveRight

X1=get(handles.slider1,'Value');
new_pt=ceil((length(EMG_TIMESTAMPS)*X1)/100);

if new_pt<=0 
% In case there is an error in generating the value of X1 and the value it 
% goes negative, then start from the first value itself.
    new_pt=1;
end
difference=abs(new_pt - EPOCH_StartPoint);
ind_shiftvalue = round(difference/EPOCHSIZEOF10sec);
if new_pt > EPOCH_StartPoint
    INDEX=INDEX + ind_shiftvalue;
    EPOCH_StartPoint = EPOCH_StartPoint + (ind_shiftvalue * EPOCHSIZEOF10sec);
else
    INDEX=INDEX - ind_shiftvalue;
    if INDEX <= 0
        INDEX = 1;
        EPOCHStartPoint = 1; 
    else
        EPOCH_StartPoint = EPOCH_StartPoint - (ind_shiftvalue * EPOCHSIZEOF10sec);
    end
end

if ISRECORDED ==1     % If u r looking at the saved scored data
    if BoundIndex ~=1
        if isequal(SAVED_index(1,1), 1)
            ind=find(SAVED_index==INDEX);
        else
            ind=find((SAVED_index - LO_INDEX+5)==INDEX);
        end
    else
        ind=find(SAVED_index==INDEX);
    end
    if isempty(ind)==0
        statenum(EPOCHstate(ind,:));
        set(handles.scoredstate,'String',Sleepstates(EPOCHnum(INDEX),:),...
            'backgroundcolor',Statecolors(EPOCHnum(INDEX),:));
        TRACKING_INDEX=ind;
    else
        if BoundIndex ~=1
            ind=find((SAVED_index - LO_INDEX+5)<=INDEX);
        else
            ind=find(SAVED_index<=INDEX);
        end
        TRACKING_INDEX=ind(end);
        statenum(EPOCHstate(TRACKING_INDEX,:));
        set(handles.scoredstate,'String',Sleepstates(EPOCHnum(INDEX),:),...
            'backgroundcolor',Statecolors(EPOCHnum(INDEX),:));
    end
else
    if isempty(EPOCHnum)== 0
        if (INDEX>length(EPOCHnum)) || (EPOCHnum(INDEX)==0)
            st='NOT SCORED';
            set(handles.scoredstate,'String',st, 'backgroundcolor',Statecolors(7,:));
        else
            set(handles.scoredstate,'String',Sleepstates(EPOCHnum(INDEX),:),...
                'backgroundcolor',Statecolors(EPOCHnum(INDEX),:));
        end
        if (INDEX <= length(EPOCHnum)) 
            if (EPOCHnum(INDEX)==0)||(EPOCHnum(INDEX)==7)
                if isequal(INDEX, 1)
                    TRACKING_INDEX = 2;
                else
                    TRACKING_INDEX = 1 + find(((EPOCHnum(1:INDEX-1) ~= 0) & (EPOCHnum(1:INDEX-1) ~= 7)),1,'last');
                    if isempty(TRACKING_INDEX)
                        TRACKING_INDEX = 1;  % may need to change this to = INDEX + 1
                    end
                end
            else
                TRACKING_INDEX = INDEX-1 + find(((EPOCHnum(INDEX:length(EPOCHnum))==0) | (EPOCHnum(INDEX:length(EPOCHnum))==7)),1);
                if isempty(TRACKING_INDEX)
                    TRACKING_INDEX = length(EPOCHnum) +1;
                end

            end
        else
            TRACKING_INDEX = 1 + find(((EPOCHnum(1:length(EPOCHnum)) ~= 0) & (EPOCHnum(1:length(EPOCHnum)) ~= 7)),1,'last');
            if isempty(TRACKING_INDEX)
                TRACKING_INDEX = 1;  % may need to change this to = INDEX + 1
            end
        end
%         if (INDEX <= length(EPOCHnum)) && (EPOCHnum(INDEX)==0)||(EPOCHnum(INDEX)==7)
%             if isequal(INDEX, 1)
%                 TRACKING_INDEX = 1;
%             else
%                 TRACKING_INDEX = find(((EPOCHnum(1:INDEX-1) ~= 0) & (EPOCHnum(1:INDEX-1) ~= 7)),1,'last');
%             end
% 
%         end
    else
        st='NOT SCORED';
        set(handles.scoredstate,'String', st,'backgroundcolor', Statecolors(7,:));
        TRACKING_INDEX = 1;
    end
end
plot_epochdata_on_axes_in_GUI;
SLIDERVALUE=(100*EPOCH_StartPoint)/length(EMG_TIMESTAMPS);
set(handles.slider1, 'Value',SLIDERVALUE);
DisplayStateColors;
viewStates;
if get(handles.PSDvaluescheckbox,'Value') == 1
        powerdensity_for_epoch;
end
set(handles.emg_edit,'String','');
set(handles.delta_edit,'String','');
set(handles.theta_edit,'String','');
set(handles.sigma_edit,'String','');
set(handles.sigmatheta,'String','');
set(handles.deltatheta,'String','');
set(handles.beta_edit,'String','');
moveRight = 1; moveLeft = 1;
guidata(handles.sleepscorer,handles);
% #########################################################################
function Activewaking_Callback(h, eventdata, handles, varargin)

global stateNumberCode stateLetterCode epochScoringSize epochVal

stateNumberCode = 1;
stateLetterCode = 'AW';
stateProcessing;
% #########################################################################
function Quietsleep_Callback(h, eventdata, handles, varargin)

global stateNumberCode stateLetterCode epochScoringSize epochVal

stateNumberCode = 2;
stateLetterCode = 'QS';
stateProcessing;
% #########################################################################
function Intermediate_Waking_Callback(h, eventdata, handles, varargin)

global stateNumberCode stateLetterCode epochScoringSize epochVal

stateNumberCode = 8;
stateLetterCode = 'IW';
stateProcessing;
% #########################################################################
function REM_Callback(h, eventdata, handles, varargin)

global stateNumberCode stateLetterCode epochScoringSize epochVal

stateNumberCode = 3;
stateLetterCode = 'RE';
stateProcessing;
% #########################################################################
function Quietwaking_Callback(h, eventdata, handles, varargin)

global stateNumberCode stateLetterCode epochScoringSize epochVal

stateNumberCode = 4;
stateLetterCode = 'QW';
stateProcessing;
% #########################################################################
function Unhooked_Callback(h, eventdata, handles, varargin)

global stateNumberCode stateLetterCode epochScoringSize epochVal

stateNumberCode = 5;
stateLetterCode = 'UH';
stateProcessing;
% #########################################################################
function clearstate_Callback(hObject, eventdata, handles)

global stateNumberCode stateLetterCode EPOCHnum TRACKING_INDEX INDEX epochScoringSize epochVal

stateNumberCode = 7;
stateLetterCode = 'NS';
stateProcessing;
% #########################################################################
function transREM_Callback(h, eventdata, handles, varargin) %#ok<DEFNU>

global stateNumberCode stateLetterCode epochScoringSize epochVal
% The EPOCHnum of TR has been changed from 7 to 6
stateNumberCode = 6;
stateLetterCode = 'TR';
stateProcessing;
% #########################################################################
function autofill_Callback(hObject, eventdata, handles)

global EPOCHSIZE EMG_TIMESTAMPS EPOCHtime TRACKING_INDEX EPOCHstate EPOCH_StartPoint INDEX EPOCHnum 
global EPOCHSIZEOF10sec  moveRight Sleepstates LO_INDEX BoundIndex ISRECORDED ...
        SAVED_index SLIDERVALUE Statecolors moveLeft epochScoringSize epochVal TRAINEDEPOCH_INDEX

if isequal(epochScoringSize, epochVal)
    handles=guihandles(sleepscorer);
    if (INDEX - TRACKING_INDEX >= 0) && (TRACKING_INDEX > 1)
        track_state = EPOCHstate(TRACKING_INDEX-1,:);
        d = TRACKING_INDEX:INDEX;
        track_point = EPOCH_StartPoint - (INDEX - TRACKING_INDEX) * EPOCHSIZE;
        t = track_point:EPOCHSIZE:EPOCH_StartPoint;
        if length(t) > length(d)
            t=t(1:end-1);
        end
        EPOCHstate(d,1) = track_state(1,1);
        EPOCHstate(d,2) = track_state(1,2);
        track_time = double(EMG_TIMESTAMPS(t));
        EPOCHtime(TRACKING_INDEX:INDEX) = single(track_time(1:end));
        EPOCHnum(TRACKING_INDEX:INDEX) = EPOCHnum(TRACKING_INDEX-1);
        for i = TRACKING_INDEX:INDEX
            if ~any(TRAINEDEPOCH_INDEX == i) % add index to indoffset only if it was not done b4 
                TRAINEDEPOCH_INDEX=[TRAINEDEPOCH_INDEX; i]; %#ok<AGROW>
            end
        end
        if(length(EMG_TIMESTAMPS)-(EPOCH_StartPoint+EPOCHSIZE) <= 0)
            uiwait(errordlg('End of file reached.Scroll back or CLOSE the program', 'ERROR','modal'));
        else
            set(handles.emg_edit,'String','');
            set(handles.delta_edit,'String','');
            set(handles.theta_edit,'String','');
            set(handles.sigma_edit,'String','');
            set(handles.sigmatheta,'String','');
            set(handles.deltatheta,'String','');
            set(handles.beta_edit,'String','');

%             INDEX = INDEX + round(EPOCHSIZE/EPOCHSIZEOF10sec);
%             EPOCH_StartPoint = EPOCH_StartPoint + EPOCHSIZE;
            nIndexSteps = round(EPOCHSIZE/EPOCHSIZEOF10sec);
            if isequal(nIndexSteps, 1)
                INDEX = INDEX + 1;
                EPOCH_StartPoint = EPOCH_StartPoint + EPOCHSIZEOF10sec;
            else
                for i = 2:nIndexSteps
                    INDEX = INDEX + 1;
                    EPOCH_StartPoint = EPOCH_StartPoint + EPOCHSIZEOF10sec;
                    EPOCHtime(INDEX) = EMG_TIMESTAMPS(EPOCH_StartPoint);
                    EPOCHstate(INDEX,:) = EPOCHstate(INDEX-1,:);
                    EPOCHnum(INDEX) = EPOCHnum(INDEX-1);
                    if ~any(TRAINEDEPOCH_INDEX==INDEX) % add index to indoffset only if it was not done b4 
                        TRAINEDEPOCH_INDEX=[TRAINEDEPOCH_INDEX;INDEX]; %#ok<AGROW>
                    end
                end
                INDEX = INDEX + 1;
                EPOCH_StartPoint = EPOCH_StartPoint + EPOCHSIZEOF10sec;
            end
            plot_epochdata_on_axes_in_GUI;
            SLIDERVALUE=(100*EPOCH_StartPoint)/length(EMG_TIMESTAMPS);
            set(handles.slider1, 'Value', SLIDERVALUE); 
            if ISRECORDED == 1 % If looking at the saved scored data
                if BoundIndex ~=1
                    ind=find((SAVED_index - LO_INDEX+5)==INDEX);
                else
                    ind=find(SAVED_index==INDEX);
                end
                if isempty(ind)==1

                    statenum(EPOCHstate(TRACKING_INDEX,:))
                    set(handles.scoredstate,'String',Sleepstates(EPOCHnum(INDEX),:),...
                        'backgroundcolor',Statecolors(EPOCHnum(INDEX),:));
                else
                    statenum(EPOCHstate(ind,:))
                    set(handles.scoredstate,'String',Sleepstates(EPOCHnum(INDEX),:),...
                        'backgroundcolor',Statecolors(EPOCHnum(INDEX),:));
                    TRACKING_INDEX=ind;
                end
            else
                if (INDEX>length(EPOCHnum)) || (EPOCHnum(INDEX)==0)
                    st='NOT SCORED';
                    set(handles.scoredstate,'String',st,...
                        'backgroundcolor',Statecolors(7,:));
                else
                    set(handles.scoredstate,'String',Sleepstates(EPOCHnum(INDEX),:),...
                        'backgroundcolor',Statecolors(EPOCHnum(INDEX),:));
                end
                if (INDEX <= length(EPOCHnum)) 
                    if (EPOCHnum(INDEX)==0)||(EPOCHnum(INDEX)==7)
                        TRACKING_INDEX = INDEX;
                    else
                        TRACKING_INDEX = INDEX-1 + find(((EPOCHnum(INDEX:length(EPOCHnum))==0) | (EPOCHnum(INDEX:length(EPOCHnum))==7)),1);
                        if isempty(TRACKING_INDEX)
                            TRACKING_INDEX = length(EPOCHnum) +1;
                        end

                    end
                else
                    TRACKING_INDEX = INDEX;
                end
            end
        end
        DisplayStateColors;
        viewStates;
        if get(handles.PSDvaluescheckbox,'Value') == 1
                powerdensity_for_epoch;
        end
        moveRight = 1; moveLeft = 1;
        guidata(handles.sleepscorer,handles);
    else
        uiwait(errordlg('Cannot use the AutoFill.This is just the next frame',...
            'ERROR','modal'));
    end
else
    switch epochScoringSize
        case 1
            epochString = '2 seconds';
        case 2
            epochString = '10 seconds';
        case 3
            epochString = '30 seconds';
        case 4
            epochString = '1 minute';
        case 5
            epochString = '2 minutes';
        case 6
            epochString = '4 minutes';
    end
    errordlg(['Epoch setting for scoring is locked to' epochString...
        '.  Please change the epoch size in the drop-down menu to continue scoring.'],'Error');

end
% #########################################################################
function loadnplot_datafiles_Callback(h, eventdata, handles, varargin)

global EMG_TIMESTAMPS EPOCHtime EPOCH_StartPoint EPOCHnum...
     BoundIndex LBounds TRAINEDEPOCH_INDEX SLIDERVALUE

if isempty(TRAINEDEPOCH_INDEX) && isempty(EPOCHtime) 
    uiwait(errordlg('There was no state scored for this section and hence no data shall be appended to file'...
        ,'ERROR','modal'));
else    
    TRAINEDEPOCH_INDEX=sort(TRAINEDEPOCH_INDEX);  % In case the states were not scored in order
    
    filename=get(handles.trainingfile,'TooltipString');
    fid=fopen(filename,'a+');
    for i = 1:length(EPOCHnum)
        if isequal(EPOCHnum(i), 0)
            EPOCHnum(i) = 7;  % Re-labels to "not-scored"
        end
        if isequal(EPOCHtime(i), 1)
            EPOCHtime(i) = EPOCHtime(i-1) + 10; 
        end
        fprintf(fid,'%7d',i); % The index number should be = i since it is now writing all epochs to the file.
        fprintf(fid,'\t');
        fprintf(fid,'%9.4f',EPOCHtime(i));
        fprintf(fid,'\t');
        fprintf(fid,'%8d\n',EPOCHnum(i));
    end     
    %Commented out the part below because it was only writing scored epochs
    %to file.  All epochs in the section, including ones not scored, need
    %to be written to the file in order for correction of manually scored
    %file to work correctly.
%     for i = 1:length(TRAINEDEPOCH_INDEX) 
%         fprintf(fid,'%7d',TRAINEDEPOCH_INDEX(i));
%         fprintf(fid,'\t');
%         fprintf(fid,'%9.4f',EPOCHtime(TRAINEDEPOCH_INDEX(i)));
%         fprintf(fid,'\t');
%         fprintf(fid,'%8d\n',EPOCHnum(TRAINEDEPOCH_INDEX(i)));
%     end
    fclose(fid);
end

if BoundIndex + 1 > length(LBounds)
    uiwait(errordlg('End of the file. Scored data is saved.'...
        ,'ERROR','modal'));
    set(handles.load_nextsection_savedfile,'visible','off');
else
       
    clear global EPOCHstate 
    clear global EPOCHtime 
    clear global EPOCHnum 
    clear global TRAINEDEPOCH_INDEX
    BoundIndex=BoundIndex+1;
    sectionword=strcat('Section ',num2str( BoundIndex));
    set(handles.sectiontext,'string',sectionword);
    % If the entire file has been plotted, then just save the training file and
    % move it to the appropriate file folder or else, continue loading the file
    % records
      
    %[uppertimestamp,lowertimestamp]=extract_samples_timestamps_from_datafile;
    % Oct-7-2009: Removed uppertimestamp & lowertimestamp outputs from
    % 'extract_samples..." function. They don't appear to be used anywhere.
    extract_samples_timestamps_from_datafile;
    plot_epochdata_on_axes_in_GUI;
    %   ^^^^^^^^^ Setting the slider arrow and trough step EPOCHSIZEOF10sec ^^^^^^ 
    slider_step(1)=0.01188;
    slider_step(2)=0.09509;
    set(handles.slider1,'sliderstep',slider_step);
    SLIDERVALUE=(100*EPOCH_StartPoint)/length(EMG_TIMESTAMPS);
    set(handles.slider1, 'Value',SLIDERVALUE);
    if get(handles.PSDvaluescheckbox,'Value') == 1
        powerdensity_for_epoch;
    end
end
DisplayStateColors;
% #########################################################################
function load_nextsection_savedfile_Callback(hObject, eventdata, handles)

global EPOCHSIZE EMG_TIMESTAMPS tbounds EPOCHSIZEOF10sec EPOCHtime ISRECORDED...  
    EPOCHstate EPOCH_StartPoint  INDEX Sleepstates EPOCHnum exitAlgorithm...
    SAVED_index UBounds BoundIndex newname SLIDERVALUE exactLowerTS exactUpperTS
i=1;
fid=fopen(newname,'a+');
while i<=length(EPOCHtime)
    fprintf(fid,'%6f',SAVED_index(i));
    fprintf(fid,'\t');
    fprintf(fid,'%9.4f',EPOCHtime(i));
    fprintf(fid,'\t');
    fprintf(fid,'%6s\n',EPOCHstate(i,:));
    i=i+1;
end
fclose(fid);

if BoundIndex <=length(UBounds)
    BoundIndex = BoundIndex+1;
    sectionword = strcat('Section ',num2str( BoundIndex));
    set(handles.sectiontext,'string',sectionword);
    %See 1st instance of function for information
    extract_samples_timestamps_from_datafile;
    ISRECORDED=1;
    % Reading in the states,tstamps & Index from the SAVED excel file 
    exactLowerTS = tbounds(BoundIndex,5);
    exactUpperTS = tbounds(BoundIndex,6);
    data_tstamp_read(exactLowerTS,exactUpperTS); 
    
    if isequal(exitAlgorithm, 1)
        return
    end
    index = find(double(EMG_TIMESTAMPS(1))+9.99 < EMG_TIMESTAMPS...
        & EMG_TIMESTAMPS < double(EMG_TIMESTAMPS(1))+10.1);
    difference = EMG_TIMESTAMPS(index(1):index(end)) - (EMG_TIMESTAMPS(1)+10);
    [minimum,ind] = min(abs(difference));

    try
        EPOCHSIZE=index(ind);
    catch 
        fprintf( 'There is an error in calculating the EPOCHSIZE of 10sec in load_nextsection_savedfile function \n' );
    end
    EPOCHSIZEOF10sec=EPOCHSIZE;

    numEpochsInSectionOfEMG = floor(size(EMG_TIMESTAMPS,1)/EPOCHSIZEOF10sec);
    numEpochsInSectionOfScoredFile = size(EPOCHtime,1);
    if numEpochsInSectionOfScoredFile < numEpochsInSectionOfEMG
        EPOCHnum = EPOCHnum(1:end-1,:);
        EPOCHstate = EPOCHstate(1:end-1,:);
        EPOCHtime = EPOCHtime(1:end-1,:);
        SAVED_index = SAVED_index(1:end-1,:);
        for i=numEpochsInSectionOfScoredFile:numEpochsInSectionOfEMG
            EPOCHnum = [EPOCHnum;7];
            EPOCHstate = [EPOCHstate; 'NS'];
            tempEpochTimePointIndex = 1+ ((i-1)*EPOCHSIZEOF10sec);
            EPOCHtime= [EPOCHtime;EMG_TIMESTAMPS(tempEpochTimePointIndex)];
            SAVED_index = [SAVED_index; i]; % Adjusts the vector to include the added indeterminant states
        end
    end
    
  
    plot_epochdata_on_axes_in_GUI;
    statenum(EPOCHstate(INDEX,:));
    set(handles.scoredstate,'String',Sleepstates(EPOCHnum(INDEX),:));
    %Setting the slider arrow and trough step EPOCHSIZEOF10sec 
    slider_step(1)=0.01188;
    slider_step(2)=0.09509;
    set(handles.slider1,'sliderstep',slider_step);
    SLIDERVALUE=(100*EPOCH_StartPoint)/length(EMG_TIMESTAMPS);
    set(handles.slider1, 'Value',SLIDERVALUE);
    if get(handles.PSDvaluescheckbox,'Value') == 1
        powerdensity_for_epoch;
    end
    DisplayStateColors;
else
    uiwait(errordlg('End of the file. Scored data is saved.'...
        ,'ERROR','modal'));
    set(handles.load_nextsection_savedfile,'visible','off');
end
% #########################################################################
function[] = data_tstamp_read(exactLowerTS,exactUpperTS)

global SAVED_index EPOCHstate EPOCHtime EPOCHnum EMG_TIMESTAMPS EPOCH_StartPoint...
    INDEX Sleepstates LO_INDEX SLIDERVALUE Statecolors FileFlag scoreFileCorrectionType...
    exitAlgorithm

handles=guihandles(sleepscorer);
filename=get(handles.autoscoredfile,'TooltipString');
%Part below was commented out since file types are now checked when loading the
%file.
% try
%     [t_stamps,state]=xlsread(filename);
% catch ME
%     errordlg(ME.message,ME.identifier);
%     uiwait(errordlg('Check if the file is saved in Microsoft Excel format.','ERROR','modal'));
% end
switch scoreFileCorrectionType
    case 0  % Manually scored file will be loaded for correction
        [t_stamp_state,stateTemp] = xlsread(filename);
        trainVsCorrected = size(t_stamp_state,2);
        if isequal(trainVsCorrected, 3) %This is an original manually scored file.
            clear stateTemp
            t_stamps = t_stamp_state(:,1:2);
            state = t_stamp_state(:,3);
            clear t_stamp_state
            lengthState = size(state,1);
            %state = zeros(lengthState);
            EPOCHstate = [];
            for i = 1:lengthState  % This loop creates a vector to be like the state vector from Auto-Scorer
                switch state(i)
                    case 1
                        EPOCHstate = [EPOCHstate; 'AW']; %#ok<*AGROW>
                    case 2
                        EPOCHstate = [EPOCHstate; 'QS'];
                    case 3
                        EPOCHstate = [EPOCHstate; 'RE'];
                    case 4
                        EPOCHstate = [EPOCHstate; 'QW'];
                    case 5
                        EPOCHstate = [EPOCHstate; 'UH'];
                    case 6
                        EPOCHstate = [EPOCHstate; 'TR'];
                    case 7
                        EPOCHstate = [EPOCHstate; 'NS'];
                    case 8
                        EPOCHstate = [EPOCHstate; 'IW'];   
                end
            end
        elseif isequal(trainVsCorrected, 2) % This is a manually corrected file.
            t_stamps = t_stamp_state(:,1:2);
            clear t_stamp_state
            state = stateTemp(3:end,3);
            clear stateTemp
            state = char(state);
            EPOCHstate=[state(:,5) state(:,6)];
        end
    case 1  % Auto-scored file will be loaded for correction
        [t_stamps,state] = xlsread(filename);
        t_stamps = t_stamps(5:end,1:2);
        state = state(5:end,3);
        state = char(state);
        EPOCHstate=[state(:,5) state(:,6)];
end
clear state
if isequal(FileFlag, 0)
    errordlg('You must select a file type.','Error');
else  %Add code to limit to one index value
    if isequal(FileFlag,2) % AD System
        exactLowerTime = exactLowerTS/10^4;
        exactUpperTime = exactUpperTS/10^4;
    elseif isequal(FileFlag,1) % Neuralynx
        exactLowerTime = exactLowerTS/10^6;
        exactUpperTime = exactUpperTS/10^6;
    elseif isequal(FileFlag,3)  % ASCII - Polysmith
        exactLowerTime = exactLowerTS;
        exactUpperTime = exactUpperTS;
    elseif isequal(FileFlag,4)  % ASCII - EMZA 
        exactLowerTime = exactLowerTS;
        exactUpperTime = exactUpperTS;
    elseif isequal(FileFlag,5)  % Plexon
        exactLowerTime = exactLowerTS;
        exactUpperTime = exactUpperTS;
    end
    [lowDifference,lowIndex] = min(abs(t_stamps(:,2) - exactLowerTime));  %#ok<*ASGLU>
    LO_INDEX = lowIndex(1);
    clear lowDifference lowIndex exactLowerTime
    [highDifference,highIndex] = min(abs(t_stamps(:,2) - exactUpperTime));
    up_index = highIndex(1);
    clear highDifference highIndex exactUpperTime
    try
        SAVED_index=t_stamps(LO_INDEX:up_index,1);
%         if isequal(size(SAVED_index,1),1)
%             errordlg('You have reached the end of the sections that have previously been scored.')
%         end
    catch ME
        errordlg(ME.message,ME.identifier);
        errordlg(' There was an error calculating the up_index in the data_tstamp_read function')
    end
    EPOCHtime = t_stamps(LO_INDEX:up_index,2);   
%     state=state(LO_INDEX:up_index,3);
%     state=char(state);
    EPOCHstate = EPOCHstate(LO_INDEX:up_index,:);
    % Since this variable is reloaded again, we have to make sure that in case
    % the previous length was longer than the current, then delete those values
    % which otherwise, would show up on DisplayStatecolors at the end of the
    % file... and would get confusing. (Huh?)
%     if length(state) < length(EPOCHstate)
%         EPOCHstate = EPOCHstate(1:length(state),:);
%     end

    EPOCHnum = zeros(length(EPOCHstate),1);
    for i=1:length(EPOCHnum)
        try
        statenum(EPOCHstate(i,:));
        catch err
            errordlg('You have reached the end of the sections that have previously been scored.')
            exitAlgorithm = 1;
            return
        end
        INDEX = INDEX+1;
    end
    INDEX = 1;
    exitAlgorithm = 0;
    clear state t_stamps   
    %^^^^^^^^^ Setting the slider arrow and trough step EPOCHSIZEOF10sec ^^^^^^ 
    slider_step(1) = 0.01088;
    slider_step(2) = 0.09909;
    set(handles.slider1,'sliderstep',slider_step);
    SLIDERVALUE=(100*EPOCH_StartPoint)/length(EMG_TIMESTAMPS);
    set(handles.slider1, 'Value',SLIDERVALUE);
    statenum(EPOCHstate(INDEX,:));
    set(handles.scoredstate,'String',Sleepstates(EPOCHnum(INDEX),:),...
        'backgroundcolor',Statecolors(EPOCHnum(INDEX),:));
end
% #####################################################################
function powerdensity_for_epoch_Callback(h, eventdata, handles, varargin)
powerdensity_for_epoch;
%##########################################################################
%#############          EXTRACTING INPUT FILES            #################
%##########################################################################
function[uppertimestamp,lowertimestamp] = extract_samples_timestamps_from_datafile()

global TRACKING_INDEX EPOCHstate EPOCH_StartPoint INDEX EPOCHtime EPOCHnum... 
    TRAINEDEPOCH_INDEX  LBounds UBounds BoundIndex  Fs FileFlag...
    P_emg P_delta P_theta P_sigma st_power dt_ratio...
    EMG_CHANNEL EMG_TIMESTAMPS EMG_SAMPLES EMG_Notch_enable EMG_LP_Fc EMG_lowpass_enable...
    EEG_CHANNEL EEG_TIMESTAMPS EEG_SAMPLES EEG_highpass_enable EEG_HP_Fc EEG_Notch_enable...
    Input3_enable Input3_LP_enable Input3_LP_Fc Input3_Notch_enable Input3_HP_enable Input3_HP_Fc INPUT3_TIMESTAMPS INPUT3_SAMPLES INPUT3_CHANNEL...
    Input4_enable Input4_HP_enable Input4_HP_Fc Input4_Notch_enable Input4_LP_enable Input4_LP_Fc INPUT4_TIMESTAMPS INPUT4_SAMPLES INPUT4_CHANNEL
global EEG_Fc EMG_Fc SampFreq1 SampFreq2 sampfactor exactLowIndx exactHiIndx sampfactor2 Fs2 sampfactor3 Fs3 sampfactor4 Fs4

nsamp = []; % Number of samples per bin of time
waithandle= waitbar(0,'Loading the file ..... ');pause(0.2)
handles=guihandles(sleepscorer);
exactLow = exactLowIndx(BoundIndex);
exactHi = exactHiIndx(BoundIndex);
 %  ****** NECK EMG FILE extraction *********
filename=get(handles.emgfile,'TooltipString');
lowertimestamp=LBounds(BoundIndex);
uppertimestamp=UBounds(BoundIndex);
if isequal(FileFlag, 2) % AD System
    try
        if EMG_CHANNEL <= 5
            [Timestamps,Samples,SF,Nsamp]=Crx2Mat(filename,lowertimestamp+EMG_CHANNEL-1,...
                uppertimestamp+EMG_CHANNEL-1);
        else % Channel 6 have timestamps skipped by 1 from channel 5, hence the offset changes
            [Timestamps,Samples,SF,Nsamp]=Crx2Mat(filename,lowertimestamp+EMG_CHANNEL,...
                uppertimestamp+EMG_CHANNEL);
        end
    catch 
        fprintf('There is an error in Crx2Mat function. Check values passed into the function \n' );
        fprintf('\n Maybe the channel numbers do not match the actual channel number\n\n');
        rethrow(lasterror); %#ok<LERR>
    end
    waitbar(0.1,waithandle,'Converting EMG from CRextract format to Matlab dataformat ...');
    figure(waithandle),pause(0.2),
    samples=double(Samples(:)');
    clear Samples
    SampFreq1=SF;
    if BoundIndex == 1
        DS = (1:1:10);
        DSampSF = SampFreq1./DS;
        indSampfactor = find(DSampSF >= 250);
        Fs = round(DSampSF(indSampfactor(end)));
        sampfactor = DS(indSampfactor(end));
        msgbox({['Orginal Sampling Rate:  ' num2str(SampFreq1) 'Hz'];...
            ['Down-Sampled Sampling Rate:  ' num2str(Fs) 'Hz']; ['Sampling Factor:  ' num2str(sampfactor) '']});
    end

    waitbar(0.4,waithandle,'Filtering the EMG data ...'); 
    figure(waithandle),pause(0.2),
    % Incase you are looking at stimulation file, then you dont have to
    % filter out the high frequency data. WE just use unfiltered data
    %[path,name,ext]=fileparts(filename);
    switch ext
        case '.stim'
            [EMG_TIMESTAMPS,EMG_SAMPLES]=Crxread(double(Timestamps),samples,sampfactor,Nsamp, exactLow, exactHi);
        case '.emg'
            [EMG_TIMESTAMPS,EMG_SAMPLES] = Crxread(double(Timestamps),samples,sampfactor,Nsamp, exactLow, exactHi);


            %  High pass filter for EMG signals
            [Bhigh,Ahigh]=ellip(7,1,60, EMG_Fc/(SampFreq1/2),'high');  % Default setting implements high pass filter with 30hz cutoff
            filtered_samples=(filter(Bhigh,Ahigh,EMG_SAMPLES))/4;
            %  OPTIONAL lowpass filter for EMG signals
            if EMG_lowpass_enable>0
                [EMG_Blow,EMG_Alow] = ellip(7,1,60, EMG_LP_Fc/(SampFreq1/2));   % Default is OFF
                filtered_samples = filter(EMG_Blow,EMG_Alow, filtered_samples);
            end
            % Optional EMG 60Hz Notch Filter
            if EMG_Notch_enable > 0
                woB = 60/(SampFreq1/2);
                [B_EMG_Notch,A_EMG_Notch] =  iirnotch(woB, woB/35);   % Default is OFF
                filtered_samples = filter(B_EMG_Notch,A_EMG_Notch, filtered_samples);
            end
            EMG_TIMESTAMPS = EMG_TIMESTAMPS(1:sampfactor:end);
            EMG_SAMPLES = filtered_samples(1:sampfactor:end);
    end
    
elseif isequal(FileFlag, 1) % Neuralynx System
    waitbar(0.1,waithandle,'Converting EMG from Neuralynx CSC to Matlab data ...');
    figure(waithandle),pause(0.2),
    [Timestamps,SF,Samples] = Nlx2MatCSC(filename,[1 0 1 0 1],0,4,[lowertimestamp uppertimestamp]);
    samples = double(Samples(:)');
    clear Samples
    SampFreq1 = SF(1);
    if BoundIndex == 1
        DS = (1:1:10);
        DSampSF = SampFreq1./DS;
        indSampfactor = find(DSampSF >= 1000);
        Fs = round(DSampSF(indSampfactor(end)));
        sampfactor = DS(indSampfactor(end));
         msgbox({['Orginal Sampling Rate:  ' num2str(SampFreq1) 'Hz'];...
            ['Down-Sampled Sampling Rate:  ' num2str(Fs) 'Hz']; ['Sampling Factor:  ' num2str(sampfactor) '']});
    end
    % Precise time stamps should be calculated here:
    [EMG_TIMESTAMPS,EMG_SAMPLES] = generate_timestamps_from_Ncsfiles(Timestamps, samples, exactLow, exactHi, nsamp);
    %Set up EMG filters    
    %  High pass filter for EMG signals
    [Bhigh,Ahigh]=ellip(7,1,60, EMG_Fc/(SampFreq1/2),'high');  % Default setting implements high pass filter with 30hz cutoff
    waitbar(0.4,waithandle,'Filtering the EMG data ...'); 
    figure(waithandle),pause(0.2),
    physInput = 1;  %Needed to select proper error box in HeaderADBit.
    ADBit2uV = HeaderADBit(filename, physInput);    %Calls a function to extract the AD Bit Value.
    EMG_SAMPLES = EMG_SAMPLES * ADBit2uV;   %Convert EMG amplitude of signal from AD Bits to microvolts.
    filtered_samples = filter(Bhigh,Ahigh,EMG_SAMPLES);
    % OPTIONAL lowpass filter for EMG signals
    if EMG_lowpass_enable>0
        [EMG_Blow,EMG_Alow] = ellip(7,1,60, EMG_LP_Fc/(SampFreq1/2));   % Default is OFF
        filtered_samples = filter(EMG_Blow,EMG_Alow, filtered_samples);
    end
    % Optional 60Hz Notch Filter
    if EMG_Notch_enable > 0
        woB = 60/(SampFreq1/2);
        [B_EMG_Notch,A_EMG_Notch] =  iirnotch(woB, woB/35);   % Default is OFF
        filtered_samples = filter(B_EMG_Notch,A_EMG_Notch, filtered_samples);
    end
    EMG_TIMESTAMPS = EMG_TIMESTAMPS(1:sampfactor:end);
    EMG_SAMPLES = filtered_samples(1:sampfactor:end);
    clear physInput ADBit2uV
elseif isequal(FileFlag, 3) % ASCII - Polysmith
    waitbar(0.1,waithandle,'Converting EMG from ASCII to Matlab data ...');
    figure(waithandle),pause(0.2),
    %Changed below from 200Hz
    SampFreq1 = 200;
    exactLow = (exactLow + 7200 * SampFreq1 * (BoundIndex - 1));
    exactHi = (exactLow + exactHi - 1);
    SampA = dlmread(filename);
    filenameB = strrep(filename, '-1', '-2');
    SampB = dlmread(filenameB);
    Samples = SampA - SampB;
    clear SampA SampB
    Samples = Samples(exactLow:exactHi);
    samples = double(Samples(:));
    clear Samples
    physInput = 1;  %Needed to select proper error box in HeaderADBit.
    samples = AsciiPolysmithADBit(filename, physInput, samples);    %Calls a function to convert from bit volts to uV.
    
    tStep = 1/SampFreq1;
    tLow = exactLow/SampFreq1;
    tHi = exactHi/SampFreq1;
    Timestamps = (tLow:tStep:tHi);
    sampfactor = 1;
   
    Fs = round(SampFreq1/sampfactor);
    % Confirming that the downsampling is not too low
    if BoundIndex == 1
        DS = (1:1:10);
        DSampSF = SampFreq1./DS;
        indSampfactor = find(DSampSF >= 200);
        Fs = round(DSampSF(indSampfactor(end)));
        sampfactor = DS(indSampfactor(end));
         msgbox({['Orginal Sampling Rate:  ' num2str(SampFreq1) 'Hz'];...
            ['Down-Sampled Sampling Rate:  ' num2str(Fs) 'Hz']; ['Sampling Factor:  ' num2str(sampfactor) '']});
    end
%     while Fs < 200
%         errordlg('Use a smaller downsampling factor','Error');
%         sampfactor = input('What factor would you want to use (Ex- 2,3,4,5,6,7,8): ');
%         Fs = round(SampFreq1/sampfactor);
%     end
    % Precise time stamps should be calculated here:
    EMG_TIMESTAMPS = Timestamps;
    EMG_SAMPLES = samples;
    %Set up EMG filters    
    [Bhigh,Ahigh]=ellip(7,1,60, EMG_Fc/(SampFreq1/2),'high');  % Default setting implements high pass filter with 30hz cutoff
    %[Bhigh,Ahigh,Blow,Alow] = filterDefinition;
    waitbar(0.4,waithandle,'Filtering the EMG data ...'); 
    figure(waithandle),pause(0.2),
    filtered_samples = filter(Bhigh,Ahigh,EMG_SAMPLES);
    % OPTIONAL lowpass filter for EMG signals
    if EMG_lowpass_enable>0
        [EMG_Blow,EMG_Alow] = ellip(7,1,60, EMG_LP_Fc/(SampFreq1/2));   % Default is OFF
        filtered_samples = filter(EMG_Blow,EMG_Alow, filtered_samples);
    end
    % Optional 60Hz Notch Filter
    if EMG_Notch_enable > 0
        woB = 60/(SampFreq1/2);
        [B_EMG_Notch,A_EMG_Notch] =  iirnotch(woB, woB/35);   % Default is OFF
        filtered_samples = filter(B_EMG_Notch,A_EMG_Notch, filtered_samples);
    end
    EMG_TIMESTAMPS = EMG_TIMESTAMPS(1:sampfactor:end);
    EMG_SAMPLES = filtered_samples(1:sampfactor:end);
elseif isequal(FileFlag, 4) % ASCII - EMZA    
    waitbar(0.6,waithandle,' Converting EMG from ASCII format to Matlab dataformat ...');
    figure(waithandle),pause(0.2)
    SampFreq1 = 200;
    exactLow = (exactLow + 7200 * SampFreq1 * (BoundIndex - 1));
    exactHi = (exactLow + exactHi - 1);

    % Code for extracting the data from the ASCII files:
    fileA = fopen(filename);
    tempSampAtext = textscan(fileA, '%s',1);
    tempSampAnum = textscan(fileA, '%f %f', 'delimiter', '"');
    SampA = tempSampAnum{1,2}(:);
    clear tempSampAtext tempSampAnum
    fclose(fileA);

    filenameB = strrep(filename, '-1', '-2');  % Automatically determines the name of the 2nd file of the pair.
    fileB = fopen(filenameB);
    tempSampBtext = textscan(fileB, '%s',1);
    tempSampBnum = textscan(fileB, '%f %f', 'delimiter', '"');
    SampB = tempSampBnum{1,2}(:);
    clear tempSampBtext tempSampBnum
    fclose(fileB);

    Samples = SampA - SampB;
    clear SampA SampB
    Samples = Samples(exactLow:exactHi);
    samples = double(Samples(:));
    clear Samples
    tStep = 1/SampFreq1;
    tLow = exactLow/SampFreq1;
    tHi = exactHi/SampFreq1;
    Timestamps = (tLow:tStep:tHi);
    sampfactor = 1;
   
    Fs = round(SampFreq1/sampfactor);
    % Confirming that the downsampling is not too low
    if BoundIndex == 1
        DS = (1:1:10);
        DSampSF = SampFreq1./DS;
        indSampfactor = find(DSampSF >= 200);
        Fs = round(DSampSF(indSampfactor(end)));
        sampfactor = DS(indSampfactor(end));
         msgbox({['Orginal Sampling Rate:  ' num2str(SampFreq1) 'Hz'];...
            ['Down-Sampled Sampling Rate:  ' num2str(Fs) 'Hz']; ['Sampling Factor:  ' num2str(sampfactor) '']});
    end
%     while Fs < 200
%         errordlg('Use a smaller downsampling factor','Error');
%         sampfactor = input('What factor would you want to use (Ex- 2,3,4,5,6,7,8): ');
%         Fs = round(SampFreq1/sampfactor);
%     end
    % Precise time stamps should be calculated here:
    EMG_TIMESTAMPS = Timestamps;
    EMG_SAMPLES = samples;
    %Set up EMG filters    
    [Bhigh,Ahigh]=ellip(7,1,60, EMG_Fc/(SampFreq1/2),'high');  % Default setting implements high pass filter with 30hz cutoff
    %[Bhigh,Ahigh,Blow,Alow] = filterDefinition;
    waitbar(0.4,waithandle,'Filtering the EMG data ...'); 
    figure(waithandle),pause(0.2),
    filtered_samples = filter(Bhigh,Ahigh,EMG_SAMPLES);
    % OPTIONAL lowpass filter for EMG signals
    if EMG_lowpass_enable>0
        [EMG_Blow,EMG_Alow] = ellip(7,1,60, EMG_LP_Fc/(SampFreq1/2));   % Default is OFF
        filtered_samples = filter(EMG_Blow,EMG_Alow, filtered_samples);
    end
    % Optional 60Hz Notch Filter
    if EMG_Notch_enable > 0
        woB = 60/(SampFreq1/2);
        [B_EMG_Notch,A_EMG_Notch] =  iirnotch(woB, woB/35);   % Default is OFF
        filtered_samples = filter(B_EMG_Notch,A_EMG_Notch, filtered_samples);
    end
    EMG_TIMESTAMPS = EMG_TIMESTAMPS(1:sampfactor:end);
    EMG_SAMPLES = filtered_samples(1:sampfactor:end);  

elseif isequal(FileFlag, 5) % Plexon
    channel = [];
    while isempty(channel)
        prompt={'Enter channel to be used for EMG:'};
        dlgTitle='EMG Channel Select';
        lineNo=1;
        answer = inputdlg(prompt,dlgTitle,lineNo);
        channel = str2double(answer{1,1});
        clear answer prompt dlgTitle lineNo
    end
    waitbar(0.1,waithandle,'Importing EMG data from Plexon PLX file ...');
    figure(waithandle),pause(0.2),
    [adfreq, ~, Timestamps, nsamp, Samples] = plx_ad_v(filename, channel);
    %[Timestamps,SF,Samples] = Nlx2MatCSC(filename,[1 0 1 0 1],0,4,[lowertimestamp uppertimestamp]);
    samples = double(Samples(:)');
    clear Samples
    SampFreq1 = adfreq;
    if BoundIndex == 1
        DS = (1:1:10);
        DSampSF = SampFreq1./DS;
        indSampfactor = find(DSampSF >= 600);
        Fs = round(DSampSF(indSampfactor(end)));
        sampfactor = DS(indSampfactor(end));
         msgbox({['Orginal Sampling Rate:  ' num2str(SampFreq1) 'Hz'];...
            ['Down-Sampled Sampling Rate:  ' num2str(Fs) 'Hz']; ['Sampling Factor:  ' num2str(sampfactor) '']});
    end
    % Precise time stamps should be calculated here:
    [EMG_TIMESTAMPS,EMG_SAMPLES] = generate_timestamps_from_Ncsfiles(Timestamps, samples, exactLow, exactHi, nsamp);
    % 'generate_timestamps...' converts the time for Neuralynx files to
    % seconds.  The next equation is used to correct the time stamps for
    % PLX files.
    EMG_TIMESTAMPS = EMG_TIMESTAMPS * 1000000;
    %Set up EMG filters    
    %  High pass filter for EMG signals
    [Bhigh,Ahigh]=ellip(7,1,60, EMG_Fc/(SampFreq1/2),'high');  % Default setting implements high pass filter with 30hz cutoff
    waitbar(0.4,waithandle,'Filtering the EMG data ...'); 
    figure(waithandle),pause(0.2),
    filtered_samples = filter(Bhigh,Ahigh,EMG_SAMPLES);
    % OPTIONAL lowpass filter for EMG signals
    if EMG_lowpass_enable>0
        [EMG_Blow,EMG_Alow] = ellip(7,1,60, EMG_LP_Fc/(SampFreq1/2));   % Default is OFF
        filtered_samples = filter(EMG_Blow,EMG_Alow, filtered_samples);
    end
    % Optional 60Hz Notch Filter
    if EMG_Notch_enable > 0
        woB = 60/(SampFreq1/2);
        [B_EMG_Notch,A_EMG_Notch] =  iirnotch(woB, woB/35);   % Default is OFF
        filtered_samples = filter(B_EMG_Notch,A_EMG_Notch, filtered_samples);
    end
    EMG_TIMESTAMPS = EMG_TIMESTAMPS(1:sampfactor:end);
    EMG_SAMPLES = filtered_samples(1:sampfactor:end);
end
clear filtered_samples samples SF

%  ******    EEG FILE extraction   *********
filename=get(handles.eegfile,'TooltipString');
lowertimestamp=LBounds(BoundIndex);
uppertimestamp=UBounds(BoundIndex);
if isequal(FileFlag, 2) % AD System
    try
        if EEG_CHANNEL <= 5
            [Timestamps,Samples,SF,Nsamp]=Crx2Mat(filename,lowertimestamp+EEG_CHANNEL-1,...
                uppertimestamp+EEG_CHANNEL-1);
        else % Channel 6 have timestamps skipped by 1 from channel 5, hence the offset changes
            [Timestamps,Samples,SF,Nsamp]=Crx2Mat(filename,lowertimestamp+EEG_CHANNEL,...
                uppertimestamp+EEG_CHANNEL);
        end
    catch 
        fprintf( 'There is an error in Crx2Mat function. Check values passed into the function \n' );
        rethrow(lasterror); %#ok<LERR>
    end
    waitbar(0.6,waithandle,' Converting EEG from Crextract format to Matlab dataformat ...');
    figure(waithandle),pause(0.2)
    samples=double(Samples(:)');
    clear Samples
    SampFreq1=SF;
    waitbar(0.8,waithandle,'Filtering the EEG data ...'); 
    figure(waithandle),pause(0.2),
    [EEG_TIMESTAMPS,EEG_SAMPLES]=Crxread(double(Timestamps),samples,sampfactor,Nsamp, exactLow, exactHi);
    [Blow,Alow]=ellip(7,1,60, EEG_Fc/(SampFreq2/2));           % Default setting implements low pass filter with 30hz cutoff
    filtered_samples=filter(Blow,Alow,EEG_SAMPLES/4);
    %  OPTIONAL highpass filter for EEG signals
    if EEG_highpass_enable>0
        [EEG_Bhi,EEG_Ahi] = ellip(7,1,60, EEG_HP_Fc/(SampFreq1/2),'high');   % Default is OFF
        filtered_samples = filter(EEG_Bhi,EEG_Ahi, filtered_samples);
    end
    %  OPTIONAL 60Hz Notch filter for EEG signals
    if EEG_Notch_enable > 0
        wo = 60/(SampFreq1/2);
        [B_EEG_Notch,A_EEG_Notch] =  iirnotch(wo, wo/35);   % Default is OFF
        filtered_samples = filter(B_EEG_Notch,A_EEG_Notch, filtered_samples);
    end
    EEG_TIMESTAMPS = EEG_TIMESTAMPS(1:sampfactor:end);
    EEG_SAMPLES = filtered_samples(1:sampfactor:end);
elseif isequal(FileFlag, 1) % Neuralynx System
    waitbar(0.6,waithandle,' Converting EEG from Neuralynx CSC to Matlab data ...');
    figure(waithandle),pause(0.2)
    [Timestamps,SF,Samples]=Nlx2MatCSC(filename,[1 0 1 0 1],0,4,[lowertimestamp uppertimestamp]);
    samples=double(Samples(:)');
    clear Samples
    SampFreq2=SF(1);
    %New IF statement:
    if BoundIndex == 1
        DS = (1:1:10);
        DSampSF = SampFreq2./DS;
        indSampfactor = find(DSampSF >= 1000);
        Fs2 = round(DSampSF(indSampfactor(end)));
        sampfactor2 = DS(indSampfactor(end));       
    end
   
    waitbar(0.8,waithandle,'Filtering the EEG data ...'); 
    figure(waithandle),pause(0.2),
    [EEG_TIMESTAMPS,EEG_SAMPLES] = generate_timestamps_from_Ncsfiles(Timestamps,samples, exactLow, exactHi, nsamp);
    physInput = 2;  %Needed to select proper error box in HeaderADBit.
    ADBit2uV = HeaderADBit(filename, physInput);    %Calls a function to extract the AD Bit Value.
    EEG_SAMPLES = EEG_SAMPLES * ADBit2uV;   %Convert EEG amplitude of signal from AD Bits to microvolts.
    %  Low pass filter for EEG signals
    [Blow,Alow]=ellip(7,1,60, EEG_Fc/(SampFreq2/2));           % Default setting implements low pass filter with 30hz cutoff
    filtered_samples=filter(Blow,Alow,EEG_SAMPLES);
    %  OPTIONAL highpass filter for EEG signals
    if EEG_highpass_enable>0
        [EEG_Bhi,EEG_Ahi] = ellip(7,1,60, EEG_HP_Fc/(SampFreq2/2),'high');   % Default is OFF
        filtered_samples = filter(EEG_Bhi,EEG_Ahi, filtered_samples);
    end
    %  OPTIONAL 60Hz Notch filter for EEG signals
    if EEG_Notch_enable > 0
        wo = 60/(SampFreq2/2);
        [B_EEG_Notch,A_EEG_Notch] =  iirnotch(wo, wo/35);   % Default is OFF
        filtered_samples = filter(B_EEG_Notch,A_EEG_Notch, filtered_samples);
    end
    EEG_TIMESTAMPS = EEG_TIMESTAMPS(1:sampfactor2:end);
    EEG_SAMPLES = filtered_samples(1:sampfactor2:end);
    clear physInput ADBit2uV
elseif isequal(FileFlag, 3) % ASCII - Polysmith
    waitbar(0.6,waithandle,' Converting EEG from ASCII format to Matlab dataformat ...');
    figure(waithandle),pause(0.2)

    SampFreq1 = 200;
    SampA = dlmread(filename);
    filenameB = strrep(filename, '-1', '-2');
    SampB = dlmread(filenameB);
    Samples = SampA - SampB;
    clear SampA SampB
    Samples = Samples(exactLow:exactHi);
    samples = double(Samples(:));
    clear Samples

    physInput = 2;  %Needed to select proper error box in HeaderADBit.
    samples = AsciiPolysmithADBit(filename, physInput, samples);    %Calls a function to convert from bit volts to uV.
    
    Fs = round(SampFreq1/sampfactor);
    waitbar(0.8,waithandle,'Filtering the EEG data ...'); 
    figure(waithandle),pause(0.2),
    EEG_TIMESTAMPS = Timestamps;
    EEG_SAMPLES = samples;
    [Blow,Alow]=ellip(7,1,60, EEG_Fc/(SampFreq1/2));
    filtered_samples=filter(Blow,Alow,EEG_SAMPLES);
    %  OPTIONAL highpass filter for EEG signals
    if EEG_highpass_enable>0
        [EEG_Bhi,EEG_Ahi] = ellip(7,1,60, EEG_HP_Fc/(SampFreq1/2),'high');   % Default is OFF
        filtered_samples = filter(EEG_Bhi,EEG_Ahi, filtered_samples);
    end
    %  OPTIONAL 60Hz Notch filter for EEG signals
    if EEG_Notch_enable > 0
        wo = 60/(SampFreq1/2);
        [B_EEG_Notch,A_EEG_Notch] =  iirnotch(wo, wo/35);   % Default is OFF
        filtered_samples = filter(B_EEG_Notch,A_EEG_Notch, filtered_samples);
    end
    EEG_TIMESTAMPS = EEG_TIMESTAMPS(1:sampfactor:end);
    EEG_SAMPLES = filtered_samples(1:sampfactor:end);
    
elseif isequal(FileFlag, 4) % ASCII - EMZA    
    waitbar(0.6,waithandle,' Converting EEG from ASCII format to Matlab dataformat ...');
    figure(waithandle),pause(0.2)
    SampFreq1 = 200;
    

    % Code for extracting the data from the ASCII files:
    fileA = fopen(filename);
    tempSampAtext = textscan(fileA, '%s',1);
    tempSampAnum = textscan(fileA, '%f %f', 'delimiter', '"');
    SampA = tempSampAnum{1,2}(:);
    clear tempSampAtext tempSampAnum
    fclose(fileA);

    filenameB = strrep(filename, '-1', '-2');  % Automatically determines the name of the 2nd file of the pair.
    fileB = fopen(filenameB);
    tempSampBtext = textscan(fileB, '%s',1);
    tempSampBnum = textscan(fileB, '%f %f', 'delimiter', '"');
    SampB = tempSampBnum{1,2}(:);
    clear tempSampBtext tempSampBnum
    fclose(fileB);
    
    Samples = SampA - SampB;
    clear SampA SampB
    Samples = Samples(exactLow:exactHi);
    samples = double(Samples(:));
    clear Samples
%     tStep = 1/SampFreq1;
%     tLow = exactLow/SampFreq1;
%     tHi = exactHi/SampFreq1;
%     
%     Timestamps = (tLow:tStep:tHi);
%     sampfactor = 1;
   
    Fs = round(SampFreq1/sampfactor);
    waitbar(0.8,waithandle,'Filtering the EEG data ...'); 
    figure(waithandle),pause(0.2),
    EEG_TIMESTAMPS = Timestamps;
    EEG_SAMPLES = samples;
    [Blow,Alow]=ellip(7,1,60, EEG_Fc/(SampFreq1/2));
    filtered_samples=filter(Blow,Alow,EEG_SAMPLES);
    %  OPTIONAL highpass filter for EEG signals
    if EEG_highpass_enable>0
        [EEG_Bhi,EEG_Ahi] = ellip(7,1,60, EEG_HP_Fc/(SampFreq1/2),'high');   % Default is OFF
        filtered_samples = filter(EEG_Bhi,EEG_Ahi, filtered_samples);
    end
    %  OPTIONAL 60Hz Notch filter for EEG signals
    if EEG_Notch_enable > 0
        wo = 60/(SampFreq1/2);
        [B_EEG_Notch,A_EEG_Notch] =  iirnotch(wo, wo/35);   % Default is OFF
        filtered_samples = filter(B_EEG_Notch,A_EEG_Notch, filtered_samples);
    end
    EEG_TIMESTAMPS = EEG_TIMESTAMPS(1:sampfactor:end);
    EEG_SAMPLES = filtered_samples(1:sampfactor:end);
    
elseif isequal(FileFlag, 5) % Plexon
    channel = [];
    while isempty(channel)
        prompt={'Enter channel to be used for EEG:'};
        dlgTitle='EEG Channel Select';
        lineNo=1;
        answer = inputdlg(prompt,dlgTitle,lineNo);
        channel = str2double(answer{1,1});
        clear answer prompt dlgTitle lineNo
    end
    waitbar(0.1,waithandle,'Importing EEG data from Plexon PLX file ...');
    figure(waithandle),pause(0.2),
    [adfreq, ~, Timestamps, nsamp, Samples] = plx_ad_v(filename, channel);
    %[Timestamps,SF,Samples] = Nlx2MatCSC(filename,[1 0 1 0 1],0,4,[lowertimestamp uppertimestamp]);
    samples = double(Samples(:)');
    clear Samples
    SampFreq2 = adfreq;
    Fs=round(SampFreq2/sampfactor);
    waitbar(0.8,waithandle,'Filtering the EEG data ...'); 
    figure(waithandle),pause(0.2),
    [EEG_TIMESTAMPS,EEG_SAMPLES] = generate_timestamps_from_Ncsfiles(Timestamps,samples, exactLow, exactHi, nsamp);
    % 'generate_timestamps...' converts the time for Neuralynx files to
    % seconds.  The next equation is used to correct the time stamps for
    % PLX files.
    EEG_TIMESTAMPS = EEG_TIMESTAMPS * 1000000;
    %  Low pass filter for EEG signals
    [Blow,Alow]=ellip(7,1,60, EEG_Fc/(SampFreq2/2));           % Default setting implements low pass filter with 30hz cutoff
    filtered_samples=filter(Blow,Alow,EEG_SAMPLES);
    %  OPTIONAL highpass filter for EEG signals
    if EEG_highpass_enable>0
        [EEG_Bhi,EEG_Ahi] = ellip(7,1,60, EEG_HP_Fc/(SampFreq2/2),'high');   % Default is OFF
        filtered_samples = filter(EEG_Bhi,EEG_Ahi, filtered_samples);
    end
    %  OPTIONAL 60Hz Notch filter for EEG signals
    if EEG_Notch_enable > 0
        wo = 60/(SampFreq2/2);
        [B_EEG_Notch,A_EEG_Notch] =  iirnotch(wo, wo/35);   % Default is OFF
        filtered_samples = filter(B_EEG_Notch,A_EEG_Notch, filtered_samples);
    end
    EEG_TIMESTAMPS = EEG_TIMESTAMPS(1:sampfactor:end);
    EEG_SAMPLES = filtered_samples(1:sampfactor:end);
end
clear filtered_samples samples SF
%freqVersusTimePowerMap(EEG_SAMPLES, Fs, EEG_Fc);

%  ******    INPUT3 FILE extraction   *********
if Input3_enable == 1
    filename=get(handles.Input3file,'TooltipString');
    lowertimestamp=LBounds(BoundIndex);
    uppertimestamp=UBounds(BoundIndex);
    if isequal(FileFlag, 2) % AD System
        try
            if INPUT3_CHANNEL <= 5
                [Timestamps,Samples,SF,Nsamp]=Crx2Mat(filename,lowertimestamp+INPUT3_CHANNEL-1,...
                    uppertimestamp+INPUT3_CHANNEL-1);
            else % Channel 6 have timestamps skipped by 1 from channel 5, hence the offset changes
                [Timestamps,Samples,SF,Nsamp]=Crx2Mat(filename,lowertimestamp+INPUT3_CHANNEL,...
                    uppertimestamp+INPUT3_CHANNEL);
            end
        catch 
            fprintf( 'There is an error in Crx2Mat function. Check values passed into the function \n' );
            rethrow(lasterror); %#ok<LERR>
        end
        waitbar(0.6,waithandle,' Converting INPUT 3 from Crextract format to Matlab dataformat ...');
        figure(waithandle),pause(0.2)
        samples=double(Samples(:)');
        clear Samples
        SampFreq1=SF;
        waitbar(0.8,waithandle,'Filtering INPUT 3 data ...'); 
        figure(waithandle),pause(0.2),
        [INPUT3_TIMESTAMPS,INPUT3_SAMPLES]=Crxread(double(Timestamps),samples,sampfactor,Nsamp, exactLow, exactHi);
        
        filtered_samples = INPUT3_SAMPLES/4;
        %  OPTIONAL highpass filter for Input 3 signals
        if Input3_HP_enable>0
            [Input3_Bhi,Input3_Ahi] = ellip(7,1,60, Input3_HP_Fc/(SampFreq1/2),'high');   % Default is OFF
            filtered_samples = filter(Input3_Bhi,Input3_Ahi, filtered_samples);
        end
        %  OPTIONAL lowpass filter for Input 3 signals
        if Input3_LP_enable>0
            [Input3_Blow,Input3_Alow] = ellip(7,1,60, Input3_LP_Fc/(SampFreq1/2));   % Default is OFF
            filtered_samples = filter(Input3_Blow,Input3_Alow, filtered_samples);
        end
        %  OPTIONAL 60Hz Notch filter for Input 3 signals
        if Input3_Notch_enable > 0
            wo = 60/(SampFreq1/2);
            [B_Input3_Notch,A_Input3_Notch] =  iirnotch(wo, wo/35);   % Default is OFF
            filtered_samples = filter(B_Input3_Notch,A_Input3_Notch, filtered_samples);
        end
        INPUT3_TIMESTAMPS = INPUT3_TIMESTAMPS(1:sampfactor:end);
        INPUT3_SAMPLES = filtered_samples(1:sampfactor:end);
    elseif isequal(FileFlag, 1) % Neuralynx System
        waitbar(0.6,waithandle,' Converting INPUT 3 from Neuralynx CSC to Matlab data ...');
        figure(waithandle),pause(0.2)
        [Timestamps,SF,Samples]=Nlx2MatCSC(filename,[1 0 1 0 1],0,4,[lowertimestamp uppertimestamp]);
        samples=double(Samples(:)');
        clear Samples
        SampFreq3=SF(1);
        %New IF statement:
        if BoundIndex == 1
            DS = (1:1:10);
            DSampSF = SampFreq3./DS;
            indSampfactor = find(DSampSF >= 1000);
            Fs3 = round(DSampSF(indSampfactor(end)));
            sampfactor3 = DS(indSampfactor(end));       
        end

        waitbar(0.8,waithandle,'Filtering INPUT 3 data ...'); 
        figure(waithandle),pause(0.2),
        [INPUT3_TIMESTAMPS,INPUT3_SAMPLES]=generate_timestamps_from_Ncsfiles(Timestamps,samples, exactLow, exactHi, nsamp);
        physInput = 3;  %Needed to select proper error box in HeaderADBit.
        ADBit2uV = HeaderADBit(filename, physInput);    %Calls a function to extract the AD Bit Value.
        INPUT3_SAMPLES = INPUT3_SAMPLES * ADBit2uV;   %Convert INPUT3 amplitude of signal from AD Bits to microvolts.
        filtered_samples = INPUT3_SAMPLES;
        %  OPTIONAL highpass filter for Input 3 signals
        if Input3_HP_enable>0
            [Input3_Bhi,Input3_Ahi] = ellip(7,1,60, Input3_HP_Fc/(SampFreq3/2),'high');   % Default is OFF
            filtered_samples = filter(Input3_Bhi,Input3_Ahi, filtered_samples);
        end
        %  OPTIONAL lowpass filter for Input 3 signals
        if Input3_LP_enable>0
            [Input3_Blow,Input3_Alow] = ellip(7,1,60, Input3_LP_Fc/(SampFreq3/2));   % Default is OFF
            filtered_samples = filter(Input3_Blow,Input3_Alow, filtered_samples);
        end
        %  OPTIONAL 60Hz Notch filter for Input 3 signals
        if Input3_Notch_enable > 0
            wo = 60/(SampFreq3/2);
            [B_Input3_Notch,A_Input3_Notch] =  iirnotch(wo, wo/35);   % Default is OFF
            filtered_samples = filter(B_Input3_Notch,A_Input3_Notch, filtered_samples);
        end
        INPUT3_TIMESTAMPS = INPUT3_TIMESTAMPS(1:sampfactor3:end);
        INPUT3_SAMPLES = filtered_samples(1:sampfactor3:end);
        clear physInput ADBit2uV
    elseif isequal(FileFlag, 3) % ASCII - Polysmith
        waitbar(0.6,waithandle,' Converting INPUT 3 from ASCII format to Matlab dataformat ...');
        figure(waithandle),pause(0.2)
        SampFreq1 = 200;
%         exactLow = (exactLow + 7200 * SampFreq1 * (BoundIndex - 1));
%         exactHi = (exactLow + exactHi - 1);
        SampA = dlmread(filename);
        filenameB = strrep(filename, '-1', '-2');
        SampB = dlmread(filenameB);
        Samples = SampA - SampB;
        clear SampA SampB
        Samples = Samples(exactLow:exactHi);
        samples = double(Samples(:));
        clear Samples
%         tStep = 1/SampFreq1;
%         tLow = exactLow/SampFreq1;
%         tHi = exactHi/SampFreq1;
%         Timestamps = (tLow:tStep:tHi);
%         sampfactor = 1;
        physInput = 3;  %Needed to select proper error box in HeaderADBit.
        samples = AsciiPolysmithADBit(filename, physInput, samples);    %Calls a function to convert from bit volts to uV.
    
        Fs = round(SampFreq1/sampfactor);
        waitbar(0.8,waithandle,'Filtering INPUT 3 data ...'); 
        figure(waithandle),pause(0.2),
        INPUT3_TIMESTAMPS = Timestamps;
        INPUT3_SAMPLES = samples;
             
        filtered_samples = INPUT3_SAMPLES;
        %  OPTIONAL highpass filter for Input 3 signals
        if Input3_HP_enable>0
            [Input3_Bhi,Input3_Ahi] = ellip(7,1,60, Input3_HP_Fc/(SampFreq1/2),'high');   % Default is OFF
            filtered_samples = filter(Input3_Bhi,Input3_Ahi, filtered_samples);
        end
        %  OPTIONAL lowpass filter for Input 3 signals
        if Input3_LP_enable>0
            [Input3_Blow,Input3_Alow] = ellip(7,1,60, Input3_LP_Fc/(SampFreq1/2));   % Default is OFF
            filtered_samples = filter(Input3_Blow,Input3_Alow, filtered_samples);
        end
        %  OPTIONAL 60Hz Notch filter for Input 3 signals
        if Input3_Notch_enable > 0
            wo = 60/(SampFreq1/2);
            [B_Input3_Notch,A_Input3_Notch] =  iirnotch(wo, wo/35);   % Default is OFF
            filtered_samples = filter(B_Input3_Notch,A_Input3_Notch, filtered_samples);
        end
        INPUT3_TIMESTAMPS = INPUT3_TIMESTAMPS(1:sampfactor:end);
        INPUT3_SAMPLES = filtered_samples(1:sampfactor:end);
    
    elseif isequal(FileFlag, 4) % ASCII - EMZA
        waitbar(0.6,waithandle,' Converting INPUT 3 from ASCII format to Matlab dataformat ...');
        figure(waithandle),pause(0.2)
        SampFreq1 = 200;
%         exactLow = (exactLow + 7200 * SampFreq1 * (BoundIndex - 1));
%         exactHi = (exactLow + exactHi - 1);
        % Code for extracting the data from the ASCII files:
        fileA = fopen(filename);
        tempSampAtext = textscan(fileA, '%s',1);
        tempSampAnum = textscan(fileA, '%f %f', 'delimiter', '"');
        SampA = tempSampAnum{1,2}(:);
        clear tempSampAtext tempSampAnum
        fclose(fileA);

        filenameB = strrep(filename, '-1', '-2');  % Automatically determines the name of the 2nd file of the pair.
        fileB = fopen(filenameB);
        tempSampBtext = textscan(fileB, '%s',1);
        tempSampBnum = textscan(fileB, '%f %f', 'delimiter', '"');
        SampB = tempSampBnum{1,2}(:);
        clear tempSampBtext tempSampBnum
        fclose(fileB);
        
        Samples = SampA - SampB;
        clear SampA SampB
        Samples = Samples(exactLow:exactHi);
        samples = double(Samples(:));
        clear Samples

        Fs = round(SampFreq1/sampfactor);
        waitbar(0.8,waithandle,'Filtering INPUT 3 data ...'); 
        figure(waithandle),pause(0.2),
        INPUT3_TIMESTAMPS = Timestamps;
        INPUT3_SAMPLES = samples;
     
        filtered_samples = INPUT3_SAMPLES;

        %  OPTIONAL highpass filter for Input 3 signals
        if Input3_HP_enable>0
            [Input3_Bhi,Input3_Ahi] = ellip(7,1,60, Input3_HP_Fc/(SampFreq1/2),'high');   % Default is OFF
            filtered_samples = filter(Input3_Bhi,Input3_Ahi, filtered_samples);
        end
        %  OPTIONAL lowpass filter for Input 3 signals
        if Input3_LP_enable>0
            [Input3_Blow,Input3_Alow] = ellip(7,1,60, Input3_LP_Fc/(SampFreq1/2));   % Default is OFF
            filtered_samples = filter(Input3_Blow,Input3_Alow, filtered_samples);
        end
        %  OPTIONAL 60Hz Notch filter for Input 3 signals
        if Input3_Notch_enable > 0
            wo = 60/(SampFreq1/2);
            [B_Input3_Notch,A_Input3_Notch] =  iirnotch(wo, wo/35);   % Default is OFF
            filtered_samples = filter(B_Input3_Notch,A_Input3_Notch, filtered_samples);
        end
        INPUT3_TIMESTAMPS = INPUT3_TIMESTAMPS(1:sampfactor:end);
        INPUT3_SAMPLES = filtered_samples(1:sampfactor:end);
    
    elseif isequal(FileFlag, 5) % Plexon
        channel = [];
        while isempty(channel)
            prompt={'Enter channel to be used for Input 3:'};
            dlgTitle='Input 3 Channel Select';
            lineNo=1;
            answer = inputdlg(prompt,dlgTitle,lineNo);
            channel = str2double(answer{1,1});
            clear answer prompt dlgTitle lineNo
        end
        waitbar(0.1,waithandle,'Importing INPUT 3 data from Plexon PLX file ...');
        figure(waithandle),pause(0.2),
        [adfreq, ~, Timestamps, nsamp, Samples] = plx_ad_v(filename, channel);
        %[Timestamps,SF,Samples] = Nlx2MatCSC(filename,[1 0 1 0 1],0,4,[lowertimestamp uppertimestamp]);
        samples = double(Samples(:)');
        clear Samples
        SampFreq3 = adfreq;
        clear adfreq
        Fs=round(SampFreq3/sampfactor);
        waitbar(0.8,waithandle,'Filtering INPUT 3 data ...'); 
        figure(waithandle),pause(0.2),
        [INPUT3_TIMESTAMPS,INPUT3_SAMPLES]=generate_timestamps_from_Ncsfiles(Timestamps,samples, exactLow, exactHi, nsamp);
        
        % 'generate_timestamps...' converts the time for Neuralynx files to
        % seconds.  The next equation is used to correct the time stamps for
        % PLX files.
        INPUT3_TIMESTAMPS = INPUT3_TIMESTAMPS * 1000000;

        %  OPTIONAL highpass filter for Input 3 signals
        if Input3_HP_enable>0
            [Input3_Bhi,Input3_Ahi] = ellip(7,1,60, Input3_HP_Fc/(SampFreq3/2),'high');   % Default is OFF
            INPUT3_SAMPLES = filter(Input3_Bhi,Input3_Ahi, INPUT3_SAMPLES);
        end
        %  OPTIONAL lowpass filter for Input 3 signals
        if Input3_LP_enable>0
            [Input3_Blow,Input3_Alow] = ellip(7,1,60, Input3_LP_Fc/(SampFreq3/2));   % Default is OFF
            INPUT3_SAMPLES = filter(Input3_Blow,Input3_Alow, INPUT3_SAMPLES);
        end
        %  OPTIONAL 60Hz Notch filter for Input 3 signals
        if Input3_Notch_enable > 0
            wo = 60/(SampFreq3/2);
            [B_Input3_Notch,A_Input3_Notch] =  iirnotch(wo, wo/35);   % Default is OFF
            INPUT3_SAMPLES = filter(B_Input3_Notch,A_Input3_Notch, INPUT3_SAMPLES);
        end
        INPUT3_TIMESTAMPS = INPUT3_TIMESTAMPS(1:sampfactor:end);
        INPUT3_SAMPLES = INPUT3_SAMPLES(1:sampfactor:end);  
    end
clear filtered_samples samples SF
end

%  ******    INPUT4 FILE extraction   *********
if Input4_enable>0
    filename=get(handles.Input4file,'TooltipString');
    lowertimestamp=LBounds(BoundIndex);
    uppertimestamp=UBounds(BoundIndex);
    if isequal(FileFlag, 2) % AD System
        try
            if INPUT4_CHANNEL <= 5
                [Timestamps,Samples,SF,Nsamp]=Crx2Mat(filename,lowertimestamp+INPUT4_CHANNEL-1,...
                    uppertimestamp+INPUT4_CHANNEL-1);
            else % Channel 6 have timestamps skipped by 1 from channel 5, hence the offset changes
                [Timestamps,Samples,SF,Nsamp]=Crx2Mat(filename,lowertimestamp+INPUT4_CHANNEL,...
                    uppertimestamp+INPUT4_CHANNEL);
            end
        catch 
            fprintf( 'There is an error in Crx2Mat function. Check values passed into the function \n' );
            rethrow(lasterror); %#ok<LERR>
        end
        waitbar(0.6,waithandle,' Converting INPUT 4 from Crextract format to Matlab dataformat ...');
        figure(waithandle),pause(0.2)
        samples=double(Samples(:)');
        clear Samples
        SampFreq1=SF;
        waitbar(0.8,waithandle,'Filtering INPUT 4 data ...'); 
        figure(waithandle),pause(0.2),
        [INPUT4_TIMESTAMPS,INPUT4_SAMPLES]=Crxread(double(Timestamps),samples,sampfactor,Nsamp, exactLow, exactHi);
        filtered_samples = INPUT4_SAMPLES/4;
        %  OPTIONAL highpass filter for Input 4 signals
        if Input4_HP_enable>0
            [Input4_Bhi,Input4_Ahi] = ellip(7,1,60, Input4_HP_Fc/(SampFreq1/2),'high');   % Default is OFF
            filtered_samples = filter(Input4_Bhi,Input4_Ahi, filtered_samples);
        end
        %  OPTIONAL lowpass filter for Input 4 signals
        if Input4_LP_enable>0
            [Input4_Blow,Input4_Alow] = ellip(7,1,60, Input4_LP_Fc/(SampFreq1/2));   % Default is OFF
            filtered_samples = filter(Input4_Blow,Input4_Alow, filtered_samples);
        end
        %  OPTIONAL 60Hz Notch filter for Input 4 signals
        if Input4_Notch_enable > 0
            wo = 60/(SampFreq1/2);
            [B_Input4_Notch,A_Input4_Notch] =  iirnotch(wo, wo/35);   % Default is OFF
            filtered_samples = filter(B_Input4_Notch,A_Input4_Notch, filtered_samples);
        end
        INPUT4_TIMESTAMPS = INPUT4_TIMESTAMPS(1:sampfactor:end);
        INPUT4_SAMPLES = filtered_samples(1:sampfactor:end);
    elseif isequal(FileFlag, 1) % Neuralynx System
        waitbar(0.6,waithandle,' Converting INPUT 4 from Neuralynx CSC to Matlab data ...');
        figure(waithandle),pause(0.2)
        [Timestamps,SF,Samples]=Nlx2MatCSC(filename,[1 0 1 0 1],0,4,[lowertimestamp uppertimestamp]);
        samples=double(Samples(:)');
        clear Samples
        SampFreq4=SF(1);
        
        %New IF statement:
        if BoundIndex == 1
            DS = (1:1:10);
            DSampSF = SampFreq4./DS;
            indSampfactor = find(DSampSF >= 1000);
            Fs4 = round(DSampSF(indSampfactor(end)));
            sampfactor4 = DS(indSampfactor(end));       
        end
        
        waitbar(0.8,waithandle,'Filtering INPUT 4 data ...'); 
        figure(waithandle),pause(0.2),
        [INPUT4_TIMESTAMPS,INPUT4_SAMPLES] = generate_timestamps_from_Ncsfiles(Timestamps,samples, exactLow, exactHi, nsamp);
        physInput = 4;  %Needed to select proper error box in HeaderADBit.
        ADBit2uV = HeaderADBit(filename, physInput);    %Calls a function to extract the AD Bit Value.
        INPUT4_SAMPLES = INPUT4_SAMPLES * ADBit2uV;   %Convert INPUT4 amplitude of signal from AD Bits to microvolts.
        filtered_samples = INPUT4_SAMPLES;

        %  OPTIONAL highpass filter for Input 4 signals
        if Input4_HP_enable>0
            [Input4_Bhi,Input4_Ahi] = ellip(7,1,60, Input4_HP_Fc/(SampFreq4/2),'high');   % Default is OFF
            filtered_samples = filter(Input4_Bhi,Input4_Ahi, filtered_samples);
        end
        %  OPTIONAL lowpass filter for Input 4 signals
        if Input4_LP_enable>0
            [Input4_Blow,Input4_Alow] = ellip(7,1,60, Input4_LP_Fc/(SampFreq4/2));   % Default is OFF
            filtered_samples = filter(Input4_Blow,Input4_Alow, filtered_samples);
        end
        %  OPTIONAL 60Hz Notch filter for Input 4 signals
        if Input4_Notch_enable > 0
            wo = 60/(SampFreq4/2);
            [B_Input4_Notch,A_Input4_Notch] =  iirnotch(wo, wo/35);   % Default is OFF
            filtered_samples = filter(B_Input4_Notch,A_Input4_Notch, filtered_samples);
        end
        INPUT4_TIMESTAMPS = INPUT4_TIMESTAMPS(1:sampfactor4:end);
        INPUT4_SAMPLES = filtered_samples(1:sampfactor4:end);
        clear physInput ADBit2uV
    elseif isequal(FileFlag, 3) % ASCII - Polysmith
        waitbar(0.6,waithandle,' Converting INPUT 4 from ASCII format to Matlab dataformat ...');
        figure(waithandle),pause(0.2)
        SampFreq1 = 200;
%         exactLow = (exactLow + 7200 * SampFreq1 * (BoundIndex - 1));
%         exactHi = (exactLow + exactHi - 1);
        SampA = dlmread(filename);
        filenameB = strrep(filename, '-1', '-2');
        SampB = dlmread(filenameB);
        Samples = SampA - SampB;
        clear SampA SampB
        Samples = Samples(exactLow:exactHi);
        samples = double(Samples(:));
        clear Samples
%         tStep = 1/SampFreq1;
%         tLow = exactLow/SampFreq1;
%         tHi = exactHi/SampFreq1;
%         Timestamps = (tLow:tStep:tHi);
%         sampfactor = 1;
        physInput = 4;  %Needed to select proper error box in HeaderADBit.
        samples = AsciiPolysmithADBit(filename, physInput, samples);    %Calls a function to convert from bit volts to uV.
    
        Fs = round(SampFreq1/sampfactor);
        waitbar(0.8,waithandle,'Filtering INPUT 4 data ...'); 
        figure(waithandle),pause(0.2),
        INPUT4_TIMESTAMPS = Timestamps;
        INPUT4_SAMPLES = samples;
             
        filtered_samples = INPUT4_SAMPLES;
        %  OPTIONAL highpass filter for Input 4 signals
        if Input4_HP_enable>0
            [Input4_Bhi,Input4_Ahi] = ellip(7,1,60, Input4_HP_Fc/(SampFreq1/2),'high');   % Default is OFF
            filtered_samples = filter(Input4_Bhi,Input4_Ahi, filtered_samples);
        end
        %  OPTIONAL lowpass filter for Input 4 signals
        if Input4_LP_enable>0
            [Input4_Blow,Input4_Alow] = ellip(7,1,60, Input4_LP_Fc/(SampFreq1/2));   % Default is OFF
            filtered_samples = filter(Input4_Blow,Input4_Alow, filtered_samples);
        end
        %  OPTIONAL 60Hz Notch filter for Input 4 signals
        if Input4_Notch_enable > 0
            wo = 60/(SampFreq1/2);
            [B_Input4_Notch,A_Input4_Notch] =  iirnotch(wo, wo/35);   % Default is OFF
            filtered_samples = filter(B_Input4_Notch,A_Input4_Notch, filtered_samples);
        end
        INPUT4_TIMESTAMPS = INPUT4_TIMESTAMPS(1:sampfactor:end);
        INPUT4_SAMPLES = filtered_samples(1:sampfactor:end);

    elseif isequal(FileFlag, 4) % ASCII - EMZA
        waitbar(0.6,waithandle,' Converting INPUT 4 from ASCII format to Matlab dataformat ...');
        figure(waithandle),pause(0.2)
        SampFreq1 = 200;

        % Code for extracting the data from the ASCII files:
        fileA = fopen(filename);
        tempSampAtext = textscan(fileA, '%s',1);
        tempSampAnum = textscan(fileA, '%f %f', 'delimiter', '"');
        SampA = tempSampAnum{1,2}(:);
        clear tempSampAtext tempSampAnum
        fclose(fileA);

        filenameB = strrep(filename, '-1', '-2');  % Automatically determines the name of the 2nd file of the pair.
        fileB = fopen(filenameB);
        tempSampBtext = textscan(fileB, '%s',1); %#ok<*NASGU>
        tempSampBnum = textscan(fileB, '%f %f', 'delimiter', '"');
        SampB = tempSampBnum{1,2}(:);
        clear tempSampBtext tempSampBnum
        fclose(fileB);

        Samples = SampA - SampB;
        clear SampA SampB
        Samples = Samples(exactLow:exactHi);
        samples = double(Samples(:));
        clear Samples
%         tStep = 1/SampFreq1;
%         tLow = exactLow/SampFreq1;
%         tHi = exactHi/SampFreq1;
%         Timestamps = (tLow:tStep:tHi);
%         sampfactor = 1;

        Fs = round(SampFreq1/sampfactor);
        waitbar(0.8,waithandle,'Filtering INPUT 4 data ...'); 
        figure(waithandle),pause(0.2),
        INPUT4_TIMESTAMPS = Timestamps;
        INPUT4_SAMPLES = samples;

        filtered_samples = INPUT4_SAMPLES;
        %  OPTIONAL highpass filter for Input 4 signals
        if Input4_HP_enable>0
            [Input4_Bhi,Input4_Ahi] = ellip(7,1,60, Input4_HP_Fc/(SampFreq1/2),'high');   % Default is OFF
            filtered_samples = filter(Input4_Bhi,Input4_Ahi, filtered_samples);
        end
        %  OPTIONAL lowpass filter for Input 4 signals
        if Input4_LP_enable>0
            [Input4_Blow,Input4_Alow] = ellip(7,1,60, Input4_LP_Fc/(SampFreq1/2));   % Default is OFF
            filtered_samples = filter(Input4_Blow,Input4_Alow, filtered_samples);
        end
        %  OPTIONAL 60Hz Notch filter for Input 4 signals
        if Input4_Notch_enable > 0
            wo = 60/(SampFreq1/2);
            [B_Input4_Notch,A_Input4_Notch] =  iirnotch(wo, wo/35);   % Default is OFF
            filtered_samples = filter(B_Input4_Notch,A_Input4_Notch, filtered_samples);
        end
        INPUT4_TIMESTAMPS = INPUT4_TIMESTAMPS(1:sampfactor:end);
        INPUT4_SAMPLES = filtered_samples(1:sampfactor:end);
    
    elseif isequal(FileFlag, 5) % Plexon
        channel = [];
        while isempty(channel)
            prompt={'Enter channel to be used for Input 4:'};
            dlgTitle='Input 4 Channel Select';
            lineNo=1;
            answer = inputdlg(prompt,dlgTitle,lineNo);
            channel = str2double(answer{1,1});
            clear answer prompt dlgTitle lineNo
        end
        waitbar(0.1,waithandle,'Importing INPUT 4 data from Plexon PLX file ...');
        figure(waithandle),pause(0.2),
        [adfreq, ~, Timestamps, nsamp, Samples] = plx_ad_v(filename, channel);
        %[Timestamps,SF,Samples] = Nlx2MatCSC(filename,[1 0 1 0 1],0,4,[lowertimestamp uppertimestamp]);
        samples = double(Samples(:)');
        clear Samples
        SampFreq4 = adfreq;
        clear adfreq
        Fs=round(SampFreq4/sampfactor);
        waitbar(0.8,waithandle,'Filtering INPUT 3 data ...'); 
        figure(waithandle),pause(0.2),
        [INPUT4_TIMESTAMPS,INPUT4_SAMPLES]=generate_timestamps_from_Ncsfiles(Timestamps,samples, exactLow, exactHi, nsamp);
        
        % 'generate_timestamps...' converts the time for Neuralynx files to
        % seconds.  The next equation is used to correct the time stamps for
        % PLX files.
        INPUT4_TIMESTAMPS = INPUT4_TIMESTAMPS * 1000000;

        %  OPTIONAL highpass filter for Input 3 signals
        if Input4_HP_enable>0
            [Input4_Bhi,Input4_Ahi] = ellip(7,1,60, Input4_HP_Fc/(SampFreq4/2),'high');   % Default is OFF
            INPUT4_SAMPLES = filter(Input4_Bhi,Input4_Ahi, INPUT4_SAMPLES);
        end
        %  OPTIONAL lowpass filter for Input 4 signals
        if Input4_LP_enable>0
            [Input4_Blow,Input4_Alow] = ellip(7,1,60, Input4_LP_Fc/(SampFreq4/2));   % Default is OFF
            INPUT4_SAMPLES = filter(Input4_Blow,Input4_Alow, INPUT4_SAMPLES);
        end
        %  OPTIONAL 60Hz Notch filter for Input 4 signals
        if Input4_Notch_enable > 0
            wo = 60/(SampFreq4/2);
            [B_Input4_Notch,A_Input4_Notch] =  iirnotch(wo, wo/35);   % Default is OFF
            INPUT4_SAMPLES = filter(B_Input4_Notch,A_Input4_Notch, INPUT4_SAMPLES);
        end
        INPUT4_TIMESTAMPS = INPUT4_TIMESTAMPS(1:sampfactor:end);
        INPUT4_SAMPLES = INPUT4_SAMPLES(1:sampfactor:end);  
    
    end
clear filtered_samples samples SF
end

waitbar(1,waithandle, 'Finished converting.. Now Loading the data ..');
figure(waithandle), pause(0.2);
close(waithandle)

% Initialize the variables for further access
st_power=[];dt_ratio=[];P_emg=[];
P_delta=[]; P_theta=[];P_sigma=[];
EPOCH_StartPoint=1; INDEX=1; 
TRACKING_INDEX=1;
TRAINEDEPOCH_INDEX=[];
%****************This is where the program is defining array lengths in the
%beginning based on 10 second epochs. It will need to be changed.
all_arraylength=ceil((double(EEG_TIMESTAMPS(end))-double(EEG_TIMESTAMPS(1)))/10);
EPOCHnum=zeros(all_arraylength,1); EPOCHtime=ones(all_arraylength,1);
EPOCHstate=[repmat('N',all_arraylength,1) repmat('S',all_arraylength,1)];
viewStates;
%freqVersusTimePowerMap;

%##########################################################################
function emgfile_open_Callback(hObject, eventdata, handles)

working_dir=pwd;
current_dir='C:\SleepData\Datafiles';
cd(current_dir);
[filename, pathname] = uigetfile({'*.dat;*.ascii;*.ncs;*.emg;*.stim',...
        'All data files (*.ascii, *.dat, *.emg, *.ncs, *.stim)'},'Pick an EMG data file');
if isequal(filename,0) || isequal(pathname,0)
    uiwait(errordlg('You need to select a file. Please press the button again',...
        'ERROR','modal'));
    cd(working_dir);
else
    cd(working_dir);
    emgfile= fullfile(pathname, filename);
    set(handles.emgfile,'string',filename);
    set(handles.emgfile,'Tooltipstring',emgfile);
end
% #####################################################################
function eegfile_open_Callback(hObject, eventdata, handles) %#ok<*INUSL>

working_dir=pwd;
current_dir='C:\SleepData\Datafiles';
cd(current_dir);
[filename, pathname] = uigetfile({'*.dat;*.ascii;*.ncs;*.eeg;',...
        'All data files (*.dat, *.ascii, *.ncs, *.eeg)'}, 'Pick an EEG data file');
if isequal(filename,0) || isequal(pathname,0)
    uiwait(errordlg('You need to select a file. Please press the button again',...
        'ERROR','modal'));
    cd(working_dir);
else
    cd(working_dir);
    eegfile= fullfile(pathname, filename);
    set(handles.eegfile,'string',filename);
    set(handles.eegfile,'Tooltipstring',eegfile); 
end
% #####################################################################
function input3file_open_Callback(hObject, eventdata, handles)

working_dir=pwd;
current_dir='C:\SleepData\Datafiles';
cd(current_dir);
[filename, pathname] = uigetfile({'*.dat;*.ascii;*.ncs;*.eeg;',...
        'All data files (*.dat, *.ascii, *.ncs, *.eeg)'}, 'Pick a file for Input 3');
if isequal(filename,0) || isequal(pathname,0)
    uiwait(errordlg('You need to select a file. Please press the button again',...
        'ERROR','modal'));
    cd(working_dir);
else
    cd(working_dir);
    Input3file= fullfile(pathname, filename);
    set(handles.Input3file,'string',filename);
    set(handles.Input3file,'Tooltipstring',Input3file); 
end
% #####################################################################
function input4file_open_Callback(hObject, eventdata, handles)

working_dir=pwd;
current_dir='C:\SleepData\Datafiles';
cd(current_dir);
[filename, pathname] = uigetfile({'*.dat;*.ascii;*.ncs;*.eeg;',...
        'All data files (*.dat, *.ascii, *.ncs, *.eeg)'}, 'Pick a file for Input 4');
if isequal(filename,0) || isequal(pathname,0)
    uiwait(errordlg('You need to select a file. Please press the button again',...
        'ERROR','modal'));
    cd(working_dir);
else
    cd(working_dir);
    Input4file= fullfile(pathname, filename);
    set(handles.Input4file,'string',filename);
    set(handles.Input4file,'Tooltipstring',Input4file); 
end
% #####################################################################
function manualScored_open_Callback(hObject, eventdata, handles)
global scoreFileCorrectionType
working_dir=pwd;
current_dir='C:\SleepData\Results';
cd(current_dir);
[filename, pathname] = uigetfile('*.xls', 'Pick the manually scored file you want to correct.');
if isequal(filename,0) || isequal(pathname,0)
    uiwait(errordlg('You need to select a file. Please try loading file again',...
        'ERROR','modal'));
    cd(working_dir);
else
    cd(working_dir);
    manualScoredFullPathName= fullfile(pathname, filename);
    statusScoredFile = xlsfinfo(manualScoredFullPathName);  % Completes the file name for the header file and checks to see if it exists
    if isempty(statusScoredFile)
        uiwait(errordlg('The manually scored file is not in Excel 1997-2003 format. Please try loading file again',...
        'ERROR','modal'));
    else
        set(handles.autoscoredfile,'string',filename);
        set(handles.autoscoredfile,'Tooltipstring',manualScoredFullPathName);
        scoredFileType='Manually Scored';  % Sets the label string to reflect the file type that will be corrected
        scoreFileCorrectionType = 0;  % Variable set to direct to loading a manually scored file
        set(handles.ScoredFileType,'String', scoredFileType);  % Loads the label string to the 'ScoredFileType' field on the GUI

        % Load the settings from when the file was scored using the header file
        % that was created.  The settings can be over-ruled before loading the
        % file for correction.
        savedHeaderFile = regexprep(manualScoredFullPathName, '.xls', '');  % Removes Excel extension from the manual scored file name
        statusHeaderFile = xlsfinfo([savedHeaderFile 'Header.xls']);  % Completes the file name for the header file and checks to see if it exists
        if isempty(statusHeaderFile)
            uiwait(errordlg('The header file associated with the manually scored file . Please try loading file again',...
            'ERROR','modal'));
        else  % The header exists and is in Excel format.
            savedHeadrFiltrs = xlsread([savedHeaderFile 'Header.xls'],'b1:y1')';  % Read in the setting value from the manually scored file.
            if savedHeadrFiltrs(1) ~= -1
                EMG_Fc = savedHeadrFiltrs(1);
                set(handles.EMG_cutoff, 'String', EMG_Fc);
            end
            if savedHeadrFiltrs(3) ~= -1
                EMG_LP_Fc = savedHeadrFiltrs(3);
                set(handles.EMG_Lowpass_cutoff, 'String', EMG_LP_Fc);
                EMG_lowpass_enable = 1;
                set(handles.EMG_LP_checkbox, 'Value',1);
            end
            if savedHeadrFiltrs(5) ~= -1
                EMG_Notch_enable=1;
                set(handles.Notch60EMG, 'Value',1);
            end
            if savedHeadrFiltrs(7) ~= -1
                EEG_Fc = savedHeadrFiltrs(7);
                set(handles.EEG_cutoff, 'String', EEG_Fc);
            end
            if savedHeadrFiltrs(9) ~= -1
                EEG_HP_Fc = savedHeadrFiltrs(9);
                set(handles.EEG_Highpass_cutoff, 'String', EEG_HP_Fc);
                EEG_highpass_enable=1;
                set(handles.EEG_Highpass_checkbox, 'Value',1);
            end
            if savedHeadrFiltrs(11) ~= -1
                EEG_Notch_enable=1;
                set(handles.Notch60, 'Value',1);
            end
            if (savedHeadrFiltrs(13)~= -1||savedHeadrFiltrs(15)~= -1||savedHeadrFiltrs(17)~= -1)
                Input3_enable = 1;
                set(handles.Input3_checkbox, 'Value',1);
            end
            if savedHeadrFiltrs(13) ~= -1
                Input3_HP_Fc = savedHeadrFiltrs(13);
                set(handles.Input3_Highpass_cutoff, 'String', Input3_HP_Fc);
                Input3_HP_enable = 1;
                set(handles.Input3_HP_checkbox, 'Value',1);
            end
            if savedHeadrFiltrs(15) ~= -1
                Input3_LP_Fc = savedHeadrFiltrs(15);
                set(handles.Input3_Lowpass_cutoff, 'String', Input3_LP_Fc);
                Input3_LP_enable = 1;
                set(handles.Input3_LP_checkbox, 'Value',1);
            end
            if savedHeadrFiltrs(17) ~= -1
                Input3_Notch_enable = 1;
                set(handles.Notch60Input3, 'Value',1);
            end
            if (savedHeadrFiltrs(19)~= -1||savedHeadrFiltrs(21)~= -1||savedHeadrFiltrs(23)~= -1)
                Input4_enable = 1;
                set(handles.Input4_checkbox, 'Value',1);
            end
            if savedHeadrFiltrs(19) ~= -1
                Input4_HP_Fc = savedHeadrFiltrs(19);
                set(handles.Input4_Highpass_cutoff, 'String', Input4_HP_Fc);
                Input4_HP_enable = 1;
                set(handles.Input4_HP_checkbox, 'Value',1);
            end
            if savedHeadrFiltrs(21) ~= -1
                Input4_LP_Fc = savedHeadrFiltrs(21);
                set(handles.Input4_Lowpass_cutoff, 'String', Input4_LP_Fc);
                Input4_LP_enable = 1;
                set(handles.Input4_LP_checkbox, 'Value',1);
            end
            if savedHeadrFiltrs(23) ~= -1
                Input4_Notch_enable = 1;
                set(handles.Notch60Input4, 'Value',1);
            end
        end
        clear statusHeaderFile
    end
    clear statusScoredFile
end
% #####################################################################
function timestampfile_open_Callback(hObject, eventdata, handles)

working_dir=pwd;
current_dir='C:\SleepData\Timestampfiles';
cd(current_dir);
[filename, pathname] = uigetfile('*.xls', 'Pick the timestamp file for these datafiles');
if isequal(filename,0) || isequal(pathname,0)
    uiwait(errordlg('You need to select a file. Please press the button again',...
        'ERROR','modal'));
    cd(working_dir);
else
    cd(working_dir);
    timestampfile= fullfile(pathname, filename);
    statusTimeStampFile = xlsfinfo(timestampfile);
    if isempty(statusTimeStampFile)
        uiwait(errordlg('The time stamp file is not in Excel 1997-2003 format. Please try loading file again',...
        'ERROR','modal'));
    else
        set(handles.tstampsfile,'string',filename);
        set(handles.tstampsfile,'Tooltipstring',timestampfile);
    end
end
% #####################################################################
function autoscoredfile_open_Callback(hObject, eventdata, handles)
global scoreFileCorrectionType
working_dir=pwd;
current_dir='C:\SleepData\Results';
cd(current_dir);
[filename, pathname] = uigetfile('*.xls', 'Pick an Auto-Scored File');
if isequal(filename,0) || isequal(pathname,0)
    uiwait(errordlg('You need to select a file. Please press the button again',...
        'ERROR','modal'));
    cd(working_dir);
else
    cd(working_dir);
    autoscoredfile= fullfile(pathname, filename);
    statusScoredFile = xlsfinfo(autoscoredfile);  % Checks to see if it exists
    if isempty(statusScoredFile)
        uiwait(errordlg('The manually scored file is not in Excel 1997-2003 format. Please try loading file again',...
        'ERROR','modal'));
    else
        set(handles.autoscoredfile,'string',filename);
        set(handles.autoscoredfile,'Tooltipstring',autoscoredfile);
        scoredFileType='Auto-Scored';  % Sets the label string to reflect the file type that will be corrected
        scoreFileCorrectionType = 1;  % Variable set to direct to loading an auto-scored file
        set(handles.ScoredFileType,'String', scoredFileType);  % Loads the label string to the 'ScoredFileType' field on the GUI
    end
    clear statusScoredFile
end
% #####################################################################
function loadDataForTraining_Callback(hObject, eventdata, handles)

global EPOCHSIZE EMG_TIMESTAMPS EEG_TIMESTAMPS EMG_SAMPLES EEG_SAMPLES...
    EPOCHSIZEOF10sec EPOCHtime ISRECORDED TRACKING_INDEX ...
    EPOCHstate STATE EPOCH_StartPoint EPOCH_shiftsize INDEX Sleepstates...
    EPOCHnum TRAINEDEPOCH_INDEX EEG_CHANNEL EMG_CHANNEL FileFlag
global LBounds UBounds BoundIndex LO_INDEX P_emg P_delta P_theta P_sigma Statecolors 
global EMG_Fc EMG_Notch_enable EEG_Fc EEG_highpass_enable EEG_HP_Fc EEG_Notch_enable EMG_lowpass_enable EMG_LP_Fc
global Input3_enable Input3_LP_enable Input3_LP_Fc Input3_Notch_enable Input3_HP_enable Input3_HP_Fc INPUT3_TIMESTAMPS INPUT3_SAMPLES INPUT3_CHANNEL
global Input4_enable Input4_HP_enable Input4_HP_Fc Input4_Notch_enable Input4_LP_enable Input4_LP_Fc INPUT4_TIMESTAMPS INPUT4_SAMPLES INPUT4_CHANNEL
global exactLowIndx exactHiIndx epochVal epochScoringSize
cwd = pwd;
cd(tempdir);
cd(cwd);
%whitebg(gcf,[.165,.465,.665]) %Remove percent to execute change in chart background color.

% *********** Timestamps extraction *********
filename=get(handles.tstampsfile,'TooltipString');
current_dir=pwd;
[path,name,ext]=fileparts(filename);
% We use DOS command to copy the file to the current dir... and then work
% with XLSREAD on it. After reading it, move it back to the original dir..
% copy_expression=['copy ' filename ' ' current_dir '\' name ext]; 
% dos(copy_expression);
try
    [tbounds]=xlsread(filename);
%     [tbounds]=xlsread(strcat(name,ext));
catch %#ok<*CTCH>
    uiwait(errordlg('Check if the file is saved in Microsoft Excel format.','ERROR','modal'));
end
% del_expression=['del ' current_dir '\' name ext];
% dos(del_expression);

switch FileFlag
    case 0
        uiwait(errordlg('Please select a FILE FORMAT first','ERROR','modal'));    
    case 1    % Neuralynx
        terminate = 0;
    case 2    % AD System
        % To ensure that user has selected the channel numbers of EEG /EMG files
        if isempty(EEG_CHANNEL)
            terminate = 1;
            uiwait(errordlg('Please right click on EEG/EMG filenames and select their channel.',...
                'ERROR','modal'));
        else
            terminate = 0;
        end
    % The ASCII version may need to be modified for your particular set-up.    
    case 3    % ASCII - Polysmith
        terminate = 0; 
    case 4    % ASCII - EMZA
        terminate = 0;
    case 5    % Plexon
        terminate = 0;
end

while terminate == 0
    LBounds=tbounds(1:end,1);      % Lowerbounds array
    UBounds=tbounds(1:end,2);      % Upperbounds array         
    exactLowIndx = tbounds(1:end,3);
    exactHiIndx = tbounds(1:end,4);
    BoundIndex=1;
    sectionword=strcat('Section ',num2str( BoundIndex));
    set(handles.sectiontext,'string',sectionword);
    
    [uppertimestamp,lowertimestamp] = extract_samples_timestamps_from_datafile;
    fprintf('filextraction now \n');
    ISRECORDED=0;
    % Get the 10 sec EPOCHSIZE to work without user selecting the default.
    index=find(double(EMG_TIMESTAMPS(1))+9.99 < EMG_TIMESTAMPS...
        & EMG_TIMESTAMPS < double(EMG_TIMESTAMPS(1))+10.001);
    difference=double(EMG_TIMESTAMPS(index(1):index(end)))-(double(EMG_TIMESTAMPS(1))+10);
    [minimum,ind]=min(abs(difference));
    try
        EPOCHSIZE=index(ind);
    catch
        fprintf( 'There is an error in calculating the EPOCHSIZE of 10sec in loadData_for_training function \n' );
    end
    EPOCHSIZEOF10sec=EPOCHSIZE;
    EPOCH_shiftsize=40;
    set(handles.epochSizeMenu,'Value',2); % Set the epochSizeMenu to 10sec epoch
    epochVal = 2;
    epochScoringSize = 0;
    plot_epochdata_on_axes_in_GUI;
    
    % Setting the slider arrow and trough step EPOCHSIZEOF10sec
    slider_step(1)=0.01188;
    slider_step(2)=0.09509;
    set(handles.slider1,'sliderstep',slider_step);
    working_dir=pwd;
    current_dir='C:\SleepData\Results';
    cd(current_dir);
    if isempty(get(handles.trainingfile,'string')) == 1
        [filename,pathname] = uiputfile('TR_file.xls','Save training file as:');
    else
        file=get(handles.trainingfile,'string');
        [filename,pathname] = uiputfile(file,'Save training file in correct folder:');
    end
    set(handles.trainingfile,'string',filename);
    cd(working_dir);
    newname=strcat(pathname,filename);
    fid=fopen(newname,'w');
    fprintf(fid,'Index');
    fprintf(fid,'\t');        
    fprintf(fid,'Timestamp ');
    fprintf(fid,'\t');
    fprintf(fid,'State');
    fprintf(fid,'\n');
    fclose(fid);
    %Write the filter info to file here:
    headrFiltrs = regexprep(newname, '.xls', '');
    headrFiltrs = [headrFiltrs 'Header.xls']; %#ok<AGROW>
    fid2=fopen(headrFiltrs,'w');
    fprintf(fid2,'EMG HP:');
    fprintf(fid2,'\t');
    fprintf(fid2, num2str(EMG_Fc));
    fprintf(fid2,'\t');
    if EMG_lowpass_enable > 0 
        fprintf(fid2,'EMG LP:');
        fprintf(fid2,'\t');
        fprintf(fid2, num2str(EMG_LP_Fc));
    else
        fprintf(fid2,'EMG LP:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    if EMG_Notch_enable > 0 
        fprintf(fid2,'EMG Notch:');
        fprintf(fid2,'\t');
        fprintf(fid2,'60');
    else
        fprintf(fid2,'EMG Notch:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    fprintf(fid2,'EEG LP:');
    fprintf(fid2,'\t');
    fprintf(fid2, num2str(EEG_Fc));
    fprintf(fid2,'\t');
    if EEG_highpass_enable > 0 
        fprintf(fid2,'EEG HP:');
        fprintf(fid2,'\t');
        fprintf(fid2, num2str(EEG_HP_Fc));
    else
        fprintf(fid2,'EEG HP:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    if EEG_Notch_enable > 0 
        fprintf(fid2,'EEG Notch:');
        fprintf(fid2,'\t');
        fprintf(fid2,'60');
    else
        fprintf(fid2,'EEG Notch:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    if Input3_HP_enable > 0 
        fprintf(fid2,'Input3 HP:');
        fprintf(fid2,'\t');
        fprintf(fid2, num2str(Input3_HP_Fc));
    else
        fprintf(fid2,'Input3 HP:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    if Input3_LP_enable > 0 
        fprintf(fid2,'Input3 LP:');
        fprintf(fid2,'\t');
        fprintf(fid2, num2str(Input3_LP_Fc));
    else
        fprintf(fid2,'Input3 LP:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    if Input3_Notch_enable > 0 
        fprintf(fid2,'Input3 Notch:');
        fprintf(fid2,'\t');
        fprintf(fid2,'60');
    else
        fprintf(fid2,'Input3 Notch:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    if Input4_HP_enable > 0 
        fprintf(fid2,'Input4 HP:');
        fprintf(fid2,'\t');
        fprintf(fid2, num2str(Input4_HP_Fc));
    else
        fprintf(fid2,'Input4 HP:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    if Input4_LP_enable > 0 
        fprintf(fid2,'Input4 LP:');
        fprintf(fid2,'\t');
        fprintf(fid2, num2str(Input4_LP_Fc));
    else
        fprintf(fid2,'Input4 LP:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    if Input4_Notch_enable > 0 
        fprintf(fid2,'Input4 Notch:');
        fprintf(fid2,'\t');
        fprintf(fid2,'60');
    else
        fprintf(fid2,'Input4 Notch:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    fprintf(fid2,'0');
    fprintf(fid2,'\n');
    fclose(fid2);
    set(handles.trainingfile,'TooltipString',newname);
    set(handles.loadnplot_datafiles,'Visible','on');
    DisplayStateColors;
    terminate = 1;
end
set(handles.fileSelectionMenu,'visible','off')
% #####################################################################
function loadDataForCorrection_Callback(hObject, eventdata, handles)

global EPOCHSIZE EMG_TIMESTAMPS EEG_TIMESTAMPS EMG_SAMPLES EEG_SAMPLES EPOCHSIZEOF10sec EPOCHtime ISRECORDED TRACKING_INDEX ...
    EPOCHstate STATE EPOCH_StartPoint EPOCH_shiftsize INDEX Sleepstates EPOCHnum TRAINEDEPOCH_INDEX SAVED_index POW_IND...
    LBounds UBounds BoundIndex LO_INDEX newname pathname Statecolors EMG_CHANNEL EEG_CHANNEL FileFlag...
    INPUT3_TIMESTAMPS INPUT3_SAMPLES INPUT4_TIMESTAMPS INPUT4_SAMPLES Input3_enable Input4_enable...
	exactLowIndx exactHiIndx exactLowerTS exactUpperTS tbounds scoreFileCorrectionType...
    EMG_Fc EMG_Notch_enable EEG_Fc EEG_highpass_enable EEG_HP_Fc EEG_Notch_enable EMG_lowpass_enable EMG_LP_Fc...
    Input3_LP_enable Input3_LP_Fc Input3_Notch_enable Input3_HP_enable Input3_HP_Fc INPUT3_CHANNEL...
    Input4_HP_enable Input4_HP_Fc Input4_Notch_enable Input4_LP_enable Input4_LP_Fc INPUT4_CHANNEL

cwd = pwd;
cd(tempdir);
%pack;
cd(cwd);
%whitebg(gcf,[.165,.465,.665])

switch FileFlag
    case 0
        uiwait(errordlg('Please select a FILE FORMAT first','ERROR','modal'));    
    case 1    % Neuralynx
        terminate = 0;
    case 2    % AD System
        % To ensure that user has selected the channel numbers of EEG /EMG files
        if isempty(EEG_CHANNEL)
            terminate = 1;
            uiwait(errordlg('Please right click on EEG/EMG filenames and select their channel.',...
                'ERROR','modal'));
        else
            terminate = 0;
        end
    % The ASCII version may need to be modified for your particular set-up.    
    case 3    % ASCII - Polysmith
        terminate = 0;  
    case 4    % ASCII - EMZA
        terminate = 0; 
    case 5    % Plexon
        terminate = 0;
end

while terminate == 0
    BoundIndex=1;
    sectionword=strcat('Section ',num2str(BoundIndex));
    set(handles.sectiontext,'string',sectionword);
    
    % *********** Timestamps extraction *********
    filename=get(handles.tstampsfile,'TooltipString');
    current_dir=pwd;
    [path,name,ext]=fileparts(filename);
    % We use DOS command to copy the file to the current dir... and then work
    % with XLSREAD on it. After reading it, move it back to the original dir..
%     copy_expression=['copy ' filename ' ' current_dir '\' name ext]; 
%     dos(copy_expression);
    % try
    [tbounds]=xlsread(filename);
%     [tbounds]=xlsread(strcat(name,ext));
    % catch
    %     uiwait(errordlg('Check if the file is saved in Microsoft Excel format.',...
    %         'ERROR','modal'));
    % end
%     del_expression=['del ' current_dir '\' name ext];
%     dos(del_expression);

    LBounds=tbounds(1:end,1);       % Lowerbounds array
    UBounds=tbounds(1:end,2);       % Upperbounds array    
    exactLowIndx = tbounds(1:end,3);
    exactHiIndx = tbounds(1:end,4);
    % Extract data from the datafile for the given timestamps
    [uppertimestamp,lowertimestamp]=extract_samples_timestamps_from_datafile;
    ISRECORDED=1;
    
    set(handles.loadnplot_datafiles,'Visible','off');
    set(handles.load_nextsection_savedfile,'Visible','on');
    %set(handles.sectionmenu,'Visible','on');
    
    warning off MATLAB:mir_warning_variable_used_as_function
    currentdate=date;
    prompt={'Enter your name:','Enter the date you are correcting the file on:'};
    def={'Name',currentdate};
    dlgTitle='Input for file management';
    lineNo=1;
    answer=inputdlg(prompt,dlgTitle,lineNo,def);
    name=char(answer(1,:));
    %date=char(answer(2,:));
    
    filename=get(handles.autoscoredfile,'TooltipString');
    [path,name1,ext]=fileparts(filename);
    newname=strcat(path,'\C_',name1,'_',name(1),currentdate,ext);
    fid=fopen(newname,'w');
    fprintf(fid,'Name:\t');
    fprintf(fid,'%s\t',name);
    fprintf(fid,'Date:\t');
    fprintf(fid,'%s\n',date);
    fprintf(fid,'Index');
    fprintf(fid,'\t');        
    fprintf(fid,'Timestamp ');
    fprintf(fid,'\t');
    fprintf(fid,'State\n');
    fclose(fid);
    
    %Need to seperate this code out as a subfunction when time permits
    headrFiltrs = regexprep(newname, '.xls', '');
    headrFiltrs = [headrFiltrs 'Header.xls']; %#ok<AGROW>
    fid2=fopen(headrFiltrs,'w');
    fprintf(fid2,'EMG HP:');
    fprintf(fid2,'\t');
    fprintf(fid2, num2str(EMG_Fc));
    fprintf(fid2,'\t');
    if EMG_lowpass_enable > 0 
        fprintf(fid2,'EMG LP:');
        fprintf(fid2,'\t');
        fprintf(fid2, num2str(EMG_LP_Fc));
    else
        fprintf(fid2,'EMG LP:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    if EMG_Notch_enable > 0 
        fprintf(fid2,'EMG Notch:');
        fprintf(fid2,'\t');
        fprintf(fid2,'60');
    else
        fprintf(fid2,'EMG Notch:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    fprintf(fid2,'EEG LP:');
    fprintf(fid2,'\t');
    fprintf(fid2, num2str(EEG_Fc));
    fprintf(fid2,'\t');
    if EEG_highpass_enable > 0 
        fprintf(fid2,'EEG HP:');
        fprintf(fid2,'\t');
        fprintf(fid2, num2str(EEG_HP_Fc));
    else
        fprintf(fid2,'EEG HP:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    if EEG_Notch_enable > 0 
        fprintf(fid2,'EEG Notch:');
        fprintf(fid2,'\t');
        fprintf(fid2,'60');
    else
        fprintf(fid2,'EEG Notch:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    if Input3_HP_enable > 0 
        fprintf(fid2,'Input3 HP:');
        fprintf(fid2,'\t');
        fprintf(fid2, num2str(Input3_HP_Fc));
    else
        fprintf(fid2,'Input3 HP:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    if Input3_LP_enable > 0 
        fprintf(fid2,'Input3 LP:');
        fprintf(fid2,'\t');
        fprintf(fid2, num2str(Input3_LP_Fc));
    else
        fprintf(fid2,'Input3 LP:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    if Input3_Notch_enable > 0 
        fprintf(fid2,'Input3 Notch:');
        fprintf(fid2,'\t');
        fprintf(fid2,'60');
    else
        fprintf(fid2,'Input3 Notch:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    if Input4_HP_enable > 0 
        fprintf(fid2,'Input4 HP:');
        fprintf(fid2,'\t');
        fprintf(fid2, num2str(Input4_HP_Fc));
    else
        fprintf(fid2,'Input4 HP:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    if Input4_LP_enable > 0 
        fprintf(fid2,'Input4 LP:');
        fprintf(fid2,'\t');
        fprintf(fid2, num2str(Input4_LP_Fc));
    else
        fprintf(fid2,'Input4 LP:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    if Input4_Notch_enable > 0 
        fprintf(fid2,'Input4 Notch:');
        fprintf(fid2,'\t');
        fprintf(fid2,'60');
    else
        fprintf(fid2,'Input4 Notch:');
        fprintf(fid2,'\t');
        fprintf(fid2,'-1');
    end
    fprintf(fid2,'\t');
    fprintf(fid2,'0');
    fprintf(fid2,'\n');
    fclose(fid2);
    
    
    exactLowerTS = tbounds(BoundIndex,5);
    exactUpperTS = tbounds(BoundIndex,6);
    %  Reading in the states,tstamps & Index from the SAVED excel file 
    data_tstamp_read(exactLowerTS,exactUpperTS);
    %  Get the 10 sec EPOCHSIZE to work without user selecting the default.
    index=find(double(EMG_TIMESTAMPS(1))+9.99 < EMG_TIMESTAMPS...
        & EMG_TIMESTAMPS < double(EMG_TIMESTAMPS(1))+10.001);
    difference=double(EMG_TIMESTAMPS(index(1):index(end)))-(double(EMG_TIMESTAMPS(1))+10);
    [minimum,ind]=min(abs(difference));
    try
        EPOCHSIZE=index(ind);
    catch %#ok<CTCH>
        fprintf( 'There is an error in calculating the EPOCHSIZE of 10sec in loadData_for_correction function \n' );
    end
    EPOCHSIZEOF10sec=EPOCHSIZE;
    EPOCH_shiftsize=35;
    set(handles.epochSizeMenu,'value',2); % Set the epochSizeMenu to 10sec epoch
    
    numEpochsInSectionOfEMG = floor(size(EMG_TIMESTAMPS,1)/EPOCHSIZEOF10sec);
    numEpochsInSectionOfScoredFile = size(EPOCHtime,1);
    if numEpochsInSectionOfScoredFile < numEpochsInSectionOfEMG
        EPOCHnum = EPOCHnum(1:end-1,:);
        EPOCHstate = EPOCHstate(1:end-1,:);
        EPOCHtime = EPOCHtime(1:end-1,:);
        SAVED_index = SAVED_index(1:end-1,:);
        for i=numEpochsInSectionOfScoredFile:numEpochsInSectionOfEMG
            EPOCHnum = [EPOCHnum;7];
            EPOCHstate = [EPOCHstate; 'NS'];
            tempEpochTimePointIndex = 1+ ((i-1)*EPOCHSIZEOF10sec);
            EPOCHtime= [EPOCHtime;EMG_TIMESTAMPS(tempEpochTimePointIndex)];
            SAVED_index = [SAVED_index; i]; % Adjusts the vector to include the added indeterminant states
        end
    end
    plot_epochdata_on_axes_in_GUI;
    statenum(EPOCHstate(INDEX,:));
    set(handles.scoredstate,'String',Sleepstates(EPOCHnum(INDEX),:));
    DisplayStateColors;
    terminate = 1;
end
set(handles.fileSelectionMenu,'visible','off')
% #####################################################################
function[]=statenum(state)
% This function is called from this M-file from all the callback functions
% to assign appropriate numbers to the scored state
global EPOCHnum INDEX

switch state
    case 'AW'
        EPOCHnum(INDEX)=1;
    case 'QS'
        EPOCHnum(INDEX)=2;
    case 'RE'
        EPOCHnum(INDEX)=3;
    case 'QW'
        EPOCHnum(INDEX)=4;
    case 'UH'
        EPOCHnum(INDEX)=5;
    case 'TR'
        EPOCHnum(INDEX)=6;
    case 'NS'
        EPOCHnum(INDEX)=7;
    case 'IW'
        EPOCHnum(INDEX)=8;    
end
% #######################################################################
function eeg_cb1_Callback(hObject, eventdata, handles)
global EEG_CHANNEL 

EEG_CHANNEL = 1;
SetEegChannelsOff
set(gcbo,'Checked','ON');
% #######################################################################
function eeg_cb2_Callback(hObject, eventdata, handles)
global EEG_CHANNEL 

EEG_CHANNEL = 2;
SetEegChannelsOff
set(gcbo,'Checked','ON');
% #######################################################################
function eeg_cb3_Callback(hObject, eventdata, handles)
global EEG_CHANNEL 

EEG_CHANNEL = 3;
SetEegChannelsOff
set(gcbo,'Checked','ON');
% #######################################################################
function eeg_cb4_Callback(hObject, eventdata, handles)
global EEG_CHANNEL 

EEG_CHANNEL = 4;
SetEegChannelsOff
set(gcbo,'Checked','ON');
% #######################################################################
function eeg_cb5_Callback(hObject, eventdata, handles)
global EEG_CHANNEL 

EEG_CHANNEL = 5;
SetEegChannelsOff
set(gcbo,'Checked','ON');
% #######################################################################
function emg_cb1_Callback(hObject, eventdata, handles)
global EMG_CHANNEL 

EMG_CHANNEL = 1;
SetEmgChannelsOff
set(gcbo,'Checked','ON');
% #######################################################################
function emg_cb2_Callback(hObject, eventdata, handles)
global EMG_CHANNEL 

EMG_CHANNEL = 2;
SetEmgChannelsOff
set(gcbo,'Checked','ON');
% #######################################################################
function emg_cb3_Callback(hObject, eventdata, handles)
global EMG_CHANNEL 

EMG_CHANNEL = 3;
SetEmgChannelsOff
set(gcbo,'Checked','ON');
% #######################################################################
function emg_cb4_Callback(hObject, eventdata, handles)
global EMG_CHANNEL 

EMG_CHANNEL = 4;
SetEmgChannelsOff
set(gcbo,'Checked','ON');
% #######################################################################
function emg_cb5_Callback(hObject, eventdata, handles)
global EMG_CHANNEL 

EMG_CHANNEL = 5;
SetEmgChannelsOff
set(gcbo,'Checked','ON');
% #######################################################################
function eeg_cb6_Callback(hObject, eventdata, handles)
global EEG_CHANNEL 

EEG_CHANNEL = 6;
SetEegChannelsOff
set(gcbo,'Checked','ON');
% #######################################################################
function eeg_cb7_Callback(hObject, eventdata, handles)
global EEG_CHANNEL 

EEG_CHANNEL = 7;
SetEegChannelsOff
set(gcbo,'Checked','ON');
% #######################################################################
function eeg_cb8_Callback(hObject, eventdata, handles)
global EEG_CHANNEL 

EEG_CHANNEL = 8;
SetEegChannelsOff
set(gcbo,'Checked','ON');
% #######################################################################
function emg_cb6_Callback(hObject, eventdata, handles)
global EMG_CHANNEL 

EMG_CHANNEL = 6;
SetEmgChannelsOff
set(gcbo,'Checked','ON');
% #######################################################################
function emg_cb7_Callback(hObject, eventdata, handles)
global EMG_CHANNEL 

EMG_CHANNEL = 7;
SetEmgChannelsOff
set(gcbo,'Checked','ON');
% #######################################################################
function emg_cb8_Callback(hObject, eventdata, handles)
global EMG_CHANNEL 

EMG_CHANNEL = 8;
SetEmgChannelsOff
set(gcbo,'Checked','ON');
% --------------------------------------------------------------------
function Input_3_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function Input_4_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function input3_cb1_Callback(hObject, eventdata, handles)
global INPUT3_CHANNEL 
INPUT3_CHANNEL = 1;
SetINPUT3ChannelsOff
set(gcbo,'Checked','ON');
% --------------------------------------------------------------------
function input3_cb2_Callback(hObject, eventdata, handles)
global INPUT3_CHANNEL 
INPUT3_CHANNEL = 2;
SetINPUT3ChannelsOff
set(gcbo,'Checked','ON');
% --------------------------------------------------------------------
function input3_cb3_Callback(hObject, eventdata, handles)
global INPUT3_CHANNEL 
INPUT3_CHANNEL = 3;
SetINPUT3ChannelsOff
set(gcbo,'Checked','ON');
% --------------------------------------------------------------------
function input3_cb4_Callback(hObject, eventdata, handles)
global INPUT3_CHANNEL 
INPUT3_CHANNEL = 4;
SetINPUT3ChannelsOff
set(gcbo,'Checked','ON');
% --------------------------------------------------------------------
function input3_cb5_Callback(hObject, eventdata, handles)
global INPUT3_CHANNEL 
INPUT3_CHANNEL = 5;
SetINPUT3ChannelsOff
set(gcbo,'Checked','ON');
% --------------------------------------------------------------------
function input3_cb6_Callback(hObject, eventdata, handles)
global INPUT3_CHANNEL 
INPUT3_CHANNEL = 6;
SetINPUT3ChannelsOff
set(gcbo,'Checked','ON');
% --------------------------------------------------------------------
function input3_cb7_Callback(hObject, eventdata, handles)
global INPUT3_CHANNEL 
INPUT3_CHANNEL = 7;
SetINPUT3ChannelsOff
set(gcbo,'Checked','ON');
% --------------------------------------------------------------------
function input3_cb8_Callback(hObject, eventdata, handles)
global INPUT3_CHANNEL 
INPUT3_CHANNEL = 8;
SetINPUT3ChannelsOff
set(gcbo,'Checked','ON');
% --------------------------------------------------------------------
function input4_cb1_Callback(hObject, eventdata, handles)
global INPUT4_CHANNEL 
INPUT4_CHANNEL = 1;
SetINPUT4ChannelsOff
set(gcbo,'Checked','ON');
% --------------------------------------------------------------------
function input4_cb2_Callback(hObject, eventdata, handles)
global INPUT4_CHANNEL 
INPUT4_CHANNEL = 2;
SetINPUT4ChannelsOff
set(gcbo,'Checked','ON');
% --------------------------------------------------------------------
function input4_cb3_Callback(hObject, eventdata, handles)
global INPUT4_CHANNEL 
INPUT4_CHANNEL = 3;
SetINPUT4ChannelsOff
set(gcbo,'Checked','ON');
% --------------------------------------------------------------------
function input4_cb4_Callback(hObject, eventdata, handles)
global INPUT4_CHANNEL 
INPUT4_CHANNEL = 4;
SetINPUT4ChannelsOff
set(gcbo,'Checked','ON');
% --------------------------------------------------------------------
function input4_cb5_Callback(hObject, eventdata, handles)
global INPUT4_CHANNEL 
INPUT4_CHANNEL = 5;
SetINPUT4ChannelsOff
set(gcbo,'Checked','ON');
% --------------------------------------------------------------------
function input4_cb6_Callback(hObject, eventdata, handles)
global INPUT4_CHANNEL 
INPUT4_CHANNEL = 6;
SetINPUT4ChannelsOff
set(gcbo,'Checked','ON');
% --------------------------------------------------------------------
function input4_cb7_Callback(hObject, eventdata, handles)
global INPUT4_CHANNEL 
INPUT4_CHANNEL = 7;
SetINPUT4ChannelsOff
set(gcbo,'Checked','ON');
% --------------------------------------------------------------------
function input4_cb8_Callback(hObject, eventdata, handles)
global INPUT4_CHANNEL 
INPUT4_CHANNEL = 8;
SetINPUT4ChannelsOff
set(gcbo,'Checked','ON');
% --------------------------------------------------------------------
function input3_channel_menu_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function input4_channel_menu_Callback(hObject, eventdata, handles)
% #######################################################################
function SetEegChannelsOff()

handles=guihandles(sleepscorer);
set(handles.eeg_cb1,'Checked','OFF');set(handles.eeg_cb2,'Checked','OFF');
set(handles.eeg_cb3,'Checked','OFF');set(handles.eeg_cb4,'Checked','OFF');
set(handles.eeg_cb5,'Checked','OFF');set(handles.eeg_cb6,'Checked','OFF');
set(handles.eeg_cb7,'Checked','OFF');set(handles.eeg_cb8,'Checked','OFF');
% #######################################################################
function SetEmgChannelsOff()

handles=guihandles(sleepscorer);
set(handles.emg_cb1,'Checked','OFF');set(handles.emg_cb2,'Checked','OFF');
set(handles.emg_cb3,'Checked','OFF');set(handles.emg_cb4,'Checked','OFF');
set(handles.emg_cb5,'Checked','OFF');set(handles.emg_cb6,'Checked','OFF');
set(handles.emg_cb7,'Checked','OFF');set(handles.emg_cb8,'Checked','OFF');
%##########################################################################
function SetINPUT3ChannelsOff()

handles=guihandles(sleepscorer);
set(handles.input3_cb1,'Checked','OFF');set(handles.input3_cb2,'Checked','OFF');
set(handles.input3_cb3,'Checked','OFF');set(handles.input3_cb4,'Checked','OFF');
set(handles.input3_cb5,'Checked','OFF');set(handles.input3_cb6,'Checked','OFF');
set(handles.input3_cb7,'Checked','OFF');set(handles.input3_cb8,'Checked','OFF');
%##########################################################################
function SetINPUT4ChannelsOff()

handles=guihandles(sleepscorer);
set(handles.input4_cb1,'Checked','OFF');set(handles.input4_cb2,'Checked','OFF');
set(handles.input4_cb3,'Checked','OFF');set(handles.input4_cb4,'Checked','OFF');
set(handles.input4_cb5,'Checked','OFF');set(handles.input4_cb6,'Checked','OFF');
set(handles.input4_cb7,'Checked','OFF');set(handles.input4_cb8,'Checked','OFF');
%##########################################################################
function checkbox1_Callback(hObject, eventdata, handles)

function emg_channel_menu_Callback(hObject,eventdata,handles)
%##########################################################################
%               CODE FOR INITIALIZING VARIABLES
%
% --- Executes on button press in Set_pushbutton.
function Set_pushbutton_Callback(hObject, eventdata, handles)
global D_lo D_hi T_lo T_hi S_lo S_hi B_lo B_hi
global EEG_Fc EMG_Fc EEG_highpass_enable EEG_Notch_enable EMG_Notch_enable EMG_lowpass_enable
global Input3_enable Input3_LP_enable Input3_Notch_enable Input3_HP_enable
global Input4_enable Input4_HP_enable Input4_Notch_enable Input4_LP_enable

D_lo = 0.4; set(handles.Delta_lo, 'String', D_lo);
D_hi = 4; set(handles.Delta_hi, 'String', D_hi);
T_lo = 5; set(handles.Theta_lo, 'String', T_lo);
T_hi = 9; set(handles.Theta_hi, 'String', T_hi);
S_lo = 10; set(handles.Sigma_lo, 'String', S_lo);
S_hi = 14; set(handles.Sigma_hi, 'String', S_hi);
B_lo = 15; set(handles.Beta_lo, 'String', B_lo);
B_hi = 20; set(handles.Beta_hi, 'String', B_hi);

EEG_Fc = 30; set(handles.EEG_cutoff, 'String', EEG_Fc);
EEG_highpass_enable=0; set(handles.EEG_Highpass_checkbox, 'Value', 0);
EEG_Notch_enable=0; set(handles.Notch60, 'Value', 0);

EMG_Fc = 30; set(handles.EMG_cutoff, 'String', EMG_Fc);
EMG_Notch_enable=0; set(handles.Notch60EMG, 'Value', 0);
EMG_lowpass_enable=0; set(handles.EMG_LP_checkbox, 'Value', 0);

Input3_enable=0; set(handles.Input3_checkbox, 'Value', 0);
Input3_HP_enable=0; set(handles.Input3_HP_checkbox, 'Value', 0);
Input3_LP_enable=0; set(handles.Input3_LP_checkbox, 'Value', 0);
Input3_Notch_enable=0; set(handles.Notch60Input3, 'Value', 0);

Input4_enable=0; set(handles.Input4_checkbox, 'Value', 0);
Input4_HP_enable=0; set(handles.Input4_HP_checkbox, 'Value', 0);
Input4_LP_enable=0; set(handles.Input4_LP_checkbox, 'Value', 0);
Input4_Notch_enable=0; set(handles.Notch60Input4, 'Value', 0);

function Delta_lo_Callback(hObject, eventdata, handles)
global D_lo
Delta_lo = str2double(get(hObject,'String'));   % returns contents of Delta_lo as a double
if isnan(Delta_lo)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
D_lo = Delta_lo; 
% --- Executes during object creation, after setting all properties.
function Delta_lo_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Delta_hi_Callback(hObject, eventdata, handles)
global D_hi
Delta_hi = str2double(get(hObject,'String'));   % returns contents of EMG_Low as a double
if isnan(Delta_hi)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
D_hi = Delta_hi; 
% --- Executes during object creation, after setting all properties.
function Delta_hi_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Theta_lo_Callback(hObject, eventdata, handles)
global T_lo
Theta_lo = str2double(get(hObject,'String'));   % returns contents of Theta_lo as a double
if isnan(Theta_lo)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
T_lo = Theta_lo; 
% --- Executes during object creation, after setting all properties.
function Theta_lo_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Theta_hi_Callback(hObject, eventdata, handles)
global T_hi
Theta_hi = str2double(get(hObject,'String'));   % returns contents of Theta_hi as a double
if isnan(Theta_hi)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
T_hi = Theta_hi; 
% --- Executes during object creation, after setting all properties.
function Theta_hi_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Sigma_lo_Callback(hObject, eventdata, handles)
global S_lo
Sigma_lo = str2double(get(hObject,'String'));   % returns contents of Sigma_lo as a double
if isnan(Sigma_lo)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
S_lo = Sigma_lo;
% --- Executes during object creation, after setting all properties.
function Sigma_lo_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Sigma_hi_Callback(hObject, eventdata, handles)
global S_hi
Sigma_hi = str2double(get(hObject,'String'));   % returns contents of Sigma_hi as a double
if isnan(Sigma_hi)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
S_hi = Sigma_hi;
% --- Executes during object creation, after setting all properties.
function Sigma_hi_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Beta_lo_Callback(hObject, eventdata, handles)
global B_lo
Beta_lo = str2double(get(hObject,'String'));   % returns contents of Beta_lo as a double
if isnan(Beta_lo)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
B_lo = Beta_lo; 
% --- Executes during object creation, after setting all properties.
function Beta_lo_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Beta_hi_Callback(hObject, eventdata, handles)
global B_hi
Beta_hi = str2double(get(hObject,'String'));   % returns contents of Beta_hi as a double
if isnan(Beta_hi)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
B_hi = Beta_hi;
% --- Executes during object creation, after setting all properties.
function Beta_hi_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
%##########################################################################

function EEG_cutoff_Callback(hObject, eventdata, handles)
global EEG_Fc
EEG_cutoff = str2double(get(hObject,'String'));   % returns contents of EEG_cutoff as a double
if isnan(EEG_cutoff)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
% if EEG_cutoff > 124
%     set(hObject, 'String', 0);
%     errordlg('Cutoff frequency must be < 125 Hz','Error');
% end
EEG_Fc = EEG_cutoff;
% --- Executes during object creation, after setting all properties.
function EEG_cutoff_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function EMG_cutoff_Callback(hObject, eventdata, handles)
global EMG_Fc
EMG_cutoff = str2double(get(hObject,'String'));   % returns contents of EMG_cutoff as a double
if isnan(EMG_cutoff)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
EMG_Fc = EMG_cutoff;
% --- Executes during object creation, after setting all properties.
function EMG_cutoff_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%############## OPTIONAL Filters for the EEG and EMG Data #################

% --- Executes on button press in EEG_Highpass_checkbox.
function EEG_Highpass_checkbox_Callback(hObject, eventdata, handles)
global EEG_highpass_enable
if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    EEG_highpass_enable=1;
else
    % checkbox is not checked-take approriate action
    EEG_highpass_enable=0;
end

function EEG_Highpass_cutoff_Callback(hObject, eventdata, handles)
global EEG_HP_Fc
EEG_Highpass_cutoff = str2double(get(hObject,'String'));   % returns contents of EEG_cutoff as a double
if isnan(EEG_Highpass_cutoff)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
if EEG_Highpass_cutoff < 0
    set(hObject, 'String', 0);
    errordlg('Cutoff frequency must be a positive number','Error');
end
EEG_HP_Fc = EEG_Highpass_cutoff;

function EEG_Highpass_cutoff_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% --- Executes on button press in Notch60.
function Notch60_Callback(hObject, eventdata, handles)
global EEG_Notch_enable
if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    EEG_Notch_enable=1;
else
    % checkbox is not checked-take approriate action
    EEG_Notch_enable=0;
end
% --- Executes on button press in Notch60EMG.
function Notch60EMG_Callback(hObject, eventdata, handles)
global EMG_Notch_enable
if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    EMG_Notch_enable=1;
else
    % checkbox is not checked-take approriate action
    EMG_Notch_enable=0;
end
% --- Executes on button press in EMG_LP_checkbox.
function EMG_LP_checkbox_Callback(hObject, eventdata, handles)
global EMG_lowpass_enable
if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    EMG_lowpass_enable=1;
else
    % checkbox is not checked-take approriate action
    EMG_lowpass_enable=0;
end

function EMG_Lowpass_cutoff_Callback(hObject, eventdata, handles)
global EMG_LP_Fc
EMG_Lowpass_cutoff = str2double(get(hObject,'String'));   % returns contents of EMG_Lowpass_cutoff as a double
if isnan(EMG_Lowpass_cutoff)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
if EMG_Lowpass_cutoff < 0
    set(hObject, 'String', 0);
    errordlg('Cutoff frequency must be a positive number','Error');
end
EMG_LP_Fc = EMG_Lowpass_cutoff;

function EMG_Lowpass_cutoff_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function Input3file_Callback(hObject, eventdata, handles)

function Input3file_CreateFcn(hObject, eventdata, handles)

function Input4file_Callback(hObject, eventdata, handles)

function Input4file_CreateFcn(hObject, eventdata, handles)
% --- Executes on button press in Input3_HP_checkbox.
function Input3_HP_checkbox_Callback(hObject, eventdata, handles)
global Input3_HP_enable
if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    Input3_HP_enable=1;
else
    % checkbox is not checked-take approriate action
    Input3_HP_enable=0;
end

function Input3_Highpass_cutoff_Callback(hObject, eventdata, handles)
global Input3_HP_Fc
Input3_Highpass_cutoff = str2double(get(hObject,'String'));   % returns contents of Input3_Highpass_cutoff as a double
if isnan(Input3_Highpass_cutoff)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
if Input3_Highpass_cutoff < 0
    set(hObject, 'String', 0);
    errordlg('Cutoff frequency must be a positive number','Error');
end
Input3_HP_Fc = Input3_Highpass_cutoff;
% --- Executes during object creation, after setting all properties.
function Input3_Highpass_cutoff_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% --- Executes on button press in Notch60Input3.
function Notch60Input3_Callback(hObject, eventdata, handles)
global Input3_Notch_enable
if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    Input3_Notch_enable=1;
else
    % checkbox is not checked-take approriate action
    Input3_Notch_enable=0;
end

function Input3_Lowpass_cutoff_Callback(hObject, eventdata, handles)
global Input3_LP_Fc
Input3_Lowpass_cutoff = str2double(get(hObject,'String'));   % returns contents of Input3_Lowpass_cutoff as a double
if isnan(Input3_Lowpass_cutoff)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
if Input3_Lowpass_cutoff < 0
    set(hObject, 'String', 0);
    errordlg('Cutoff frequency must be a positive number','Error');
end
Input3_LP_Fc = Input3_Lowpass_cutoff;
% --- Executes during object creation, after setting all properties.
function Input3_Lowpass_cutoff_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% --- Executes on button press in Input4_HP_checkbox.
function Input4_HP_checkbox_Callback(hObject, eventdata, handles)
global Input4_HP_enable
if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    Input4_HP_enable=1;
else
    % checkbox is not checked-take approriate action
    Input4_HP_enable=0;
end

function Input4_Highpass_cutoff_Callback(hObject, eventdata, handles)
global Input4_HP_Fc
Input4_Highpass_cutoff = str2double(get(hObject,'String'));   % returns contents of Input4_Highpass_cutoff as a double
if isnan(Input4_Highpass_cutoff)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
if Input4_Highpass_cutoff < 0
    set(hObject, 'String', 0);
    errordlg('Cutoff frequency must be a positive number','Error');
end
Input4_HP_Fc = Input4_Highpass_cutoff;
% --- Executes during object creation, after setting all properties.
function Input4_Highpass_cutoff_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% --- Executes on button press in Notch60Input4.
function Notch60Input4_Callback(hObject, eventdata, handles)
global Input4_Notch_enable
if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    Input4_Notch_enable=1;
else
    % checkbox is not checked-take approriate action
    Input4_Notch_enable=0;
end

function Input4_Lowpass_cutoff_Callback(hObject, eventdata, handles)
global Input4_LP_Fc
Input4_Lowpass_cutoff = str2double(get(hObject,'String'));   % returns contents of Input4_Lowpass_cutoff as a double
if isnan(Input4_Lowpass_cutoff)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
end
if Input4_Lowpass_cutoff < 0
    set(hObject, 'String', 0);
    errordlg('Cutoff frequency must be a positive number','Error');
end
Input4_LP_Fc = Input4_Lowpass_cutoff;
% --- Executes during object creation, after setting all properties.
function Input4_Lowpass_cutoff_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ymin3_Callback(hObject, eventdata, handles)

function ymin3_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function ylimit4_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function ylimit4_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% --- Executes on button press in Input3_LP_checkbox.
function Input3_LP_checkbox_Callback(hObject, eventdata, handles)
global Input3_LP_enable
if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    Input3_LP_enable=1;
else
    % checkbox is not checked-take approriate action
    Input3_LP_enable=0;
end
% --- Executes on button press in Input4_LP_checkbox.
function Input4_LP_checkbox_Callback(hObject, eventdata, handles)
global Input4_LP_enable
if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    Input4_LP_enable=1;
else
    % checkbox is not checked-take approriate action
    Input4_LP_enable=0;
end
% --- Executes during object creation, after setting all properties.
function Notch60Input3_CreateFcn(hObject, eventdata, handles)
% --- Executes on button press in Input3_checkbox.
function Input3_checkbox_Callback(hObject, eventdata, handles)
global Input3_enable
if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    Input3_enable=1;
else
    % checkbox is not checked-take approriate action
    Input3_enable=0;
end
% --- Executes on button press in Input4_checkbox.
function Input4_checkbox_Callback(hObject, eventdata, handles)
global Input4_enable
if (get(hObject,'Value') == get(hObject,'Max'))
    % then checkbox is checked-take approriate action
    Input4_enable=1;
else
    % checkbox is not checked-take approriate action
    Input4_enable=0;
end

function eegfile_Callback(hObject, eventdata, handles)

function emgfile_Callback(hObject, eventdata, handles)


function ymin1_Callback(hObject, eventdata, handles)
function ymax1_Callback(hObject, eventdata, handles)

function ymin2_Callback(hObject, eventdata, handles)
function ymax2_Callback(hObject, eventdata, handles)

function ymax3_Callback(hObject, eventdata, handles)

function ymin4_Callback(hObject, eventdata, handles)
function ymax4_Callback(hObject, eventdata, handles)

function current_plus5_Callback(hObject, eventdata, handles)

function current_plus6_Callback(hObject, eventdata, handles)

function trainingfile_Callback(hObject, eventdata, handles)



% --- Executes during object creation, after setting all properties.
function ymin4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ymax4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ymin1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ymax1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function viewSectionStates_CreateFcn(hObject, eventdata, handles)

function ymax3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ymin2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ymax2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function current_plus5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function current_plus6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function channelplot1_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in powerColorMap.
function powerColorMap_Callback(hObject, eventdata, handles)
global EEG_SAMPLES Fs EEG_Fc
PowerColorMapGUI
%freqVersusTimePowerMap


% --- Executes on selection change in fileSelectionMenu.
function fileSelectionMenu_Callback(hObject, eventdata, handles)
global FileFlag
switch get(handles.fileSelectionMenu,'Value')   
    case 1
        FileFlag = 0;
        errordlg('You must select a file type.','Error');
    case 2 % Neuralynx
        FileFlag = 1;
    case 3 % AD System
        FileFlag = 2;
    case 4 % ASCII - Polysmith
        FileFlag = 3;
    case 5 % ASCII - EMZA
        FileFlag = 4;
    case 6 % Plexon
        FileFlag = 5;
end

% --- Executes during object creation, after setting all properties.
function fileSelectionMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function epochSizeMenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in keyScoreCheckbox.
function keyScoreCheckbox_Callback(hObject, eventdata, handles)
global enableKeyScoring
enableKeyScoring = get(handles.keyScoreCheckbox, 'Value');
set(handles.sleepscorer,'KeyPressFcn',@keyScoring);

function keyScoring(src,evnt,handles)
%src is the gui figure
%evnt is the keypress information
global enableKeyScoring
%this line brings the handles structures into the local workspace
%now we can use handles.cats in this subfunction!
handles = guidata(src);
 
%get the value of the key that was pressed
%evnt.Key is the lowercase symbol on the key that was pressed
%so even if you tried "shift + 8", evnt.Key will return 8
k=str2num(evnt.Character); %#ok<ST2NM>
 
% if k > 0 & k < 8 & isequal(enableKeyScoring, 1)
if isempty(k)
    if isequal(evnt.Key, 'rightarrow')
        Nextframe_Callback
    elseif isequal(evnt.Key, 'leftarrow')
        Previousframe_Callback
    end    
elseif isequal(enableKeyScoring, 1)
    switch k
        case 1  %Active Wake
            Activewaking_Callback 
        case 2  %Quiet Wake
            Quietwaking_Callback
        case 3  %Quiet Sleep
            Quietsleep_Callback 
        case 4  %Transition to REM
            transREM_Callback
        case 5  %REM Sleep
            REM_Callback
        case 6  %Unhooked
            Unhooked_Callback
        case 7  %Clear the state of the current epoch
            clearstate_Callback
        case 8  %Fill in current and contiguous prior epochs with state of last scored epoch.
            autofill_Callback
        otherwise
    end
    %updates the handles structures!
    guidata(src, handles); 
 
end




function ScoredFileType_Callback(hObject, eventdata, handles)

function ScoredFileType_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
