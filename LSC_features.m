function [Data_LSC,Data_LSC_1vR] = LSC_features(x,y)
Data_LSC_1vR=[];
LSC_num=0;
for ii=1:size(x,1)
    Same_x=x(y==y(ii),:);
    Same_x=setdiff(Same_x,x(ii,:));
    Diff_x=x(y~=y(ii),:);
    Diff_x=setdiff(Diff_x,x(ii,:));
    Dis_same=[];
    Dis_diff=[];
    for j=1:size(Diff_x)
        Dis_diff=[Dis_diff;norm(Diff_x(j,:)-x(ii,:))];
    end
    Min_Inter=min(Dis_diff);
    for i=1:size(Same_x)
        Dis_same=[Dis_same;norm(Same_x(i,:)-x(ii,:))];
    end
    Less_Inter_num=sum(Dis_same<Min_Inter);
    LSC_num=LSC_num+Less_Inter_num;
end
Data_LSC=1-LSC_num/(size(x,1)^2);

    class_info=unique(y);
    for mm=1:length(class_info)
        LSC_num_i=0;
        class_i=x(y==class_info(mm),:);
        for iii=1:size(class_i,1)
            Same_x=class_i;
            Same_x=setdiff(Same_x,class_i(iii,:));
            Diff_x=x(y~=class_info(mm),:);
            Diff_x=setdiff(Diff_x,class_i(iii,:));
            Dis_same_i=[];
            Dis_diff_i=[];
            for j=1:size(Diff_x)
                Dis_diff_i=[Dis_diff_i;norm(Diff_x(j,:)-class_i(iii,:))];
            end
            Min_Inter_i=min(Dis_diff_i);
            for i=1:size(Same_x)
                Dis_same_i=[Dis_same_i;norm(Same_x(i,:)-class_i(iii,:))];
            end
            Less_Inter_num_i=sum(Dis_same_i<Min_Inter_i);
            LSC_num_i=LSC_num_i+Less_Inter_num_i;          
        end
        LSC_num_i=1-LSC_num_i/(size(class_i,1)^2);
        Data_LSC_1vR=[Data_LSC_1vR;LSC_num_i];
    end
    
end