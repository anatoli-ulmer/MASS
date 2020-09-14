function [vectorInVolts, GMDinVolts, status, message] = Acqiris_ReadOut(instrumentID, AqReadParameters)

%% Reading-out the data from the digitizer

% Read the data
[status dataDesc segDescArray AqDataBuffer] = AqD1_readData(instrumentID, 1, AqReadParameters);
[status2 dataDesc2 segDescArray2 AqDataBuffer2] = AqD1_readData(instrumentID, 3, AqReadParameters);
message = '';
if status < 0;
	[status message] = Aq_errorMessage(instrumentID, status);
    error(sprintf('Read data error: %s', message))
end;


% Convert to volt
vectorInVolts = cast(AqDataBuffer,'double') * dataDesc.vGain - dataDesc.vOffset;
GMDinVolts = cast(AqDataBuffer2,'double') * dataDesc2.vGain - dataDesc2.vOffset;

