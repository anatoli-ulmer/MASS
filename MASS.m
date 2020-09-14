function varargout = MASS(varargin)
% MASS M-file for MASS.fig
%      MASS, by itself, creates a new MASS or raises the existing
%      singleton*.
%
%      H = MASS returns the handle to a new MASS or the handle to
%      the existing singleton*.
%
%      MASS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MASS.M with the given input arguments.
%
%      MASS('Property','Value',...) creates a new MASS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MASS_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MASS_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MASS

% Last Modified by GUIDE v2.5 13-Apr-2017 11:35:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @MASS_OpeningFcn, ...
    'gui_OutputFcn',  @MASS_OutputFcn, ...
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

function MASS_OpeningFcn(hObject, eventdata, handles, varargin)
acqirispath = 'C:\Program Files (x86)\Agilent\Acqiris'; % specify path here
addpath(genpath(acqirispath));
[handles.sourcepath,~,~] = fileparts(mfilename('fullpath'));
addpath(genpath(handles.sourcepath));

handles.arrow_text.String = char(8680);
set(handles.trigger_popupmenu, 'Value', 2);
handles.output = hObject;

guidata(hObject, handles); 

function varargout = MASS_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


function init_pushbutton_Callback(hObject, eventdata, handles)
set(handles.MASS_figure, 'pointer', 'watch'); drawnow

% Initialize
handles.instrumentID = Acqiris_Init();
guidata(hObject,handles);

% Configurate
applyChanges_pushbutton_Callback(hObject, eventdata, handles)

set(handles.MASS_figure, 'pointer', 'arrow');
guidata(hObject,handles);

function applyChanges_pushbutton_Callback(hObject, eventdata, handles)
% stop measurement
setappdata(handles.stop_pushbutton, 'stop', true);

% Update parameters
handles.nbrSamples = str2double(get(handles.nbrSamples_edit,'String'));
handles.nbrSegments = 1;
handles.samplingInterval = str2double(get(handles.samplingInterval_edit,'String'))*1e-9;
handles.fullScale = str2double(get(handles.fullScale_edit,'String'));
handles.offset = str2double(get(handles.offset_edit,'String'));
handles.acquisitionTimeOut = str2double(get(handles.timeOut_edit,'String'));

handles.trigLevel = str2double(get(handles.trigLevel_edit,'String'));
handles.trigSlope = handles.slope_popupmenu.String(handles.slope_popupmenu.Value,:);
handles.trig = handles.trigger_popupmenu.String{handles.trigger_popupmenu.Value,:};

handles = init_ID(handles);

% Create traces
handles.trace = zeros(handles.nbrSamples,1);
handles.runningtrace = zeros(handles.nbrSamples,1);
handles.sweeptrace = zeros(handles.nbrSamples,1);
handles.sweepcnt = 0;

% Configurate
status = Acqiris_Config(handles.instrumentID, handles.nbrSamples, handles.nbrSegments, handles.samplingInterval, handles.fullScale, handles.offset, handles.trigLevel, handles.trigSlope, handles.trig);
handles.status_text.String = status;
axes(handles.normal_axes);
ylim([-handles.fullScale*0.5 + handles.offset, handles.fullScale*0.5 + handles.offset])
xlim([1, handles.nbrSamples]*handles.samplingInterval*1e6)
grid on; box on
axes(handles.GMD_axes);
grid on; box on
guidata(hObject,handles);

function conti_pushbutton_Callback(hObject, ~, handles) %#ok<*DEFNU>
handles.iMax = 1e10;
handles = record_data(hObject, handles);
guidata(hObject,handles);

function startRun_pushbutton_Callback(hObject, ~, handles) %#ok<DEFNU>
handles.iMax = str2double(get(handles.nshots_edit,'String'));
handles = record_data(hObject, handles);
guidata(hObject,handles);

function stop_pushbutton_Callback(hObject, eventdata, handles)
setappdata(handles.stop_pushbutton, 'stop', true);
guidata(hObject,handles);

function browse_pushbutton_Callback(hObject, eventdata, handles)
newspath = uigetdir;
set(handles.savePath_edit, 'String', newspath);
guidata(hObject,handles);

function runaverage_checkbox_Callback(hObject, eventdata, handles)
try
    if handles.runaverage_checkbox.Value
        handles.averagePlot.Visible = 'on';
    else
        handles.averagePlot.Visible = 'off';
    end
end
drawnow;
guidata(hObject,handles);

function sweep_checkbox_Callback(hObject, eventdata, handles)
if handles.sweep_checkbox.Value
    handles.newsweep = true;
end
try
    if handles.sweep_checkbox.Value
        handles.sweepPlot.Visible = 'on';
    else
        handles.sweepPlot.Visible = 'off';
    end
end
drawnow;
guidata(hObject,handles);

function sweep_pushbutton_Callback(hObject, eventdata, handles)
handles.sweep_checkbox.Value = true;
handles.sweep_pushbutton.UserData = 1;
try handles.sweepPlot.Visible = 'on'; end
guidata(hObject,handles);

function running_checkbox_Callback(hObject, eventdata, handles)
try
    if handles.running_checkbox.Value
        handles.runningPlot.Visible = 'on';
    else
        handles.runningPlot.Visible = 'off';
    end
end
drawnow;
guidata(hObject,handles);

function clearAxes_pushbutton_Callback(hObject, eventdata, handles)
cla(handles.normal_axes); legend(gca, 'off')
cla(handles.GMD_axes);

