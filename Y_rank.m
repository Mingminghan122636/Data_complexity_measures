function [rank]=Y_rank(M)
    %��������� M ��ÿһ��Ԫ�ؽ���������������ÿ�������ľ�ֵ  Ĭ��Ϊ��С����
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