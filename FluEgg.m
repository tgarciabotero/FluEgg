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
%   Last Modified   : March 20, 2014
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

% Last Modified by GUIDE v2.5 28-Jul-2014 13:31:57

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
axes(handles.FluEgg_Logo); imshow('logo.png');
axes(handles.riverfig); imshow('riverfig.png');
axes(handles.eggsfig); imshow('eggsfig2.png');
axes(handles.bottom); imshow('asiancarp.png');
%% Settings
handles.settings=FluEgg_Settings;
guidata(hObject, handles);% Update handles structure

% --- Outputs from this function are returned to the command line.
function varargout = FluEgg_OutputFcn(~, ~, handles)
varargout{1} = handles.output;

%% River input data::::::::::::::::::::::::::::::::::::::::::::::::::::::%

% --- Executes on button press in Load_River_Input.
function Load_River_Input_Callback(hObject,eventdata, handles)
delete('./results/FluEgg_LogFile.txt')
try
    diary('./results/FluEgg_LogFile.txt')
catch
    ed = errordlg(' File ./results/FluEgg_LogFile.txt not found','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
end
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
function popup_roughness_CreateFcn(hObject, ~, ~)
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
function Yi_input_CreateFcn(hObject, ~, ~)
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
function Xi_input_CreateFcn(hObject, ~, handles)
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

function ConstD_Callback(hObject, ~, ~)
function ConstD_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function PostferT_Callback(~, ~, handles)
function PostferT_CreateFcn(hObject, eventdata, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ConstRhoe_Callback(~, ~, ~)
function ConstRhoe_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Tref_Callback(hObject, ~, ~)
function Tref_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Simulation setup Getting Input data ::::::::::::::::::::::::::::::::::::::::::::::::::::%
function Totaltime_Callback(hObject, eventdata, handles)

function Totaltime_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Dt_Callback(hObject, eventdata, handles)

%
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
CheckDt=0;
%% Get Data from Main GUI
hFluEggGui=getappdata(0,'hFluEggGui');
if length(get(handles.edit_River_name, 'String'))<2
    ed = errordlg('Please input the river name','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
    return
end
%%
%% Batch Run
Batch=0;  %
handles.userdata.Batch=Batch;
No=100;  %Getting info from Batch GUI;
if Batch==1
    for k=1:No
        handles.userdata.RunNumber=k;
        if k==1
            [minDt,CheckDt,Exit]=FluEgggui(hObject, eventdata,handles,CheckDt);
            %% Checking Dt
            if handles.userdata.Dt>minDt  % If we exit the running function because Dt is to large, correct Dt
                set(handles.Dt,'String',minDt);
                handles.userdata.Dt=minDt;
                FluEgggui(hObject, eventdata,handles,CheckDt);
            end
        else
            FluEgggui(hObject, eventdata,handles,CheckDt);
        end
    end
else
    [minDt,CheckDt,Exit]=FluEgggui(hObject, eventdata,handles,CheckDt);
    %% Checking Dt
    if handles.userdata.Dt>minDt  % If we exit the running function because Dt is to large, correct Dt
        set(handles.Dt,'String',minDt);
        handles.userdata.Dt=minDt;
        FluEgggui(hObject, eventdata,handles,CheckDt);
    end
end

%% If Simulation time greater than hatching time
if minDt==0
    return
end

try
    if Exit==0
        % Make invisible
        set(handles.Running,'Visible','off');
        % Make Results Visible
        set(handles.panel_Results,'Visible','on');
        set(handles.Results,'Visible','on');
        set(handles.NewSim_Button,'Visible','on');
        diary off
        guidata(handles.figure1, handles);
    end
catch
    %If there was an error during the simulation (FluEgggui)
    msgbox('An unexpected error occurred, FluEgg is going to close','FluEgg error','error')
    pause(4)
end

%% Analyze the Results::::::::::::::::::::::::::::::::::::::::::::::::::::::%
function Results_Callback(hObject, eventdata, handles)
Results();

function NewSim_Button_Callback(hObject, ~, handles)
set(handles.Summary_panel,'Visible','off');
set(handles.Simulation_setup,'Visible','off');
set(handles.simulation_panel,'Visible','off');
set(handles.panel_Results,'Visible','off');
guidata(hObject, handles);

% function Batch_button_Callback(hObject, ~, handles)
% Batch();
% set(handles.Batch_button,'Value',1)
% %display(get(handles.popup_EggsChar,'Value'))
% guidata(hObject, handles);


% --------------------------------------------------------------------
function Analyze_Results_Callback(hObject, eventdata, handles)
Results();

% --------------------------------------------------------------------
function tools_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function Ht_Callback(hObject, eventdata, handles)
load './Temp/temp_variables.mat'
Temp=temp_variables.Temp;
specie=get(handles.Silver,'Value');  %Need to comment this for now
if specie==1
    specie={'Silver'};
else
    specie={'Bighead'};
end
TimeToHatch = HatchingTime(Temp,specie);
msgbox(['The estimated hatching time for an averaged temperature of ',num2str(round(mean(Temp)*10)/10),' C is ', num2str(TimeToHatch), ' hours.'],'FluEgg','none');


% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Website_Callback(hObject, eventdata, handles)
diary('./results/FluEgg_LogFile.txt')
web('http://asiancarp.illinois.edu/')

function settings=FluEgg_Settings
settings.version='v1.3';


% --------------------------------------------------------------------
function Check_for_updates_Callback(hObject, eventdata, handles)
%% Check FluEgg Version
try
    FluEgg_Latest_Version=urlread('http://publish.illinois.edu/tgarciaweb/files/2014/05/FluEgg_version1.txt');
    if strcmpi(FluEgg_Latest_Version,handles.settings.version)
        h=msgbox('The FluEgg version you are using is up to date, no updates available','Checking for Update..');
    else
        h=msgbox('The FluEgg version you are using is out of date, please vistit the FluEgg website to download the newest version','Checking for Update..');
    end
    uiwait(h)
catch
    msgbox('error connection failed','FluEgg error','error')
end

% --------------------------------------------------------------------
function About_FluEgg_Callback(~, ~, handles)
set(0,'Units','pixels') ;
scnsize = get(0,'ScreenSize');
About=figure('Name','Percentage of eggs distributed in the vertical','Color',[1 1 1],...%[0.9412 0.9412 0.9412],...
    'Name','About FluEgg',...
    'position',[scnsize(3)/2 scnsize(4)/2.6 scnsize(3)/3 scnsize(4)/2]);
AboutBackground=axes('Parent',About,'Units','Normalized','Position',[0 -0.1 1 1]);
imshow('AboutBackground.png','InitialMagnification','fit');
set(About,'MenuBar','none')
textAbout1=uicontrol(About,'Style','text','String',{['FluEgg ', num2str(handles.settings.version)];'64-bits'},...
    'Units','Normalized','Position',[0.1 0.79 0.8 0.2],'FontSize',14,'BackgroundColor',[1 1 1],'ForegroundColor',[0.039 0.141 0.416]);
textAbout2=uicontrol(About,'Style','text',...
    'String',{'Copyright 2009-2013 University of Illinois at Urbana-Champaign. This program is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.'},...
    'Units','Normalized','Position',[0 0.68 1 0.15],'FontSize',6,'BackgroundColor',[1 1 1]);


% --- Executes on button press in set_to_hatching.
function set_to_hatching_Callback(hObject, eventdata, handles)
%% Set running time
%%Eggs biological properties
specie=get(handles.Silver,'Value');  %Need to comment this for now
if specie==1
    specie={'Silver'};
else
    specie={'Bighead'};
end
%%
Temp=load('./Temp/temp_variables.mat');temp_variables=Temp.temp_variables;clear Temp;Temp=single(temp_variables.Temp);
set(handles.Totaltime,'String',HatchingTime(Temp,specie));
