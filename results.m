function varargout = Results(varargin)
% RESULTS MATLAB code for Results.fig
%  
% Edit the above text to modify the response to help Results

% Last Modified by GUIDE v2.5 18-Sep-2013 16:43:56

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
end

% --- Executes just before Results is made visible.
function Results_OpeningFcn(hObject, eventdata, handles, varargin)
diary('./results/FluEgg_LogFile.txt')
axes(handles.bottom); imshow('asiancarp.png');
button_load_picture(hObject, eventdata, handles);
handles.Results=0;
handles.output = hObject;
guidata(hObject, handles);
end

% --- Executes on button press in Browse_button.
function Browse_button_Callback(hObject, eventdata, handles)
%% Main handles
setappdata(0,'handleResults',gcf); %gcf-->get current GUI
handleResults=getappdata(0,'handleResults'); %0 means root-->storage in desktop
[filename, pathname] = uigetfile('./results/Results_*.mat', 'Open result file');
fullpath_result = [pathname,filename];
load (fullpath_result);
setappdata(handleResults, 'ResultsSim', ResultsSim);
setappdata(handleResults, 'fullpath_result', fullpath_result);
setappdata(handleResults, 'pathname',pathname);
set(handles.ResultsPathName,'string',filename);
guidata(hObject, handles);
end

