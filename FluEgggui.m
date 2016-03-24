function [handles]=FluEgggui(hObject, eventdata,handles)
%=========================================================================
%% Lagrangian Random Walk Model for Silver Carp Eggs Transport
%
% Written by Tatiana Garcia, University of Illinois, 2011
% Version 4.0
% Take out central figure
%tic
%% Iniciate Waitbar
h = waitbar(0,'Initializing variables...','Name','Eggs drifting...',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
setappdata(h,'canceling',0)
%%
alivemodel=0;  %if alivemodel=1 the eggs would not die
%% =======================================================================
load './Temp/temp_variables.mat' 
CumlDistance=temp_variables.CumlDistance;
Depth=temp_variables.Depth;
Q=temp_variables.Q;
VX=temp_variables.VX;
Vlat=temp_variables.Vlat;
Vvert=temp_variables.Vvert;
Ustar=temp_variables.Ustar;
Temp=temp_variables.Temp;
Width=temp_variables.Width;
ks=temp_variables.ks;
%===========
Eggs=handles.userdata.Num_Eggs;%make sure you can take the cubic root of it.(e.g 27,64,125)
Xi=handles.userdata.Xi;Yi=handles.userdata.Yi;Zi=handles.userdata.Zi;%Spawning location in m
%% =======================================================================
%% Delta t is constant
Totaltime=handles.userdata.Totaltime*3600;%seconds
Dt=handles.userdata.Dt; %time step in seconds
Steps=Totaltime/Dt;
time=0:Dt:Totaltime;t=1; %Time is in seconds
%% =======================================================================
%% pre-allocate memory and intialization of variables
X=zeros(Steps+1,Eggs);Y=zeros(Steps+1,Eggs);Z=zeros(Steps+1,Eggs);
alive=ones(Steps+1,Eggs);celldead=zeros(Eggs,1);cell=zeros(Eggs,1);
Vx=cell;Vy=cell;Vz=cell;H=cell;W=cell;DH=cell;ustar=cell;SG=cell;T=cell;%Vx=cell
X(1,:)=Xi;Y(1,:)=Yi;Z(1,:)=Zi;Dead_t=cell;KS=cell;Rhoe=cell;
touch=zeros(Steps+1,Eggs);%counter to calculate how many eggs touched the bottom every time step
VsT=zeros(Steps,Eggs);
%% ========================================================================
waitbar(0,h,['Please wait....' 'Running growth model']);   
%%Eggs biological properties
 specie=get(handles.Silver,'Value');  %Need to comment this for now
if specie==1
     specie={'Silver'};
else
     specie={'Bighead'};
end
% Determine the selected data set.
str=get(handles.popup_EggsChar, 'String');
val=get(handles.popup_EggsChar,'Value');
% Set current data to the selected data set.
switch str{val};
    case 'Use constant egg diameter and density' %%model would use a constant Rhoe and D 
        D=str2double(get(handles.ConstD,'String'));%mm
        D=D*ones(length(time),1);
        Rhoe_ref=str2double(get(handles.ConstRhoe,'String'));
        Rhoe_ref=Rhoe_ref*ones(length(time),1);      
        Tref=str2double(get(handles.Tref,'String'));
    case 'Use diameter and egg density time series (Chapman, 2011)'
        Tref=22; %C
       [D,Rhoe_ref]=EggBio(time,specie); %include bighead   
end
%% Calculate water density
Rhow=density(Temp); %Here we calculate the water density in every cell
%% Channel geometry and initial data
for i=1:Eggs
    C=find(X(t,i)<CumlDistance*1000);cell(i)=C(1);
    Vx(i)=VX(cell(i)); %m/s 
    Vz(i)=Vvert(cell(i)); %m/s 
    Vy(i)=Vlat(cell(i)); %m/s 
    H(i)=Depth(cell(i)); %m
    W(i)=Width(cell(i)); %m    
    ustar(i)=Ustar(cell(i));
    T(i)=Temp(cell(i));
    KS(i)=ks(cell(i)); %mm
    %% Calculating the SG of esggs
    %Rhoe(i)=(1004.5-0.20646*Temp(cell(i)))-((1004.5-0.20646*Tref)-Rhoe_ref(t));
    Rhoe(i)=Rhoe_ref(t)+0.20646*(Tref-Temp(cell(i)));
    SG(i)=Rhoe(i)/Rhow(cell(i));%dimensionless
    %======================================================================      
    %% Explicit Lagrangian Horizontal Diffusion
    DH(i)=0.6*H(i)*ustar(i);
end  
%% Calculating Fall velocity
%% Dietrich's
Vzpart=-Dietrich(D(t),SG(1),T(1))/100;%D should be in mm, vs output is in cm/s, then we convert it to m
%display(max(Vzpart))%used to calculate Dt
%% Iterative method
%Vzpart=-fzero(@(vs) vfallfun(vs,D(t),SG(1),T(1)),20)/100;  % Call optimizer, D should be in mm, vs output is in cm/s, then we convert it to m
% if isnan(Vzpart)
%     ed = errordlg('There is a problem trying to find Vs, please contact the administrator','Error');
%     set(ed, 'WindowStyle', 'modal');
%     uiwait(ed);
% end

Vzpart=Vzpart*ones(Eggs,1); %Initially all the eggs have the same Vs
%%
clear Xi Yi Zi Dmin Vsmax DiamStd VsStd Diam vs C
%Rhoet(t)=Rhoe(1);
VsT(t,:)=Vzpart';
Jump(Steps,time,Totaltime,h,alivemodel,handles,X,Dt,DH,Y,Vy,W,D,Vz,Z,Vzpart,H,ustar,alive,celldead,T,KS,touch,cell,Rhoe,SG,VsT,Tref,Rhoe_ref,Rhow,temp_variables,specie);   
%toc;
%display(toc)

% Total_perTime=sum(touch,2);
% plot(time(2:end),Total_perTime);
% bar(time(2:end),Total_perTime);
% 

