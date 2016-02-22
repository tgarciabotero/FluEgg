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
% End initialization code - DO NOT EDIT

function Edit_River_Input_File_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
%RiverInputFile_CellEditCallback(hObject, eventdata, handles)
guidata(hObject, handles);


function pannel_CreateFcn(hObject, eventdata, handles)

function Riverinput_filename_Callback(hObject, eventdata, handles)
function Riverinput_filename_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function loadfromfile_Callback(hObject, eventdata, handles)
%%::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
[FileName,PathName]=uigetfile({'*.*',  'All Files (*.*)';
    '*.xlsx','xlsx files (*.xlsx)'; ...
    '*.xls','xls-files (*.xls)'; ...
    '*.csv'             , 'CSV - comma delimited (*.csv)'; ... 
    '*.txt'             , 'Text (Tab Delimited (*.txt)'}, ...
    'Select Excel file to import','MultiSelect', 'on');
strFilename=fullfile(PathName,FileName);
if PathName==0 %if the user pressed cancelled, then we exit this callback
    return
else
   if FileName~=0
       set(handles.Riverinput_filename,'string',fullfile(FileName));
       Riverinputfile=importdata(strFilename);handles.userdata.Riverinputfile=...
           Riverinputfile.data;
       % Load River input file
       RinFile=handles.userdata.Riverinputfile;
              set(handles.RiverInputFile,'Data',RinFile);
             % end of load river input file
   end
end
guidata(hObject, handles);% Update handles structure
Riverin_DataPlot(hObject, eventdata, handles)

function Riverin_DataPlot(hObject, eventdata, handles)

%% DepthPlot Riverin data
RinFile=handles.userdata.Riverinputfile;
%calculate cumulative distance as the middle of the cell
x=RinFile(:,2);
x=(x+[0; x(1:end-1)])/2;
set(handles.DepthPlot,'Visible','on');
plot(handles.DepthPlot,x,RinFile(:,3),'LineWidth',1.5,'Color',[0 0 0]); 
ylabel(handles.DepthPlot,'H [m]','FontWeight','bold','FontSize',10);
box(handles.DepthPlot,'on');
axis(handles.DepthPlot,[0 max(RinFile(:,2)) 0 max(RinFile(:,3))*1.5]);
%==========================================================================
%% QPlot Riverin data
set(handles.QPlot,'Visible','on');
plot(handles.QPlot,x,RinFile(:,4),'LineWidth',1.5,'Color',[0 0 0]);
ylabel(handles.QPlot,{'Q [cms]'},'FontWeight','bold','FontSize',10);
box(handles.QPlot,'on');
axis(handles.QPlot,[0 max(RinFile(:,2)) 0 max(RinFile(:,4))*1.5]);
%==========================================================================
%% VmagPlot Riverin data
set(handles.VmagPlot,'Visible','on');
plot(handles.VmagPlot,x,RinFile(:,5),'LineWidth',1.5,'Color',[0 0 0]);
ylabel(handles.VmagPlot,{'Vmag [m/s]'},'FontWeight','bold','FontSize',10);
box(handles.VmagPlot,'on');
axis(handles.VmagPlot,[0 max(RinFile(:,2)) 0 max(RinFile(:,5))*1.5]);
%==========================================================================
%% VyPlot Riverin data
set(handles.VyPlot,'Visible','on');
plot(handles.VyPlot,x,RinFile(:,6),'LineWidth',1.5,'Color',[0 0 0]);
ylabel(handles.VyPlot,{'Vy [m/s]'},'FontWeight','bold','FontSize',10);
box(handles.VyPlot,'on');
if max(RinFile(:,7))~=0
axis(handles.VyPlot,[0 max(RinFile(:,2)) 0 max(RinFile(:,6))*1.5]);
else
    xlim(handles.VyPlot,[0 max(RinFile(:,2))]);
end
%==========================================================================
%% VzPlot Riverin data
set(handles.VzPlot,'Visible','on');
plot(handles.VzPlot,x,RinFile(:,7),'LineWidth',1.5,'Color',[0 0 0]);
ylabel(handles.VzPlot,{'Vz [m/s]'},'FontWeight','bold','FontSize',10);
box(handles.VzPlot,'on');
if max(RinFile(:,7))~=0
axis(handles.VzPlot,[0 max(RinFile(:,2)) min(RinFile(:,7))*1.5 max(RinFile(:,7))*1.5]);
else
    xlim(handles.VzPlot,[0 max(RinFile(:,2))]);
