%%%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                       Edit or import FluEgg River Input data           %
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This function is used to import river input data into FluEgg. Currently %
% there are two options, import an excel, csv or text file, or import a   %
% steady or unsteady state HEC-RAS project.                               %

%-------------------------------------------------------------------------%
%                                                                         %
%-------------------------------------------------------------------------%
%   Created by      : Tatiana Garcia                                      %
%   Last Modified   : Jan 25, 2017 by TG                                         
%-------------------------------------------------------------------------%
% Inputs: River input file (xls,xlsx,csv,txt) or HEC-RAS project (prj)    %
%        river input file containing cell number,cumulative distance, flow,
%        velocity magnitude, Vy, Vz, shear velocity, water depth,water    %
%        temperature.
% Outputs: FluEgg River input file(s)
% Copyright 2016 Tatiana Garcia
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%

function varargout = Edit_River_Input_File(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Edit_River_Input_File_OpeningFcn, ...
    'gui_OutputFcn',  @Edit_River_Input_File_OutputFcn, ...
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
end

function Edit_River_Input_File_OpeningFcn(hObject, ~, handles, varargin)
ScreenSize=get(0, 'screensize');
set(handles.River_inputfile_GUI,'Position',[1 1 ScreenSize(3:4)])
%Logs erros in a log file
diary('./results/FluEgg_LogFile.txt')

%The default is to display HEC-RAS project import.
set(handles.panel_Single_xls_file, 'visible', 'off'); 
set(handles.panel2,                'visible', 'on');
set(handles.popup_variable,        'Visible','off')
set(handles.checkbox_flow,         'value', 1)

handles.output = hObject;
guidata(hObject, handles);
end

function varargout = Edit_River_Input_File_OutputFcn(~,~, handles)
diary off
varargout{1} = handles.output;% if the user suppled an 'exit' argument, close the figure by calling
% figure's CloseRequestFcn
if (isfield(handles,'closeFigure') && handles.closeFigure)
    Edit_River_Input_File_CloseRequestFcn(hObject, eventdata, handles)
end
end

function Edit_River_Input_File_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject);
end

% --- Executes on button press in River_Input_File_Panel_button.
function River_Input_File_Panel_button_Callback(hObject, eventdata, handles)
set(handles.panel2, 'visible', 'off');
set(handles.panel_Single_xls_file, 'visible', 'on');
set(handles.Import_HECRAS_panel_button, 'value', 0);
set(handles.River_Input_File_Panel_button,'value',1)
guidata(hObject, handles);% Update handles structure
end

% --- Executes on button press in Import_HECRAS_panel_button.
function Import_HECRAS_panel_button_Callback(hObject, eventdata, handles)
init_ImportHECRAS_panel()
set(handles.Import_data_button,'String', 'Import data')
guidata(hObject, handles);% Update handles structure

    function init_ImportHECRAS_panel()
        set(handles.text_TempHEC, 'Visible', 'on')
        set(handles.popup_TempHEC,'Visible', 'on')
        set(handles.Const_Temp,   'Visible', 'on')
        set(handles.checkbox_flow,'Visible', 'on')
        set(handles.panel2,       'visible', 'on')
        set(handles.checkbox_H,   'Visible', 'on')
        set(handles.LoadObsData,  'Visible', 'off')
        set(handles.edit4,        'Visible', 'off')
        set(handles.popup_variable,'Visible','off')
        set(handles.panel_Single_xls_file,   'visible', 'off')
        
        %set(handles.text_HECRAS_profile,'String','HEC-RAS profile:')
        set(handles.checkbox_flow,                'value', 1)
        set(handles.checkbox_H,                   'value', 0)
        set(handles.River_Input_File_Panel_button,'Value', 0)
        set(handles.Import_HECRAS_panel_button,   'Value', 1)
        set(handles.time_series_panel,            'Value', 0)
    end % init_ImportHECRAS_panel()
end

%% <<<<<<<<<<< USER WANTS TO IMPORT A SINGLE RIVER INPUT FILE >>>>>>>>>>>%%

function loadfromfile_Callback(hObject,~, handles)
%%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
[FileName,PathName]=uigetfile({'*.*',  'All Files (*.*)';
    '*.xls;*.xlsx'     , 'Microsoft Excel Files (*.xls,*.xlsx)'; ...
    '*.csv'             , 'CSV - comma delimited (*.csv)'; ...
    '*.txt'             , 'Text (Tab Delimited (*.txt)'}, ...
    'Select file to import');
strFilename = fullfile(PathName,FileName);
if PathName == 0 %if the user pressed cancelled, then we exit this callback
    return
