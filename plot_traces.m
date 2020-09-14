function handles = plot_traces(handles)

%%%%% GMD trace
if isfield(handles, 'GMDplot') && isvalid(handles.GMDplot)
    set(handles.GMDplot, 'YData', handles.GMD(1:2000))
else
    set(handles.MASS_figure, 'CurrentAxes', handles.GMD_axes);
    handles.GMDplot = plot(handles.GMD(1:2000));
    ylim([-0.05 0.3]); grid on;
end

%%%%% normal trace
if isfield(handles,'normalPlot') && isvalid(handles.normalPlot)
    set(handles.normalPlot, 'YData', handles.trace(1:handles.nbrSamples));
else
    set(handles.MASS_figure, 'CurrentAxes', handles.normal_axes); hold on; grid on;
    handles.timeaxis = (1:handles.nbrSamples)*handles.samplingInterval*1e6;
    handles.normalPlot = plot(handles.timeaxis, handles.trace(1:handles.nbrSamples));
end

%%%%% run average trace
if handles.runaverage_checkbox.Value
    if isfield(handles, 'averagePlot') && isvalid(handles.averagePlot)
        set(handles.averagePlot, 'YData', handles.averagetrace(1:handles.nbrSamples)/handles.ind);
    else
        set(handles.MASS_figure, 'CurrentAxes', handles.normal_axes); hold on; grid on;
        handles.averagePlot = plot(handles.timeaxis, handles.averagetrace(1:handles.nbrSamples)/handles.ind);
    end
end

%%%%% running average trace
if handles.running_checkbox.Value
    if handles.runningcnt == 1
        handles.nbrSweeps = str2double(handles.sweep_edit.String);
        handles.runningtrace = nan(handles.nbrSamples, handles.nbrSweeps);
    end
    
    handles.indrunning = mod(handles.runningcnt, handles.nbrSweeps)+1;
    handles.runningtrace(:,handles.indrunning) = handles.trace(1:handles.nbrSamples);
    handles.runningcnt = handles.runningcnt+1;
    runningtrace = nanmean(handles.runningtrace,2);

    if isfield(handles, 'runningPlot') && isvalid(handles.runningPlot)
        set(handles.runningPlot, 'YData', runningtrace(1:handles.nbrSamples));        
    else
        set(handles.MASS_figure, 'CurrentAxes', handles.normal_axes); hold on; grid on;
        handles.runningPlot = plot(handles.timeaxis, runningtrace(1:handles.nbrSamples));
    end
else
    handles.runningcnt = 1;
end

%%%%% sweep trace
if handles.sweep_checkbox.Value
    if isfield(handles, 'sweepPlot') && isgraphics(handles.sweepPlot)
        set(handles.sweepPlot, 'YData', handles.sweeptrace(1:handles.nbrSamples)/handles.sweepcnt);
    else
        set(handles.MASS_figure, 'CurrentAxes', handles.normal_axes); hold on; grid on;
        handles.sweepPlot = plot(handles.timeaxis, handles.sweeptrace(1:handles.nbrSamples)/handles.sweepcnt);
    end
end
drawnow;