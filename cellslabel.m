function varargout = cellslabel(varargin)
% CELLSLABEL MATLAB code for cellslabel.fig
%      CELLSLABEL, by itself, creates a new CELLSLABEL or raises the existing
%      singleton*.
%
%      H = CELLSLABEL returns the handle to a new CELLSLABEL or the handle to
%      the existing singleton*.
%
%      CELLSLABEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELLSLABEL.M with the given input arguments.
%
%      CELLSLABEL('Property','Value',...) creates a new CELLSLABEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cellslabel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cellslabel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cellslabel

% Last Modified by GUIDE v2.5 27-Aug-2013 12:04:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cellslabel_OpeningFcn, ...
                   'gui_OutputFcn',  @cellslabel_OutputFcn, ...
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


% --- Executes just before cellslabel is made visible.
function cellslabel_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% UIWAIT makes cellslabel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cellslabel_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in button_Yes.
function button_Yes_Callback(hObject, eventdata, handles)
label_on=1;
handleResults=getappdata(0,'handleResults'); 
setappdata(handleResults, 'label_on', label_on); 
close;


% --- Executes on button press in button_No.
function button_No_Callback(hObject, eventdata, handles)
label_on=0;
handleResults=getappdata(0,'handleResults'); 
setappdata(handleResults, 'label_on', label_on);  
close;
