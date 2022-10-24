function [lambda,No_of_iterations] = linesearch(func,x,d)

% time_ls=cputime;        %Only for Computing Time, Starttime.
xstart=x;           
No_of_iterations=0;

iterMAX=1000;       % Maximum of Iterations
tolMIN=1.0e-60;     % Toleranz between Funktion values
atol=1.0e-60;       % Minimale Step size !!!!!!!
tol=1;              % Toleranz value only for starting must be > tolMIN!

a=1;                % first Stepsize (Lambda) only for starting must be > atol!
ax=0.5;             % a=ax*a by using smaller step ax<1! own decision

bigStep=1.0e70;     % For bad startingponts.

h=0;                % auxiliary svariable min(fl,fx,fr) -> h=(1,0,2)

fx=func(x);

while tol>tolMIN && No_of_iterations<iterMAX && a>atol
    
    if h==1
        fl=func(x-a*d);
    end
    if h==2
        fr=func(x+a*d);
    end
    if h==0
        fl=func(x-a*d);
        fr=func(x+a*d);
    end

%compare: min(fl,fx,fr) -> h=(1,0,2)
if fx>fr
    if fr>fl
        h=1;
        tol=fx-fl;
        fx=fl;
        x=x-a*d;
    else
        h=2;
        tol=fx-fr;
        fx=fr;
        x=x+a*d;
    end
else
    h=0;
    if fx>fl
        h=1;
        tol=fx-fl;
        fx=fl;
        x=x-a*d;
    end
end

if h==0
    a=ax*a;         %Funktion for much smaller value near the search point.
end

if h==1
    a=a+ax*a;
end

if h==2
    a=a+ax*a;
end

if a<atol
    lambda=d\(x - xstart);
    if lambda==0
        a=bigStep;
    end
end

No_of_iterations=No_of_iterations+1;

end

lambda=d\(x - xstart);

% didn't used... from assignment.
% if isnan(func(xstart+lambda*d)) || func(xstart+lambda*d)>func(xstart)
%     error('Bad job of the line search!')
% end

% time_ls=cputime-time_ls;      %Only for Computing Time, Endtime.

end

% lambda_1=linesearch(@test_func, [0;0], [1;0])
% lambda_1=linesearch(@test_func, [0;0], [0;1])