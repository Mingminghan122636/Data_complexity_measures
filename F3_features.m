function [Data_F3,Data_F3_1vR] = F3_features(x,y)
    Data_F3=[];        
    Data_F3_1vR=[]; 
    
class_info=unique(y);
class_num=length(class_info);
F3=0;
for c1=1:class_num
        class_p=x(y==class_info(c1),:);
        class_n=x(y~=class_info(c1),:);
        F31=zeros(size(x,2),2);
        F31_num=zeros(1,size(x,2));
        F31_num_i=zeros(1,size(x,2));
        for i=1:size(x,2)
            count_overlap=0;
            count_overlap_i=0;
            min_p_i=min(class_p(:,i));
            max_p_i=max(class_p(:,i));
            min_n_i=min(class_n(:,i));
            max_n_i=max(class_n(:,i));
            F31(i,:)=[max([min_p_i,min_n_i]),min([max_p_i,max_n_i])];
            TT=[class_p(:,i);class_n(:,i)];
            for num_TT=1:size(TT,1)
                if TT(num_TT)>F31(i,1) & TT(num_TT)<F31(i,2)
                    count_overlap=count_overlap+1;
                end
            end
            F31_num(i)=count_overlap/size(TT,1);      
            
            for mm=1:size(class_p,1)
                if class_p(mm,i)>F31(i,1) & class_p(mm,i)<F31(i,2)
                    count_overlap_i=count_overlap_i+1;
                end
            end
            F31_num_i(i)=count_overlap_i/size(class_p,1);          
        end 
        F3=F3+min(F31_num);
        Data_F3_1vR=[Data_F3_1vR;min(F31_num_i)]; 
end
Data_F3=F3/class_num;
Data_F3=Data_F3/(1+Data_F3);
end