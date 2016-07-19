function varargout = Longitudinal_Dist_Eggs(varargin)
% Last Modified by GUIDE v2.5 14-Aug-2014 10:36:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Longitudinal_Dist_Eggs_OpeningFcn, ...
    'gui_OutputFcn',  @Longitudinal_Dist_Eggs_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Longitudinal_Dist_Eggs is made visible.
function Longitudinal_Dist_Eggs_OpeningFcn(hObject, ~, handles, varargin)
diary('./results/FluEgg_LogFile.txt')
handleResults=getappdata(0,'handleResults');
ResultsSim=getappdata(handleResults,'ResultsSim');
Temp=ResultsSim.Temp;
%%Eggs biological properties
specie=ResultsSim.specie;
%%
set(handles.SetTime,'String',round((ResultsSim.time(end)/3600)*10)/10);
setappdata(handleResults, 'continue', 0); 
handles.output = hObject;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Longitudinal_Dist_Eggs_OutputFcn(~, ~, handles)
diary off
varargout{1} = handles.output;

function SetTime_Callback(~, ~, handles)
function SetTime_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Continue_button.
function Continue_button_Callback(hObject, eventdata, handles)
handleResults=getappdata(0,'handleResults'); 
SetTime=str2double(get(handles.SetTime,'String'));
ResultsSim=getappdata(handleResults,'ResultsSim');
CalculateEggs_at_risk_hatching=(get(handles.Hatchingrisk,'value'));
%% Error checking==========================================================
if isempty(SetTime)||isnan(SetTime)
    ed=msgbox('Empty input field. Please make sure all required fields are filled out correctly ','FluEgg Error: Empty fields','error');
    try
    rmappdata(handleResults,'SetTime') 
    catch
        %If the handle does not exist, dont do anything
    end
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed); 
    return
end
if SetTime<=0
    ed=msgbox('Incorrect negative or zero value. Please make sure all required fields are filled out correctly','FluEgg Error: Incorrect negative or zero value','error');
     try
    rmappdata(handleResults,'SetTime') 
    catch
        %If the handle does not exist, dont do anything
    end
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
    return
end
if SetTime>str2double(num2str(round(ResultsSim.time(end)*10/3600)/10)) 
  ed = errordlg('Time exceeds simulation time','FluEgg Error: incorrect input value');
   try
    rmappdata(handleResults,'SetTime') 
    catch
        %If the handle does not exist, dont do anything
    end
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed); 
    return
end
if (CalculateEggs_at_risk_hatching==1)&(SetTime<str2double(num2str(ResultsSim.T2_Hatching)))
    ed = errordlg('The time is less than the estimated hatching time, the eggs at risk of hatching cannot be calculated','FluEgg Error: incorrect input value');
    try
        rmappdata(handleResults,'SetTime')
    catch
        %If the handle does not exist, dont do anything
    end
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
    return
end
%==========================================================================
  
    
setappdata(handleResults, 'SetTime', SetTime); 
setappdata(handleResults, 'CalculateEggs_at_risk_hatching', CalculateEggs_at_risk_hatching); 
setappdata(handleResults, 'continue', 1); 
close(handles.figure1)

% --- Executes on button press in Hatchingrisk.
function Hatchingrisk_Callback(hObject, eventdata, handles)

% --- Executes on button press in Set_2_hatching_time.
function Set_2_hatching_time_Callback(hObject, eventdata, handles)
handleResults=getappdata(0,'handleResults');
ResultsSim=getappdata(handleResults,'ResultsSim');
%%
set(handles.SetTime,'String',ResultsSim.T2_Hatching);
