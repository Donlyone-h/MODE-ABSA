function bSize = CtoP(Tm,maxBatch,bChorm)
pop = size(bChorm,1);
bSize = zeros(pop,size(bChorm,2));
tempb = bChorm;
tIndex = cumsum(maxBatch);%用于判断分批后子任务属于哪类工件
%bChorm各公件类累加和
sbC = zeros(pop,length(maxBatch));
for i = 1 : length(tIndex)
    if i == 1
        sbC(:,i) = sum(bChorm(:,1:tIndex(1)),2);
    else
        sbC(:,i) = sum(bChorm(:,tIndex(i - 1) + 1:tIndex(i)),2);
    end
end
%分配比例
for j = 1 : pop
    for i = 1 : length(maxBatch)
        isz = ones(1,maxBatch(i));%记录哪些批次大小为0
        s=0;%记录需要重新分配的比例
        if i == 1
            sta = 1;
        else
            sta = tIndex(i - 1) + 1;
        end
        %分配比例
        for k = sta : tIndex(i)
            a = bChorm(j,k) / sbC(j,i);
            if a < 0.1 %小比例
                tempb(j,k) = 0;
                s = s + a;
                isz(k - sta + 1) = 0;
            else
                tempb(j,k) = a;
            end
        end
        %重新分配小比例并计算数量
        last = find(isz,1,'last') + sta - 1;%记录最后有效批次
        left = Tm(i).tm(2);%记录还剩多少没分
        s = s / sum(isz);
        for k = sta : last
            if k == last 
                bSize(j,k) = left;
            else
                if isz(k - sta + 1) ~= 0
                    tempb(j,k) = tempb(j,k) + s;
                    bSize(j,k) = round(Tm(i).tm(2) * tempb(j,k));
                    left = left - bSize(j,k);
                end
            end
            
        end 
    end
end

end