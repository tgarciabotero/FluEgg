%% Egg Vertical Concentration Distribution
load './Temp/temp_variables.mat' 
    Dist_X=str2double(get(handles.X,'String'));
    Nlayers=str2double(get(handles.Nlayers,'String'));
    cell=find((CumlDistance)*1000>=Dist_X);cell=cell(1);
    H=Depth(cell);
%% 
if handles.update==0
    if handles.eddit==1
        Nodes=get(handles.Nodes,'Data');Nodes=Nodes(:,1);
        extra=str2double(get(handles.Extra_node,'String'));
        Nodes=[extra; Nodes];
    else
        Nodes=0:-H/(Nlayers):-H;    Nodes=Nodes';
    end
end
if handles.update==1
    Nodes=get(handles.Nodes,'Data');Nodes=Nodes(:,1);
end    
Nodes=sort(Nodes,'ascend');
sortedNodes=sort(Nodes,'descend');
set(handles.Nodes,'Data',[sortedNodes (sortedNodes+H)/H]);%Nodes of the layers in model coordinates
Nodes=get(handles.Nodes,'Data');%Nodes=Nodes(:,1);
save('./results/results.mat','Dist_X','Nodes','-append')