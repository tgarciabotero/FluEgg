function [D,Vzpart] = Bio(time,Dmin,Vsmax,DiamStd,VsStd)
%% Diameter fit
a=4.6639;b=2635.2;D=a*(1-exp(-time/b));
D(D<Dmin)=Dmin;%diameter (mm) as a function of time in seconds %y(x) = a (1 - exp( - x / b))-->R = 0.89018 
%% Fall velocity fit
a=43.606;c=0.58961;n=-0.57227;%R=0.79213 Vs=[cm/s];
Vs=a*(time).^n+c;%time is in seconds
Vs(Vs>Vsmax)=Vsmax;
for t=1:length(D) %because the counter of the array starts from 1
%% Diameter fit + scatter
Dvar(t)=normrnd(D(t),DiamStd);
while (Dvar(t)>=D(t)+DiamStd)|(Dvar(t)<=D(t)-DiamStd)
    Dvar(t)=normrnd(D(t),DiamStd);
end
D(t)=Dvar(t);
%% Fall velocity fit + scatter
Vsvar(t)=normrnd(Vs(t),VsStd);
while (Vsvar(t)>=Vs(t)+VsStd)|(Vsvar(t)<=Vs(t)-VsStd)
    Vsvar(t)=normrnd(Vs(t),VsStd);
end
Vzpart(t)=Vsvar(t)/100;%conver to m/s
end
end


