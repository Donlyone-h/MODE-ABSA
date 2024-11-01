function [bChorm,bSize,ncount] = Bchorm_Size(obChorm,obSize,bM,count,Tm,j)
    bChorm = obChorm;
    bSize = obSize;
    init(1,:) = normalization(bM.tz);
    init(2,:) = normalization(bM.sx);
    init(3,:) = normalization(bM.cz);
    init(4,:) = normalization(bM.ct) ;
    
    for i = 1 : 4
        tempcount = count;
        %如果比例小于0.1就设为0，并均分给其他数值
        isz = ones(1,length(init(i,:)));%记录哪些批次大小为0
        s=0;%记录需要重新分配的比例
        for l = 1: length(init(i,:))
            if init(i,l) < 0.1
                isz(l) = 0;
                s = s + init(i,l);
            end
        end
        s = s / sum(isz);
        left = Tm(j).tm(2);%记录还剩多少没分
        last = find(isz,1,'last');%记录最后有效批次
        for k = 1: length(init(i,:))
            if isz(k) ~= 0
                bChorm(i,tempcount) = init(i,k) + s;
            else
                bChorm(i,tempcount) = 0;
            end
            if k < last && bChorm(i,tempcount)~= 0%按照分批编码 分配数量
                bSize(i,tempcount) = round(Tm(j).tm(2) * bChorm(i,tempcount));
                left = left - bSize(i,tempcount);
            elseif k == last
                bSize(i,tempcount) = left;%最后一批为剩下的全部
            end
            tempcount = tempcount + 1;
        end
    end
    ncount = tempcount;
end