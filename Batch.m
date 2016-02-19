function varargout = Batch(varargin)
% BATCH MATLAB code for Batch.fig
%      BATCH, by itself, creates a new BATCH or raises the existing
%      singleton*.
%
%      H = BATCH returns the handle to a new BATCH or the handle to
%      the existing singleton*.
%
%      BATCH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BATCH.M with the given input arguments.
%
%      BATCH('Property','Value',...) creates a new BATCH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Batch_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Batch_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Batch

% Last Modified by GUIDE v2.5 25-Jul-2012 09:54:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Batch_OpeningFcn, ...
                   'gui_OutputFcn',  @Batch_OutputFcn, ...
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


% --- Executes just before Batch is made visible.
function Batch_OpeningFcn(hObject, eventdata, handles, varargin)
axes(handles.bottom); imshow('./icons/asiancarp.png');
axes(handles.logoUofI); imshow('./icons/imark.tif');
axes(handles.logo_usgs); imshow('./icons/logo_usgs.png');
handles.output = hObject;
guidata(hObject, handles);

function varargout = Batch_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function BatchRun_botton_Callback(hObject, eventdata, handles)
hAcetGui=getappdata(0,'hAcetGui');
fhRunning=getappdata(hAcetGui,'fhRunning');
handlesmain=getappdata(hAcetGui, 'handlesmain');
Batch=get(handles.BatchRun_botton,'Value');
setappdata(hAcetGui, 'Batch', Batch);
No=str2double(get(handles.No,'String'));
setappdata(hAcetGui, 'No', No);
feval(fhRunning);

function X_Callback(hObject, eventdata, handles)
function X_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Nlayers_Callback(hObject, eventdata, handles)
addpath('./Codes/Postprocessing');
handles.eddit=0;
Vertical_Dist
guidata(hObject, handles);
function Nlayers_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function No_Callback(hObject, eventdata, handles)

function No_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Extra_node_Callback(hObject, eventdata, handles)

function Extra_node_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushB_Extra_node_Callback(hObject, eventdata, handles)
addpath('./Codes/Postprocessing');
handles.eddit=0;
Vertical_Dist


% --- Executes when entered data in editable cell(s) in Nodes.
function Nodes_CellEditCallback(hObject, eventdata, handles)
handles.eddit=1;
addpath('./Codes/Plots');
Vertical_Dist