else
    if FileName ~= 0
        % Load River input file
        m = msgbox('Please wait, loading file...','FluEgg');
        set(handles.Riverinput_filename,'string',fullfile(FileName));
        extension=regexp(FileName, '\.', 'split');
        if (strcmp(extension(end),'xls') == 1 || strcmp(extension(end),'xlsx') == 1)
            %% If xlsread fails
            try %Eddited TGB 03/21/14
                [Riverinputfile, Riverinputfile_hdr] = xlsread(strFilename);
                close(m);
            catch
                close(m);
                m = msgbox('Unexpected error, please try again','FluEgg error','error');
                uiwait(m)
                return
            end
            %%
        elseif strcmp(extension(end),'csv') == 1
            Riverinputfile = importdata(strFilename);
            Riverinputfile_hdr = Riverinputfile.textdata;
            Riverinputfile = Riverinputfile.data;
            close(m);
        elseif strcmp(extension(end),'txt') == 1
            Riverinputfile = importdata(strFilename);
            if  isstruct(Riverinputfile)
                Riverinputfile_hdr = Riverinputfile.textdata;
                Riverinputfile_hdr = regexp(Riverinputfile_hdr, '\t', 'split');
                Riverinputfile_hdr = Riverinputfile_hdr{1,1};
                Riverinputfile = Riverinputfile.data;
            else
                ed = errordlg('Please fill all the data required in the river input file, and load the file again','Error');
                set(ed, 'WindowStyle', 'modal');
                uiwait(ed);
                close(m)
                return
            end
            close(m)
            %%
        else
            msgbox('The file extension is unrecognized, please select another file','FluEgg Error','Error');
            return
        end %Checking file extension
        try
            handles.userdata.Riverinputfile = Riverinputfile(:,1:9);
            handles.userdata.Riverinputfile_hdr = Riverinputfile_hdr(:,1:9);
            if size(Riverinputfile_hdr) ~= [1 9]
                ed = msgbox('Incorrect river input file, please select another file','FluEgg Error','Error');
                set(ed, 'WindowStyle', 'modal');
                uiwait(ed);
                return
            elseif sum(strcmp(Riverinputfile_hdr(:,1:9),{'CellNumber','CumlDistance_km','Depth_m','Q_cms','Vmag_mps','Vvert_mps','Vlat_mps','Ustar_mps','Temp_C'}))<9
                ed = msgbox('Incorrect river input file, please select another file','FluEgg Error','Error');
                set(ed, 'WindowStyle', 'modal');
                uiwait(ed);
                return
            end
            set(handles.RiverInputFile,'Data',handles.userdata.Riverinputfile(:,1:9));
            Riverin_DataPlot(handles);
        catch
            if size(Riverinputfile,2) ~= 9
                ed = errordlg('Please fill all the data required in the river input file, and load the file again','Error');
                set(ed, 'WindowStyle', 'modal');
                uiwait(ed);
                return
            end
        end %try
    end
end %if user pres cancel
HECRAS_data.Profiles(1).Riverinputfile=Riverinputfile;
HECRAS_data.Riverinputfile_hdr=Riverinputfile_hdr;
%% Save data in hFluEggGui
hFluEggGui = getappdata(0,'hFluEggGui');
setappdata(hFluEggGui, 'inputdata',HECRAS_data);
%%
%% Clear old input data
set(handles.hecras_file_path,'String',' ')
set(handles.popup_River,'String',' ')
set(handles.popup_Reach,'String',' ')
set(handles.popup_Reach,'String',' ')
set(handles.popup_HECRAS_profile,'String',' ')
set(handles.popup_River_Station,'String',' ')
set(handles.popupPlan,'String',' ')
set(handles.Plot_Hydrograph,'Visible','off')
set(handles.uipanel10,'Visible','off')
set(handles.Import_data_button,'String','Import data');
set(handles.uipanel10,'Visible','on')
%%
guidata(hObject, handles);% Update handles structure
end % end function loadfromfile_Callback

%% <<<<<<<<<<< USER WANTS TO IMPORT A HEC-RAS PROJECT >>>>>>>>>>>%%
% --- Executes on button press in load_hecras_button.
function load_hecras_button_Callback(hObject, eventdata, handles)
% Keeps active the current Panel
% This is important when updating the Hec-Ras profiles pop-up button
what = get(handles.Import_data_button, 'string');
if strcmp(what, 'Import data')
    set(handles.Import_HECRAS_panel_button,   'Value', 1)
elseif strcmp(what, 'Import TS')
    set(handles.time_series_panel,            'Value', 1)
end

[FileName,PathName]=uigetfile({'*.prj'     , 'HEC-RAS project'}, ...
    'Select the HEC-RAS project file to import');
strFilename=fullfile(PathName,FileName);
if PathName==0 %if the user pressed cancelled, then we exit this callback
    return
else
    if FileName~=0
        % Load River input file
        m=msgbox('Please wait, loading HEC-RAS project file...','FluEgg');
        set(handles.hecras_file_path,'string',fullfile(FileName));%writes the file path
        %% Execute the Extract RAS function
        % loads HEC-RAS project and gets info about River, Rach, profile,
        % River stations and plan into the GUI
        [RC]=loadsHECRAS(strFilename);
        %extension=regexp(FileName, '\.', 'split');
        %set(handles.hecras_file_path,'string',fullfile(FileName));
        handles.strFilename=strFilename;
    end
end

%set(handles.Import_data_button,'String','Import data'); %[SS-->To avoid overwritting the "import TS" with "Import data" when using the TS panel]

%%
guidata(hObject, handles);% Update handles structure
close(m)

