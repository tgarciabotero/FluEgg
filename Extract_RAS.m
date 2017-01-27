%%%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                       Extract output from HEC-RAS                      %
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This function is used to extract data from a HEC-RAS project and produces %
% References:                                                             %
% Goodell, C.R. 2014.                                                     %
% Breaking the HEC-RAS Code: A User's Guide to Automating HEC-RAS. A User's
% Guide to Automating HEC-RAS. h2ls. Portland, OR.                        %
%-------------------------------------------------------------------------%
%                                                                         %
%-------------------------------------------------------------------------%
%   Created by      : Tatiana Garcia                                      %
%   Date            : March 29, 2016                                      %
%   Last Modified   : April 18, 2016                                      %
%-------------------------------------------------------------------------%
% Inputs:
% Outputs:
% Copyright 2016 Tatiana Garcia
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%

function [Riverinputfile]=Extract_RAS(strRASProject,handles,profile)

%% Creates a COM Server for the HEC-RAS Controller

% The command above depends on the version of HEC-RAS you have, in my case
% I am using version 5.0.3
try
    RC = actxserver('RAS503.HECRASController');
catch
    try %HECRAS 5.0.2
        RC = actxserver('RAS502.HECRASController');
    catch
        try %HECRAS 5.0.1
            RC = actxserver('RAS501.HECRASController');
        catch
            try %HECRAS 5.0.0
                RC = actxserver('RAS500.HECRASController');
            catch
            end %HECRAS 5.0.0
        end %HECRAS 5.0.1
    end%HECRAS 5.0.2
end %HECRAS 5.0.3


%% Open the project
%strRASProject = 'D:\Asian Carp\Asian Carp_USGS_Project\Tributaries data\Sandusky River\SANDUSKY_Hec_RAS_mod\Sandusky_mod_II\BallvilleDam_Updated.prj';
RC.Project_Open(strRASProject); %open and show interface, no need to use RC.ShowRAS in Matlab

%% Define Variables
% get variables from GUI with user selection
lngRiverID = get(handles.popup_River,'Value');   % RiverID
lngReachID = get(handles.popup_Reach,'Value');   % ReachID
%%
if profile==-1
lngProfile = get(handles.popup_HECRAS_profile,'Value')-1;   % Profile Number, 1 is all profiles
else
    %The first profile in HEC-RAS corresponds to MAX WS, then the profile
    % corresponding to initial conditions is:
    lngProfile=profile+1;    
end    

lngUpDn = 0;      % Up/Down index for nodes with multiple sections (only used for bridges)
% Output ID of Variables ( see page 247 in reference book for more details)
% lngWS_ID = 2;                     % The Water Surface Elevation ID is 2.
lngVelChnl_ID = 25;                 % The  ID of the average velocity of flow for the main channel is 23.
lngHydrDepthC_ID = 128;             % Hydraulic depth in channel.
lngQChannel_ID = 7;                 % Flow in the main channel.
lngHydrRadiusC_ID = 210;            % ID for hydraulic radius in channel.
lngMannWtdChnl_ID = 45;             % ID for Conveyance weighted Manning's n for the main channel.
lngLengthChnl_ID = 42;              % ID for Downstream reach length of the main channel to next XS
                                    %(unless BR in d/s, then this is the distance to the deck/roadway).

lngNum_XS = RC.Schematic_XSCount(); %Number of XS - HEC-RAS Controller will populate.

[~,~,lngNum_RS]=RC.Geometry_GetNodes(lngRiverID,lngReachID,0,0,0);%Number of nodes
        
% Preallocate memory
strRS = cell(lngNum_RS,1); %Array of names of the nodes-->River station name.  See page 36 in book
strNodeType = strRS;       %Pre-allocate array for node type

% Preallocate memory for output vectors
%sngWS = nan(lngNum_RS,1);
sngVelChnl = nan(lngNum_XS,1);
sngHydrDepthC = nan(lngNum_XS,1);
sngQChannel = nan(lngNum_XS,1);
sngHydrRadiusC = nan(lngNum_XS,1);
sngMannWtdChnl = nan(lngNum_XS,1);
sngLengthChnl = nan(lngNum_XS,1);

