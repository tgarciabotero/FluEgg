%%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                    FluEgg Post-processing tools                        %
%%           Generate video or figures to analize FluEgg results          %
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This is the results GUI, it is used inside FluEgg to generate different %
% plots to analyze FluEgg results.                                        %
%-------------------------------------------------------------------------%
%   Created by      : Tatiana Garcia                                      %
%   Last Modified   : June 28, 2016                                       %
%-------------------------------------------------------------------------%
% Copyright 2016 Tatiana Garcia
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
function varargout = Results(varargin)
% Last Modified by GUIDE v2.5 01-Sep-2015 09:05:42

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

%% Setting-up Longitudinal Tab
handles.currentab='Longitudinal';
set(handles.Postprocessing_option(1),'string','Longitudinal distribution');
set(handles.Postprocessing_option(2),'string','Vertical position of the centroid of the egg mass');
set(handles.Postprocessing_option(3),'string','Google Earth utility');
set(handles.Postprocessing_option(4),'Visible','off');
guidata(hObject, handles);
end

function varargout = Results_OutputFcn(~, ~, handles)
diary off
varargout{1} = handles.output;
end

% --- Executes on button press in Browse_button.
function Browse_button_Callback(hObject, eventdata, handles)
% When user selects the results file
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
beep
guidata(hObject, handles);
end

function generate_Callback(hObject, ~, handles)
%% LOAD DATA
handleResults=getappdata(0,'handleResults');
try
    ResultsSim=getappdata(handleResults,'ResultsSim');
catch
    ResultsSim=[];
