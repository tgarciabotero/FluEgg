function varargout = FluEgg(varargin)
%%%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                       MAIN INTERFACE PROGRAM                           %
%%           Lagrangian Asian Carp Egg Transport Model                    %
%%         for Control and Evaluation of Spawning Rivers
%%             FLUVIAL EGG DRIFT SIMULATOR (FluEgg)
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This interface is used to facilitate the use of the FluEgg developed by % 
% Tatiana Garcia.                                                         %
%                                                                         %
%-------------------------------------------------------------------------%
%                                    %
%-------------------------------------------------------------------------%
%   Created by      : Tatiana Garcia                                      %
%   Date            : May 20, 2010                                        %
%   Last Modified   : July 26, 2013  
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%
%      H = FLUEGG returns the handle to a new FLUEGG or the handle to
%      the existing singleton*.
%      FLUEGG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FLUEGG.M with the given input arguments.
%      FLUEGG('Property','Value',...) creates a new FLUEGG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FluEgg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FluEgg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FluEgg

% Last Modified by GUIDE v2.5 10-Oct-2013 10:35:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FluEgg_OpeningFcn, ...
                   'gui_OutputFcn',  @FluEgg_OutputFcn, ...
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

% --- Executes just before FluEgg is made visible.
function FluEgg_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
%% Figures and icons
axes(handles.riverfig); imshow('riverfig.png');
axes(handles.eggsfig); imshow('eggsfig2.png');
axes(handles.bottom); imshow('asiancarp.png');
guidata(hObject, handles);% Update handles structure

% --- Outputs from this function are returned to the command line.
function varargout = FluEgg_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

%% River input data::::::::::::::::::::::::::::::::::::::::::::::::::::::%

% --- Executes on button press in Load_River_Input.
function Load_River_Input_Callback(hObject,eventdata, handles)
delete('./results/FluEgg_LogFile.txt')
diary('./results/FluEgg_LogFile.txt')
workpath = pwd;setappdata(0,'workpath',workpath);
%% Main handles
setappdata(0,'hFluEggGui',gcf);
setappdata(gcf,   'handlesmain'    , handles);
setappdata(gcf,   'hObjectmain'    , hObject);
setappdata(gcf,   'eventdatamain'    , eventdata);
%setappdata(gcf,   'Batch'    , 0);
setappdata(gcf,'fhRunning',@Running);
Edit_River_Input_File();
%% Make Visible
set(handles.Summary_panel,'Visible','on');
    set(handles.text13,'Visible','on');
    set(handles.text14,'Visible','on');
    set(handles.text15,'Visible','on');
    set(handles.text16,'Visible','on');
    set(handles.text17,'Visible','on');
    set(handles.MinH,'Visible','on');
    set(handles.MinW,'Visible','on');
    set(handles.MinX,'Visible','on');
    set(handles.MaxH,'Visible','on');
    set(handles.MaxW,'Visible','on');
    set(handles.MaxX,'Visible','on');
set(handles.Simulation_setup,'Visible','on');
    set(handles.Totaltime,'Visible','on');
    set(handles.text11,'Visible','on');
    set(handles.Dt,'Visible','on');
    set(handles.text12,'Visible','on');
set(handles.simulation_panel,'Visible','on');
    set(handles.Running,'Visible','on');
set(handles.Running,'Visible','on');
%% Make Results Invisible
set(handles.panel_Results,'Visible','off');
set(handles.NewSim_Button,'Visible','off');
guidata(hObject, handles);% Update handles structure

