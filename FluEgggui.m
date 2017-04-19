%% FluEgg main function: FluEgggui.m
%%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                       MAIN FUNCTION                                    %
%                                                                         %
%%             FLUVIAL EGG DRIFT SIMULATOR (FluEgg)                       %
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
% =========================================================================
% ------------------------------------------------------------------------%
% This is the main function of the FluEgg model, this function gets input %
% data, sets the virtual spawning event, performs egg movement and        %
% generates results.                                                      %
% ------------------------------------------------------------------------%
%                                                                         %
% ------------------------------------------------------------------------%
%   Created by      : Tatiana Garcia                                      %
%   Last Modified   : July 29, 2016                                        %
% ------------------------------------------------------------------------%
%                                                                         %
% Copyright 2016 Tatiana Garcia                                           %
% ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
% With nested functions and single precision and uint8 data types         %
%
% The mortality model is under development, there are a lot of lines making
% refference to alive or dead eggs, everything works as this module was   %
% already implemented. TG                                                 %

function [minDt,CheckDt,Exit]=FluEgggui(~, ~,handles,CheckDt)

%% Are we doing inverse modeling? TG
Inv_mod_status=get(handles.Inverse_modeling,'Checked');
switch Inv_mod_status
    %======================================================================
    case 'off' %If forward modeling
        Inv_mod=1;
    case 'on' % If inverse modeling is activated
        Inv_mod=-1;
        %% Inverse modeling [TG}
        choice = questdlg('You are about to start an inverse simulation of drifting eggs, are you sure you want to continue?'...
            ,'Warning','Yes','No','Yes');
        switch choice
            case 'Yes'
                %Continue
            case 'No'
                minDt = 0;
                Exit=1;
                h = msgbox('The simulation was terminated by user','Warn');
                pause(4)
                 delete(h)
                return
        end
end

