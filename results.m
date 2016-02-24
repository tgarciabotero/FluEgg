function varargout = Results(varargin)
% RESULTS MATLAB code for Results.fig
%      RESULTS, by itself, creates a new RESULTS or raises the existing
%      singleton*.
%
%      H = RESULTS returns the handle to a new RESULTS or the handle to
%      the existing singleton*.
%
%      RESULTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RESULTS.M with the given input arguments.
%
%      RESULTS('Property','Value',...) creates a new RESULTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Results_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Results_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Results

% Last Modified by GUIDE v2.5 01-May-2013 16:10:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Results_OpeningFcn, ...
                   'gui_OutputFcn',  @Results_OutputFcn, ...
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


% --- Executes just before Results is made visible.
function Results_OpeningFcn(hObject, eventdata, handles, varargin)
axes(handles.bottom); imshow('asiancarp.png');
axes(handles.logoUofI); imshow('imark.tif');
axes(handles.logo_usgs); imshow('logo_usgs.png');
button_load_picture(hObject, eventdata, handles);
handles.Results=0;
handles.output = hObject;
%% Main handles
setappdata(0,'handleResults',gcf); %gcf-->get current GUI
%%
guidata(hObject, handles);

% --- Executes on button press in Browse_button.
function Browse_button_Callback(hObject, eventdata, handles)
handleResults=getappdata(0,'handleResults'); %0 means root-->storage in desktop
[filename, pathname] = uigetfile('./results/Results_*.mat', 'Open result file');
fullpath_result = [pathname,filename];
load (fullpath_result);
setappdata(handleResults, 'ResultsSim', ResultsSim);
set(handles.ResultsPathName,'string',filename);
guidata(hObject, handles);

function varargout = Results_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;
function PostprocessingOptions_listbox_Callback(~, ~, handles)
function PostprocessingOptions_listbox_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function generate_Callback(~, ~, handles)
handleResults=getappdata(0,'handleResults'); 
ResultsSim=getappdata(handleResults,'ResultsSim');
if isempty(ResultsSim)
   ed = errordlg('Please load results file and continue','Error');
   set(ed, 'WindowStyle', 'modal');
   uiwait(ed); 
   return
end
% Determine the selected data set.
str=get(handles.PostprocessingOptions_listbox, 'String');
val=get(handles.PostprocessingOptions_listbox,'Value');
switch str{val};
    case 'Evolution of a mass of Asian carp eggs'  
        snapshotPlotDt();
    case 'Egg vertical concentration distribution' 
        Egg_vertical_concentration();
    case 'Vertical position of the centroid of the egg mass as a function of distance'
        egg_mass_centroid_Vs_distance();
    case 'Normalized vertical position of the centroid of the egg mass' 
        Normalized_egg_mass_centroid_Vs_distance();
    case '3D animation of eggs transport (video)' 
        Minigui_Video();       
end

function checkbox1_Callback(~, ~, handles)
function ResultsPathName_Callback(hObject, eventdata, handles)
function ResultsPathName_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function egg_mass_centroid_Vs_distance()
%%
handleResults=getappdata(0,'handleResults'); 
ResultsSim=getappdata(handleResults,'ResultsSim');
X=ResultsSim.X;
Z=ResultsSim.Z;
CumlDistance=ResultsSim.CumlDistance;
Depth=ResultsSim.Depth;
Temp=ResultsSim.Temp;
specie=ResultsSim.specie;
time=ResultsSim.time;
%%
meanX=mean(X,2);
meanZ=mean(Z,2);
%% Mean of alive eggs
% for t=1:size(X,1)
%     meanX(t)=mean(X(t,alive(t,:)==1));
% end
%%
figure('color','w','position',[ 1000 300 600  400]);
subaxis(1,1,1,'SpacingVert',0,'MR',0.02,'ML',0.075,'MB',0.105,'MT',0.19);
line((meanX)/1000,meanZ,'color','r')
%%
hold on
stairs(([0; CumlDistance]),[-Depth; -Depth(end)],'color','k','linewidth',2);
ax1=gca;
set(gca,'TickDir','in','TickLength',[0.021 0.021],'FontSize',12);
xlabel('Distance (X spatial mean) [km]','FontName','Arial','FontSize',12);
ylabel('Vertical position of the centroid of egg mass [m]','FontName','Arial','FontSize',12);
xlim([0 max(CumlDistance)])
%% Text
for i=1:length(CumlDistance)
    if i==1
            text(CumlDistance(i)/3,-Depth(i)-0.2,texlabel(num2str(i)),'FontWeight','bold','FontName','Arial')
    else
    text(CumlDistance(i)-(CumlDistance(i)-CumlDistance(i-1))/1.5,-Depth(i)-0.2,texlabel(num2str(i)),'FontWeight','bold','FontName','Arial')
    end
