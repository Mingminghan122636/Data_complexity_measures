function [R_train,R_test]=run_multi_classifiers(train_data,test_data,K_para) % train_data=[x,y]
R_train=[];
R_test=[];

% 获取训练集和测试集的[x,y]\[X,Y]
x=train_data(:,1:end-1);
y=train_data(:,end);
X=test_data(:,1:end-1);
Y=test_data(:,end);

% 不同分类器对训练集和测试集的预测结果
    % KNN
    % 训练集训练
     KNN_clf=ClassificationKNN.fit(x,y,'NumNeighbors',K_para);
    % 训练集预测及其结果评估
     [L0,~] = predict(KNN_clf, x); 
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,y,L0);
     R_train=[R_train;[CBA,microF1,G,Pave]];
    % 测试集预测
     [L1,~] = predict(KNN_clf, X); 
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,Y,L1);
     R_test=[R_test;[CBA,microF1,G,Pave]];

    %SVM-'ecoc'
    % 训练集训练
     SVM_clf=fitcecoc(x,y);
    % 训练集预测及其结果评估
     L0= predict(SVM_clf,x);
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,y,L0);
     R_train=[R_train;[CBA,microF1,G,Pave]];
    % 测试集预测
     [L1,~] = predict(SVM_clf, X); 
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,Y,L1);
     R_test=[R_test;[CBA,microF1,G,Pave]];
     
%     %NB
%     % 训练集训练
%      NB_clf = fitcnb(x,y);
%     % 训练集预测及其结果评估
%      L0 = predict(NB_clf,x);
%      [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,y,L0);
%      R_train=[R_train;[IAM,CBA,microF1,macroF1,G,Pave]];
%     % 测试集预测
%      L1= predict(NB_clf,X);
%      [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,Y,L1);
%      R_test=[R_test;[IAM,CBA,microF1,macroF1,G,Pave]];     

    %DT
    % 训练集训练
     tree_clf = fitctree(x, y);
    % 训练集预测及其结果评估
     L0 = predict(tree_clf, x);
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,y,L0);
     R_train=[R_train;[CBA,microF1,G,Pave]];
    % 测试集预测
     L1= predict(tree_clf, X);
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,Y,L1);
     R_test=[R_test;[CBA,microF1,G,Pave]];   
     
    %RF
    % 训练集训练
     rf_clf = TreeBagger(50,x,y, 'Method', 'classification');
    % 训练集预测及其结果评估
     L0 = str2double(predict(rf_clf,x));
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,y,L0);
     R_train=[R_train;[CBA,microF1,G,Pave]];
    % 测试集预测
     L1= str2double(predict(rf_clf,X));
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,Y,L1);
     R_test=[R_test;[CBA,microF1,G,Pave]];     
     
    %Adaboost
    % 训练集训练
    adaBoostModel = fitcensemble(x,y, 'Method', 'AdaBoostM2', 'NumLearningCycles', 50);
    % 训练集预测及其结果评估
     L0 = predict(adaBoostModel, x);
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,y,L0);
     R_train=[R_train;[CBA,microF1,G,Pave]];
    % 测试集预测
     L1= predict(adaBoostModel, X);
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,Y,L1);
     R_test=[R_test;[CBA,microF1,G,Pave]];      

end
