function [difP,difS] = Mutate(pChorm1,pChorm2,sChorm1,sChorm2,jNumber,f)
f = 0.5;
difP = zeros(1,length(pChorm1));
difS = zeros(1,length(pChorm1));
%交叉操作 
%对工序码 POX 交叉
pox1 = randperm(jNumber,round(jNumber/2));
for i = 1 : length(pChorm1)
    if ismember(pChorm1(i),pox1)
        difP(i) = pChorm1(i);
    end
end
index = find(difP==0);
j = 1;
for i = 1 : length(pChorm1)
    if ~ismember(pChorm2(i),pox1)
        difP(index(j)) = pChorm2(i);
        j = j + 1;
        if j > length(index)
            break;
        end
    end 
end
%对机器码
%记录工序码出现下标
index1 = cell(jNumber,1);
index2 = cell(jNumber,1);
gxs = ones(jNumber,1);
for i = 1 : jNumber
    index1{i} = find(pChorm1 == i);
    index2{i} = find(pChorm2 == i);
end
%按f 概率 取
for i = 1 : length(sChorm1)
    if rand < f
        difS(i) = sChorm2(index2{difP(i)}(gxs(difP(i))));
        gxs(difP(i)) = gxs(difP(i)) + 1;
    else
        difS(i) = sChorm1(index1{difP(i)}(gxs(difP(i))));
        gxs(difP(i)) = gxs(difP(i)) + 1;
    end
end

end