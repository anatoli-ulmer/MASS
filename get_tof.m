function tof = get_tof(handles, AqReadParameters)

% Wait for Acquisition
status = AqD1_waitForEndOfAcquisition(handles.instrumentID, handles.acquisitionTimeOut);
if status == -1074116352 % -1074116352 == ACQIRIS_ERROR_ACQ_TIMEOUT (See AcqirisErrorCodes.h)
    % If no valid trigger is detected after the given timout period,
    % a software trigger is generated
    disp('No trigger found! Starting software trigger.')
    status = AqD1_forceTrigEx(handles.instrumentID, 0, 0, 0);
    status = AqD1_waitForEndOfAcquisition(handles.instrumentID,handles.acquisitionTimeOut);
end

% Data readout
[trace, GMD, ~, ~] = Acqiris_ReadOut(handles.instrumentID, AqReadParameters); %#ok<*NASGU> % safe read

tof.AqReadParameters = AqReadParameters; %#ok<*AGROW>
tof.trace = trace;
tof.GMD = GMD;
tof.ID = handles.ID;