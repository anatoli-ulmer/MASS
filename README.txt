1. Install Software from 'AcqirisSoftware' folder.
2. Specify path to installed software an libraries at the MASS opening function in MASS.m :
	function MASS_OpeningFcn(hObject, eventdata, handles, varargin)
	acqirispath = 'C:\Program Files (x86)\Agilent\Acqiris'; % specify path here
3. Run MASS.m

If you want to include the MASS data into another datastream you can just 
run MASS and configurate it as you like. While the MASS figure is still 
open but the recording is stopped you can do the following:

    % Get GUIdata (only necessary if you changed parameters) (1-2 ms) 
    MASS_guidata = guidata(findobj('Tag','MASS_figure')); 
    
    % Arm the Acqiris when you are ready and waiting for the trigger
    AqReadParameters = arm_tof(MASS_guidata); (2 ms)
    
    % Read the recorded data
    tof = get_tof(MASS_guidata, AqReadParameters); (2 ms)

    % Update MASS plot if you want to see what you are recording (1-2 ms)
    MASS_guidata.normalPlot.YData = tof.trace(1:MASS_guidata.nbrSamples);
    MASS_guidata.GMDplot.YData = tof.GMD(1:2000);