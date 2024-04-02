## Data preprocessing

    train_data=[x,y];
    test_data=[X,Y];
    K_para=5;      
    
## Train the model and make predictions 

    [R_train,R_test]=run_multi_classifiers(train_data,test_data,K_para);
    
## Measure initial complexity, decomposed class complexity, imbalance metric, and others

    [DC,DC_mean,DC_pos,DC_neg]=DC_outputs(x,y,K_para); % DC_1 1v1   DC_R 1vR
    
## CrossValidation

    [O_x,O_y,O_X,O_Y]=CrossValidation(x,y,X,Y);
    
## Raw results collection

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
    
## VoR and DoC

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
    VoR_DC_Clf_KNN=ResultAndRanks(VoR_DC_Clf_KNN);
    VoR_DC_Clf_SVM=ResultAndRanks(VoR_DC_Clf_SVM);
    VoR_DC_Clf_DT=ResultAndRanks(VoR_DC_Clf_DT);
    VoR_DC_Clf_RF=ResultAndRanks(VoR_DC_Clf_RF);
    VoR_DC_Clf_ADB=ResultAndRanks(VoR_DC_Clf_ADB);
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

## M represents any result (Spearman or Pearson coefficients, VoR or DoC)
             
## Empirical classification difficulty (the average of all classifier predictions)

    [rank]=Y_rank(M);
    Clf_mean_tra=(KNN_tra+SVM_tra+DT_tra+RF_tra+ADB_tra)/5;
    Clf_mean_tes=(KNN_tes+SVM_tes+DT_tes+RF_tes+ADB_tes)/5;    
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

## Experimental figures
    
    figure
        bar(M')
        ylabel('DoC');
        legend('F1', 'F3', 'N1', 'N2','N3','LSC','T1','MFII');

## The combination of weighted decomposed class measures

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