end
if isempty(ResultsSim)
    ed = errordlg('Please load results file and continue','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
    return
end

%% Determine which kind of analysis was selected by the user
Tab=handles.currentab;

%% selected Post processing tools
selected=cell2mat(get(handles.Postprocessing_option,'Value'));

%% selected life stage
selected_life_stage=cell2mat(get(handles.Life_stage_group,'Value'));
% Error================================================================
if isfield(ResultsSim, 'T2_Gas_bladder')==0%This is for results files from previous FluEgg versions
    T2_Gas_bladder=0;
else
    T2_Gas_bladder=ResultsSim.T2_Gas_bladder;
end
if T2_Gas_bladder==0&&selected_life_stage(1)==1  % Case larvae is not simulated
    strcmp( selected_life_stage, 'Larvae at gas bladder inflation')
    ed = errordlg('Larvae at gas bladder Inflation stage was not simulated','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
    return
end
%==========================================================================
if sum(selected_life_stage)==0
    ed = errordlg('Please select a life stage','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
    return
elseif sum(selected_life_stage)==1
    selected_life_stage={get(handles.Life_stage_group(selected_life_stage==1),'string')};
else
    selected_life_stage=get(handles.Life_stage_group(selected_life_stage==1),'string');
end

%=========================================================================
if sum(selected)==0
    ed = errordlg('Please select a postprocessing tool','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
    return
elseif sum(selected)==1
    Postprocessing_option={get(handles.Postprocessing_option(selected==1),'string')};
else
    Postprocessing_option=get(handles.Postprocessing_option(selected==1),'string');
end
%%
switch Tab
    %%=================================================================================================
    case 'Vertical'
        for i=length(Postprocessing_option):-1:1
            if  strcmp(Postprocessing_option(i),'Distribution of eggs over the water column')
                
                % Construct a questdlg with two options
                choice = questdlg('Do you want to plot the vertical distribution of eggs at:', ...
                    'Plot option','a given time?','a given distance?','a given time?');
                % Handle response
                switch choice
                    case 'a given time?'
                        Distribution_of_Eggs_at_hatching();
                    case 'a given distance?'
                        Distribution_of_Eggs_at_a_distance();
                end
            end
            if  strcmp(Postprocessing_option(i),'Egg vertical concentration distribution')
                Egg_vertical_concentration();
            end
        end
        %%=================================================================================================
    case 'Longitudinal'
        for i=1:sum(selected)
            if  strcmp(Postprocessing_option(i),'Longitudinal distribution')
                Longitudinal_distribution_of_eggs_at_time_t();
            end
            if  strcmp(Postprocessing_option(i),'Vertical position of the centroid of the egg mass')
                egg_mass_centroid_Vs_distance();
            end
            if  strcmp(Postprocessing_option(i),'Google Earth utility')
                Google_Earth_utility();
            end
        end
        %%=================================================================================================
    case 'Temporal'
        for i=length(Postprocessing_option):-1:1
            if  strcmp(Postprocessing_option(i),'Egg travel-time distribution')
                travel_time();
            end
        end
        %%=================================================================================================
    case 'Mixed'
        for i=length(Postprocessing_option):-1:1
            if  strcmp(Postprocessing_option(i),'Evolution of a mass of Asian carp eggs/larvae')
                snapshotPlotDt();
            end
            if  strcmp(Postprocessing_option(i),'Summary of temporal and spatial evolution of the eggs/larvae mass')
                temporal_and_spatial_dispersion();
            end
            if  strcmp(Postprocessing_option(i),'3D animation of egg/larvae transport (video)')
                Minigui_Video();
            end
            if  strcmp(Postprocessing_option(i),'Calculate the percentage of eggs at a given location, depth, and time')
                PercentageEggs_location_time();
            end
            
        end
end

%% Storage data in structure
handleResults=getappdata(0,'handleResults'); %0 means root-->storage in desktop
setappdata(handleResults, 'selected_life_stage', selected_life_stage);
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
%==========================================================================
Message= msgbox('Please wait while your figure is being generated','help');
pause(2.2)
try
    delete(Message)
catch
end
%==========================================================================
%% Generate Normalized plot
%% Load data
[label_on,Temp,time,Xi,T2_Hatching]=load_data; %Updated 9/3/2015 TG
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
%% Plot
%ylimits=get(ax1,'YLim');
%% text
text(double(Xi/1000-0.07),1.02, '\downarrow','FontWeight','normal','FontName','Arial')
text(double(Xi/1000-0.02),1.15, {'Fish','spawn','here'},'HorizontalAlignment','center','FontName','Arial')
%%
if round(T2_Hatching*60*60)<=time(end)%+Dt to round by Dt
    Time_index=find(time>=round(T2_Hatching*60*60));Time_index=Time_index(1);
    plot([meanX(Time_index) meanX(Time_index)]/1000,ylimits,'color','k','LineStyle','--','linewidth',2)
    %% text
    text(double(meanX(Time_index)*0.985/1000),1.02, '\downarrow','FontWeight','normal','FontName','Arial')
    Initial_Cell=find(CumlDistance*1000>=Xi); % Updated TG May,2015
    text(double(meanX(Time_index)*0.988/1000),1.185, {'Hatching location','at an average',['temperature of ', num2str(round(mean(Temp(Initial_Cell:end))*10)/10),' \circC'],['(',num2str(floor(T2_Hatching*10)/10),' hours)']},'HorizontalAlignment','center','FontName','Arial')
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
xlabel('Average downstream distance [km]','FontName','Arial','FontSize',12);
ylabel('Normalized vertical position (z/h+1) [ ]','FontName','Arial','FontSize',12);
set(gca,'TickDir','in','TickLength',[0.021 0.021],'FontName','Arial','FontSize',12)
ylim([0 1])
xlim([0 max(CumlDistance)])
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
if round(T2_Hatching*60*60)>time(end)
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
                if X(t,c(j))<CumlDistance(end)*1000 % If the eggs are in the last cell
                    C=find(X(t,c(j))<CumlDistance*1000);Cell(t,c(j))=C(1);%cell is the cell were an egg is
                    h(t,c(j))=Depth(Cell(t,c(j))); %m
                end
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
    function [label_on,Temp,time,Xi,T2_Hatching]=load_data
        handleResults=getappdata(0,'handleResults');
        label_on=getappdata(handleResults,'label_on');
        ResultsSim=getappdata(handleResults,'ResultsSim');
        Temp=ResultsSim.Temp;
        time=ResultsSim.time;
        Xi=ResultsSim.Spawning(1);%m
        T2_Hatching=ResultsSim.T2_Hatching;
    end %load_data
%%
end %Function egg mass centroid

function [] = temporal_and_spatial_dispersion()
%==========================================================================
Message= msgbox('Please wait while your figure is being generated','help');
pause(2.2)
try
    delete(Message)
catch
end
%==========================================================================
%% Colors
Dark_Gray=[113 113 113]/255;
%% Alpha-->A*STD
A=1;
%% Load data
[time]=load_data;
%%
[meanX,minX,maxX,STDX,meanY_W,minY_W,maxY_W,STDY_W,meanZ_H,minZ_H,maxZ_H,STDZ_H] = calculate_statistics;
%% Checking STD
Check=meanY_W-A*STDY_W; STDY_W(Check<0)=meanY_W(Check<0);
Check=meanY_W+A*STDY_W; STDY_W(Check>1)=1+meanY_W(Check>1);
%%
Check=meanZ_H-A*STDZ_H; STDZ_H(Check<0)=meanZ_H(Check<0);
Check=meanZ_H+A*STDZ_H; STDZ_H(Check>1)=1+meanZ_H(Check>1);
%% Plot
set(0,'Units','pixels') ;
scnsize = get(0,'ScreenSize');
figure('Name','Summary of temporal and spatial evolution of the egg mass','Color',[1 1 1],...
    'position',[scnsize(3)/2 scnsize(4)/8 scnsize(3)/2.1333 scnsize(4)/1.4]);
PlotingX()
PlotingY()
PlotingZ()
    function [meanX,minX,maxX,STDX,meanY_W,minY_W,maxY_W,STDY_W,meanZ_H,minZ_H,maxZ_H,STDZ_H] = calculate_statistics
        %% Data
        handleResults=getappdata(0,'handleResults');
        ResultsSim=getappdata(handleResults,'ResultsSim');
        CumlDistance=ResultsSim.CumlDistance;%Km
        Depth=ResultsSim.Depth;%C
        Width=ResultsSim.Width;
        time=ResultsSim.time;
        X=ResultsSim.X;%Km
        Z=ResultsSim.Z;%m
        Y=ResultsSim.Y;%m
        time=time(1:size(X,1))';
        time=time/3600;%Hours
        %% Cells
        Cell=zeros(size(X));
        h=zeros(size(X));
        W=zeros(size(X));
        for e=1:size(X,2)
            C=find(X(1,e)<CumlDistance*1000);Cell(1,e)=C(1);
            h(1,e)=Depth(Cell(1,e)); %m
            W(1,e)=Width(Cell(1,e)); %m
        end
        for t=2:size(X,1)
            Cell(t,:)=Cell(t-1,:);
            h(t,:)=Depth(Cell(t-1,:));%if the eggs are still in the same cell use the same characteristic as previous time step
            W(t,:)=Width(Cell(t-1,:));%if the eggs are still in the same cell use the same characteristic as previous time step
            [c,~]=find(X(t,:)'>(CumlDistance(Cell(t-1,:))*1000));
            for j=1:length(c)
                if X(t,c(j))<CumlDistance(end)*1000
                    C=find(X(t,c(j))<CumlDistance*1000);Cell(t,c(j))=C(1);%cell is the cell were an egg is
                    h(t,c(j))=Depth(Cell(t,c(j))); %m
                    W(t,c(j))=Width(Cell(t,c(j))); %m
                end
            end
        end
        X=X/1000; %In Km
        %% Normalize
        Z_H=(Z+h)./h;
        Y_W=Y./W;
        %% Statistics
        meanX=mean(X,2);
        minX=min(X,[],2);
        maxX=max(X,[],2);
        STDX=std(X,1,2);% Sample std using (N-1)
        meanY_W=mean(Y_W,2);
        minY_W=min(Y_W,[],2);
        maxY_W=max(Y_W,[],2);
        STDY_W=std(Y_W,1,2);% Sample std using (N-1)
        meanZ_H=mean(Z_H,2);
        minZ_H=min(Z_H,[],2);
        maxZ_H=max(Z_H,[],2);
        STDZ_H=std(Z_H,1,2);% Sample std using (N-1)
    end%statistics
%%
    function [time]=load_data
        handleResults=getappdata(0,'handleResults');
        ResultsSim=getappdata(handleResults,'ResultsSim');
        time=ResultsSim.time;
    end %load_data
    function PlotingX()
        Light_Og=[245 150 120]/255;
        Red=[237 24 31]/255;
        %% X
        subaxis(3,1,1,'MR',0.05,'ML',0.1,'MB',0.09,'MT',0.05);
        plot(time,meanX,'LineWidth',3,'color',Red);hold on
        plot(time,minX,time,maxX,'LineWidth',1.5,'color',Dark_Gray)
        plot(time,meanX+A*STDX,time,meanX-A*STDX,'LineWidth',1.5,'LineStyle','--','color',Red)
        %% Shaded area
        px=[time',fliplr(time')]; % make closed patch
        py=[[meanX+A*STDX]', fliplr([meanX-A*STDX]')];
        patch(px,py,1,'FaceColor',Light_Og,'EdgeColor','none');
        set(gca,'children',flipud(get(gca,'children')))
        %%
        ylabel('X [km]','FontName','Arial','FontSize',11);
        set(gca,'XTickLabel',[],'XColor','k','FontName','Arial');
        set(gca,'XLim',[0 max(time)]);
    end %plotingX
%%
    function PlotingY()
        Light_Berry=[213 163 201]/255;
        Berry=[183 81 161]/255;
        %% Y_W
        subaxis(3,1,2,'MR',0.05,'ML',0.1,'MB',0.09,'MT',0.06);
        plot(time,meanY_W,'LineWidth',3,'color',Berry)
        hold on
        plot(time,minY_W,time,maxY_W,'LineWidth',1.5,'color',Dark_Gray)
        plot(time,meanY_W+A*STDY_W,time,meanY_W-A*STDY_W,'LineWidth',1.5,'LineStyle','--','color',Berry)
        %% Shaded area
        px=[time',fliplr(time')]; % make closed patch
        py=[[meanY_W+A*STDY_W]', fliplr([meanY_W-A*STDY_W]')];
        patch(px,py,1,'FaceColor',Light_Berry,'EdgeColor','none');
        set(gca,'children',flipud(get(gca,'children')))
        %%
        ylabel('Y/W [m]','FontName','Arial','FontSize',11);
        set(gca,'XTickLabel',[],'XColor','k','FontName','Arial');
        set(gca,'XLim',[0 max(time)]);
        ylim([-0.1 1.1])
    end%PlotingY
%%
    function PlotingZ()
        Light_Purple=[168 150 199]/255;
        Purple=[106 75 159]/255;
        %% Z_H
        subaxis(3,1,3,'MR',0.05,'ML',0.1,'MB',0.09,'MT',0.06);
        plot(time,meanZ_H,'LineWidth',3,'color',Purple)
        hold on
        plot(time,minZ_H,time,maxZ_H,'LineWidth',1.5,'color',Dark_Gray)
        meanMinusSTDZ_H=meanZ_H-A*STDZ_H;meanMinusSTDZ_H(meanMinusSTDZ_H<minZ_H)=minZ_H(meanMinusSTDZ_H<minZ_H);
        plot(time,meanZ_H+A*STDZ_H,time,meanMinusSTDZ_H,'LineWidth',1.5,'LineStyle','--','color',Purple)
        %% Shaded area
        px=[time',fliplr(time')]; % make closed patch
        py=[[meanZ_H+A*STDZ_H]', fliplr([meanMinusSTDZ_H]')];
        patch(px,py,1,'FaceColor',Light_Purple,'EdgeColor','none');
        set(gca,'children',flipud(get(gca,'children')))
        %%
        ylabel('Z/H [m]','FontName','Arial','FontSize',11);
        xlabel('Time since spawning [h]','FontName','Arial','FontSize',11);
        set(gca,'XLim',[0 max(time)]);
        ylim([-0.1 1.1])
    end%PlotingZ
