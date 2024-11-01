function valRank = Cal(pIChorm,sIChorm,sIndex,bSize,unitC,Tm,Trm,jNumber,pNumber,maxBatch)
%valRank����ʱ��ͳɱ�����Ŀ��ֵ Ҳ���ں����洢�����еȼ���ӵ����
pop = size(pIChorm,1);
valRank = zeros(pop,4);
for i = 1 : pop
    %����ɱ�
    count = 1;
    cSum = 0;
    for j = 1 : size(unitC , 2)
        for k = 1 : size(unitC{i,j},2)
            cSum = cSum + bSize(i,count) * unitC{i,j}(k);
            count = count + 1;
        end
    end
    valRank(i,2) = cSum;
    %����ʱ��
    t = CalTime(pIChorm(i,:),sIChorm(i,:),sIndex(i,:),Tm,Trm,bSize(i,:),jNumber,pNumber,maxBatch);
    valRank(i,1) = max(t(2,:));
end

end