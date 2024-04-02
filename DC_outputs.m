function [DC,DC_mean,DC_pos,DC_neg]=DC_outputs(x,y,K_para) % DC_1 1v1   DC_R 1vR
    DC=[];
    DC_mean=[];
    DC_pos=[];
    DC_neg=[];

    train_data=[x,y];
    
    % 获取类别信息 类别+样本数量
    y_info=unique(y);
    num=length(y_info);
    class_info=zeros(num,2);
    for class_i=1:num
        class_info(class_i,1)=y_info(class_i);
        class_info(class_i,2)=sum(y==y_info(class_i));
    end
    % 获取各类的正负比例
    pos=class_info(:,2)./size(y,1);
    neg=[];
    for tag=1:num
        neg=[neg;pos(num+1-tag)];
    end
    avg=ones(num,1)./num;
    
    % 获取DC 和 给类别DC 
% %     F1
    [Data_F1,Data_F1v_1vR] = F1v_features(train_data);
% %     F2
     [Data_F2,Data_F2_1vR] = F2_features(x,y);
% %     F3
    [Data_F3,Data_F3_1vR] = F3_features(x,y);
% %     N1
    [Data_N1,Data_N1_1vR] = N1_features(x,y);
% %     N2
     [Data_N2,Data_N2_1vR] = N2_features(x,y);
% %     N3
     [Data_N3,Data_N3_1vR] = N3_features(x,y);
% %     LSC
    [Data_LSC,Data_LSC_1vR] = LSC_features(x,y);
% %     T1
     [Data_T1,Data_T1_1vR] = T1_features(x,y);
% %     MFII
    [Data_MFII，~] = MFII(x,y,K_para);
    % Class distributd metrics    包含三个 multi_IR  lrid_value  ID_HD  ID_TV
     IM_metric=ImbalancedMeasure(train_data);
    
    
    
    % 得到不同复杂性度量
     Outputs=[Data_F1(1),Data_F3,Data_N1,Data_N2,Data_N3,Data_LSC,Data_T1,Data_B3];
     Avg_opt=[sum(avg.*Data_F1v_1vR),sum(avg.*Data_F3_1vR),sum(avg.*Data_N1_1vR),sum(avg.*Data_N2_1vR),sum(avg.*Data_N3_1vR),sum(avg.*Data_LSC_1vR),sum(avg.*Data_T1_1vR),sum(avg.*Data_B3_1vR)];
     pos_opt=[sum(pos.*Data_F1v_1vR),sum(pos.*Data_F3_1vR),sum(pos.*Data_N1_1vR),sum(pos.*Data_N2_1vR),sum(pos.*Data_N3_1vR),sum(pos.*Data_LSC_1vR),sum(pos.*Data_T1_1vR),sum(pos.*Data_B3_1vR)];
     neg_opt=[sum(neg.*Data_F1v_1vR),sum(neg.*Data_F3_1vR),sum(neg.*Data_N1_1vR),sum(neg.*Data_N2_1vR),sum(neg.*Data_N3_1vR),sum(neg.*Data_LSC_1vR),sum(neg.*Data_T1_1vR),sum(neg.*Data_B3_1vR)];
% % %     
%     Outputs=[Data_N1,Data_LSC,Data_B3];
%     Avg_opt=[sum(avg.*Data_N1_1vR),sum(avg.*Data_LSC_1vR),sum(avg.*Data_B3_1vR)];
%     pos_opt=[sum(pos.*Data_F1v_1vR),sum(pos.*Data_F3_1vR),sum(pos.*Data_N1_1vR),sum(pos.*Data_N2_1vR),sum(pos.*Data_N3_1vR),sum(pos.*Data_LSC_1vR),sum(pos.*Data_T1_1vR),sum(pos.*Data_B3_1vR)];
%     neg_opt=[sum(neg.*Data_F1v_1vR),sum(neg.*Data_F3_1vR),sum(neg.*Data_N1_1vR),sum(neg.*Data_N2_1vR),sum(neg.*Data_N3_1vR),sum(neg.*Data_LSC_1vR),sum(neg.*Data_T1_1vR),sum(neg.*Data_B3_1vR)];
%  
    DC=[DC;Outputs]; 
    DC_mean=[DC_mean;Avg_opt]; 
% %     DC_pos=[DC_pos;pos_opt];
% %     DC_neg=[DC_neg;neg_opt];
    
    % 结果评估
end
