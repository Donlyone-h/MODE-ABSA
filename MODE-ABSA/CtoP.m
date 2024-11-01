function bSize = CtoP(Tm,maxBatch,bChorm)
pop = size(bChorm,1);
bSize = zeros(pop,size(bChorm,2));
tempb = bChorm;
tIndex = cumsum(maxBatch);%�����жϷ������������������๤��
%bChorm���������ۼӺ�
sbC = zeros(pop,length(maxBatch));
for i = 1 : length(tIndex)
    if i == 1
        sbC(:,i) = sum(bChorm(:,1:tIndex(1)),2);
    else
        sbC(:,i) = sum(bChorm(:,tIndex(i - 1) + 1:tIndex(i)),2);
    end
end
%�������
for j = 1 : pop
    for i = 1 : length(maxBatch)
        isz = ones(1,maxBatch(i));%��¼��Щ���δ�СΪ0
        s=0;%��¼��Ҫ���·���ı���
        if i == 1
            sta = 1;
        else
            sta = tIndex(i - 1) + 1;
        end
        %�������
        for k = sta : tIndex(i)
            a = bChorm(j,k) / sbC(j,i);
            if a < 0.1 %С����
                tempb(j,k) = 0;
                s = s + a;
                isz(k - sta + 1) = 0;
            else
                tempb(j,k) = a;
            end
        end
        %���·���С��������������
        last = find(isz,1,'last') + sta - 1;%��¼�����Ч����
        left = Tm(i).tm(2);%��¼��ʣ����û��
        s = s / sum(isz);
        for k = sta : last
            if k == last 
                bSize(j,k) = left;
            else
                if isz(k - sta + 1) ~= 0
                    tempb(j,k) = tempb(j,k) + s;
                    bSize(j,k) = round(Tm(i).tm(2) * tempb(j,k));
                    left = left - bSize(j,k);
                end
            end
            
        end 
    end
end

end