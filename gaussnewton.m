function gaussnewton(phi,t,y,start,tol,use_linesearch,printout,plotout)

% XXXX  Don't forget:
    % [t,y]=data1; or [t,y]=data2;
    % gaussnewton(@phi1,t,y,[1;2],0.1,1,1,1);
    % or gaussnewton(@phi2,t,y,[1;2;3;4],0.1,1,1,1);

% XXXX Preparation
%if printout==1
%    time_total=cputime;
%end
close(gcf);                             % Close all Plots
f_tol = 1.0e60;                           % Only for Starting
tolJ = 0.0001;                            % For Jacobian
iter = 0;                                 % Iteration Step
iterMAX = 200;
x = start;                                % For printing in the end
auxf=@(x)sum((phi(x,t)-y).^2);          % Auxiliary Function

% XXXX Computing
while f_tol>tol && iter<iterMAX      % Termination Criteria: (Book page 108)
                                     % Change in the Function value < tol. 
    
    % Computing Jacobian
    J = zeros(length(t),length(x));
    for i=1:length(x)
        dx = x;
        dx(i) = x(i) + tolJ;
        J(:,i) = (phi(x,t) - phi(dx,t))./tolJ;
        %dx(i) = x(i) - tolJ;          % Not necessery becaause of Line 21.
    end
        
    % Determining Direction
    %H=J'*J;                      % Simplyfied Hessian (Book page 94)
    R = (phi(x,t) - y);           % Vector of r(x)
    maxR = max(abs(R));           % Determining Residuum, only for print.
    d = -J\R;                     % Book page 94-95: J' * J * d = -J' * R;
    
    % Determining Lambda using line search in order to improve convergence.
    if use_linesearch==1
        [lambda,No_of_iterations] = linesearch(auxf,x,d);
    else
        lambda=-0.1;                    % own Choise, good convergence.
        No_of_iterations=0;             % No Line Search -> 0.
    end
    
    % New x and Function value
    ns = lambda*d;                      % Step can be also printed
    x = x + ns;                           % New x
    ss = norm(ns);                      % Step Size, only for print.
    if iter>0                         % Calculate Functiontolerance for Stoping
        f_old = f;
        f = auxf(x);
        f_tol = abs(f_old - f);
    else
        f = auxf(x);                    % Function value only first iteration.
        f_tol = f;
    end
    iter=iter+1;                        %Iterarion
    
    %Print
    if printout==1
      if iter==1                      %Only first Line
        fprintf('\n\n%s\t%s\t\t\t%s\t\t\t%s\t\t\t%s\t%s\t%s\t\t%s\t%s\n\n', ...
                '|iter','|x','|d','|ss','|f(x)','|max(|r|)', ...
                '|f_tol','|ls iter','|lambda');
      end   
      fprintf('(%0.0f)\t\t%0.4f\t\t%0.4f\t\t%0.3f\t\t%0.2f\t%0.4f\t\t%0.4f\t\t%0.0f\t\t\t%0.4f\n', ...
            iter,x(1),d(1),ss,f,maxR,f_tol,No_of_iterations,lambda);
        if length(x)>1
            for j=2:length(x)
                fprintf('\t\t%0.4f\t\t%0.4f\n',x(j),d(j));
            end
        end
        fprintf('\n');
    end
end

% XXXX SolutionPlot
if plotout==1
    hold on;
    plot(t, y, 'rx');

    maxt = max(t);
    mint = min(t);
    xt = mint:(maxt - mint)/500:maxt;   %It is also possible to use t for xt!
    plot(xt, phi(start,xt), 'b-');
    plot(xt, phi(x,xt), 'g-');
    xlabel('t');
    ylabel('y');
    %Plottitle with Iterationsteps
    title(sprintf('Least Square Problem, iteration %0.0f',iter))       
    hold off
end
%if printout==1
 %   time_total=cputime-time_total;
  %  fprintf('Total time: %0.1f ms.\n',1000*time_total);
%end         
end