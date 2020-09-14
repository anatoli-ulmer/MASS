function varargout = focusScanGUI(varargin)
% FOCUSSCANGUI M-file for focusScanGUI.fig
%      FOCUSSCANGUI, by itself, creates a new FOCUSSCANGUI or raises the existing
%      singleton*.
%
%      H = FOCUSSCANGUI returns the handle to a new FOCUSSCANGUI or the handle to
%      the existing singleton*.
%
%      FOCUSSCANGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FOCUSSCANGUI.M with the given input arguments.
%
%      FOCUSSCANGUI('Property','Value',...) creates a new FOCUSSCANGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before focusScanGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to focusScanGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help focusScanGUI

% Last Modified by GUIDE v2.5 25-Oct-2015 20:36:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @focusScanGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @focusScanGUI_OutputFcn, ...
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

function varargout = focusScanGUI_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function focusScanGUI_OpeningFcn(hObject, eventdata, handles, varargin)
MASS = findobj('Tag','MASS_figure');
MASS_guidata = guidata(MASS);
% fopen(MASS_guidata.bunchIDsocket);
% bunchID = fscanf(MASS_guidata.bunchIDsocket);
% fclose(MASS_guidata.bunchIDsocket);
bunchID = horzcat(datestr(datenum(clock), 'yymmdd HHMMss.FFF '), num2str(1));

handles.oldpath = get(MASS_guidata.savePath_edit, 'String');
handles.spath = fullfile(handles.oldpath, 'focusScan', ['focusScan_20', bunchID(1:6), '_', bunchID(8:11)]);
set(MASS_guidata.savePath_edit, 'String', handles.spath);

handles.Xe2left = 12800;
handles.Xe2right = 15000;
handles.Xe3left = 10400;
handles.Xe3right = 11500;
handles.Xe4left = 8800;
handles.Xe4right = 9800;
handles.Xe5left = 7800;
handles.Xe5right = 8400;

% handles.Xe2left = str2double(get(handles.Xe2left_edit,'String'));
% handles.Xe2right = str2double(get(handles.Xe2right_edit,'String'));
% handles.Xe3left = str2double(get(handles.Xe3left_edit,'String'));
% handles.Xe3right = str2double(get(handles.Xe3right_edit,'String'));
% handles.Xe4left = str2double(get(handles.Xe4left_edit,'String'));
% handles.Xe4right = str2double(get(handles.Xe4right_edit,'String'));
% handles.Xe5left = str2double(get(handles.Xe5left_edit,'String'));
% handles.Xe5right = str2double(get(handles.Xe5right_edit,'String'));

% axes(MASS_guidata.normal_axes)
% lims = get(gca, 'YLim');
% MASS_guidata.Xe2ROIplot1 = plot([12800, 12800], [lims(1), lims(2)],'r');
% MASS_guidata.Xe2ROIplot2 = plot([15000, 15000], [lims(1), lims(2)],'r');
% MASS_guidata.Xe3ROIplot1 = plot([10400, 10400], [lims(1), lims(2)],'r');
% MASS_guidata.Xe3ROIplot2 = plot([11500, 11500], [lims(1), lims(2)],'r');
% MASS_guidata.Xe4ROIplot1 = plot([8800, 8800], [lims(1), lims(2)],'r');
% MASS_guidata.Xe4ROIplot2 = plot([9800, 9800], [lims(1), lims(2)],'r');
% MASS_guidata.Xe5ROIplot1 = plot([7800, 7800], [lims(1), lims(2)],'r');
% MASS_guidata.Xe5ROIplot2 = plot([8400, 8400], [lims(1), lims(2)],'r');
% axes(MASS_guidata.average_axes)
% MASS_guidata.Xe2ROIplot1 = plot([12800, 12800], [lims(1), lims(2)],'r');
% MASS_guidata.Xe2ROIplot2 = plot([15000, 15000], [lims(1), lims(2)],'r');
% MASS_guidata.Xe3ROIplot1 = plot([10400, 10400], [lims(1), lims(2)],'r');
% MASS_guidata.Xe3ROIplot2 = plot([11500, 11500], [lims(1), lims(2)],'r');
% MASS_guidata.Xe4ROIplot1 = plot([8800, 8800], [lims(1), lims(2)],'r');
% MASS_guidata.Xe4ROIplot2 = plot([9800, 9800], [lims(1), lims(2)],'r');
% MASS_guidata.Xe5ROIplot1 = plot([7800, 7800], [lims(1), lims(2)],'r');
% MASS_guidata.Xe5ROIplot2 = plot([8400, 8400], [lims(1), lims(2)],'r');


