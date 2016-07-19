%%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                       Generate snapshot plot                           %
%%                        Post-processing tools                           %
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This is a Sub-GUI of the results GUI, it is used inside FluEgg to       %
% generate the snapshot figure of eggs at a given DT.                     %
%-------------------------------------------------------------------------%
%                                                                         %
%-------------------------------------------------------------------------%
%   Created by      : Tatiana Garcia                                      %
%   Last Modified   : July 15, 2016                                       %
%-------------------------------------------------------------------------%
% Copyright 2016 Tatiana Garcia
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
function varargout = snapshotPlotDt(varargin)
% Last Modified by GUIDE v2.5 15-Jul-2016 11:46:21

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
end
% End initialization code - DO NOT EDIT


% --- Executes just before snapshotPlotDt is made visible.
function snapshotPlotDt_OpeningFcn(hObject, ~, handles, varargin)
diary('./results/FluEgg_LogFile.txt')
handleResults=getappdata(0,'handleResults');
ResultsSim=getappdata(handleResults,'ResultsSim');
time=ResultsSim.time;
T2_Hatching=ResultsSim.T2_Hatching;
T2_Gas_bladder=ResultsSim.T2_Gas_bladder;
%% Default values and options
  % If the user simulated until hatching time, diplay plot option
  if time(end)/3600>=T2_Hatching
     set(handles.Add_Hatching_Time,'Visible','on');
     set(handles.Add_Hatching_Time,'Value',1); 
     
  else
     set(handles.Add_Hatching_Time,'Visible','off');
  end
  
  % If the user simulated until GBI stage, diplay plot option
  if time(end)/3600>=T2_Gas_bladder
     set(handles.Add_GBI,'Visible','on');
     set(handles.Add_GBI,'Value',1); 
     else
     set(handles.Add_Hatching_Time,'Visible','off');
  end
  
%set(handles.TimeStep_Snapshot,'String',round(10*time(end)/3600/10)/10)
handles.output = hObject;
guidata(hObject, handles);

%Default selection of snapshot times
if  (time(end)/3600>=T2_Hatching)&&(time(end)/3600<T2_Gas_bladder)
    set(handles.Snapshot_Time_Table,'Data',[0;1;fix(T2_Hatching/2);round(T2_Hatching*10)/10]);
elseif time(end)/3600>=T2_Gas_bladder
    set(handles.Snapshot_Time_Table,'Data',[0;1;round(T2_Hatching*10)/10;round(T2_Gas_bladder*10)/10]);
end
end

% --- Outputs from this function are returned to the command line.
function varargout = snapshotPlotDt_OutputFcn(~, ~, handles)
diary off
varargout{1} = handles.output;
end

function TimeStep_Snapshot_Callback(~, ~, handles)
end

function TimeStep_Snapshot_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in SaveTimestep_button.
function SaveTimestep_button_Callback(hObject, eventdata, handles)
try
    SnapshotEvolution(hObject, eventdata, handles);
catch
    handleResults=getappdata(0,'handleResults');
    ResultsSim=getappdata(handleResults,'ResultsSim');
%     TimeStep_Snapshot=str2double(get(handles.TimeStep_Snapshot,'String'));
%     if isnan(TimeStep_Snapshot)
%         msgbox('Empty input field. Please make sure all required fields are filled out correctly ','FluEgg Error: Empty fields','error');
%         return
%     end
%========================================================================
% Check for negative values
Snapshot_Time_Table=get(handles.Snapshot_Time_Table,'Data');
    if sum(Snapshot_Time_Table<0)>0
        msgbox('Incorrect negative or zero value. Please make sure all required fields are filled out correctly','FluEgg Error: Incorrect negative or zero value','error');
        return
    end
end
diary off
close(handles.figure1)
end

function SnapshotEvolution(~, ~, handles)
handleResults=getappdata(0,'handleResults');
ResultsSim=getappdata(handleResults,'ResultsSim');
Snapshot_Time_Table=get(handles.Snapshot_Time_Table,'Data');
%TimeStep_Snapshot=str2double(get(handles.TimeStep_Snapshot,'String'));
%% Getting results data
X = ResultsSim.X;
Z = ResultsSim.Z;
time = ResultsSim.time;
CumlDistance = double(ResultsSim.CumlDistance);
Depth = double(ResultsSim.Depth);
Xi = double(ResultsSim.Spawning(1,1));% in m
Zi = double(ResultsSim.Spawning(1,3));% in m
Dt=time(2)-time(1);
T2_Hatching=ResultsSim.T2_Hatching;
T2_Gas_bladder=ResultsSim.T2_Gas_bladder;

%% Figure
set(0,'Units','pixels') ;
scnsize = get(0,'ScreenSize');
figure('Name','Evolution of a mass of Asian carp eggs','NumberTitle','off',...
    'Menubar','figure','color','w','position',[8 scnsize(4)/2.6 scnsize(3)/2.1333 scnsize(4)/2]);
subaxis(1,1,1,'MR',0.035,'ML',0.09,'MB',0.12,'MT',0.075);

Legends=cell(1,length(Snapshot_Time_Table));

