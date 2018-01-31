%==============================================================================
% FluEgg -Fluvial Egg Drift Simulator
%==============================================================================
% Copyright (c) 2013-2017 Tatiana Garcia

   % This program is free software: you can redistribute it and/or modify
    % it under the terms of the GNU General Public License version 3 as published by
    % the Free Software Foundation (currently at http://www.gnu.org/licenses/agpl.html) 
    % with a permitted obligation to maintain Appropriate Legal Notices.

    % This program is distributed in the hope that it will be useful,
    % but WITHOUT ANY WARRANTY; without even the implied warranty of
    % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    % GNU General Public License for more details.

    % You should have received a copy of the GNU General Public License
    % along with this program.  If not, see <http://www.gnu.org/licenses/>.

%%%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%            Calculate settling velocity using Dietrich equation         %
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This function is used calculate settling velocity using Dietrich 
% equation %
%-------------------------------------------------------------------------%
%                                                                         %
%-------------------------------------------------------------------------%
%   Created by      : Tatiana Garcia                                      %
%   Last Modified   : May 27, 2016                                        %
%-------------------------------------------------------------------------%
% Reference: Garcia, M. H. (2008). Sedimentation engineering: processes, 
%            measurements, modeling and practice. ASCE Manuals and Reports 
%            on Engineering Practice No. 110.    Page 41                  %
% Inputs:
%        D = egg diameter in mm
%        T = temperature in Celsius degrees
%        SG =egg specific gravity (dimensionless)= density of egg/density
%        of water.
% Outputs:
% Copyright 2016 Tatiana Garcia
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
function [vs] = Dietrich(D,SG,T)
D = D/10; % convert to cm from mm
g = 981; %gravity cm/s^2
viscosity = (1.79e-6*100^2)/(1+(0.03368*T)+(0.00021*(T^2)));%cm^2/s
% constants
b1 = 2.891394;
b2 = 0.95296;
b3 = 0.056835;
b4 = 0.002892;
b5 = 0.000245;
Rep = (D*sqrt((SG-1)*g*D))/viscosity; %Reynolds particle number.
Rf = exp(-b1+(b2*(log(Rep)))-(b3*((log(Rep))^2))...
-(b4*((log(Rep))^3))+(b5*((log(Rep))^4)));
vs = Rf*sqrt((SG-1)*g*D); %Settling velocity in cm/s


