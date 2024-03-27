function [R_train,R_test]=run_multi_classifiers(train_data,test_data,K_para) % train_data=[x,y]
R_train=[];
R_test=[];

% ��ȡѵ�����Ͳ��Լ���[x,y]\[X,Y]
x=train_data(:,1:end-1);
y=train_data(:,end);
X=test_data(:,1:end-1);
Y=test_data(:,end);

% ��ͬ��������ѵ�����Ͳ��Լ���Ԥ����
    % KNN
    % ѵ����ѵ��
     KNN_clf=ClassificationKNN.fit(x,y,'NumNeighbors',K_para);
    % ѵ����Ԥ�⼰��������
     [L0,~] = predict(KNN_clf, x); 
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,y,L0);
     R_train=[R_train;[CBA,microF1,G,Pave]];
    % ���Լ�Ԥ��
     [L1,~] = predict(KNN_clf, X); 
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,Y,L1);
     R_test=[R_test;[CBA,microF1,G,Pave]];

    %SVM-'ecoc'
    % ѵ����ѵ��
     SVM_clf=fitcecoc(x,y);
    % ѵ����Ԥ�⼰��������
     L0= predict(SVM_clf,x);
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,y,L0);
     R_train=[R_train;[CBA,microF1,G,Pave]];
    % ���Լ�Ԥ��
     [L1,~] = predict(SVM_clf, X); 
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,Y,L1);
     R_test=[R_test;[CBA,microF1,G,Pave]];
     
%     %NB
%     % ѵ����ѵ��
%      NB_clf = fitcnb(x,y);
%     % ѵ����Ԥ�⼰��������
%      L0 = predict(NB_clf,x);
%      [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,y,L0);
%      R_train=[R_train;[IAM,CBA,microF1,macroF1,G,Pave]];
%     % ���Լ�Ԥ��
%      L1= predict(NB_clf,X);
%      [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,Y,L1);
%      R_test=[R_test;[IAM,CBA,microF1,macroF1,G,Pave]];     

    %DT
    % ѵ����ѵ��
     tree_clf = fitctree(x, y);
    % ѵ����Ԥ�⼰��������
     L0 = predict(tree_clf, x);
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,y,L0);
     R_train=[R_train;[CBA,microF1,G,Pave]];
    % ���Լ�Ԥ��
     L1= predict(tree_clf, X);
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,Y,L1);
     R_test=[R_test;[CBA,microF1,G,Pave]];   
     
    %RF
    % ѵ����ѵ��
     rf_clf = TreeBagger(50,x,y, 'Method', 'classification');
    % ѵ����Ԥ�⼰��������
     L0 = str2double(predict(rf_clf,x));
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,y,L0);
     R_train=[R_train;[CBA,microF1,G,Pave]];
    % ���Լ�Ԥ��
     L1= str2double(predict(rf_clf,X));
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,Y,L1);
     R_test=[R_test;[CBA,microF1,G,Pave]];     
     
    %Adaboost
    % ѵ����ѵ��
    adaBoostModel = fitcensemble(x,y, 'Method', 'AdaBoostM2', 'NumLearningCycles', 50);
    % ѵ����Ԥ�⼰��������
     L0 = predict(adaBoostModel, x);
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,y,L0);
     R_train=[R_train;[CBA,microF1,G,Pave]];
    % ���Լ�Ԥ��
     L1= predict(adaBoostModel, X);
     [IAM,CBA,microF1,macroF1,G,Pave]=Show_4_METRICS(y,Y,L1);
     R_test=[R_test;[CBA,microF1,G,Pave]];      

end