end
text(CumlDistance(end)/2.4,-0.2,texlabel('Water surface'),'FontWeight','bold','FontName','Arial')
text(CumlDistance(1)/3,-Depth(1)-0.7,texlabel('Cell #'),'FontWeight','bold','FontName','Arial')
text(CumlDistance(end)*0.97,-Depth(end)+0.15, '\downarrow','FontWeight','bold','FontName','Arial')
text(CumlDistance(end)*0.9,-Depth(end)+0.4, 'River bed','FontWeight','bold','FontName','Arial')
text(-0.07,0.15, '\downarrow','FontWeight','bold','FontName','Arial')
text(0.005,0.9, {'Fish','spawn','here'},'HorizontalAlignment','center','FontName','Arial')
%% Time to hatch
AvgTemp=mean(Temp);
if strcmp(specie,'Silver')%if specie=='Silver'
    %% If silver carp
    %This funtion includes a compilation of different research done about
    %hatching time R^2=0.96558 
    TimeToHatch=1.2087e+7*(AvgTemp^-4.2664)+10.242;%Time to hatch in hours
else
    %% If Bighead carp
    %This funtion includes a compilation of different research done about
    %hatching time R^2=0.93029
    TimeToHatch=35703*(AvgTemp^-2.223);%Time to hatch in hours
end
ylimits=get(ax1,'YLim');
if TimeToHatch*60*60<time(end)
    Time_index=find(time>=TimeToHatch*60*60);Time_index=Time_index(1); 
    plot([X(Time_index) X(Time_index)]/1000,ylimits,'color','k','LineStyle','--','linewidth',2)
    %% text
    text(X(Time_index)*0.985/1000,0.15, '\downarrow','FontWeight','bold','FontName','Arial')
    text(X(Time_index)*0.988/1000,0.96, {'Hatching','location',['at ', num2str(round(AvgTemp*10)/10),' \circC'],['(',num2str(floor(TimeToHatch*10)/10),' hours)']},'HorizontalAlignment','center','FontName','Arial')
