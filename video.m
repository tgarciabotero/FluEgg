figure('color',[1 1 1]);
%%
colormap([0.6 1 1;0.57 0.97 1;0.54 0.94 1;0.51 0.9 1;0.49 0.89 1;0.46 0.88 1;0.43 0.83 1;0.4 0.8 1;0.39 0.79 1;0.375 0.775000035762787 1;0.362500011920929 0.762499988079071 1;0.349999994039536 0.75 1;0.337500005960464 0.737500011920929 1;0.325000017881393 0.725000023841858 1;0.3125 0.712500035762787 1;0.300000011920929 0.700000047683716 1;0.287499994039536 0.6875 1;0.275000005960464 0.675000011920929 1;0.262500017881393 0.662500023841858 1;0.25 0.650000035762787 1;0.237499997019768 0.637500047683716 1;0.225000008940697 0.625 1;0.212500005960464 0.612500011920929 1;0.200000002980232 0.600000023841858 1;0.1875 0.587500035762787 1;0.174999997019768 0.575000047683716 1;0.162500008940697 0.5625 1;0.150000005960464 0.550000011920929 1;0.137500002980232 0.537500023841858 1;0.125 0.525000035762787 1;0.112500004470348 0.512499988079071 1;0.100000001490116 0.5 1;0.0874999985098839 0.487500011920929 1;0.0750000029802322 0.475000023841858 1;0.0625 0.462500005960464 1;0.0500000007450581 0.450000017881393 1;0.0375000014901161 0.4375 1;0.025000000372529 0.425000011920929 1;0.0125000001862645 0.412499994039536 1;0 0.400000005960464 1;0 0.387500017881393 0.987500011920929;0 0.375 0.975000023841858;0 0.362500011920929 0.962499976158142;0 0.349999994039536 0.949999988079071;0 0.337500005960464 0.9375;0 0.325000017881393 0.925000011920929;0 0.3125 0.912500023841858;0 0.300000011920929 0.899999976158142;0 0.287499994039536 0.887499988079071;0 0.275000005960464 0.875;0 0.262500017881393 0.862500011920929;0 0.25 0.850000023841858;0 0.237499997019768 0.837500035762787;0 0.225000008940697 0.824999988079071;0 0.212500005960464 0.8125;0 0.200000002980232 0.800000011920929;0 0.174999997019768 0.775000035762787;0 0.150000005960464 0.75;0 0.125 0.72;0 0.1 0.700000047683716;0 0.075 0.675;0 0.05 0.65;0 0.025 0.625;0 0 0.6]);
xo=0;
%% Cells to plot
Fcell=4;
for k=1:Fcell%length(CumlDistance)%Fcell
    if k>1
        xo=CumlDistance(k-1);
    end
x(:,k)=[xo CumlDistance(k) CumlDistance(k) xo];
y(:,k)=[Width(k) Width(k) Width(k) Width(k)];
z(:,k)=[-Depth(k) -Depth(k) 0 0 ]; %[0 0 Depth(k) Depth(k)];
colorp(:,k)=[Vmag(k) Vmag(k) Vmag(k) Vmag(k)];
yb(:,k)=[0 0 Width(k) Width(k)];
yf(:,k)=[0 0 0 0];
zb(:,k)=[-Depth(k) -Depth(k) -Depth(k) -Depth(k)];%[0 0 0 0];
zt(:,k)=[0 0 0 0];%[Depth(k) Depth(k) Depth(k) Depth(k)];
end
%%
for t=1:length(time) 
    %%
rotate3d on
newView=round(get(gca,'View'));
zamp=0.2;%200
yamp=1;
font = 'Helvetica'; fontsize = 8;
set(gca,'color',[0.95 0.95 0.95])
%%
scatter3(X(t,:)/1000,Y(t,:),Z(t,:),1.3*20,'y','MarkerFaceColor','flat','MarkerEdgeColor',[0 0 0]);
%%
%% Drawing cubes
patch(x,y,z,colorp) %Back face
hold on
patch(x,yb,zb,colorp)%Bottom face
patch(x,yb,zt,'w','FaceAlpha',0.02)%Top face
patch(x,yf,z,'w','FaceAlpha',0.02) %Front face
bar=colorbar('CLim',[0 1.2]);
colorbar('XTick',[0:0.2:1.2],'YTickLabel',[0:0.2:1.2])
bar=colorbar('location','northoutside');set(get(bar,'xlabel'),'String', 'Cell Vmag [m/s]');clear bar
bar=findobj(gcf,'Tag','Colorbar');
set(bar,'Position',[0.73 0.11 0.25 0.018]);
hold off
%%
box('on');
grid('off')
view([-3 2]);
%view(newView);
daspect([0.1 yamp zamp])
%%
xlim([0 CumlDistance(Fcell)]); 
ylim([0 max(Width(1:Fcell))]);
zlim([-max(Depth(1:Fcell)) 0]);
% set('YTick',[0:max(Width(1:Fcell))/2:max(Width(1:Fcell))],'YTickLabel',[0:max(Width(1:Fcell))/2:max(Width(1:Fcell))],'FontName',font,'FontSize',fontsize);
%%
xlabel('Distance in X(km)','FontSize',fontsize);
ylabel('Width(m)','FontSize',fontsize);
zlabel('Water depth(m)','FontSize',fontsize);
%%
title(['Time=',num2str(time(t)/60),' minutes','   ',num2str(round(D(t)*10)/10),'mm Diameter'],'FontSize',12)
        pause(0.1)        
end  
   