function [Model]=initial_model_construction(data,train_class_labels)

global num_cluster;
train_data=data(:,1:end-1);
train_data_labels=data(:,end);
%[train_class_labels, ia, cid] = unique(train_data_labels,'stable');
for i=1:size(train_class_labels,1)
    
    class_data{i}=train_data(train_data_labels==train_class_labels(i),:);
    class_labels{i}=train_data_labels(train_data_labels==train_class_labels(i));
end
num_replicates=1;

Model={};
a=1;
for i=1:size(train_class_labels,1)
    cls_data=class_data{i};
    if size(cls_data,1)<= num_cluster
        
        KK=ceil(size(cls_data,1)/2);
        %  KK=num_cluster;
    else
        KK=num_cluster;
    end
    [membership, ctrs] = kmeans(cls_data,KK,'Replicates',num_replicates,'Distance','sqEuclidean','MaxIter',1000);
    
    for j=1:KK
        clu_pt=find(membership==j);
        
        clu_data=cls_data(clu_pt,:);
        
        N_pt=size(clu_data,1);
        %if N_pt>1
        clu_center=ctrs(j,:);
        
        LS=sum(clu_data,1);
        SS=sum(clu_data.^2,1);
        clu_r=sqrt(sum(SS/N_pt)-sum((LS/N_pt).^2));
        micro_clu{1,1}=LS; 
        micro_clu{1,2}=SS;
        
        micro_clu{1,3}=N_pt;
        
        micro_clu{1,4}=train_class_labels(i); %mc label

        micro_clu{1,5}=1; %label flg
         micro_clu{1,6}=LS/N_pt; %center
        micro_clu{1,7}=clu_r; %radius
        micro_clu{1,8}=0; %time
        micro_clu{1,9}=1; %importance
        Model(a,:)=micro_clu;
        a=a+1;
       
    end
end

end