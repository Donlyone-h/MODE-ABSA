function [xpChorm,xsChorm] = Across(apChorm,asChorm,pChorm,sChorm,cr,jNumber,Tm,Trm,maxBatch)
xpChorm = pChorm;%��¼���������
xsChorm = sChorm;%��¼��������쵥Ԫ��
pop = size(pChorm,1);

for i = 1 : pop
        %���н������
    if rand < cr
        [p1,s1] = Mutate(apChorm(i,:),pChorm(i,:),asChorm(i,:),sChorm(i,:),jNumber,cr);
    else
        p1 = apChorm(i,:);
        s1 = asChorm(i,:);
    end
    xpChorm(i,:) = p1;
    xsChorm(i,:) = s1;
end

end