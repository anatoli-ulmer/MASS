
% Initialize
instrumentID = Acqiris_Init();

% Update parameters
nbrSamples = 20000;
nbrSegments = 1;
samplingInterval = 0.5; % ns
fullScale = 1; % V
offset = 0; % V
acquisitionTimeOut = 1000; % ms
trigLevel = 0.1; % in percent of fullScale
trigSlope = 'positive';
trig = 'Channel 2';

% Configurate
status = Acqiris_Config(instrumentID, nbrSamples, nbrSegments, samplingInterval, fullScale, offset, trigLevel, trigSlope, trig);

% Arming
AqReadParameters = Acqiris_Acquisition(instrumentID, acquisitionTimeOut); % Acquiring

% Complete parameters
AqReadParameters.samplingInterval = samplingInterval;
AqReadParameters.fullScale = fullScale; % Full scale in volts (everything above will be cut)
AqReadParameters.offset = offset;
AqReadParameters.trigLevel = trigLevel; % In percent of vertical fullscale

% Wait for Acquisition
status = AqD1_waitForEndOfAcquisition(instrumentID, acquisitionTimeOut);
if status == -1074116352 % -1074116352 == ACQIRIS_ERROR_ACQ_TIMEOUT (See AcqirisErrorCodes.h)
    % If no valid trigger is detected after the given timout period,
    % a software trigger is generated
    disp('No trigger found! Starting software trigger.')
    status = AqD1_forceTrigEx(instrumentID, 0, 0, 0);
    status = AqD1_waitForEndOfAcquisition(instrumentID, acquisitionTimeOut);
end

% Data readout
[trace, GMD, ~, ~] = Acqiris_ReadOut(instrumentID, AqReadParameters); %#ok<*NASGU> % safe read

tof.AqReadParameters = AqReadParameters; %#ok<*AGROW>
tof.trace = trace;
tof.GMD = GMD;


