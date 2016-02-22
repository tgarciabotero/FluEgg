function varargout = FluEgg(varargin)
%%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                       MAIN INTERFACE PROGRAM                           %
%%           Lagrangian Asian Carp Egg Transport Model                    %
%%         for Control and Evaluation of Spawning Rivers                  %
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
%   Last Modified   : Dec 12, 2012  
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%                                                                         %
% Begin initialization code - DO NOT EDIT                                 %
gui_Singleton = 1;                                                        %
gui_State = struct('gui_Name',       mfilename, ...                       %
                   'gui_Singleton',  gui_Singleton, ...                   %
                   'gui_OpeningFcn', @FluEgg_OpeningFcn, ...              %
                   'gui_OutputFcn',  @FluEgg_OutputFcn, ...               %
                   'gui_LayoutFcn',  [] , ...                             %
                   'gui_Callback',   []);                                 %
if nargin && ischar(varargin{1})                                          %
    gui_State.gui_Callback = str2func(varargin{1});                       %
end                                                                       %
if nargout                                                                %
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});         %
else                                                                      %
   gui_mainfcn(gui_State, varargin{:});                                  %
end                                                                       %
% End initialization code - DO NOT EDIT                                   %
warning('off', 'MATLAB:dispatcher:UnresolvedFunctionHandle');                                                                          %
%% Code Paths:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
    addpath('./Codes');
    %:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::% 

function FluEgg_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
%% Figures and icons
axes(handles.riverfig); imshow('./icons/riverfig.png');
axes(handles.eggsfig); imshow('./icons/eggsfig2.png');
axes(handles.waterclock); imshow('./icons/waterclock.png');
axes(handles.bottom); imshow('./icons/asiancarp.png');
axes(handles.logoUofI); imshow('./icons/imark.tif');
axes(handles.logo_usgs); imshow('./icons/logo_usgs.png');
addpath('./User_Interfaces/');
workpath = pwd;
setappdata(0,'workpath',workpath);
guidata(hObject, handles);% Update handles structure
%% Main handles
setappdata(0,'hFluEggGui',gcf);
setappdata(gcf,   'handlesmain'    , handles);
setappdata(gcf,   'hObjectmain'    , hObject);
setappdata(gcf,   'eventdatamain'    , eventdata);
setappdata(gcf,   'Batch'    , 0);
setappdata(gcf,'fhRunning',@Running);


function varargout = FluEgg_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

%% River input data::::::::::::::::::::::::::::::::::::::::::::::::::::::%
function riverfig_CreateFcn(hObject, eventdata, handles)
function RiverInPannel_SelectionChangeFcn(hObject, eventdata, handles)
function RiverInPannel_CreateFcn(hObject, eventdata, handles)

function Load_River_Input_Callback(hObject, eventdata, handles)
Edit_River_Input_File();
%% Make Visible
set(handles.Summary_panel,'Visible','on');
set(handles.Simulation_setup,'Visible','on');
set(handles.simulation_panel,'Visible','on');
set(handles.Running,'Visible','on');
%% Make Results Invisible
set(handles.panel_Results,'Visible','off');
set(handles.NewSim_Button,'Visible','off');
guidata(hObject, handles);% Update handles structure

function popup_roughness_Callback(hObject, eventdata, handles)
guidata(hObject,handles)
function popup_roughness_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popupDiffusivity_Callback(hObject, eventdata, handles)
guidata(hObject,handles)
function popupDiffusivity_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%% Spawning event Getting Input data ::::::::::::::::::::::::::::::::::::::::::::::::::::%
function Num_Eggs_Callback(hObject, eventdata, handles)
function Num_Eggs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Xi_input_Callback(hObject, eventdata, handles)
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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Yi_input_Callback(hObject, eventdata, handles)
load './Temp/temp_variables.mat' 
Width=temp_variables.Width;
set(handles.Yi_input,'String',floor(Width(1)*100/2)/100);
guidata(hObject, handles);% Update handles structure
function Yi_input_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Zi_input_Callback(hObject, eventdata, handles)
function Zi_input_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Eggs Characteristics Getting Input data ::::::::::::::::::::::::::::::::::::::::::::::::::::%
function popup_EggsChar_Callback(hObject, eventdata, handles)
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
  set(handles.Ti,'Visible','off');
  set(handles.text_C,'Visible','off');
  set(handles.ConstRhoe,'Visible','off');
  set(handles.textPostFert_Time,'Visible','on');
  set(handles.PostferT,'Visible','on');
