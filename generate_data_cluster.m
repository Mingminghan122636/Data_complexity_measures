% 1 Np=100 IR=5,10,50
% 2 Syn_overlap without noise  dist=0, 1, 2, 3
% 3 with noise rate=0, 0.1, 0.2, 0.3  0.1 means 10% of each class instances
% exchange their labels dist=2
% 4 corvance matrix=[11,12;21,22]+0.1I  each item belong to[-1,1] [0,1]
% 5 small disjuncts 1,2,,4,8 each cluster distance is 2
% 6 each kind of data run 10 times 3*4*10=120 datasets
function [x]=generate_data_cluster(IR,cluster_rate,run_time,MIN_size)
    NUM_dataset=length(IR)*length(cluster_rate)*run_time;
    x=cell(NUM_dataset,2);
    Data_ind=1; % the number of dataset
    Point_Np=[0,0;2,-2;4,0;6,-2;0,-4;2,-6;4,-4;6,-6];
    Point_Nn=[2,0;0,-2;4,-2;6,0;0,-6;2,-4;4,-6;6,-4];
    for k=1:run_time
        for i=1:length(IR)
            for j=1:length(cluster_rate)
                Sub_num=randperm(MIN_size,cluster_rate(j));
                Sub_num=ceil(Sub_num./sum(Sub_num)*MIN_size);
                Sub_num1=randperm(MIN_size*IR(i),cluster_rate(j));
                Sub_num1=ceil(Sub_num1./sum(Sub_num1)*MIN_size*IR(i));                
                for jj=1:cluster_rate(j)
                    Np_mu =Point_Np(jj,:);
                    Val_12=-1+2*rand(1); % Feature1 and 2 variance
                    Np_SIGMA = [rand(1),Val_12;Val_12,rand(1)]+eye(2);
                    Np_data = mvnrnd(Np_mu,Np_SIGMA,Sub_num(jj));
                    x{Data_ind,1}=[x{Data_ind,1};Np_data];
                    x{Data_ind,2}=[x{Data_ind,2};ones(Sub_num(jj),1)];
                    Nn_mu = Point_Nn(jj,:);
                    Val_12_21=-1+2*rand(1);
                    Nn_SIGMA = [rand(1),Val_12_21;Val_12_21,rand(1)]+eye(2);
                    Nn_data = mvnrnd(Nn_mu,Nn_SIGMA,Sub_num1(jj));  
                    x{Data_ind,1}=[x{Data_ind,1};Nn_data];
                    x{Data_ind,2}=[x{Data_ind,2};-1*ones(Sub_num1(jj),1)];                 
                end
                Data_ind=Data_ind+1;
            end
        end        
    end
%     for i=1:length(IR)
%         for j=1:length(cluster_rate) 
%             Plot_data_x=x{(i-1)*length(cluster_rate)+j,1};
%             Plot_data_y=x{(i-1)*length(cluster_rate)+j,2};
%             subplot(length(IR),length(cluster_rate),(i-1)*length(cluster_rate)+j);
%             plot(Plot_data_x(find(Plot_data_y==1),1),Plot_data_x(find(Plot_data_y==1),2),'r+');hold on;
%             plot(Plot_data_x(find(Plot_data_y~=1),1),Plot_data_x(find(Plot_data_y~=1),2),'*');
%         end
%     end
end
