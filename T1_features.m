% T1 Cover Ball
function [Data_T1,Data_T1_1vR] = T1_features(x,y)
Data_T1_1vR=[];
Data_T1=0;

R_i=zeros(size(x,1),1);
for i=1:size(x,1)
    R_i(i)=Radius_i(x,y,i);
end
[Center,R_center,R_point,count_Cir,count_Cir_set]=Circle_Remove(x,y,R_i);
Data_T1=count_Cir/size(x,1);
Data_T1_1vR=count_Cir_set;
end
function R_i=Radius_i(x,y,i)
Index_I_enemy_X=Near_enemy(x,y,i);
D_i_enemy=norm(x(i,:)-x(Index_I_enemy_X,:));

Index_I_enemy_enemy_X=Near_enemy(x,y,Index_I_enemy_X);
if i==Index_I_enemy_enemy_X
    R_i=D_i_enemy/2;
else
    R_Index_I_enemy_X=Radius_i(x,y,Index_I_enemy_X);
    R_i=D_i_enemy-R_Index_I_enemy_X;
end
end
function Index_I_enemy_X =Near_enemy(x,y,i)
Dist=squareform(pdist(x));
index_Not_y=find(y~=y(i));
Dist_i_enemy=Dist(i,index_Not_y);
Index_I_enemy=find(Dist_i_enemy==min(Dist_i_enemy));
Index_I_enemy=Index_I_enemy(1);
Index_I_enemy_X=index_Not_y(Index_I_enemy);
end
function [Center,R_center,R_point,count_Cir,count_Cir_set]=Circle_Remove(x,y,R_i)
% 为每个类确定最终的超球个数，并确定圆心。半径。包含样本数
class_info=unique(y);
class_num=length(class_info);
Center=[];
R_center=[];
count_Cir_set=[];
count_Cir=0;
for i=1:class_num
    Index_i=find(y==class_info(i));
    Select_x=x(Index_i,:);
    Select_R=R_i(Index_i,:);
    Cir_tag=ones(length(Index_i),1);
    count_Cir_i=0;
    while length(Cir_tag)>0
        if length(Cir_tag)==1
            count_Cir_i=count_Cir_i+1;
            Center=[Center;[Select_x(1,:),class_info(i)]];
            R_center=[R_center;Select_R(1)];
            R_point{count_Cir_i,1}=Select_x(1,:); 
            Cir_tag=[];
            Select_x=[];
            Select_R=[];     
        else
            [Select_R,Order_R]=sort(Select_R,'descend');
            Select_x=Select_x(Order_R,:);
            Cir_tag=Cir_tag(Order_R);
            DD=squareform(pdist(Select_x));
            Less_R=find(DD(1,:)<=Select_R(1)); % 每个超求的样本数

            count_Cir_i=count_Cir_i+1;
            Center=[Center;[Select_x(1,:),class_info(i)]];
            R_center=[R_center;Select_R(1)];
            R_point{count_Cir_i,1}=Select_x(Less_R,:);

            Cir_tag(Less_R)=[];
            Select_x(Less_R,:)=[];
            Select_R(Less_R)=[];               
        end
    end  
    count_Cir_set=[count_Cir_set;count_Cir_i/sum(y==class_info(i))];
    count_Cir=count_Cir+count_Cir_i;
end
end
