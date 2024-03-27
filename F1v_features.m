function [Data_F1,Data_F1v_1vR] = F1v_features(train_data)
    Data_F1=[];         % 用于放置1vR和1v1的整体F1度量
    Data_F1v_1vR=[];    % 用于放置1vR的所有类F1度量 --------- 基于类分解的每个类的度量结果
    Data_F1v_1v1=[];    % 每个1v1的度量结果
    
    label_train=train_data(:,end);
    class_info=unique(label_train);
    if length(class_info)==2
        Data_F1v_1vR=Features_F1v(train_data(:,1:end-1),train_data(:,end));
        Data_F1v_1v1=Data_F1v_1vR;
        Data_F1=[Data_F1v_1vR,Data_F1v_1v1];
    else    
        for ii=1:length(class_info)
            ll=train_data(:,end);
            ll(ll~=class_info(ii))=-1;
            Data_F1v_i=Features_F1v(train_data(:,1:end-1),ll);
            Data_F1v_1vR=[Data_F1v_1vR;Data_F1v_i];
        end
        
        for iii=1:length(class_info)-1
            for jjj=iii+1:length(class_info)
                pos_x=train_data(train_data(:,end)==class_info(iii),1:end-1);
                pos_y=train_data(train_data(:,end)==class_info(iii),end);
                neg_x=train_data(train_data(:,end)==class_info(jjj),1:end-1);
                neg_y=train_data(train_data(:,end)==class_info(jjj),end);
                Data_F1v_i=Features_F1v([pos_x;neg_x],[pos_y;neg_y]);
                Data_F1v_1v1=[Data_F1v_1v1;Data_F1v_i];
            end
        end
        Data_F1v_1v1=2*sum(Data_F1v_1v1)/(length(class_info)*(length(class_info)-1));
        Data_F1=[sum(Data_F1v_1vR)/length(class_info),Data_F1v_1v1];
    end
end

function F1v=Features_F1v(data_x,data_y)
class_info=unique(data_y);
class_num=length(class_info);
mean_i=[];
size_i=[];
scatter_matrix_i=cell(1,1);
for i=1:class_num
    data_i=data_x(data_y==class_info(i),:);
    mean_i=[mean_i;mean(data_i)];
    size_i=[size_i;size(data_i,1)/size(data_x,1)];
    scatter_matrix_i{i,1}=Scater_M(data_i);
end
B=(mean_i(1,:)-mean_i(2,:))'*(mean_i(1,:)-mean_i(2,:));
W=size_i(1)*scatter_matrix_i{1,1}+size_i(2)*scatter_matrix_i{2,1};
d=inv(W)*(mean_i(1,:)-mean_i(2,:))';
dF=(d'*B*d)/(d'*W*d);
F1v=1/(1+dF);
end

function scatter_matrix_i = Scater_M(data_i)
[m,n]=size(data_i);
scatter_matrix_i=zeros(n,n);
for j=1:m
    scatter_matrix_i=scatter_matrix_i+(data_i(j,:)-mean(data_i))'*(data_i(j,:)-mean(data_i));
end
scatter_matrix_i=scatter_matrix_i./m;
end