function nChorm = Boundary(Chorm)
%�������߽�ı���
nChorm = Chorm;

%�����߽�����һ������������ֵ�滻
for i = 1 : size(nChorm,1)
    for j = 1 : size(nChorm,2)
        %�߽�����
        if nChorm(i,j) > 1 
            nChorm(i,j) = 1;
        elseif nChorm(i,j) <= 0
            nChorm(i,j) = rand * 0.1;
        end
    end
end


end