for i=1:length(Snapshot_Time_Table)
    t=Snapshot_Time_Table(i)*3600; %Time in seconds
    if t==0
        scatter((X(round(t/Dt+1),:)/1000),Z(round(t/Dt+1),:),30,'filled');
        hold all
    else
        if t<T2_Hatching*3600
        scatter((X(round(t/Dt+1),:)/1000),Z(round(t/Dt+1),:),5);
        else
        scatter((X(round(t/Dt+1),:)/1000),Z(round(t/Dt+1),:),30,'d','filled');  
        end
    end
    Legends{i}=[num2str(t/3600) 'h'];
end
box on
% Display bottom of cells
stairs([0; CumlDistance],[-Depth; -Depth(end)],'color','k','linewidth',1.5);

% figure settings
set(gca,'TickDir','in','TickLength',[0.021 0.021],'FontSize',12);
xlabel('Distance [km]','FontName','Arial','FontSize',12);
ylabel('Vertical location of eggs [m]','FontName','Arial','FontSize',12);
legend(Legends,'Location','Best','FontName','Arial','FontSize',8)
MaxX=fix(max(max(X))/1000);
xticks=get(gca,'XTick');
minxtick=find(xticks<fix(X(1,1)/1000),1,'last');
maxxtick=find(xticks>MaxX,1,'first');
xlim([xticks(minxtick) xticks(maxxtick)])
ylim([-max(Depth)-0.15 0])
set(gca,'XMinorTick','on')
No=length(Depth);

%% Text
text(Xi/1000-CumlDistance(end)*0.007,Zi+Depth(end)*0.028, '\downarrow','FontWeight','bold','FontName','Arial')
text(Xi/1000-CumlDistance(end)*0.04,Zi+Depth(end)*0.07, 'Fish spawn here','FontWeight','normal','FontName','Arial')
text(MaxX/2.4,0.08,'Water surface','FontWeight','normal','FontName','Arial')
text(MaxX*0.9,-Depth(end)*0.95,'\downarrow','FontWeight','bold','FontName','Arial');%,'FontSize',20
text(MaxX*0.9,-Depth(end)*0.9, 'River bed','FontWeight','normal','FontName','Arial')

%% Cell labels ON-OFF
label_on=get(handles.Labelcheckbox,'Value'); 

if label_on==1
    
    for i=1:length(CumlDistance)
        if i==1
            text(CumlDistance(i)/5.5,-Depth(i)*1.03,texlabel(num2str(i)),'FontWeight','normal','FontName','Arial','FontSize',8)
        else
            text(CumlDistance(i)-(CumlDistance(i)-CumlDistance(i-1))/1.1,-Depth(i)*1.03,texlabel(num2str(i)),'FontWeight','normal','FontName','Arial','FontSize',8)
        end
    end
    text(CumlDistance(1)/3,-Depth(1)*2.5,texlabel('Cell #'),'FontWeight','normal','FontName','Arial','FontSize',8)

end
diary off
end

% --- Executes on button press in Add_GBI.
function Add_GBI_Callback(hObject, eventdata, handles)
handleResults=getappdata(0,'handleResults');
ResultsSim=getappdata(handleResults,'ResultsSim');
T2_Hatching=ResultsSim.T2_Hatching;
T2_Gas_bladder=ResultsSim.T2_Gas_bladder;
time=ResultsSim.time;
GBI_switch=get(handles.Add_GBI,'Value'); 
Snapshot_Time_Table=get(handles.Snapshot_Time_Table,'Data');
if GBI_switch==0
    if time(end)>=T2_Hatching
        set(handles.Snapshot_Time_Table,'Data',[0;1;fix(T2_Hatching/2);round(T2_Hatching*10)/10]);
    end
elseif GBI_switch==1&&time(end)>=T2_Gas_bladder
    set(handles.Snapshot_Time_Table,'Data',[0;1;round(T2_Hatching*10)/10;round(T2_Gas_bladder*10)/10]);
end
end


% --- Executes on button press in Add_Hatching_Time.
function Add_Hatching_Time_Callback(hObject, eventdata, handles)
handleResults=getappdata(0,'handleResults');
ResultsSim=getappdata(handleResults,'ResultsSim');
T2_Hatching=ResultsSim.T2_Hatching;
T2_Gas_bladder=ResultsSim.T2_Gas_bladder;
time=ResultsSim.time;
Hatching_switch=get(handles.Add_Hatching_Time,'Value'); 
Snapshot_Time_Table=get(handles.Snapshot_Time_Table,'Data');
if Hatching_switch==1
    if time(end)>=T2_Hatching
       id=find(Snapshot_Time_Table==T2_Hatching,1,'first');
       if isempty(id) 
        set(handles.Snapshot_Time_Table,'Data',sort([Snapshot_Time_Table;round(T2_Hatching*10)/10]));
       end
    end
end
end

% --- Executes on button press in Add_snapshot.
function Add_snapshot_Callback(hObject, eventdata, handles)
Add_snapshot=get(hObject,'Value');
Snapshot_Time_Table=get(handles.Snapshot_Time_Table,'Data');
if Add_snapshot==1
        set(handles.Snapshot_Time_Table,'Data',[Snapshot_Time_Table;NaN]);
end
set(handles.Add_snapshot,'Value',0); 
end


% --- Executes on button press in clear_table.
function clear_table_Callback(hObject, eventdata, handles)
clear_table=get(hObject,'Value');
if clear_table==1
        set(handles.Snapshot_Time_Table,'Data',0);
end
% Unselect options
set(handles.Add_Hatching_Time,'Value',0); 
set(handles.Add_GBI,'Value',0); 
set(handles.Add_snapshot,'Value',0); 
end
