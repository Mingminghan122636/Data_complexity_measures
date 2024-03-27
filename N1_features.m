function [Data_N1,Data_N1_1vR] = N1_features(x,y)
    Data_N1=[];        
    Data_N1_1vR=[]; 
    N1=0;
    Dist=squareform(pdist(x));
    Root_P=1;
    [MST,Pred]=graphminspantree(sparse(Dist),Root_P);
    % 得到不同MST的连接矩阵
    MST_Mtraix=full(MST);
    % 遍历连接矩阵，发现不同的连接 data complexity, 给定起始点与构建MST的起始点相同
    Tag=y;
    % 遍历MST的实现
    [Same,Diff]=Search_MST(Tag,MST_Mtraix);
    [~,Group_diff]=Grouping(Same,Diff,Tag);
    for gg=1:size(Group_diff,1)
       N1=N1+length(Group_diff{gg,1});
    end
    Data_N1=N1/size(x,1);
    
    class_info=unique(y);
    for mm=1:length(class_info)
        N1_i=0; % 标签计数
        count_y=class_info(mm);
        for gg1=1:size(Group_diff,1)
           N1_i=N1_i+sum(Group_diff{gg1,2}==count_y);
        end
        Data_N1_1vR=[Data_N1_1vR; N1_i/sum(y==count_y)];
    end
%     Tree_Group{set_i,1}=Group_same;
%     Tree_Group{set_i,2}=Group_diff;
%     % alpha 用来确定异常点 当子簇大小小于 class_size*alpha时，认为为异常或rare_case
%     [Cluster,Outlier,Border,show_cluster,show_outlier]=Get_data_components(Group_same,Group_diff,0,Tag);
%     
%     [Total_N3,Class_N3,~] = N3_total(Border,Tag);
end

% Same cell(n,2)={每个样本的same集合，对应的标签}  Diff cell(n,2)={每个样本的diff集合，对应的标签}
function [Same,Diff]=Search_MST(Tag,MST_Mtraix)
Adj_Matrix=MST_Mtraix+eye(size(Tag,1));
Adj_Matrix(find(Adj_Matrix~=0))=1;
Tag_same=zeros(size(Tag,1));
for i=1:size(Tag,1)
    for j=1:size(Tag,1)
        Tag_same(i,j)=(Tag(i)==Tag(j));
    end
end
 % 构建邻接链表
 A=cell(size(Tag,1),1);
 Same=cell(1,2);
 Diff=cell(1,2);

 for i=1:size(Tag,1)
     A{i,1}=find(Adj_Matrix(:,i)==1)';
     Same{i,1}=i;
     for j=1:size(A{i,1},2)
         if Tag_same(i,A{i,1}(j))==1
            Same{i,1}=union(Same{i,1},A{i,1}(j));
            Same{i,2}=Tag(i)*ones(1,length(Same{i,1}));
         end
     end
 end
  for i=1:size(Tag,1)
     A{i,1}=find(Adj_Matrix(:,i)==1)';
     Diff{i,1}=i;
     Diff{i,2}=Tag(i);
     for j=1:size(A{i,1},2)
         if Tag_same(i,A{i,1}(j))~=1
            Diff{i,1}=union(Diff{i,1},A{i,1}(j));
            Diff{i,2}=Tag(Diff{i,1})';
         end     
     end
  end
end

function [Group_same,Group_diff]=Grouping(Same,Diff,Tag)
Group_same=cell(1,2);
Group_diff=cell(1,2);
same_num=0;
diff_num=0;
Node=1:size(Tag,1);
while length(Node)>0
    i=Node(1);
    same_num=same_num+1;
    Group_same{same_num,1}=Same{i,1}; 
    for ii=1:length(Tag)
        TT= Group_same{same_num,1};
          for j=1:size(Tag,1)
              if length(intersect(Group_same{same_num,1},Same{j,1}))>0  
                 Group_same{same_num,1}=union(Same{j,1},Group_same{same_num,1}); 
              end
          end
          if length(TT)==length(Group_same{same_num,1})
              break;
          end
    end
    if length(Group_same{same_num,1})>1
       Group_same{same_num,2}=Tag(i)*ones(1,length(Group_same{same_num,1}))';
       Del_node=Group_same{same_num,1};
       for len=1:length(Del_node)
           Node(Node==Del_node(len))=[];
       end
    else  
       Node(Node==Group_same{same_num,1})=[];     
       same_num=same_num-1;
    end
end
Group_same=Group_same(1:same_num,:);

Node1=[1:size(Tag,1)];
while length(Node1)>0
    diff_num=diff_num+1;
    i=Node1(1);
    Group_diff{diff_num,1}=Diff{i,1};  
        for ii=1:length(Tag)
            TT1= Group_diff{diff_num,1};
            for j=1:size(Tag,1)
                if length(intersect(Group_diff{diff_num,1},Diff{j,1}))>0  
                    Group_diff{diff_num,1}=union(Diff{j,1},Group_diff{diff_num,1})'; 
                end
            end
            if length(TT1)==length(Group_diff{diff_num,1})
                 break;
            end            
        end
        if length(Group_diff{diff_num,1})>1
            Group_diff{diff_num,2}=Tag(Group_diff{diff_num,1});
            Del_node1=Group_diff{diff_num,1};
            for len1=1:length(Del_node1)
                Node1(Node1==Del_node1(len1))=[];
            end   
        else
            Node1(Node1==Group_diff{diff_num,1})=[]; 
            diff_num=diff_num-1;      
        end
end
Group_diff=Group_diff(1:diff_num,:);
end