%%
end% temporal and spatial dispersion

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

if round(TimeToHatch*60*60)>time(end)
    % Construct a questdlg with two options
choice = questdlg('Eggs have not hatched yet, would you want to plot vertical distribution of eggs at the end of simulation period?', ...
	'Time','Yes','No','at a different time','Yes');
% Handle response
switch choice
    case 'Yes'
        disp([choice ' Perfect.'])
        TimeToHatch=time(end)/3600;
    case 'at a different time'
        TimeToHatch=str2double(inputdlg('time(h)',...
              'Time', [1 10])); 
          if round(TimeToHatch*60*60)>time(end)
              errordlg('Input time is greater than simulated time','FluEgg Error');
          end
          
    case 'No'
        return
end
end
%This was designed for time to hatch, now we use it for different times
    %% Percentage of eggs in the water column
    %% finding the normalized location at hatching time
    tindex=find(time>=round(TimeToHatch*3600));tindex=tindex(1);
    Z_at_hatching=Z(tindex,:);Z_at_hatching=Z_at_hatching';
    X_at_hatching=X(tindex,:);X_at_hatching=X_at_hatching';
    %% finding water depth at each egg location
    Cell=zeros(size(Z_at_hatching));
    h=zeros(size(Z_at_hatching));
    for e=1:length(Z_at_hatching)
        C=find(X_at_hatching(e)<CumlDistance*1000);
        if X_at_hatching(e)<CumlDistance(end)*1000 % If the eggs are in the last cell
            Cell(e)=C(1);
        else
            Cell(e)=length(CumlDistance);
        end
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

