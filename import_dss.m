%%%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                  Import CSV created with HEC-DSSVue                    %
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This function is used to extract data from a tab-separated file that    %
% with data from a HEC-DSS file
% References:                                                             %
% Goodell, C.R. 2014.                                                     %
% Breaking the HEC-RAS Code: A User's Guide to Automating HEC-RAS. A User's
% Guide to Automating HEC-RAS. h2ls. Portland, OR.                        %
%-------------------------------------------------------------------------%
%                                                                         %
%-------------------------------------------------------------------------%
%   Created by      : Santiago Santacruz & Tatiana                        %
%   Date            : January 20, 2016                                    %
%   Last Modified   : Febrauary 20, 2016                                    %
%-------------------------------------------------------------------------%
% Inputs:
% Outputs:
% Copyright 2017 Santiago Santacruz & Tatiana Garcia
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
function [dss_data] = import_dss(filename)
    fid = fopen(filename);
    check_fid(fid)
    dss_data = {};
    dss_data.parts = textscan(fid, '%s %s', 5);
    dss_data.units = textscan(fid, '%s %s', 1);
    dss_data.type = textscan(fid, '%s %s', 1);
    dss_data.data = textscan(fid, '%s %s %s %f');
    fclose(fid);
end

function check_fid(fid)
    if fid == -1
        ed = warndlg('Your file could not be read','Observed Data');
        set(ed, 'WindowStyle', 'modal');
        uiwait(ed);
    end
end