    clc;
    clear all;
    load('F:\PhD_Study\Datasets\GasSensor ArrayDriftDataset\GasSensorDriftDataRand.mat');
    load('F:\PhD_Study\Datasets\spam\ForPaper\spame_data_rand.mat');
    load('F:\PhD_Study\Datasets\hyperplaneDataset\ForPaper\hyperplane_gradual_drift.mat');
    load('F:\PhD_Study\Datasets\sea\SEA_data\SEA.mat');
    load('F:\PhD_Study\Datasets\shuttle\shuttle_Norm.mat');
    load('F:\PhD_Study\Datasets\weather\weather_rand.mat');
    %     load('F:\PhD_Study\Datasets\Forestcover\covtypeNorm.mat');
    %%%%%%%%%%%%%%%%%%%% stream %%%%%%%%%%%%%%%%%%%%%%%%%%%
    stream_data=SEA;
    strt=tic;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Important var Parameters%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global maxMC; %maximum number of micro-clusters
    maxMC=1000;
    global num_cluster; %number of clusters per class
    num_cluster=50;
    global lamda; % decay rate
    lamda=0.000002;% 000002[2K 0.06]
    global D_init;
    D_init=1000; %initial training data
    global wT;
    wT=0.06;
    global weight; % classifier weight
    weight=[1;1;1];
    global acc_win_max_size; %accuracy window size
    acc_win_max_size=100;
    global acc_win; % accuracy window
    global num_of_knn; % number of kNN classifiers
    num_of_knn=4;
    label_ratio=[1,5,10,20,30,100]; % label percentage

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ij=1:6 % Label ratio

        fprintf('Label Percentage =%d  \n',label_ratio(ij));
        weight=ones(num_of_knn,1);
        acc_win=zeros(num_of_knn,1);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        label_per=label_ratio(ij);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%initial training data D_init %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        train_data=stream_data(1:D_init,:);
        train_data_labels=train_data(:,end);

        test_data=stream_data(D_init+1:end,1:end-1);
        test_data_labels=stream_data(D_init+1:end,end);
        [train_cls_lb, ia2, cid2] = unique(train_data_labels);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [Model]=initial_model_construction(train_data,train_cls_lb);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %percentage of partial labels
        test_size=size(test_data,1); %size of test stream

        no_label_data=ceil(label_per*test_size/100);
        rno=randperm(test_size,no_label_data);
        test_data_labels=[test_data_labels zeros(1,test_size)'];
        test_data_labels(rno,2)=1;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        acc=[];
        correct=0;
        j=1;
        i=1;
        while i<=test_size
            %disp(b_no);
            ex.data=test_data(i,:);
            ex.label=test_data_labels(i,1);
            ex.label_flg=test_data_labels(i,2);
            CurrentTime=i;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [ p_label, idx] = classify( ex, Model );

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            if p_label==ex.label
                correct=correct+1;
            end
            if ex.label_flg==1

                nrb_labels=cell2mat(Model(idx,4));
                con_label=idx(nrb_labels==ex.label);
                incon_label=idx(nrb_labels~=ex.label);
                Model(con_label,9)=num2cell(cell2mat(Model(con_label,9))+1); %consistant with true label
                Model(con_label,8)=num2cell(CurrentTime);
                Model(incon_label,9)=num2cell(cell2mat(Model(incon_label,9))-1); %inconsistant with true label

            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            [ Model] = update_Model( Model, CurrentTime);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            clu_cent=cell2mat(Model(:,6));
            [idx, D]=knnsearch(clu_cent,ex.data,'NSMethod','exhaustive');
            r=Model{idx,7};

            if D<=r && ex.label_flg==1 && ex.label==cell2mat(Model(idx,4))||D<=r && ex.label_flg~=1
                [ Model ] = update_micro(Model,ex,idx, CurrentTime);
            else

                [ Model] = createMC( Model,ex, r,CurrentTime);
            end

            acc(j,1)=correct*100/i;
            if mod(i,1000)==0
                fprintf('\n example no =%d',i);
                fprintf('\t accuracy=%f  \n',acc(j,1));
            end
            i=i+1;
            j=j+1;

            weight=sum(acc_win,2)/size(acc_win,2);
        end
        fprintf('\t Label Percentage =%d  \n',label_ratio(ij));
        fprintf('\t Final Accuracy=%f  \n \n',acc(end));
        dset_f_acc(ij)=acc(end);

    end
