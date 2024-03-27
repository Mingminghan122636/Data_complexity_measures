
function [Data_F2,Data_F2_1vR] = F2_features(x,y)
    Data_F2=[];        
    Data_F2_1vR=[]; 
    
    class_info=unique(y);
    class_num=length(class_info);
    F3=0;
    for c1=1:class_num
            class_p=x(y==class_info(c1),:);
            class_n=x(y~=class_info(c1),:);
            F31=1;
            F32=1;
            for i=1:size(x,2)
                min_p_i=min(class_p(:,i));
                max_p_i=max(class_p(:,i));
                min_n_i=min(class_n(:,i));
                max_n_i=max(class_n(:,i));
                Overlap1=max([0,min([max_p_i,max_n_i])-max([min_p_i,min_n_i])]);
                Overlap=Overlap1/(max([max_p_i,max_n_i])-min([min_p_i,min_n_i]));
                F31=F31*Overlap;
                Overlap_i=Overlap1/(max_p_i-min_p_i);
                F32=F32*Overlap_i;
            end 
            F3=F3+F31;
            Data_F2_1vR=[Data_F2_1vR;F32]; 
    end
    F3=F3/class_num;
    Data_F2=F3/(1+F3);
end