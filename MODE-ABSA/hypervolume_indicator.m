function hv = hypervolume_indicator(S, PF)
    % S: 解集，每一行表示一个解向量，例如[1, 2; 3, 4]表示两个解(1, 2)和(3, 4)
    % ref_point: 参考点向量，例如[5, 5]表示参考点(5, 5)
    ref_point = [1,1];
    mint = min(PF(:,1));
    maxt = max(PF(:,1));
    minc = min(PF(:,2));
    maxc = max(PF(:,2));
    for i = 1 : size(S,1)
        S(i,1) = (S(i,1) - mint) / (maxt - mint);
        S(i,2) = (S(i,2) - minc) / (maxc - minc);
    end
    % 对目标空间中的解按照升序进行排序
    sorted_S = sortrows(S, 1);
    sorted_S(sorted_S(:,1) > 1 | sorted_S(:,1) < 0,:) = [];
    sorted_S(sorted_S(:,2) > 1 | sorted_S(:,2) < 0,:) = [];
    sorted_S = unique(sorted_S, 'rows'); % 去重
    % 初始化超体积
    hv = 0;
    
    % 计算每个矩形的超体积并累加
    for i = 1:size(sorted_S, 1)
        if i == 1
            h = ref_point(2) - sorted_S(i, 2);
        else
            h = sorted_S(i-1, 2) - sorted_S(i, 2);
        end
        w = ref_point(1) - sorted_S(i, 1);
        hv = hv + abs(h * w);
    end
end