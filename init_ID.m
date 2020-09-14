function handles = init_ID(handles)

switch handles.IDsource_popupmenu.Value
    case 1
        handles.bunchIDsocket = tcpip('hasfhvctrl', 58050);
    case 2
        handles.bunchIDsocket = tcpip('localhost', 58051);
    case 3
        sprintf('Using internal clock as shot ID instead of bunch ID!')
end