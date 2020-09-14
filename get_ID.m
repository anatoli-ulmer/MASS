function [ID, IDstatus] = get_ID(handles)

switch handles.IDsource_popupmenu.Value
    case 1
        flushinput(handles.bunchIDsocket);
        ID = fscanf(handles.bunchIDsocket); % get bunchID 20ms before the pulse
        IDstatus = 'N';
    case 2
        ID = fscanf(handles.bunchIDsocket);
        IDstatus = ID(15);
    case 3
        ID = horzcat(datestr(datenum(clock), 'yymmdd HHMMss.FFF '));
        IDstatus = 'N';
    otherwise
        'error in get_ID'
end
set_IDstatus(handles, IDstatus);