diary off
end

function Distribution_of_Eggs_at_a_distance()
ed=downDist();
uiwait(ed);
handleResults=getappdata(0,'handleResults');
dX=getappdata(handleResults,'dX');
% If error in dX input
if isempty(dX)
    return
end
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
    ed = errordlg('No eggs have arrived to distance X, please check the distribution of eggs closer to the spawning location or run the model for a longer time','Error');
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
    h = msgbox([num2str(sum(N)) ' eggs passed by ' num2str(dX/1000) ' km during the simulation time'],'FluEgg Message');
end
end %distribution of eggs at a distance


function travel_time()
ed=downDist();
uiwait(ed);
%% From Results Gui
handleResults=getappdata(0,'handleResults');
dX=getappdata(handleResults,'dX');
% If error in dX input
if isempty(dX)
    return
end
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
    %%
    set(0,'Units','pixels') ;
    scnsize = get(0,'ScreenSize');
    figure('Name','Travel time distribution at a given downstream distance','Color',[1 1 1],...
        'position',[scnsize(3)/2 scnsize(4)/2.6 scnsize(3)/2.1333 scnsize(4)/2]);
    boxplot(t_Dist_X,dX/1000,'orientation','horizontal')
    xlabel('Arrival time [h]','FontName','Arial','FontSize',12);
    ylabel('Distance [Km]','FontName','Arial','FontSize',12);
    set(gca,'TickDir','in','TickLength',[0.021 0.021],'FontName','Arial','FontSize',12)
    %% Eggs in suspension
    Nsusp=t_Dist_X(Z_Dist_X>0.05);
    Nbot=t_Dist_X(Z_Dist_X<0.05);
    %%
    k=round(2*size(X,2)^(1/3));%Number of bins
    edges=0:(time(end)/3600+0.01)/k:time(end)/3600+0.01;
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
    subaxis(1,1,1,'MR',0.062,'ML',0.1,'MB',0.14,'MT',0.22);
    bar1=bar(bids,[Nbot Nsusp]*100/size(X,2),1,'stacked');%,'FaceColor',[0.3804,0.8118,0.8980])
    set(bar1(2),'FaceColor',[0.3804,0.8118,0.8980],'Edgecolor',[0 0 0]);
    set(bar1(1),'FaceColor',[0.6,0.6,0.6],'Edgecolor',[0 0 0]);
    hold on
    ylabel('Percentage of eggs [%]','FontName','Arial','FontSize',12);
    xlabel('Time since spawning [h]','FontName','Arial','FontSize',12);
    set(gca,'TickDir','in','TickLength',[0.021 0.021],'FontName','Arial','FontSize',12)
    ax1=gca;
    %%
    %% Time to hatch
    legend('Near the bottom','In suspension','location','NorthWest');
    TimeToHatch = HatchingTime(Temp,specie);
    %
    ylimits=get(ax1,'YLim');
    N=Nsusp+Nbot;
    if round(TimeToHatch*60*60)<=time(end)
        plot([TimeToHatch TimeToHatch],ylimits,'color','k','LineStyle','--','linewidth',2)
        %% text
        text(double(TimeToHatch*0.995),ylimits(end)*1.02, '\downarrow','FontWeight','normal','FontName','Arial')
        text(double(TimeToHatch),ylimits(end)*1.2, {'Hatching time','at an average',['temperature of ', num2str(round(mean(Temp)*10)/10),' \circC'],['(',num2str(floor(round(TimeToHatch*10))/10),' hours)']},'HorizontalAlignment','center','FontName','Arial')
        %%
        %     id=find(N==max(N));id=id(1);
        %     leadingEdge=0.89*bids(id);
        %     TrailingEdge=leadingEdge+2000000/(3600*1025*bids(id)^-0.887);
        %     plot([leadingEdge leadingEdge],ylimits,'color',[241 29 26]/255,'linewidth',1.3)
        %     plot([TrailingEdge TrailingEdge],ylimits,'color',[0 64 222]/255,'linewidth',1.3)
        %     text(leadingEdge*0.95,ylimits(end)*0.74, {'LE'},'HorizontalAlignment','center','FontName','Arial','rotation',90)
        %     text(TrailingEdge*0.97,ylimits(end)*0.74, {'TE'},'HorizontalAlignment','center','FontName','Arial','rotation',90)
        %     set(leg1,'box','off','color','none')
        %% Eggs at risk of hatching
        %     if max(bids)>=TimeToHatch
        %         TimeIndex=find(bids>=TimeToHatch);TimeIndex=TimeIndex(1);
        %         PercentHatching=sum(Nsusp(TimeIndex:end)*100/sum(N));
        %         plot([TimeToHatch edges(end)],[ylimits(end)*0.8 ylimits(end)*0.8],'color',[208 35 122]/255,'linewidth',1.5)
        %         plot(TimeToHatch,ylimits(end)*0.8,'MarkerFaceColor',[208 35 122]/255,'MarkerEdgeColor',[208 35 122]/255,'Marker','<')
        %         plot(edges(end),ylimits(end)*0.8,'MarkerFaceColor',[208 35 122]/255,'MarkerEdgeColor',[208 35 122]/255,'Marker','>')
        %         plot([edges(end) edges(end)],[0 ylimits(end)*0.8],'color',[128 128 128]/255,'LineStyle',':','linewidth',1)
        %         %text(TimeToHatch+(edges(end)-TimeToHatch)/2,ylimits(end)*0.88, {['Approximately ' num2str(5*round(PercentHatching/5)),'% of eggs are'],' at risk of hatching'},'HorizontalAlignment','center','FontName','Arial')
        %         text(double(TimeToHatch+(edges(end)-TimeToHatch)/2),ylimits(end)*0.88, {['Approximately ' num2str(round((PercentHatching*10)/10)),'% of eggs are'],' at risk of hatching'},'HorizontalAlignment','center','FontName','Arial')
        %
        %     end
    end
    %% Message
    h = msgbox(['At the end of the simulation time ' num2str(sum(N)) ' eggs passed by ' num2str(dX/1000) ' km'],'FluEgg Message');
