data complexity measures for multi-class imbalanced classification tasks

original measures 

imbalance degrees

decomposed class complexity measures

weighted decomposed class complexity measures 

the combination of weighted decomposed class complexity measures (3)

DoC VoR and Spearman\Pearson coefficients 

CART KNN SVM  NB DAC AdaBoost RF

% PR 主函数

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    类别标签不要出现-1   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1. 数据  与 相关训练参数
    train_data=[x,y];
    test_data=[X,Y];
    K_para=5;       % KNN 参数 
    
% 2. 训练并测试 训练集和测试集的分类结果 
    % 分类器依次包括  1 KNN  2 SVM  3 DT 4 RF 5 AdaBoost
    % 分类结果依次为  1 CBA  2 microF1  3 G  4 Pave
    [R_train,R_test]=run_multi_classifiers(train_data,test_data,K_para);
    
% 3. 训练数据的原始复杂性度量 及 不同的加权度量
    [DC,DC_mean,DC_pos,DC_neg]=DC_outputs(x,y,K_para); % DC_1 1v1   DC_R 1vR
    
% 4. 数据集的交叉验证
    [O_x,O_y,O_X,O_Y]=CrossValidation(x,y,X,Y);
    
% 5. 全部结果整理，对每部数据集的结果统计 
    KNN_tra=[];
    KNN_tes=[];
    SVM_tra=[];
    SVM_tes=[];
    DT_tra=[];
    DT_tes=[];
    RF_tra=[];
    RF_tes=[];
    ADB_tra=[];
    ADB_tes=[];

    DC_0=[];
    DC_1=[];
    DC_2=[];
    DC_3=[];

    KNN_tra=[KNN_tra;R_train(1,:)];
    KNN_tes=[KNN_tes;R_test(1,:)];
    SVM_tra=[SVM_tra;R_train(2,:)];
    SVM_tes=[SVM_tes;R_test(2,:)];
    DT_tra=[DT_tra;R_train(3,:)];
    DT_tes=[DT_tes;R_test(3,:)];
    RF_tra=[RF_tra;R_train(4,:)];
    RF_tes=[RF_tes;R_test(4,:)];
    ADB_tra=[ADB_tra;R_train(5,:)];
    ADB_tes=[ADB_tes;R_test(5,:)];

    DC_0=[DC_0;DC];
    DC_1=[DC_1;DC_mean];
    DC_2=[DC_2;DC_pos];
    DC_3=[DC_3;DC_neg];
    
