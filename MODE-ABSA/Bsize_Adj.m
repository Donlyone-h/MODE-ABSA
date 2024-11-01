function [valRank,bSize] = Bsize_Adj(pIChorm,sIChorm,sIndex,Tm,Trm,jNumber,pNumber,maxBatch)
pop = size(pIChorm,1);
valRank = zeros(pop * 3,5);
%�����趨�ķ������� �õ���������bChorm ����unitC
[obSize,unitC] = BatchRule(pIChorm,sIChorm,sIndex,Tm,Trm,jNumber,pNumber,maxBatch);
bSize = zeros(pop*3,size(obSize,2) + 1);
%��϶������������� ��ʱ��
n = 1;
for i = 1 : pop  
    [t , nbSize] = Gem(pIChorm(i,:),sIChorm(i,:),sIndex(i,:),Tm,Trm,obSize(i,:),jNumber,pNumber,maxBatch);
    valRank(n,1) = t;
    %����ɱ�
    count = 1;
    cSum = 0;
    for j = 1 : size(unitC , 2)
        for k = 1 : size(unitC{i,j},2)
            cSum = cSum + obSize(i,count) * unitC{i,j}(k);
            count = count + 1;
        end
    end
    valRank(n,2) = cSum;
    valRank(n,5) = i;
    bSize(n,:) = [obSize(i,:),i];
    n = n + 1;
    fbSize = obSize(i,:);
    %��ʱ��ΪĿ�ĵ�GEM
        is = false;
        tfbSize = fbSize;
        tt = t;
        tnbSize = nbSize;
        while 1
            [nt , nbS] = Gem(pIChorm(i,:),sIChorm(i,:),sIndex(i,:),Tm,Trm,tnbSize,jNumber,pNumber,maxBatch);
            if nt < tt
                is = true;
                tt = nt;
                tfbSize = tnbSize;
                tnbSize = nbS;
            else
                break;
            end
        end
        if is
        	bSize(n,:) = [tfbSize,i];
            valRank(n,1) = tt;
            %����ɱ�
            count = 1;
            tcSum = 0;
            for j = 1 : size(unitC , 2)
                for k = 1 : size(unitC{i,j},2)
                    tcSum = tcSum + bSize(n,count) * unitC{i,j}(k);
                    count = count + 1;
                end
            end
            valRank(n,2) = tcSum;
            valRank(n,5) = i;
            n = n + 1;
        end

        
        %�Գɱ�ΪĿ�ĵ�GEM
        is = false;
        cfbSize = fbSize;
        ct = t;
        cnbSize = nbSize;
        while 1
            %������ɱ�
            count = 1;
            ncSum = 0;
            for j = 1 : size(unitC , 2)
                for k = 1 : size(unitC{i,j},2)
                    ncSum = ncSum + cnbSize(count) * unitC{i,j}(k);
                    count = count + 1;
                end
            end
            [nt, nbS] = Gem(pIChorm(i,:),sIChorm(i,:),sIndex(i,:),Tm,Trm,cnbSize,jNumber,pNumber,maxBatch);
            if ncSum < cSum
                is = true;
                ct = nt;
                cSum = ncSum;
                cfbSize = cnbSize;
                cnbSize = nbS;
            else
                break;
            end
        end
        if is
            bSize(n,:) = [cfbSize,i];
            valRank(n,1) = ct;
            valRank(n,2) = cSum;
            valRank(n,5) = i;
            n = n + 1;
        end
        
end
if n <= pop*3
    bSize(n: pop*3,:) = [];
    valRank(n: pop*3,:) = [];
end

end