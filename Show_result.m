function [Pave,G,CBA]=Show_result(y,Y,pre)
Pave=0;
G=1;
CBA=0;
[ M,R,P ] = M_pricise( y,Y,pre );
class_info=unique(y);
for i=1:size(R,1)
    if ismember(class_info(i),unique(Y))     
        G=G*R(i);
        CBA=CBA+R(i);
    end
    Pave=Pave+P(i);
end
Pave=Pave/length(unique(y));
G=nthroot(G,length(unique(Y)));
CBA=CBA/length(unique(Y));
end

function [minority,majority]=class_divide(y,IR)
y_unique=unique(y); % ��ǩ���
y_num=[y_unique,countn(y,y_unique)]; % ��ͬ����Ӧ��������Ŀ
min_y=[];  % �������ǩ
maj_y=[];  % �������ǩ 
% ���ֶ�������������
for i=1:size(y_num,1)
    if max(y_num(:,2))/y_num(i,2)>=IR
        min_y=[min_y;y_num(i,1)];
    else
        maj_y=[maj_y;y_num(i,1)];
    end
end
minority=min_y;
majority=maj_y;
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
    if isnan(Precise(i,1))
        Precise(i,1)=0;
    end
end
for i=1:class_num
    Recall(i,1)=Confuse_M(i,i)./sum(Confuse_M(:,i));
end
end
function [ acc ] = numsofacc( x,y,z )  %xΪ��ԭʼ��ǩ  yΪpre_reset 
%UNTITLED5 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
n=size(x,1);
m=size(unique(z),1);
a=unique(z);
acc=zeros(m,1);
for i=1:n
     if y(i)==x(i)
       for k=1:m
           if y(i)==a(k)
               acc(k)=acc(k)+1;
           end
       end
     end
end
end
function [ c ] = countn( x,y )% x Ϊ��ǩ���� yΪunique_lable���� 
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
m=size(y,1);
c=zeros(m,1);
n=size(x,1);
for k=1:m
    for i=1:n
     if x(i,1)==y(k,1)
        c(k,1)=c(k,1)+1;
     end
    end
end
end