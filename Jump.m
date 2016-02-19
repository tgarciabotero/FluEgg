function [X,Y,Z,D,alive]=Jump(handles,advection,t,X,Dt,Vx,DH,Y,Vy,W,D,Vz,Z,Vzpart,H,ustar,alive,T)
%a=Z(t-1,:)>0;
%a=Z(t-1,:)>-H;%Are they alive???
a=Z(t-1,:)>-2*H;%Are they alive???
d=0.5*(D(t)+D(t-1))/1000; %D -->diameter (mm)to m

%% Vertical velocity profile
%viscosity=0.000001;%%	m2/s
viscosity=(1.79e-6)./(1+(0.03368*T(a))+(0.00021*(T(a).^2)));%m^2/s
Zb=Z(t-1,a)+H(a);Zb(Zb<0.00001)=0.00001;
% Determine the selected data set.
str=get(handles.popup_roughness, 'String');
val=get(handles.popup_roughness,'Value');
% Set current data to the selected data set.
switch str{val};
    case 'Log Law Smooth Bottom Boundary (Case flumes)'  
        Vxz=ustar(a).*((1/0.41)*log((ustar(a).*Zb)./viscosity)+5.5);
    case 'Log Law Rogh Bottom Boundary (Case rivers)' 
        ks=str2double(get(handles.Ks,'String'));%m
        Vxz=ustar(a).*((1/0.41)*log(Zb/ks)+8.5);
end

%% X
%X(t,a)=X(t-1,a)+(Dt*Vx(a))+normrnd(0,1,1,sum(a)).*sqrt(2*DH(a)*Dt);
X(t,a)=X(t-1,a)+(Dt*Vxz)+(normrnd(0,1,1,sum(a)).*sqrt(2*DH(a)*Dt));
%reflecting Boundary
check=X(t,a);check(check<d/2)=d-check(check<d/2);X(t,a)=check;check=[];
X(t,~a)=X(t-1,~a);%If they were already dead,leave them in the same position.
%% Y
Y(t,a)=Y(t-1,a)+(Dt*Vy)+(normrnd(0,1,1,sum(a)).*sqrt(2*DH(a)*Dt));
%reflecting Boundary
check=Y(t,a);check(check<d/2)=d-check(check<d/2);Y(t,a)=check;check=[];
check=Y(t,a);w=W(a);check(check>w-d/2)=2*w(check>w-d/2)-d-check(check>w-d/2);Y(t,a)=check;check=[];
Y(t,~a)=Y(t-1,~a);%If they were already dead,leave them in the same position.
%% Z
if advection==1
    Kz=0;
else

%% Determine the selected Turbulent diffusivity model.

%B(a)=1;%1
B=1+(2*((abs(Vzpart(a))./ustar(a)).^2));
ZR=Z(t-1,a)+H(a);%ZR(ZR<0.1)=0.1;ZR(ZR>H(1)-0.1)=H(1)-0.1;
%Zprime=ZR; %in case of calculatin Kv at Z
str=get(handles.popupDiffusivity, 'String');
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
      Kprime=B.*0.41.*ustar(a).*(1-(2*ZR./H(a)));
      Kprime(ZR./H(a)>=0.5)=0;  %constant portion
      Zprime=ZR+(0.5*Kprime*Dt);
      Kz=B.*0.41.*ustar(a).*Zprime.*(1-(Zprime./H(a)));%Calculated at ofset location 0.5K'Dt  %% Parabolic function
      Kz(Zprime./H(a)>=0.5)=B(Zprime./H(a)>=0.5).*0.25*0.41.*ustar(Zprime./H(a)>=0.5).*H(Zprime./H(a)>=0.5);  %% Constant
      Kz(Kz<B.*viscosity)=B(Kz<B.*viscosity).*viscosity(Kz<B.*viscosity);  %If eddy diffusivity is less than the water viscosity, use the water viscosity
    case 'Exponential Turbulent Diffusivity'
       Kprime=B.*0.41.*ustar(a).*(1-1.82*(ZR./H(a))).*exp(-1.82*(ZR./H(a)));     
       Zprime=ZR+(0.5*Kprime*Dt);
       Kz=B.*0.41.*ustar(a).*Zprime.*exp(-1.82*(Zprime./H(a)));   
       Kz(Kz<B.*viscosity)=B(Kz<B.*viscosity).*viscosity(Kz<B.*viscosity);  %If eddy diffusivity is less than the water viscosity, use the water viscosity
end

end
%%
Z(t,a)=Z(t-1,a)+Dt*(Vz(a)+Vzpart(a)+Kprime)+(normrnd(0,1,1,sum(a)).*sqrt(2*Kz*Dt));
Z(t,~a)=-H(~a);%If they were already dead,leave them in the bottom.
%% Reflective Boundary
btop=Z(t,:)>-d/2;Z(t,btop)=-d-Z(t,btop);
b=Z(t,:)<-H+d/2;Z(t,b)=-Z(t,b)-2*(H(b)-d/2);
alive(b)=0; %Zero means dead
end