%% Clear old input data
set(handles.Riverinput_filename,'String',' ')
set(handles.RiverInputFile,'Data',[])
set(handles.DepthPlot,'Visible','off');
set(handles.QPlot,'Visible','off');
set(handles.VmagPlot,'Visible','off');
set(handles.VyPlot,'Visible','off');
set(handles.VzPlot,'Visible','off');
set(handles.UstarPlot,'Visible','off');
set(handles.TempPlot,'Visible','off');

    function [RC]=loadsHECRAS(strFilename)
        %% Creates a COM Server for the HEC-RAS Controller
        try
            % The command above depends on the version of HEC-RAS you have, in my case
            % I am using version 5.0.3
            RC = actxserver('RAS503.HECRASController');
        catch
            try %HECRAS 5.0.2
                RC = actxserver('RAS502.HECRASController');
            catch
                try %HECRAS 5.0.1
                    RC = actxserver('RAS501.HECRASController');
                catch
                    try %HECRAS 5.0.0
                        RC = actxserver('RAS500.HECRASController');
                    catch
                        ed = errordlg('Please install HEC-RAS 5.0.3 and try again','Error');
                        set(ed, 'WindowStyle', 'modal');
                        uiwait(ed);
                    end %HECRAS 5.0.0
                end %HECRAS 5.0.1
            end%HECRAS 5.0.2     
        end %HECRAS 5.0.3
        
        %% Open the project
        try
            %strRASProject = 'D:\Asian Carp\Asian Carp_USGS_Project\Tributaries data\Sandusky River\SANDUSKY_Hec_RAS_mod\Sandusky_mod_II\BallvilleDam_Updated.prj';
            RC.Project_Open(strFilename); %open and show interface, no need to use RC.ShowRAS in Matlab
            
            % Profile Names
            [lngNumProf,strProfileName]=RC.Output_GetProfiles(0,0);
                        importData = get(handles.Import_HECRAS_panel_button,'Value');
            if importData == 1 
               % Only if Import HECRAS tab is highlighted
               % add the option of including all profiles --> For unsteady state
                strProfileName(2:end+1) = strProfileName(1:end);
               % Display ALL profile names in GUI                
                strProfileName{1} = 'All profiles-unsteady flow';
                set(handles.popup_HECRAS_profile,'string',strProfileName);
            else
                % Display only 'All profiles-unsteady flow'
                set(handles.popup_HECRAS_profile,'string','All profiles-unsteady flow');
            end
            % Plan Name
            [lngPlanCount,strPlanNames,~]=RC.Plan_Names(0,0,0);%Gets plan names. Output:[lngPlanCount,strPlanNames,blnIncludeBasePlansOnly]
            set(handles.popupPlan,'string',strPlanNames);%Display plan names in GUI
            % River Name
            [lngRiv,strRiv]=RC.Geometry_GetRivers(0,0);%Gets River(s) name
            set(handles.popup_River,'string',strRiv);%Display plan names in GUI
            %Get selected River ID
            lngRiverID=get(handles.popup_River,'Value');
            % Reach Name
            [~,lngRch,strRch]=RC.Geometry_GetReaches(lngRiverID,0,0);%Gets River(s) Reach name
            set(handles.popup_Reach,'string',strRch);%Display plan names in GUI
            %Get selected River Reach ID
            lngReachID=get(handles.popup_Reach,'Value');
            % River station
            [~,~,lgnNode,strNode,strNodeType]=RC.Geometry_GetNodes(lngRiverID,lngReachID,0,0,0);%Number of nodes.~&~==>strRS & strNodeType
            set(handles.popup_River_Station,'string',strNode(strcmp(strNodeType,'')));%Display plan names in GUI
        catch
            ed = errordlg('FluEgg cannot load you HEC-RAS project. Please check HEC-RAS files and try again','Error');
            set(ed, 'WindowStyle', 'modal');
            uiwait(ed);
        end
    end %loadsProfiles

end%End load HEC-RAS project

%%:::::PLOT INPUT DATA:::::::::::::::::::::::::::::::::::::::::::::::::::::
function Riverin_DataPlot(handles)
%% DepthPlot Riverin data
hFluEggGui = getappdata(0,'hFluEggGui');
HECRAS_data=getappdata(hFluEggGui, 'inputdata');
Riverinputfile=HECRAS_data.Profiles.Riverinputfile;
%calculate cumulative distance at the middle of the cell
x = Riverinputfile(:,2);
x = [(x+[0; x(1:end-1)])/2; x(end)];
%% Depth
set(handles.DepthPlot,'Visible','on');
plot(handles.DepthPlot,[0; x],[Riverinputfile(1,3); Riverinputfile(:,3);Riverinputfile(end,3)],'LineWidth',1.5,'Color',[0 0 0]);
ylabel(handles.DepthPlot,'H [m]','FontWeight','bold','FontSize',10);
box(handles.DepthPlot,'on');
xlim(handles.DepthPlot,[0 max(Riverinputfile(:,2))]);
%==========================================================================
%% QPlot Riverin data
set(handles.QPlot,'Visible','on');
plot(handles.QPlot,[0; x],[Riverinputfile(1,4); Riverinputfile(:,4);Riverinputfile(end,4)],'LineWidth',1.5,'Color',[0 0 0]);
ylabel(handles.QPlot,{'Q [cms]'},'FontWeight','bold','FontSize',10);
box(handles.QPlot,'on');
xlim(handles.QPlot,[0 max(Riverinputfile(:,2))]);
%==========================================================================
%% VmagPlot Riverin data
set(handles.VmagPlot,'Visible','on');
plot(handles.VmagPlot,[0; x],[Riverinputfile(1,5); Riverinputfile(:,5); Riverinputfile(end,5)],'LineWidth',1.5,'Color',[0 0 0]);
ylabel(handles.VmagPlot,{'Vmag [m/s]'},'FontWeight','bold','FontSize',10);
box(handles.VmagPlot,'on');
xlim(handles.VmagPlot,[0 max(Riverinputfile(:,2))]);
%==========================================================================
%% VyPlot Riverin data
set(handles.VyPlot,'Visible','on');
plot(handles.VyPlot,[0; x],[Riverinputfile(1,6); Riverinputfile(:,6);Riverinputfile(end,6)],'LineWidth',1.5,'Color',[0 0 0]);
ylabel(handles.VyPlot,{'Vy [m/s]'},'FontWeight','bold','FontSize',10);
box(handles.VyPlot,'on');%check
xlim(handles.VyPlot,[0 max(Riverinputfile(:,2))]);
%==========================================================================
%% VzPlot Riverin data
set(handles.VzPlot,'Visible','on');
plot(handles.VzPlot,[0; x],[Riverinputfile(1,7); Riverinputfile(:,7); Riverinputfile(end,7)],'LineWidth',1.5,'Color',[0 0 0]);
ylabel(handles.VzPlot,{'Vz [m/s]'},'FontWeight','bold','FontSize',10);
box(handles.VzPlot,'on');
xlim(handles.VzPlot,[0 max(Riverinputfile(:,2))]);
%==========================================================================
%% UstarPlot Riverin data
set(handles.UstarPlot,'Visible','on');
plot(handles.UstarPlot,[0; x],[Riverinputfile(1,8); Riverinputfile(:,8);Riverinputfile(end,8)],'LineWidth',1.5,'Color',[0 0 0]);
ylabel(handles.UstarPlot,{'u_* [m/s]'},'FontWeight','bold','FontSize',10);
xlabel(handles.UstarPlot,{'Cumulative distance [Km]'},'FontWeight','bold',...
    'FontSize',10);
