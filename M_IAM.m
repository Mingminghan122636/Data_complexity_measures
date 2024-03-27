function  IAM=M_IAM(y,Y,pre) % [IAM,G_mean,Ave_R,G_P,Ave_P];
[ Confuse_M,R,P ] = M_pricise( y,Y,pre );
G_mean=1;
Ave_R=0;
G_P=1;
Ave_P=0;

for jj=1:length(R)
    G_mean=G_mean*R(jj);
    Ave_R=Ave_R+R(jj);
    G_P=G_P*P(jj);
    Ave_P=Ave_P+P(jj);
end
G_mean=G_mean^(1/jj);
Ave_R=Ave_R/jj;
G_P=G_P^(1/jj);
Ave_P=Ave_P/jj;

IAM=0;
for i=1:size(Confuse_M,1)
    c_ii=Confuse_M(i,i);
    c_ij=sum(Confuse_M(i,:))-Confuse_M(i,i);
    c_ji=sum(Confuse_M(:,i))-Confuse_M(i,i);
    c_up=max(c_ij,c_ji);
    c_down=max(sum(Confuse_M(i,:)),sum(Confuse_M(:,i)));
    IAM=IAM+((c_ii-c_up)/c_down);  
end
IAM=IAM/size(Confuse_M,1);
result=[IAM,G_mean,Ave_R,G_P,Ave_P];
end

function [ Confuse_M,Recall,Precise ] = M_pricise( y,Y,pre )
Recall=[];
Precise=[];
labels=unique(y);
class_num=length(labels);
Confuse_M=zeros(class_num,class_num); % row=predict  clo=ture
for i=1:class_num
    for j=1:class_num
        Rows=find(pre==labels(i));
        Clos=find(Y==labels(j));
        Confuse_M(i,j)=length(intersect(Rows,Clos));
    end
    Precise(i,1)=Confuse_M(i,i)./sum(Confuse_M(i,:));
    if isnan(Precise(i,1))
        Precise(i,1)=0;
    end
end
for i=1:class_num
    Recall(i,1)=Confuse_M(i,i)./sum(Confuse_M(:,i));
end
end