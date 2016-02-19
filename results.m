function varargout = results(varargin)
% RESULTS MATLAB code for results.fig
%      RESULTS, by itself, creates a new RESULTS or raises the existing
%      singleton*.
%
%      H = RESULTS returns the handle to a new RESULTS or the handle to
%      the existing singleton*.
%
%      RESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESULTS.M with the given input arguments.
%
%      RESULTS('Property','Value',...) creates a new RESULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before results_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to results_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help results

% Last Modified by GUIDE v2.5 06-Aug-2012 15:07:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @results_OpeningFcn, ...
                   'gui_OutputFcn',  @results_OutputFcn, ...
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


% --- Executes just before results is made visible.
function results_OpeningFcn(hObject, eventdata, handles, varargin)
axes(handles.bottom); imshow('./icons/asiancarp.png');
axes(handles.logoUofI); imshow('./icons/imark.tif');
axes(handles.logo_usgs); imshow('./icons/logo_usgs.png');
handles.output = hObject;
handles.update=0;
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = results_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%% ========================================================================
%% 1.  Single Run Options
function SingleRun_button_Callback(hObject, eventdata, handles)
display(2)

  function SingleRun_popup(hObject, eventdata, handles)
% Determine the selected data set.
str=get(handles.SingleRun_popup, 'String');
val=get(handles.SingleRun_popup,'Value');
% Set current data to the selected data set.
% switch str{val};
%         case 'Log Law Smooth Bottom Boundary (Case flumes)'  
%         set(handles.textKs,'Visible','off');
%         set(handles.Ks,'Visible','off');
%         case 'Log Law Rogh Bottom Boundary (Case rivers)' 
%         set(handles.textKs,'Visible','on');
%         set(handles.Ks,'Visible','on');       
% end
guidata(hObject,handles)

%% 2.  Batch Run Options
function Batch_button_Callback(hObject, eventdata, handles)

function X_Callback(hObject, eventdata, handles)
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

function Extra_node_PushB_Callback(hObject, eventdata, handles)
addpath('./Codes/Postprocessing');
handles.eddit=1;
Vertical_Dist
guidata(hObject, handles);
function Nlayers_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Button_plotVertDist_Callback(hObject, eventdata, handles)
addpath('./Codes/Plots');
Vert_Dist
function Grid_on_Callback(hObject, eventdata, handles)
function MaxNode_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Nodes_CellEditCallback(hObject, eventdata, handles)
handles.update=1;
addpath('./Codes/Plots');
Vertical_Dist


% --- Executes during object creation, after setting all properties.
function SingleRun_popup_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