end
end% travel time


function Longitudinal_distribution_of_eggs_at_time_t()
%Display Sub-GUI-->at what time do you want to display the longitudinal
%distribution of eggs or larvae?
ed = Longitudinal_Dist_Eggs();
uiwait(ed);

%% Load data from Results Gui
[X,Z,Y,CumlDistance,Depth,time,Width]=load_data; %TG 05/15
%If user does not press the continue button (if user closes gui)
continuee=getappdata(handleResults, 'continue'); 
if continuee==0
    return
else
    SetTime=getappdata(handleResults,'SetTime');
end

T2_Gas_bladder=ResultsSim.T2_Gas_bladder;

%% Identify the time at which the user wants to display
if SetTime==T2_Gas_bladder
    %% Distribution of larvae at Gas bladder inflation
    Distribution_GBI;
else     %% Distribution of eggs at hatching time
    
    Distribution_eggs_hatch(SetTime);
    annotation('rectangle',position_axes1,'FaceColor','flat','linewidth',1.5);
end
%%=========================================================================



%% Sub-function-->Distribution of eggs at hatching time
    function Distribution_eggs_hatch(SetTime)
        % gets results data
        handleResults=getappdata(0,'handleResults');
        
        % If error in SetTime input
        if isempty(SetTime)
            return
        end
        
        CalculateEggs_at_risk_hatching=getappdata(handleResults,'CalculateEggs_at_risk_hatching');
        
        %% Where are the eggs when hatching occurs or when time equal to t?
        TimeIndex=find(time<=SetTime*3600,1,'last');
        X_at_Time(:,1)=X(TimeIndex,:);%or at a given t
        Z_at_Time(:,1)=Z(TimeIndex,:);
        Y_at_Time(:,1)=Y(TimeIndex,:);%TG 05/15
        %%
        Cell=zeros(size(X_at_Time));
        h=zeros(size(X_at_Time));
        %Calculate locale hydraulic conditions experienced by every egg
        for e=1:size(X_at_Time,1)
            if X_at_Time(e)>CumlDistance(end)*1000 % If the eggs are in the last cell
                Cell(e)=length(CumlDistance);
            else
                Cell(e)=find(X_at_Time(e)<CumlDistance*1000,1,'first');
            end
            h(e)=Depth(Cell(e)); %m
            w(e)=Width(Cell(e)); %m %TG 05/15
        end
        Z_at_Time_H=(Z_at_Time+h)./h;
        n=Y_at_Time-w'/2;
        X_at_Time=X_at_Time/1000; %In Km
        
        %% Define eggs in suspension and settled
        Nsusp=X_at_Time(Z_at_Time_H>0.05);
        Nbot=X_at_Time(Z_at_Time_H<=0.05);
        %%
        k=round(size(X_at_Time,1)^(1/3));%Number of bins %2*size
        %% look for rice rule-->k=2n^1/3-->https://en.wikipedia.org/wiki/Histogram
        ds=round(100*((max(max(X_at_Time))-min(min(X_at_Time)))+0.001)/k)/100;
        edges=0:ds:CumlDistance(end)+0.001;
        %edges=0:(CumlDistance(end)+0.01)/k:CumlDistance(end)+0.01;
        bids=(edges(1:end-1)+edges(2:end))/2;bids=bids';
        %%
        Nbot=histc(Nbot,edges);Nbot=Nbot(1:end-1);%here we dont include numbers greater than the max edge
        try
            Nsusp=histc(Nsusp,edges);Nsusp=Nsusp(1:end-1);%here we dont include numbers greater than the max edge
            if isempty(Nsusp)
                Nsusp=Nbot*0;
            end
        catch
            errordlg('Error','Error');
        end
        %% Plot
        set(0,'Units','pixels') ;
        scnsize = get(0,'ScreenSize');
        %h=figure('Name','Longitudinal distribution of the eggs at a given time','Color',[1 1 1],...
            %'position',[scnsize(3)/2 scnsize(4)/2.6 scnsize(3)/2.1333 scnsize(4)/2]);
            h=figure('Name','Longitudinal distribution of the eggs at a given time','Color',[1 1 1],...
            'position',[scnsize(3)/2 scnsize(4)/2.6 scnsize(3)/2.1333 scnsize(4)/2]);
        subaxis(1,1,1,'MR',0.1,'ML',0.095,'MB',0.12,'MT',0.05);
        %%
        cdf_Nsusp=cumsum(Nsusp*100/size(X_at_Time,1));
        percentage_of_Eggs=[Nbot Nsusp]*100/size(X_at_Time,1);
        bar1=bar(bids,percentage_of_Eggs,1,'stacked');
        set(bar1(2),'FaceColor',[0.3804,0.8118,0.8980]);
        set(bar1(1),'FaceColor',[0.6,0.6,0.6]);
        %--Cust0mize plot -----------------------------------------------------
        position_axes1= get(gca,'position');
               %[Convert_km_to_miles,xlabel_text,StringStats]=setupUnits(X_at_Time(Z_at_Time_H>0.05));%Calculate stats for eggs in susp.
        [Convert_km_to_miles,xlabel_text,StringStats]=setupUnits(X_at_Time);
        xStep=round((Convert_km_to_miles*(k*ds+max(max(X_at_Time)))/4)/10)*10;%in miles
        %xaxisticks=[0:ceil(xStep/10)*10:5*ceil(xStep/10)*10];
        %xlim([0 xaxisticks(end)/Convert_km_to_miles]) %Xaxis limit
        xlim([fix(0.9*min(X_at_Time)/10)*10 round(xStep*5)]./Convert_km_to_miles) %Xaxis limit
        xaxisticks=get(gca,'XTick');
        set(gca,'XTick',xaxisticks/Convert_km_to_miles,'Xticklabel',xaxisticks)
        set(gca,'TickDir','in','TickLength',[0.021 0.021],'XMinorTick','off','FontName','Arial','FontSize',12)
        xlabel(xlabel_text,'FontName','Arial','FontSize',12);
        ylim([0 round(1.2*max([Nsusp+Nbot]*100/size(X_at_Time,1)))])
        ylabel('Percentage of eggs [%]','FontName','Arial','FontSize',12);
        set(gca, 'box','off');set(gca,'YaxisLocation','left');
        xlim_axis1=get(gca,'Xlim');
        legend('Near the bottom','In suspension','location','NorthWest');
        %
        %%
        annotation('textbox',[0.75 0.7 0.1 0.1],...
            'String',StringStats,'FontName','Arial','FontSize',10);
     
        %%
        if CalculateEggs_at_risk_hatching==1
            % Create axes
            axes2 = axes('Parent',h,'YTick',[0:20:100],'YAxisLocation','right',...
                'Position',position_axes1,...
                'Color','none');
            hold(axes2,'all');
            set(axes2,'Xlim',xlim_axis1);
            set(axes2,'Ylim',[0 100]);
            set(axes2, 'XTick', []);
            % Create plot
            plot(bids(cdf_Nsusp>0),cdf_Nsusp(cdf_Nsusp>0),'Parent',axes2,'LineWidth',2,'Color',[1 0 1]);
            plot(xlim_axis1,[99.999 99.999],'k')
            ylabel(axes2,'Cumulative pct. of eggs in suspension [%]','FontName','Arial','FontSize',12);
            
            %%
            idtext=find(cdf_Nsusp>=max(cdf_Nsusp),1,'first');
            text(double(bids(idtext)*0.88),94, {['Approximately ' num2str(round((cdf_Nsusp(end)*10)/10)),'% of eggs are'],' at risk of hatching'},'HorizontalAlignment','center','FontName','Arial')
            
        end
    end


