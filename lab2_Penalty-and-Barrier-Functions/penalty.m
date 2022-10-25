function f = penalty(x)

A = [-1 -1; 1 -1; -1 0; 1 2];
b = [-2; 0; 0; 6];
n = 4;

i = 1;
g = 0;
%G = A*x - b;
G=zeros(n,1);

while i <= n
    G(i) = A(i,:)*x - b(i);
    if G(i) > 0
        g = g + G(i);
    end
    i = i + 1;
end

f = g;
end




