function varargout = batchgui(varargin)
% BATCHGUI MATLAB code for batchgui.fig
%      BATCHGUI, by itself, creates a new BATCHGUI or raises the existing
%      singleton*.
%
%      H = BATCHGUI returns the handle to a new BATCHGUI or the handle to
%      the existing singleton*.
%
%      BATCHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BATCHGUI.M with the given input arguments.
%
%      BATCHGUI('Property','Value',...) creates a new BATCHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before batchgui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to batchgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help batchgui

% Last Modified by GUIDE v2.5 28-Feb-2017 10:58:53

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @batchgui_OpeningFcn, ...
                   'gui_OutputFcn',  @batchgui_OutputFcn, ...
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
end

% --- Executes just before batchgui is made visible.
function batchgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to batchgui (see VARARGIN)

% Choose default command line output for batchgui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes batchgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = batchgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


function NumSim_Callback(hObject, eventdata, handles)
% hObject    handle to NumSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumSim as text
%        str2double(get(hObject,'String')) returns contents of NumSim as a double
end


% --- Executes on button press in BatchrunButton.
function BatchrunButton_Callback(hObject, eventdata, handles)
hFluEggGui = getappdata(0,'hFluEggGui');
inputdata=getappdata(hFluEggGui,'inputdata');
inputdata.Batch.NumSim=str2double(get(handles.NumSim,'String'));
inputdata.Batch.continuee=1;
setappdata(hFluEggGui,'inputdata',inputdata)
close(handles.figure1)%Close GUI
end
