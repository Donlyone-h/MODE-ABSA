function timeTable = CalTime(pIChorm,sIChorm,sIndex,Tm,Trm,bSize,jNumber,pNumber,maxBatch)
pTable = zeros(1,jNumber);%记录各子批最后时间
sTable = zeros(1,size(Trm,1));%记录各制造单元最后时间
timeTable = zeros(3,pNumber);%记录各工序时间 开始-加工结束-运输结束

tIndex = cumsum(maxBatch);%用于判断分批后子任务属于哪类工件
pIndex = ones(1,jNumber);%记录是第几道工序
preS = zeros(1,jNumber);%记录前一个子服务编号
preI = zeros(1,jNumber);%记录前一道工序的下标
for i = 1 : length(pIChorm)
    index = find(tIndex >= pIChorm(i),1);%index记录第几类工件
    tz = bSize(pIChorm(i)) * Tm(index).t{pIndex(pIChorm(i))}(sIChorm(i));%加工时间
    if pIndex(pIChorm(i)) == 1 %第一道工序
        preS(pIChorm(i)) = sIndex(i);
        preI(pIChorm(i)) = i;
        %计算本工序开始时间
        if sTable(sIndex(i)) > 0
            t = sTable(sIndex(i));
        else
            t = 0;
        end
        %记录本工序时间
        timeTable(1,i) = t;
        timeTable(2,i) = t + tz;
        %记录制造单元最后时间
        sTable(sIndex(i)) =  timeTable(2,i);
        pIndex(pIChorm(i)) = pIndex(pIChorm(i)) + 1;
    else
        tt = Trm(preS(pIChorm(i)),sIndex(i));%运输时间
        timeTable(3,preI(pIChorm(i))) = timeTable(2,preI(pIChorm(i))) + tt;
        %记录制造单元和子批最后时间
        pTable(pIChorm(preI(pIChorm(i)))) = timeTable(3,preI(pIChorm(i)));
        %计算本工序开始时间
        if pTable(pIChorm(i)) > sTable(sIndex(i))
            t = pTable(pIChorm(i));
        else
            t = sTable(sIndex(i));
        end
        %记录本工序时间
        timeTable(1,i) = t;
        timeTable(2,i) = t + tz;
        %记录制造单元最后时间
        sTable(sIndex(i)) =  timeTable(2,i);
        
        preS(pIChorm(i)) = sIndex(i);
        preI(pIChorm(i)) = i;
        pIndex(pIChorm(i)) = pIndex(pIChorm(i)) + 1;
    end
end

end
