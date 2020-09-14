function AqReadParameters = arm_tof(handles)

% Arming
AqReadParameters = Acqiris_Acquisition(handles.instrumentID, handles.acquisitionTimeOut); % Acquiring

% Complete parameters
AqReadParameters.samplingInterval = handles.samplingInterval;
AqReadParameters.fullScale = handles.fullScale; % Full scale in volts (everything above will be cut)
AqReadParameters.offset = handles.offset;
AqReadParameters.trigLevel = handles.trigLevel; % In percent of vertical fullscale