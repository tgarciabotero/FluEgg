%==============================================================================
% FluEgg -Fluvial Egg Drift Simulator
%==============================================================================
% Copyright (c) 2013 Tatiana Garcia

   % This program is free software: you can redistribute it and/or modify
    % it under the terms of the GNU General Public License version 3 as published by
    % the Free Software Foundation (currently at http://www.gnu.org/licenses/agpl.html) 
    % with a permitted obligation to maintain Appropriate Legal Notices.

    % This program is distributed in the hope that it will be useful,
    % but WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    % GNU General Public License for more details.

    % You should have received a copy of the GNU General Public License
    % along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
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
%  
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
