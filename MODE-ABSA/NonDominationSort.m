function [valRank,b] = NonDominationSort(uvalRank,ubSize)
b = ubSize;
valRank = uvalRank;
%快速非支配排序
front = 1;%帕累托等级
f(front).f = [];%记录帕累托等级为front的个体集合
individual = cell(size(valRank,1),1);

for i = 1 : size(valRank,1)
    individual{i}.n=0; %记录个体i被支配的个体数量
    individual{i}.p=[];%记录个体i支配的个体集合
    for j = 1 : size(valRank,1)
        %比较目标值大小
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
        %确定支配关系
        if(less == 0 && equal ~= 2)%被j支配
            individual{i}.n = individual{i}.n + 1;
        elseif(more == 0 && equal ~= 2)%支配j
            individual{i}.p = [individual{i}.p,j];
        end
    end
    %记录帕累托等级为1的个体
    if individual{i}.n == 0 
        uvalRank(i,3)=1;
        f(front).f = [f(front).f,i];
    end
end
%依次确定后续帕累托等级个体
while ~isempty(f(front).f)
    Q=[];%记录下一个帕累托等级的个体
    for i=1:length(f(front).f)
        if ~isempty(individual{f(front).f(i)}.p)
            %被支配个数减一
            for j=1:length(individual{f(front).f(i)}.p)
                individual{individual{f(front).f(i)}.p(j)}.n = ...
                    individual{individual{f(front).f(i)}.p(j)}.n - 1;
                %得到其中最优个体
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
%sortedIndex记录按照帕累托等级排列后序号
[~,sortedIndex] = sort(uvalRank(:,3));

%拥挤度计算
currentIndex=0;
for front = 1:(length(f) - 1)
    y = uvalRank(1 : length(f(front).f),:);
    previousIndex = currentIndex + 1;
    for i = 1 : length(f(front).f)
        y(i,:) = uvalRank(sortedIndex(currentIndex + i),:);%记录当前帕累托等级下个体
    end
    currentIndex=currentIndex + i;
    
    for i=1:2
        [~,indexObj]=sort(y(:,i));
        sortedObj = y;
        for j = 1:length(indexObj)
            sortedObj(j,:) = y(indexObj(j),:);%记录按照目标函数值排序后个体
        end
        f_max=sortedObj(length(indexObj),i);%目标函数最大值
        f_min=sortedObj(1,i);%最小值
        y(indexObj(length(indexObj)),4) = inf;%给最大值及最小值个体的拥挤度设置为无穷大
        y(indexObj(1),4) = inf;
        for j= 2 : length(indexObj)-1 %拥挤度计算 
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
        uvalRank(sortedIndex(previousIndex - 1 + i),:) = y(i,:);%uvalRank中记录拥挤度结果
    end
    %sortedIndex 并按照拥挤度从大到小记录序号
    [~,yIndex] = sort(y(:,4),'descend');
    x = sortedIndex(previousIndex:currentIndex);
    for i = 1 : size(y,1)
        sortedIndex(previousIndex - 1 + i) = x(yIndex(i));
    end
end
%得到非支配排序后的结果
for i = 1 : size(valRank,1)
    b(i,:) = ubSize(sortedIndex(i),:);
    valRank(i,:) = uvalRank(sortedIndex(i),:);
end

end
    
