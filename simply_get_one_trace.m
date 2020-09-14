wt = tic;

% Get GUIdata
MASS_guidata = guidata(findobj('Tag','MASS_figure'));

AqReadParameters = arm_tof(MASS_guidata);
tof = get_tof(MASS_guidata, AqReadParameters);

% Update MASS plot
MASS_guidata.normalPlot.YData = tof.trace(1:MASS_guidata.nbrSamples);
MASS_guidata.GMDplot.YData = tof.GMD(1:2000);

fprintf('%d ms\n', ceil(toc(wt)*1000))