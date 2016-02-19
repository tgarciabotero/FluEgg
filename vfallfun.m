function [error,vs]=vfallfun(vs,D,SG,T)
%D in mm
D=D/10;%Here we convert to cm
viscosity=(1.79e-6*100^2)/(1+(0.03368*T)+(0.00021*(T^2)));%cm2/s
g=981;	%cm/s2
Rp=vs*D/viscosity;
Cd=(24/Rp)*(1+(0.152*(Rp^0.5))+(0.0151*Rp));
Rf=sqrt((4/3)*(1/Cd));
vscal=Rf*(sqrt(g*(SG-1)*D));
error=vs-vscal;
end