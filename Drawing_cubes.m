%% Drawing cubes
patch(x,y,z,colorp) %Back face
hold on
patch(x,yb,zb,colorp)%Bottom face
patch(x,yb,zt,'w','FaceAlpha',0.02)%Top face
patch(x,yf,z,'w','FaceAlpha',0.02) %Front face
%set(centralfig,'XTickLabel',[]);
bar=colorbar('peer',centralfig,'CLim',[0 1.2]);
colorbar('XTick',[0:0.2:1.2],'YTickLabel',[0:0.2:1.2])
bar=colorbar('location','northoutside');set(get(bar,'xlabel'),'String', 'Cell Vmag [m/s]');clear bar
bar=findobj(gcf,'Tag','Colorbar');
% initpos=get(bar,'Position');
% set(bar,'Position',[initpos(1)+initpos(3)*0.25 initpos(2)+initpos(4)*0.25 ...
%       initpos(3)*0.5 initpos(4)*0.5]);
set(bar,'Position',[0.73 0.11 0.25 0.018]);
set(centralfig, 'View', newView);
hold off