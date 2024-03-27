% IBI^3
function [Data_B3,Data_B3_1vR] = BI3_features(x,y,K_para)
Data_B3_1vR=[];
Data_B3=0;

class_info=unique(y);
class_num=length(class_info);
for kk=1:class_num
    class_i=x(y==class_info(kk),:);
    class_bi=0;
    for kkk=1:size(class_i,1)
        point=class_i(kkk,:);
        point_y=class_info(kk);
        i_ibi3=Find_Knn_BI3(point,point_y,x,y,K_para);
        Data_B3=Data_B3+i_ibi3;
        class_bi=class_bi+i_ibi3;
    end
    class_bi=class_bi/sum(y==class_info(kk));
    Data_B3_1vR=[Data_B3_1vR;class_bi];
end
Data_B3=Data_B3/size(x,1);
end

function i_ibi3=Find_Knn_BI3(point,point_y,x,y,k0) % 同时考虑邻域类别数 和 ib3的影响
% Np为参照点的标签 x=[x,y]
dist=[];
i_ibi3=0;
for j=1:size(x,1)
    class=y(j);
    dist_i=norm(point-x(j,:));
    dist=[dist;[dist_i,class]];   
end
dist=sortrows(dist,1);
% 获取近邻的标签信息，进行判别计算bi3
KNN_L=dist(2:k0+1,2);
KNN_L_info=Unique_sort(KNN_L);
% 对原始对应标签的比例进行判别
label_info=Unique_sort(y);

M=sum(KNN_L~=point_y);
if M==k0
    k=M+1;
else
    k=k0;
end

for kk=1:size(KNN_L_info,1)
    Real_y=label_info(label_info(:,1)==point_y,2);
    Real_k=label_info(label_info(:,1)==KNN_L_info(kk,1),2);
    r=max(1,Real_k/Real_y);
    Fn=KNN_L_info(kk,2)/k;
    Fp=(k-M)/k;
    Fp_theory=r*(k-M)/k;
    i_ibi3_i=Fp_theory/(Fp_theory+Fn)-Fp/(Fn+Fp);
    i_ibi3=i_ibi3+i_ibi3_i; % 全部邻域类的影响
end
    i_ibi3=i_ibi3+(1-size(KNN_L_info,1)/size(y,1));
end

function label_info=Unique_sort(Tag) % 按照unique（y）的顺序 计算对应类的样本数
label_info=[];
unqiue_label=unique(Tag);
for i=1:length(unqiue_label)
    label_info(i,:)=[unqiue_label(i),sum(Tag==unqiue_label(i))];
end
end