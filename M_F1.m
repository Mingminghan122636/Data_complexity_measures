function [ microF1,macroF1,Confuse_M] = M_F1(y,Y,pre )
% y —µ¡∑±Í«© Y≤‚ ‘±Í«© pre‘§≤‚±Í«© 
 [ M,R,P ] = M_pricise( y,Y,pre );
 Confuse_M=M;
 macroF1=0;
 for i=1:length(unique(y))
    if (P(i)+R(i))==0 
        F1=0;
    else
        F1=2*R(i)*P(i)/(P(i)+R(i));
    end
    macroF1=macroF1+F1;
 end
 macroF1=macroF1/length(unique(y));
 
 TP=0;
 FP=0;
 FN=0;
 for j=1:size(M,1)
     TP=TP+M(j,j);
     FP=FP+(sum(M(j,:))-M(j,j));
     FN=FN+(sum(M(:,j))-M(j,j));
 end
 pp=TP/(TP+FP);
 rr=TP/(TP+FN);
 microF1=2*pp*rr/(pp+rr);
end
function [ Confuse_M,Recall,Precise ] = M_pricise( y,Y,pre )
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
    if isinf(Precise(i,1))
        Precise(i,1)=0;
    end
end
for i=1:class_num
    Recall(i,1)=Confuse_M(i,i)./sum(Confuse_M(:,i));
end
end
