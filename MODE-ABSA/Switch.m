function [maxt,cum,nbSize] = Switch(pIChorm,sIChorm,sIndex,Tm,Trm,bSize,unitC,jNumber,pNumber,maxBatch)

tIndex = cumsum(maxBatch);%用于判断分批后子任务属于哪类工件
%批次最大与最小交换
for i = 1 : length(maxBatch)
    max = 0;
    min = +Inf;
    c = 0;
    if  i == 1
        s = 1;
    else
        s = tIndex(i - 1) + 1;
    end
    for j = s : tIndex(i)
        if bSize(j) ~= 0
            c = c + 1;
            if max < bSize(j)
                max = j;
            end
            if min > bSize(j)
                min = j;
            end
        end
    end
    if c >= 2
        temp = bSize(max);
        bSize(max) = bSize(min);
        bSize(min) = temp;
    end
end
nbSize = bSize;
%计算交换后的时间和成本
res = Cal(pIChorm,sIChorm,sIndex,nbSize,unitC,Tm,Trm,jNumber,pNumber,maxBatch);
maxt = res(1);
cum = res(2);
end