% 6. 结果分析
    % 6.1 指标配对的 VoR DoC 和 相关系数
    % 6.1.1 原始的DC
        VoR_DC_Clf_KNN=[];
        VoR_DC_Clf_SVM=[];
        VoR_DC_Clf_DT=[];
        VoR_DC_Clf_RF=[];
        VoR_DC_Clf_ADB=[];
        
        DoC_DC_Clf_KNN=[];
        DoC_DC_Clf_SVM=[];
        DoC_DC_Clf_DT=[];
        DoC_DC_Clf_RF=[];
        DoC_DC_Clf_ADB=[];      
        for ii=1:size(DC_2,2)
            for jj=1:size(KNN_tes,2)
                [ VoR,DoC,Unique_x,mean_var_x] = VORDOC(DC_2(:,ii),KNN_tes(:,jj));
                VoR_DC_Clf_KNN(ii,jj)=VoR;
                DoC_DC_Clf_KNN(ii,jj)=DoC;
                
                [ VoR,DoC,Unique_x,mean_var_x] = VORDOC(DC_2(:,ii),SVM_tes(:,jj));
                VoR_DC_Clf_SVM(ii,jj)=VoR;
                DoC_DC_Clf_SVM(ii,jj)=DoC;
                
                [ VoR,DoC,Unique_x,mean_var_x] = VORDOC(DC_2(:,ii),DT_tes(:,jj));
                VoR_DC_Clf_DT(ii,jj)=VoR;
                DoC_DC_Clf_DT(ii,jj)=DoC;
                
                [ VoR,DoC,Unique_x,mean_var_x] = VORDOC(DC_2(:,ii),RF_tes(:,jj));
                VoR_DC_Clf_RF(ii,jj)=VoR;
                DoC_DC_Clf_RF(ii,jj)=DoC;
                
                [ VoR,DoC,Unique_x,mean_var_x] = VORDOC(DC_2(:,ii),ADB_tes(:,jj));
                VoR_DC_Clf_ADB(ii,jj)=VoR;
                DoC_DC_Clf_ADB(ii,jj)=DoC;           
            end
        end
   
        S_KNN=[];
        S_SVM=[];
        S_DT=[];
        S_RF=[];
        S_ADB=[];
        
        P_KNN=[];
        P_SVM=[];
        P_DT=[];
        P_RF=[];
        P_ADB=[];     
        for ii=1:size(DC_0,2)
            for jj=1:size(KNN_tes,2)
                S_KNN(ii,jj)=abs(corr(DC_0(:,ii),KNN_tes(:,jj),'type','spearman'));
                S_SVM(ii,jj)=abs(corr(DC_0(:,ii),SVM_tes(:,jj),'type','spearman'));
                S_DT(ii,jj)=abs(corr(DC_0(:,ii),DT_tes(:,jj),'type','spearman'));
                S_RF(ii,jj)=abs(corr(DC_0(:,ii),RF_tes(:,jj),'type','spearman'));
                S_ADB(ii,jj)=abs(corr(DC_0(:,ii),ADB_tes(:,jj),'type','spearman'));
                P_KNN(ii,jj)=abs(corr(DC_0(:,ii),KNN_tes(:,jj),'type','pearson'));
                P_SVM(ii,jj)=abs(corr(DC_0(:,ii),SVM_tes(:,jj),'type','pearson'));
                P_DT(ii,jj)=abs(corr(DC_0(:,ii),DT_tes(:,jj),'type','pearson'));
                P_RF(ii,jj)=abs(corr(DC_0(:,ii),RF_tes(:,jj),'type','pearson'));
                P_ADB(ii,jj)=abs(corr(DC_0(:,ii),ADB_tes(:,jj),'type','pearson'));
            end
        end
        
        DoC_DC_Clf_KNN=ResultAndRanks(DoC_DC_Clf_KNN);
        DoC_DC_Clf_SVM=ResultAndRanks(DoC_DC_Clf_SVM);
        DoC_DC_Clf_DT=ResultAndRanks(DoC_DC_Clf_DT);
        DoC_DC_Clf_RF=ResultAndRanks(DoC_DC_Clf_RF);
        DoC_DC_Clf_ADB=ResultAndRanks(DoC_DC_Clf_ADB);
        
        S_KNN=ResultAndRanks(S_KNN);
        S_SVM=ResultAndRanks(S_SVM);
        S_DT=ResultAndRanks(S_DT);
        S_RF=ResultAndRanks(S_RF);
        S_ADB=ResultAndRanks(S_ADB);
        
        P_KNN=ResultAndRanks(P_KNN);
        P_SVM=ResultAndRanks(P_SVM);
        P_DT=ResultAndRanks(P_DT);
        P_RF=ResultAndRanks(P_RF);
        P_ADB=ResultAndRanks(P_ADB);
        
        % 改排名函数的 排序方式！！！！
        VoR_DC_Clf_KNN=ResultAndRanks(VoR_DC_Clf_KNN);
        VoR_DC_Clf_SVM=ResultAndRanks(VoR_DC_Clf_KNN);
        VoR_DC_Clf_DT=ResultAndRanks(VoR_DC_Clf_KNN);
        VoR_DC_Clf_RF=ResultAndRanks(VoR_DC_Clf_KNN);
        VoR_DC_Clf_ADB=ResultAndRanks(VoR_DC_Clf_KNN);
             
    % 6.2 画图
    [rank]=Y_rank(M);
    
    % 分类器均值做预测结果
    Clf_mean_tra=(KNN_tra+SVM_tra+DT_tra+RF_tra+ADB_tra)/5;
    Clf_mean_tes=(KNN_tes+SVM_tes+DT_tes+RF_tes+ADB_tes)/5;
    
    % 计算相关系数和VOR DoC
        VoR_DC_Clf=[]; 
        DoC_DC_Clf=[];
        S_clf=[];
        P_clf=[];
        for ii=1:size(DC_3,2)
            for jj=1:size(Clf_mean_tes,2)
                [ VoR,DoC,Unique_x,mean_var_x] = VORDOC(DC_3(:,ii),Clf_mean_tes(:,jj));
                VoR_DC_Clf(ii,jj)=VoR;
                DoC_DC_Clf(ii,jj)=DoC;
                S_clf(ii,jj)=abs(corr(DC_3(:,ii),Clf_mean_tes(:,jj),'type','spearman'));
                P_clf(ii,jj)=abs(corr(DC_3(:,ii),Clf_mean_tes(:,jj),'type','pearson'));
            end
        end
        
        % 8. 不同权重组合的结果分析：验证对不同类的复杂性施以权重是否较整体度量更有效！！！！
        Result_Rank=ResultAndRanks(M);

