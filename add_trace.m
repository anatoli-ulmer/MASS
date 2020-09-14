function handles = add_trace(handles, trace, type)

clipboard = getappdata(handles.clipboard_uitable, 'clipboard');
n = size(clipboard,2) + 1;

clipboard(n).trace = trace;
clipboard(n).time = handles.timeaxis;
clipboard(n).show = true;
clipboard(n).ID = handles.ID;
clipboard(n).name = [handles.ID, type];

handles.clipboard_uitable.Data{n,1} = clipboard(n).name;
handles.clipboard_uitable.Data{n,2} = clipboard(n).show;

% clipboard = plot_clipboard(handles, clipboard);

setappdata(handles.clipboard_uitable, 'clipboard', clipboard);