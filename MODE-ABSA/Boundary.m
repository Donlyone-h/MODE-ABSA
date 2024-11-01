function nChorm = Boundary(Chorm)
%处理超出边界的编码
nChorm = Chorm;

%超出边界则用一个可行域内数值替换
for i = 1 : size(nChorm,1)
    for j = 1 : size(nChorm,2)
        %边界吸收
        if nChorm(i,j) > 1 
            nChorm(i,j) = 1;
        elseif nChorm(i,j) <= 0
            nChorm(i,j) = rand * 0.1;
        end
    end
end


end