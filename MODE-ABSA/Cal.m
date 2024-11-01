function valRank = Cal(pIChorm,sIChorm,sIndex,bSize,unitC,Tm,Trm,jNumber,pNumber,maxBatch)
%valRank储存时间和成本两个目标值 也用于后续存储帕累托等级和拥挤度
pop = size(pIChorm,1);
valRank = zeros(pop,4);
for i = 1 : pop
    %计算成本
    count = 1;
    cSum = 0;
    for j = 1 : size(unitC , 2)
        for k = 1 : size(unitC{i,j},2)
            cSum = cSum + bSize(i,count) * unitC{i,j}(k);
            count = count + 1;
        end
    end
    valRank(i,2) = cSum;
    %计算时间
    t = CalTime(pIChorm(i,:),sIChorm(i,:),sIndex(i,:),Tm,Trm,bSize(i,:),jNumber,pNumber,maxBatch);
    valRank(i,1) = max(t(2,:));
end

end