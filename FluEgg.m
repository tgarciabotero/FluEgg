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
%   Last Modified   : Sept 12, 2012  
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
                                                                          %
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
%%
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
set(handles.Plot_Setup,'Visible','on');
set(handles.text18,'Visible','on');
set(handles.Fcell,'Visible','on');
set(handles.text19,'Visible','on');
set(handles.Panel_Limits,'Visible','on');
set(handles.update_plotLimits,'Visible','on');
set(handles.text22,'Visible','on');
set(handles.Running,'Visible','on');
set(handles.zamp,'Visible','on');
set(handles.text20,'Visible','on');
set(handles.yamp,'Visible','on');
set(handles.text21,'Visible','on');
%% Make Results Invisible
set(handles.Results,'Visible','off');
guidata(hObject, handles);% Update handles structure
function popup_roughness_Callback(hObject, eventdata, handles)
% Determine the selected data set.
str=get(handles.popup_roughness, 'String');
val=get(handles.popup_roughness,'Value');
% Set current data to the selected data set.
switch str{val};
        case 'Log Law Smooth Bottom Boundary (Case flumes)'  
        set(handles.textKs,'Visible','off');
        set(handles.Ks,'Visible','off');
        case 'Log Law Rogh Bottom Boundary (Case rivers)' 
        set(handles.textKs,'Visible','on');
        set(handles.Ks,'Visible','on');       
end
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
function Xi_input_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,...
        'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Yi_input_Callback(hObject, eventdata, handles)
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
case 'Use diameter and fall velocity time series (Chapman, 2011)'
  set(handles.text9,'Visible','off');
  set(handles.ConstD,'Visible','off');
  set(handles.text10,'Visible','off');
  set(handles.ConstRhoe,'Visible','off');
  set(handles.text7,'Visible','on');
  set(handles.PostferT,'Visible','on');
  set(handles.text8,'Visible','on');
  set(handles.Silver,'Visible','on');
  set(handles.Bighead,'Visible','on');
case 'Use constant egg diameter and density' 
  set(handles.text7,'Visible','off');
  set(handles.PostferT,'Visible','off');
  set(handles.text8,'Visible','off');
  set(handles.Silver,'Visible','off');
  set(handles.Bighead,'Visible','off');
  set(handles.text9,'Visible','on');
  set(handles.ConstD,'Visible','on');
  set(handles.text10,'Visible','on');
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

%% 3D Plot Getting Input data ::::::::::::::::::::::::::::::::::::::::::::::::::::%
function Plotlim_CellEditCallback(hObject, eventdata, handles)
function waittbar_CreateFcn(hObject, eventdata, handles)
function centralfig_CreateFcn(hObject, eventdata, handles)
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
function Fcell_Callback(hObject, eventdata, handles)
function Fcell_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Plot_Setup_CreateFcn(hObject, eventdata, handles)
function uipanelSpawning_CreateFcn(hObject, eventdata, handles)
function uipanelEggs_Chara_CreateFcn(hObject, eventdata, handles)
function uipanel_CreateFcn(hObject, eventdata, handles)
function Panel_Limits_CreateFcn(hObject, eventdata, handles)
function zamp_Callback(hObject, eventdata, handles)
update_plotLimits_Callback(hObject, eventdata, handles)
function zamp_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

 update_plotLimits_Callback(hObject, eventdata, handles)
function yamp_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function Plot_Setup_Callback(hObject, eventdata, handles)
%% getting the data
load './Temp/temp_variables.mat' 
 [~,Fc]=find(max(CumlDistance)<=(CumlDistance'));
 set(handles.text18,'Visible','on');
 set(handles.text19,'Visible','on');
 set(handles.Fcell,'Visible','on');
 set(handles.Fcell,'String',Fc);
 update_plotLimits_Callback(hObject, eventdata, handles)
 set(handles.update_plotLimits,'Visible','on');
 guidata(hObject, handles);
function update_plotLimits_Callback(hObject, eventdata, handles)
set(handles.Panel_Limits,'Visible','on');
set(handles.zamp,'Visible','on');
set(handles.yamp,'Visible','on');
set(handles.text20,'Visible','on');
set(handles.text21,'Visible','on');
load './Temp/temp_variables.mat' 
Fcell=str2double(get(handles.Fcell,'String'));
set(handles.MinX,'String',0);
 set(handles.MaxX,'String',max(CumlDistance(1:Fcell)));
 set(handles.MinW,'String',0);
 set(handles.MaxW,'String',max(Width(1:Fcell)));
 set(handles.MinH,'String',max(Depth(1:Fcell)));
 set(handles.MaxH,'String',0);
 set(handles.MaxH,'String',0);
 set(handles.MaxH,'String',0);
 %% Preliminary plot
      Eggs=handles.Num_Eggs;
      Xi=str2double(get(handles.Xi_input,'String'));
      Yi=str2double(get(handles.Yi_input,'String'));
      Zi=str2double(get(handles.Zi_input,'String'));%Spawning location in m          
X(floor(1:Eggs))=Xi;Y(floor(1:Eggs))=Yi;Z(floor(1:Eggs))=Zi;
centralfig=handles.centralfig;
newView=round(get(handles.centralfig,'View'));
set(handles.centralfig, 'View', newView);  
cubes; t=1;time=0;D=4.2;
plotallKm
title(centralfig,'Setup the cells to display in the screen and rotate the figure if is needed','FontSize',10)
guidata(hObject, handles);

% --- Executes on button press in Batch_button.
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
handles.userdata.Fcell=str2double(get(handles.Fcell,'String'));
%% Get Data from Main GUI
hFluEggGui=getappdata(0,'hFluEggGui');
Batch=getappdata(hFluEggGui,'Batch');  %Getting info from Batch GUI
No=getappdata(hFluEggGui,'No');  %Getting info from Batch GUI;
addpath('./Codes/Plots');
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
set(handles.Plot_Setup,'Visible','off');
set(handles.text18,'Visible','off');
set(handles.Fcell,'Visible','off');
set(handles.text19,'Visible','off');
set(handles.Panel_Limits,'Visible','off');
set(handles.update_plotLimits,'Visible','off');
set(handles.waittbar,'Visible','off');
set(handles.text22,'Visible','off');
set(handles.Running,'Visible','off');
set(handles.zamp,'Visible','off');
set(handles.text20,'Visible','off');
set(handles.yamp,'Visible','off');
set(handles.text21,'Visible','off');
%% Make Results Visible
set(handles.Results,'Visible','on');
guidata(hObject, handles);

%% Analyze the Results::::::::::::::::::::::::::::::::::::::::::::::::::::::%
function Results_Callback(hObject, eventdata, handles)
results();

function uipanelEggs_Chara_DeleteFcn(hObject, eventdata, handles)

function Ks_Callback(hObject, eventdata, handles)

function Ks_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function NewSim_Bottom_Callback(hObject, eventdata, handles)
function Batch_button_CreateFcn(hObject, eventdata, handles)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over Running.
function Running_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to Running (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Batch.
function Batch_Callback(hObject, eventdata, handles)
% hObject    handle to Batch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function yamp_Callback(hObject, eventdata, handles)
update_plotLimits_Callback(hObject, eventdata, handles)
