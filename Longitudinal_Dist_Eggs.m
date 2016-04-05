function varargout = Longitudinal_Dist_Eggs(varargin)
% LONGITUDINAL_DIST_EGGS MATLAB code for Longitudinal_Dist_Eggs.fig
%      LONGITUDINAL_DIST_EGGS, by itself, creates a new LONGITUDINAL_DIST_EGGS or raises the existing
%      singleton*.
%
%      H = LONGITUDINAL_DIST_EGGS returns the handle to a new LONGITUDINAL_DIST_EGGS or the handle to
%      the existing singleton*.
%
%      LONGITUDINAL_DIST_EGGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LONGITUDINAL_DIST_EGGS.M with the given input arguments.
%
%      LONGITUDINAL_DIST_EGGS('Property','Value',...) creates a new LONGITUDINAL_DIST_EGGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Longitudinal_Dist_Eggs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Longitudinal_Dist_Eggs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Longitudinal_Dist_Eggs

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
Temp=ResultsSim.Temp;
specie=ResultsSim.specie;
CalculateEggs_at_risk_hatching=(get(handles.Hatchingrisk,'value'));
    if SetTime==0
        ed = errordlg('Time=0 is not allowed','Error');
        set(ed, 'WindowStyle', 'modal');
        uiwait(ed);
    elseif SetTime>str2double(num2str(round(ResultsSim.time(end)*10/3600)/10)) 
        ed = errordlg('Time exceeds simulation time','Error');
        set(ed, 'WindowStyle', 'modal');
        uiwait(ed);
    end
    if (CalculateEggs_at_risk_hatching==1)&(SetTime<str2double(num2str(round(HatchingTime(Temp,specie)*10)/10)))
        ed = errordlg('The time is less than the estimated hatching time, the eggs at risk of hatching can not be calculated','Error');
        set(ed, 'WindowStyle', 'modal');
        uiwait(ed);
    end
setappdata(handleResults, 'SetTime', SetTime); 
setappdata(handleResults, 'CalculateEggs_at_risk_hatching', CalculateEggs_at_risk_hatching); 

close(handles.figure1)

% --- Executes on button press in Hatchingrisk.
function Hatchingrisk_Callback(hObject, eventdata, handles)

% --- Executes on button press in Set_2_hatching_time.
function Set_2_hatching_time_Callback(hObject, eventdata, handles)
handleResults=getappdata(0,'handleResults');
ResultsSim=getappdata(handleResults,'ResultsSim');
Temp=ResultsSim.Temp;
%%Eggs biological properties
specie=ResultsSim.specie;
%%
set(handles.SetTime,'String',HatchingTime(Temp,specie));
