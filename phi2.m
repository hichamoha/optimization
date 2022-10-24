function y = phi2(x,t)
% PHI2 computes the function values of
% phi2(x,t) = x1*exp(-x3*t) + x2*exp(-x4*t)
% where x = parameters.
% 
y = x(1)*exp(-x(2)*t) + x(3)*exp(-x(4)*t);