end
%==========================================================================
%% UstarPlot Riverin data
set(handles.UstarPlot,'Visible','on');
plot(handles.UstarPlot,x,RinFile(:,8),'LineWidth',1.5,'Color',[0 0 0]); 
ylabel(handles.UstarPlot,{'u_* [m/s]'},'FontWeight','bold','FontSize',10);
xlabel(handles.UstarPlot,{'Cumulative distance [Km]'},'FontWeight','bold',...
    'FontSize',10);
box(handles.UstarPlot,'on');
axis(handles.UstarPlot,[0 max(RinFile(:,2)) 0 max(RinFile(:,8))*1.5]);
%==========================================================================

%% TempPlot Riverin data
set(handles.TempPlot,'Visible','on');
plot(handles.TempPlot,x,RinFile(:,9),'LineWidth',1.5,'Color',[0 0 0]); 
ylabel(handles.TempPlot,{'T [^oC]'},'FontWeight','bold','FontSize',10);
xlabel(handles.TempPlot,{'Cumulative distance [Km]'},'FontWeight','bold', 'FontSize',10);
box(handles.TempPlot,'on');
axis(handles.TempPlot,[0 max(RinFile(:,2)) 0 max(RinFile(:,9))*1.5]);
%==========================================================================

%% D50 Riverin data
set(handles.D50Plot,'Visible','on');
plot(handles.D50Plot,x,RinFile(:,10),'LineWidth',1.5,'Color',[0 0 0]); 
ylabel(handles.D50Plot,{'D50 [mm]'},'FontWeight','bold','FontSize',10);
box(handles.D50Plot,'on');
axis(handles.D50Plot,[0 max(RinFile(:,2)) 0 max(RinFile(:,10))*1.5]);
%==========================================================================

function RiverInputFile_CellEditCallback(hObject, eventdata, handles)
handles.userdata.Riverinputfile=get(handles.RiverInputFile,'Data');
Riverin_DataPlot(hObject, eventdata, handles)
guidata(hObject, handles);% Update handles structure
function RiverInputFile_CellSelectionCallback(hObject, eventdata, handles)
function varargout = Edit_River_Input_File_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function ContinueButton_Callback(hObject, eventdata, handles)
Riverinputfile=handles.userdata.Riverinputfile;
CumlDistance=Riverinputfile(:,2); %Km
Depth=Riverinputfile(:,3);        %m
Q=Riverinputfile(:,4);            %m3/s
Vmag=Riverinputfile(:,5);         %m/s
Vlat=Riverinputfile(:,6);         %m/s
Vvert=Riverinputfile(:,7);        %m/s
Ustar=Riverinputfile(:,8);        %m/s
Temp=Riverinputfile(:,9);         %C
D50=Riverinputfile(:,10);          %mm
%%
Width=abs(Q./(Vmag.*Depth));           %m
VX=sqrt(Vmag.^2-Vlat.^2-Vvert.^2);%m/s
%%
temp_variables.CumlDistance=CumlDistance;
temp_variables.Depth=Depth;
temp_variables.Q=Q;
temp_variables.VX=VX;
temp_variables.Vlat=Vlat;
temp_variables.Vvert=Vvert;
temp_variables.Ustar=Ustar;
temp_variables.Temp=Temp;
temp_variables.Width=Width;
temp_variables.D50=D50;
save './Temp/temp_variables.mat' 'temp_variables'
%% Updating spawning location to the middle of the cell
   %% getting main handles
   hFluEggGui=getappdata(0,'hFluEggGui');
   handlesmain=getappdata(hFluEggGui, 'handlesmain');
   %%
   set(handlesmain.Yi_input,'String',floor(Width(1)*100/2)/100);
   guidata(hObject, handles);% Update handles structure
%% Updating River Geometry Summary
set(handlesmain.MinX,'String',min(CumlDistance));
set(handlesmain.MaxX,'String',max(CumlDistance));
set(handlesmain.MinW,'String',floor(min(Width)*100/2)/100);
set(handlesmain.MaxW,'String',floor(max(Width)*100/2)/100);
set(handlesmain.MinH,'String',min(Depth));
set(handlesmain.MaxH,'String',max(Depth));
close();

function SaveFile_button_Callback(hObject, eventdata, handles)
[file,path] = uiputfile('*.txt','Save modified file as');
strFilename=fullfile(path,file);
hdr={'CellNumber','CumlDistance_km','Depth_m','Q_cms','Vmag_mps','Vvert_mps','Vlat_mps','Ustar_mps','Temp_C','D50_mm'};
dlmwrite(strFilename,[sprintf('%s\t',hdr{:}) ''],'');
dlmwrite(strFilename,get(handles.RiverInputFile,'Data'),'-append','delimiter','\t','precision', 6);

function River_inputfile_GUI_CreateFcn(hObject, eventdata, handles)
%%Creates GUI

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
