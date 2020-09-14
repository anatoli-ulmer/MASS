function varargout = waterfall(varargin)
% WATERFALL M-file for waterfall.fig
%      WATERFALL, by itself, creates a new WATERFALL or raises the existing
%      singleton*.
%
%      H = WATERFALL returns the handle to a new WATERFALL or the handle to
%      the existing singleton*.
%
%      WATERFALL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WATERFALL.M with the given input arguments.
%
%      WATERFALL('Property','Value',...) creates a new WATERFALL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before waterfall_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to waterfall_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help waterfall

% Last Modified by GUIDE v2.5 27-Oct-2015 23:59:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @waterfall_OpeningFcn, ...
                   'gui_OutputFcn',  @waterfall_OutputFcn, ...
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

function varargout = waterfall_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function waterfall_OpeningFcn(hObject, eventdata, handles, varargin)
MASS = findobj('Tag','MASS_figure');
MASS_guidata = guidata(MASS);
fopen(MASS_guidata.bunchIDsocket);
bunchID = fscanf(MASS_guidata.bunchIDsocket);
fclose(MASS_guidata.bunchIDsocket);

handles.oldpath = get(MASS_guidata.savePath_edit, 'String');
handles.savepath = fullfile(handles.oldpath, 'timing', ['timing_20', bunchID(1:6), '_', bunchID(8:11)]);
set(MASS_guidata.savePath_edit, 'String', handles.savepath);

handles.Xe2left = str2double(get(handles.Xe2left_edit,'String'));
handles.Xe2right = str2double(get(handles.Xe2right_edit,'String'));
handles.Xe3left = str2double(get(handles.Xe3left_edit,'String'));
handles.Xe3right = str2double(get(handles.Xe3right_edit,'String'));

axes(MASS_guidata.normal_axes)
plot([handles.Xe2left, handles.Xe2right, handles.Xe3left, handles.Xe3right],[0,0,0,0],'rx', 'LineWidth', 2, 'MarkerSize', 12)
axes(MASS_guidata.average_axes)
plot([handles.Xe2left, handles.Xe2right, handles.Xe3left, handles.Xe3right],[0,0,0,0],'rx', 'LineWidth', 2, 'MarkerSize', 12)

% axes(MASS_guidata.normal_axes)
% hx = graph2d.constantline(handles.Xe2left, 'LineStyle', ':', 'Color', 'red'); hold on;
% changedependentvar(hx,'x')

handles.delaylist = [];
handles.Xe2 = [];
handles.Xe3 = [];
handles.delayCount = 0;

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes waterfall wait for user response (see UIRESUME)
% uiwait(handles.timing_figure);


function trun_pushbutton_Callback(hObject, eventdata, handles) %#ok<*INUSL,*DEFNU,*NOPRT,*NASGU>
% Acq(startRun_pushbutton_Callback(hObject, eventdata, handles))
MASS = findobj('Tag','MASS_figure');
MASS_guidata = guidata(MASS);
handles.delayCount = handles.delayCount+1;
if ~exist(handles.savepath, 'dir')
    mkdir(handles.savepath);
end

del = strrep(get(handles.delay_edit,'String'), ',', '.');
handles.delaylist = [handles.delaylist, str2double(del)];

iMax = str2double(get(MASS_guidata.edit9,'String'));
set(MASS_guidata.stop_pushbutton, 'userdata', false);
fclose(MASS_guidata.bunchIDsocket);
fopen(MASS_guidata.bunchIDsocket);

aqTime = 0;

for i=1:iMax
    tic
    if i==1
        wholeLoop = tic;
    end
    
    flushinput(MASS_guidata.bunchIDsocket);
    bunchID = fscanf(MASS_guidata.bunchIDsocket); % get bunchID 20ms before the pulse
        
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
    
    axes(MASS_guidata.normal_axes); hold on;
    delete(get(MASS_guidata.normal_axes,'Children'));
    plot(vectorInVolts(1:AqReadParameters.nbrSamplesInSeg))
    ylim([-AqReadParameters.fullScale/2 AqReadParameters.fullScale/20])
    set(gcf, 'CurrentAxes', MASS_guidata.average_axes); hold on;
    delete(get(MASS_guidata.average_axes,'Children'));
    plot(averageVectorInVolts(1:AqReadParameters.nbrSamplesInSeg)/i)
    ylim([-AqReadParameters.fullScale/2 AqReadParameters.fullScale/20])
    set(gcf, 'CurrentAxes', MASS_guidata.GMD_axes); hold on;
    delete(get(MASS_guidata.GMD_axes,'Children'));
    plot(GMDinVolts(1:2000))
    ylim([-0.05 0.15])
    drawnow
    
    saveData.AqReadParameters = AqReadParameters; %#ok<*AGROW>
    saveData.vectorInVolts = vectorInVolts;
    saveData.GMD = GMDinVolts;
    
    if get(MASS_guidata.checkbox1,'Value');
        if i==1
            savepath = fullfile(get(MASS_guidata.savePath_edit,'String'), [sprintf('t%02.f',handles.delayCount), '_20', bunchID(1:6), '_', bunchID(8:11)]);
            if ~exist(savepath, 'dir')
                mkdir(savepath);
            end
        end
        saveData.bunchID = bunchID;
        saveData.AqReadParameters = AqReadParameters;
        saveData.vectorInVolts = vectorInVolts;
        saveData.GMD = GMDinVolts;
        BID = bunchID(end-8:end-2);
        savename = ['shot_', num2str(hex2dec(BID))];
        save(fullfile(savepath, savename), 'saveData');
    end
    
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
  
