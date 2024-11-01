function sIndex = CtoI(pChorm,sChorm,Tm,maxBatch,jNumber)
sIndex = sChorm;
pop = size(pChorm,1);
pNumber = size(pChorm,2);
tIndex = cumsum(maxBatch);%用于判断分批后子任务属于哪类工件
%子服务码
for i = 1 : pop
    pIndex = ones(1,jNumber);%记录第几道工序
    for j = 1 : pNumber
        index = find(tIndex >= pChorm(i,j),1);%index记录第几类工件
        sIndex(i,j) = Tm(index).m{pIndex(pChorm(i,j))}(sChorm(i,j));%记录制造单元码对应的子服务编号
        pIndex(pChorm(i,j)) = pIndex(pChorm(i,j)) + 1;
    end
end

end