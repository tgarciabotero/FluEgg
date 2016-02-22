function varargout = Egg_vertical_concentration(varargin)
% EGG_VERTICAL_CONCENTRATION MATLAB code for Egg_vertical_concentration.fig
%      EGG_VERTICAL_CONCENTRATION, by itself, creates a new EGG_VERTICAL_CONCENTRATION or raises the existing
%      singleton*.
%
%      H = EGG_VERTICAL_CONCENTRATION returns the handle to a new Egg_vertical_concentration or the handle to
%      the existing singleton*.
%
%      EGG_VERTICAL_CONCENTRATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EGG_VERTICAL_CONCENTRATION.M with the given input arguments.
%
%      EGG_VERTICAL_CONCENTRATION('Property','Value',...) creates a new EGG_VERTICAL_CONCENTRATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Egg_vertical_concentration_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Egg_vertical_concentration_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Egg_vertical_concentration

% Last Modified by GUIDE v2.5 02-May-2013 14:46:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Egg_vertical_concentration_OpeningFcn, ...
                   'gui_OutputFcn',  @Egg_vertical_concentration_OutputFcn, ...
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
%% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
function Egg_vertical_concentration_OpeningFcn(hObject, ~, handles, varargin)
axes(handles.bottom); imshow('./icons/asiancarp.png');
axes(handles.logoUofI); imshow('./icons/imark.tif');
axes(handles.logo_usgs); imshow('./icons/logo_usgs.png');
%%
handleResults=getappdata(0,'handleResults'); 
ResultsSim=getappdata(handleResults,'ResultsSim');
CumlDistance=ResultsSim.CumlDistance;
Depth=ResultsSim.Depth;
set(handles.X_editBox,'String',round(CumlDistance(end)/2));
set(handles.Nlayers_editBox,'String',7);
%% From Current Gui
Dist_X=str2double(get(handles.X_editBox,'String'))*1000;% It is in km and then we convert it to m
Nlayers=str2double(get(handles.Nlayers_editBox,'String'));
cell=find((CumlDistance)*1000>=Dist_X);cell=cell(1);
H=Depth(cell);
Nodes=0:-H/(Nlayers):-H;    Nodes=Nodes';
set(handles.LayerNodes_table,'Data',[Nodes (Nodes+H)/H]);%Nodes of the layers in model coordinates
%%
handles.output = hObject;
handles.update=0;
guidata(hObject, handles);

function varargout = Egg_vertical_concentration_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;

function X_editBox_Callback(hObject,eventdata, handles)
handles.eddit=0;
Egg_Vertical_Concentration_Distribution(hObject, eventdata, handles);
function X_editBox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Nlayers_editBox_Callback(hObject, eventdata, handles)
handles.eddit=0;
Egg_Vertical_Concentration_Distribution(hObject, eventdata, handles);
guidata(hObject, handles);
function Nlayers_editBox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ExtraNode_editBox_Callback(hObject, eventdata, handles)
function ExtraNode_editBox_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function AddNode_button_Callback(hObject, eventdata, handles)
handles.eddit=1;
Egg_Vertical_Concentration_Distribution(hObject, eventdata, handles);
guidata(hObject, handles);

function LayerNodes_table_CellEditCallback(hObject, eventdata, handles)
handles.update=1;
Egg_Vertical_Concentration_Distribution(hObject, eventdata, handles);

function Plot_button_Callback(hObject, eventdata, handles)
Plot_Vertical_Distribution(hObject, eventdata, handles)

function Grid_on_checkbox_Callback(hObject, eventdata, handles)

function Egg_Vertical_Concentration_Distribution(hObject, eventdata, handles)
%% This function divides the water depth into layers and gets the Nodes Table
%% From Results Gui
handleResults=getappdata(0,'handleResults'); 
ResultsSim=getappdata(handleResults,'ResultsSim');
CumlDistance=ResultsSim.CumlDistance;
Depth=ResultsSim.Depth;
%% From Current Gui
Dist_X=str2double(get(handles.X_editBox,'String'))*1000;% It is in km and then we convert it to m
if Dist_X>CumlDistance(end)*1000
  ed = errordlg('The longitudinal distance you input is out of the domain','Error');
  set(ed, 'WindowStyle', 'modal');
  uiwait(ed); 
