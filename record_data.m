function handles = record_data(hObject, handles)
setappdata(handles.stop_pushbutton, 'stop', false);
handles = init_ID(handles);
handles.firstSave = true;
iMax = handles.iMax;
handles.ind = 1;
wholeLoop = tic;
freqCnt = nan(10,1);

if handles.IDsource_popupmenu.Value<3
    try fopen(handles.bunchIDsocket);
    catch
        errordlg('Could not open bunchID socket!');
        return
    end
end

while ~getappdata(handles.stop_pushbutton, 'stop');
    guidata(hObject, handles);
    if handles.ind > iMax
        break
    end
    tic
    
    %%%
    ID = get_ID(handles); handles.ID = ID;
    
    AqReadParameters = arm_tof(handles);
    tof = get_tof(handles, AqReadParameters);
    
    handles.trace = tof.trace;
    handles.GMD = tof.GMD;
    
    if handles.ind==1
        disp(['Hello! The time is ',ID(8:9),':',ID(10:11),':',ID(12:13)])
        handles.averagetrace = handles.trace;
    else
        handles.averagetrace = handles.averagetrace + handles.trace;
    end
    
    if handles.sweep_checkbox.Value
        if handles.sweep_pushbutton.UserData
            handles.sweepcnt = 0;
            handles.nbrSweeps = str2double(handles.sweep_edit.String);
            handles.sweeptrace = zeros(handles.nbrSamples,1);
            handles.sweep_pushbutton.UserData = 0;
        end
        if handles.sweepcnt < handles.nbrSweeps
            handles.sweeptrace = handles.sweeptrace(1:handles.nbrSamples) + handles.trace(1:handles.nbrSamples);
            handles.sweepcnt = handles.sweepcnt+1;
            handles.sweep_text.String = [num2str(handles.sweepcnt), ' / '];
        end
    end

    handles = plot_traces(handles);
    save_tof(handles);

    set(handles.text24, 'String', ['shot ', num2str(handles.ind)]);
    
    freqCnt(mod(handles.ind,10)+1) = toc;
    freq = 1/nanmean(freqCnt);
    set(handles.freq_text, 'String', sprintf('%1.1f Hz',freq));

    handles.ind=handles.ind+1;
end
timeTotal = toc(wholeLoop);

if handles.IDsource_popupmenu.Value<3
    fclose(handles.bunchIDsocket);
end
if timeTotal>handles.ind/10
    %     warndlg(['Warning! missed ',num2str(ceil(timeTotal*10-i)) , ' shot(s)!!!'])
    disp(['Warning! missed ',num2str(ceil(timeTotal*10-(handles.ind))) , ' shot(s)!!!'])
end

try %#ok<TRYNC>
    fclose(fileID_TOF);
    fclose(fileID_GMD);
    fclose(fileID_BID);
    fclose(fileID_PAR);
end
try
    fclose(handles.bunchIDsocket);
end

