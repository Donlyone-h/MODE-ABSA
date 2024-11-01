function [pChorm,sChorm,sIndex] = InitPop(Tm,maxBatch,pNumber,jNumber,pop)
%�þ�������ֲ������෴�Ľ�����һ���������
pChorm = zeros(2*pop,pNumber);%������
sChorm = zeros(2*pop,pNumber);%���쵥Ԫ��
sIndex = zeros(2*pop,pNumber);%���쵥Ԫ���Ӧ�����쵥Ԫ���
tIndex = cumsum(maxBatch);%�����жϷ������������������๤��
%��ʼ������������쵥Ԫ��

last = zeros(1,sum(maxBatch));
for i = 1 : length(last)
    index = find(tIndex >= i,1);%index��¼�ڼ��๤��
    last(i) = Tm(index).tm(1);
end
for i = 1 : 2*pop
    %������
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
    
    %���쵥Ԫ��
    pIndex = ones(1,jNumber);%��¼�ڼ�������
    for j = 1 : pNumber
        index = find(tIndex >= pChorm(i,j),1);%index��¼�ڼ��๤��
        s = size(Tm(index).m{pIndex(pChorm(i,j))},2);%��ѡ���쵥Ԫ����
        sChorm(i,j) = randi([1,s]);
        sIndex(i,j) = Tm(index).m{pIndex(pChorm(i,j))}(sChorm(i,j));%��¼���쵥Ԫ���Ӧ�����쵥Ԫ���
        pIndex(pChorm(i,j)) = pIndex(pChorm(i,j)) + 1;
    end
end

end
