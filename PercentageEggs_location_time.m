function varargout = PercentageEggs_location_time(varargin)
% PERCENTAGEEGGS_LOCATION_TIME MATLAB code for PercentageEggs_location_time.fig
%%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                    Calculate percentage of eggs at a given             %
%%                             location, depth, and time                  %
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% FluEgg tool to calculate percentage of eggs at a given location, depth  %
% and time. This tool is particulary useful for hindcasting spawning      %
% grounds based on eggs collected in the field                            %
%-------------------------------------------------------------------------%
%   Created by      : Tatiana Garcia                                      %
%   Last Modified   : October 24, 2016                                    %
%-------------------------------------------------------------------------%
% Copyright 2016 Tatiana Garcia
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%

% Last Modified by GUIDE v2.5 25-Oct-2016 10:57:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @PercentageEggs_location_time_OpeningFcn, ...
    'gui_OutputFcn',  @PercentageEggs_location_time_OutputFcn, ...
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


function PercentageEggs_location_time_OpeningFcn(hObject, eventdata, handles, varargin)
axes(handles.bottom); imshow('asiancarp.png');
%%=========================================================================
% handleResults=getappdata(0,'handleResults');
% ResultsSim=getappdata(handleResults,'ResultsSim');

handles.output = hObject;
guidata(hObject, handles);
end %function

function varargout = PercentageEggs_location_time_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
end %function

function [Egg_sampling_location_m,eggAge,Sampling_depth_m,SamplingTime_minutes]=load_data_from_GUI(handles)
Egg_sampling_location_m=str2double(get(handles.Egg_sampling_location_m,'String'));
eggAge=str2double(get(handles.eggAge,'String'));
Sampling_depth_m=str2double(get(handles.Sampling_depth_m,'String'));
SamplingTime_minutes=str2double(get(handles.SamplingTime_minutes,'String'));
end


% --- Executes on button press in calculate_percentage_of_eggs_button.
function calculate_percentage_of_eggs_button_Callback(hObject, eventdata, handles)
%The percentage of eggs is calculated based on eggs located before the
%bongonet at the starting sampling time. Number of eggs collected
%corresponds to eggs that crossed the sampling distance withing the
%sampling time

%% Load results
handleResults=getappdata(0,'handleResults');
ResultsSim=getappdata(handleResults,'ResultsSim');
[Egg_sampling_location_m,eggAge,Sampling_depth_m,SamplingTime_minutes]=load_data_from_GUI(handles);
X=ResultsSim.X;
Z=ResultsSim.Z;
time=ResultsSim.time;

 %% Where are all the eggs where when sampling occured?
 TimeIndex_start=find(time<=((eggAge*3600)-(SamplingTime_minutes*60/2)),1,'last');
 TimeIndex_end=find(time>=((eggAge*3600)+(SamplingTime_minutes*60/2)),1,'first');
if isempty(TimeIndex_end)
    ed=errordlg(['You need to do another simulation with at least ',num2str(SamplingTime_minutes/2),' minutes more of simulation time'],'Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
    Exit=1;
    return
end
 X_at_timewindow=X(TimeIndex_start:TimeIndex_end,:);

%  DispersionofEggsat_sampling=max(X_at_sampling)-min(X_at_sampling);
%  Dx_m=round(2*(DispersionofEggsat_sampling^(1/3)))/2;

%find eggs at starting sampling window located before the net in the
%longitudinal direction
EggsBeforeNetAtSampling=find(( X_at_timewindow(1,:)<=Egg_sampling_location_m));
N=0; %Initialize egg counter=0
set(handles.Percentage_eggs,'String',' ')
 for i=1:size(EggsBeforeNetAtSampling,2) %For all eggs located before the net at the begining of the sampling period..
     % Find the time at which eggs crossed the net
     Samplingtimeindex=find(X_at_timewindow(:,EggsBeforeNetAtSampling(i))>=Egg_sampling_location_m,1,'first');
     if Samplingtimeindex>=1 %If egg crossed the net
         %EggIndex(i)=EggsBeforeNetAtSampling(i);
         %% Find the vertical location of the egg
         ZeggAtSampling=Z(TimeIndex_start+Samplingtimeindex,EggsBeforeNetAtSampling(i));
         %% If located where net was, count it
         if ZeggAtSampling>=-Sampling_depth_m
                N=N+1;
         end      
    end
 end
 set(handles.Percentage_eggs,'String', num2str(N*100/size(X,2)))
 ed=errordlg('Done','Check your results');
 set(ed, 'WindowStyle', 'modal');
 uiwait(ed);
end

%If user changes sampling location or egg age
function Egg_sampling_location_m_Callback(hObject, eventdata, handles)
try  % Try first, because if the user had not finished filling up the blcks we might have an error
 calculate_location_accuracy(handles);
catch
end
end



























% 
% function Generateplot_debuggin(handles)
% figure('color','w')
% plot([Egg_sampling_location_m Egg_sampling_location_m],[5600 5900],'r','linewidth',3)
% hold on
% for i=1:size( X_at_sampling,2)
% plot(X_at_timewindow(:,i),[time(TimeIndex_start):time(2)-time(1):time(TimeIndex_end)],'*g')
% hold all
% end
% %find eggs at starting sampling window located before the net
% EggsBeforeNetAtSampling=find(( X_at_timewindow(1,:)<=Egg_sampling_location_m));
% N=0;      
%  for i=1:size(EggsBeforeNetAtSampling,2)
%      Samplingtimeindex=find(X_at_timewindow(:,EggsBeforeNetAtSampling(i))>=Egg_sampling_location_m,1,'first');
%      if Samplingtimeindex>=1
%          EggIndex(i)=EggsBeforeNetAtSampling(i);
%          ZeggAtSampling=Z(TimeIndex_start+Samplingtimeindex,EggsBeforeNetAtSampling(i))
%          if ZeggAtSampling>=-Sampling_depth_m
%                 N=N+1;
%          end
%          plot(X_at_timewindow(:,EggsBeforeNetAtSampling(i)),[time(TimeIndex_start):time(2)-time(1):time(TimeIndex_end)],'*k')
%       
%     end
%  end
% end

