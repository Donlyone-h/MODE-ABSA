function [bChorm,bSize,ncount] = Bchorm_Size(obChorm,obSize,bM,count,Tm,j)
    bChorm = obChorm;
    bSize = obSize;
    init(1,:) = normalization(bM.tz);
    init(2,:) = normalization(bM.sx);
    init(3,:) = normalization(bM.cz);
    init(4,:) = normalization(bM.ct) ;
    
    for i = 1 : 4
        tempcount = count;
        %�������С��0.1����Ϊ0�������ָ�������ֵ
        isz = ones(1,length(init(i,:)));%��¼��Щ���δ�СΪ0
        s=0;%��¼��Ҫ���·���ı���
        for l = 1: length(init(i,:))
            if init(i,l) < 0.1
                isz(l) = 0;
                s = s + init(i,l);
            end
        end
        s = s / sum(isz);
        left = Tm(j).tm(2);%��¼��ʣ����û��
        last = find(isz,1,'last');%��¼�����Ч����
        for k = 1: length(init(i,:))
            if isz(k) ~= 0
                bChorm(i,tempcount) = init(i,k) + s;
            else
                bChorm(i,tempcount) = 0;
            end
            if k < last && bChorm(i,tempcount)~= 0%���շ������� ��������
                bSize(i,tempcount) = round(Tm(j).tm(2) * bChorm(i,tempcount));
                left = left - bSize(i,tempcount);
            elseif k == last
                bSize(i,tempcount) = left;%���һ��Ϊʣ�µ�ȫ��
            end
            tempcount = tempcount + 1;
        end
    end
    ncount = tempcount;
end