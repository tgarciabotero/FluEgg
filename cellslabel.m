%%%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                       Add labels to figures                            %
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This function is used to add label of cells to figures                  %
%-------------------------------------------------------------------------%
%                                                                         %
%-------------------------------------------------------------------------%
%   Created by      : Tatiana Garcia                                      %
%   Last Modified   : May 17, 2016                                      %
%-------------------------------------------------------------------------%
% Inputs:
% Outputs:
% Copyright 2016 Tatiana Garcia
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%

function varargout = cellslabel(varargin)
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

% --- Outputs from this function are returned to the command line.
function varargout = cellslabel_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% If user press button_Yes.
function button_Yes_Callback(hObject, eventdata, handles)
label_on=1;
handleResults=getappdata(0,'handleResults'); 
setappdata(handleResults, 'label_on', label_on); 
close;

% If user press button_Yes._No.
function button_No_Callback(hObject, eventdata, handles)
label_on=0;
handleResults=getappdata(0,'handleResults'); 
setappdata(handleResults, 'label_on', label_on);  
close;
