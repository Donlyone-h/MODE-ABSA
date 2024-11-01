function [maxt,nbSize] = Gem(pIChorm,sIChorm,sIndex,Tm,Trm,bSize,jNumber,pNumber,maxBatch)

pTable = zeros(1,jNumber);%记录各子批最后时间
sTable = zeros(1,size(Trm,1));%记录各制造单元最后时间
timeTable = zeros(3,pNumber);%记录各工序时间 开始-加工结束-运输结束

tIndex = cumsum(maxBatch);%用于判断分批后子任务属于哪类工件
pIndex = ones(1,jNumber);%记录是第几道工序
preS = zeros(1,jNumber);%记录前一个子服务编号
preI = zeros(1,jNumber);%记录前一道工序的下标
preB = zeros(1,size(Trm,1));%记录各制造单元最后一个操作属于哪个子批
preM = zeros(size(Trm,1),jNumber);%记录之前操作所用时间
adjB = zeros(3,jNumber);%记录各子批需要调整的数量
bNum = zeros(1,length(maxBatch));%记录每类工件分了多少批
isfalse = zeros(1,jNumber);%记录是否考虑此批次
for i = 1 : length(maxBatch)
    if  i == 1
        s = 1;
    else
        s = tIndex(i - 1) + 1;
    end
    for j = s : tIndex(i)
        if bSize(j) ~= 0
            bNum(i) = bNum(i) + 1;
        else
            isfalse(j) = 1;
        end
    end
end

for i = 1 : length(pIChorm)
    if bSize(pIChorm(i)) == 0
        continue;
    end
    index = find(tIndex >= pIChorm(i),1);%index记录第几类工件
    tz = bSize(pIChorm(i)) * Tm(index).t{pIndex(pIChorm(i))}(sIChorm(i));%加工时间
    if pIndex(pIChorm(i)) == 1 %第一道工序
%         preS(pIChorm(i)) = sIndex(i);
%         preI(pIChorm(i)) = i;
        %计算本工序开始时间
        if sTable(sIndex(i)) > 0
            t = sTable(sIndex(i));
        else
            t = 0;
        end
        %记录本工序时间
        timeTable(1,i) = t;
        timeTable(2,i) = t + tz;
        
    else
        tt = Trm(preS(pIChorm(i)),sIndex(i));%运输时间
        timeTable(3,preI(pIChorm(i))) = timeTable(2,preI(pIChorm(i))) + tt;
        %记录子服务和子批最后时间
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

    end
    
    %间隙挤出
        if sTable(sIndex(i)) ~= 0
            idB = find(tIndex >= preB(sIndex(i)),1);%第几类工件
            if t > sTable(sIndex(i)) && bNum(idB) >= 2 && preB(sIndex(i)) ~= pIChorm(i)%有间隙 批次数至少为2 间隔前后不为同一子批
               mt = preM(sIndex(i),preB(sIndex(i))); %之前工序单个时间
               n = floor((t - sTable(sIndex(i))) / mt);%该子批需要增大的数量
               if n > adjB(1,preB(sIndex(i))) %数量比之前大 调整
                   adjn = n - adjB(1,preB(sIndex(i)));
                   unitn = floor(adjn / (bNum(idB) - 1));
                   last = adjn - (unitn * (bNum(idB) - 1));
                   if unitn > 0
                       for j = 1 : maxBatch(idB)
                           tempi = tIndex(idB) - j + 1;
                           if bSize(tempi) ~= 0 && tempi ~= preB(sIndex(i))
                               adjB(2,tempi) = adjB(2,tempi) - unitn;
                           end
                       end
                   end
                   if last > 0
                       tempi = tIndex(idB);
                       while last ~= 0
                           if bSize(tempi) ~= 0 && tempi ~= preB(sIndex(i))
                               adjB(2,tempi) = adjB(2,tempi) - 1;
                               last = last - 1;
                           end
                           tempi = tempi - 1;
                       end
                   end
                   adjB(1,preB(sIndex(i))) = n;
               end 
               preM(sIndex(i),:) = zeros(1,jNumber);
            end
        end
        %记录子服务最后时间
        sTable(sIndex(i)) =  timeTable(2,i);
        preS(pIChorm(i)) = sIndex(i);
        preI(pIChorm(i)) = i;
        preB(sIndex(i)) = pIChorm(i);
        preM(sIndex(i),pIChorm(i)) = preM(sIndex(i),pIChorm(i)) + Tm(index).t{pIndex(pIChorm(i))}(sIChorm(i));
        pIndex(pIChorm(i)) = pIndex(pIChorm(i)) + 1;
end

adjB(3,:) = adjB(1,:) + adjB(2,:);
nbSize = bSize + adjB(3,:);
%出现小于零的批次 则调整
while 1
    is = true;
    for i = 1 : length(nbSize)
        index = find(tIndex >= i,1);
        if nbSize(i) < Tm(index).tm(2) * 0.1 && nbSize(i) ~= 0
            is = false;
            unitn = floor( (- nbSize(i)) / (bNum(index) - 1));
            last = (- nbSize(i)) - (unitn * (bNum(index) - 1));
            if unitn ~= 0
               for j = 1 : maxBatch(index)
                   tempi = tIndex(index) - j + 1;
                   
%                    if nbSize(tempi) ~= 0 && tempi ~= i
                   if isfalse(tempi) ~= 1 && tempi ~= i
                       nbSize(tempi) = nbSize(tempi) - unitn;
                   end
               end
           end
           if last ~= 0
               tempi = tIndex(index);
               if last > 0
                   while last ~= 0
                       if isfalse(tempi) ~= 1 && tempi ~= i
                           nbSize(tempi) =  nbSize(tempi) - 1;
                           last = last - 1;
                       end
                       tempi = tempi - 1;
                    end
               else
                   while last ~= 0
                       if isfalse(tempi) ~= 1 && tempi ~= i
                           nbSize(tempi) =  nbSize(tempi) + 1;
                           last = last + 1;
                       end
                       tempi = tempi - 1;
                   end
               end
           end
           nbSize(i) = 0;
           isfalse(i) = 1;%无此批次
           bNum(index) = bNum(index) - 1;
        end
    end
    if is == true
        break;
    end
end

maxt = max(timeTable(2,:));
end