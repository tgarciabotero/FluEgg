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
%   Created by      : Santiago Santacruz & Tatiana                        %
%   Date            : December 20, 2016                                   %
%   Last Modified   : December 20, 2016                                   %
%-------------------------------------------------------------------------%
% Inputs:
% Outputs:
% Copyright 2016 Santiago Santacruz & Tatiana Garcia
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%

function [hydrographs, profiles] = Extract_RAS_TS(strRASProject,handles,RiverStation)

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
%lngPlanID = get(handles.popupPlan,'Value');   % PlanID
lngNodeID = RC.Geometry_GetNode(lngRiverID, lngReachID, RiverStation{1});   % NodeID
%%
% Variables to be extracted
lngQChannelID = 7;    % Flow in the main channel
lngWseID = 2;    % Water Surface Elevation
%% Get data
[nProfiles, profiles] = RC.Output_GetProfiles(0, 0);
QChannel_TS = nan(nProfiles - 1, 1); % Discard MaxWSL profile
WSE = nan(nProfiles - 1, 1); % Discard MaxWSL profile

for i = 1:nProfiles-1 % Profile = 1 is for MaxWSL (to be discarded)
    QChannel_TS(i) = RC.Output_NodeOutput(lngRiverID,...
                                          lngReachID,....
                                           lngNodeID,...
                                                   0,...
                                               i + 1,...
                                       lngQChannelID);
    WSE(i)         = RC.Output_NodeOutput(lngRiverID,...
                                          lngReachID,....
                                           lngNodeID,...
                                                   0,...
                                               i + 1,...
                                            lngWseID);
end
hydrographs = [(1:numel(WSE))', QChannel_TS, WSE];
profiles = {profiles{2:end}}'; %Don't save MaxWS profile
try
    RC.QuitRAS
catch
end
delete(RC);
end
