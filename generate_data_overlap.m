% 1 Np=100 IR=5,10,50
% 2 Syn_overlap without noise  dist=0, 1, 2, 3
% 3 with noise rate=0, 0.1, 0.2, 0.3  0.1 means 10% of each class instances
% exchange their labels dist=2
% 4 corvance matrix=[11,12;21,22]+0.1I  each item belong to[-1,1] [0,1]
% 5 small disjuncts 1,2,,4,8 each cluster distance is 2
% 6 each kind of data run 10 times 3*4*10=120 datasets
function [x]=generate_data_overlap(IR,overlap_rate,run_time,MIN_size)
    NUM_dataset=length(IR)*length(overlap_rate)*run_time;
    x=cell(1,1);
    Data_ind=1; % the number of dataset
    Np_mu = [1,1];
    Val_12=-1+2*rand(1); % Feature1 and 2 variance
    Np_SIGMA = [rand(1),Val_12;Val_12,rand(1)]+eye(2);
    Np_data = mvnrnd(Np_mu,Np_SIGMA,MIN_size);
    for k=1:run_time
        for i=1:length(IR)
            for j=1:length(overlap_rate)
                x{Data_ind,1}=Np_data;
                x{Data_ind,2}=ones(MIN_size,1);
                Nn_mu = Dist_data_generation(Np_mu,overlap_rate(j));
                Val_12_21=-1+2*rand(1);
                Nn_SIGMA = [rand(1),Val_12_21;Val_12_21,rand(1)]+eye(2);
                Nn_data = mvnrnd(Nn_mu,Nn_SIGMA,MIN_size*IR(i));  
                x{Data_ind,1}=[x{Data_ind,1};Nn_data];
                x{Data_ind,2}=[x{Data_ind,2};-1*ones(MIN_size*IR(i),1)]; 
                Data_ind=Data_ind+1;
            end
        end        
    end
end
function point=Dist_data_generation(A,dist)
    tag1=A(1)-dist+2*dist*rand(1);
    tag=sqrt(dist^2-(tag1-A(1))^2);
    tag2=A(2)-tag;
    point=[tag1,tag2];
end
