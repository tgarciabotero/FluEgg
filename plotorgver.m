%% User View Setup
rotate3d on
newView=round(get(handles.centralfig,'View'));
zamp=get(handles.zamp,'Value');%200
yamp=get(handles.yamp,'Value');
font = 'Helvetica';
fontsize = 8;
set(centralfig,'color',[0.95 0.95 0.95])
%%
scatter3(centralfig,X(t,:)/1000,Y(t,:)*yamp,Z(t,:)*zamp,1.3*20,'y','MarkerFaceColor','flat','MarkerEdgeColor',[0 0 0]);
Drawing_cubes
box(centralfig,'on');
%axis(centralfig,'equal');
%axis(centralfig,'vis3d');
set(centralfig, 'View', newView);
%pbaspect([8 1 2])
%%
xlim(centralfig,[0 CumlDistance(Fcell)]); %CumlDistance(end)*1000]);%CumlDistance(Fcell)*1000
ylim(centralfig,[0 max(Width(1:Fcell))*yamp]);%635.2
zlim(centralfig,[-max(Depth(1:Fcell))*zamp 0]);%-2.5*zamp
set(gca,'XTick',[0:CumlDistance(Fcell)/4:CumlDistance(Fcell)],'XTickLabel',[0:CumlDistance(Fcell)/4:CumlDistance(Fcell)],'FontName',font,'FontSize',fontsize);
set(centralfig,'YTick',[0:max(Width(1:Fcell))/2:max(Width(1:Fcell))]*yamp,'YTickLabel',[0:max(Width(1:Fcell))/2:max(Width(1:Fcell))],'FontName',font,'FontSize',fontsize);
set(centralfig,'ZTick',[-max(Depth(1:Fcell)):max(Depth(1:Fcell))/2:0]*zamp,'ZTickLabel',[-max(Depth(1:Fcell)):max(Depth(1:Fcell))/2:0],'FontName',font,'FontSize',fontsize);
%%
xlabel(centralfig,'Distance in X(km)','FontSize',fontsize);
ylabel(centralfig,'Width(m)','FontSize',fontsize);
zlabel(centralfig,'Water depth(m)','FontSize',fontsize);

