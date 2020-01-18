    function [ Model_temp ] = update_micro(Model_temp,ex,idx,currentTime)

    LS=Model_temp{idx,1}+ex.data;
    SS=Model_temp{idx,2}+ex.data.^2;
    N_pt=Model_temp{idx,3}+1;
    clu_center=LS/N_pt;
    clu_r=sqrt(sum(SS/N_pt)-sum((LS/N_pt).^2));
    Model_temp{idx,1}=LS;%LS
    Model_temp{idx,2}=SS;%SS
    Model_temp{idx,3}=N_pt;%total ex in mc
    if ex.label_flg==1 && Model_temp{idx,5}==0
        Model_temp{idx,4}=ex.label;
        Model_temp{idx,5}=1;%label flg
    else

    end

    Model_temp{idx,6}=clu_center;

    Model_temp{idx,7}=clu_r;
    Model_temp{idx,8}=currentTime; %current time

    end

