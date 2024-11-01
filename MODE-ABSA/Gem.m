function [maxt,nbSize] = Gem(pIChorm,sIChorm,sIndex,Tm,Trm,bSize,jNumber,pNumber,maxBatch)

pTable = zeros(1,jNumber);%��¼���������ʱ��
sTable = zeros(1,size(Trm,1));%��¼�����쵥Ԫ���ʱ��
timeTable = zeros(3,pNumber);%��¼������ʱ�� ��ʼ-�ӹ�����-�������

tIndex = cumsum(maxBatch);%�����жϷ������������������๤��
pIndex = ones(1,jNumber);%��¼�ǵڼ�������
preS = zeros(1,jNumber);%��¼ǰһ���ӷ�����
preI = zeros(1,jNumber);%��¼ǰһ��������±�
preB = zeros(1,size(Trm,1));%��¼�����쵥Ԫ���һ�����������ĸ�����
preM = zeros(size(Trm,1),jNumber);%��¼֮ǰ��������ʱ��
adjB = zeros(3,jNumber);%��¼��������Ҫ����������
bNum = zeros(1,length(maxBatch));%��¼ÿ�๤�����˶�����
isfalse = zeros(1,jNumber);%��¼�Ƿ��Ǵ�����
for i = 1 : length(maxBatch)
    if  i == 1
        s = 1;
    else
        s = tIndex(i - 1) + 1;
    end
    for j = s : tIndex(i)
        if bSize(j) ~= 0
            bNum(i) = bNum(i) + 1;
        else
            isfalse(j) = 1;
        end
    end
end

for i = 1 : length(pIChorm)
    if bSize(pIChorm(i)) == 0
        continue;
    end
    index = find(tIndex >= pIChorm(i),1);%index��¼�ڼ��๤��
    tz = bSize(pIChorm(i)) * Tm(index).t{pIndex(pIChorm(i))}(sIChorm(i));%�ӹ�ʱ��
    if pIndex(pIChorm(i)) == 1 %��һ������
%         preS(pIChorm(i)) = sIndex(i);
%         preI(pIChorm(i)) = i;
        %���㱾����ʼʱ��
        if sTable(sIndex(i)) > 0
            t = sTable(sIndex(i));
        else
            t = 0;
        end
        %��¼������ʱ��
        timeTable(1,i) = t;
        timeTable(2,i) = t + tz;
        
    else
        tt = Trm(preS(pIChorm(i)),sIndex(i));%����ʱ��
        timeTable(3,preI(pIChorm(i))) = timeTable(2,preI(pIChorm(i))) + tt;
        %��¼�ӷ�����������ʱ��
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

    end
    
    %��϶����
        if sTable(sIndex(i)) ~= 0
            idB = find(tIndex >= preB(sIndex(i)),1);%�ڼ��๤��
            if t > sTable(sIndex(i)) && bNum(idB) >= 2 && preB(sIndex(i)) ~= pIChorm(i)%�м�϶ ����������Ϊ2 ���ǰ��Ϊͬһ����
               mt = preM(sIndex(i),preB(sIndex(i))); %֮ǰ���򵥸�ʱ��
               n = floor((t - sTable(sIndex(i))) / mt);%��������Ҫ���������
               if n > adjB(1,preB(sIndex(i))) %������֮ǰ�� ����
                   adjn = n - adjB(1,preB(sIndex(i)));
                   unitn = floor(adjn / (bNum(idB) - 1));
                   last = adjn - (unitn * (bNum(idB) - 1));
                   if unitn > 0
                       for j = 1 : maxBatch(idB)
                           tempi = tIndex(idB) - j + 1;
                           if bSize(tempi) ~= 0 && tempi ~= preB(sIndex(i))
                               adjB(2,tempi) = adjB(2,tempi) - unitn;
                           end
                       end
                   end
                   if last > 0
                       tempi = tIndex(idB);
                       while last ~= 0
                           if bSize(tempi) ~= 0 && tempi ~= preB(sIndex(i))
                               adjB(2,tempi) = adjB(2,tempi) - 1;
                               last = last - 1;
                           end
                           tempi = tempi - 1;
                       end
                   end
                   adjB(1,preB(sIndex(i))) = n;
               end 
               preM(sIndex(i),:) = zeros(1,jNumber);
            end
        end
        %��¼�ӷ������ʱ��
        sTable(sIndex(i)) =  timeTable(2,i);
        preS(pIChorm(i)) = sIndex(i);
        preI(pIChorm(i)) = i;
        preB(sIndex(i)) = pIChorm(i);
        preM(sIndex(i),pIChorm(i)) = preM(sIndex(i),pIChorm(i)) + Tm(index).t{pIndex(pIChorm(i))}(sIChorm(i));
        pIndex(pIChorm(i)) = pIndex(pIChorm(i)) + 1;
end

adjB(3,:) = adjB(1,:) + adjB(2,:);
nbSize = bSize + adjB(3,:);
%����С��������� �����
while 1
    is = true;
    for i = 1 : length(nbSize)
        index = find(tIndex >= i,1);
        if nbSize(i) < Tm(index).tm(2) * 0.1 && nbSize(i) ~= 0
            is = false;
            unitn = floor( (- nbSize(i)) / (bNum(index) - 1));
            last = (- nbSize(i)) - (unitn * (bNum(index) - 1));
            if unitn ~= 0
               for j = 1 : maxBatch(index)
                   tempi = tIndex(index) - j + 1;
                   
%                    if nbSize(tempi) ~= 0 && tempi ~= i
                   if isfalse(tempi) ~= 1 && tempi ~= i
                       nbSize(tempi) = nbSize(tempi) - unitn;
                   end
               end
           end
           if last ~= 0
               tempi = tIndex(index);
               if last > 0
                   while last ~= 0
                       if isfalse(tempi) ~= 1 && tempi ~= i
                           nbSize(tempi) =  nbSize(tempi) - 1;
                           last = last - 1;
                       end
                       tempi = tempi - 1;
                    end
               else
                   while last ~= 0
                       if isfalse(tempi) ~= 1 && tempi ~= i
                           nbSize(tempi) =  nbSize(tempi) + 1;
                           last = last + 1;
                       end
                       tempi = tempi - 1;
                   end
               end
           end
           nbSize(i) = 0;
           isfalse(i) = 1;%�޴�����
           bNum(index) = bNum(index) - 1;
        end
    end
    if is == true
        break;
    end
end

maxt = max(timeTable(2,:));
end