function popup_roughness_Callback(hObject, ~, handles)
guidata(hObject,handles)
function popup_roughness_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popupDiffusivity_Callback(hObject, eventdata, handles)
function popupDiffusivity_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_River_name_Callback(~, ~, handles)
function edit_River_name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Spawning event Getting Input data
%% ::::::::::::::::::::::::::::::::::::::::::::::::::::%
function Num_Eggs_Callback(~, ~, handles)
function Num_Eggs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Zi_input_Callback(hObject, eventdata, handles)
function Zi_input_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Yi_input_Callback(hObject, ~, handles)
load './Temp/temp_variables.mat' 
Width=temp_variables.Width;
set(handles.Yi_input,'String',floor(Width(1)*100/2)/100);
guidata(hObject, handles);% Update handles structure
function Yi_input_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Xi_input_Callback(hObject, ~, handles)
load './Temp/temp_variables.mat'
CumlDistance=temp_variables.CumlDistance;
Width=temp_variables.Width;
%% Find initial cell
Xi=str2double(get(handles.Xi_input,'String'));
if Xi>CumlDistance(end)*1000
    ed = errordlg('Spawning location is outside the domain, try a smaller value for Xi','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);  
end
C=find(Xi<CumlDistance*1000);C=C(1);
%% Update Yi
set(handles.Yi_input,'String',floor(Width(C)*100/2)/100);
guidata(hObject, handles);% Update handles structure
function Xi_input_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Eggs Characteristics Getting Input data
%% ::::::::::::::::::::::::::::::::::::::::::::::::::::%
function popup_EggsChar_Callback(hObject, ~, handles)
% Determine the selected data set.
str = get(handles.popup_EggsChar, 'String');
val = get(handles.popup_EggsChar,'Value');
% Set current data to the selected data set.
switch str{val};
case 'Use diameter and egg density time series (Chapman, 2011)'
  set(handles.textDiameter,'Visible','off');
  set(handles.ConstD,'Visible','off');
  set(handles.textDensity,'Visible','off');
  set(handles.text_at,'Visible','off');
  set(handles.Tref,'Visible','off');
  set(handles.text_C,'Visible','off');
  set(handles.ConstRhoe,'Visible','off');
  %set(handles.textPostFert_Time,'Visible','on');
  %set(handles.PostferT,'Visible','on');
case 'Use constant egg diameter and density' 
  set(handles.textPostFert_Time,'Visible','off');
  set(handles.PostferT,'Visible','off');
  set(handles.textDiameter,'Visible','on');
  set(handles.ConstD,'Visible','on');
  set(handles.textDensity,'Visible','on');
  set(handles.text_at,'Visible','on');
  set(handles.Tref,'Visible','on');
  set(handles.text_C,'Visible','on');
  set(handles.ConstRhoe,'Visible','on');
  end
guidata(hObject,handles)
function popup_EggsChar_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ConstD_Callback(hObject, eventdata, handles)
function ConstD_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function PostferT_Callback(~, ~, handles)
function PostferT_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ConstRhoe_Callback(hObject, eventdata, handles)
function ConstRhoe_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Tref_Callback(hObject, eventdata, handles)
function Tref_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Simulation setup Getting Input data ::::::::::::::::::::::::::::::::::::::::::::::::::::%
function Totaltime_Callback(hObject, eventdata, handles)
function Totaltime_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Dt_Callback(hObject, eventdata, handles)
function Dt_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Running
hFluEggGui=getappdata(0,'hFluEggGui');
handles= getappdata(hFluEggGui, 'handlesmain');
hObject=getappdata(hFluEggGui,   'hObjectmain');
eventdata=getappdata(hFluEggGui,   'eventdatamain');
Running_Callback(hObject, eventdata, handles);

%% Running the model::::::::::::::::::::::::::::::::::::::::::::::::::::::%
function Running_Callback(hObject, eventdata, handles)
%% Get data from Handles
handles.userdata.Num_Eggs=str2double(get(handles.Num_Eggs,'String'));
handles.userdata.Xi=str2double(get(handles.Xi_input,'String'));
handles.userdata.Yi=str2double(get(handles.Yi_input,'String'));
handles.userdata.Zi=str2double(get(handles.Zi_input,'String'));
handles.userdata.Dt=str2double(get(handles.Dt,'String'));
handles.userdata.Totaltime=str2double(get(handles.Totaltime,'String'));
%% Get Data from Main GUI
hFluEggGui=getappdata(0,'hFluEggGui');
Batch=getappdata(hFluEggGui,'Batch');  %Getting info from Batch GUI
No=getappdata(hFluEggGui,'No');  %Getting info from Batch GUI;
if Batch==1
for k=1:No
FluEgggui(hObject, eventdata,handles);
Vert_Dist
load './results/Vertdist.mat'
if k==1
    batchresults=Vertdist;
else
    batchresults=[batchresults Vertdist(:,2)];
end
save('./results/Vertdist.mat','batchresults','-append')
end
else
     if length(get(handles.edit_River_name, 'String'))<2
         ed = errordlg('Please input the river name','Error');
         set(ed, 'WindowStyle', 'modal');
         uiwait(ed);
         return
     end
    FluEgggui(hObject, eventdata,handles);
   % Vert_Dist %% need to comment this out later-->this is to produce%results without using the results gui
end
beep
%% Make invisible
set(handles.Running,'Visible','off');
%% Make Results Visible
set(handles.panel_Results,'Visible','on');
    set(handles.Results,'Visible','on');
set(handles.NewSim_Button,'Visible','on');
diary off
guidata(hObject, handles);

%% Analyze the Results::::::::::::::::::::::::::::::::::::::::::::::::::::::%
function Results_Callback(hObject, eventdata, handles)
Results();

function NewSim_Button_Callback(hObject, eventdata, handles)
set(handles.Summary_panel,'Visible','off');
set(handles.Simulation_setup,'Visible','off');
set(handles.simulation_panel,'Visible','off');
set(handles.panel_Results,'Visible','off');
guidata(hObject, handles);

function Batch_button_Callback(hObject, eventdata, handles)
Batch();
set(handles.Batch_button,'Value',1) 
display(get(handles.popup_EggsChar,'Value'))
guidata(hObject, handles);


% --------------------------------------------------------------------
function Analyze_Results_Callback(hObject, eventdata, handles)
% hObject    handle to Analyze_Results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Results();

% --------------------------------------------------------------------
function tools_Callback(hObject, eventdata, handles)
% hObject    handle to tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