% axes(MASS_guidata.normal_axes)
% plot([handles.Xe2left, handles.Xe2right, handles.Xe3left, handles.Xe3right, handles.Xe4left, handles.Xe4right,handles.Xe5left, handles.Xe5right],[0,0,0,0,0,0,0,0],'rx', 'LineWidth', 2, 'MarkerSize', 12)
% axes(MASS_guidata.average_axes)
% plot([handles.Xe2left, handles.Xe2right, handles.Xe3left,
% handles.Xe3right, handles.Xe4left, handles.Xe4right,handles.Xe5left, handles.Xe5right],[0,0,0,0,0,0,0,0],'rx', 'LineWidth', 2, 'MarkerSize', 12)

handles.delaylist = [];
handles.Xe2 = [];
handles.Xe3 = [];
handles.Xe4 = [];
handles.Xe5 = [];
handles.delayCount = 0;

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes focusScanGUI wait for user response (see UIRESUME)
% uiwait(handles.focus_figure);


function trun_pushbutton_Callback(hObject, eventdata, handles) %#ok<*INUSL,*DEFNU,*NOPRT,*NASGU>
% Acq(startRun_pushbutton_Callback(hObject, eventdata, handles))
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
    
%     if get(MASS_guidata.checkbox1,'Value');
        if i==1
            spath = fullfile(get(MASS_guidata.savePath_edit,'String'), [sprintf('t%02.f',handles.delayCount), '_20', bunchID(1:6), '_', bunchID(8:11)]);
            if ~exist(spath, 'dir')
                mkdir(spath);
            end
        end
        saveData.bunchID = bunchID;
        saveData.AqReadParameters = AqReadParameters;
        saveData.vectorInVolts = vectorInVolts;
        saveData.GMD = GMDinVolts;
%         BID = bunchID(end-8:end-2);
%         savename = ['shot_', num2str(hex2dec(BID))];
        savename = ['shot_',bunchID(1:6),'_',bunchID(8:13),'_',bunchID(15:17)];
        save(fullfile(spath, savename), 'saveData');
%     end
    
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
handles.runlist = dir(fullfile(handles.spath));
runlist = handles.runlist(3:end);

nbrRuns = size(runlist,1)

