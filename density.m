function [Rhow]=density(T)
%Ecuation of state UNESCO(1987)
%Temperature should be in C & Rho in Kg/m^3
a_0=999.842594;
a_1=6.793952e-2;
a_2=-9.09529e-3;
a_3=1.001685e-4;
a_4=-1.120083e-6;
a_5=6.536332e-9;
Rhow=a_0+a_1*T+a_2*T.^2+a_3*T.^3+a_4*T.^4+a_5*T.^5;
end

