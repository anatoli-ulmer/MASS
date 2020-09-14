function save_tof(handles)

%%%%% SAVING %%%%%
if get(handles.checkbox1,'Value')
    switch handles.save_popupmenu.Value
        case 1
            if handles.firstSave
                spath = fullfile(get(handles.savePath_edit,'String'), ['run_20', ID(1:6), '_', ID(8:11)]);
                if ~exist(fullfile(spath,'mat'), 'dir')
                    mkdir(fullfile(spath,'mat'));
                end
                handles.firstSave = false;
            end
            tof.AqReadParameters = AqReadParameters;
            tof.trace = handles.trace;
            tof.GMD = handles.GMDinVolts;
            
            switch handles.IDsource_popupmenu.Value
                case 1
                    BID = ID(end-8:end-2); % use this for real BID
                    savename = ['shot_', num2str(hex2dec(BID))];
                case 2
                    BID = ID(end-8:end-2); % use this for real BID
                    savename = ['shot_', num2str(hex2dec(BID))];
                case 3
                    savename = ['shot_',ID(1:6),'_',ID(8:13),'_',ID(15:17)];
            end
            save(fullfile(spath, 'mat', savename), 'mass_data');
        case 2
            if handles.firstSave
                spath = fullfile(get(handles.savePath_edit,'String'), ['run_20', ID(1:6), '_', ID(8:11)]);
                if ~exist(fullfile(spath,'binary','tof'),'dir')
                    mkdir(fullfile(spath,'binary','tof'))
                end
                if ~exist(fullfile(spath,'binary','gmd'),'dir')
                    mkdir(fullfile(spath,'binary','gmd'))
                end
                if ~exist(fullfile(spath,'binary','bid'),'dir')
                    mkdir(fullfile(spath,'binary','bid'))
                end
                if ~exist(fullfile(spath,'binary','parameters'),'dir')
                    mkdir(fullfile(spath,'binary','parameters'))
                end
                fileID_TOF = fopen(fullfile(spath,'binary','tof',['TOF_20', ID(1:6), '_', ID(8:11),'.dat']), 'W', 'ieee-le');
                fileID_GMD = fopen(fullfile(spath,'binary','gmd',['GMD_20', ID(1:6), '_', ID(8:11),'.dat']), 'W', 'ieee-le');
                fileID_BID = fopen(fullfile(spath,'binary','bid',['BID_20', ID(1:6), '_', ID(8:11),'.dat']), 'W', 'ieee-le');
                fileID_PAR = fopen(fullfile(spath,'binary','parameters',['PAR_20', ID(1:6), '_', ID(8:11),'.dat']), 'W', 'ieee-le');
                handles.firstSave = false;
            end
            fwrite(fileID_TOF, handles.trace, 'double');
            fwrite(fileID_GMD, handles.GMDinVolts, 'double');
            fwrite(fileID_BID, ID, 'char');
            AqReadParametersCell = struct2cell(AqReadParameters);
            fwrite(fileID_PAR, [AqReadParametersCell{:}], 'double');
    end
end