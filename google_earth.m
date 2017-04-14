function varargout = google_earth(varargin)
% GOOGLE_EARTH MATLAB code for google_earth.fig
%      GOOGLE_EARTH, by itself, creates a new GOOGLE_EARTH or raises the existing
%      singleton*.
%
%      H = GOOGLE_EARTH returns the handle to a new GOOGLE_EARTH or the handle to
%      the existing singleton*.
%
%      GOOGLE_EARTH('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GOOGLE_EARTH.M with the given input arguments.
%
%      GOOGLE_EARTH('Property','Value',...) creates a new GOOGLE_EARTH or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before google_earth_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to google_earth_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help google_earth

% Last Modified by GUIDE v2.5 30-Jun-2016 09:43:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @google_earth_OpeningFcn, ...
    'gui_OutputFcn',  @google_earth_OutputFcn, ...
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
end %function
% End initialization code - DO NOT EDIT


function google_earth_OpeningFcn(hObject, eventdata, handles, varargin)
axes(handles.bottom); imshow('asiancarp.png');
%%=========================================================================
handleResults=getappdata(0,'handleResults');
ResultsSim=getappdata(handleResults,'ResultsSim');
if isfield(ResultsSim, 'T2_Gas_bladder')==0%This is for results files from previous FluEgg versions
    T2_Gas_bladder=0;
else
    T2_Gas_bladder=ResultsSim.T2_Gas_bladder;
end
Menu_labels={'Egg location at hatching time and at gass bladder inflation stage';'Longitudinal distribution of eggs at hatching time and at gass bladder inflation stage'};
if T2_Gas_bladder>0
    set(handles.FluEgg_results_menu,'String',Menu_labels);
end
%%=========================================================================
handles.output = hObject;
guidata(hObject, handles);
end %function

function varargout = google_earth_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
end %function

%% LOAD KML FILE

function Load_kml_file_button_Callback(hObject, eventdata, handles)
[FileName,PathName]=uigetfile({'*.kml', 'kml file (*.kml)'},'Select file to import');
handles.inputfile=fullfile(PathName,FileName);
if PathName==0 %if the user pressed cancelled, then we exit this callback
    return
else
    if FileName~=0
        set(handles.kml_file_path,'string',fullfile(FileName));
    end
end
guidata(hObject, handles);
end %function

function kml_file_path_Callback(hObject, eventdata, handles)
end %function
%%
function kml_file_path_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end %function

function L_Callback(hObject, eventdata, handles)
end %function

function L_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end %function

function FluEgg_results_menu_Callback(hObject, eventdata, handles)
end %function

function FluEgg_results_menu_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end %function


function outputfilename_Callback(hObject, eventdata, handles)
end %function

function outputfilename_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end %function


function ds_Callback(hObject, eventdata, handles)
end %function

function ds_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end %function

function create_regular_grid_centerline_button_Callback(hObject,eventdata,handles)
% Read the input KML file to a MapStruct
if isfield(handles, 'inputfile')==0%This is for results files from previous FluEgg versions
    ed = errordlg('Please load river centerline','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
    return
else
    indata = kml2struct(handles.inputfile);
    %% Message for the user
    Message= msgbox('Please wait','help');
end
% Extract centerline Lat/Lon and convert to UTM
lat = indata.Lat;
lon = indata.Lon;
if get(handles.Flip_centerline,'value')==1
    lat=flipud(lat);
    lon=flipud(lon);
end
[x1,y1,utmzone_in] = deg2utm(lat,lon);
%% Preallocate vectores to storage centerline with constant ds
x=[];y=[];utmzone_out=[];
%% Find if we are in the same utm zone
utmzoneCell=cellstr(utmzone_in);
ChangeInZoneID_in=find(strcmp(utmzoneCell(1:end-1),utmzoneCell(2:end))==0);
if ~isempty(ChangeInZoneID_in) %we have a change in UTM zone
    % Create x,y for each UTM zone
    Init_id=1;
    End_id=ChangeInZoneID_in(1);
    for i=1:length(ChangeInZoneID_in)+1
        if i==length(ChangeInZoneID_in)+1
            Init_id=End_id+1;
            End_id=length(x1);
        end
        [xout,yout]=create_x_y_constant_ds(x1(Init_id:End_id),y1(Init_id:End_id),handles);
        x=[x;xout];
        y=[y;yout];
        utmzone_out=[utmzone_out;repmat(utmzone_in(Init_id,:),length(xout),1)];
        if i<length(ChangeInZoneID_in)
            Init_id=End_id+1;
            End_id=ChangeInZoneID_in(i+1);
        end
    end
else
    [x,y]=create_x_y_constant_ds(x1,y1,handles);
    utmzone_out=repmat(utmzone_in(1,:),length(x),1);
end
[centerline_lat_out,centerline_lon_out] = utm2deg(x,y,utmzone_out);
%%
handleResults=getappdata(0,'handleResults');
pathname=getappdata(handleResults,'pathname');
kmlwritepoint([pathname 'centerline_nodes' '.kml'],centerline_lat_out,centerline_lon_out,'icon','http://maps.google.com/mapfiles/kml/shapes/shaded_dot.png','Color','c','Name',repmat(' ',length(x),1),'Iconscale',0.4)
set(handles.Export_FluEgg_results_panel,'Visible','on');
%%
handles.x=x;
handles.y=y;
handles.utmzone=utmzone_out;
guidata(hObject, handles);% Update handles structure
try
    delete(Message)
catch
end
%%
Message= msgbox('Please verify the centerline with a recular spacing and continue','help');
pause(2.2)
try
    delete(Message)
catch
end
%eval(['!' pathname 'centerline_nodes' '.kml'])
%%
%
%
%%==============
    function [xout,yout]=create_x_y_constant_ds(xin,yin,handles)
        % Fit PCS and create a regular centerline with spacing ~ds
        [pcs_out,~,~]=pcscurvature(xin,yin,str2double(get(handles.ds,'String')));
        xout=pcs_out(:,1);yout=pcs_out(:,2);%curv = pcs_out(:,3); % Reassign x,y, and curvature
    end
end %function

function Create_kml_button_Callback(hObject, eventdata, handles)
%% LOAD DATA FROM RESULTS GUI
handleResults=getappdata(0,'handleResults');
pathname=getappdata(handleResults,'pathname');
ResultsSim=getappdata(handleResults,'ResultsSim');
selected_life_stage=getappdata(handleResults, 'selected_life_stage');

X=ResultsSim.X;Xi=min(min(X));
%T2_Hatching=ResultsSim.T2_Hatching;
if isfield(ResultsSim, 'T2_Gas_bladder')==0%This is for results files from previous FluEgg versions
    T2_Gas_bladder=0;
else
    T2_Gas_bladder=ResultsSim.T2_Gas_bladder;
end
utmzone=handles.utmzone;
x=handles.x;
y=handles.y;
%%
[coordX,coordY] = sn2xy(Xi/str2double(get(handles.L,'String')),0,x,y);
%% find UTM zone
distanceToSpawning=sqrt((x-coordX).^2+(y-coordY).^2);
[Lat_susp,Lon_susp]=utm2deg(coordX,coordY,utmzone(distanceToSpawning==min(distanceToSpawning),:));
Spawning_Location=[Lat_susp Lon_susp];
%%

%% Convert s and n to x and y
%[X_at_hatching,Xsusp,Xbot,CumlDistance]=eggs_at_hatching();
% Determine the selected data set.
str=get(handles.FluEgg_results_menu, 'String');
val=get(handles.FluEgg_results_menu,'Value');
% Set current data to the selected data set.
if isfield(ResultsSim, 'T2_Gas_bladder')==0%This is for results files from previous FluEgg versions
    T2_Gas_bladder=0;
else
    T2_Gas_bladder=ResultsSim.T2_Gas_bladder;
end

switch val;
    %% ========================================================================
    case 1 %'Egg location
        if T2_Gas_bladder==0 %if larvae mode is disable
            eggs_at_hatching(handles,Spawning_Location)
        else
            eggs_at_hatching(handles,Spawning_Location)
            eggs_at_Gas_Bladder(handles,Spawning_Location)
        end
        %% ========================================================================
    case 2 %Longitudinal distribution of eggs or larvae
        %%
        prompt={'Please specify bin size in m', 'Enter the scale factor for the display of the distribution'};
        title_text='Bin size and scale factor';
        numlines=1;
        defaultanswer = {'100','100'};
        ans1 = inputdlg(prompt,title_text,numlines,defaultanswer);
        bin=str2num(ans1{1});  scale_factor=str2num(ans1{2});
        %%
        if T2_Gas_bladder==0 %if larvae mode is disable
            Distribution_at_hatching(handles,Spawning_Location,bin,scale_factor)
        else
            Distribution_at_hatching(handles,Spawning_Location,bin,scale_factor)
            Distribution_at_Gas_Bladder(handles,Spawning_Location,bin,scale_factor)
        end
        %%
end
%%
ed = msgbox('A kml file has been created, please check the results folder','FluEgg message');
set(ed, 'WindowStyle', 'modal');
uiwait(ed);
end %function


function eggs_at_hatching(handles,Spawning_Location)
%% Load data
handleResults=getappdata(0,'handleResults');
ResultsSim=getappdata(handleResults,'ResultsSim');
X=ResultsSim.X;
Z=ResultsSim.Z;
CumlDistance=ResultsSim.CumlDistance;
Depth=ResultsSim.Depth;
x=handles.x;
y=handles.y;
utmzone=handles.utmzone;
pathname=getappdata(handleResults,'pathname');
%specie=ResultsSim.specie;
%Temp=ResultsSim.Temp;
time=ResultsSim.time;
%T2_Hatching=ResultsSim.T2_Hatching;
if isfield(ResultsSim, 'T2_Hatching')==0%This is for results files from previous FluEgg versions
    Temp=ResultsSim.Temp;
    Initial_Cell=find(CumlDistance*1000>=X(1),1,'first'); % Updated TG Jan 2016
    specie=ResultsSim.specie;
    T2_Hatching = HatchingTime(Temp(Initial_Cell:end),specie);
else
    T2_Hatching=ResultsSim.T2_Hatching;
end
%=========================================
% if isfield(ResultsSim, 'T2_Gas_bladder')==0%This is for results files from previous FluEgg versions
%     T2_Gas_bladder=0;
% else
% T2_Gas_bladder=ResultsSim.T2_Gas_bladder;
% end

%% Eggs in suspension =====================================================================================

%% Where are the eggs when hatching occurs?
TimeIndex=find(time>=round(T2_Hatching*3600));TimeIndex=TimeIndex(1);
X_at_hatching(:,1)=X(TimeIndex,:);%in m
Z_at_hatching(:,1)=Z(TimeIndex,:);
%% Find the cell where every egg is and determine if is in suspension or settle
Cell=zeros(size(X_at_hatching));
h=zeros(size(X_at_hatching));
for e=1:size(X_at_hatching,1)
    if X_at_hatching(e)>CumlDistance(end)*1000 % If the eggs are in the last cell
        Cell(e)=length(CumlDistance);
    else
        C=find(X_at_hatching(e)<CumlDistance*1000);Cell(e)=C(1);
    end
    h(e)=Depth(Cell(e)); %m
end
Z_at_hatching_H=(Z_at_hatching+h)./h;
%X_at_hatching=X_at_hatching; %In m
%% Define eggs in suspension and settled
Xsusp=X_at_hatching(Z_at_hatching_H>0.05);
Xbot=X_at_hatching(Z_at_hatching_H<0.05);
%% ========================================================================================================

if length(Xsusp)>5000
    Xsusp=[min(Xsusp); downsample(Xsusp,round(length(Xsusp)/5000)); max(Xsusp)];
    %%
    ed = msgbox(['The number of eggs in suspension is too large, the egg location has been downsample by ' num2str(round(length(Xsusp)/5000)) ' and the minimum and maximum egg location has been preserved'],'FluEgg message');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
end
s=Xsusp/str2double(get(handles.L,'String'));
%%
% [coordX,coordY] = sn2xy(s,zeros(length(s),1),x,y);
% utmzone_out=UTMVector_Out(utmzone,coordX,coordY,x,y);
[coordX,coordY,utmzone_out]=UTMVector_Out(utmzone,x,y,s,str2double(get(handles.L,'String')));
[Lat_susp,Lon_susp]  = utm2deg(coordX,coordY,utmzone_out);
%% Eggs near the bottom
if length(Xbot)>5000
    Xbot=[min(Xbot); downsample(Xbot,round(length(Xbot)/5000)); max(Xbot)];
    %%
    ed = msgbox(['The number of eggs near the bottom is too large, the egg location has been downsample by ' num2str(round(length(Xbot)/5000)) ' and the minimum and maximum egg location has been preserved'],'FluEgg message');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
end
s=Xbot/str2double(get(handles.L,'String'));
[coordX,coordY,utmzone_out]=UTMVector_Out(utmzone,x,y,s,str2double(get(handles.L,'String')));
[Lat_bot,Lon_bot]  = utm2deg(coordX,coordY,utmzone_out);
%%
%kmlwritepoint([pathname get(handles.outputfilename,'String') '.kml'],lat_out,lon_out,'icon','http://maps.google.com/mapfiles/kml/shapes/shaded_dot.png','Color','y','Name',repmat(' ',length(s),1),'Iconscale',0.4)
GEplot_3D([pathname get(handles.outputfilename,'String') ' at hatching'],Lat_susp,Lon_susp,zeros(length(Lat_susp),1),'oy',Lat_bot,Lon_bot,zeros(length(Lat_bot),1),'om',[],Spawning_Location,[],'MarkerSize',0.4);
end

function eggs_at_Gas_Bladder(handles,Spawning_Location)
%% Load data
handleResults=getappdata(0,'handleResults');
ResultsSim=getappdata(handleResults,'ResultsSim');
X=ResultsSim.X;
alive=ResultsSim.alive;
time=ResultsSim.time;
%T2_Hatching=ResultsSim.T2_Hatching;
T2_Gas_bladder=ResultsSim. T2_Gas_bladder;
%CumlDistance=ResultsSim.CumlDistance;
x=handles.x;
y=handles.y;
utmzone=handles.utmzone;
pathname=getappdata(handleResults,'pathname');

%% Where are the eggs when they reach Gas Bladder stage?
TimeIndex=find(time>=round(T2_Gas_bladder-(time(2)-time(1))*3600),1,'last');TimeIndex=TimeIndex(1);
X_at_Gas_Bladder(:,1)=X(TimeIndex,alive(TimeIndex,:)==1);%in m
s=X_at_Gas_Bladder/str2double(get(handles.L,'String'));
[coordX,coordY,utmzone_out]=UTMVector_Out(utmzone,x,y,s,str2double(get(handles.L,'String')));
[Lat,Lon] =utm2deg(coordX,coordY,utmzone_out);
%%
%kmlwritepoint([pathname get(handles.outputfilename,'String') '.kml'],lat_out,lon_out,'icon','http://maps.google.com/mapfiles/kml/shapes/shaded_dot.png','Color','y','Name',repmat(' ',length(s),1),'Iconscale',0.4)
GEplot_3D([pathname get(handles.outputfilename,'String') '_Gas_bladder_larvae'],Lat,Lon,zeros(length(Lat),1),'oc',[],[],[],'om',[],Spawning_Location,[],'MarkerSize',0.4);
end

function Distribution_at_hatching(handles,Spawning_Location,bin,scale_factor)
%% Load data
handleResults=getappdata(0,'handleResults');
ResultsSim=getappdata(handleResults,'ResultsSim');
CumlDistance=ResultsSim.CumlDistance;
Depth=ResultsSim.Depth;
X=ResultsSim.X;
Z=ResultsSim.Z;
%alive=ResultsSim.alive;
time=ResultsSim.time;
%T2_Hatching=ResultsSim.T2_Hatching;
if isfield(ResultsSim, 'T2_Hatching')==0%This is for results files from previous FluEgg versions
    Temp=ResultsSim.Temp;
    Initial_Cell=find(CumlDistance*1000>=X(1),1,'first'); % Updated TG Jan 2016
    specie=ResultsSim.specie;
    T2_Hatching = HatchingTime(Temp(Initial_Cell:end),specie);
else
    T2_Hatching=ResultsSim.T2_Hatching;
end
%=========================================
%T2_Gas_bladder=ResultsSim. T2_Gas_bladder;%h
x=handles.x;
y=handles.y;
utmzone=handles.utmzone;
pathname=getappdata(handleResults,'pathname');
%% Longitudinal distribution of eggs
edges=0:bin:(CumlDistance(end)+0.01)*1000;
bids=(edges(1:end-1)+edges(2:end))/2;bids=bids';
%%==========================================================================================================

%% Where are the eggs when hatching occurs?
TimeIndex=find(time>=round(T2_Hatching*3600));TimeIndex=TimeIndex(1);
X_at_hatching(:,1)=X(TimeIndex,:);%in m
Z_at_hatching(:,1)=Z(TimeIndex,:);
%% Find the cell where every egg is and determine if is in suspension or settle
Cell=zeros(size(X_at_hatching));
h=zeros(size(X_at_hatching));
for e=1:size(X_at_hatching,1)
    if X_at_hatching(e)>CumlDistance(end)*1000 % If the eggs are in the last cell
        Cell(e)=length(CumlDistance);
    else
        C=find(X_at_hatching(e)<CumlDistance*1000);Cell(e)=C(1);
    end
    h(e)=Depth(Cell(e)); %m
end
Z_at_hatching_H=(Z_at_hatching+h)./h;
%X_at_hatching=X_at_hatching; %In m
%% Define eggs in suspension and settled
Xsusp=X_at_hatching(Z_at_hatching_H>0.05);
Xbot=X_at_hatching(Z_at_hatching_H<=0.05);
%% ========================================================================================================

%% Eggs in suspension
Nsusp=histc(Xsusp,edges);Nsusp=Nsusp(1:end-1);%here we dont include numbers greater than the max edge
id=find(bids>=min(Xsusp));id=id(1)-1;
id_end=find(bids>=max(Xsusp));id_end=id_end(1);
s=bids(id:id_end)/str2double(get(handles.L,'String'));
[coordX,coordY,utmzone_out]=UTMVector_Out(utmzone,x,y,s,str2double(get(handles.L,'String')));
[Lat_susp,Lon_susp] = utm2deg(coordX,coordY,utmzone_out);
Nsusp=Nsusp(id:id_end)*100/size(X_at_hatching,1);
%% Near the bottom
Nbot=histc(Xbot,edges);Nbot=Nbot(1:end-1);%here we dont include numbers greater than the max edge
id=find(bids>min(Xbot));id=id(1)-1;
id_end=find(bids>=max(Xbot));id_end=id_end(1);
s=bids(id:id_end)/str2double(get(handles.L,'String'));
[coordX,coordY,utmzone_out]=UTMVector_Out(utmzone,x,y,s,str2double(get(handles.L,'String')));
[Lat_bot,Lon_bot] = utm2deg(coordX,coordY,utmzone_out);
Nbot=Nbot(id:id_end)*100/size(X_at_hatching,1);
%% Percentage of eggs at risk of hatching
ERH=sum(Nsusp);
%% Generating the GEplot_3D
GEplot_3D([pathname get(handles.outputfilename,'String') ' distribution at hatching time'],Lat_susp,Lon_susp,Nsusp*scale_factor,'-g',Lat_bot,Lon_bot,Nbot*scale_factor,'-y',ERH,Spawning_Location,0,'LineWidth',3);
%% ========================================================================================================

end

function [coordX,coordY,utmzone_out]=UTMVector_Out(utmzone,x,y,s,L);
%% Preallocate vectores to storage centerline with constant ds
coordX=[];coordY=[];utmzone_out=[];

%% Find if we are in the same utm zone
utmzoneCell=cellstr(utmzone);
ChangeInZoneID_in=find(strcmp(utmzoneCell(1:end-1),utmzoneCell(2:end))==0);
Distance_s_ToChangeZone=sqrt((x(1:ChangeInZoneID_in-1)-x(2:ChangeInZoneID_in)).^2+(y(1:ChangeInZoneID_in-1)-y(2:ChangeInZoneID_in)).^2);
Distance_s_ToChangeZone=sum(Distance_s_ToChangeZone)/L;

%% Convert sn to xy and then to lat long

if ~isempty(ChangeInZoneID_in) %we have a change in UTM zone
    %% Assume 2 changing zones
    if max(s)>Distance_s_ToChangeZone %if eggs passed the changing zone
        % Create x,y for each UTM zone
        Init_id=1; 
        Init_id_s=1;
        End_id=ChangeInZoneID_in(1);
        End_id_s=find(s>Distance_s_ToChangeZone,1,'first');
        for i=1:length(ChangeInZoneID_in)+1
            if i==length(ChangeInZoneID_in)+1
                Init_id=End_id+1;
                End_id=length(x);
                Init_id_s= End_id_s+1;
                End_id_s=length(s);
            end
            [coordX_out,coordY_out] = sn2xy(s(Init_id_s: End_id_s),zeros(length(s( Init_id_s: End_id_s)),1),x(Init_id:End_id),y(Init_id:End_id));
            coordX=[coordX;coordX_out];
            coordY=[coordY;coordY_out];
            utmzone_out=[utmzone_out;repmat(utmzone(Init_id,:),length(coordX_out),1)];
            if i<length(ChangeInZoneID_in)
                Init_id=End_id+1;
                End_id=ChangeInZoneID_in(i+1);
            end
        end %for
    else
        [coordX,coordY] = sn2xy(s,zeros(length(s),1),x(1:ChangeInZoneID_in(1)),y(1:ChangeInZoneID_in(1)));
        utmzone_out=repmat(utmzone(1,:),length(coordX),1);
    end
else %If there are not change in zones
    [coordX,coordY] = sn2xy(s,zeros(length(s),1),x,y);
    utmzone_out=repmat(utmzone(1,:),length(coordX),1);
end  % End if there are changing zones

% utmzone_out=[];
% utmzoneCell=cellstr(utmzone);
% ChangeInZoneID_in=find(strcmp(utmzoneCell(1:end-1),utmzoneCell(2:end))==0);
% if ~isempty(ChangeInZoneID_in) %we have a change in UTM zone
%     % Create utmzone_out for changing UTM zones
%     Init_id=1;
%     for i=1:length(ChangeInZoneID_in)+1
%         %Find whether the X and Y coordinates are within a zone of changing
%         %UTM
%         if i<length(ChangeInZoneID_in)+1
%             distanceToChangeInZone=sqrt((x(ChangeInZoneID_in)-coordX).^2+(y(ChangeInZoneID_in)-coordY).^2);
%         end
%         if min(distanceToChangeInZone)<max(diff(x)./diff(y))
%             if i==length(ChangeInZoneID_in)+1
%                 End_id=length(coordX);
%             else
%                 End_id=find(distanceToChangeInZone==min(distanceToChangeInZone));
%
%             end
%             if i==1
%             utmzone_out=[utmzone_out;repmat(utmzone(1,:),End_id-Init_id+1,1)];
%             else
%                 utmzone_out=[utmzone_out;repmat(utmzone(ChangeInZoneID_in(i-1)+1,:),End_id-Init_id+1,1)];
%             end
%             Init_id=End_id+1;
%         else
%             utmzone_out=repmat(utmzoneCell(1,:),length(coordX),1);
%         end
%     end
% end
% utmzone_out=char(utmzone_out);

end%UTMVector_Out function
function  Distribution_at_Gas_Bladder(handles,Spawning_Location,bin,scale_factor)
%% Load data
handleResults=getappdata(0,'handleResults');
ResultsSim=getappdata(handleResults,'ResultsSim');
CumlDistance=ResultsSim.CumlDistance;
X=ResultsSim.X;
alive=ResultsSim.alive;
T2_Gas_bladder=ResultsSim. T2_Gas_bladder;%h
x=handles.x;
y=handles.y;
utmzone=handles.utmzone;
pathname=getappdata(handleResults,'pathname');
%% Longitudinal distribution of eggs
edges=0:bin:(CumlDistance(end)+0.01)*1000;
bids=(edges(1:end-1)+edges(2:end))/2;bids=bids';
%%==========================================================================================================

Gass_bladder_Larvae=histc(X(end,alive(end,:)==1),edges);Gass_bladder_Larvae=Gass_bladder_Larvae(1:end-1);%here we dont include numbers greater than the max edge
id=find(bids>min(X(end,alive(end,:)==1)),1,'first');
id_end=find(bids>=max(X(end,alive(end,:)==1)));id_end=id_end(1)-1;
s=bids(id:id_end)/str2double(get(handles.L,'String'));
[coordX,coordY,utmzone_out]=UTMVector_Out(utmzone,x,y,s,str2double(get(handles.L,'String')));
[Lat_Larvae,Lon_larvae] = utm2deg(coordX,coordY,utmzone_out);
Gass_bladder_Larvae=Gass_bladder_Larvae(id:id_end)*100/size(X(end,alive(end,:)==1),2);
%% Generating the GEplot_3D
GEplot_3D([pathname get(handles.outputfilename,'String') ' distribution of larvae at gas bladder inflation stage'],Lat_Larvae,Lon_larvae,Gass_bladder_Larvae*scale_factor,'-m',[],[],[],'-c',[],Spawning_Location,T2_Gas_bladder,'LineWidth',3);


end%Function


% --- Executes on button press in Flip_centerline.
function Flip_centerline_Callback(hObject, eventdata, handles)

end