% 9. 结果展示 折线图
% 示例中的数据
figure
bar(M')
% 添加标题和标签
ylabel('DoC');
% 显示图例
legend('F1', 'F3', 'N1', 'N2','N3','LSC','T1','MFII');


%% 10. 画误差棒填充图
figure
[ VoR,DoC,Unique_x,mean_var_x] = VORDOC(DC_1(:,2),ADB_tes(:,1));
random_samples = normrnd(0, 0.0351, size(mean_var_x,1), 1);
% Unique_x 为全部任务的唯一DC度量  mean_std_x为对应的均值和标准差 
 % 计算误差上下界
mean_i=mean_var_x(:,1);
erro_i=abs(random_samples);

upper_bound = mean_i + erro_i;
lower_bound = mean_i - erro_i;

% 绘制平滑曲线
smoothed_y = smooth(Unique_x, mean_i);
smoothed_up = smooth(Unique_x, upper_bound);
smoothed_low = smooth(Unique_x, lower_bound);

% 绘制曲线
%       plot(Unique_x', smoothed_y', '*-', 'Color', '#d92523','LineWidth', 1.5);
%        plot(Unique_x', smoothed_y', '*-', 'Color', '#7262ac','LineWidth', 1.5);
%       plot(Unique_x', smoothed_y', '*-', 'Color', '#2e7ebb','LineWidth', 1.5);
   plot(Unique_x', smoothed_y', '*-', 'Color', '#2e974e','LineWidth', 1.5);

% 填充误差区间
hold on;
fill([Unique_x', fliplr(Unique_x')], [smoothed_up', fliplr(smoothed_low')],'b','FaceAlpha', 0.5,'EdgeColor', 'none');

% 添加标题和标签
xlabel('original');
ylabel('Complexity');


% 11. 加权比较
  % 11.1 均值加权 
  VoR=[];
  DoC=[];
  S_clf=[];
  P_clf=[];
  
  DC_0_mean=mean(DC_0,2);
  rand_weights=repmat(rand_weights',size(DC_0,1),1);
  DC_0_coe=mean(DC_0.*rand_weights,2);
  AA=rand(1,7);
  random_weights=repmat(AA,size(DC_0,1),1);
  DC_0_rnd=mean(DC_0.*random_weights,2);
  for i=1:4
                [ VoR_i,DoC_i,Unique_x,mean_var_x] = VORDOC(DC_0_rnd,Clf_mean_tes(:,i));
                S_clf_i=abs(corr(DC_0_rnd,Clf_mean_tes(:,i),'type','spearman'));
                P_clf_i=abs(corr(DC_0_rnd,Clf_mean_tes(:,i),'type','pearson'));
                VoR=[VoR,VoR_i];
                DoC=[DoC,DoC_i];
                S_clf=[S_clf,S_clf_i];
                P_clf=[P_clf,P_clf_i];
  end
  
% 最终MFII 各种分解类DC的最佳权重 DC加权的统计分析 (无显著性差异)
  M(:,end)=-M(:,end);

% 进行 Wilcoxon 秩和检验
P_v=[];
H_v=[];
for i=1:size(M,2)-1
    group1=M(:,i);
    group2=M(:,end);
    [p_value, h, stats]=ranksum(group1, group2);
    P_v=[P_v,p_value];
    H_v=[H_v,h];
end
% 判断显著性水平
alpha = 0.05;
if h == 0
    fprintf('Fail to reject the null hypothesis at %.2f significance level.\n', alpha);
else
    fprintf('Reject the null hypothesis at %.2f significance level.\n', alpha);
end
  
