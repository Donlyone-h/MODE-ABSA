function [nbSize,unitC] = BatchRule(pIChorm,sIChorm,sIndex,Tm,Trm,jNumber,pNumber,maxBatch)
% pScheme = cell(size(pChorm,1),size(Tm,2));%记录调度方案
tIndex = cumsum(maxBatch);%用于判断分批后子任务属于哪类工件
%tz 制造时间 tt运输时间 sx当前在制造单元中的制造顺序 cz 制造成本 ct 运输成本 
bM = cell(size(pIChorm,1),size(Tm,2)); %记录各调度方案的各项指标
%Bm初始化
for k = 1: size(bM,1)
    for i = 1 : size(bM,2)
        bM{k,i}.tz = zeros(1,maxBatch(i));
        bM{k,i}.sx = zeros(1,maxBatch(i));
        bM{k,i}.cz = zeros(1,maxBatch(i));
        bM{k,i}.ct = zeros(1,maxBatch(i));
    end
end
%计算各调度方案的各项指标
for i = 1 : size(pIChorm,1)
    pIndex = ones(1,jNumber);%记录是第几道工序
    preS = zeros(1,jNumber);%记录前一个子服务编号
    sxIndex = zeros(1,size(Trm,1));%计算当前子服务已安排多少各任务
    for j = 1 : size(pIChorm,2) %解码工序码 及找到对于子服务号
        index = find(tIndex >= pIChorm(i,j),1);%index记录第几类工件
        
        if pIChorm(i,j) <= tIndex(1)
            bIndex = pIChorm(i,j);%bIndex记录第个子批次
        else
            bIndex =pIChorm(i,j) - tIndex(index - 1);
        end
        %计算运输成本和时间
        if pIndex(pIChorm(i,j)) == 1
            preS(pIChorm(i,j)) = sIndex(i,j);
        else
            bM{i,index}.ct(bIndex) = bM{i,index}.ct(bIndex) + Trm(preS(pIChorm(i,j)),sIndex(i,j)) * Tm(index).tm(3);
            preS(pIChorm(i,j)) = sIndex(i,j);
        end
        %计算制造成本和时间
        bM{i,index}.tz(bIndex) = bM{i,index}.tz(bIndex) + Tm(index).t{pIndex(pIChorm(i,j))}(sIChorm(i,j));
        bM{i,index}.cz(bIndex) = bM{i,index}.cz(bIndex) + Tm(index).c{pIndex(pIChorm(i,j))}(sIChorm(i,j));
        pIndex(pIChorm(i,j)) = pIndex(pIChorm(i,j)) + 1;
        %计算在子服务的制造次序
        bM{i,index}.sx(bIndex) = bM{i,index}.sx(bIndex) - sxIndex(sIndex(i,j));
        sxIndex(sIndex(i,j)) = sxIndex(sIndex(i,j)) + 1;
    end
end

%unitC每批单价 bSize每批数量
unitC = cell(size(bM,1),size(bM,2));
nbSize = zeros(size(pIChorm,1),jNumber);
%Bm各项指标归一化 并合并根据权重合并指标
for i = 1 : size(bM,1)
    count = 1;
    %初始种群bChorm bSize
    bChorm = zeros(4,jNumber);
    bSize = zeros(4,jNumber);
    for j = 1: size(bM,2)
        unitC{i,j} = bM{i,j}.cz + bM{i,j}.ct;
        bM{i,j}.tz = mmnormal(1./bM{i,j}.tz);
        bM{i,j}.sx = mmnormal(bM{i,j}.sx);
        bM{i,j}.cz = mmnormal(1./bM{i,j}.cz);
        temp = bM{i,j}.ct;
        for k = 1 : length(temp)
            if temp(k) == 0
                bM{i,j}.ct(k) = 0.01;
            end
        end
        bM{i,j}.ct = mmnormal(1./bM{i,j}.ct);
        % 初始种群
        [bChorm,bSize,count] = Bchorm_Size(bChorm,bSize,bM{i,j},count,Tm,j);
    end
        nbSize(i,:) = Conjoint(pIChorm(i,:),sIChorm(i,:),sIndex(i,:),bChorm,bSize,unitC(i,:),Tm,Trm,jNumber,pNumber,maxBatch);
end

end