function bSize = Conjoint(pIChorm,sIChorm,sIndex,bChorm,bSize,unitC,Tm,Trm,jNumber,pNumber,maxBatch)
    f = 0.7;
    cr = 0.3;
    %计算适应度
    valRank = zeros(4,4);
    for i = 1 : 4
        valRank(i,:) = Cal(pIChorm,sIChorm,sIndex,bSize(i,:),unitC,Tm,Trm,jNumber,pNumber,maxBatch);  
    end
    %生成协同种群
    abChorm = zeros(4,size(bChorm,2));
    abSize = zeros(4,size(bSize,2));
    valRanka = zeros(4,4);
    [~,bt] = min(valRank(:,1));
    [~,bc] = min(valRank(:,2));
    abChorm(1,:) = bChorm(bt,:);
    abSize(1,:) = bSize(bt,:);
    valRanka(1,:) = valRank(bt,:);
    abChorm(2,:) = bChorm(bc,:);
    abSize(2,:) = bSize(bc,:);
    valRanka(2,:) = valRank(bc,:);
    %% 一
    tbChorm1 = bChorm;
    cbChorm1 = bChorm;
    %tbChorm变异 current-to-best/1/bin 交叉
    for i = 1:4
        while 1
            r = randi(4);
            if r ~= i
                break;
            end
        end
        tbChorm1(i,:) = tbChorm1(i,:) + f * (tbChorm1(bt,:) - tbChorm1(i,:)) + f *  (tbChorm1(r,:) - abChorm(2,:));
        %交叉
        k = unidrnd(size(tbChorm1,2));
        for j = 1 : size(tbChorm1,2)
            r = rand;
            if r <= cr || j == k
                tbChorm1(i,j) = tbChorm1(i,j);
            else
                tbChorm1(i,j) = bChorm(i,j);
            end
        end
        %边界处理
        tbChorm1 = Boundary(tbChorm1);
    end
    tbSize1 = CtoP(Tm,maxBatch,tbChorm1);
    %cbChorm变异 current-to-best/1/bin
    for i = 1:4
        while 1
            r = randi(4);
            if r ~= i
                break;
            end
        end
        cbChorm1(i,:) = cbChorm1(i,:) + f * (cbChorm1(bc,:) - cbChorm1(i,:)) + f *  (cbChorm1(r,:) - abChorm(1,:));
        %交叉
        k = unidrnd(size(tbChorm1,2));
        for j = 1 : size(tbChorm1,2)
            r = rand;
            if r <= cr || j == k
                cbChorm1(i,j) = cbChorm1(i,j);
            else
                cbChorm1(i,j) = bChorm(i,j);
            end
        end
        %边界处理
        cbChorm1 = Boundary(cbChorm1);
    end
    cbSize1 = CtoP(Tm,maxBatch,cbChorm1);
    %计算适应度
    valRankt1 = zeros(4,4);
    valRankc1 = zeros(4,4);
    for i = 1 : 4
        valRankt1(i,:) = Cal(pIChorm,sIChorm,sIndex,tbSize1(i,:),unitC,Tm,Trm,jNumber,pNumber,maxBatch);
        valRankc1(i,:) = Cal(pIChorm,sIChorm,sIndex,cbSize1(i,:),unitC,Tm,Trm,jNumber,pNumber,maxBatch);
    end
    %更新 并生成结合种群
    [~,bt] = min(valRankt1(:,1));
    [~,bc] = min(valRankc1(:,2));
    abChorm(3,:) = tbChorm1(bt,:);
    abSize(3,:) = tbSize1(bt,:);
    valRanka(3,:) = valRankt1(bt,:);
    abChorm(4,:) = cbChorm1(bc,:);
    abSize(4,:) = cbSize1(bc,:);
    valRanka(4,:) = valRankc1(bc,:);
    for i = 1 : 4
        if valRankt1(i,1) > valRank(i,1)
            tbChorm1(i,:) = bChorm(i,:);
            tbSize1(i,:) = bSize(i,:);
            valRankt1(i,:) = valRank(i,:);
        end
        
        if valRankc1(i,2) > valRank(i,2)
            cbChorm1(i,:) = bChorm(i,:);
            cbSize1(i,:) = bSize(i,:);
            valRankc1(i,:) = valRank(i,:);
        end
    end
    %% 二
    tbChorm2 = tbChorm1;
    cbChorm2 = cbChorm1;
    %tbChorm变异 current-to-best/1/bin
    for i = 1:4
        while 1
            r1 = randi(4);
            if r1 ~= i
                break;
            end
        end
        r2 = randi(4);
        tbChorm2(i,:) = tbChorm2(i,:) + f * (tbChorm2(bt,:) - tbChorm2(i,:)) + f *  (tbChorm2(r1,:) - abChorm(r2,:));
        %交叉
        k = unidrnd(size(tbChorm1,2));
        for j = 1 : size(tbChorm1,2)
            r = rand;
            if r <= cr || j == k
                tbChorm2(i,j) = tbChorm2(i,j);
            else
                tbChorm2(i,j) = tbChorm1(i,j);
            end
        end
        %边界处理
        tbChorm2 = Boundary(tbChorm2);
    end
    tbSize2 = CtoP(Tm,maxBatch,tbChorm2);
    %cbChorm变异 current-to-best/1/bin
    for i = 1:4
        while 1
            r1 = randi(4);
            if r1 ~= i
                break;
            end
        end
        r2 = randi(4);
        cbChorm2(i,:) = cbChorm2(i,:) + f * (cbChorm2(bc,:) - cbChorm2(i,:)) + f *  (cbChorm2(r1,:) - abChorm(r2,:));
        %交叉
        k = unidrnd(size(tbChorm1,2));
        for j = 1 : size(tbChorm1,2)
            r = rand;
            if r <= cr || j == k
                cbChorm2(i,j) = cbChorm2(i,j);
            else
                cbChorm2(i,j) = cbChorm1(i,j);
            end
        end
        %边界处理
        cbChorm2 = Boundary(cbChorm2);
    end
    cbSize2 = CtoP(Tm,maxBatch,cbChorm2);
    %协同种群变异交叉
    [~,bt] = min(valRanka(:,1));
    [~,bc] = min(valRanka(:,2));
    nabChorm = abChorm;
    for i = 1:4
        if rand < 0.5
            b = bt;
        else
            b = bc;
        end
        while 1
            r1 = randi(4);
            r2 = randi(4);
            if r1 ~= i && r1 ~= b && r2 ~= i && r2 ~= b && r1 ~= r2
                break;
            end
        end
        nabChorm(i,:) = abChorm(i,:) + f * (abChorm(b,:) - abChorm(i,:)) + f *  (abChorm(r1,:) - abChorm(r2,:));
        %交叉
        k = unidrnd(size(nabChorm,2));
        for j = 1 : size(nabChorm,2)
            r = rand;
            if r <= cr || j == k
                nabChorm(i,j) = nabChorm(i,j);
            else
                nabChorm(i,j) = abChorm(i,j);
            end
        end
        %边界处理
        nabChorm = Boundary(nabChorm);
    end
    nabSize = CtoP(Tm,maxBatch,nabChorm);
    %计算适应度
    nvalRanka = valRanka;
    for i = 1 : size(nabSize,1)
        nvalRanka(i,:) = Cal(pIChorm,sIChorm,sIndex,nabSize(i,:),unitC,Tm,Trm,jNumber,pNumber,maxBatch);
    end
    valRankt2 = zeros(4,4);
    valRankc2 = zeros(4,4);
    for i = 1 : 4
        valRankt2(i,:) = Cal(pIChorm,sIChorm,sIndex,tbSize2(i,:),unitC,Tm,Trm,jNumber,pNumber,maxBatch);
        valRankc2(i,:) = Cal(pIChorm,sIChorm,sIndex,cbSize2(i,:),unitC,Tm,Trm,jNumber,pNumber,maxBatch);
    end
    %更新 并生成结合种群
    
    [~,bt] = min(valRankt2(:,1));
    [~,bc] = min(valRankc2(:,2));

    abSize1 = zeros(2,size(bSize,2));
    valRanka1 = zeros(2,4);

    abSize1(1,:) = tbSize2(bt,:);
    valRanka1(1,:) = valRankt2(bt,:);

    abSize1(2,:) = cbSize2(bc,:);
    valRanka1(2,:) = valRankc2(bc,:);
    
    abSize = [abSize;nabSize]; valRanka = [valRanka;nvalRanka];
    abSize = [abSize;abSize1]; valRanka = [valRanka;valRanka1];
    [nval,b] = NonDominationSort(valRanka,abSize);
    [~,bt] = min(nval(:,1));
    [~,bc] = min(nval(:,2));
    if rand < 0.5
        bSize = b(bt,:);
    else
        bSize = b(bc,:);
    end
end