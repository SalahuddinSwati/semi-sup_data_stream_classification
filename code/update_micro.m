    function [ Model_temp ] = update_micro(Model_temp,ex,idx,currentTime)

    LS=Model_temp{idx,1}+ex.data;
    SS=Model_temp{idx,2}+ex.data.^2;
    N_pt=Model_temp{idx,3}+1;
    clu_center=LS/N_pt;
    clu_r=sqrt(sum(SS/N_pt)-sum((LS/N_pt).^2));
    Model_temp{idx,1}=LS;%LS
    Model_temp{idx,2}=SS;%SS
    Model_temp{idx,3}=N_pt;%total ex in mc
    if ex.label_flg==1
        if Model_temp{idx,7}==0
            Model_temp{idx,4}=ex.label;
        end
        Model_temp{idx,5}=Model_temp{idx,5}+ex.data; %CLS
        Model_temp{idx,6}=Model_temp{idx,6}+ex.data.^2;%SSS
        Model_temp{idx,7}=Model_temp{idx,7}+1;%class points
    else
     
    end

    Model_temp{idx,8}=clu_center;
   
    Model_temp{idx,9}=clu_r;
    
    Model_temp{idx,10}=Model_temp{idx,10}+currentTime; %LT
    Model_temp{idx,11}=Model_temp{idx,11}+currentTime.^2; %ST
    Model_temp{idx,12}=currentTime; %current time
 
    end

