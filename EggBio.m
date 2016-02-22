function [D,Rhoe_i]=EggBio(time,specie)
%% Initialize variables
Dvar=ones(length(time),1);Rhoevar=Dvar;
%%
if strcmp(specie,'Silver')%if specie=='Silver'
    Dmin=1.6980;% mm
    Rhoe_max=1029.112;% Kg/m^3 at 22C  
    %% Diameter fit
    a=4.66;b=2635.9;D=a*(1-exp(-time/b));%R2 = 0.87 for silver carp eggs
    %% Density of eggs fit Standardized to 22C
    a=20.5290;b=2262.9;c=999.05;Rhoe_i=(a*exp(-time/b))+c;%R2 = 0.82 for silver carp eggs
else
    Dmin=1.5970;% mm
    Rhoe_max=1032.6;% Kg/m^3 at 22C  
    %% Diameter fit
    a=5.82;b=3506.7;D=a*(1-exp(-time/b));%R2 = 0.85 for silver carp eggs
    %% Density of eggs fit Standardized to 22C
    a=24.928;b=1730.1;c=999.08;Rhoe_i=(a*exp(-time/b))+c;%R2 = 0.82 for silver carp eggs 
end
%% Checking for min D and max Rhoegg
D(D<Dmin)=Dmin;%diameter (mm) as a function of time in seconds %y(x) = a (1 - exp( - x / b))-->R = 0.89018 
Rhoe_i(Rhoe_i>Rhoe_max)=Rhoe_max;

for t=1:length(D) %because the counter of the array starts from 1
    if strcmp(specie,'Silver')%if specie=='Silver'
        %% STD
        if time(t)/3600<4
            DiamStd=0.9868;%mm 
        else
            DiamStd=0.3512;%mm
        end
        if time(t)/3600<1
            RhoeStd=6.7227;%Kg/m^3 at 22C
        else
            RhoeStd=0.633;%Kg/m^3 at 22C
        end
        %%
    else
        %% STD
        if time(t)/3600<4
            DiamStd=1.1311;%mm 
        else
            DiamStd=0.4549;%mm
        end
        if time(t)/3600<1
            RhoeStd=4.3463;%Kg/m^3 at 22C
        else
            RhoeStd=0.9112;%Kg/m^3 at 22C
        end
        %% 
    end
%% Diameter fit + scatter
Dvar(t,1)=normrnd(D(t),DiamStd);
while (Dvar(t)>=D(t)+DiamStd)||(Dvar(t)<=D(t)-DiamStd)
    Dvar(t)=normrnd(D(t),DiamStd);
end
%% Fall velocity fit + scatter
Rhoevar(t,1)=normrnd(Rhoe_i(t),RhoeStd);
while (Rhoevar(t)>=Rhoe_i(t)+RhoeStd)||(Rhoevar(t)<=Rhoe_i(t)-RhoeStd)
    Rhoevar(t)=normrnd(Rhoe_i(t),RhoeStd);
end
end
Rhoe_i=Rhoevar;
D=Dvar;
end


