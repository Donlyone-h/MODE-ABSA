function score = IGD(PopObj,PF)
    mint = min(PF(:,1));
    maxt = max(PF(:,1));
    minc = min(PF(:,2));
    maxc = max(PF(:,2));

    for i = 1 : size(PopObj,1)
        PopObj(i,1) = (PopObj(i,1) - mint) / (maxt - mint);
        PopObj(i,2) = (PopObj(i,2) - minc) / (maxc - minc);
    end
    for i = 1 : size(PF,1)
        PF(i,1) = (PF(i,1) - mint) / (maxt - mint);
        PF(i,2) = (PF(i,2) - minc) / (maxc - minc);
    end

    Distance = zeros(size(PF,1),1);
    for i = 1:size(PF,1)
        for j = 1:size(PopObj,1)
            if j == 1
                mins = sqrt((PF(i,1) - PopObj(j,1))^2 + (PF(i,2) - PopObj(j,2))^2);
            else
                temp = sqrt((PF(i,1) - PopObj(j,1))^2 + (PF(i,2) - PopObj(j,2))^2);
                if temp < mins
                    mins = temp;
                end
            end
        end
        Distance(i) = mins;
    end
    score  = mean(Distance);
end