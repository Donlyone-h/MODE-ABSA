function sIndex = CtoI(pChorm,sChorm,Tm,maxBatch,jNumber)
sIndex = sChorm;
pop = size(pChorm,1);
pNumber = size(pChorm,2);
tIndex = cumsum(maxBatch);%�����жϷ������������������๤��
%�ӷ�����
for i = 1 : pop
    pIndex = ones(1,jNumber);%��¼�ڼ�������
    for j = 1 : pNumber
        index = find(tIndex >= pChorm(i,j),1);%index��¼�ڼ��๤��
        sIndex(i,j) = Tm(index).m{pIndex(pChorm(i,j))}(sChorm(i,j));%��¼���쵥Ԫ���Ӧ���ӷ�����
        pIndex(pChorm(i,j)) = pIndex(pChorm(i,j)) + 1;
    end
end

end