%% Run the current plan
%RC.Compute_CurrentPlan(0,0); %from book: = RC.Compute_CurrentPlan(lngMessages,strMessages(), True)
% RC.Compute_HideComputationWindow; %To hide Computation Window

% Uncoment the lines below for info about current plan and project
% Do not delete, we might need this in the future
%==========================================================================
%Current_Plan= RC.CurrentPlanFile()
%Current_Geometry_File= RC.CurrentGeomFile()
%[lngNumProf,strProfileName]=RC.Output_GetProfiles(0,0) %Profiles names and todatl number

%% Output Results
XC_counter=0;
% Extracts variable info from XS to Xs
for i=1:lngNum_RS
    strNodeType{i}=RC.Geometry.NodeCType(lngRiverID,lngReachID,i);
    
    if strcmp(strNodeType{i},'')% An empty strings (i.e. ' ') denotes a cross section;
            XC_counter=XC_counter+1;
        % Here we assing the river station name to each node
        strRS{XC_counter} = RC.Geometry.NodeRS(lngRiverID,lngReachID,i);
        % Extracts average velocity of flow for the main channel
        sngVelChnl(XC_counter) = abs(RC.Output_NodeOutput(lngRiverID,lngReachID,i,lngUpDn,...
            lngProfile,lngVelChnl_ID));
        % Extracts hydraulic depth in channel
        sngHydrDepthC(XC_counter) = RC.Output_NodeOutput(lngRiverID,lngReachID,i,lngUpDn,...
            lngProfile,lngHydrDepthC_ID);
        % Extracts flow in the main channel.
        sngQChannel(XC_counter) = RC.Output_NodeOutput(lngRiverID,lngReachID,i,lngUpDn,...
            lngProfile,lngQChannel_ID);
        % Extracts hydraulic radius in channel.
        sngHydrRadiusC(XC_counter) = RC.Output_NodeOutput(lngRiverID,lngReachID,i,lngUpDn,...
            lngProfile,lngHydrRadiusC_ID);
        % Extracts conveyance weighted Manning's n for the main channel.
        sngMannWtdChnl(XC_counter) = RC.Output_NodeOutput(lngRiverID,lngReachID,i,lngUpDn,...
            lngProfile,lngMannWtdChnl_ID);
        % Extracts conveyance weighted Manning's n for the main channel.
        sngLengthChnl(XC_counter) = RC.Output_NodeOutput(lngRiverID,lngReachID,i,lngUpDn,...
            lngProfile,lngLengthChnl_ID);       
        % Extracts Water Surface Elevation at each XS
        %sngWS(i) = RC.Output_NodeOutput(lngRiverID,lngReachID,i,lngUpDn,...
        %           lngProfile,lngWS_ID);       
    end%if is a cross section
    
end %for
sngLengthChnl(end)=0; %There is not data of length channel for the last cell

%% Generate Rivirinputfile dataset for the FluEgg model
Riverinputfile=Generate_Rivirinputfile();

try
    %Kill Hec-ras 
    !taskkill /im ras.exe
    RC.QuitRAS
    
catch
end
delete(RC);



%% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    function Riverinputfile=Generate_Rivirinputfile()
        CumlDistance=[0;cumsum(sngLengthChnl(1:end-1))/1000];%In km
        CumlDistance=[((CumlDistance(1:end-1)+CumlDistance(2:end))/2); CumlDistance(end)]; %FluEgg cells are located between 2 XS
        CellNumber=(1:1:lngNum_XS)';
        ks=(8.1.*sngMannWtdChnl.*sqrt(9.81)).^6;
        Ustar=abs(sngVelChnl./(8.1*((sngHydrRadiusC./ks).^(1/6))));
        %% Temperature choice
        Temperature=str2double(get(handles.Const_Temp(2),'String'));
        if isnan(Temperature) %If user didn't input temperature
            ed = errordlg('Please input temperature','Error');
            set(ed, 'WindowStyle', 'modal');
            uiwait(ed);
            return
        end
        Riverinputfile=[CellNumber CumlDistance sngHydrDepthC sngQChannel...
                        sngVelChnl zeros(lngNum_XS,1) zeros(lngNum_XS,1) Ustar ...
                        Temperature*ones(lngNum_XS,1)]; % default temperature 22C
    end
%% :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

end
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%

%% Notes:
% When there is not data the controller puts a very large number: 3.39999995214436e+38