end
%%
set(gca,'XMinorTick','on')
box on
set(gca,'FontSize',12)
if TimeToHatch*60*60>time(end)
    ed = errordlg('Eggs have not hatched yet','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed); 
end

function  Normalized_egg_mass_centroid_Vs_distance()
%% Load data
handleResults=getappdata(0,'handleResults'); 
ResultsSim=getappdata(handleResults,'ResultsSim');
X=ResultsSim.X;
Z=ResultsSim.Z;
CumlDistance=ResultsSim.CumlDistance;
Depth=ResultsSim.Depth;
Temp=ResultsSim.Temp;
specie=ResultsSim.specie;
time=ResultsSim.time;
%%
gray=[128 128 128]/255;
lightgray=[211 211 211]/255;
%%
Cell=zeros(size(X));
h=zeros(size(X));
for e=1:size(X,2)
    C=find(X(1,e)<CumlDistance*1000);Cell(1,e)=C(1);
    h(1,e)=Depth(Cell(1,e)); %m
end
for t=2:size(X,1)
        Cell(t,:)=Cell(t-1,:);
        h(t,:)=Depth(Cell(t-1,:));%if the eggs are still in the same cell use the same characteristic as previous time step
        [c,~]=find(X(t,:)'>(CumlDistance(Cell(t-1,:))*1000));                
        for j=1:length(c)
        C=find(X(t,c(j))<CumlDistance*1000);Cell(t,c(j))=C(1);%cell is the cell were an egg is
        h(t,c(j))=Depth(Cell(t,c(j))); %m
        end
end
clear Cell C c i e
Z_H=(Z+h)./h;
meanX=mean(X,2);
%% Mean of alive eggs
% for t=1:size(X,1)
%     meanX(t)=mean(X(t,alive(t,:)==1));
% end
meanZ_H=mean(Z_H,2);
STDZ_H=std(Z_H,1,2);
%%
h=figure('color','w','position',[50 170 600 365]);h=axes('Parent',h);
subaxis(1,1,1,'SpacingVert',0,'MR',0.1,'ML',0.075,'MB',0.105,'MT',0.2);
plot((meanX)/1000,meanZ_H,'r','linewidth',1.5);
hold on
ax1=gca;
%% Time
ylimits=[0 1];
%% Time to hatch
AvgTemp=mean(Temp);
if strcmp(specie,'Silver')%if specie=='Silver'
    %% If silver carp
    %This funtion includes a compilation of different research done about hatching time R^2=0.96558 
    TimeToHatch=1.2087e+7*(AvgTemp^-4.2664)+10.242;%Time to hatch in hours
else
    %% If Bighead carp
    %This funtion includes a compilation of different research done about hatching time R^2=0.93029
    TimeToHatch=35703*(AvgTemp^-2.223);%Time to hatch in hours
end
ylimits=get(ax1,'YLim');
%% text
text(-0.07,1.02, '\downarrow','FontWeight','bold','FontName','Arial')
    text(-0.02,1.14, {'Fish','spawn','here'},'HorizontalAlignment','center','FontName','Arial')
%%
if TimeToHatch*60*60<time(end)
    Time_index=find(time>=TimeToHatch*60*60);Time_index=Time_index(1);
    plot([X(Time_index) X(Time_index)]/1000,ylimits,'color','k','LineStyle','--','linewidth',2)
    %% text
    text(X(Time_index)*0.985/1000,1.02, '\downarrow','FontWeight','bold','FontName','Arial')
    text(X(Time_index)*0.988/1000,1.17, {'Hatching location','at an average',['temperature of ', num2str(round(AvgTemp*10)/10),' \circC'],['(',num2str(floor(TimeToHatch*10)/10),' hours)']},'HorizontalAlignment','center','FontName','Arial')
end
%% Patches
%%
yy=[0 0 1 1];
for i=1:length(CumlDistance)
    if i==1
  xx=[0 CumlDistance(i) CumlDistance(i) 0];
  patch(xx,yy,gray,'FaceAlpha',0.2,'LineStyle','none')
    elseif mod(i,2)==0
        xx=[CumlDistance(i-1) CumlDistance(i) CumlDistance(i) CumlDistance(i-1)];
        patch(xx,yy,lightgray,'FaceAlpha',0.2,'LineStyle','none')
    else
          xx=[CumlDistance(i-1) CumlDistance(i) CumlDistance(i) CumlDistance(i-1)];
          patch(xx,yy,gray,'FaceAlpha',0.2,'LineStyle','none')
    end
end
 xlabel('Average downstream distance from spawning location [km]','FontName','Arial','FontSize',10);
 ylabel('Normalized vertical position (Z/H) [ ]','FontName','Arial','FontSize',10);
 ylim([0 1])
 xlim([0 max(CumlDistance)])
 %% Water surface
annotation('line',[0.901 1],[0.8 0.8]);
annotation('line',[0.93 0.97],[0.79 0.79]);%annotation('line',[0.92 0.98](x location),[0.88 0.88](y location));
annotation('line',[0.94 0.96],[0.78 0.78]);
%% triangle
annotation('line',[0.94 0.96],[0.83 0.83]);
annotation('line',[0.94 0.95],[0.83 0.81]);
annotation('line',[0.95 0.96],[0.81 0.83]);
text(27,0.9, {'Water','surface'},'HorizontalAlignment','center','FontName','Arial')

%% River bed anotations
annotation('line',[0.901 1],[0.103 0.103]);
annotation('line',[0.92 0.932],[0.102 0.092]);
annotation('line',[0.91 0.922],[0.102 0.092]);
annotation('line',[0.935 0.935],[0.093 0.098]);
annotation('line',[0.95 0.94],[0.102 0.092]);
annotation('line',[0.96 0.95],[0.102 0.092]);
annotation('line',[0.96 0.97],[0.096 0.086]);
annotation('line',[0.95 0.95],[0.088 0.085]);
annotation('line',[0.975 0.975],[0.094 0.08]);
annotation('line',[0.98 0.99],[0.096 0.086]);
annotation('line',[0.986 0.996],[0.096 0.086]);
annotation('line',[0.97 0.966],[0.1 0.09]);
annotation('line',[0.936 0.947],[0.082 0.07]);
annotation('line',[0.928 0.939],[0.082 0.07]);
annotation('line',[0.97 0.96],[0.08 0.07]);
annotation('line',[0.98 0.97],[0.08 0.07]);
text(27,0.06, {'River','bed'},'HorizontalAlignment','center','FontName','Arial')
%% Text Cells
for i=1:length(CumlDistance)
    if i==1
            text(CumlDistance(i)/3,0.95,texlabel(num2str(i)),'FontWeight','bold','FontName','Arial')
    else
    text(CumlDistance(i)-(CumlDistance(i)-CumlDistance(i-1))/1.5,0.95,texlabel(num2str(i)),'FontWeight','bold','FontName','Arial')
    end
end
text(CumlDistance(1)/3,0.87,texlabel('Cell #'),'FontWeight','bold','FontName','Arial')
 set(gca,'FontSize',10)
 set(gca,'XMinorTick','on')
 set(gca,'YGrid','on')   
 if TimeToHatch*60*60>time(end)
    ed = errordlg('Eggs have not hatched yet','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed); 
end

function button_load_picture(hObject, eventdata, handles)
Fig_open=imread('browse.png');
set(handles.Browse_button, 'Cdata', Fig_open);
