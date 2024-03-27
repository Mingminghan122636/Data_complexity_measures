function [Data_N3,Data_N3_1vR] = N3_features(x,y)
    Data_N3=[];        
    Data_N3_1vR=[];
    
    N3=0;
    Error_num=0;
    for i=1:size(x,1)
        [Intra_i,Inter_i]=Find_Intra_Inter_Instance(x(i,:),y(i),x,y);
        Dis_Intra=norm(x(i,:)-Intra_i);
        Dis_Inter=norm(x(i,:)-Inter_i);
        if Dis_Inter<=Dis_Intra
            Error_num=Error_num+1;
        end
    end
    Data_N3=Error_num/size(x,1);
    
    class_info=unique(y);
    for mm=1:length(class_info)
        Error_num_i=0;
        class_i=x(y==class_info(mm),:);
        for iii=1:size(class_i,1)
            [Intra_i,Inter_i]=Find_Intra_Inter_Instance(class_i(iii,:),class_info(mm),x,y);
            Dis_Intra=norm(class_i(iii,:)-Intra_i);
            Dis_Inter=norm(class_i(iii,:)-Inter_i);
            if Dis_Inter<=Dis_Intra
                Error_num_i=Error_num_i+1;
            end
        end
        N3_i=Error_num_i/size(class_i,1);
        Data_N3_1vR=[Data_N3_1vR;N3_i];
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