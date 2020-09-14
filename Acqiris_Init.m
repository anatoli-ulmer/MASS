function instrumentID = Acqiris_Init()

%% Acqiris Startup file

% Aq_Startup.m   Acqiris Startup file
% 
% This file is generated automatically during the installation
% DO NOT EDIT - File will be overwritten if re-installing or updating
 
% AqRoot=getenv('AcqirisDxRoot');
% addpath([AqRoot,'\bin']);
% addpath([AqRoot,'\MATLAB\mex'],[AqRoot,'\MATLAB\mex\help']);


% Detect Acqiris instruments
[status nbInstr] = Aq_getNbrInstruments();
disp(sprintf('Found %d Acqiris instrument(s)', nbInstr)); %#ok<*DSPS>

%% Initialize
if nbInstr == 0
    error('No instrument found!')
else
    % Initialize the first instrument found on the PCI bus
    [status instrumentID] = Aq_InitWithOptions('PCI::INSTR0', 0,0,'asbus=false');
end

% Check instrument class
[status devType] = Aq_getDevType(instrumentID);
if devType ~= 1 % 1 == AqD1 (See AcqirisDatatypes.h)
    error('This example works only with Acqiris Digitizer instruments (AqD1 class).');
end

% Check if the initialization was successful
if status < 0 % An error occured
    [status message] = Aq_errorMessage(0, status);
    error(sprintf('Initialization error: %s', message))
end

% Retreive digitizer position, name and serial number
[status name, serial, bus, slot] = Aq_getInstrumentData(instrumentID);
disp(sprintf('Initialized %s, SN %d, on bus %d, slot %d',name, serial, bus, slot));
