function [Group_same,Group_diff]=Grouping(Same,Diff,Tag)
Group_same=cell(1,2);
Group_diff=cell(1,2);
same_num=0;
diff_num=0;
Node=1:size(Tag,1);
while length(Node)>0
    same_num=same_num+1;
    i=Node(1);
    Group_same{same_num,1}=Same{i,1}; 
%     for ii=1:length(Group_same{same_num,1})
    for ii=1:length(Tag)
          for j=1:size(Tag,1)
              if length(intersect(Group_same{same_num,1},Same{j,1}))>0  
            %             Same{i,1}=union(Same{i,1},Same{j,1});
                 Group_same{same_num,1}=union(Same{j,1},Group_same{same_num,1}); 
              end
          end
     end       
    Group_same{same_num,2}=Tag(i)*ones(1,length(Group_same{same_num,1}))';
    for k=1:length(Group_same{same_num,1})
        Del=find(Node==Group_same{same_num,1}(k));
        Node(Del)=[];
    end
end

Node1=[1:size(Tag,1)];
while length(Node1)>0
    diff_num=diff_num+1;
    i=Node1(1);
    Group_diff{diff_num,1}=Diff{i,1};  
        for ii=1:length(Tag)
            for j=1:size(Tag,1)
                if length(intersect(Group_diff{diff_num,1},Diff{j,1}))>0  
        %             Diff{i,1}=union(Diff{i,1},Diff{j,1});
                    Group_diff{diff_num,1}=union(Diff{j,1},union(Diff{i,1},Group_diff{diff_num,1}))'; 
                end
            end 
        end
    if length(Group_diff{diff_num,1})==1  
        for k=1:length(Group_diff{diff_num,1})
            Del=find(Node1==Group_diff{diff_num,1}(k));
            Node1(Del)=[];
        end
        Group_diff{diff_num,1}=[];
        diff_num=diff_num-1;        
    else
        Group_diff{diff_num,2}=Tag(Group_diff{diff_num,1});
        for k=1:length(Group_diff{diff_num,1})
            Del=find(Node1==Group_diff{diff_num,1}(k));
            Node1(Del)=[];
        end    
    end
end
Group_diff=Group_diff(1:diff_num,:);
end