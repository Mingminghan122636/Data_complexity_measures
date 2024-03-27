function [ VoR,DoC,Unique_x,mean_var_x] = VORDOC(x,y)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
VoR=0;
[Unique_x,mean_var_x]=Simpliy_plot(x,y);
[~,low_y,up_y]=Simpliy_plot_upAndlow(x,y);
sum_var=mean(mean_var_x(:,2));
diff=mean(up_y)-mean(low_y);
if diff<0
    diff=0;
end
VoR1=sum_var*exp(diff);
DoC=0;
RR=sortrows([x,y],1);
for i=1:size(RR,1)-1
    if RR(i,1)-RR(i+1,1)<0 && RR(i,2)-RR(i+1,2)>0
        DoC=DoC+1/(size(RR,1)-1);
    end
    if RR(i,1)-RR(i+1,1)<0 && RR(i,2)-RR(i+1,2)<0
        DoC=DoC-1/(size(Unique_x,1)-1);
    end
end
DoC=abs(DoC);
DoC=(DoC+var(mean_var_x(:,1)))/2;

[Unique_x,mean_var_x]=Simpliy_plot(y,x);
[~,low_y,up_y]=Simpliy_plot_upAndlow(y,x);
sum_var=mean(mean_var_x(:,2));
diff=mean(up_y)-mean(low_y);
if diff<0
    diff=0;
end
VoR2=sum_var*exp(diff);
VoR=max(VoR1,VoR2);
end

function [Unique_x,Unique_y]=Simpliy_plot(x,y)
  m=size(x,1);
  Unique_x=unique(x);
  m1=size(Unique_x,1);
  Unique_y=zeros(m1,2);
  for i=1:m1
      x_y=y(find(x==Unique_x(i)));
      Unique_y(i,1)=mean(x_y);
      Unique_y(i,2)=std(x_y);
  end
  
end
function [Unique_x,low_y,up_y]=Simpliy_plot_upAndlow(x,y)
  m=size(x,1);
  Unique_x=unique(x);
  m1=size(Unique_x,1);
  low_y=zeros(m1,1);
  up_y=zeros(m1,1);
  for i=1:m1
      x_y=y(find(x==Unique_x(i)));
      low_y(i)=min(x_y);
      up_y(i)=max(x_y);
  end 
end