case 'Use constant egg diameter and density' 
  set(handles.textPostFert_Time,'Visible','off');
  set(handles.PostferT,'Visible','off');
  set(handles.textDiameter,'Visible','on');
  set(handles.ConstD,'Visible','on');
  set(handles.textDensity,'Visible','on');
  set(handles.text_at,'Visible','on');
  set(handles.Ti,'Visible','on');
  set(handles.text_C,'Visible','on');
  set(handles.ConstRhoe,'Visible','on');
  end
guidata(hObject,handles)
function popup_EggsChar_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function D_Callback(hObject, eventdata, handles)
function D_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function PostferT_Callback(hObject, eventdata, handles)
function PostferT_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function ConstD_Callback(hObject, eventdata, handles)
function ConstD_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function ConstRhoe_Callback(hObject, eventdata, handles)
function ConstRhoe_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Silver_Callback(hObject, eventdata, handles)
function Bighead_Callback(hObject, eventdata, handles)

%% Simulation setup Getting Input data ::::::::::::::::::::::::::::::::::::::::::::::::::::%
function Totaltime_Callback(hObject, eventdata, handles)
function Totaltime_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Dt_Callback(hObject, eventdata, handles)
function Dt_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% River geometry summary ::::::::::::::::::::::::::::::::::::::::::::::::::::%
function MinH_Callback(hObject, eventdata, handles)
function MinH_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function MinW_Callback(hObject, eventdata, handles)
function MinW_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function MinX_Callback(hObject, eventdata, handles)
function MinX_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function MaxH_Callback(hObject, eventdata, handles)
function MaxH_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function MaxW_Callback(hObject, eventdata, handles)
function MaxW_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function MaxX_Callback(hObject, eventdata, handles)
function MaxX_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function uipanelSpawning_CreateFcn(hObject, eventdata, handles)
function uipanelEggs_Chara_CreateFcn(hObject, eventdata, handles)
function Simulation_setup_CreateFcn(hObject, eventdata, handles)
function Summary_panel_CreateFcn(hObject, eventdata, handles)
function Batch_button_Callback(hObject, eventdata, handles)
Batch();
set(handles.Batch_button,'Value',1) 
display(get(handles.popup_EggsChar,'Value'))
guidata(hObject, handles);
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
    FluEgggui(hObject, eventdata,handles);
   % Vert_Dist %% need to comment this out later-->this is to produce%results without using the results gui
end
beep
%% Make invisible
set(handles.Running,'Visible','off');
%% Make Results Visible
set(handles.panel_Results,'Visible','on');
set(handles.NewSim_Button,'Visible','on');
guidata(hObject, handles);

%% Analyze the Results::::::::::::::::::::::::::::::::::::::::::::::::::::::%
function Results_Callback(hObject, eventdata, handles)
Results();
function uipanelEggs_Chara_DeleteFcn(hObject, eventdata, handles)
function Ks_Callback(hObject, eventdata, handles)
function Ks_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function NewSim_Button_Callback(hObject, eventdata, handles)
set(handles.Summary_panel,'Visible','off');
set(handles.Simulation_setup,'Visible','off');
set(handles.simulation_panel,'Visible','off');
set(handles.panel_Results,'Visible','off');
guidata(hObject, handles);

function Batch_button_CreateFcn(hObject, eventdata, handles)
function Running_ButtonDownFcn(hObject, eventdata, handles)
function Batch_Callback(hObject, eventdata, handles)

function Ti_Callback(hObject, eventdata, handles)

function Ti_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Results_menu_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Analyzeresults_Callback(hObject, eventdata, handles)
Results();

function edit_River_name_Callback(hObject, eventdata, handles)

function edit_River_name_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit58_Callback(hObject, eventdata, handles)

function edit58_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
