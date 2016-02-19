function Vzpart=buoyancy(Vz,D,Rhop,Rhow)
D=D/1000;%m
%Rhop kg/m3
%Rhow kg/m3
g=9.81;%m/s^2
Viscosity=1e-6; %m2/s
%Vz m/s
%Vzpart m/s
Vzpart=Vz+((1/24)*g*D^2*((-Rhop+Rhow)/(Rhow*Viscosity))*log(5/2));
end