end
Nlayers=str2double(get(handles.Nlayers_editBox,'String'));
cell=find((CumlDistance)*1000>=Dist_X);cell=cell(1);
H=Depth(cell);
%% 
if handles.update==0
    if handles.eddit==1  %if we need to add an extra node
        Nodes=get(handles.LayerNodes_table,'Data');Nodes=Nodes(:,1);
        extra=str2double(get(handles.ExtraNode_editBox,'String'));
        Nodes=[extra; Nodes];
    else
        Nodes=0:-H/(Nlayers):-H;    Nodes=Nodes';
    end
else %handles.update==1 Ïf the table is eddited please update the Nodes
    Nodes=get(handles.LayerNodes_table,'Data');Nodes=Nodes(:,1);
end    
Nodes=sort(Nodes,'ascend');
sortedNodes=sort(Nodes,'descend');
set(handles.LayerNodes_table,'Data',[sortedNodes (sortedNodes+H)/H]);%Nodes of the layers in model coordinates
Nodes=get(handles.LayerNodes_table,'Data');%Nodes=Nodes(:,1);
%save('./results/results.mat','Dist_X','Nodes','-append')

function Plot_Vertical_Distribution(hObject, eventdata, handles)
% This function generates the plot of the vertical concentration
% distribution
%% From Results Gui
handleResults=getappdata(0,'handleResults'); 
ResultsSim=getappdata(handleResults,'ResultsSim');
CumlDistance=ResultsSim.CumlDistance;
Depth=ResultsSim.Depth;
X=ResultsSim.X;
Z=ResultsSim.Z;
%% From Current Gui
Nodes=get(handles.LayerNodes_table,'Data');
Dist_X=str2double(get(handles.X_editBox,'String'))*1000;
cell=find((CumlDistance)*1000>=Dist_X);cell=cell(1);
H=Depth(cell);
%%
c=0;[a b]=size(X);
check=0;%Have all the eggs arrive to distance X???
for i=1:b 
    tind=find(X(:,i)>=Dist_X);
        if length(tind)>=1
            tind=tind(1);
            c=c+1;
            Z_Dist_X(c)=Z(tind,i);
            check=check+1;
        end
end
%%
if check==0
  ed = errordlg('No eggs have arrived downstream distance X, please check the egg vertical distribution closer to the spawning location or run the model for a longer time','Error');
  set(ed, 'WindowStyle', 'modal');
  uiwait(ed); 
else
z_over_H=Nodes;z_over_H=z_over_H(:,2);z_over_H=sort(z_over_H,'ascend');
Nodes=sort(Nodes(:,1),'ascend');
z_o_H_midd=z_over_H(1:end-1)+(diff(z_over_H)/2);%in dimensionless form z/H middle points
hightLayers=[abs(diff(Nodes))];%in m
N=histc(Z_Dist_X,Nodes);N=N(1:end-1)';
Nmatrix=[sort(z_o_H_midd,'ascend') N];
%%
Cy=(N./hightLayers)*100;
Cavg=sum(N)/H;
CyCavg=Cy./Cavg;
Vertdist=[z_o_H_midd CyCavg];
%% Saving results
hFluEggGui=getappdata(0,'hFluEggGui');
outputfile=getappdata(hFluEggGui, 'outputfile');
save(outputfile,'Vertdist','-mat','-append');
%if Batch==0
figure('Color',[1 1 1]);
semilogx(CyCavg,z_o_H_midd,'MarkerFaceColor',[0 0 0],'MarkerSize',5,...
    'Marker','square','LineWidth',2,'LineStyle','--','Color',[0 0 0]);
xlim([1 500])
ylim([0 1])
set(gca,'XTick',[0 10 50 100 500],'XTickLabel',[0 10 50 100 500]);
xlabel('log C_z/C');
ylabel('z/H');
legend('FluEgg simulation','Location','NorthWest')
%% Grid ON-OFF
gridon=get(handles.Grid_on_checkbox,'Value');  %Need to comment this for now
if gridon==1
     grid on
else
     grid off
end
%% Message
h = msgbox([num2str(sum(N)) ' eggs passed by ' num2str(Dist_X/1000) ' km downstream from the virtual spawning location during the simulation time'],'FluEgg Message');
end