function timeTable = CalTime(pIChorm,sIChorm,sIndex,Tm,Trm,bSize,jNumber,pNumber,maxBatch)
pTable = zeros(1,jNumber);%��¼���������ʱ��
sTable = zeros(1,size(Trm,1));%��¼�����쵥Ԫ���ʱ��
timeTable = zeros(3,pNumber);%��¼������ʱ�� ��ʼ-�ӹ�����-�������

tIndex = cumsum(maxBatch);%�����жϷ������������������๤��
pIndex = ones(1,jNumber);%��¼�ǵڼ�������
preS = zeros(1,jNumber);%��¼ǰһ���ӷ�����
preI = zeros(1,jNumber);%��¼ǰһ��������±�
for i = 1 : length(pIChorm)
    index = find(tIndex >= pIChorm(i),1);%index��¼�ڼ��๤��
    tz = bSize(pIChorm(i)) * Tm(index).t{pIndex(pIChorm(i))}(sIChorm(i));%�ӹ�ʱ��
    if pIndex(pIChorm(i)) == 1 %��һ������
        preS(pIChorm(i)) = sIndex(i);
        preI(pIChorm(i)) = i;
        %���㱾����ʼʱ��
        if sTable(sIndex(i)) > 0
            t = sTable(sIndex(i));
        else
            t = 0;
        end
        %��¼������ʱ��
        timeTable(1,i) = t;
        timeTable(2,i) = t + tz;
        %��¼���쵥Ԫ���ʱ��
        sTable(sIndex(i)) =  timeTable(2,i);
        pIndex(pIChorm(i)) = pIndex(pIChorm(i)) + 1;
    else
        tt = Trm(preS(pIChorm(i)),sIndex(i));%����ʱ��
        timeTable(3,preI(pIChorm(i))) = timeTable(2,preI(pIChorm(i))) + tt;
        %��¼���쵥Ԫ���������ʱ��
        pTable(pIChorm(preI(pIChorm(i)))) = timeTable(3,preI(pIChorm(i)));
        %���㱾����ʼʱ��
        if pTable(pIChorm(i)) > sTable(sIndex(i))
            t = pTable(pIChorm(i));
        else
            t = sTable(sIndex(i));
        end
        %��¼������ʱ��
        timeTable(1,i) = t;
        timeTable(2,i) = t + tz;
        %��¼���쵥Ԫ���ʱ��
        sTable(sIndex(i)) =  timeTable(2,i);
        
        preS(pIChorm(i)) = sIndex(i);
        preI(pIChorm(i)) = i;
        pIndex(pIChorm(i)) = pIndex(pIChorm(i)) + 1;
    end
end

end
