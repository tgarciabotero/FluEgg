function []=Jump(Steps,time,Totaltime,h,alivemodel,handles,X,Dt,DH,Y,Vy,W,D,Vz,Z,Vzpart,H,ustar,alive,celldead,T,D_50,touch,cell,Rhoe,SG,VsT,Ti,Rhoe_i,Rhow,temp_variables,specie)
Mortality=0;
for t=2:Steps+1
    fill=time(t)/Totaltime;
    % Check for Cancel button press
    if getappdata(h,'canceling')
        close(h);
        return;%break
    end
    % Report current estimate in the waitbar's message field
    waitbar(fill,h,['Please wait....' sprintf('%12.1f',fill*100) '%']);

%%
%a=Z(t-1,:)>0;
if alivemodel==0
    a=alive(t-1,:)==1;
else
    a=Z(t-1,:)'>-2*H;
end
%a=Z(t-1,:)'>-H;%Are they alive???
%
d=0.5*(D(t)+D(t-1))/1000; %D -->diameter (mm)to m

%% Vertical velocity profile
viscosity=(1.79e-6)./(1+(0.03368*T(a))+(0.00021*(T(a).^2)));%m^2/s
Zb=Z(t-1,a)'+H(a);Zb(Zb<0.00001)=0.00001;
% Determine the selected data set.
str=get(handles.popup_roughness, 'String');
val=get(handles.popup_roughness,'Value');
% Set current data to the selected data set.
switch str{val};
    case 'Log Law Smooth Bottom Boundary (Case flumes)'  
        Vxz=ustar(a).*((1/0.41)*log((ustar(a).*Zb)./viscosity)+5.5);
    case 'Log Law Rough Bottom Boundary (Case rivers)' 
        ks=2.5*D_50(a)/1000;%m
        Vxz=ustar(a).*((1/0.41)*log(Zb./ks)+8.5);%Vxz of alive eggs
end
%% X
X(t,a)=X(t-1,a)'+(Dt*Vxz)+(normrnd(0,1,sum(a),1).*sqrt(2*DH(a)*Dt));
%reflecting Boundary
check=X(t,a);check(check<d/2)=d-check(check<d/2);X(t,a)=check;check=[];
X(t,~a)=X(t-1,~a);%If they were already dead,leave them in the same position.
%% Y
Y(t,a)=Y(t-1,a)'+(Dt*Vy(a))+(normrnd(0,1,sum(a),1).*sqrt(2*DH(a)*Dt));
Y(t,~a)=Y(t-1,~a);%If they were already dead,leave them in the same position.
%% Determine the selected Turbulent diffusivity model.
%B(a)=1;%1
if ustar(a)==0
    ed = errordlg('u* can not be equal to zero, try using a very small number different than zero','Error');
    set(ed, 'WindowStyle', 'modal');
    uiwait(ed);
    return
end
%%
B=1+(2*((abs(Vzpart(a))./ustar(a)).^2));
outrange=abs(Vzpart(a))./ustar(a);outrange=outrange>1;%Out of the function range
B(outrange)=3;%3
%%
ZR=Z(t-1,a)'+H(a);%ZR(ZR<0.1)=0.1;ZR(ZR>H(1)-0.1)=H(1)-0.1;
%%
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
      Kprime=B.*0.41.*ustar(a).*(1-(2*ZR./H(a)));%dimensionless
      Kprime(ZR./H(a)>=0.5)=0;  %constant portion
      Zprime=ZR+(0.5*Kprime*Dt);
      Kz=B.*0.41.*ustar(a).*Zprime.*(1-(Zprime./H(a)));%Calculated at ofset location 0.5K'Dt  %% Parabolic function
      Kz(ZR./H(a)>=0.5)=B(ZR./H(a)>=0.5).*0.25*0.41.*ustar(ZR./H(a)>=0.5).*H(ZR./H(a)>=0.5);  %% Constant
      Kz(Kz<B.*viscosity)=B(Kz<B.*viscosity).*viscosity(Kz<B.*viscosity);  %If eddy diffusivity is less than the water viscosity, use the water viscosity
end

