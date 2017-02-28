function [pbias, nse] = modeleval(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%sim, obs are arrays of simulated and observed time series
%sim and obs elements do not occur at the same time
%modeleval() computes statistical measurements to evaluate the model
%performance against observations.
%Ref: Moriasi, D. N., Arnold, J. G., Van Liew, M. W., Binger, 
%     R. L., Harmel, R. D., & Veith, T. L. (2007). 
%     Model evaluation guidelines for systematic quantification of accuracy
%     in watershed simulations. Transactions of the ASABE, 50(3), 885–900. 
%     http://doi.org/10.13031/2013.23153
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load handles & Objects
hFluEggGui = getappdata(0,'hFluEggGui');
HECRAS_data = getappdata(hFluEggGui,'inputdata');
h   = handles.Plot_Hydrograph;
str = get(handles.popup_River_Station, 'String');            
val = get(handles.popup_River_Station, 'Value');
currentRS = HECRAS_data.RiverStation;
obs_data    = getappdata(hFluEggGui,'obsdata');

%% Load data
%HEC-RAS (simulation)
if get(handles.checkbox_flow,'value') == 1
    % Flow Hydrograph
    sim = HECRAS_data.TS(:,2);
elseif get(handles.checkbox_H,'value') == 1
    % Water Level hydrograph
    sim = HECRAS_data.TS(:,3);
else
    % No hydrograph has been selected
    m = msgbox('Please select a variable to plot',...
        'FluEgg error','error');
    uiwait(m)
    return
end %if
sim_date = arrayfun(@(x) datenum(x,'ddmmyyyy HHMM'), HECRAS_data.Dates);

%Observed Data
obs = obs_data.data{1,4};
text1 = obs_data.data{1,2};
text2 = obs_data.data{1,3};
profile = arrayfun(@(x, y) strcat(x,{' '},y), text1, text2);
obs_date = arrayfun(@(x) datenum(x,'ddmmyyyy HHMM'), profile);

%Interpolate simulation results at each observation time
sim_intrp = interp1(sim_date, sim, obs_date);
% h3 = line(obs_date, sim_intrp, 'Parent', h);
% h3.LineStyle        = 'none';
% h3.Marker           = 's';
% h3.MarkerEdgeColor  = 'm';
% h3.MarkerSize       = 2;
%% Compute statistics
pbias = sum(obs - sim_intrp)*100/sum(obs); % PBIAS
nse   = 1 - (sum((obs - sim_intrp).^2) / sum((obs - mean(obs).^2)));% Nash-Sutcliffe
