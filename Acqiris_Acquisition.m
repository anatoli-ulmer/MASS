function AqReadParameters = Acqiris_Acquisition(instrumentID, acquisitionTimeOut)

% disp('Acquiring');
status = AqD1_acquire(instrumentID);

if status < 0
   	[status message] = Aq_errorMessage(instrumentID, status);
    error(sprintf('Acquire error: %s', message)) %#ok<*SPERR>
end; 

% Wait by polling. Please refer to the Programmer's Guide for more information.
%done = 0;
%while ((done==0) & (status==0))
%    [status done] = AqD1_acqDone(instrumentID);
%end

% Wait by interrupt. Please refer to the Programmer's Guide for more information.
% timedOut = false;
% status = AqD1_waitForEndOfAcquisition(instrumentID,acquisitionTimeOut);

if status == -1074116352 % -1074116352 == ACQIRIS_ERROR_ACQ_TIMEOUT (See AcqirisErrorCodes.h)
    % If no valid trigger is detected after the given timout period,
    % a software trigger is generated
    status = AqD1_forceTrigEx(instrumentID, 0, 0, 0);
    status = AqD1_waitForEndOfAcquisition(instrumentID,acquisitionTimeOut);
    timedOut = true;
end

if status < 0
   	[status message] = Aq_errorMessage(instrumentID, status);
    error(sprintf('Wait for end error: %s', message))
end; 

% Preparing Read-out

% disp('Retrieving data');

% retrieveing the memory settings in case they were adapted
[status nbrSamples nbrSegments] = AqD1_getMemory(instrumentID);

% Preparing read parameters
clear AqReadParameters;
AqReadParameters.dataType = 1; % Read 16bit
AqReadParameters.readMode = 0; % ReadModeStdW
AqReadParameters.firstSegment = 0;
AqReadParameters.nbrSegments = nbrSegments;
AqReadParameters.firstSampleInSeg = 0;
AqReadParameters.nbrSamplesInSeg = nbrSamples;
AqReadParameters.segmentOffset = nbrSamples;
AqReadParameters.dataArraySize = (nbrSamples + 32) * (AqReadParameters.dataType + 1); % dataArraySize in bytes
AqReadParameters.segDescArraySize = 16 * nbrSegments; % 2*4 bytes for the timestamps and 1*8 bytes for the horPos (see AcqirisDatatypes.h)
AqReadParameters.flags = 0;
AqReadParameters.reserved = 0;
AqReadParameters.reserved2 = 0.0;
AqReadParameters.reserved3 = 0.0;

% AqReadParameters.timedOut = timedOut;