box(handles.UstarPlot,'on');
xlim(handles.UstarPlot,[0 max(Riverinputfile(:,2))]);
%==========================================================================
%% TempPlot Riverin data
set(handles.TempPlot,'Visible','on');
plot(handles.TempPlot,[0; x],[Riverinputfile(1,9); Riverinputfile(:,9);Riverinputfile(end,9)],'LineWidth',1.5,'Color',[0 0 0]);
ylabel(handles.TempPlot,{'T [^oC]'},'FontWeight','bold','FontSize',10);
xlabel(handles.TempPlot,{'Cumulative distance [Km]'},'FontWeight','bold', 'FontSize',10);
box(handles.TempPlot,'on');
xlim(handles.TempPlot,[0 max(Riverinputfile(:,2))]);
%==========================================================================
end

function ContinueButton_Callback(hObject, eventdata, handles)
hFluEggGui = getappdata(0,'hFluEggGui');
HECRAS_data=getappdata(hFluEggGui, 'inputdata');
%% If using a single riverinputfile and user has not uploaded the file
if  (isempty(HECRAS_data.Profiles) == 1)&&(get(handles.River_Input_File_Panel_button,'value')==1)
    ed = errordlg('Please load the river input file and continue','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
    return
end

%% Create data structures case single xls or csv file
%===========================================================================================
if get(handles.River_Input_File_Panel_button,'value')==1 % If using a single xls or csv file
    %Riverinputfile = handles.userdata.Riverinputfile;
    HECRAS_data.Profiles(1).Riverinputfile=Extract_RAS(handles.strFilename,handles,1);
    Riverinputfile_hdr={'CellNumber','CumlDistance_km','Depth_m','Q_cms','Vmag_mps','Vvert_mps','Vlat_mps','Ustar_mps','Temp_C'};
    HECRAS_data.Riverinputfile_hdr=Riverinputfile_hdr;
    %% Save data in hFluEggGui
    hFluEggGui = getappdata(0,'hFluEggGui');
    setappdata(hFluEggGui, 'inputdata',HECRAS_data);
end

%% Load data for code audit
%===========================================================================================
hFluEggGui = getappdata(0,'hFluEggGui');
HECRAS_data=getappdata(hFluEggGui,'inputdata'); %0 means root-->storage in desktop
Riverinputfile=HECRAS_data.Profiles(1).Riverinputfile;% Use the River input file for initial time

% Create hydraulic variables
CumlDistance = Riverinputfile(:,2);   %Km
Depth = Riverinputfile(:,3);          %m
Q = Riverinputfile(:,4);              %m3/s
Vmag = Riverinputfile(:,5);           %m/s
Vlat = Riverinputfile(:,6);           %m/s
Vvert = Riverinputfile(:,7);          %m/s
Ustar = Riverinputfile(:,8);          %m/s
Width=abs(Q./(Vmag.*Depth));           %m

%==========================================================================
%% Error  %Code audit 03/2015 TG
if  any(CumlDistance<0)
    ed = errordlg('Invalid negative value for attribute cumulative distance','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
    return
end
if  any(Depth<=0)
    ed = errordlg('Invalid negative or zero value for attribute depth','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
    return
end
if  any(Vmag<0)
    ed = errordlg('Invalid negative value for attribute velocity magnitud','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
    return
end
if  any(Vmag==0)
    ed = errordlg('Invalid zero value for attribute velocity magnitud. You may use a very small value for Vmag, but it still must be greater than zero.','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
    return
end
if  any(Ustar<0)
    ed = errordlg('Invalid negative value for attribute shear velocity','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
    return
end
if  any(Vmag==0)
    ed = errordlg('Invalid zero value for attribute shear velocity. You may use a very small value for Ustar, but it still must be greater than zero.','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
    return
end

%=========================================================================
%% Updating spawning location to the middle of the cell
% getting main handles
hFluEggGui = getappdata(0,'hFluEggGui');
handlesmain = getappdata(hFluEggGui, 'handlesmain');

%If user input data, autopopulate lateral position of spawning location
set(handlesmain.Yi_input,'String',floor(Width(1)*100/2)/100);
guidata(hObject, handles);% Update handles structure

%=========================================================================
%% Updating River Geometry Summary
set(handlesmain.MinX,'String',floor(min(CumlDistance)*10)/10);
set(handlesmain.MaxX,'String',floor(max(CumlDistance)*10)/10);
set(handlesmain.MinW,'String',floor(min(Width)*10)/10);
set(handlesmain.MaxW,'String',floor(max(Width)*10)/10);
set(handlesmain.MinH,'String',floor(min(Depth)*10)/10);
set(handlesmain.MaxH,'String',floor(max(Depth)*10)/10);
axes(handlesmain.calendar_icon(1)); imshow('calendar.png');
axes(handlesmain.calendar_icon(2)); imshow('calendar.png');

%% Set simulation date and time if unsteady simulation
if length(HECRAS_data.Profiles)>1
    
    %% Find index of spawning time
    date=arrayfun(@(x) datenum(x.Date,'ddmmyyyy HHMM'), HECRAS_data.Profiles);
    
    %Display Spawning time in main GUI
    HECRASspawiningTimeIndex=find(date<=HECRAS_data.SpawningTime,1,'last'); %use the previous time with available hydraulic data
    SpawningTime=date(HECRASspawiningTimeIndex);
    SpawningTime=datestr(SpawningTime,'ddmmmyyyy HHMM');
    dateandtime = strsplit(char(SpawningTime),' ');
    %dateandtime = strsplit(char(HECRAS_data.Profiles(HECRASspawiningTimeIndex).Date(1)),' ');
    set(handlesmain.edit_Starting_Date,'String',dateandtime(1));
    set(handlesmain.edit_Starting_time,'String',dateandtime(2));
    
    %Display Ending time in main GUI
    endSimtime=HECRAS_data.SpawningTime+str2double(get(handlesmain.Totaltime,'String'))/24;
    endSimtime_Str=datestr(endSimtime,'ddmmmyyyy HHMM');
    dateandtime = strsplit(char(endSimtime_Str),' ');
    set(handlesmain.edit_Ending_Date,'String',dateandtime(1));
    set(handlesmain.edit_Ending_time,'String',dateandtime(2));
    
    %EndSimTimeIndex=find(date>=endSimtime,1,'first');
    
    if endSimtime>date(end)
        ed = errordlg('The simulated time in HEC-RAS is not long enough to support FluEgg simulations, Please extend your simulated period in HEC-RAS. ','Error');
        set(ed, 'WindowStyle', 'modal');
        uiwait(ed);
    end
    HECRAS_data.HECRASspawiningTimeIndex= HECRASspawiningTimeIndex;
    %HECRAS_data.EndSimTimeIndex=EndSimTimeIndex;
    setappdata(hFluEggGui,'inputdata',HECRAS_data)
end
diary off
close(Edit_River_Input_File);
end

%%======================================================================
function SaveFile_button_Callback(hObject, eventdata, handles)
[file,path]  =  uiputfile('*.txt','Save modified file as');
strFilename=fullfile(path,file);
if ~isfield(handles,'userdata')%Eddited TGB 03/21/14
    handles.userdata=[];
    handles.userdata.Riverinputfile=get(handles.RiverInputFile,'Data');
    handles.userdata.Riverinputfile_hdr=get(handles.RiverInputFile,'ColumnName');
end
hdr=handles.userdata.Riverinputfile_hdr;
dlmwrite(strFilename,[sprintf('%s\t',hdr{:}) ''],'');
dlmwrite(strFilename,get(handles.RiverInputFile,'Data'),'-append','delimiter','\t','precision', 6);
end

function RiverInputFile_CellEditCallback(hObject, eventdata, handles)
hFluEggGui = getappdata(0,'hFluEggGui');
HECRAS_data=getappdata(hFluEggGui,'inputdata');
HECRAS_data.Profiles.Riverinputfile=get(handles.RiverInputFile,'Data');
setappdata(hFluEggGui, 'inputdata',HECRAS_data);
% if  isfield(handles,'userdata') == 0
%     ed = errordlg('Please load the river input file and continue','Error');
%     set(ed, 'WindowStyle', 'modal');
%     uiwait(ed);
%     return
% end100
Riverin_DataPlot(handles)
end

function RiverInputFile_CellSelectionCallback(~, eventdata, handles)
end

function River_inputfile_GUI_CreateFcn(hObject, eventdata, handles)
end

function tools_ks_Callback(hObject, eventdata, handles)
end

function hecras_file_path_Callback(hObject, eventdata, handles)
end

function hecras_file_path_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function popup_HECRAS_profile_Callback(hObject, eventdata, handles)
end

function popup_HECRAS_profile_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
% --- Executes during object creation, after setting all properties.
function panel_Single_xls_file_CreateFcn(hObject, eventdata, handles)
end

% --- Executes on selection change in popup_River.
function popup_River_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function popup_River_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popup_River_Station.
function popup_River_Station_Callback(hObject, eventdata, handles)
try
    pushbutton_plot_Callback(hObject, eventdata, handles)
catch
    %Do nothin. For Model Evaluation the user needs to import again the data
end
end

% --- Executes during object creation, after setting all properties.
function popup_River_Station_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in pushbutton_plot.
function pushbutton_plot_Callback(hObject, eventdata, handles)
%<<<<<<< HEAD
%hFluEggGui = getappdata(0,'hFluEggGui');
%HECRAS_data=getappdata(hFluEggGui,'inputdata'); %0 means root-->storage in desktop
%if isempty(HECRAS_data)
%    m = msgbox('Please import data and try again','FluEgg error','error');
% uiwait(m)
% return
% else
% %% Determine the parameter to plot
% str = get(handles.popup_River_Station, 'String');
% val = get(handles.popup_River_Station,'Value');
% % Hydrographs:
% if get(handles.checkbox_flow,'value')==1
% Hydrograph=arrayfun(@(x) x.Riverinputfile(val,4), HECRAS_data.Profiles);
% %% Velocity
% %Hydrograph_Vel=arrayfun(@(x) x.Riverinputfile(val,5), HECRAS_data.Profiles);
% %%
% Yylabel='Flow, in cubic meters per second';
% %save('Hydrograph_Q_V_ustar',[date  Hydrograph Hydrograph_Vel Hydrograph_shearVel])
% elseif get(handles.checkbox_H,'value')==1
% Hydrograph=arrayfun(@(x) x.Riverinputfile(val,3), HECRAS_data.Profiles);
% Yylabel='Water depth, in meters';
% else
% m = msgbox('Please select a variable to plot','FluEgg error','error');
% uiwait(m)
% return
% end
% date=arrayfun(@(x) datenum(x.Date,'ddmmyyyy HHMM'), HECRAS_data.Profiles);
% set(handles.Plot_Hydrograph,'visible','on')
% =======
%% Determines the action the user would want to do (TG)
what = get(handles.Import_data_button, 'String');
if strcmp(    what,'Import data')
    % Plot the flow or water depth time series for 
    % any XS for any plan (TG)
    [date_axis, Yylabel] = plotProfiles(handles);
elseif strcmp(    what,'Import TS')
    % Plot time series of selected variable at specific River Station
    % Variable to plot from popup menu
    str = get(handles.popup_variable,'String');
    val = get(handles.popup_variable,'Value');
    var = str{val};
    
    % Plot HEC-RAS results
    [date_axis, Yylabel] = plotTS(handles, var); 
    
    % Plot observed data for selected River Station
    plot_obs_data(handles);
    
    %Run Model Evaluation
    [pbias, nse] = modeleval(handles);
    
    % Add model evaluation results to polot
    pbiasstr = strcat({'PBIAS ='}, {' '}, {num2str(pbias)});
    nsestr   = strcat({'NSE ='}  , {' '}, {num2str(nse)});
    txt = sprintf('%s \n%s', pbiasstr{1}, nsestr{1});
    uicontrol('style'   ,'text',...
          'String'  , txt,...
          'Position', [950 150 180 50],...
          'Max'     , 2,...
          'FontSize', 12,...
          'BackgroundColor', 'white');
end
%% Format plot
handles.Plot_Hydrograph;
h.FontName          = 'Arial';
h.XLabel            = xlabel('Time', 'FontSize',14 );
h.Visible           = 'on';
h.XTickLabel        = date_axis;
h.XColor            = 'k';
h.XLabel.Visible    = 'on';
h.YLabel            = ylabel(Yylabel, 'FontSize',14);
h.YLabel.Visible    = 'on';
h.XMinorTick        = 'on';
box( h, 'on')
grid(h, 'on')
set( h, 'XMinorTick','on');

%% Sub-functions 
    function [date_axis, Yylabel] = plotProfiles(handles)
        %% As coded by Tatiana
        hFluEggGui = getappdata(0,'hFluEggGui');
        try
            HECRAS_data = getappdata(hFluEggGui,'inputdata'); %0 means root-->storage in desktop
            h = handles.Plot_Hydrograph;
            %% Determine the parameter to plot
            str = get(handles.popup_River_Station, 'String');
            val = get(handles.popup_River_Station,'Value');
            % Hydrographs:
            if get(handles.checkbox_flow,'value') == 1
                set(handles.checkbox_H,'value',0)
                Hydrograph = arrayfun(@(x) x.Riverinputfile(val,4), HECRAS_data.Profiles);
                Yylabel = 'Flow, in cubic meters per second';
            elseif get(handles.checkbox_H,'value') == 1
                set(handles.checkbox_flow,'value',0)
                Hydrograph = arrayfun(@(x) x.Riverinputfile(val,3), HECRAS_data.Profiles);
                Yylabel = 'Water depth, in meters';
            else
                m = msgbox('Please select a variable to plot','FluEgg error','error');
                uiwait(m)
                return
            end %if
        catch
            m = msgbox('Please import data and try again','FluEgg error','error');
            uiwait(m)
            return
        end
        % Format Date data for plot
        date = arrayfun(@(x) datenum(x.Date,'ddmmyyyy HHMM'), HECRAS_data.Profiles);
        date_axis = datestr(date, 'mm/dd/yy HH:MM AM');
        
        % Create Axes and line object         
        plot(h, date, Hydrograph, 'linewidth',2);       
%         %xlim(handles.Plot_Hydrograph,[date(1) date(end)])
%         %%set(handles.Plot_Hydrograph,'XTick',[date(1):(date(end)-date(1))/5:date(end)]);
%         %set(handles.Plot_Hydrograph,'XTickLabel',datestr([date(1):(date(end)-date(1))/5:date(end)],'mm/dd/yy HH:MM AM'),'XColor','k','FontName','Arial');
%         set(handles.Plot_Hydrograph,'XTickLabel',datestr(get(handles.Plot_Hydrograph,'XTick'),'mm/dd/yy HH:MM AM'),'XColor','k','FontName','Arial');
%         box(handles.Plot_Hydrograph,'on')
%         xlabel(handles.Plot_Hydrograph,'Time','FontName','Arial','FontSize',14);
%         grid(handles.Plot_Hydrograph,'on')
%         set(handles.Plot_Hydrograph,'XMinorTick','on')
%         ylabel(handles.Plot_Hydrograph,Yylabel,'FontName','Arial','FontSize',14);
%         %msgbox('Feature under development, no available','FluEgg message')
%         set(handles.delete_spawning_time,'Visible','off')
%         set(handles.Set_up_spawning_time,'Visible','on')
    end %plotProfiles()
    function [date_axis, Yylabel] = plotTS(handles, var)
        %% Coded by Santi for Model Evaluation
        % This function plots HEC-RAS output hydrographs.
        % Load HEC-RAS outputs
        hFluEggGui = getappdata(0,'hFluEggGui');
        HECRAS_data = getappdata(hFluEggGui,'inputdata');
        h = handles.Plot_Hydrograph;
        
        if isempty(HECRAS_data)
            % If HEC-RAS data store in FluEGG is not found
            m = msgbox('Please import data and try again','FluEgg error','error');
            uiwait(m)
            return
        else
            % If HEC-RAS data is found: Determine the parameter to plot
            str = get(handles.popup_River_Station, 'String');
            val = get(handles.popup_River_Station, 'Value');
            
            % Check data was imported for selected River Station
            currentRS = HECRAS_data.RiverStation;
            if val ~= currentRS
                m = msgbox('Please Import TS for new river station',...
                    'FluEgg error','error');
                uiwait(m)
                return
            end
            
            % Get Hydrographs data
            if strcmp(var, 'Flow')
                % Flow Hydrograph
                Hydrograph = HECRAS_data.TS(:,2);
                Yylabel='Flow, in cubic meters per second';
            elseif strcmp(var,'Water Depth') == 1
                % Water Level hydrograph
                Hydrograph = HECRAS_data.TS(:,3);
                Yylabel='Water Depth, in meters';
            elseif strcmp(var,'Stage') == 1
                % Water Level hydrograph
                Hydrograph = HECRAS_data.TS(:,3);
                Yylabel='Water Surface Elevation, in meters';
            else
                % No hydrograph has been selected
                m = msgbox('Please select a variable to plot',...
                    'FluEgg error','error');
                uiwait(m)
                return
            end
        end %if
        
        % Format Date data for plot
        date = arrayfun(@(x) datenum(x,'ddmmyyyy HHMM'), HECRAS_data.Dates);
        date_axis = datestr(date, 'mm/dd/yy HH:MM AM');
        
        % Create Axes and line object
         plot(h, date, Hydrograph, 'linewidth',2);
    end %plotTS()
    function plot_obs_data(handles)
        % Add Observed data to plot, if any
        hFluEggGui  = getappdata(0,'hFluEggGui');
        obs_data    = getappdata(hFluEggGui,'obsdata');
        h = handles.Plot_Hydrograph;
        
        if ~isempty(obs_data)
            % Observed data was loaded in FluEgg
            % Format dates for plotting
            text1 = obs_data.data{1,2};
            text2 = obs_data.data{1,3};
            profile = arrayfun(@(x, y) strcat(x,{' '},y), text1, text2);
            date = arrayfun(@(x) datenum(x,'ddmmyyyy HHMM'), profile);
            hydrograph = obs_data.data{1,4};
            
            %Add line to plot and add format
            h2 = line(date, hydrograph, 'Parent', h);
            h2.LineStyle        = 'none';
            h2.Marker           = 's';
            h2.MarkerEdgeColor  = 'k';
            h2.MarkerSize       = 2;
        end
    end %plot_obs_data()
end % pushbutton_plot_Callback(hObject, eventdata, handles)

% --- Executes on button press in pushbutton_table.
function pushbutton_table_Callback(~, eventdata, handles)
msgbox('Feature under development, no available','FluEgg message')
end

% --- Executes on selection change in popup_Reach.
function popup_Reach_Callback(hObject, eventdata, handles)
end
% --- Executes during object creation, after setting all properties.
function popup_Reach_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupPlan.
function popupPlan_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function popupPlan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupPlan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in Import_data_button.
% Modified by SS to add TS capabilities
function Import_data_button_Callback(hObject, eventdata, handles)
%% Determines the action the user would want to do (TG)
what = get(handles.Import_data_button, 'String');
project = get(handles.hecras_file_path,'String');
if  strcmp(project,' ') == 1 % If project was not loaded
    error_load()
    return
end
% If project was loaded, take action according to Import button's string
if strcmp(    what,'Import data')
    % Load HEC-RAS data
    import_data();
elseif strcmp(    what,'Import TS')
    % Import HEC_RAS data and Observed Data if any
    import_TS();
    try
        import_OBS();
    catch
        ed = warndlg('No Observed Data was found','Observed Data');
        set(ed, 'WindowStyle', 'modal');
        uiwait(ed);  
    end
elseif strcmp(what,   'Continue')
    ContinueButton_Callback(hObject, eventdata, handles)
end

%==========================================================================
%% Error load data
%% Check user loaded HEC-RAS project
    function error_load()
        ed = errordlg('Please load the HEC-RAS project and import the data into FluEgg','Error');
        set(ed, 'WindowStyle', 'modal');
        uiwait(ed);
    end
%==========================================================================
%% Import Data
    function import_data()
        lngProfile = get(handles.popup_HECRAS_profile,'Value')-1;   % Profile Number
        if lngProfile==0 % If unsteady state-->Multiple profiles
            Profiles=get(handles.popup_HECRAS_profile,'string');
            %% Check user loaded HEC-RAS project
            if  (strcmp(Profiles,' ') == 1)
                ed = errordlg('Please load the HEC-RAS project and import the data into FluEgg','Error');
                set(ed, 'WindowStyle', 'modal');
                uiwait(ed);
                return
            end
            %%=========================================================================
            %% Iniciate Waitbar
            h = waitbar(0,'Importing HEC-RAS data...','Name','Importing HEC-RAS data,please wait...',...
                'CreateCancelBtn',...
                'setappdata(gcbf,''canceling'',1)');
            setappdata(h,'canceling',0)
            if getappdata(h,'canceling')
                delete(h);
                Exit=1;
                return;
            end
            %%===========
            Profiles=Profiles(3:end);%Without the first two rows (All profiles & Max WS)
            % HECRAS_data.Profiles.Date=Profiles;
            HECRAS_data.Profiles(length(Profiles),1).Riverinputfile=NaN;
            waitbar(0,h,['Please wait....' 'Importing HEC-RAS data']);
            for i=1:length(Profiles)
                if ~mod(i, 5) || i==length(Profiles)
                    fill=i/length(Profiles);
                    % Check for Cancel button press
                    if getappdata(h,'canceling')
                        delete(h);
                        Exit=1;
                        return;
                    end
                    % Report current estimate in the waitbar's message field
                    waitbar(fill,h,['Please wait....' sprintf('%12.0f',fill*100) '%']);
                end
                HECRAS_data.Profiles(i).Date=Profiles(i);
                try
                    HECRAS_data.Profiles(i).Riverinputfile=Extract_RAS(handles.strFilename,handles,i);
                catch
                    ed = errordlg('Error importing data','Error');
                    set(ed, 'WindowStyle', 'modal');
                    uiwait(ed);
                    delete(h)
                    return
                end
            end
            close(h);delete(h)
            clear Profiles
            %     msgbox('Feature under development, no available','FluEgg message')
            %     return
        else
            HECRAS_data.Profiles(1).Riverinputfile=Extract_RAS(handles.strFilename,handles,1);
        end
        %% Save data in hFluEggGui
        hFluEggGui = getappdata(0,'hFluEggGui');
        setappdata(hFluEggGui,'inputdata',HECRAS_data);
        %%
        % set(handles.Set_up_spawning_time,'Visible','on')
    end %import data function

%==========================================================================
%% Import Time Series Data
    function import_TS()
        list = get(handles.popup_River_Station,'String');
        val = get(handles.popup_River_Station,'value');
        XS = list(val,:);
        try
            %HECRAS_data.TimeSeries(length(list),1) = NaN;
            [TS, dates] = Extract_RAS_TS(handles.strFilename,handles,XS);
            HECRAS_data.TS = TS;
            HECRAS_data.Dates = dates;
            HECRAS_data.RiverStation = val;
        catch
            ed = errordlg('Error importing data','Error');
            set(ed, 'WindowStyle', 'modal');
            uiwait(ed);
            %             delete(h)
            return
        end
        
        %% Save data in hFluEggGui
        hFluEggGui = getappdata(0,'hFluEggGui');
        setappdata(hFluEggGui,'inputdata',HECRAS_data);
    end %import_TS()
%==========================================================================
%% Import Observed Time Series Data
    function import_OBS()
        fileName = handles.strObsDataFile;
        if ~strcmp(fileName,'')
            OBS_data = import_dss(fileName);
            hFluEggGui = getappdata(0,'hFluEggGui');
            setappdata(hFluEggGui,'obsdata',OBS_data);
        end
    end
end %Import_data_button_Callback

% --- Executes on selection change in popup_TempHEC.
function popup_TempHEC_Callback(hObject, eventdata, handles)
% Determine the selected input data.
str = get(handles.popup_TempHEC, 'String');
val = get(handles.popup_TempHEC,'Value');
% Get data from GUI
switch str{val};
    case 'Constant temperature in space and time' %%model would use a constant Rhoe and D
        set(handles.Const_Temp,'Visible','on');
        
    case 'Constant temperature in time'
        msgbox('This feature is currently under development, stay tuned to new updates','FluEgg','Feature under development');
        set(handles.Const_Temp,'Visible','off');
        
    case'Time and space varing temperature '
        msgbox('This feature is currently under development, stay tuned to new updates','FluEgg','Feature under development');
        set(handles.Const_Temp,'Visible','off');
end %Temperature choice
end

% --- Executes on button press in delete_spawning_time.
function delete_spawning_time_Callback(hObject, eventdata, handles)
hFluEggGui = getappdata(0,'hFluEggGui');
HECRAS_data=getappdata(hFluEggGui, 'inputdata');
HECRAS_data.SpawningTime=[];
setappdata(hFluEggGui, 'inputdata',HECRAS_data);
pushbutton_plot_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in Set_up_spawning_time.
function Set_up_spawning_time_Callback(hObject, eventdata, handles)
% hObject    handle to Set_up_spawning_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Reset
hFluEggGui = getappdata(0,'hFluEggGui');
HECRAS_data=getappdata(hFluEggGui, 'inputdata');
HECRAS_data.SpawningTime=[];
setappdata(hFluEggGui, 'inputdata',HECRAS_data);
pushbutton_plot_Callback(hObject, eventdata, handles)

set(gcf, 'pointer', 'crosshair');
[xi,yi] = ginput(1);
hold on
plot(xi,yi,'+','color',[ 1.000 0.314 0.510 ],'linewidth',2);
text(xi,1.005*yi,[datestr(xi,'ddmmmyyyy HHMM') ', ' num2str(round(yi*10)/10)])
hold off
%%
%% Save data in hFluEggGui
hFluEggGui = getappdata(0,'hFluEggGui');
HECRAS_data=getappdata(hFluEggGui, 'inputdata');
HECRAS_data.SpawningTime=xi;
setappdata(hFluEggGui, 'inputdata',HECRAS_data);
set(handles.Import_data_button,'String','Continue');
set(gcf,'Pointer','arrow')
set(handles.delete_spawning_time,'Visible','on')
end



function Const_Temp_Callback(hObject, eventdata, handles)
try
    hFluEggGui = getappdata(0,'hFluEggGui');
    HECRAS_data=getappdata(hFluEggGui, 'inputdata');
    %% Temperature choice
    Temperature=str2double(get(handles.Const_Temp(2),'String'));
    for i=1:length(HECRAS_data.Profiles)
        HECRAS_data.Profiles(i).Riverinputfile(:,9)=Temperature;
    end
catch
end
setappdata(hFluEggGui, 'inputdata',HECRAS_data);
end

% --- Executes on button press in time_series_panel.
function time_series_panel_Callback(hObject, eventdata, handles)
% hObject    handle to time_series_panel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%TimeSeries_GUI()
% Initialize GUI: makes some objects invisible
set(handles.text_TempHEC,  'Visible', 'off')
set(handles.popup_TempHEC, 'Visible', 'off')
set(handles.Const_Temp,    'Visible', 'off')
set(handles.checkbox_flow, 'Visible', 'off')
set(handles.checkbox_H,    'Visible', 'off')
set(handles.LoadObsData,   'Visible', 'on')
set(handles.edit4,         'Visible', 'on')
set(handles.popup_variable,'Visible', 'on')
set(handles.popup_variable, ...
    'String', {'Variable','Flow', 'Water Depth','Stage'})
set(handles.Import_data_button,           'String', 'Import TS')
set(handles.River_Input_File_Panel_button,'Value',0)
set(handles.Import_HECRAS_panel_button,   'Value',0)
set(handles.time_series_panel,            'Value',1)
end %time_series_panel_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popup_HECRAS_profile.
function popup_HECRAS_profile_ButtonDownFcn(hObject, eventdata, handles)
end

% --- Executes on key press with focus on popup_HECRAS_profile and none of its controls.
function popup_HECRAS_profile_KeyPressFcn(hObject, eventdata, handles)
end

% --- Executes on button press in LoadObsData.
function LoadObsData_Callback(hObject, eventdata, handles)
[FileName,PathName]=uigetfile({'*.dat'     , 'Observed data'}, ...
    'Select the Observed Data file to import');
strFilename=fullfile(PathName,FileName);
if PathName == 0 %if the user pressed cancelled, then we exit this callback
    return
elseif FileName ~= 0
    % Load River input file
    m = msgbox('Please wait, loading Observed Data...','FluEgg');
    handles.strObsDataFile = strFilename;
    set(handles.edit4,'string',FileName)
    guidata(hObject, handles);% Update handles structure
    close(m)
end
end %LoadObsData_Callback(hObject, eventdata, handles)

function edit4_Callback(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in checkbox_H.
function checkbox_H_Callback(hObject, eventdata, handles)
set(handles.checkbox_flow,'value',0)
end
% --- Executes on button press in checkbox_flow.
function checkbox_flow_Callback(hObject, eventdata, handles)
set(handles.checkbox_H,'value',0)
end

% --- Executes on selection change in popup_variable.
function popup_variable_Callback(hObject, eventdata, handles)
% hObject    handle to popup_variable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_variable contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_variable
end

% --- Executes during object creation, after setting all properties.
function popup_variable_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_variable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
