function clipboard = plot_clipboard(handles, new_window)

if nargin<2
    new_window = true;
end

clipboard = getappdata(handles.clipboard_uitable, 'clipboard');

if new_window
    figure(1337)
    hold off;
else
    set(handles.MASS_figure, 'CurrentAxes', handles.normal_axes); hold on; grid on;
end

ntraces = size(clipboard,2);
for n = 1:ntraces
    if new_window; offs = str2double(handles.clipoffset_edit.String)*(n-1);
    else offs = 0; end;
    clipboard(n).show = handles.clipboard_uitable.Data{n,2};
    if clipboard(n).show
        if isfield(clipboard(n),'plot') && ~isempty(clipboard(n).plot) && isvalid(clipboard(n).plot)
            clipboard(n).plot.YData = clipboard(n).trace - offs;
        else
            clipboard(n).plot = plot(clipboard(n).time, clipboard(n).trace - offs); hold on;
        end
    else
        try
            delete(clipboard(n).plot);
        end
    end
end

grid on;
if new_window
    ylim([-handles.fullScale*0.5 + handles.offset - str2double(handles.clipoffset_edit.String)*(n-1), handles.fullScale*0.5 + handles.offset])
end
legend([clipboard([clipboard.show]).plot], clipboard([clipboard.show]).name)

setappdata(handles.clipboard_uitable, 'clipboard', clipboard);



