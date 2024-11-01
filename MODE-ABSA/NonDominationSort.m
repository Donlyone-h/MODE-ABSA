function [valRank,b] = NonDominationSort(uvalRank,ubSize)
b = ubSize;
valRank = uvalRank;
%���ٷ�֧������
front = 1;%�����еȼ�
f(front).f = [];%��¼�����еȼ�Ϊfront�ĸ��弯��
individual = cell(size(valRank,1),1);

for i = 1 : size(valRank,1)
    individual{i}.n=0; %��¼����i��֧��ĸ�������
    individual{i}.p=[];%��¼����i֧��ĸ��弯��
    for j = 1 : size(valRank,1)
        %�Ƚ�Ŀ��ֵ��С
        less = 0;equal = 0;more = 0;
        for k = 1 : 2
            if uvalRank(i,k) < uvalRank(j,k)
                less = less + 1;
            elseif uvalRank(i,k) == uvalRank(j,k)
                equal = equal + 1;
            else
                more = more + 1;
            end
        end
        %ȷ��֧���ϵ
        if(less == 0 && equal ~= 2)%��j֧��
            individual{i}.n = individual{i}.n + 1;
        elseif(more == 0 && equal ~= 2)%֧��j
            individual{i}.p = [individual{i}.p,j];
        end
    end
    %��¼�����еȼ�Ϊ1�ĸ���
    if individual{i}.n == 0 
        uvalRank(i,3)=1;
        f(front).f = [f(front).f,i];
    end
end
%����ȷ�����������еȼ�����
while ~isempty(f(front).f)
    Q=[];%��¼��һ�������еȼ��ĸ���
    for i=1:length(f(front).f)
        if ~isempty(individual{f(front).f(i)}.p)
            %��֧�������һ
            for j=1:length(individual{f(front).f(i)}.p)
                individual{individual{f(front).f(i)}.p(j)}.n = ...
                    individual{individual{f(front).f(i)}.p(j)}.n - 1;
                %�õ��������Ÿ���
                if individual{individual{f(front).f(i)}.p(j)}.n == 0
                    uvalRank(individual{f(front).f(i)}.p(j) , 3)= front + 1;
                    Q = [Q,individual{f(front).f(i)}.p(j)];
                end
            end
        end
    end
    front = front + 1;
    f(front).f = Q;
end
%sortedIndex��¼���������еȼ����к����
[~,sortedIndex] = sort(uvalRank(:,3));

%ӵ���ȼ���
currentIndex=0;
for front = 1:(length(f) - 1)
    y = uvalRank(1 : length(f(front).f),:);
    previousIndex = currentIndex + 1;
    for i = 1 : length(f(front).f)
        y(i,:) = uvalRank(sortedIndex(currentIndex + i),:);%��¼��ǰ�����еȼ��¸���
    end
    currentIndex=currentIndex + i;
    
    for i=1:2
        [~,indexObj]=sort(y(:,i));
        sortedObj = y;
        for j = 1:length(indexObj)
            sortedObj(j,:) = y(indexObj(j),:);%��¼����Ŀ�꺯��ֵ��������
        end
        f_max=sortedObj(length(indexObj),i);%Ŀ�꺯�����ֵ
        f_min=sortedObj(1,i);%��Сֵ
        y(indexObj(length(indexObj)),4) = inf;%�����ֵ����Сֵ�����ӵ��������Ϊ�����
        y(indexObj(1),4) = inf;
        for j= 2 : length(indexObj)-1 %ӵ���ȼ��� 
            next_obj = sortedObj(j+1,i);
            previous_obj = sortedObj(j-1,i);
            if(f_max - f_min == 0)
                y(indexObj(j),4) = inf;
            else
                y(indexObj(j),4) = y(indexObj(j),4) + (next_obj - previous_obj)/(f_max - f_min);
            end
        end
    end
    for i = 1 : length(f(front).f)
        uvalRank(sortedIndex(previousIndex - 1 + i),:) = y(i,:);%uvalRank�м�¼ӵ���Ƚ��
    end
    %sortedIndex ������ӵ���ȴӴ�С��¼���
    [~,yIndex] = sort(y(:,4),'descend');
    x = sortedIndex(previousIndex:currentIndex);
    for i = 1 : size(y,1)
        sortedIndex(previousIndex - 1 + i) = x(yIndex(i));
    end
end
%�õ���֧�������Ľ��
for i = 1 : size(valRank,1)
    b(i,:) = ubSize(sortedIndex(i),:);
    valRank(i,:) = uvalRank(sortedIndex(i),:);
end

end
    
