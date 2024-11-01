function r = normalization(a)
s = sum(a);
    for i = 1 : length(a)
        a(i) = a(i) / s;
    end
    r = a;
end