for i=1:nbrRuns
    if size(handles.Xe2,2)<i
        handles.Xe2 = [handles.Xe2 0];
        handles.Xe3 = [handles.Xe3 0];
        handles.Xe4 = [handles.Xe4 0];
        handles.Xe5 = [handles.Xe5 0];
    end
    shotlist = dir(fullfile(handles.spath,runlist(i).name,'*.mat'));
    nbrShots = size(shotlist,1);
    runlist(i).name
    if handles.Xe2(i)==0
        for j=1:nbrShots
            load(fullfile(handles.spath, runlist(i).name, shotlist(j).name))
            handles.Xe2(i) = handles.Xe2(i)+ sum(saveData.vectorInVolts(handles.Xe2left:handles.Xe2right))/nbrShots;
            handles.Xe3(i) = handles.Xe3(i)+ sum(saveData.vectorInVolts(handles.Xe3left:handles.Xe3right))/nbrShots;
            handles.Xe4(i) = handles.Xe4(i)+ sum(saveData.vectorInVolts(handles.Xe4left:handles.Xe4right))/nbrShots;
            handles.Xe5(i) = handles.Xe5(i)+ sum(saveData.vectorInVolts(handles.Xe5left:handles.Xe5right))/nbrShots;
        end
    end
    if size(handles.delaylist,2) == size(handles.Xe3,2)
        axes(handles.timing_axes) %#ok<LAXES>
        labels = cellstr(num2str([1:nbrRuns]'));
        plot(handles.delaylist(1:i),handles.Xe4(1:i)./handles.Xe2(1:i),'rx', 'LineWidth', 2, 'MarkerSize', 12); title('Xe^4 zu Xe^2 Integrale'); hold on;
        text(handles.delaylist(1:i),handles.Xe4(1:i)./handles.Xe2(1:i),labels, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right')
        drawnow
        axes(handles.axes2)
        plot(handles.delaylist(1:i),handles.Xe4(1:i)./handles.Xe3(1:i),'rx', 'LineWidth', 2, 'MarkerSize', 12); title('Xe^4 zu Xe^3 Integrale'); hold on;
        text(handles.delaylist(1:i),handles.Xe4(1:i)./handles.Xe3(1:i),labels, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right')
        drawnow
        axes(handles.axes3)
        plot(handles.delaylist(1:i),handles.Xe5(1:i)./handles.Xe2(1:i),'rx', 'LineWidth', 2, 'MarkerSize', 12); title('Xe^5 zu Xe^2 Integrale'); hold on;
        text(handles.delaylist(1:i),handles.Xe5(1:i)./handles.Xe2(1:i),labels, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right')
        drawnow
    else
        'error'
    end
end

guidata(hObject,handles); 


function delay_edit_Callback(hObject, eventdata, handles) %#ok<*INUSD>

function delay_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function focus_figure_CloseRequestFcn(hObject, eventdata, handles)
MASS = findobj('Tag','MASS_figure');
MASS_guidata = guidata(MASS);
set(MASS_guidata.savePath_edit, 'String', handles.oldpath);
set(MASS_guidata.startRun_pushbutton, 'Enable', 'On');
set(MASS_guidata.conti_pushbutton, 'Enable', 'On');
set(MASS_guidata.browse_pushbutton, 'Enable', 'On');
set(MASS_guidata.applyChanges_pushbutton, 'Enable', 'On');
set(MASS_guidata.init_pushbutton, 'Enable', 'On');
set(MASS_guidata.text26, 'Visible', 'Off');
set(MASS_guidata.scanFocus_pushbutton, 'Enable', 'On');
delete(MASS_guidata.Xe2ROIplot1);
delete(MASS_guidata.Xe2ROIplot2);
delete(MASS_guidata.Xe3ROIplot1);
delete(MASS_guidata.Xe3ROIplot2);
delete(MASS_guidata.Xe4ROIplot1);
delete(MASS_guidata.Xe4ROIplot2);
delete(MASS_guidata.Xe5ROIplot1);
delete(MASS_guidata.Xe5ROIplot2);
try
    dlmwrite(fullfile(handles.spath,'delays.txt'), handles.delaylist, 'delimiter', '\t')
end
delete(hObject);


% --- Executes on button press in live_checkbox.
function live_checkbox_Callback(hObject, eventdata, handles)

function close_pushbutton_Callback(hObject, eventdata, handles)
MASS = findobj('Tag','MASS_figure');
MASS_guidata = guidata(MASS);

set(MASS_guidata.savePath_edit, 'String', handles.oldpath);
set(MASS_guidata.startRun_pushbutton, 'Enable', 'Off');
set(MASS_guidata.conti_pushbutton, 'Enable', 'On');
set(MASS_guidata.browse_pushbutton, 'Enable', 'On');
set(MASS_guidata.applyChanges_pushbutton, 'Enable', 'On');
set(MASS_guidata.init_pushbutton, 'Enable', 'On');
set(MASS_guidata.text26, 'Visible', 'Off');
set(MASS_guidata.scanFocus_pushbutton, 'Enable', 'On');

set(MASS_guidata.Xe2ROIplot1, 'Visible', 'Off')
set(MASS_guidata.Xe2ROIplot2, 'Visible', 'Off')
set(MASS_guidata.Xe3ROIplot1, 'Visible', 'Off')
set(MASS_guidata.Xe3ROIplot2, 'Visible', 'Off')
set(MASS_guidata.Xe4ROIplot1, 'Visible', 'Off')
set(MASS_guidata.Xe4ROIplot2, 'Visible', 'Off')
set(MASS_guidata.Xe5ROIplot1, 'Visible', 'Off')
set(MASS_guidata.Xe5ROIplot2, 'Visible', 'Off')

data.x = handles.delaylist;
data.Xe2 = handles.Xe2;
data.Xe3 = handles.Xe3;
data.Xe4 = handles.Xe4;
data.Xe5 = handles.Xe5;
try
    save(fullfile(handles.spath,[handles.spath(end-22:end), '.mat']),'data');
end

nbrRuns = length(handles.delaylist);
try
    savePlots = figure('units', 'normalized', 'outerposition',[0,0,1,1]);
    labels = cellstr(num2str([1:nbrRuns]'));
    subplot(311)
    plot(handles.delaylist,handles.Xe4./handles.Xe2,'rx', 'LineWidth', 2, 'MarkerSize', 12); title('Xe^4 zu Xe^2 Integrale'); hold on;
    text(handles.delaylist,handles.Xe4./handles.Xe2,labels, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right')
    subplot(312)
    plot(handles.delaylist,handles.Xe4./handles.Xe3,'rx', 'LineWidth', 2, 'MarkerSize', 12); title('Xe^4 zu Xe^3 Integrale'); hold on;
    text(handles.delaylist,handles.Xe4./handles.Xe3,labels, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right')
    subplot(313)
    plot(handles.delaylist,handles.Xe5./handles.Xe2,'rx', 'LineWidth', 2, 'MarkerSize', 12); title('Xe^5 zu Xe^2 Integrale'); hold on;
    text(handles.delaylist,handles.Xe5./handles.Xe2,labels, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right')
    drawnow
    saveas(savePlots,fullfile(handles.spath,[handles.spath(end-22:end), '.png']),'png')
end
close(savePlots);
close(gcbf);


% --- Executes on button press in save_pushbutton.
function save_pushbutton_Callback(hObject, eventdata, handles)
% spath = uiputfile({'*.png','PNG files'; '*.*', 'All files'}, 'Save Image', ...
%             fullfile(handles.spath,'timing_scan.png'));
% timingPlot = getimage(handles.timing_axes);
% saveas(timingPlot,spath,'png')
data.x = handles.delaylist;
data.Xe2 = handles.Xe2;
data.Xe3 = handles.Xe3;
data.Xe4 = handles.Xe4;
data.Xe5 = handles.Xe5;
save(fullfile(handles.spath,'data.mat'),'data');


function Xe2left_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Xe2left_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xe2left_edit as text
%        str2double(get(hObject,'String')) returns contents of Xe2left_edit as a double


% --- Executes during object creation, after setting all properties.
function Xe2left_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xe2left_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Xe3left_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Xe3left_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xe3left_edit as text
%        str2double(get(hObject,'String')) returns contents of Xe3left_edit as a double


% --- Executes during object creation, after setting all properties.
function Xe3left_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xe3left_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Xe2right_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Xe2right_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xe2right_edit as text
%        str2double(get(hObject,'String')) returns contents of Xe2right_edit as a double


% --- Executes during object creation, after setting all properties.
function Xe2right_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xe2right_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Xe3right_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Xe3right_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xe3right_edit as text
%        str2double(get(hObject,'String')) returns contents of Xe3right_edit as a double


% --- Executes during object creation, after setting all properties.
function Xe3right_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xe3right_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in applyChanges_pushbutton.
function applyChanges_pushbutton_Callback(hObject, eventdata, handles)

guidata(hObject,handles);



function Xe4left_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Xe4left_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xe4left_edit as text
%        str2double(get(hObject,'String')) returns contents of Xe4left_edit as a double


% --- Executes during object creation, after setting all properties.
function Xe4left_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xe4left_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Xe4right_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Xe4right_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xe4right_edit as text
%        str2double(get(hObject,'String')) returns contents of Xe4right_edit as a double


% --- Executes during object creation, after setting all properties.
function Xe4right_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xe4right_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Xe5left_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Xe5left_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xe5left_edit as text
%        str2double(get(hObject,'String')) returns contents of Xe5left_edit as a double


% --- Executes during object creation, after setting all properties.
function Xe5left_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xe5left_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Xe5right_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Xe5right_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xe5right_edit as text
%        str2double(get(hObject,'String')) returns contents of Xe5right_edit as a double


function Xe5right_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set2_pushbutton.
function set2_pushbutton_Callback(hObject, eventdata, handles)
MASS = findobj('Tag','MASS_figure');
MASS_guidata = guidata(MASS);
rect = round(getrect(MASS_guidata.average_axes));
lims = get(gca, 'YLim');
set(MASS_guidata.Xe2ROIplot1, 'XData', [rect(1),rect(1)])
set(MASS_guidata.Xe2ROIplot2, 'XData', [rect(1)+rect(3),rect(1)+rect(3)])
set(handles.Xe2left_edit,'String',num2str(rect(1)))
set(handles.Xe2right_edit,'String',num2str(rect(1)+rect(3)))
handles.Xe2left = rect(1);
handles.Xe2right = rect(1)+rect(3);
guidata(hObject,handles);

% --- Executes on button press in set3_pushbutton.
function set3_pushbutton_Callback(hObject, eventdata, handles)
MASS = findobj('Tag','MASS_figure');
MASS_guidata = guidata(MASS);
rect = round(getrect(MASS_guidata.average_axes));
lims = get(gca, 'YLim');
set(MASS_guidata.Xe3ROIplot1, 'XData', [rect(1),rect(1)])
set(MASS_guidata.Xe3ROIplot2, 'XData', [rect(1)+rect(3),rect(1)+rect(3)])
set(handles.Xe3left_edit,'String',num2str(rect(1)))
set(handles.Xe3right_edit,'String',num2str(rect(1)+rect(3)))
handles.Xe3left = rect(1)
handles.Xe3right = rect(1)+rect(3);
guidata(hObject,handles);

% --- Executes on button press in set4_pushbutton.
function set4_pushbutton_Callback(hObject, eventdata, handles)
MASS = findobj('Tag','MASS_figure');
MASS_guidata = guidata(MASS);
rect = round(getrect(MASS_guidata.average_axes));
lims = get(gca, 'YLim');
set(MASS_guidata.Xe4ROIplot1, 'XData', [rect(1),rect(1)])
set(MASS_guidata.Xe4ROIplot2, 'XData', [rect(1)+rect(3),rect(1)+rect(3)])
set(handles.Xe4left_edit,'String',num2str(rect(1)))
set(handles.Xe4right_edit,'String',num2str(rect(1)+rect(3)))
handles.Xe4left = rect(1);
handles.Xe4right = rect(1)+rect(3);
guidata(hObject,handles);

% --- Executes on button press in set5_pushbutton.
function set5_pushbutton_Callback(hObject, eventdata, handles)
MASS = findobj('Tag','MASS_figure');
MASS_guidata = guidata(MASS);
rect = round(getrect(MASS_guidata.average_axes));
lims = get(gca, 'YLim');
set(MASS_guidata.Xe5ROIplot1, 'XData', [rect(1),rect(1)])
set(MASS_guidata.Xe5ROIplot2, 'XData', [rect(1)+rect(3),rect(1)+rect(3)])
set(handles.Xe5left_edit,'String',num2str(rect(1)))
set(handles.Xe5right_edit,'String',num2str(rect(1)+rect(3)))
handles.Xe5left = rect(1);
handles.Xe5right = rect(1)+rect(3);
guidata(hObject,handles);



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to Xe2left_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xe2left_edit as text
%        str2double(get(hObject,'String')) returns contents of Xe2left_edit as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xe2left_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to Xe3left_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xe3left_edit as text
%        str2double(get(hObject,'String')) returns contents of Xe3left_edit as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xe3left_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to Xe2right_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xe2right_edit as text
%        str2double(get(hObject,'String')) returns contents of Xe2right_edit as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xe2right_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in apply_pushbutton.
function apply_pushbutton_Callback(hObject, eventdata, handles)
MASS = findobj('Tag','MASS_figure');
MASS_guidata = guidata(MASS);
handles.Xe2left = str2double(get(handles.Xe2left_edit,'String'));
handles.Xe2right = str2double(get(handles.Xe2right_edit,'String'));
handles.Xe3left = str2double(get(handles.Xe3left_edit,'String'));
handles.Xe3right = str2double(get(handles.Xe3right_edit,'String'));
handles.Xe4left = str2double(get(handles.Xe4left_edit,'String'));
handles.Xe4right = str2double(get(handles.Xe4right_edit,'String'));
handles.Xe5left = str2double(get(handles.Xe5left_edit,'String'));
handles.Xe5right = str2double(get(handles.Xe5right_edit,'String'));
set(MASS_guidata.Xe2ROIplot1, 'XData', [handles.Xe2left,handles.Xe2left])
set(MASS_guidata.Xe2ROIplot2, 'XData', [handles.Xe2right,handles.Xe2right])
set(MASS_guidata.Xe3ROIplot1, 'XData', [handles.Xe3left,handles.Xe3left])
set(MASS_guidata.Xe3ROIplot2, 'XData', [handles.Xe3right,handles.Xe3right])
set(MASS_guidata.Xe4ROIplot1, 'XData', [handles.Xe4left,handles.Xe4left])
set(MASS_guidata.Xe4ROIplot2, 'XData', [handles.Xe4right,handles.Xe4right])
set(MASS_guidata.Xe5ROIplot1, 'XData', [handles.Xe5left,handles.Xe5left])
set(MASS_guidata.Xe5ROIplot2, 'XData', [handles.Xe5right,handles.Xe5right])
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% 
% 
% 
% function Xe4left_edit_Callback(hObject, eventdata, handles)
% % hObject    handle to Xe4left_edit (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of Xe4left_edit as text
% %        str2double(get(hObject,'String')) returns contents of Xe4left_edit as a double
% 
% 
% 
% function Xe4right_edit_Callback(hObject, eventdata, handles)
% % hObject    handle to Xe4right_edit (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of Xe4right_edit as text
% %        str2double(get(hObject,'String')) returns contents of Xe4right_edit as a double
% 
% 
% 
% function Xe5left_edit_Callback(hObject, eventdata, handles)
% % hObject    handle to Xe5left_edit (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of Xe5left_edit as text
% %        str2double(get(hObject,'String')) returns contents of Xe5left_edit as a double
% 
% 
% 
% function Xe5right_edit_Callback(hObject, eventdata, handles)
