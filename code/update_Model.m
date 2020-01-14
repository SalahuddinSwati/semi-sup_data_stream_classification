    function [ Model] = update_Model( Model, CurrentTime)
   
    global lamda;
    global wT;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    impr=cell2mat(Model(:,13));
    impr=impr.*2.^(-lamda.*(CurrentTime-cell2mat(Model(:,12))));
    Model(:,13)=num2cell(impr);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    total_label_mc=sum(cell2mat(Model(:,7))~=0);
    idx=find(impr<wT);
    total_mc_delete=sum(cell2mat(Model(idx,7))~=0);
    if total_label_mc - total_mc_delete<=50
        impr(idx(1:total_mc_delete-(total_label_mc-5)))=0.2;
    end

    Model(impr<wT,:)=[];
    end
