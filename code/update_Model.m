    function [ Model] = update_Model( Model, CurrentTime)
   
    global lamda;
    global wT;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    impr=cell2mat(Model(:,9));
    impr=impr.*(2.^(-lamda.*(CurrentTime-cell2mat(Model(:,8)))));
    Model(:,9)=num2cell(impr);

    Model(impr<wT,:)=[];
    end
