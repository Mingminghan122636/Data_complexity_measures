% 1 Np=100 IR=5,10,50
% 2 Syn_overlap without noise  dist=0, 1, 2, 3
% 3 with noise rate=0, 0.1, 0.2, 0.3  0.1 means 10% of each class instances
% exchange their labels dist=2
% 4 corvance matrix=[11,12;21,22]+0.1I  each item belong to[-1,1] [0,1]
% 5 small disjuncts 1,2,,4,8 each cluster distance is 2
% 6 each kind of data run 10 times 3*4*10=120 datasets
function [x]=generate_data_noise(IR,noise_rate,run_time,MIN_size)
    NUM_dataset=length(IR)*length(noise_rate)*run_time;
    x=cell(1,1);
    Data_ind=1; % the number of dataset
    Np_mu = [1,1];
    Val_12=-1+2*rand(1); % Feature1 and 2 variance
    Np_SIGMA = [rand(1),Val_12;Val_12,rand(1)]+eye(2);
    Np_data = mvnrnd(Np_mu,Np_SIGMA,MIN_size);
    for k=1:run_time
        for i=1:length(IR)
            for j=1:length(noise_rate)
                x{Data_ind,1}=Np_data;
                x{Data_ind,2}=ones(MIN_size,1);
                Exchange=randperm(MIN_size,MIN_size*noise_rate(j));
                if length(Exchange)~=0
                   x{Data_ind,2}(Exchange)=-1;
                end
                Nn_mu = Dist_data_generation(Np_mu,2);
                Val_12_21=-1+2*rand(1);
                Nn_SIGMA = [rand(1),Val_12_21;Val_12_21,rand(1)]+eye(2);
                Nn_data = mvnrnd(Nn_mu,Nn_SIGMA,MIN_size*IR(i));  
                Exchange=randperm(MIN_size*IR(i),MIN_size*noise_rate(j));                    
                Nn_label=-1*ones(MIN_size*IR(i),1);
                x{Data_ind,1}=[x{Data_ind,1};Nn_data];                    
                if length(Exchange)~=0
                    Nn_label(Exchange)=1; 
                    x{Data_ind,2}=[x{Data_ind,2};Nn_label];
                else
                    x{Data_ind,2}=[x{Data_ind,2};Nn_label];
                end           
                Data_ind=Data_ind+1;
            end
        end        
    end
%     for i=1:length(IR)
%         for j=1:length(noise_rate) 
%             Plot_data_x=x{(i-1)*length(noise_rate)+j,1};
%             Plot_data_y=x{(i-1)*length(noise_rate)+j,2};
%             subplot(length(IR),length(noise_rate),(i-1)*length(noise_rate)+j);
%             plot(Plot_data_x(find(Plot_data_y==1),1),Plot_data_x(find(Plot_data_y==1),2),'r+');hold on;
%             plot(Plot_data_x(find(Plot_data_y~=1),1),Plot_data_x(find(Plot_data_y~=1),2),'*');
%         end
%     end
end


function point=Dist_data_generation(A,dist)
    tag1=A(1)-dist+2*dist*rand(1);
    tag=sqrt(dist^2-(tag1-A(1))^2);
    tag2=A(2)-tag;
    point=[tag1,tag2];
end



% mu = [7 8];
% SIGMA = [ 1 0; 0 2];
% r2 = mvnrnd(mu,SIGMA,100);
% plot(r(:,1),r(:,2),'r+');hold on;
% plot(r2(:,1),r2(:,2),'*')