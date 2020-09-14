function varargout = waterfallGUI(varargin)
% WATERFALLGUI M-file for waterfallGUI.fig
%      WATERFALLGUI, by itself, creates a new WATERFALLGUI or raises the existing
%      singleton*.
%
%      H = WATERFALLGUI returns the handle to a new WATERFALLGUI or the handle to
%      the existing singleton*.
%
%      WATERFALLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WATERFALLGUI.M with the given input arguments.
%
%      WATERFALLGUI('Property','Value',...) creates a new WATERFALLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before waterfallGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to waterfallGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help waterfallGUI

% Last Modified by GUIDE v2.5 28-Oct-2015 06:17:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @waterfallGUI_OpeningFcn, ...
    'gui_OutputFcn',  @waterfallGUI_OutputFcn, ...
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

function varargout = waterfallGUI_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function waterfallGUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.tgroup = uitabgroup('parent', gcf);
handles.PGtab = uitab('parent', handles.tgroup, 'title', '     PG     ')
handles.BLtab = uitab('parent', handles.tgroup, 'title', '     BL     ')
handles.BOTHtab = uitab('parent', handles.tgroup, 'title', '     both     ')

set(handles.BL_axes, 'parent', handles.BLtab)
set(handles.PG_axes, 'parent', handles.PGtab)
set(handles.waterfall_axes, 'parent', handles.BOTHtab)

MASS = findobj('Tag','MASS_figure');
MASS_guidata = guidata(MASS);
% fopen(MASS_guidata.bunchIDsocket);
% bunchID = fscanf(MASS_guidata.bunchIDsocket);
bunchID = horzcat(datestr(datenum(clock), 'yymmdd HHMMss.FFF '), num2str(1));
% fclose(MASS_guidata.bunchIDsocket);

handles.oldpath = get(MASS_guidata.savePath_edit, 'String');
handles.spath = fullfile(handles.oldpath, 'waterfall', ['waterfall_20', bunchID(1:6), '_', bunchID(8:11)]);
set(MASS_guidata.savePath_edit, 'String', handles.spath);

handles.delaylist = [];
handles.delayCount = 0;

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes waterfallGUI wait for user response (see UIRESUME)
% uiwait(handles.waterfall_figure);

function delay_edit_Callback(hObject, eventdata, handles) %#ok<*INUSD>

function delay_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function waterfall_figure_CloseRequestFcn(hObject, eventdata, handles)
MASS = findobj('Tag','MASS_figure');
MASS_guidata = guidata(MASS);
set(MASS_guidata.savePath_edit, 'String', handles.oldpath);
% set(MASS_guidata.startRun_pushbutton, 'Enable', 'On');
set(MASS_guidata.conti_pushbutton, 'Enable', 'On');
set(MASS_guidata.browse_pushbutton, 'Enable', 'On');
set(MASS_guidata.applyChanges_pushbutton, 'Enable', 'On');
set(MASS_guidata.init_pushbutton, 'Enable', 'On');
set(MASS_guidata.text26, 'Visible', 'Off');
set(MASS_guidata.timing_pushbutton, 'Enable', 'On');
set(MASS_guidata.scanFocus_pushbutton, 'Enable', 'On');
set(MASS_guidata.waterfall_pushbutton, 'Enable', 'On');
try
    dlmwrite(fullfile(handles.spath,'delays.txt'), handles.delaylist, 'delimiter', '\t')
end
delete(hObject);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
close(gcbf);

function trun_pushbutton_Callback(hObject, eventdata, handles) %#ok<*INUSL,*DEFNU,*NOPRT,*NASGU>
MASS = findobj('Tag','MASS_figure');
MASS_guidata = guidata(MASS);
handles.delayCount = handles.delayCount+1;
if ~exist(handles.spath, 'dir')
    mkdir(handles.spath);
end

del = strrep(get(handles.delay_edit,'String'), ',', '.');
handles.delaylist = [handles.delaylist, str2double(del)];

