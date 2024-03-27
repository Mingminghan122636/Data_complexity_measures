function [rank]=Y_rank(M)
    %对输入矩阵 M 的每一列元素进行排名，最后输出每行排名的均值  默认为从小到大
    rank=[];
    for i=1:size(M,2)
        A=M(:,i);
        rank_i=tiedrank(-exp(A));
        rank=[rank,rank_i];
    end
     mean_row=mean(rank,2);
%      rank=[rank,mean_row];
rank=mean_row;
end