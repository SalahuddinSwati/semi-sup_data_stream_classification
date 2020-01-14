function [ Model_temp ] = mergMCul( Model_temp )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

                clu_cent_all=cell2mat(Model_temp(:,8));
                label_clu_cen=find(cell2mat(Model_temp(:,7))~=0);
                clu_cent_lb=clu_cent_all(label_clu_cen,:);
                ulabel_clu_cen=find(cell2mat(Model_temp(:,7))==0);
                clu_cent_ulb=clu_cent_all(ulabel_clu_cen,:);
                D = pdist2(clu_cent_ulb,clu_cent_lb,'euclidean');
                D(D==0)=1000;
                minMatrix = min(D(:));
                [row,col] = find(D==minMatrix);
                if size(col,1)>1
                    col=col(1,1);
                elseif size(col,1)==0
                     col=col(1,1);
                end
                if size(row,1)>1
                    row=row(1,1);
                end
                mc1=Model_temp(ulabel_clu_cen(row),:);
                mc2=Model_temp(label_clu_cen(col),:);
                mc{1,1}=mc1{1,1}+mc2{1,1};
                mc{1,2}=mc1{1,2}+mc2{1,2};
                mc{1,3}=mc1{1,3}+mc2{1,3};
                mc{1,4}=max(mc1{1,4},mc2{1,4});
                mc{1,5}=mc1{1,5}+mc2{1,5};
                mc{1,6}=mc1{1,6}+mc2{1,6};
                mc{1,7}=mc1{1,7}+mc2{1,7};
                LS=mc{1,1};
                SS=mc{1,2};
                N_pt=mc{1,3};
                clu_center=LS/N_pt;
                clu_r=sqrt(sum(SS/N_pt)-sum((LS/N_pt).^2));
                mc{1,8}=clu_center;
                mc{1,9}=clu_r;
                mc{1,10}=mc1{1,10}+mc2{1,10};
                mc{1,11}=mc1{1,11}+mc2{1,11};
                mc{1,12}=max(mc1{1,12},mc2{1,12});
                mc{1,13}=max(mc1{1,13},mc2{1,13});
               % mc{1,14}=max(mc1{1,14},mc2{1,14});
                 a=size(Model_temp,1);
                Model_temp(a+1,:)=mc;
                Model_temp(ulabel_clu_cen(row),:)=[];
                Model_temp(label_clu_cen(col),:)=[];
                
end

