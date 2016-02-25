function varargout = downDist(varargin)
% DOWNDIST MATLAB code for downDist.fig
%      DOWNDIST, by itself, creates a new DOWNDIST or raises the existing
%      singleton*.
%
%      H = DOWNDIST returns the handle to a new DOWNDIST or the handle to
%      the existing singleton*.
%
%      DOWNDIST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DOWNDIST.M with the given input arguments.
%
%      DOWNDIST('Property','Value',...) creates a new DOWNDIST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before downDist_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to downDist_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help downDist

% Last Modified by GUIDE v2.5 28-Aug-2013 10:11:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @downDist_OpeningFcn, ...
                   'gui_OutputFcn',  @downDist_OutputFcn, ...
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


% --- Executes just before downDist is made visible.
function downDist_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to downDist (see VARARGIN)

% Choose default command line output for downDist
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes downDist wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = downDist_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function dX_Callback(hObject, eventdata, handles)
% hObject    handle to dX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dX as text
%        str2double(get(hObject,'String')) returns contents of dX as a double


% --- Executes during object creation, after setting all properties.
function dX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Continuebutton.
function Continuebutton_Callback(hObject, eventdata, handles)
dX=str2double(get(handles.dX,'String'))*1000;% It is in km and then we convert it to m
handleResults=getappdata(0,'handleResults'); 
ResultsSim=getappdata(handleResults,'ResultsSim');
CumlDistance=ResultsSim.CumlDistance;
if dX>CumlDistance(end)*1000
  ed = errordlg('The longitudinal distance you input is out of the domain','Error');
  return
  set(ed, 'WindowStyle', 'modal');
  uiwait(ed); 
end
setappdata(handleResults, 'dX', dX); 
close;
 