fclose(MASS_guidata.bunchIDsocket);
MASS_guidata.AqReadParameters = AqReadParameters;
MASS_guidata.currentsavepath = savepath;
% handles.savepath =
% 'E:\FLASH2015_MetalCluster\timing\timing_20151012_2017\';
handles.runlist = dir(fullfile(handles.savepath));
runlist = handles.runlist(3:end);

nbrRuns = size(runlist,1)

for i=1:nbrRuns
    if size(handles.Xe2,2)<i
        handles.Xe2 = [handles.Xe2 0];
        handles.Xe3 = [handles.Xe3 0];
    end
    shotlist = dir(fullfile(handles.savepath,runlist(i).name,'*.mat'));
    nbrShots = size(shotlist,1);
    runlist(i).name
    if handles.Xe2(i)==0
        for j=1:nbrShots
            load(fullfile(handles.savepath, runlist(i).name, shotlist(j).name))
            handles.Xe2(i) = handles.Xe2(i)+ sum(saveData.vectorInVolts(handles.Xe2left:handles.Xe2right))/nbrShots;
            handles.Xe3(i) = handles.Xe3(i)+ sum(saveData.vectorInVolts(handles.Xe3left:handles.Xe3right))/nbrShots;
        end
    end
    size(handles.delaylist,2)
    size(handles.Xe3,2)
    if size(handles.delaylist,2) == size(handles.Xe3,2)
        axes(handles.timing_axes) %#ok<LAXES>
        labels = cellstr(num2str([1:nbrRuns]'));
        plot(handles.delaylist(1:i),handles.Xe3(1:i)./handles.Xe2(1:i),'rx', 'LineWidth', 2, 'MarkerSize', 12); title('Xe^3 zu Xe^2 Integrale'); hold on;
        text(handles.delaylist(1:i),handles.Xe3(1:i)./handles.Xe2(1:i),labels, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right')
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


function timing_figure_CloseRequestFcn(hObject, eventdata, handles)
MASS = findobj('Tag','MASS_figure');
MASS_guidata = guidata(MASS);
set(MASS_guidata.savePath_edit, 'String', handles.oldpath);
set(MASS_guidata.startRun_pushbutton, 'Enable', 'On');
set(MASS_guidata.conti_pushbutton, 'Enable', 'On');
set(MASS_guidata.browse_pushbutton, 'Enable', 'On');
set(MASS_guidata.applyChanges_pushbutton, 'Enable', 'On');
set(MASS_guidata.init_pushbutton, 'Enable', 'On');
set(MASS_guidata.text26, 'Visible', 'Off');
set(MASS_guidata.timing_pushbutton, 'Enable', 'On');
try
    dlmwrite(fullfile(handles.savepath,'delays.txt'), handles.delaylist, 'delimiter', '\t')
end
delete(hObject);


% --- Executes on button press in live_checkbox.
function live_checkbox_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
close(gcbf);


% --- Executes on button press in save_pushbutton.
function save_pushbutton_Callback(hObject, eventdata, handles)
savePath = uiputfile({'*.png','PNG files'; '*.*', 'All files'}, 'Save Image', ...
            fullfile(handles.savepath,'timing_scan.png'));
timingPlot = getimage(handles.timing_axes);
saveas(timingPlot,savePath,'png')



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
MASS = findobj('Tag','MASS_figure');
MASS_guidata = guidata(MASS);
handles.Xe2left = str2double(get(handles.Xe2left_edit,'String'));
handles.Xe2right = str2double(get(handles.Xe2right_edit,'String'));
handles.Xe3left = str2double(get(handles.Xe3left_edit,'String'));
handles.Xe3right = str2double(get(handles.Xe3right_edit,'String'));

axes(MASS_guidata.normal_axes)
plot([handles.Xe2left, handles.Xe2right, handles.Xe3left, handles.Xe3right],[0,0,0,0],'rx', 'LineWidth', 2, 'MarkerSize', 12)
axes(MASS_guidata.average_axes)
plot([handles.Xe2left, handles.Xe2right, handles.Xe3left, handles.Xe3right],[0,0,0,0],'rx', 'LineWidth', 2, 'MarkerSize', 12)

guidata(hObject,handles);