%% Distribution of larvae at Gas bladder inflation
    function Distribution_GBI
        % Load data
        handleResults=getappdata(0,'handleResults');
        ResultsSim=getappdata(handleResults,'ResultsSim');
        T2_Gas_bladder=ResultsSim.T2_Gas_bladder;
        %         time=ResultsSim.time;
        %         CumlDistance=ResultsSim.CumlDistance;
        alive=ResultsSim.alive;
        %% Where are the eggs when gas bladder inflation occurs?
        TimeIndex=find(time<=T2_Gas_bladder*3600,1,'last');
        X_at_GBI(:,1)=X(TimeIndex,alive(TimeIndex,:)==1)/1000; %In Km   %Location of larvae at GBI
        
        % Number of bins
        k=round(2*size( X_at_GBI,1)^(1/3));%Number of bins %2*size
        ds=round(100*((max(max( X_at_GBI))-min(min( X_at_GBI)))+0.001)/k)/100;
        h = msgbox(['Bin spacing equal to ' num2str(ds) ' km']);
        pause(2)
        try
            close(h)
        end
        edges=0:ds:CumlDistance(end)+0.001;
        bids=(edges(1:end-1)+edges(2:end))/2;bids=bids';
        % Number of eggs in each bin
        N=histc(X_at_GBI,edges);N=N(1:end-1);%here we dont include numbers greater than the max edge
        %% Plot
        %---Settings-------------------------------------------------------
        set(0,'Units','pixels') ;
        scnsize = get(0,'ScreenSize');
        h=figure('Name','Longitudinal distribution of larvae at gas bladder inflation','Color',[1 1 1],...
            'position',[scnsize(3)/2 scnsize(4)/2.6 scnsize(3)/2.1333 scnsize(4)/2]);
        subaxis(1,1,1,'MR',0.1,'ML',0.095,'MB',0.12,'MT',0.05);
        %---------------------------------------------------------------
        percentage_of_Eggs=N*100/size(X_at_GBI,1);
        bar1=bar(bids,percentage_of_Eggs,1);
        %--Cust0mize plot -----------------------------------------------------
        set(bar1,'FaceColor',[1,0,1]);
        [Convert_km_to_miles,xlabel_text,StringStats]=setupUnits(X_at_GBI);
        xStep=round(Convert_km_to_miles*(k*ds+max(max(X_at_GBI)))/4);%in miles
        xaxisticks=[0:round(xStep/10)*10:5*round(xStep/10)*10];
        set(gca,'XTick',xaxisticks/Convert_km_to_miles,'Xticklabel',xaxisticks)
        set(gca,'TickDir','in','TickLength',[0.021 0.021],'XMinorTick','on','FontName','Arial','FontSize',12)
        xlim([0 xaxisticks(end)/Convert_km_to_miles]) %Xaxis limit
        ylabel('Percentage of larvae at GBI stage [%]','FontName','Arial','FontSize',12);
        xlabel(xlabel_text,'FontName','Arial','FontSize',12);
        %%
        annotation('textbox',[0.7 0.7 0.1 0.1],...
            'String',StringStats,'FontName','Arial','FontSize',12);
        
    end
