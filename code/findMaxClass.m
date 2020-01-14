function [ mxclabel, fre ] = findMaxClass( Model_temp )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
     mcs=cell2mat(Model_temp(:,4));
            label_mcs_idx=find(cell2mat(Model_temp(:,7))~=0);
            label_mcs=mcs(label_mcs_idx);
             
            [train_cls_lb, ia2, cid2] = unique(label_mcs);
            counts2 = sum( bsxfun(@eq, cid2, unique(cid2)') )';
            [fre I]=max(counts2);
            mxclabel=train_cls_lb(I);

end