function varargout = Results_OutputFcn(~, ~, handles) 
diary off
varargout{1} = handles.output;
end
function PostprocessingOptions_listbox_Callback(~, ~, handles)
end
function PostprocessingOptions_listbox_CreateFcn(hObject, ~, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
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
       case 'Vertical position of the centroid of the egg mass as a function of distance'
        egg_mass_centroid_Vs_distance();
       case 'Summary of temporal and spatial evolution of the egg mass'
        temporal_and_spatial_dispersion();
    case 'Egg vertical concentration distribution' 
        Egg_vertical_concentration();
    case 'Distribution of eggs over the water column at hatching time' 
        Distribution_of_Eggs_at_hatching();
    case 'Distribution of eggs over the water column at a given downstream distance' 
        Distribution_of_Eggs_at_a_distance();
    case 'Egg travel-time distribution'
        travel_time();
    case '3D animation of egg transport (video)' 
        Minigui_Video();     
end
end

function checkbox1_Callback(~, ~, handles)
end

function ResultsPathName_Callback(~, eventdata, handles)
end

function ResultsPathName_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function egg_mass_centroid_Vs_distance()
ed=cellslabel();
uiwait(ed);
%%
gray=[128 128 128]/255;
lightgray=[211 211 211]/255;
%% Generate Normalized plot
%% Load data
[label_on,Temp,specie,time,Xi]=load_data;
%========================================
%% Calculate means
[meanZ_H,meanX]=load_data_and_calculate_means;

%%
set(0,'Units','pixels') ;
scnsize = get(0,'ScreenSize');
figure('Name','Normalized vertical position of the centroid of the egg mass','NumberTitle','off',...
    'color','w','position',[8 scnsize(4)/2.6 scnsize(3)/2.1333 scnsize(4)/2]);
%h=figure('color','w','position',[50 170 600 365]);h=axes('Parent',h);
subaxis(1,1,1,'SpacingVert',0,'MR',0.1,'ML',0.102,'MB',0.13,'MT',0.21);
plot((meanX)/1000,meanZ_H,'r','linewidth',1);
hold on
%ax1=gca;
%% Time
ylimits=[0 1];
%% Time to hatch
TimeToHatch = HatchingTime(Temp,specie);
%% Plot
%ylimits=get(ax1,'YLim');
%% text
text(double(Xi/1000-0.07),1.02, '\downarrow','FontWeight','normal','FontName','Arial')
text(double(Xi/1000-0.02),1.15, {'Fish','spawn','here'},'HorizontalAlignment','center','FontName','Arial')
%%
% if TimeToHatch*60*60<time(end)
%     Time_index=find(time>=TimeToHatch*60*60);Time_index=Time_index(1);
%     plot([meanX(Time_index) meanX(Time_index)]/1000,ylimits,'color','k','LineStyle','--','linewidth',2)
%     %% text
%     text(double(meanX(Time_index)*0.985/1000),1.02, '\downarrow','FontWeight','normal','FontName','Arial')
%     text(double(meanX(Time_index)*0.988/1000),1.185, {'Hatching location','at an average',['temperature of ', num2str(round(mean(Temp)*10)/10),' \circC'],['(',num2str(floor(TimeToHatch*10)/10),' hours)']},'HorizontalAlignment','center','FontName','Arial')
% end
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
xlabel('Average downstream distance from spawning location [km]','FontName','Arial','FontSize',12);
ylabel('Normalized vertical position (z/h+1) [ ]','FontName','Arial','FontSize',12);
set(gca,'TickDir','in','TickLength',[0.021 0.021],'FontName','Arial','FontSize',12)   
ylim([0 1])
%xlim([0 max(CumlDistance)])
xlim([0 max(meanX)/1000])
 %% Water surface
annotation('line',[0.901 1],[0.79 0.79]);
annotation('line',[0.93 0.97],[0.78 0.78]);%annotation('line',[0.92 0.98](x location),[0.88 0.88](y location));
annotation('line',[0.94 0.96],[0.77 0.77]);
%% triangle
annotation('line',[0.94 0.96],[0.82 0.82]);
annotation('line',[0.94 0.95],[0.82 0.80]);
annotation('line',[0.95 0.96],[0.8 0.82]);
text(double(CumlDistance(end)*1.06),0.89, {'Water','surface'},'HorizontalAlignment','center','FontName','Arial')

%% River bed anotations
annotation('line',[0.901 1],[0.13 0.13]);
annotation('line',[0.92 0.932],[0.122 0.1120]);
annotation('line',[0.91 0.922],[0.122 0.1120]);
annotation('line',[0.935 0.935],[0.1130 0.1180]);
annotation('line',[0.95 0.94],[0.122 0.1120]);
annotation('line',[0.96 0.95],[0.122 0.1120]);
annotation('line',[0.96 0.97],[0.1160 0.1060]);
annotation('line',[0.95 0.95],[0.1080 0.1050]);
annotation('line',[0.975 0.975],[0.1140 0.1000]);
annotation('line',[0.98 0.99],[0.1160 0.1060]);
annotation('line',[0.986 0.996],[0.1160 0.1060]);
annotation('line',[0.97 0.966],[0.1200 0.1100]);
annotation('line',[0.936 0.947],[0.1020 0.0900]);
annotation('line',[0.928 0.939],[0.1020 0.0900]);
annotation('line',[0.97 0.96],[0.1020 0.0900]);
annotation('line',[0.98 0.97],[0.1020 0.0900]);
text(double(CumlDistance(end)*1.06),0.063, {'River','bed'},'HorizontalAlignment','center','FontName','Arial')
set(gca,'TickDir','in','TickLength',[0.021 0.021],'FontName','Arial','FontSize',12,'XMinorTick','on','YGrid','on')   
%% Text Cells
if label_on==1
for i=1:length(CumlDistance)
    if i==1
            text(double(CumlDistance(i)/3),0.95,texlabel(num2str(i)),'FontWeight','normal','FontName','Arial','FontSize',7)
    else
    text(double(CumlDistance(i)-(CumlDistance(i)-CumlDistance(i-1))/1.3),0.95,texlabel(num2str(i)),'FontWeight','normal','FontName','Arial','FontSize',7)
    end
end
text(double(CumlDistance(1)/3),0.87,texlabel('Cell #'),'FontWeight','normal','FontName','Arial','FontSize',7)
end
 if TimeToHatch*60*60>time(end)
    ed = errordlg('Eggs have not hatched yet','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed); 
 end
diary off
%%
function [meanZ_H,meanX]=load_data_and_calculate_means
%% Load data
handleResults=getappdata(0,'handleResults'); 
ResultsSim=getappdata(handleResults,'ResultsSim');
X=ResultsSim.X;
Z=ResultsSim.Z;
CumlDistance=ResultsSim.CumlDistance;
Depth=ResultsSim.Depth;
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
clear h
meanX=mean(X,2);
%% Mean of alive eggs
% for t=1:size(X,1)
%     meanX(t)=mean(X(t,alive(t,:)==1));
% end
meanZ_H=mean(Z_H,2);
%STDZ_H=std(Z_H,1,2);
end %load_data_and_calculate_means
%%
function [label_on,Temp,specie,time,Xi]=load_data
handleResults=getappdata(0,'handleResults'); 
label_on=getappdata(handleResults,'label_on');
ResultsSim=getappdata(handleResults,'ResultsSim');
Temp=ResultsSim.Temp;
specie=ResultsSim.specie;
time=ResultsSim.time;
Xi=ResultsSim.Spawning(1);%m
end %load_data
%%
end %Function egg mass centroid

function Distribution_of_Eggs_at_hatching()
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
 %% Time to hatch
TimeToHatch = HatchingTime(Temp,specie);

if TimeToHatch*60*60>time(end)
    ed = errordlg('Eggs have not hatched yet','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed); 
else
 %% Percentage of eggs in the water column
 %% finding the normalized location at hatching time
tindex=find(time>=TimeToHatch*3600);tindex=tindex(1);
Z_at_hatching=Z(tindex,:);Z_at_hatching=Z_at_hatching';
X_at_hatching=X(tindex,:);X_at_hatching=X_at_hatching';
%% finding water depth at each egg location
Cell=zeros(size(Z_at_hatching));
h=zeros(size(Z_at_hatching));
for e=1:length(Z_at_hatching)
    C=find(X_at_hatching(e)<CumlDistance*1000);Cell(e)=C(1);
    h(e)=Depth(Cell(e)); %m
end
Z_H_hatch=(Z_at_hatching+h)./h;
N=histc(Z_H_hatch,0:0.05:1);N=N(1:end-1)';
%% Plot
set(0,'Units','pixels') ;
scnsize = get(0,'ScreenSize');
figure('Name','Percentage of eggs distributed in the vertical','Color',[1 1 1],...
    'position',[scnsize(3)/2 scnsize(4)/2.6 scnsize(3)/2.1333 scnsize(4)/2]);
subaxis(1,1,1,'MR',0.1,'ML',0.1,'MB',0.13,'MT',0.08);
barh(0.025:0.05:1,N*100/sum(N),1,'FaceColor',[1,0.5,0.5])
set(gca,'YTick',0:0.1:1,'YTickLabel',0:0.1:1);
ylabel('Normalized vertical position (z/h+1) [ ]','FontName','Arial','FontSize',12);
xlabel('Percentage of eggs [%]','FontName','Arial','FontSize',12);
set(gca,'TickDir','in','TickLength',[0.021 0.021],'FontName','Arial','FontSize',12)   
%% Text
Xlimit=get(gca,'XTick');
 %% Water surface
annotation('line',[0.901 1],[0.92 0.92]);
annotation('line',[0.93 0.97],[0.91 0.91]);%annotation('line',[0.92 0.98](x location),[0.88 0.88](y location));
annotation('line',[0.94 0.96],[0.9 0.9]);
%% triangle
annotation('line',[0.94 0.96],[0.95 0.95]);
annotation('line',[0.94 0.95],[0.95 0.93]);
annotation('line',[0.95 0.96],[0.93 0.95]);
text(Xlimit(end)*1.065,0.89, {'Water','surface'},'HorizontalAlignment','center','FontName','Arial')
%% River bed anotations
annotation('line',[0.901 1],[0.13 0.13]);
annotation('line',[0.92 0.932],[0.122 0.1120]);
annotation('line',[0.91 0.922],[0.122 0.1120]);
annotation('line',[0.935 0.935],[0.1130 0.1180]);
annotation('line',[0.95 0.94],[0.122 0.1120]);
annotation('line',[0.96 0.95],[0.122 0.1120]);
annotation('line',[0.96 0.97],[0.1160 0.1060]);
annotation('line',[0.95 0.95],[0.1080 0.1050]);
annotation('line',[0.975 0.975],[0.1140 0.1000]);
annotation('line',[0.98 0.99],[0.1160 0.1060]);
annotation('line',[0.986 0.996],[0.1160 0.1060]);
annotation('line',[0.97 0.966],[0.1200 0.1100]);
annotation('line',[0.936 0.947],[0.1020 0.0900]);
annotation('line',[0.928 0.939],[0.1020 0.0900]);
annotation('line',[0.97 0.96],[0.1020 0.0900]);
annotation('line',[0.98 0.97],[0.1020 0.0900]);
text(Xlimit(end)*1.065,0.063, {'River','bed'},'HorizontalAlignment','center','FontName','Arial')
end
diary off
end

function Distribution_of_Eggs_at_a_distance()
ed=downDist();
uiwait(ed);
handleResults=getappdata(0,'handleResults'); 
dX=getappdata(handleResults,'dX'); 
%% From Results Gui
handleResults=getappdata(0,'handleResults'); 
ResultsSim=getappdata(handleResults,'ResultsSim');
CumlDistance=ResultsSim.CumlDistance;
Depth=ResultsSim.Depth;
X=ResultsSim.X;
Z=ResultsSim.Z;
cell=find((CumlDistance)*1000>=dX);cell=cell(1);
h=Depth(cell);
%%
c=0;
check=0;%Have all the eggs arrive to distance X???
for i=1:size(X,2)
    tind=find(X(:,i)>=dX);
        if length(tind)>=1
            tind=tind(1);
            c=c+1;
            Z_Dist_X(c)=Z(tind,i);
            check=check+1;
        end
end
%%
if check==0
  ed = errordlg('No eggs have arrived downstream distance X, please check the distribution of eggs closer to the spawning location','Error');
  set(ed, 'WindowStyle', 'modal');
  uiwait(ed); 
else
Z_Dist_X=(Z_Dist_X+h)./h;
N=histc(Z_Dist_X,0:0.05:1);N=N(1:end-1)';%N(end) is number of eggs located above water depth--> none
%% Plot
set(0,'Units','pixels') ;
scnsize = get(0,'ScreenSize');
figure('Name','Percentage of eggs distributed in the vertical','Color',[1 1 1],...
    'position',[scnsize(3)/2 scnsize(4)/2.6 scnsize(3)/2.1333 scnsize(4)/2]);
subaxis(1,1,1,'MR',0.1,'ML',0.1,'MB',0.13,'MT',0.08);
barh(0.025:0.05:1,N*100/sum(N),1,'FaceColor',[1,0.5,0.5])
set(gca,'YTick',0:0.1:1,'YTickLabel',0:0.1:1);
ylabel('Normalized vertical position (z/h+1) [ ]','FontName','Arial','FontSize',12);
xlabel('Percentage of eggs [%]','FontName','Arial','FontSize',12);
set(gca,'TickDir','in','TickLength',[0.021 0.021],'FontName','Arial','FontSize',12)   
%% Text
Xlimit=get(gca,'XTick');
 %% Water surface
annotation('line',[0.901 1],[0.92 0.92]);
annotation('line',[0.93 0.97],[0.91 0.91]);%annotation('line',[0.92 0.98](x location),[0.88 0.88](y location));
annotation('line',[0.94 0.96],[0.9 0.9]);
%% triangle
annotation('line',[0.94 0.96],[0.95 0.95]);
annotation('line',[0.94 0.95],[0.95 0.93]);
annotation('line',[0.95 0.96],[0.93 0.95]);
text(Xlimit(end)*1.065,0.89, {'Water','surface'},'HorizontalAlignment','center','FontName','Arial')
%% River bed anotations
annotation('line',[0.901 1],[0.13 0.13]);
annotation('line',[0.92 0.932],[0.122 0.1120]);
annotation('line',[0.91 0.922],[0.122 0.1120]);
annotation('line',[0.935 0.935],[0.1130 0.1180]);
annotation('line',[0.95 0.94],[0.122 0.1120]);
annotation('line',[0.96 0.95],[0.122 0.1120]);
annotation('line',[0.96 0.97],[0.1160 0.1060]);
annotation('line',[0.95 0.95],[0.1080 0.1050]);
annotation('line',[0.975 0.975],[0.1140 0.1000]);
annotation('line',[0.98 0.99],[0.1160 0.1060]);
annotation('line',[0.986 0.996],[0.1160 0.1060]);
annotation('line',[0.97 0.966],[0.1200 0.1100]);
annotation('line',[0.936 0.947],[0.1020 0.0900]);
annotation('line',[0.928 0.939],[0.1020 0.0900]);
annotation('line',[0.97 0.96],[0.1020 0.0900]);
annotation('line',[0.98 0.97],[0.1020 0.0900]);
text(Xlimit(end)*1.065,0.063, {'River','bed'},'HorizontalAlignment','center','FontName','Arial')
%% Message
h = msgbox([num2str(sum(N)) ' eggs passed by ' num2str(dX/1000) ' km downstream from the virtual spawning location during the simulation time'],'FluEgg Message');
end
end


function travel_time()
ed=downDist();
uiwait(ed);
%% From Results Gui
handleResults=getappdata(0,'handleResults'); 
dX=getappdata(handleResults,'dX'); 
ResultsSim=getappdata(handleResults,'ResultsSim');
CumlDistance=ResultsSim.CumlDistance;
X=ResultsSim.X;
Z=ResultsSim.Z;
Depth=ResultsSim.Depth;
Temp=ResultsSim.Temp;
time=ResultsSim.time;
specie=ResultsSim.specie;
cell=find((CumlDistance)*1000>=dX);cell=cell(1);
h=Depth(cell);
%%
c=0;
check=0;%Have all the eggs arrive to distance X???
for i=1:size(X,2)
    tind=find(X(:,i)>=dX);
        if length(tind)>=1
            tind=tind(1);
            c=c+1;
            t_Dist_X(c)=time(tind);
            Z_Dist_X(c)=Z(tind,i);
            check=check+1;
        end
end
%%
if check==0
  ed = errordlg('No eggs have arrived downstream distance X, please check the distribution of eggs closer to the spawning location or run the model for a longer time','Error');
  set(ed, 'WindowStyle', 'modal');
  uiwait(ed); 
else
Z_Dist_X=(Z_Dist_X+h)./h;
t_Dist_X=t_Dist_X/3600; %In hours
%% Eggs in suspension
Nsusp=t_Dist_X(Z_Dist_X>0.05);
Nbot=t_Dist_X(Z_Dist_X<0.05);
%%
k=round(2*size(X,2)^(1/3));%Number of bins
edges=min(t_Dist_X):(max(t_Dist_X)+0.01-min(t_Dist_X))/k:max(t_Dist_X)+0.01;
bids=(edges(1:end-1)+edges(2:end))/2;bids=bids';
%%
Nbot=histc(Nbot,edges);Nbot=Nbot(1:end-1)';%here we dont include numbers greater than the max edge
try
Nsusp=histc(Nsusp,edges);Nsusp=Nsusp(1:end-1)';%here we dont include numbers greater than the max edge
if isempty(Nsusp)
    Nsusp=Nbot*0;
end
catch
      ed = errordlg('Error','Error');
end
%% Plot
set(0,'Units','pixels') ;
scnsize = get(0,'ScreenSize');
figure('Name','Travel time distribution at a given downstream distance','Color',[1 1 1],...
    'position',[scnsize(3)/2 scnsize(4)/2.6 scnsize(3)/2.1333 scnsize(4)/2]);
subaxis(1,1,1,'MR',0.085,'ML',0.11,'MB',0.13,'MT',0.22);
bar1=bar(bids,[Nsusp Nbot]*100/size(X,2),1,'stacked');%,'FaceColor',[0.3804,0.8118,0.8980])
set(bar1(1),'FaceColor',[0.3804,0.8118,0.8980]);
set(bar1(2),'FaceColor',[0.6,0.6,0.6]);
hold on
%xlim([min(edges) (max(edges)+0.01)])
%set(gca,'YTick',0:0.1:1,'YTickLabel',0:0.1:1);
ylim([0 round(1.5*max([Nsusp+Nbot]*100/size(X,2)))])
ylabel('Percentage of eggs [%]','FontName','Arial','FontSize',12);
xlabel('Time since spawning [h]','FontName','Arial','FontSize',12);
set(gca,'TickDir','in','TickLength',[0.021 0.021],'FontName','Arial','FontSize',12)   
ax1=gca;
%%
%% Time to hatch
TimeToHatch = HatchingTime(Temp,specie);
%
ylimits=get(ax1,'YLim');
N=Nsusp+Nbot;
if TimeToHatch*60*60<time(end)
    plot([TimeToHatch TimeToHatch],ylimits,'color','k','LineStyle','--','linewidth',2)
    %% text
    text(double(TimeToHatch*0.995),ylimits(end)*1.02, '\downarrow','FontWeight','normal','FontName','Arial')
    text(double(TimeToHatch),ylimits(end)*1.19, {'Hatching time','at an average',['temperature of ', num2str(round(mean(Temp)*10)/10),' \circC'],['(',num2str(floor(TimeToHatch*10)/10),' hours)']},'HorizontalAlignment','center','FontName','Arial')
    %%
     
%     id=find(N==max(N));id=id(1);
%     leadingEdge=0.89*bids(id);
%     TrailingEdge=leadingEdge+2000000/(3600*1025*bids(id)^-0.887);
%     plot([leadingEdge leadingEdge],ylimits,'color',[241 29 26]/255,'linewidth',1.3)
%     plot([TrailingEdge TrailingEdge],ylimits,'color',[0 64 222]/255,'linewidth',1.3)
%     text(leadingEdge*0.95,ylimits(end)*0.74, {'LE'},'HorizontalAlignment','center','FontName','Arial','rotation',90)
%     text(TrailingEdge*0.97,ylimits(end)*0.74, {'TE'},'HorizontalAlignment','center','FontName','Arial','rotation',90)
     leg1 = legend('In suspension', 'Near the bottom','location','SouthEast');
%     set(leg1,'box','off','color','none')
    %% Eggs at risk of hatching
    if max(bids)>=TimeToHatch
        hatchingIndex=find(bids>=TimeToHatch);hatchingIndex=hatchingIndex(1);
        PercentHatching=sum(Nsusp(hatchingIndex:end)*100/sum(N));
        plot([TimeToHatch edges(end)],[ylimits(end)*0.8 ylimits(end)*0.8],'color',[208 35 122]/255,'linewidth',1.5)
        plot(TimeToHatch,ylimits(end)*0.8,'MarkerFaceColor',[208 35 122]/255,'MarkerEdgeColor',[208 35 122]/255,'Marker','<')
        plot(edges(end),ylimits(end)*0.8,'MarkerFaceColor',[208 35 122]/255,'MarkerEdgeColor',[208 35 122]/255,'Marker','>')
        plot([edges(end) edges(end)],[0 ylimits(end)*0.8],'color',[128 128 128]/255,'LineStyle',':','linewidth',1)
        %text(TimeToHatch+(edges(end)-TimeToHatch)/2,ylimits(end)*0.88, {['Approximately ' num2str(5*round(PercentHatching/5)),'% of eggs are'],' at risk of hatching'},'HorizontalAlignment','center','FontName','Arial')
        text(double(TimeToHatch+(edges(end)-TimeToHatch)/2),ylimits(end)*0.88, {['Approximately ' num2str(round((PercentHatching*10)/10)),'% of eggs are'],' at risk of hatching'},'HorizontalAlignment','center','FontName','Arial')
       
    end
end
%% Message
h = msgbox(['At the end of the simulation time ' num2str(sum(N)) ' eggs passed by ' num2str(dX/1000) ' km downstream from the virtual spawning location'],'FluEgg Message');
end
end


function button_load_picture(~, eventdata, handles)
Fig_open=imread('browse.png');
set(handles.Browse_button, 'Cdata', Fig_open);
end


