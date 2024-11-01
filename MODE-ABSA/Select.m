function [pChorm,sChorm,valRank,bSize] = Select(upChorm,usChorm,uvalRank,ubSize,pop)
%带精英保留策略的 锦标赛选择
ep = 0.08;
en = floor(ep * size(upChorm,1) / 2);
pChorm = zeros(pop,size(upChorm,2));
sChorm = zeros(pop,size(usChorm,2));
valRank = zeros(pop,size(uvalRank,2));
bSize = zeros(pop,size(ubSize,2));
c = 1;
for i = 1 : en
    while(1)
        if(ismember(uvalRank(c,5),valRank(1:i-1,5)))
            c = c + 1;
        else
            pChorm(i,:) = upChorm(uvalRank(c,5),:);
            sChorm(i,:) = usChorm(uvalRank(c,5),:);
            valRank(i,:) = uvalRank(c,:);
            bSize(i,:) = ubSize(c,:);
            c = c + 1;
            break;
        end
    end
end
%锦标赛选择
c = c - 1; 
s = zeros(1,size(upChorm,1)/2 - en);
for i = en + 1 :  size(upChorm,1) / 2
    while 1
        sp = randperm(size(upChorm,1) - c,2);
        temp = min(sp + c);

        if(ismember(uvalRank(temp,5),valRank(1:i-1,5)))
            continue;
        else
            if isempty(find(s == temp, 1))
                break;
            end

        end
    end
    s(i - en) = temp;
    valRank(i,:) = uvalRank(temp,:);
    bSize(i,:) = ubSize(temp,:);
    pChorm(i,:) = upChorm(uvalRank(temp,5),:);
    sChorm(i,:) = usChorm(uvalRank(temp,5),:);
end
for i = 1:pop
    valRank(i,5) = pop + i;
    bSize(i,size(ubSize,2)) = pop + i;
end

end