%%

%% Change units
    function [Convert_km_to_miles,xlabel_text,StringStats]=setupUnits(X_at_Time)
        handleResults=getappdata(0,'handleResults');
        Menu=getappdata(handleResults, 'Menu');
        if isempty(Menu)
            %% default
            Menu.english_Units=0;
        end
        if Menu.english_Units
            Convert_km_to_miles=0.621371;
            xlabel_text='Distance [miles]';
            %StringStats={'Stats' ['Mean=',num2str(round(10*Convert_km_to_miles*(nanmean(X_at_Time)-X(1,1)/1000))/10),' miles'],['LE=',num2str(round(10*Convert_km_to_miles*(max(X_at_Time)-X(1,1)/1000))/10),' miles'],['TE=',num2str(round(10*Convert_km_to_miles*(min(X_at_Time)-X(1,1)/1000))/10),' miles']};
            StringStats={'Stats' ['Mean=',num2str(round(10*Convert_km_to_miles*(nanmean(X_at_Time)))/10),' miles'],['LE=',num2str(round(10*Convert_km_to_miles*(max(X_at_Time)))/10),' miles'],['TE=',num2str(round(10*Convert_km_to_miles*(min(X_at_Time)))/10),' miles']};
        else
            Convert_km_to_miles=1;
            xlabel_text='Distance [km]';
            %StringStats={'Stats' ['Mean=',num2str(round(10*nanmean(X_at_Time)-X(1,1)/1000)/10),' km'],['LE=',num2str(round(10*max(X_at_Time)-X(1,1)/1000)/10),' km'],['TE=',num2str(round(10*min(X_at_Time)-X(1,1)/1000)/10),' km']};
             StringStats={'Stats' ['Mean=',num2str(round(10*nanmean(X_at_Time))/10),' km'],['LE=',num2str(round(10*max(X_at_Time))/10),' km'],['TE=',num2str(round(10*min(X_at_Time))/10),' km']};
        end
    end
    function [X,Z,Y,CumlDistance,Depth,time,Width]=load_data %TG 05/15
        handleResults=getappdata(0,'handleResults');
        ResultsSim=getappdata(handleResults,'ResultsSim');
        X=ResultsSim.X;
        Z=ResultsSim.Z;
        Y=ResultsSim.Y; %TG 05/15
        %         Temp=ResultsSim.Temp;
        %         specie=ResultsSim.specie;
        time=ResultsSim.time;
        CumlDistance=ResultsSim.CumlDistance;
        Depth=ResultsSim.Depth;
        Width=ResultsSim.Width; %TG 05/15
    end %load_data