iMax = str2double(get(MASS_guidata.edit9,'String'));
set(MASS_guidata.stop_pushbutton, 'userdata', false);
% fclose(MASS_guidata.bunchIDsocket);
% fopen(MASS_guidata.bunchIDsocket);

aqTime = 0;

tmp = get(handles.BLtab, 'Visible')
if strcmp(tmp(1:2),'on')
    arm = 'BL'
else
    tmp = get(handles.PGtab, 'Visible')
    if strcmp(tmp(1:2),'on')
        arm = 'PG'
    else
        tmp = get(handles.BOTHtab, 'Visible')
        if strcmp(tmp(1:2),'on')
            arm = 'BOTH'
        end
    end
end

for i=1:iMax
    tic
    if i==1
        wholeLoop = tic;
    end
    
    %     flushinput(MASS_guidata.bunchIDsocket);
    %     bunchID = fscanf(MASS_guidata.bunchIDsocket); % get bunchID 20ms before the pulse
    bunchID = horzcat(datestr(datenum(clock), 'yymmdd HHMMss.FFF '), num2str(i));
    
    AqReadParameters = Acqiris_Acquisition(MASS_guidata.instrumentID, MASS_guidata.acquisitionTimeOut); % Acquiring
    
    status = AqD1_waitForEndOfAcquisition(MASS_guidata.instrumentID,MASS_guidata.acquisitionTimeOut);
    if status == -1074116352 % -1074116352 == ACQIRIS_ERROR_ACQ_TIMEOUT (See AcqirisErrorCodes.h)
        % If no valid trigger is detected after the given timout period,
        % a software trigger is generated
        disp('No trigger found! Starting software trigger.')
        status = AqD1_forceTrigEx(MASS_guidata.instrumentID, 0, 0, 0);
        status = AqD1_waitForEndOfAcquisition(MASS_guidata.instrumentID,MASS_guidata.acquisitionTimeOut);
    end
    
    [vectorInVolts, GMDinVolts, status, message] = Acqiris_ReadOut(MASS_guidata.instrumentID,AqReadParameters); % safe read
    
    AqReadParameters.samplingInterval = MASS_guidata.samplingInterval;
    AqReadParameters.fullScale = MASS_guidata.fullScale; % Full scale in volts (everything above will be cut)
    AqReadParameters.trigLevel = MASS_guidata.trigLevel; % In % of vertical fullscale
    
    if i==1
        averageVectorInVolts = vectorInVolts;
    else
        averageVectorInVolts = averageVectorInVolts + vectorInVolts;
    end
    
    set(MASS_guidata.normalPlot, 'YData', vectorInVolts(1:AqReadParameters.nbrSamplesInSeg));
    set(MASS_guidata.averagePlot, 'YData',averageVectorInVolts(1:AqReadParameters.nbrSamplesInSeg)/i);
    set(MASS_guidata.GMDplot, 'YData', GMDinVolts(1:2000));
    drawnow;
    
    saveData.AqReadParameters = AqReadParameters; %#ok<*AGROW>
    saveData.vectorInVolts = vectorInVolts;
    saveData.GMD = GMDinVolts;
    
    if i==1
        spath = fullfile(get(MASS_guidata.savePath_edit,'String'), [sprintf('t%02.f',handles.delayCount), '_20', bunchID(1:6), '_', bunchID(8:11), arm]);
        if ~exist(spath, 'dir')
            mkdir(spath);
            %             disp(spath);
        end
    end
    saveData.bunchID = bunchID;
    saveData.AqReadParameters = AqReadParameters;
    saveData.vectorInVolts = vectorInVolts;
    saveData.GMD = GMDinVolts;
    %     BID = bunchID(end-8:end-2);
    %     savename = ['shot_', num2str(hex2dec(BID))];
    savename = ['shot_',bunchID(1:6),'_',bunchID(8:13),'_',bunchID(15:17)];
    save(fullfile(spath, savename), 'saveData');
    
    if get(MASS_guidata.stop_pushbutton, 'userdata');
        set(MASS_guidata.stop_pushbutton, 'userdata', false);
        iMax = i;
        break
    end
    
    aqTime = aqTime + toc;
    
    drawnow
    set(MASS_guidata.freq_text, 'String', sprintf('%1.1f Hz',i/aqTime));
    set(MASS_guidata.text24, 'String', ['shot ', num2str(i)]);
