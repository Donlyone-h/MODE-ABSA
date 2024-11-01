function [pChorm,sChorm,valRank,bSize] = Select2(upChorm,usChorm,uvalRank,ubSize,pop)
pChorm = zeros(pop,size(upChorm,2));
sChorm = zeros(pop,size(usChorm,2));
valRank = zeros(pop,size(uvalRank,2));
bSize = zeros(pop,size(ubSize,2));
c = 1;
for i = 1 : pop
    while(1)
        if(uvalRank(c,5) ~= 0 && ismember(uvalRank(c,5),valRank(1:i-1,5)))
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

for i = 1:pop
    valRank(i,5) = pop + i;
    bSize(i,size(ubSize,2)) = pop + i;
end

end