%% Iniciate Waitbar
h = waitbar(0,'Initializing variables...','Name','Eggs drifting...',...
    'CreateCancelBtn',...
    'setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)
if getappdata(h,'canceling')
    delete(h);
    Exit=1;
    return;
end

%% Switch to turn on or off mortality model
%Right now we are assuming eggs don't die
% The mortality model is under development
alivemodel = 1;  %if alivemodel=1 the eggs would not die
Exit = 0; %If we exit the code
% =======================================================================

%% Imports input data

Totaltime = single(handles.userdata.Totaltime*3600);%seconds
%% HECRAS input
try
    
    hFluEggGui = getappdata(0,'hFluEggGui');
    HECRAS_data=getappdata(hFluEggGui,'inputdata');
    HECRAS_time_index=HECRAS_data.HECRASspawiningTimeIndex;%HEC-RAS spawning time index, different from
    %spawning time. It is the same or previous date with hydraulic data.
    
    date=arrayfun(@(x) datenum(x.Date,'ddmmyyyy HHMM'), HECRAS_data.Profiles);
    %Calculate Hydraulic Time step-->From HEC-RAS
    HDt=datestr(date(2)-date(1),'dd HH MM SS');
    HDt=str2double(strsplit(HDt,' '));
    HDt=(HDt(1)*24)+(HDt(2))+(HDt(3)/60)+(HDt(4)/3600);%Hydraulic Time step in hours
    HDt=HDt*3600;%Hydraulic Time step in seconds
    %HECRAS_data.HDt_seconds=HDt;
    
    %HEC-RAS time=0 is the spawning time
    HECRAS_time=0:HDt:Totaltime;
    HECRAS_time_counter=1;
    HECRAS_data.HECRAS_time_sec=HECRAS_time;
    setappdata(hFluEggGui,'inputdata',HECRAS_data)
    
    % Spawning Start Time
    %Spawning date and time in number
    SpawningTime=[get(handles.edit_Starting_Date,'String'),' ',get(handles.edit_Starting_time,'String')];
    SpawningTime=strjoin(SpawningTime);
    SpawningTime=datenum(SpawningTime,'ddmmyyyy HHMM');

    %HEC-RAS date and time when spawning occours:
    HECRAS_StartingTime=date(HECRAS_time_index);%in days
    
   %Time difference between HEC-RAS and FluEgg
   HECRAS_FluEgg_Timediff=(SpawningTime-HECRAS_StartingTime)*24*60*60;%in seconds
   % datestr(HECRAS_StartingTime)-->for debugging
   % datestr(SpawningTime)-->for debugging
catch %if steady state
HECRAS_time_index=1;
end
      
%Cell dependant variables
[CumlDistance,Depth,Q,~,Vlat,Vvert,Ustar,Temp,Width,VX,ks]=Create_Update_Hydraulic_and_QW_Variables(HECRAS_time_index);
% =======================================================================
% Gets input data from main GUI
Eggs = single(handles.userdata.Num_Eggs);%make sure you can take the cubic root of it.(e.g 27,64,125)
Xi = single(handles.userdata.Xi);Yi=single(handles.userdata.Yi);Zi=single(handles.userdata.Zi);%Spawning location in m
% =======================================================================

% Species
if get(handles.Silver,'Value')==1
    specie = {'Silver'};
elseif get(handles.Bighead,'Value')==1
    specie = {'Bighead'};
else
    specie = {'Grass'};
end
% =======================================================================

%% Time
% If Simulation time is greater than time to reach a given stage warn the user!!
% Calculate maximum simulation time.

% Initial cell location
Initial_Cell = find(CumlDistance*1000>=str2double(get(handles.Xi_input,'String')),1,'first'); % Updated TG May,2015

T2_Hatching = HatchingTime(mean(Temp(Initial_Cell:end)),specie);
Larvaemode = handles.userdata.Larvae;

switch Larvaemode %:Updated TG May,2015
    % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    case 'on'
        if strcmp(specie,'Silver')%if specie=='Silver'
            Tmin2 = 13.3;%C
            MeanCTU_Gas_bladder = 1084.59;
            %STD=97.04;
        elseif strcmp(specie,'Bighead')
            Tmin2 = 13.4;%C
            MeanCTU_Gas_bladder = 1161.07;
            %STD = 79.72;
        else %case Grass Carp :
            Tmin2 = 13.3;%C
            MeanCTU_Gas_bladder = 1100.82;
            %STD = 49.853;
        end %MeanCTU species dependent
        % Estimate time to reach GBI
        T2_Gas_bladder = str2double(num2str(round(MeanCTU_Gas_bladder*10/(mean(Temp(Initial_Cell:end))-Tmin2))/10));%h
        handles.userdata.Max_Sim_Time = T2_Gas_bladder; %Max time occours at GBI stage
        
        % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        % Display error if simulation time is greater than time to reach
        % GBI stage
        if handles.userdata.Totaltime>(handles.userdata.Max_Sim_Time+0.000001)
            choice = questdlg('Error, the simulation time overpasses the estimated time to reach gas bladder stage, do you want FluEgg to use the estimated time to reach gas bladder stage as the simulation time?'...
                ,'Simulation time Error','Yes','No','Yes');
            switch choice
                case 'Yes'
                    Totaltime=handles.userdata.Max_Sim_Time;
                    set(handles.Totaltime,'String',handles.userdata.Max_Sim_Time);
                case 'No'
                    minDt=0;
                    delete(h)
                    Exit=1;
                    return
            end
        end
        % ======================================================================
        % Simulate egg phase if larvae mode is off
    case 'off'
        T2_Gas_bladder = 0;
        handles.userdata.Max_Sim_Time = T2_Hatching; %Max time is hatching time
        % ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        % Display error if simulation time is greater than hatching time
        if handles.userdata.Totaltime>(round(handles.userdata.Max_Sim_Time*100)/100)+0.000001
            choice = questdlg('Error, the simulation time overpasses the estimated hatching time, do you want FluEgg to use the hatching time as the simulation time?'...
                ,'Simulation time Error','Yes','No','Yes');
            switch choice
                case 'Yes'
                    Totaltime = handles.userdata.Max_Sim_Time;
                    set(handles.Totaltime,'String',handles.userdata.Max_Sim_Time);
                case 'No'
                    minDt = 0;
                    delete(h)
                    Exit = 1;
                    return
            end
        end
        % ======================================================================
end %If larvaemode on


Dt = single(handles.userdata.Dt); %time step in seconds
minDt = Dt; % initialize the variable
time = single(0:Dt:Totaltime); %generates time array, time is in seconds
t = single(1); %time index
Steps = single(length(time));
% =======================================================================

%% pre-allocate memory and intialization of variables
X = zeros(Steps,Eggs,'single');
Y = zeros(Steps,Eggs,'single');
Z = zeros(Steps,Eggs,'single');
cell = zeros(Eggs,1,'single');
Vx = zeros(Eggs,1,'single');
Vy = Vx;
Egg_Direction= Vx;
Vz = Vx;
H = Vx;
W = Vx;
DH = Vx;
ustar = Vx;
SG = Vx;
T = Vx;%Egg dependante Temperature
Vswim = Vx;
X(1,:)= Xi;
Y(1,:)= Yi;
Z(1,:) = Zi;
KS = Vx;
Rhoe = Vx;
alive = ones(Steps,Eggs,'single');
%% Delete or comment, this is for debug
%H_unsteady=ones(Steps,Eggs,'single');
%% In case of mortality model active ======================================
if alivemodel==0
    %Check int 8 for this case
    Dead_t = cell;
    touch = zeros(Steps,Eggs,'int8');%counter to calculate how many eggs touched the bottom every time step
    celldead = zeros(Eggs,1,'int8');
    count_mortality_at_hatching = 0;
end

% ========================================================================

%% Eggs biological properties
waitbar(0,h,['Please wait....' 'Running growth model']);

% Determine the selected input data.
str = get(handles.popup_EggsChar, 'String');
val = get(handles.popup_EggsChar,'Value');

% Set biological data corresponding to selected species.
% Get data from GUI
switch str{val};
    case 'Use constant egg diameter and density' %%model would use a constant Rhoe and D
        D = str2double(get(handles.ConstD,'String'));%mm
        D = single(D*ones(length(time),1));
        Rhoe_ref = single(str2double(get(handles.ConstRhoe,'String')));
        Rhoe_ref = Rhoe_ref*ones(length(time),1,'single');
        Tref = str2double(get(handles.Tref,'String'));
    case 'Use diameter and egg density time series (Chapman and George (2011, 2014))'
        Tref = 22; %C
        [D,Rhoe_ref] = EggBio;
        %% Are we doing inverse modeling? TG
        if Inv_mod==-1 %If yes invert the array of D and Rhoe in such a way D decreases with every time step
                       %and Rhoe increases with every time step
            D=D(end:-1:1);
            Rhoe_ref=Rhoe_ref(end:-1:1);
        end
end % Do we use constant diameter and egg density? or do we use grow development time series

%% Calculate water density
Rhow = density(Temp); %Here we calculate the water density in every cell

%% Get channel geometry and initial data where eggs spawned
for l=1:Eggs
    C = find(X(t,l)<CumlDistance*1000);cell(l)=C(1);
    Vx(l) = VX(cell(l)); %m/s
    Vz(l) = Vvert(cell(l)); %m/s
    Vy(l) = Vlat(cell(l)); %m/s
    H(l) = Depth(cell(l)); %m
    W(l) = Width(cell(l)); %m
    ustar(l) = Ustar(cell(l));
    T(l) = Temp(cell(l));
    KS(l) = ks(cell(l)); %mm
    Egg_Direction(l) = Q(cell(l))./abs(Q(cell(l))); %positive is downstream movement
    %% Calculating the SG of eggs
    Rhoe(l) = Rhoe_ref(t)+0.20646*(Tref-Temp(cell(l)));
    SG(l) = Rhoe(l)/Rhow(cell(l));%dimensionless
    %clear Rhoe_ref; clear Rhoe;
    %======================================================================
    %% Explicit Lagrangian Horizontal Diffusion
    DH(l) = 0.6*H(l)*ustar(l);
    %% Delete or comment, this is for debug
    %H_unsteady(1,l)=H(l)';
end %get hydraulic and water temperature data at egg location

%% Calculating initial fall velocity of eggs
% Dietrich's
% All eggs have same properties initially
Vzpart = single(-Dietrich(D(t),SG(1),T(1))/100);%D should be in mm, vs output is in cm/s, then we convert it to m
%======================================================================

%% Checking Dt for simulation estability, see Garcia et al., 2013
if  CheckDt==0
    [minDt,CheckDt] = Checking_Dt;
end
if Dt>minDt
    waitfor(msgbox(['The selected time step is too large, A value of Dt=', num2str(minDt), ' seconds it is going to be used in the simulation'],'FluEgg Warning','warn'));
    delete(h)
    return % go out of function and display error message
end

Vzpart=Vzpart*ones(Eggs,1,'single'); %Initially all the eggs have the same Vs
%%
clear Dmin Vsmax DiamStd VsStd Diam vs C str val

%% Lagrangian movement of eggs (Please reffer to Jump function below)
Warning_flag=0;
Jump;
%========================================================================

%% This is for mortality model development
% Total_perTime=sum(touch,2);
% plot(time(2:end),Total_perTime);
% bar(time(2:end),Total_perTime);

%% Sometimes I use this to delete the waitbar when debbuging TG
% catch
% set(0,'ShowHiddenHandles','on')
% delete(get(0,'Children'))
% return
% end
%%=========================================================================

%% Nested Functions
% Nested functions are used in this function to speed up the simulation
%%=========================================================================
%
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%% 1.  EggBio
% In this function we estimate the eggs growth (diameter and density of eggs)
% based on Chapman's experiments.
% The time series of eggs characteristics are standardized at a temperature
% of to 22C.                                                              %
    function [D,Rhoe_ref]=EggBio()
        
        %% Initialize variables
        Dvar = ones(length(time),1);
        Rhoevar=Dvar;
        %% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        if strcmp(specie,'Silver')%if specie=='Silver' :Updated TG March,2015
            Dmin = 1.6980;% mm % Minimum diameter from Chapman's data
            Dmax = 5.6000;% mm    TG 03/2015
            Rhoe_max = 1036.1;% Kg/m^3 at 22C
            Rhoe_min = 998.7680;% Kg/m^3 at 22C TG 03/2015
            %% Diameter fit
            a = 4.66;
            b = 2635.9;
            D = a*(1-exp(-time/b));%R2 = 0.87 for silver carp eggs
            %% Density of eggs fit Standardized to 22C
            a = 25.2;
            b = 2259;
            c = 999.3;
            Rhoe_ref = (a*exp(-time/b))+c;%R-square: 0.67 for silver carp eggs
            %% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        elseif strcmp(specie,'Bighead')%:Updated TG March,2015
            Dmin = 1.5970;% mm
            Dmax = 7.1334;% mm
            Rhoe_max = 1040.4;% Kg/m^3 at 22C
            Rhoe_min = 998.5357;% Kg/m^3 at 22C
            %% Diameter fit
            a = 5.82;
            b = 3506.7;
            D = a*(1-exp(-time/b));%R2 = 0.82 for BC eggs
            %% Density of eggs fit Standardized to 22C
            a = 30.58;
            b = 1716;c=999.4;Rhoe_ref=(a*exp(-time/b))+c;%R-square: 0.84 for BC eggs
            %% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        else %case Grass Carp : TG March,2015
            Dmin = 1.2250;% mm
            Dmax = 5.6750;% mm
            Rhoe_max = 1.0473e+03;% Kg/m^3 at 22C
            Rhoe_min = 998.4118;% Kg/m^3 at 22C
            %% Diameter fit
            a = 4.56;
            b = 2314;
            D = a*(1-exp(-time/b));%R2 = 0.46 for GC eggs
            %% Density of eggs fit Standardized to 22C
            a = 29.09;
            b = 1812;
            c = 999.8;
            Rhoe_ref = (a*exp(-time/b))+c;%R-square: 0.58 for GC eggs
        end
        %% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        %% Checking for min D
        D(D<Dmin) = Dmin;%min diameter (mm)
        %
        %% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        % Generate density and diameter time series based on cells averaged
        % water temperature, simulation times and fish species
        %% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        for tt=1:length(D) %because the counter of the array starts from 1
		%The following standard deviation relationships were calculated by fitting
		% a normal probability density function to increments of Chapman's data gruped by time periods and 
		%calculating the standard deviation of the data points from the fitted curve.
        %A curve of form a*exp(-t/b)+c was then fit to the time series of standard deviation values as a function of time (LJ February 2017).
            %% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            if strcmp(specie,'Silver')%if specie=='Silver'
                %% STD
                    %% Diameter
                    DiamStd = 0.2631.*exp(-time/22410)+0.3073; %LJ
                	%% Density
                    RhoeStd = 22.4.*exp(-time/1894)+0.4103;%LJ
                %% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            elseif strcmp(specie,'Bighead')
                %% STD
                    %% Diameter
                    DiamStd = 0.1788.*exp(-time/13570)+0.44;%LJ
                    %% Density
                    RhoeStd = 63.12*exp(-time/595)+0.6292;%LJ
                %% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
            else %case Grass Carp : TG March,2015
                     %% Diameter
                    DiamStd = 0.4759.*exp(-time/14150)+0.4586;%LJ
                    %% Density
                    RhoeStd = 19.28.*exp(-time/1973)+1.029;%LJ
            end % Species selection
            %% ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
			%  The diameter and density are calculated at time 't' by using the value of the 
			%  fitted curve as the mean for that time and the value of the fitted curve of the standard
			%  deviation. A random variable is chosen from the normal distribuion with the given mean and 
			%  standard deviation to represent the diameter and density at the given time 't'. The value from the 
			%  the distribution is limited to between +/- 2 times the standard deviation, which encapsulates 95%
			%  of the observed data. (LJ February 2017)
			
            %% Diameter fit + scatter
            Dvar(tt,1) = single(normrnd(D(tt),DiamStd(tt)));
            while (Dvar(tt)>=D(tt)+DiamStd(tt))||(Dvar(tt)<=D(tt)-DiamStd(tt))
                Dvar(tt) = single(normrnd(D(tt),DiamStd(tt)));
            end
            %% Fitted density of the eggs  + scatter
            Rhoevar(tt,1) = single(normrnd(Rhoe_ref(tt),RhoeStd(tt)));
            while (Rhoevar(tt)>=Rhoe_ref(tt)+RhoeStd(tt))||(Rhoevar(tt)<=Rhoe_ref(tt)-RhoeStd(tt))
                Rhoevar(tt) = single(normrnd(Rhoe_ref(tt),RhoeStd(tt)));
            end
        end
        Rhoe_ref = Rhoevar;
        D = Dvar;
        %% Checking for min D and max Rhoegg
        D(D<Dmin) = Dmin;%min diameter (mm)
        D(D>Dmax) = Dmax;%min diameter (mm)  TG 03/2015
        Rhoe_ref(Rhoe_ref>Rhoe_max) = Rhoe_max;
        Rhoe_ref(Rhoe_ref<Rhoe_min) = Rhoe_min;   %TG 03/2015
    end %EggBio

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% 2.  Checking_Dt                                                         %
    function [minDt,CheckDt] = Checking_Dt
        CheckDt = 1;
        %% Preallocate memory [TimexCells]
        Dt_cells = zeros(size(Rhoe_ref,1),size(CumlDistance,1),'single');% [TimexCells]
        B_cells = Dt_cells; %[TimexCells]
        SG_cells = ones(length(time),length(CumlDistance),'single'); %[TimexCells]
        Vzpart_cells = ones(length(time),length(CumlDistance),'single');%[TimexCells]
        for Time=1:length(time)%calculate parameter for all cells for everytime step upto sim time.
            SG_cells(Time,:) = (Rhoe_ref(Time)+0.20646*(Tref-Temp))./Rhow;%sg during all time we will simulate
            for dist=1:length(CumlDistance)
                Vzpart_cells(Time,dist) = Dietrich(D(Time),SG_cells(Time,dist),Temp(dist))/100;
            end
            B_cells(Time,:) = 1+(2*((abs(Vzpart_cells(Time,:))./Ustar').^2));
            B_cells(Time,abs(Vzpart_cells(Time,:)./Ustar')>1) = 3;%3
            Dt_cells(Time,:) = Depth'./(2*B_cells(Time,:)*0.41.*Ustar');
        end
        minDt = round(min(min(Dt_cells)));
    end

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% 3.  Jump                                                                %
    function Jump
        Kprime = zeros(size(DH),'single');Kz=Kprime;%Memory allocation
        Mortality = 0;
        waitstep = floor((Steps)/100);
        alpha = 2.51;%Average value among several rivers
        beta = 2.47;
        %%=================================================================================================    
        for t=2:Steps                    
            if ~mod(t, waitstep) || t==Steps
                fill=time(t)/Totaltime;
                % Check for Cancel button press
                if getappdata(h,'canceling')
                    delete(h);
                    Exit=1;
                    return;
                end
                % Report current estimate in the waitbar's message field
                waitbar(fill,h,['Please wait....' sprintf('%12.0f',fill*100) '%']);
            end
            %%
            %a=Z(t-1,:)>0;
            if alivemodel==0 %If we are simulating eggs dying
                a = alive(t-1,:) == 1; %a = 1 for eggs that are alive in the previous time step
            else
                a = Z(t-1,:)' > -2*H;
            end
            %a = Z(t-1,:)' > -H;%Are they alive???
            %
            d = 0.5*(D(t)+D(t-1))/1000; %D -->diameter (mm)to m
            
            %% Vertical velocity profile
            viscosity = (1.79e-6)./(1+(0.03368*T(a))+(0.00021*(T(a).^2)));%m^2/s
            Zb = Z(t-1,a)'+H(a);
            Zb(Zb<0.00001) = 0.00001;
            % Determine the selected data set.
            str = get(handles.popup_roughness, 'String');
            val = get(handles.popup_roughness,'Value');
            
            % Set current data to the selected data set.
            switch str{val};
                case 'Log Law Smooth Bottom Boundary (Case flumes)'
                    Vxz = ustar(a).*((1/0.41)*log((ustar(a).*Zb)./viscosity)+5.5);
                    Vxz(Vxz<0)=0; %Non slip boundary condition;
                case 'Log Law Rough Bottom Boundary (Case rivers)'
                    Vxz = ustar(a).*((1/0.41)*log(Zb./KS(a))+8.5);%Vxz of alive eggs
                    Vxz(Vxz<0) = 0; %Non slip boundary condition;
            end
            Vxz=Egg_Direction(a).*Vxz;
            
            %% Streamwise velocity distribution in the transverse direction
            Vxz = abs(Vxz).*betapdf(Y(t-1,a)'./W(a),alpha,beta);
            %% X
            X(t,a) = X(t-1,a)'+Inv_mod*(Dt*Vxz)+(normrnd(0,1,sum(a),1).*sqrt(2*DH(a)*Dt));
            % Reflecting Boundary: Iff Eggs are located outside the
            % upstream boundary condition
            check = X(t,a);
            if Inv_mod==1
              check(check<d/2) = d-check(check<d/2);
            if length(check<d/2)>1 && Warning_flag==0
                hh=msgbox('Some eggs crossed the upstream boundary and where bounced back to the domain','FluEgg Warning','warn');
                pause(2)
                Warning_flag=Warning_flag+1;
                try
                delete(hh)
                catch
                end
            end 
            elseif sum(check<d/2)>=1
                ed=errordlg([{'Eggs are outside the domain'},{'Please review river input file or decrese the simulation time.'}],'Error');
                set(ed, 'WindowStyle', 'modal');
                uiwait(ed);
                minDt = 0; %terminate the simulation
                Exit=1;
                return
            end
            X(t,a) = check; %The new location of the eggs is check;
            check = []; %reset check
            X(t,~a) = X(t-1,~a);%If they were already dead,leave them in the same position.
            
            %% Y
            Y(t,a) = Y(t-1,a)'+(Dt*Vy(a))+(normrnd(0,1,sum(a),1).*sqrt(2*DH(a)*Dt));
            Y(t,~a) = Y(t-1,~a);%If they were already dead,leave them in the same position.
            
            %% Calculate Vertical dispersion
            [Kprime,Kz] = calculateKz;
            
            %% Movement in Z
            
            %% if larvae gas bladder stage
            if time(t)>T2_Hatching*3600  %after hatching
                Vzpart(a) = zeros(length(Vzpart(a)),1);
                Vswim(a) = zeros(length(Vzpart(a)),1);
            else %% if egg stage
                Vswim(a) = zeros(length(Vzpart(a)),1);
            end
            
            Z(t,a) = Z(t-1,a)'+Dt*(Vz(a)+Vswim(a)+Vzpart(a)+Kprime)+(normrnd(0,1,sum(a),1).*sqrt(2*Kz*Dt));%m
            
            %% Movement in Z
            % Z(t,a) = Z(t-1,a)'+Dt*(Vz(a)+Vzpart(a)+Kprime)+(normrnd(0,1,sum(a),1).*sqrt(2*Kz*Dt));%m
            Z(t,~a) = -H(~a)+d/2;%If they were already dead,leave them in the bottom.
            %% Check if eggs are in a new cell in this jump
            Check_if_egg_isin_newcell_or_New_Hydraulic_time_step
            if Exit==1  %If eggs are outside the domain
                delete(h)
                return
            end
            %% Reflective Boundary
            
            %% Reflective in Z
            %% If it overpasses the top
            beggs = false(size(Z,2),1);
            btop = Z(t,:)'>-d/2;%surface -->calculated based on the total No of eggs
            while sum(btop)>0
                Z(t,btop) = -d-Z(t,btop);
                b=Z(t,:)' < -H(:)+d/2;% Is any egg overpasses the bottom
                if sum(b) > 0 %if any egg touch the bottom get reflected...
                    Z(t,b) = -Z(t,b)'-2*(H(b)-d/2);
                    beggs = beggs|b; %this are the eggs that touched the bottom
                end
                btop = Z(t,:)'>-d/2;
            end
            %% If it overpasses the bottom
            b=Z(t,:)'<-H(:)+d/2;% Bottom _>need to check this outside the while too.  This is in case we overpassed just the bottom
            while sum(b)>0
                Z(t,b) = -Z(t,b)'-2*(H(b)-d/2);
                beggs = beggs|b;
                btop = Z(t,:)'>-d/2;%surface
                if sum(btop)>0
                    Z(t,btop) = -d-Z(t,btop);
                end
                b=Z(t,:)'<-H(:)+d/2;% Bottom
            end
            
            %% Reflective in Y and double check after first jump
            check = Y(t,a);
            w = W(a)';
            while ~isempty(check(check<d/2))||~isempty(check(check>w-d/2))
                if ~isempty(check(check<d/2))
                    check(check<d/2) = d-check(check<d/2);
                    Y(t,a)=check;check=[];check=Y(t,a);
                end
                if ~isempty(check(check>w-d/2))
                    w = W(a)';
                    check(check>w-d/2) = 2*w(check>w-d/2)-d-check(check>w-d/2);
                    Y(t,a) = check;
                    check = [];
                    check = Y(t,a);
                end
            end
            check = [];
            %%
            Y(t,~a) = Y(t-1,~a);%If they were already dead,leave them in the same position.
            
            %% Alive or dead ??
            if alivemodel==0
                [alive] = mortality_model(alive,d,a);
            end %mortality model
            
        end
        %% DELETE the waitbar;
        delete(h)
        %%
        M = msgbox('Please wait FluEgg is saving the results','FluEgg','help');
        %%
        if ~exist(['./results/Results_', get(handles.edit_River_name, 'String'),'_',get(handles.Totaltime, 'String'),'h_',get(handles.Dt, 'String'),'s'],'dir')
            mkdir('./results',['Results_', get(handles.edit_River_name, 'String'),'_',get(handles.Totaltime, 'String'),'h_',get(handles.Dt, 'String'),'s']);
        end
        Folderpath=['./results/Results_', get(handles.edit_River_name, 'String'),'_',get(handles.Totaltime, 'String'),'h_', ...
            get(handles.Dt, 'String'),'s/'];
        
        %% If Batch mode is activated
        Batchmode=get(handles.Batch,'Checked');
        if strcmp(Batchmode,'on')
            outputfile = [Folderpath,'Results_', get(handles.edit_River_name, 'String'),'_',get(handles.Totaltime, 'String'),'h_', ...
                get(handles.Dt, 'String'),'s','run ',num2str(handles.userdata.RunNumber) '.mat'];
        else
            outputfile = [Folderpath,'Results_', get(handles.edit_River_name, 'String'),'_',get(handles.Totaltime, 'String'),'h_', ...
                get(handles.Dt, 'String'),'s' '.mat'];
        end
        hFluEggGui = getappdata(0,'hFluEggGui');
        setappdata(hFluEggGui, 'outputfile', outputfile);
        %% DELETE_Or_comment_This is for debugging==========================================
%         hFluEggGui = getappdata(0,'hFluEggGui');
%         HECRAS_data=getappdata(hFluEggGui,'inputdata');
%         Depth_HEC_RAS=arrayfun(@(x) x.Riverinputfile(1,3), HECRAS_data.Profiles);
        %%=================================================================
        ResultsSim.X = X;
        ResultsSim.Y = Y;
        ResultsSim.Z = Z;
        ResultsSim.time = time;
        %ResultsSim.touch = touch; % For mortality model
        ResultsSim.D=D;
        ResultsSim.alive=alive;
        ResultsSim.CumlDistance=CumlDistance;
        ResultsSim.Depth=Depth;
        ResultsSim.Width=Width;
        ResultsSim.VX=VX;
        ResultsSim.Temp=Temp;
        ResultsSim.specie=specie;
        ResultsSim.Spawning=[Xi,Yi,Zi];
        ResultsSim.T2_Hatching=T2_Hatching;
        ResultsSim. T2_Gas_bladder= T2_Gas_bladder;
        savefast(outputfile,'ResultsSim');
        %folderName= uigetdir('./results','Folder name to save results');
        
        %% SAVE RESULTS AS TEXT FILE
        % This section was comented because it was taking a very long time
        % to save, maybe we will anable this in a future version
        % save([Folderpath,'X' '.txt'],'X', '-ASCII');
        % save([Folderpath,'Y' '.txt'],'Y', '-ASCII');
        % save([Folderpath,'Z' '.txt'],'Z', '-ASCII');
        % save([Folderpath,'time' '.txt'],'time', '-ASCII');
        % hFluEggGui=getappdata(0,'hFluEggGui');
        % setappdata(hFluEggGui, 'Folderpath', Folderpath);
        % hdr={'Specie=',specie;'Dt_s=',Dt;'Simulation time_h=',time(end)/3600};
        % dlmcell([Folderpath,'Simulation info' '.txt'],hdr,' ');
        delete(M)%delete message
        
        
        %%  3.1.  Calculate vertical diffusion                              %
        %                                                                 %
        function [Kprime,Kz]=calculateKz
            
            
            % Check if ustar=0 and display error if ustar=0
            if ustar(a)==0
                ed = errordlg('u* can not be equal to zero, try using a very small number different than zero','Error');
                set(ed, 'WindowStyle', 'modal');
                uiwait(ed);
                return
            end
            %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            %% Calculate beta coefficient
            %
            % Reference:                                                  %
            % Van Rijn, L. . (1984). Sediment transport, Part II: Suspended
            % load transport. Journal of Hydraulic Engineering, ASCE,     %
            % 110(11), 1613?1641.                                         %
            
            % Garcia, T., Zamalloa, C. Z., Jackson, P. R., Murphy, E. A., &
            % Garcia, M. H. (2015). A Laboratory Investigation of the     %
            % Suspension, Transport, and Settling of Silver Carp Eggs     %
            % Using Synthetic Surrogates. PloS One, 10(12), e0145775.     %
            B = 1+(2*((abs(Vzpart(a))./ustar(a)).^2));
            outrange = abs(Vzpart(a))./ustar(a);
            outrange = outrange >1;%Out of the function range
            B(outrange) = 3;
            % Vertical location of the eggs with H as coordinate reference
            % In FluEgg Z=0 is the water surface and
            ZR = Z(t-1,a)'+H(a);%ZR(ZR<0.1)=0.1;ZR(ZR>H(1)-0.1)=H(1)-0.1;
            
            %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            %% Gets from GUI user defined option for vertical turbulent diffusivity model
            str = get(handles.popupDiffusivity, 'String');
            val=get(handles.popupDiffusivity,'Value');
            switch str{val};
                case 'Constant Turbulent Diffusivity'
                    Kz=B.*(1/15).*H(a).*ustar(a);
                    Kprime(a)=0;
                    Kz(Kz<B.*viscosity)=B(Kz<B.*viscosity).*viscosity(Kz<B.*viscosity);  %If eddy diffusivity is less than the water viscosity, use the water viscosity
                case 'Parabolic Turbulent Diffusivity'
                    Kprime=B.*0.41.*ustar(a).*(1-(2*ZR./H(a)));
                    Zprime=ZR+(0.5*Kprime*Dt);
                    Kz=B.*0.41.*ustar(a).*Zprime.*(1-(Zprime./H(a)));%Calculated at ofset location 0.5K'Dt
                    Kz(Kz<B.*viscosity)=B(Kz<B.*viscosity).*viscosity(Kz<B.*viscosity);  %If eddy diffusivity is less than the water viscosity, use the water viscosity
                case 'Parabolic-Constant Turbulent Diffusivity'
                    Kprime=B.*0.41.*ustar(a).*(1-(2*ZR./H(a)));%dimensionless
                    Kprime(ZR./H(a)>=0.5)=0;  %constant portion
                    Zprime=ZR+(0.5*Kprime*Dt);
                    Kz=B.*0.41.*ustar(a).*Zprime.*(1-(Zprime./H(a)));%Calculated at ofset location 0.5K'Dt  %% Parabolic function
                    Kz(ZR./H(a)>=0.5)=B(ZR./H(a)>=0.5).*0.25*0.41.*ustar(ZR./H(a)>=0.5).*H(ZR./H(a)>=0.5);  %% Constant part, corresponding to max diffisivity, refference Van Rijin
                    Kz(Kz<B.*viscosity)=B(Kz<B.*viscosity).*viscosity(Kz<B.*viscosity);  %If eddy diffusivity is less than the water viscosity, use the water viscosity
            end %switch
        end %calculateKz
    end %Function Jump

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% 4.  Check_if_egg_isin_newcell                                                                %
    function Check_if_egg_isin_newcell_or_New_Hydraulic_time_step
        %% Check if it is a new hydraulic_time_step, if so retrive hydraulic input variables
        hFluEggGui = getappdata(0,'hFluEggGui');
        HECRAS_data=getappdata(hFluEggGui,'inputdata');
        
        %% if we are in a new HEC-RAS time step
        %%==>We will have new hydraulic conditions for next time step
        try % for unsteady input
             HECRAS_time_sec=HECRAS_data.HECRAS_time_sec;
            if time(t)+ HECRAS_FluEgg_Timediff>=HECRAS_time_sec(HECRAS_time_counter+1)
                HECRAS_time_index=HECRAS_time_index+Inv_mod; %Take into account inverse modeling when time index should go backward
                HECRAS_time_counter=HECRAS_time_counter+1;
                
                [~,Depth,Q,~,Vlat,Vvert,Ustar,Temp,Width,VX,ks]=Create_Update_Hydraulic_and_QW_Variables(HECRAS_time_index);
                for egg_index=1:length(H)
                    Cell=cell(egg_index);%Cell is the cell were the current egg is located 
                    [Vz,Vy,H,W,DH,ustar,T,KS,Vzpart,Egg_Direction]=update_local_Hydraulics_and_Temp_of_eggs(egg_index,Cell,Vz,Vy,H,W,DH,ustar,T,KS,Vzpart,Q,Egg_Direction);
                end
            end
        catch
            %continue if steady state
        end
        
        
        %% Check if eggs are in a new cell in this jump
        %Find egg index of eggs that are in a new cell
        
        %% If not doing forward modeling.
        if Inv_mod==1
        [c,~]=find(X(t,:)'>(CumlDistance(cell)*1000));%If egg is in a new cell
        else %% If we are doing inverse modeling
         %For eggs in cells>1
         %find eggs that crossed a new cell
         [c,~]=find(X(t,cell>1)'<(CumlDistance(cell(cell>1)-1)*1000));
         eggs_in_first_cell=cell==1;
         if sum(eggs_in_first_cell)>=1
          [out,~]=find(X(t,eggs_in_first_cell)'<0);
          if length(out)>1
              ed=errordlg([{'Eggs are outside the domain'},{'Please review river input file or decrese the simulation time.'}],'Error');
                set(ed, 'WindowStyle', 'modal');
                uiwait(ed);
                minDt = 0; %terminate the simulation
                Exit=1;
                return
          end
         end
        end %End if Inv mod
        
        for i=1:length(c)
            egg_index=c(i);
            C=find(X(t,egg_index)<CumlDistance*1000,1,'first'); %Find the new cell where eggs are located
            %%=====================================================================
            if isempty(C)  % If the egg is outside the domain
                ed=errordlg([{'The cells domain have being exceeded.'},{'Please extend the River the domain in the River input file.'},{'Advice:'},{'1.  If your waterbody ends in a lake and you expect the eggs to settle, you can add an additional cell with Vmag=u*=very small value=1e-5m/s.'},{'2.  If your waterbody ends in a stream where you do not expect settling, you need to extend your domain by adding an additional cell with the stream hydrodynamics.'},{'3.  If the hydrodynamics after the last cell are approximately constant, you can extrapolate your domain by extending the cumulative distance of the last cell of your domain, use with caution.'}],'Error');
                set(ed, 'WindowStyle', 'modal');
                uiwait(ed);
                msgbox(['Simulation time=', sprintf('%5.1f',time(t)/3600),'h, ','Mean X=',sprintf('%5.1f',mean(X(t-1,:))/1000),'km'],'FluEgg message','help');
                Exit=1;
                return
                %                 if cellsExtended==0
                %                     msgbox('The last cell was extended to allow the eggs to drift during the simulation time','FluEgg message','Warn');
                %                     cellsExtended=1;
                %                 end
                %% Continue in the drift ================================================
            else
                
            cell(egg_index)=C; %Update the array that storage the cell number of all the eggs    
            Cell=cell(egg_index);%Cell is the cell were the current egg is located           
            [Vz,Vy,H,W,DH,ustar,T,KS,Vzpart,Egg_Direction]=update_local_Hydraulics_and_Temp_of_eggs(egg_index,Cell,Vz,Vy,H,W,DH,ustar,T,KS,Vzpart,Q,Egg_Direction);
            end
        end
        %% Delete or comment, this is for debug
        %H_unsteady(t,:)=H';
        
        
        %% Update egg local Hydraulic and thermal characteristigs 
        function [Vz,Vy,H,W,DH,ustar,T,KS,Vzpart,Egg_Direction]=update_local_Hydraulics_and_Temp_of_eggs(egg_index,Cell,Vz,Vy,H,W,DH,ustar,T,KS,Vzpart,Q,Egg_Direction)
           %Vx(c(i))=VX(Cell); %m/s
            Vz(egg_index)=Vvert(Cell); %m/s
            Egg_Direction(egg_index)=Q(Cell)/abs(Q(Cell)); %
            Vy(egg_index)=Vlat(Cell); %m/s
            H(egg_index)=Depth(Cell); %m
            W(egg_index)=Width(Cell); %m
            DH(egg_index)=0.6*Depth(Cell)*Ustar(Cell);
            ustar(egg_index)=Ustar(Cell);
            T(egg_index)=Temp(Cell);
            KS(egg_index)=ks(Cell); %mm
            %%
            %% Calculating the SG of esggs
            Rhoe(egg_index)=(0.5*(Rhoe_ref(t)+Rhoe_ref(t-1)))+0.20646*(Tref-Temp(Cell));%Calculated at half timestep
            SG(egg_index)=Rhoe(egg_index)/Rhow(Cell);%dimensionless
            if SG(egg_index)<1
                Vzpart(egg_index)=0;
            end
            %% Dietrich
            Vzpart(egg_index)=-Dietrich(0.5*(D(t)+D(t-1)),SG(egg_index),T(egg_index))/100;
        end%update_local_Hydraulics&Temp_of_eggs
        
        
        
    end %New cell

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% 5.  Check_if_egg_isin_newcell
    function [alive]=mortality_model(alive,d,a)
        %% Load parameters
        Mp=0;   %By predators
        Mb=0;   %By burial or egg damage
        Mc=0;   %Custom mortality e.g. case of a Dam
        Mortality=Mp+Mb+Mc;
        %% ================================================================
        alive(t,:)=alive(t-1,:);%If it was dead...it continue dead
        Mortality_model=4;
        switch Mortality_model
            case 1
                %% Case 1
                %How many eggs are in the danger zone???
                bed=(0.05*H)-H;% in model coordinates;
                EggsInDanger=Z(t,:)'<bed-d/2&a';%Eggs in the danger zone that are alive
                Mortality=Mortality+0.01*sum(EggsInDanger);
                if  fix(Mortality)>=1
                    index=randperm(sum(EggsInDanger));%randomly organize eggs that can die
                    [Id,~]=find(EggsInDanger==1);%Tells the Id of eggs in danger
                    for k=1:Mortality
                        alive(t,Id(index(k)))=0; %randomly select one egg in danger Id(index(k))
                    end
                end
                Mortality=Mortality-fix(Mortality);
            case 2
                %% Case 2
                % Consequtive entries to the danger zone
                bed=(0.05*H)-H;% in model coordinates;
                EggsInDanger=Z(t,:)'<bed-d/2;%Eggs in the danger zone
                touch(t,EggsInDanger)=1;
            case 3
                %% Case 3
                % A percentage of the eggs that touched the bottom are killed
                EggsInDanger=beggs;%Eggs in risk of dying that are still alive
                Mortality=Mortality+0.01*sum(EggsInDanger);
                if  fix(Mortality)>=1
                    index=randperm(sum(EggsInDanger));%randomly organize eggs that can die
                    [Id,~]=find(EggsInDanger==1);%Tells the Id of eggs in danger
                    for k=1:Mortality
                        alive(t,Id(index(k)))=0; %randomly select one egg in danger Id(index(k))
                    end
                end
                Mortality=Mortality-fix(Mortality);
            case 4
                %if it was near the bottom at hatching time, eggs will be dead.
                %at the end of the previous time step before hatching
                if time(t)>(T2_Hatching*3600-Dt)&&count_mortality_at_hatching==0
                    alive(t,:)=alive(t-1,:);%If it was dead...it continue dead
                    %How many eggs are in the danger zone???
                    bed=(0.05*H)-H;% in model coordinates;
                    EggsInDanger=Z(t,:)'<bed-d/2&a';%Eggs in the danger zone that are alive
                    alive(t,EggsInDanger)=0;
                    count_mortality_at_hatching=1;
                end
        end %switch
        %% At which cell the egg dye??
        celldead(alive(t,:)==0)=cell(alive(t,:)==0);
    end %mortality model

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
% 6.  Create hydraulic and QW variables
    function [CumlDistance,Depth,Q,Vmag,Vlat,Vvert,Ustar,Temp,Width,VX,ks]=Create_Update_Hydraulic_and_QW_Variables(HECRAS_time_index)
        hFluEggGui = getappdata(0,'hFluEggGui');
        HECRAS_data=getappdata(hFluEggGui,'inputdata');

        %display error for users
        if HECRAS_time_index<1||HECRAS_time_index>length(HECRAS_data.Profiles)
                ed=errordlg([{'HEC-RAS simulation time error'},{'Please review HEC-RAS simulation time and make sure it is long enough to perform FluEgg simulation.'}],'Error');
                set(ed, 'WindowStyle', 'modal');
                uiwait(ed);
                minDt = 0; %terminate the simulation
                Exit=1;
                return
        end
        
        %% Delete or uncomment, this is for testing of the unsteady input new development
%         for i=1:7
%             HECRAS_data.Profiles(i).Riverinputfile(2:end,:)=[];
%             HECRAS_data.Profiles(i).Riverinputfile(1,2)=100;
%         end
%         setappdata(hFluEggGui,'inputdata',HECRAS_data);
        %%==================================================================
        Riverinputfile=HECRAS_data.Profiles(HECRAS_time_index).Riverinputfile;
        
        CumlDistance = Riverinputfile(:,2);   %Km
        Depth = Riverinputfile(:,3);          %m
        Q = Riverinputfile(:,4);              %m3/s-->sign is in Vx
        Vmag = Riverinputfile(:,5);           %m/s
        Vlat = Riverinputfile(:,6);           %m/s
        Vvert = Riverinputfile(:,7);          %m/s
        Ustar = Riverinputfile(:,8);          %m/s
        Temp = Riverinputfile(:,9);          %C
        
        %==========================================================================
        %% Calculations
        Width = abs(Q./(Vmag.*Depth));               %m
        VX = (Q./abs(Q)).*sqrt(Vmag.^2-Vlat.^2-Vvert.^2); %m/s Times +1 or - 1 to account for flow direction
        ks = Ks_calculate();
        
        function [ks]=Ks_calculate()
            %% Input data needed to calculate ks
            Depth = Riverinputfile(:,3);         %m
            Ustar = Riverinputfile(:,8);           %m/s
            ks = 11*Depth./exp((VX.*0.41)./Ustar); %m
        end
        
    end
%toc
%profreport
end %FluEgg function

