function varargout = snapshotPlotDt(varargin)
% SNAPSHOTPLOTDT MATLAB code for snapshotPlotDt.fig
%      SNAPSHOTPLOTDT, by itself, creates a new SNAPSHOTPLOTDT or raises the existing
%      singleton*.
%
%      H = SNAPSHOTPLOTDT returns the handle to a new SNAPSHOTPLOTDT or the handle to
%      the existing singleton*.
%
%      SNAPSHOTPLOTDT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SNAPSHOTPLOTDT.M with the given input arguments.
%
%      SNAPSHOTPLOTDT('Property','Value',...) creates a new SNAPSHOTPLOTDT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before snapshotPlotDt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to snapshotPlotDt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help snapshotPlotDt

% Last Modified by GUIDE v2.5 26-Aug-2013 16:48:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @snapshotPlotDt_OpeningFcn, ...
    'gui_OutputFcn',  @snapshotPlotDt_OutputFcn, ...
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


% --- Executes just before snapshotPlotDt is made visible.
function snapshotPlotDt_OpeningFcn(hObject, ~, handles, varargin)
diary('./results/FluEgg_LogFile.txt')
handleResults=getappdata(0,'handleResults');
ResultsSim=getappdata(handleResults,'ResultsSim');
time=ResultsSim.time;
set(handles.TimeStep_Snapshot,'String',round(10*time(end)/3600/10)/10)
handles.output = hObject;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = snapshotPlotDt_OutputFcn(~, ~, handles)
diary off
varargout{1} = handles.output;

function TimeStep_Snapshot_Callback(~, ~, handles)
function TimeStep_Snapshot_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in SaveTimestep_button.
function SaveTimestep_button_Callback(hObject, eventdata, handles)
try
    SnapshotEvolution(hObject, eventdata, handles);
catch
    handleResults=getappdata(0,'handleResults');
    ResultsSim=getappdata(handleResults,'ResultsSim');
    TimeStep_Snapshot=str2double(get(handles.TimeStep_Snapshot,'String'));
    if isnan(TimeStep_Snapshot)
        msgbox('Empty input field. Please make sure all required fields are filled out correctly ','FluEgg Error: Empty fields','error');
        return
    end
    if TimeStep_Snapshot<=0
        msgbox('Incorrect negative or zero value. Please make sure all required fields are filled out correctly','FluEgg Error: Incorrect negative or zero value','error');
        return
    end
end
diary off
close(handles.figure1)

function SnapshotEvolution(~, ~, handles)
handleResults=getappdata(0,'handleResults');
ResultsSim=getappdata(handleResults,'ResultsSim');
TimeStep_Snapshot=str2double(get(handles.TimeStep_Snapshot,'String'));
%%
X=ResultsSim.X;
Z=ResultsSim.Z;
time=ResultsSim.time;
CumlDistance=double(ResultsSim.CumlDistance);
Depth=double(ResultsSim.Depth);
Xi=double(ResultsSim.Spawning(1,1));% in m
Zi=double(ResultsSim.Spawning(1,3));% in m
%%
set(0,'Units','pixels') ;
scnsize = get(0,'ScreenSize');
figure('Name','Evolution of a mass of Asian carp eggs','NumberTitle','off',...
    'Menubar','figure','color','w','position',[8 scnsize(4)/2.6 scnsize(3)/2.1333 scnsize(4)/2]);
%figure('color','w','position',[ 1000 300 600  400]);
subaxis(1,1,1,'MR',0.035,'ML',0.09,'MB',0.12,'MT',0.075);
Dt=time(2)-time(1);
Legends=cell(1,fix(1+time(end)/(3600*TimeStep_Snapshot)));i=1;
for t=0:3600*TimeStep_Snapshot:time(end)%(length(X)-1)*Dt
    if t==0
        scatter((X(round(t/Dt+1),:)/1000),Z(round(t/Dt+1),:),30,'filled');
        hold all
    else
        scatter((X(round(t/Dt+1),:)/1000),Z(round(t/Dt+1),:),5);%,'filled')
        %time(round(t/Dt+1));display(time(round(t/Dt+1))/3600)
    end
    Legends{i}=[num2str(t/3600) 'h'];i=i+1;
end
box on
stairs([0; CumlDistance],[-Depth; -Depth(end)],'color','k','linewidth',1.5);
set(gca,'TickDir','in','TickLength',[0.021 0.021],'FontSize',12);
xlabel('Distance [km]','FontName','Arial','FontSize',12);
ylabel('Vertical location of eggs [m]','FontName','Arial','FontSize',12);
legend(Legends,'Location','Best','FontName','Arial','FontSize',8)
xlim([0 max(CumlDistance)])
ylim([-max(Depth)-0.15 0])
No=length(Depth);
%% Text
text(Xi/1000-CumlDistance(end)*0.007,Zi+Depth(end)*0.028, '\downarrow','FontWeight','bold','FontName','Arial')
text(Xi/1000-CumlDistance(end)*0.04,Zi+Depth(end)*0.07, 'Fish spawn here','FontWeight','normal','FontName','Arial')
text(CumlDistance(end)/2.4,0.08,'Water surface','FontWeight','normal','FontName','Arial')
text(CumlDistance(end)*0.9,-Depth(end)*0.95,'\downarrow','FontWeight','bold','FontName','Arial');%,'FontSize',20
text(CumlDistance(end)*0.9,-Depth(end)*0.9, 'River bed','FontWeight','normal','FontName','Arial')
set(gca,'XMinorTick','on')
%% Cell labels ON-OFF
label_on=get(handles.Labelcheckbox,'Value');  %Need to comment this for now
if label_on==1
    
    for i=1:length(CumlDistance)
        if i==1
            text(CumlDistance(i)/5.5,-Depth(i)*1.03,texlabel(num2str(i)),'FontWeight','normal','FontName','Arial','FontSize',8)
        else
            text(CumlDistance(i)-(CumlDistance(i)-CumlDistance(i-1))/1.1,-Depth(i)*1.03,texlabel(num2str(i)),'FontWeight','normal','FontName','Arial','FontSize',8)
        end
    end
    text(CumlDistance(1)/3,-Depth(1)*2.5,texlabel('Cell #'),'FontWeight','normal','FontName','Arial','FontSize',8)
    % text(38.34,0.15, '\downarrow','FontWeight','normal','FontName','Arial')
    % text(32.14,0.4, 'Lake Michigan','FontWeight','normal','FontName','Arial')
end
diary off


% --- Executes on button press in Labelcheckbox.
function Labelcheckbox_Callback(hObject, eventdata, handles)
