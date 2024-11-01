function [apChorm,asChorm] = Aberance(pChorm,sChorm,f,jNumber,Tm,Trm,maxBatch)
apChorm = pChorm;%记录变异后工序码
asChorm = sChorm;%记录变异后制造单元码
pop = size(pChorm,1);

for i = 1 : pop    
% DE/current-to-best/1/bin
    r = randperm(size(pChorm,1));
    if(find(r == i) <= 2)
        r = r(3:4);
    else
        r = r(1:2);
    end
    b = randperm(6,1);

    %进行变异操作
    if rand < f
        [p1,s1] = Mutate(pChorm(b,:),pChorm(i,:),sChorm(b,:),sChorm(i,:),jNumber,f);
    else
        p1 = pChorm(b,:);
        s1 = sChorm(b,:);
    end
    
    if rand < f
        [p2,s2] = Mutate(pChorm(r(1),:),pChorm(r(2),:),sChorm(r(1),:),sChorm(r(2),:),jNumber,f);
    else
        p2 = pChorm(r(1),:);
        s2 = sChorm(r(1),:);
    end  

    if rand < f
        [p3,s3] = Mutate(pChorm(i,:),p1,sChorm(i,:),s1,jNumber,f);
    else
        p3 = pChorm(i,:);
        s3 = sChorm(i,:);
    end  
    
    if rand < f
        [p4,s4] = Mutate(p3,p2,s3,s2,jNumber,f);
    else
        p4 = p3;
        s4 = s3;
    end  
    apChorm(i,:) = p4;
    asChorm(i,:) = s4;
       
end

end