function [ Model ] = createMC_updateModel( Model,ex, r,tr_cls )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
        LS=ex.data;
        SS=ex.data.^2;
        N_pt=1;
        clu_center=LS;
        clu_r=r;
       idx=size(Model,1)+1;
        Model{idx,1}=LS;
        Model{idx,2}=SS;
         tr_cls_pt=find(tr_cls==ex.lb(1,1));
        if ex.lb(1,2)==1
           
           Model{idx,3}=[1,0];
        else
             Model{idx,3}=[0,1];
        end
       
        Model{idx,4}=[0,0];
        if ex.lb(1,2)==1
         Model{idx,4}(1,tr_cls_pt)=Model{idx,4}(1,tr_cls_pt)+1;
        end
       Model{idx,5}=0;
        
        Model{idx,6}=ex.time;
        Model{idx,7}=clu_center;
        Model{idx,8}=0;
        Model{idx,9}=r;

end

