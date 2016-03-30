function [vs] = Dietrich(D,SG,T)
D=D/10; %cm
g=981; %cm/s^2
viscosity=(1.79e-6*100^2)/(1+(0.03368*T)+(0.00021*(T^2)));%cm^2/s
b1=2.891394;b2=0.95296;b3=0.056835;b4=0.002892;b5=0.000245;
Rep=(D*sqrt((SG-1)*g*D))/viscosity;
Rf=exp(-b1+(b2*(log(Rep)))-(b3*((log(Rep))^2))...
-(b4*((log(Rep))^3))+(b5*((log(Rep))^4)));
vs=Rf*sqrt((SG-1)*g*D);


