function [TimeToHatch] = HatchingTime(Temp,specie)
AvgTemp=mean(Temp);
if strcmp(specie,'Silver')%if specie=='Silver'
    %% If silver carp
    %This funtion includes a compilation of different research done about
    %hatching time R^2=0.96558 
    TimeToHatch=1.2087e+7*(AvgTemp^-4.2664)+10.242;%Time to hatch in hours
else
    %% If Bighead carp
    %This funtion includes a compilation of different research done about
    %hatching time R^2=0.93029
    TimeToHatch=35703*(AvgTemp^-2.223);%Time to hatch in hours
end


