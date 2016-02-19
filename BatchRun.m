function varargout = BatchRun(varargin)
% BatchRun MATLAB code for BatchRun.fig
%      BatchRun, by itself, creates a new BatchRun or raises the existing
%      singleton*.
%
%      H = BatchRun returns the handle to a new BatchRun or the handle to
%      the existing singleton*.
%
%      BatchRun('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BatchRun.M with the given input arguments.
%
%      BatchRun('Property','Value',...) creates a new result or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BatchRun_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BatchRun_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BatchRun_OpeningFcn, ...
                   'gui_OutputFcn',  @BatchRun_OutputFcn, ...
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

%%
 addpath('./icons');

function BatchRun_OpeningFcn(hObject, eventdata, handles, varargin)
axes(handles.bottom); imshow('./icons/asiancarp.png');
axes(handles.logoUofI); imshow('./icons/imark.tif');
axes(handles.logo_usgs); imshow('./icons/logo_usgs.png');
handles.output = hObject;
guidata(hObject, handles);
 
function varargout = BatchRun_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function X_Callback(hObject, eventdata, handles)
x=5;
function X_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_Callback(hObject, eventdata, handles)
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Nlayers_Callback(hObject, eventdata, handles)
addpath('./Codes/Postprocessing');
handles.eddit=0;
Vertical_Dist
guidata(hObject, handles);

function Extra_node_Callback(hObject, eventdata, handles)


function Extra_node_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pushB_Extra_node_Callback(hObject, eventdata, handles)
addpath('./Codes/Postprocessing');
handles.eddit=0;
Vertical_Dist


function Nlayers_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function MaxNode_Callback(hObject, eventdata, handles)
addpath('./Codes/Plots');
handles.eddit=0;
Vertical_Dist

function MaxNode_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in Nodes.
function Nodes_CellEditCallback(hObject, eventdata, handles)
handles.eddit=1;
addpath('./Codes/Plots');
Vertical_Dist



function edit6_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