function sweeptoclip_pushbutton_Callback(hObject, eventdata, handles)
handles = add_trace(handles, handles.sweeptrace(1:handles.nbrSamples)/handles.sweepcnt, 'sweep av');
guidata(hObject, handles);

function runnningtoclip_pushbutton_Callback(hObject, eventdata, handles)
handles = add_trace(handles, nanmean(handles.runningtrace,2), 'runing av');
guidata(hObject, handles);

function runtoclip_pushbutton_Callback(hObject, eventdata, handles)
handles = add_trace(handles, handles.averagetrace(1:handles.nbrSamples)/handles.ind ,'run');
guidata(hObject, handles);

function clear_clipboard_pushbutton_Callback(hObject, eventdata, handles)
setappdata(handles.clipboard_uitable, 'clipboard', []);
set(handles.clipboard_uitable, 'Data', cell(1,2));
guidata(hObject, handles);

function clipboard_uitable_CellEditCallback(hObject, eventdata, handles)
clipboard = getappdata(handles.clipboard_uitable, 'clipboard');
ntraces = size(clipboard,2);
for n = 1:ntraces
    clipboard(n).name = handles.clipboard_uitable.Data{n,1};
end
setappdata(handles.clipboard_uitable, 'clipboard', clipboard);
guidata(hObject, handles);

function window_pushbutton_Callback(hObject, eventdata, handles)
plot_clipboard(handles, true);
guidata(hObject, handles);

function same_pushbutton_Callback(hObject, eventdata, handles)
plot_clipboard(handles, false);
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function checkbox1_Callback(hObject, eventdata, handles)

function savePath_edit_Callback(hObject, eventdata, handles)

function savePath_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function nbrSamples_edit_Callback(hObject, eventdata, handles)

function nbrSamples_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function samplingInterval_edit_Callback(hObject, eventdata, handles)

function samplingInterval_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fullScale_edit_Callback(hObject, eventdata, handles)

function fullScale_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function trigLevel_edit_Callback(hObject, eventdata, handles)

function trigLevel_edit_CreateFcn(hObject, eventdata, handles) %#ok<*INUSD>
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function nshots_edit_Callback(hObject, eventdata, handles)

function nshots_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function timeOut_edit_Callback(hObject, eventdata, handles)

function timeOut_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function offset_edit_Callback(hObject, eventdata, handles)

function offset_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function trigger_popupmenu_Callback(hObject, eventdata, handles)

function trigger_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject,handles);

function slope_popupmenu_Callback(hObject, eventdata, handles)

function slope_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function IDsource_popupmenu_Callback(hObject, eventdata, handles)

function IDsource_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function sweep_edit_Callback(hObject, eventdata, handles)

function sweep_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function MASS_figure_WindowKeyReleaseFcn(hObject, eventdata, handles)

function MASS_figure_WindowKeyPressFcn(hObject, eventdata, handles)

function clipoffset_edit_Callback(hObject, eventdata, handles)

function clipoffset_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function scanFocus_pushbutton_Callback(hObject, eventdata, handles)
set(handles.startRun_pushbutton, 'Enable', 'Off');
% set(handles.conti_pushbutton, 'Enable', 'Off');
set(handles.browse_pushbutton, 'Enable', 'Off');
set(handles.applyChanges_pushbutton, 'Enable', 'Off');
set(handles.init_pushbutton, 'Enable', 'Off');
set(handles.scanFocus_pushbutton, 'Enable', 'Off');
% set(handles.waterfall_pushbutton, 'Enable', 'On');
set(handles.text26, 'Visible', 'On');

axes(handles.normal_axes)
hold on;
lims = get(handles.normal_axes, 'YLim');
handles.Xe2ROIplot1 = plot([12800, 12800], [lims(1), lims(2)],'r');
handles.Xe2ROIplot2 = plot([15000, 15000], [lims(1), lims(2)],'r');
handles.Xe3ROIplot1 = plot([10400, 10400], [lims(1), lims(2)],'r');
handles.Xe3ROIplot2 = plot([11500, 11500], [lims(1), lims(2)],'r');
handles.Xe4ROIplot1 = plot([8800, 8800], [lims(1), lims(2)],'r');
handles.Xe4ROIplot2 = plot([9800, 9800], [lims(1), lims(2)],'r');
handles.Xe5ROIplot1 = plot([7800, 7800], [lims(1), lims(2)],'r');
handles.Xe5ROIplot2 = plot([8400, 8400], [lims(1), lims(2)],'r');

guidata(hObject,handles);

handles.timing = focusScanGUI;

guidata(hObject,handles);

function waterfall_pushbutton_Callback(hObject, eventdata, handles)
set(handles.startRun_pushbutton, 'Enable', 'Off');
% set(handles.conti_pushbutton, 'Enable', 'Off');
% set(handles.browse_pushbutton, 'Enable', 'Off');
% set(handles.applyChanges_pushbutton, 'Enable', 'Off');
set(handles.init_pushbutton, 'Enable', 'Off');
% set(handles.scanFocus_pushbutton, 'Enable', 'Off');
% set(handles.waterfall_pushbutton, 'Enable', 'Off');
set(handles.text26, 'Visible', 'On');

handles.waterfall = waterfallGUI;


% --- Executes on selection change in save_popupmenu.
function save_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to save_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns save_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from save_popupmenu


% --- Executes during object creation, after setting all properties.
function save_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to save_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IDstatus_edit_Callback(hObject, eventdata, handles)
% hObject    handle to IDstatus_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IDstatus_edit as text
%        str2double(get(hObject,'String')) returns contents of IDstatus_edit as a double


% --- Executes during object creation, after setting all properties.
function IDstatus_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IDstatus_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