%% Movement in Z
Z(t,a)=Z(t-1,a)'+Dt*(Vz(a)+Vzpart(a)+Kprime)+(normrnd(0,1,sum(a),1).*sqrt(2*Kz*Dt));%m
Z(t,~a)=-H(~a)+d/2;%If they were already dead,leave them in the bottom.
%% Check if eggs are in a new cell in this jump
%% Temporal variables
CumlDistance=temp_variables.CumlDistance;
Depth=temp_variables.Depth;
Q=temp_variables.Q;
VX=temp_variables.VX;
Vlat=temp_variables.Vlat;
Vvert=temp_variables.Vvert;
Ustar=temp_variables.Ustar;
Temp=temp_variables.Temp;
Width=temp_variables.Width;
D50=temp_variables.D50;
%%
   [c,~]=find(X(t,:)'>(CumlDistance(cell)*1000));
       for i=1:length(c)
        C=find(X(t,c(i))<CumlDistance*1000);
        if isempty(C)
            ed = errordlg('The cells domain have being exceeded please decrease the simulation time or add more cells to the domain','Error');
            set(ed, 'WindowStyle', 'modal');
            uiwait(ed);
            return
        end
        cell(c(i))=C(1);Cell=cell(c(i));%cell is the cell were an egg is
        %Vx(c(i))=VX(Cell); %m/s 
        Vz(c(i))=Vvert(Cell); %m/s 
        Vy(c(i))=Vlat(Cell); %m/s 
        H(c(i))=Depth(Cell); %m
        W(c(i))=Width(Cell); %m
        DH(c(i))=0.6*Depth(Cell)*Ustar(Cell);
        ustar(c(i))=Ustar(Cell);
        T(c(i))=Temp(Cell); 
        D_50(c(i))=D50(Cell); %mm
        %%
        %% Calculating the SG of esggs
        Rhoe(c(i))=(1004.5-0.20646*Temp(Cell))-((1004.5-0.20646*Ti)-(0.5*(Rhoe_i(t)+Rhoe_i(t-1))));%dimensionless.  Calculated at half timestep
        SG(c(i))=Rhoe(c(i))/Rhow(Cell);%dimensionless
        if SG(c(i))<1
            Vzpart(c(i))=0;
        end
        %% Dietrich
        Vzpart(c(i))=-Dietrich(0.5*(D(t)+D(t-1)),SG(c(i)),T(c(i)))/100;
        %% Iterative method
        %Vzpart(c(i))=-fzero(@(vs) vfallfun(vs,0.5*(D(t)+D(t-1)),SG(c(i)),T(c(i))),2)/100;  % Call optimizer, D should be in mm, vs output is in cm/s, then we convert it to m
        %Vzpart in m/s  Settling velocity calculated in t1+1/2
      end
   
%% Reflective Boundary   

   %% Reflective in Z
   %% If it overpasses the top 
   beggs=false(size(Z,2),1);
   btop=Z(t,:)'>-d/2;%surface -->calculated based on the total No of eggs
   while sum(btop)>0
       Z(t,btop)=-d-Z(t,btop);
       b=Z(t,:)'<-H(:)+d/2;% Is any egg overpasses the bottom
       if sum(b)>0 %if any egg touch the bottom get reflected...
           Z(t,b)=-Z(t,b)'-2*(H(b)-d/2);
           beggs=beggs|b; %this are the eggs that touched the bottom
       end
       btop=Z(t,:)'>-d/2;
   end
      %% If it overpasses the bottom
      b=Z(t,:)'<-H(:)+d/2;% Bottom _>need to check this outside the while too.  This is in case we overpassed just the bottom
   while sum(b)>0
       Z(t,b)=-Z(t,b)'-2*(H(b)-d/2);
       beggs=beggs|b;
       btop=Z(t,:)'>-d/2;%surface  
       if sum(btop)>0
           Z(t,btop)=-d-Z(t,btop);
       end
       b=Z(t,:)'<-H(:)+d/2;% Bottom
   end


   %% Reflective in Y
   check=Y(t,a);check(check<d/2)=d-check(check<d/2);Y(t,a)=check;check=[];
   check=Y(t,a);w=W(a)';check(check>w-d/2)=2*w(check>w-d/2)-d-check(check>w-d/2);Y(t,a)=check;check=[];
   Y(t,~a)=Y(t-1,~a);%If they were already dead,leave them in the same position.

%% Alive or dead ??
if alivemodel==0
    alive(t,:)=alive(t-1,:);%If it was dead...it continue dead
    Mortality_model=2;
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
            EggsInDanger=beggs;%Eggs in the danger of dying that are still alive
            Mortality=Mortality+0.01*sum(EggsInDanger);
            if  fix(Mortality)>=1
                index=randperm(sum(EggsInDanger));%randomly organize eggs that can die
                [Id,~]=find(EggsInDanger==1);%Tells the Id of eggs in danger
                for k=1:Mortality
                    alive(t,Id(index(k)))=0; %randomly select one egg in danger Id(index(k))
                end
            end
            Mortality=Mortality-fix(Mortality);
    end
%% At which cell the egg dye??
    celldead(alive(t,:)==0)=cell(alive(t,:)==0);
end
%Rhoet(t)=Rhoe(1);
VsT(t,:)=Vzpart';
%%
end
%%
outputfile=['./results/Results_', get(handles.edit_River_name, 'String'),'_',get(handles.Totaltime, 'String'),'h_', ...
                            get(handles.Dt, 'String'),'s' '.mat'];
hFluEggGui=getappdata(0,'hFluEggGui');
setappdata(hFluEggGui, 'outputfile', outputfile);
%%                        
ResultsSim.X=X;
ResultsSim.Y=Y;
ResultsSim.Z=Z;
ResultsSim.time=time;
ResultsSim.touch=touch;
ResultsSim.D=D;
ResultsSim.alive=alive;
ResultsSim.CumlDistance=CumlDistance;
ResultsSim.Depth=Depth;
ResultsSim.Width=Width;
ResultsSim.VX=VX;
ResultsSim.Temp=Temp;
ResultsSim.specie=specie;
save(outputfile,'ResultsSim','-mat');
%save(['./results/Results', get(handles.edit_River_name, 'String'),get(handles.Totaltime, 'String'),'h', ...
%                            get(handles.Dt, 'String'),'s' '.mat'],'ResultsSim','-mat');
%%
%save(outputfile,'X','Y','Z','time','VsT','touch','D','alive','-mat');%,'-append');%'D','Rhoet'
end