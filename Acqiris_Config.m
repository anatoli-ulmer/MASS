function status = Acqiris_Config(instrumentID, nbrSamples, nbrSegments, samplingInterval, fullScale, offset, trigLevel, trigSlope, trig)

%% Configuration
disp('Configuring...');

% Configure horizontal settings with no delay time
status = AqD1_configHorizontal(instrumentID, samplingInterval, 0.0); %#ok<*NASGU>

% Configure memory settings
status = AqD1_configMemory(instrumentID, nbrSamples, nbrSegments);

% Configure vertical settings for channel 1 with no offset,
% 50 ohms coupling and no bandwidth limiter

% Configure settings for signal:
% status = AqD1_configVertical(instrumentID, channel, fullScale, offset,
% coupling, bandwidth);
status = AqD1_configVertical(instrumentID, 1, fullScale, -offset, 3, 0); 

% Configure settings for GMD
status = AqD1_configVertical(instrumentID, 3, 0.8, -0.1, 3, 0); 

switch trig
    case 'External'
        sourceCh = -1;
        sourcePattern = hex2dec('80000000');
        trigMode = 1;
    case 'Channel 1'
        sourceCh = 1;
        sourcePattern = 1;
        trigMode = 0;
    case 'Channel 2'
        sourceCh = 2;
        sourcePattern = 2;
        trigMode = 0;
    case 'Channel 3'
        sourceCh = 3;
        sourcePattern = 3;
        trigMode = 0;
    case 'Channel 4'
        sourceCh = 4;
        sourcePattern = 4;
        trigMode = 0;
end

switch trigSlope
    case 'positive'
        slope = 0;
    case 'negative'
        slope = 1;
end

status = AqD1_configTrigClass(instrumentID, 0, sourcePattern, 0, 0, 0.0, 0.0);
status = AqD1_configTrigSource(instrumentID, sourceCh, 0, slope, trigLevel, 0.0); %
status = AqD1_configMode(instrumentID,0,0,trigMode); %

disp('done!')