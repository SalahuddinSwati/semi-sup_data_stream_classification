    function [ final_label, idxf] = classify( ex, Model )
    
    global acc_win;
    global weight;

    global acc_win_max_size;
    global num_of_knn;
    clu_cent=cell2mat(Model(:,8));
    label_clu_cen=find(cell2mat(Model(:,7))~=0);
    clu_cent=clu_cent(label_clu_cen,:);
    [V widx]=max(weight);
    knn=[1;3;5;7;9;11];
    for i=1:num_of_knn
        [idx, D]=knnsearch(clu_cent,ex.data,'NSMethod','exhaustive','k',knn(i));

        idxn{i}=label_clu_cen(idx);

        nn_label=cell2mat(Model(idxn{i},4));
        [uninn_cls_lb, ia2, cid2] = unique(nn_label,'stable');
        counts2 = sum( bsxfun(@eq, cid2, unique(cid2)') )';
        [Y I]=max(counts2);
        p_label(i)=uninn_cls_lb(I);
        if size(acc_win,2)==acc_win_max_size
            acc_win(:,end)=[];
        end
        if i==1
            eidx=size(acc_win,2)+1;
        else
            eidx=size(acc_win,2);
        end
        if ex.label_flg==1
            if ex.label==p_label(i)
                acc_win(i,eidx)=1;
            else
                
                acc_win(i,eidx)=0;
            end
        end
    end
 
    idxf=idxn{widx};
    final_label=p_label(widx);


    end

