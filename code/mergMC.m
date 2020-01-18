function [ Model_temp ] = mergMC( label_clu_cen,Model_temp )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

                clu_cent=cell2mat(Model_temp(:,6));
                
                clu_cent=clu_cent(label_clu_cen,:);
                D = pdist2(clu_cent,clu_cent,'euclidean');
                D(D==0)=1000;
                minMatrix = min(D(:));
                [row,col] = find(D==minMatrix);
                mc1=Model_temp(label_clu_cen(row(1)),:);
                mc2=Model_temp(label_clu_cen(row(2)),:);
                mc{1,1}=mc1{1,1}+mc2{1,1};
                mc{1,2}=mc1{1,2}+mc2{1,2};
                mc{1,3}=mc1{1,3}+mc2{1,3};
                mc{1,4}=mc1{1,4};
                mc{1,5}=mc1{1,5};
                LS=mc{1,1};
                SS=mc{1,2};
                N_pt=mc{1,3};
                clu_center=LS/N_pt;
                clu_r=sqrt(sum(SS/N_pt)-sum((LS/N_pt).^2));
                mc{1,6}=clu_center;
                mc{1,7}=clu_r;
                mc{1,8}=max(mc1{1,8},mc2{1,8});
                mc{1,9}=max(mc1{1,9},mc2{1,9});
                 a=size(Model_temp,1);
                Model_temp(a+1,:)=mc;
                Model_temp(label_clu_cen(row),:)=[];
                
end