end

% fclose(MASS_guidata.bunchIDsocket);
MASS_guidata.AqReadParameters = AqReadParameters;
MASS_guidata.currentspath = spath;

save(fullfile(handles.spath,[strrep(num2str(handles.delaylist(end)),'.','_'), '_', arm,'.mat']), 'averageVectorInVolts')

% d = dir(fullfile(handles.spath));
% isub = [d(:).isdir];
% runlist = {d(isub).name}';
% runlist = runlist(3:end);
% runlist = cell2mat(runlist);

% runlist = dir(fullfile(handles.spath,'*.mat'))
PGlist = dir(fullfile(handles.spath,'*PG.mat'));
BLlist = dir(fullfile(handles.spath,'*BL.mat'));
BOTHlist = dir(fullfile(handles.spath,'*BOTH.mat'));

runlist = PGlist;
nbrRuns = size(runlist,1);

if nbrRuns>0
    CM = jet(nbrRuns+1);
    axes(handles.PG_axes)
    cla
    
    for i=1:nbrRuns
        legendlist{i} = strrep(runlist(i).name(1:end-7),'_','.');
    end
    [sortedlist, ind] = sort(str2double(legendlist));
    for k=1:nbrRuns
        i = ind(k);
        load(fullfile(handles.spath,runlist(i).name))
        plot(averageVectorInVolts(1:AqReadParameters.nbrSamplesInSeg)+k*30,'color', CM(i,:)); hold on;
        legendlist{k} = strrep(runlist(i).name(1:end-7),'_','.');
        legend(legendlist);
        drawnow
    end
end

runlist = BLlist;
nbrRuns = size(runlist,1);

if nbrRuns>0
    CM = jet(nbrRuns+1);
    axes(handles.BL_axes)
    cla
    % clear legendlist;
    for i=1:nbrRuns
        legendlist{i} = strrep(runlist(i).name(1:end-7),'_','.');
    end
    [sortedlist, ind] = sort(str2double(legendlist));
    for k=1:nbrRuns
        i = ind(k);
        load(fullfile(handles.spath,runlist(i).name))
        plot(averageVectorInVolts(1:AqReadParameters.nbrSamplesInSeg)+k*30,'color', CM(i,:)); hold on;
        legendlist{k} = strrep(runlist(i).name(1:end-7),'_','.');
        legend(legendlist);
        drawnow
    end
end

runlist = BOTHlist;
nbrRuns = size(runlist,1);

if nbrRuns>0
    CM = jet(nbrRuns+1);
    axes(handles.waterfall_axes)
    cla
    % clear legendlist;
    
    for i=1:nbrRuns
        legendlist{i} = strrep(runlist(i).name(1:end-9),'_','.');
    end
    [sortedlist, ind] = sort(str2double(legendlist));
    for k=1:nbrRuns
        i = ind(k);
        load(fullfile(handles.spath,runlist(i).name))
        plot(averageVectorInVolts(1:AqReadParameters.nbrSamplesInSeg)+k*30,'color', CM(i,:)); hold on;
        legendlist{k} = strrep(runlist(i).name(1:end-9),'_','.');
        legend(legendlist);
        drawnow
    end
end
guidata(hObject,handles);


% --------------------------------------------------------------------
% function uipushtool3_ClickedCallback(hObject, eventdata, handles)
% [filename, pathname] = uiputfile('*.png', 'Save As');
% Name = fullfile(pathname, filename);
% % imwrite(
