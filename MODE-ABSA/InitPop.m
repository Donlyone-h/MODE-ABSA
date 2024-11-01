function [pChorm,sChorm,sIndex] = InitPop(Tm,maxBatch,pNumber,jNumber,pop)
%用均匀随机分布及其相反的解生成一个解的总体
pChorm = zeros(2*pop,pNumber);%工序码
sChorm = zeros(2*pop,pNumber);%制造单元码
sIndex = zeros(2*pop,pNumber);%制造单元码对应的制造单元编号
tIndex = cumsum(maxBatch);%用于判断分批后子任务属于哪类工件
%初始化工序码和制造单元码

last = zeros(1,sum(maxBatch));
for i = 1 : length(last)
    index = find(tIndex >= i,1);%index记录第几类工件
    last(i) = Tm(index).tm(1);
end
for i = 1 : 2*pop
    %工序码
    templast = last;
    for j = 1 : pNumber
        while 1
            p = randi([1,length(last)]);
            if(templast(p) > 0)
                pChorm(i,j) = p;
                templast(p) = templast(p) - 1;
                break;
            end
        end
    end
    
    %制造单元码
    pIndex = ones(1,jNumber);%记录第几道工序
    for j = 1 : pNumber
        index = find(tIndex >= pChorm(i,j),1);%index记录第几类工件
        s = size(Tm(index).m{pIndex(pChorm(i,j))},2);%可选制造单元个数
        sChorm(i,j) = randi([1,s]);
        sIndex(i,j) = Tm(index).m{pIndex(pChorm(i,j))}(sChorm(i,j));%记录制造单元码对应的制造单元编号
        pIndex(pChorm(i,j)) = pIndex(pChorm(i,j)) + 1;
    end
end

end
