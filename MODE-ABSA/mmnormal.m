function r = mmnormal(a)
x = min(a);
d = max(a) - x;
if d~= 0
    for i = 1 : length(a)
        a(i) = (a(i) - x) / d;
    end
else
    for i = 1 : length(a)
        a(:) = 1 / length(a);
    end
end
    r = a;
end