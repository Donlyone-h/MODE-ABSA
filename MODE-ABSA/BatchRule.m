function [nbSize,unitC] = BatchRule(pIChorm,sIChorm,sIndex,Tm,Trm,jNumber,pNumber,maxBatch)
% pScheme = cell(size(pChorm,1),size(Tm,2));%��¼���ȷ���
tIndex = cumsum(maxBatch);%�����жϷ������������������๤��
%tz ����ʱ�� tt����ʱ�� sx��ǰ�����쵥Ԫ�е�����˳�� cz ����ɱ� ct ����ɱ� 
bM = cell(size(pIChorm,1),size(Tm,2)); %��¼�����ȷ����ĸ���ָ��
%Bm��ʼ��
for k = 1: size(bM,1)
    for i = 1 : size(bM,2)
        bM{k,i}.tz = zeros(1,maxBatch(i));
        bM{k,i}.sx = zeros(1,maxBatch(i));
        bM{k,i}.cz = zeros(1,maxBatch(i));
        bM{k,i}.ct = zeros(1,maxBatch(i));
    end
end
%��������ȷ����ĸ���ָ��
for i = 1 : size(pIChorm,1)
    pIndex = ones(1,jNumber);%��¼�ǵڼ�������
    preS = zeros(1,jNumber);%��¼ǰһ���ӷ�����
    sxIndex = zeros(1,size(Trm,1));%���㵱ǰ�ӷ����Ѱ��Ŷ��ٸ�����
    for j = 1 : size(pIChorm,2) %���빤���� ���ҵ������ӷ����
        index = find(tIndex >= pIChorm(i,j),1);%index��¼�ڼ��๤��
        
        if pIChorm(i,j) <= tIndex(1)
            bIndex = pIChorm(i,j);%bIndex��¼�ڸ�������
        else
            bIndex =pIChorm(i,j) - tIndex(index - 1);
        end
        %��������ɱ���ʱ��
        if pIndex(pIChorm(i,j)) == 1
            preS(pIChorm(i,j)) = sIndex(i,j);
        else
            bM{i,index}.ct(bIndex) = bM{i,index}.ct(bIndex) + Trm(preS(pIChorm(i,j)),sIndex(i,j)) * Tm(index).tm(3);
            preS(pIChorm(i,j)) = sIndex(i,j);
        end
        %��������ɱ���ʱ��
        bM{i,index}.tz(bIndex) = bM{i,index}.tz(bIndex) + Tm(index).t{pIndex(pIChorm(i,j))}(sIChorm(i,j));
        bM{i,index}.cz(bIndex) = bM{i,index}.cz(bIndex) + Tm(index).c{pIndex(pIChorm(i,j))}(sIChorm(i,j));
        pIndex(pIChorm(i,j)) = pIndex(pIChorm(i,j)) + 1;
        %�������ӷ�����������
        bM{i,index}.sx(bIndex) = bM{i,index}.sx(bIndex) - sxIndex(sIndex(i,j));
        sxIndex(sIndex(i,j)) = sxIndex(sIndex(i,j)) + 1;
    end
end

%unitCÿ������ bSizeÿ������
unitC = cell(size(bM,1),size(bM,2));
nbSize = zeros(size(pIChorm,1),jNumber);
%Bm����ָ���һ�� ���ϲ�����Ȩ�غϲ�ָ��
for i = 1 : size(bM,1)
    count = 1;
    %��ʼ��ȺbChorm bSize
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
        % ��ʼ��Ⱥ
        [bChorm,bSize,count] = Bchorm_Size(bChorm,bSize,bM{i,j},count,Tm,j);
    end
        nbSize(i,:) = Conjoint(pIChorm(i,:),sIChorm(i,:),sIndex(i,:),bChorm,bSize,unitC(i,:),Tm,Trm,jNumber,pNumber,maxBatch);
end

end