%%
end

function Google_Earth_utility()
google_earth();
end

function button_load_picture(~, eventdata, handles)
Fig_open=imread('browse.png');
set(handles.Browse_button, 'Cdata', Fig_open);
end

% --- Executes on button press in tab_group.
function tab_group_Callback(hObject, eventdata, handles)
% hObject    handle to tab_group (see GCBO)
set(handles.Postprocessing_option,'Value',0)
Tab=get(hObject,'string');
%%
switch Tab
    case 'Vertical'
        set(handles.Postprocessing_option(1),'Visible','on');
        set(handles.Postprocessing_option(2),'Visible','on');
        set(handles.Postprocessing_option(3),'Visible','off');
        set(handles.Postprocessing_option(4),'Visible','off');
        
        set(handles.Postprocessing_option(1),'string','Distribution of eggs over the water column' )
        set(handles.Postprocessing_option(2),'string','Egg vertical concentration distribution' )
        
        set(handles.tab_group,'BackgroundColor',[240 240 240]/250)
        set(handles.tab_group(2),'BackgroundColor',[250 250 250]/250)
        
    case 'Longitudinal'
        set(handles.Postprocessing_option(1),'Visible','on');
        set(handles.Postprocessing_option(2),'Visible','on');
        set(handles.Postprocessing_option(3),'Visible','on');
        set(handles.Postprocessing_option(4),'Visible','off');
        
        set(handles.Postprocessing_option(1),'string','Longitudinal distribution');
        set(handles.Postprocessing_option(2),'string','Vertical position of the centroid of the egg mass');
        set(handles.Postprocessing_option(3),'string','Google Earth utility');
        
        set(handles.tab_group,'BackgroundColor',[240 240 240]/250)
        set(handles.tab_group(1),'BackgroundColor',[250 250 250]/250)
        
    case 'Temporal'
        set(handles.Postprocessing_option(1),'Visible','on');
        set(handles.Postprocessing_option(2),'Visible','off');
        set(handles.Postprocessing_option(3),'Visible','off');
        set(handles.Postprocessing_option(4),'Visible','off');
        
        set(handles.Postprocessing_option(1),'string','Egg travel-time distribution' )
        
        set(handles.tab_group,'BackgroundColor',[240 240 240]/250)
        set(handles.tab_group(3),'BackgroundColor',[250 250 250]/250)
        
    case 'Mixed'
        set(handles.Postprocessing_option(1),'Visible','on');
        set(handles.Postprocessing_option(2),'Visible','on');
        set(handles.Postprocessing_option(3),'Visible','on');
        set(handles.Postprocessing_option(4),'Visible','on');
        
        set(handles.Postprocessing_option(1),'string','Evolution of a mass of Asian carp eggs/larvae' )
        set(handles.Postprocessing_option(2),'string','Summary of temporal and spatial evolution of the egg/larvae mass');
        set(handles.Postprocessing_option(3),'string','3D animation of egg/larvae transport (video)');
        set(handles.Postprocessing_option(4),'string','Calculate the percentage of eggs at a given location, depth, and time');
        
        set(handles.tab_group,'BackgroundColor',[240 240 240]/250)
        set(handles.tab_group(4),'BackgroundColor',[250 250 250]/250)
        
end
handles.currentab=Tab;
guidata(hObject, handles);

end

% --- Executes on button press in Postprocessing_option.
function Postprocessing_option_Callback(hObject, eventdata, handles)
% hObject    handle to Postprocessing_option (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Postprocessing_option
end

% --- Executes on button press in Life_stage_group.
function Life_stage_group_Callback(hObject, eventdata, handles)
% hObject    handle to Life_stage_group (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Life_stage_group
end


% --------------------------------------------------------------------
function Settings_Menu_results_Callback(hObject, eventdata, handles)
% Empty
end

% --------------------------------------------------------------------
function Plots_menu_Callback(hObject, eventdata, handles)
% Empty
end

% --------------------------------------------------------------------
function Units_menu_Callback(hObject, eventdata, handles)
% Empty
end

% --------------------------------------------------------------------
function MenuMetric_Callback(hObject, eventdata, handles)
% Set Units to "metric"

% Get the Application Data:
% -------------------------
handleResults=getappdata(0,'handleResults');
Menu.english_Units= false;

% store selection in handleResults
% ------------------------------
setappdata(handleResults, 'Menu',Menu);

% Update the GUI:
% ---------------
set(handles.MenuMetric, 'Checked','on')
set(handles.MenuEnglish,'Checked','off')
end

% --------------------------------------------------------------------
function MenuEnglish_Callback(hObject, eventdata, handles)
% Set Units to "metric"

% Get the Application Data:
% -------------------------
handleResults=getappdata(0,'handleResults');
Menu.english_Units= true;

% store selection in handleResults
% ------------------------------
setappdata(handleResults, 'Menu',Menu);

% Update the GUI:
% ---------------
set(handles.MenuMetric, 'Checked','off')
set(handles.MenuEnglish,'Checked','on')
end
