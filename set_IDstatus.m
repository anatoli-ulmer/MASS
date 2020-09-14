function set_IDstatus(handles, IDstatus)

N = [0.83, 0.83, 0.83]; % neutral
O = [0.4, 1, 0]; % okay
S = [1, 0.8, 0]; % stale
D = [1, 0.2, 0.2]; % disconnected

handles.IDstatus_edit.String = IDstatus;

switch IDstatus
    case 'N'
        handles.IDstatus_edit.BackgroundColor = N;
    case 'O'
        handles.IDstatus_edit.BackgroundColor = O;
    case 'S'
        handles.IDstatus_edit.BackgroundColor = S;
    case 'D'
        handles.IDstatus_edit.BackgroundColor = D;
    otherwise
        warning('bunch ID status error! Please check status flag position in bunch ID string!')
end
