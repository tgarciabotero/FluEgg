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
[FileName,PathName]=uigetfile({'*.xlsx','xlsx files (*.xlsx)'; ...
    '*.xls','xls-files (*.xls)'; '*.*',  'All Files (*.*)'}, ...
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
plot(handles.DepthPlot,x,RinFile(:,4),'LineWidth',1.5,'Color',...
    [0 0 0]);
 
ylabel(handles.DepthPlot,'H [m]','FontWeight','bold','FontSize',10);
box(handles.DepthPlot,'on');
axis(handles.DepthPlot,[0 max(RinFile(:,2)) 0 max(RinFile(:,4))*1.5]);
%==========================================================================

%% QPlot Riverin data
set(handles.QPlot,'Visible','on');
plot(handles.QPlot,x,RinFile(:,5),'LineWidth',1.5,'Color',...
    [0 0 0]);
 
ylabel(handles.QPlot,{'Q [cms]'},'FontWeight','bold','FontSize',10);
box(handles.QPlot,'on');
axis(handles.QPlot,[0 max(RinFile(:,2)) 0 max(RinFile(:,5))*1.5]);
%==========================================================================

%% VmagPlot Riverin data
set(handles.VmagPlot,'Visible','on');
plot(handles.VmagPlot,x,RinFile(:,6),'LineWidth',1.5,'Color',...
    [0 0 0]);
 
ylabel(handles.VmagPlot,{'Vmag [m/s]'},'FontWeight','bold','FontSize',10);
box(handles.VmagPlot,'on');
axis(handles.VmagPlot,[0 max(RinFile(:,2)) 0 max(RinFile(:,6))*1.5]);
%==========================================================================

%% VvertPlot Riverin data
set(handles.VvertPlot,'Visible','on');
plot(handles.VvertPlot,x,RinFile(:,7),'LineWidth',1.5,'Color',...
    [0 0 0]);
 
ylabel(handles.VvertPlot,{'Vz [m/s]'},'FontWeight','bold','FontSize',10);
box(handles.VvertPlot,'on');
if max(RinFile(:,7))~=0
axis(handles.VvertPlot,[0 max(RinFile(:,2)) min(RinFile(:,7))*1.5 max(RinFile(:,7))*1.5]);
else
    xlim(handles.VvertPlot,[0 max(RinFile(:,2))]);
end
%==========================================================================

%% UstarPlot Riverin data
set(handles.UstarPlot,'Visible','on');
plot(handles.UstarPlot,x,RinFile(:,8),'LineWidth',1.5,'Color',...
    [0 0 0]);
 
ylabel(handles.UstarPlot,{'u_* [m/s]'},'FontWeight','bold','FontSize',10);
xlabel(handles.UstarPlot,{'Cumulative distance [Km]'},'FontWeight','bold',...
    'FontSize',10);
box(handles.UstarPlot,'on');
axis(handles.UstarPlot,[0 max(RinFile(:,2)) 0 max(RinFile(:,8))*1.5]);
%==========================================================================

%% TempPlot Riverin data
set(handles.TempPlot,'Visible','on');
plot(handles.TempPlot,x,RinFile(:,9),'LineWidth',1.5,'Color',...
    [0 0 0]);
 
ylabel(handles.TempPlot,{'T [^oC]'},'FontWeight','bold','FontSize',10);
xlabel(handles.TempPlot,{'Cumulative distance [Km]'},'FontWeight','bold',...
    'FontSize',10);
box(handles.TempPlot,'on');
axis(handles.TempPlot,[0 max(RinFile(:,2)) 0 max(RinFile(:,9))*1.5]);
%==========================================================================

function RiverInputFile_CellEditCallback(hObject, eventdata, handles)
handles.userdata.Riverinputfile=get(handles.RiverInputFile,'Data');
Riverin_DataPlot(hObject, eventdata, handles)
guidata(hObject, handles);% Update handles structure
function RiverInputFile_CellSelectionCallback(hObject, eventdata, handles)
function varargout = Edit_River_Input_File_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function Close_Callback(hObject, eventdata, handles)
Riverinputfile=handles.userdata.Riverinputfile;
CumlDistance=Riverinputfile(:,2); %Km
Depth=Riverinputfile(:,4);        %m
Q=Riverinputfile(:,5);            %m3/s
Vmag=Riverinputfile(:,6);         %m/s
Vvert=Riverinputfile(:,7);        %m/s
Ustar=Riverinputfile(:,8);         %m/s
Temp=Riverinputfile(:,9);            %m2s
Width=Q./(Vmag.*Depth);
save './Temp/temp_variables.mat'...
        'CumlDistance' 'Depth' 'Q' 'Vmag' 'Vvert' 'Ustar' 'Temp' 'Width'
close;

%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
