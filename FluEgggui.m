function [handles]=ACETgui(hObject, eventdata,handles)
alivemodel=1;
%=========================================================================
%% Lagrangian Random Walk Model for Silver Carp Eggs Transport
%
% Written by Tatiana Garcia, University of Illinois, 2011
% Version 3.0
% Include Cells with different hydrodynamic conditions
%% =======================================================================
%close all;clc;clear;
advection=0;%pure advection case
%% =======================================================================
load './Temp/temp_variables.mat' 
%===========
Eggs=handles.userdata.Num_Eggs;%make sure you can take the cubic root of it.(e.g 27,64,125)
Xi=handles.userdata.Xi;Yi=handles.userdata.Yi;Zi=handles.userdata.Zi;%Spawning location in m
Fcell=handles.userdata.Fcell;
%% =======================================================================
%% Delta t is constant
Totaltime=handles.userdata.Totaltime*3600;%seconds
Dt=handles.userdata.Dt; %time step in seconds
Steps=Totaltime/Dt;
time=0:Dt:Totaltime;t=1; %Time is in seconds
%% print set up
print=(0.02:5:Totaltime);%print every n minute

%% =======================================================================
%% pre-allocate memory and intialization of variables
X=zeros(Steps,Eggs);Y=zeros(Steps,Eggs);Z=zeros(Steps,Eggs);
alive=ones(1,Eggs);celldead=zeros(1,Eggs);cell=zeros(1,Eggs);Vx=cell;
Vz=cell;H=cell;W=cell;DH=cell;ustar=cell;SG=cell;T=cell;Vzpart=cell;
counter=1;X(1,:)=Xi;Y(1,:)=Yi;Z(1,:)=Zi;Dead_t=cell;

%% ========================================================================
constantRhoe=get(handles.popup_EggsChar,'Value');% if constantRhoe=1 the ...
%model would use a constant Rhoe and D
if constantRhoe==2
load BioDuaneData
Dmin=min(Diam);Vsmax=max(vs);
[D,Vzpart] = Bio(time,Dmin,Vsmax,DiamStd,VsStd); %change this to Rhoegg, include bighead
else 
    D=str2double(get(handles.ConstD,'String'));%mm
    D=D*ones(1,length(time));
    Rhoe=str2double(get(handles.ConstRhoe,'String'));
    Rhoe=Rhoe*ones(1,length(time));   
end

%% Calculate water density
Rhow=density(Temp); %Here we calculate the water density in every cell

%% Channel geometry and initial data
Vy=0; %m/s 
for i=1:Eggs
    C=find(X(t,i)<CumlDistance*1000);cell(i)=C(1);
    Vx(i)=sqrt(Vmag(cell(i))^2-Vy^2); %m/s 
    Vz(i)=Vvert(cell(i)); %m/s 
    H(i)=Depth(cell(i)); %m
    W(i)=Q(cell(i))/(Vmag(cell(i))*H(cell(i))); %m    
    ustar(i)=Ustar(cell(i));
    T(i)=Temp(cell(i));
    %% Calculating the SG of esggs
    SG(i)=Rhoe(1)/Rhow(cell(i));%dimensionless
    %======================================================================
    %% Pure advection case
    if advection==1
    DH(i)=0;
    else        
        %% Explicit Lagrangian Horizontal Diffusion
        DH(i)=0.6*H(i)*ustar(i);
    end    
end
Vzpart=-fzero(@(vs) vfallfun(vs,D(1),SG(1),T(1)),2)/100;  % Call optimizer, D should be in mm, vs output is in cm/s, then we convert it to m
Vzpart=Vzpart*ones(1,Eggs); %Initially all the eggs have the same Vs

clear Xi Yi Zi Dmin Vsmax DiamStd VsStd Diam vs

%% GUI
centralfig=handles.centralfig;
cubes
plotallKm
title(centralfig,['Time=',num2str(time(t)/60),' minutes','   ',num2str(round(D(t)*10)/10),'mm Diameter'],'FontSize',12)
pause(3)
h=handles.waittbar;
set(handles.waittbar,'Visible','on')
set(handles.text22,'Visible','on')
rectangle('Position',[0 0 1 0.5],'Parent',h,'FaceColor','w','EdgeColor','k');
set(h,'XTickLabel',[],'YTickLabel',[]);
%%
for t=2:Steps+1
    fill=time(t)/Totaltime;
    rectangle('Position',[0 0 fill 0.5],'Parent',h,'FaceColor','r','EdgeColor','none');  
    %%
    [X,Y,Z,D,alive]=Jump(handles,advection,t,X,Dt,Vx,DH,Y,Vy,W,D,Vz,Z,Vzpart,H,ustar,alive,T);
    [~,c]=find(X(t,:)>(CumlDistance(cell)*1000)');
    % [~,c]=find(X(t,:)>(CumlDistance(cell)*1000));
    
      for i=1:length(c)
        cell(c(i))=cell(c(i))+1;Cell=cell(c(i));%cell is the cell were an egg is
        Vx(c(i))=sqrt(Vmag(Cell)^2-Vy^2); %m/s 
        Vz(c(i))=Vvert(Cell); %m/s 
        H(c(i))=Depth(Cell); %m
        W(c(i))=Q(Cell)/(Vmag(Cell)*Depth(Cell)); %m
        DH(c(i))=0.6*Depth(Cell)*Ustar(Cell);
        ustar(c(i))=Ustar(Cell);
        T(c(i))=Temp(Cell); 
        SG(c(i))=0.5*(Rhoe(t)+Rhoe(t-1))/Rhow(Cell);%dimensionless.  Calculated at half timestep
        Vzpart(c(i))=-fzero(@(vs) vfallfun(vs,0.5*(D(t)+D(t-1)),SG(c(i)),T(c(i))),2)/100;  % Call optimizer, D should be in mm, vs output is in cm/s, then we convert it to m
        %Vzpart in m/s  Settling velocity calculated in t1+1/2
      end
      
    %% At which cell the egg dye??
    celldead(alive==0)=cell(alive==0);
    %%
%     if (round(time(t)*100/60)/100)>=print(counter)
%         plotallKm
%         title(centralfig,['Time=',num2str(time(t)/60),' minutes','   ',num2str(round(D(t)*10)/10),'mm Diameter'],'FontSize',12)
%         pause(0.1)        
%     end  
%     if sum(alive)==0
%         break
%     end
end

%%
save('./results/results.mat','X','Y','Z','D','time','alive','celldead','-append');
% %% ===================
 for i=1:Eggs
 tind=find(Z(:,i)<=0,1);
 if length(tind)>1
 Dead_t(i)=time(tind)/60;
 else
     Dead_t(i)=0;
 end
 end
 %%
 function Plotlim(CumlDistance,Width,Depth,hObject, eventdata, handles)
 set(handles.MinX,'String',0);
 set(handles.MaxX,'String',max(CumlDistance));
 set(handles.MinW,'String',0);
 set(handles.MaxW,'String',max(Width));
 set(handles.MinH,'String',-max(Depth));
 set(handles.MaxH,'String',0);
 guidata(hObject, handles);