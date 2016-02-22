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

% Last Modified by GUIDE v2.5 02-May-2013 11:55:51

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
handleResults=getappdata(0,'handleResults'); 
ResultsSim=getappdata(handleResults,'ResultsSim');
time=ResultsSim.time;
set(handles.TimeStep_Snapshot,'String',time(end)/3600/10)
handles.output = hObject;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = snapshotPlotDt_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

function TimeStep_Snapshot_Callback(~, ~, handles)
function TimeStep_Snapshot_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in SaveTimestep_button.
function SaveTimestep_button_Callback(hObject, eventdata, handles)
guidata(hObject, handles);
SnapshotEvolution(hObject, eventdata, handles);

         
function SnapshotEvolution(~, ~, handles)
handleResults=getappdata(0,'handleResults'); 
ResultsSim=getappdata(handleResults,'ResultsSim');
TimeStep_Snapshot=str2double(get(handles.TimeStep_Snapshot,'String'));
%%
X=ResultsSim.X;
Z=ResultsSim.Z;
time=ResultsSim.time;
CumlDistance=ResultsSim.CumlDistance;
Depth=ResultsSim.Depth;
%%
figure('color','w','position',[ 1000 300 600  400]);
subaxis(1,1,1,'MR',0.02,'ML',0.09,'MB',0.1,'MT',0.075);
Dt=time(2)-time(1);
Legends=cell(1,fix(1+time(end)/(3600*TimeStep_Snapshot)));i=1;
for t=0:3600*TimeStep_Snapshot:(length(X)-1)*Dt
    if t==0
            scatter((X(round(t/Dt+1),:)/1000),Z(round(t/Dt+1),:),30,'filled');
            hold all
    else
    scatter((X(round(t/Dt+1),:)/1000),Z(round(t/Dt+1),:),5);%,'filled')
    time(round(t/Dt+1));%display(time(round(t/Dt+1))/3600)
    end
    Legends{i}=[num2str(t/3600) 'h'];i=i+1;
end
box on 
stairs([0; CumlDistance],[-Depth; -Depth(end)],'color','k','linewidth',1.5);
set(gca,'TickDir','in','TickLength',[0.021 0.021],'FontSize',12);
xlabel('Distance [km]','FontName','Arial','FontSize',12);
ylabel('Vertical location of eggs [m]','FontName','Arial','FontSize',12);
legend(Legends,'FontName','Arial','FontSize',8)
xlim([0 max(CumlDistance)])
%% Text
for i=1:length(CumlDistance)
    if i==1
            text(CumlDistance(i)/3,-Depth(i)-0.2,texlabel(num2str(i)),'FontWeight','bold','FontName','Arial')
    else
    text(CumlDistance(i)-(CumlDistance(i)-CumlDistance(i-1))/1.5,-Depth(i)-0.2,texlabel(num2str(i)),'FontWeight','bold','FontName','Arial')
    end
end
text(CumlDistance(end)/2.4,0.2,texlabel('Water surface'),'FontWeight','bold','FontName','Arial')
text(CumlDistance(1)/3,-Depth(1)-0.7,texlabel('Cell #'),'FontWeight','bold','FontName','Arial')
text(-0.12,0.15, '\downarrow','FontWeight','bold','FontName','Arial')
text(-2.5,0.4, 'Fish spawn here','FontWeight','bold','FontName','Arial')
text(CumlDistance(end)*0.97,-Depth(end)+0.15, '\downarrow','FontWeight','bold','FontName','Arial')
text(CumlDistance(end)*0.9,-Depth(end)+0.4, 'River bed','FontWeight','bold','FontName','Arial')
set(gca,'XMinorTick','on')
