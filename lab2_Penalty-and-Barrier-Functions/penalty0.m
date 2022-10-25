function f = penalty0(x)
g = 0;
g1 = -x(1) - x(2) + 2;
if g1 > 0
    g = g + G;
end
g2 = -x(2) + x(1);
if g2 > 0
    g = g + g2;
end    
g3 = -x(1);
if g3 > 0
    g = g + g3;
end    
g4 = x(1) + 2*x(2);
if g4 > 0
    g = g + g4;
end

f = g;
end