%N2 Intra class / Inter class Nearest neighbor distance
function [Data_N2,Data_N2_1vR] = N2_features(x,y)
    Data_N2=[];        
    Data_N2_1vR=[]; 
    
N2=0;
Intra=0;
Inter=0;
for i=1:size(x,1)
    [Intra_i,Inter_i]=Find_Intra_Inter_Instance(x(i,:),y(i),x,y);
    Dis_Intra=norm(x(i,:)-Intra_i);
    Dis_Inter=norm(x(i,:)-Inter_i);
    Intra=Intra+Dis_Intra;
    Inter=Inter+Dis_Inter;
end
N2=Intra/Inter;
Data_N2=N2/(N2+1);

class_info=unique(y);
    for mm=1:length(class_info)
        Intra_ii=0;
        Inter_ii=0;
        class_i=x(y==class_info(mm),:);
        for iii=1:size(class_i,1)
            [Intra_i,Inter_i]=Find_Intra_Inter_Instance(class_i(iii,:),class_info(mm),x,y);
            Dis_Intra_i=norm(class_i(iii,:)-Intra_i);
            Dis_Inter_i=norm(class_i(iii,:)-Inter_i);
            Intra_ii=Intra_ii+Dis_Intra_i;
            Inter_ii=Inter_ii+Dis_Inter_i;
        end
        N2_i=Intra_ii/Inter_ii;
        N2_i=N2_i/(N2_i+1);
        Data_N2_1vR=[Data_N2_1vR;N2_i];    
    end
    
end
function [Intra_i,Inter_i]=Find_Intra_Inter_Instance(P_x,P_y,x,y)
Same_x=x(y==P_y,:);
Same_x=setdiff(Same_x,P_x);
Diff_x=x(y~=P_y,:);
Diff_x=setdiff(Diff_x,P_x);
Dis_same=[];
Dis_diff=[];
for i=1:size(Same_x)
    Dis_same=[Dis_same;norm(Same_x(i,:)-P_x)];
end
Intra_i=Same_x(find(Dis_same==min(Dis_same)),:);
Intra_i=Intra_i(1,:);
for j=1:size(Diff_x)
    Dis_diff=[Dis_diff;norm(Diff_x(j,:)-P_x)];
end
Inter_i=Diff_x(find(Dis_diff==min(Dis_diff)),:);
Inter_i=Inter_i(1,:);
end