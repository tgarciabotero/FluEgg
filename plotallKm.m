%% User View Setup
rotate3d on
newView=round(get(handles.centralfig,'View'));
zamp=get(handles.zamp,'Value');%200
yamp=get(handles.yamp,'Value');
font = 'Helvetica'; fontsize = 8;
set(centralfig,'color',[0.95 0.95 0.95])
%%
scatter3(centralfig,X(t,:)/1000,Y(t,:),Z(t,:),1.3*20,'y','MarkerFaceColor','flat','MarkerEdgeColor',[0 0 0]);
Drawing_cubes
box(centralfig,'on');
grid(centralfig,'off')
set(centralfig, 'View', newView);
daspect([0.1 yamp zamp])
%%
xlim(centralfig,[0 CumlDistance(Fcell)]); 
ylim(centralfig,[0 max(Width(1:Fcell))]);
zlim(centralfig,[-max(Depth(1:Fcell)) 0]);
set(centralfig,'YTick',[0:max(Width(1:Fcell))/2:max(Width(1:Fcell))],'YTickLabel',[0:max(Width(1:Fcell))/2:max(Width(1:Fcell))],'FontName',font,'FontSize',fontsize);
%%
xlabel(centralfig,'Distance in X(km)','FontSize',fontsize);
ylabel(centralfig,'Width(m)','FontSize',fontsize);
zlabel(centralfig,'Water depth(m)','FontSize',fontsize);

