function lab2

% The second lab in Optimization course at LTH.
%
% Type lab2 to start.
%

% Solves the constrained optimization problem 
%
%     min f(x) subject to Ax>=b
%
% via the penalty/barrier method
%
%     min f(x)+mu*penalty(x)
%
%     min f(x)+epsilon*barrier(x)
% 
% ----------------------------------------------------------------
% User function penalty(x) should be defined in the file penalty.m
% User function barrier(x) should be defined in the file barrier.m
%  ---------------------------------------------------------------
% User data for minimizing f(x) over the set Ax>=b should be 
% defined in the file problem_data.m as
%
% function [A,b,f]=problem_data
% A=...
% b=...
% f=@(x)<some expression containing x(1),...,x(n)>
% ----------------------------------------------------------------
% See examples at the end of the file (to be removed in the release).

%
% (c) AG, 2015

disp('Welcome to Lab 2');
go_2D('init');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Two-dimensional problems %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function go_2D(action)

global Problem Penaltybutton PenaltyXstartframe PenaltyYstartframe PenaltyXframe PenaltyYframe PenaltyFframe Muframe Mu ...
  Barrierbutton BarrierXstartframe BarrierYstartframe BarrierXframe BarrierYframe BarrierFframe Epsilonframe Epsilon ...
  Problems Restart Penaltycurve Barriercurve Penaltypoint Barrierpoint Penaltyfunction Barrierfunction

options = optimoptions(@fminunc,'Display','off','Algorithm','quasi-newton');

switch action
  case 'init'
    Restart='yes';
    figure('units','normalized','position',[0.1 0.1 0.6 0.8],'menubar','none');

    go_2D('drawbuttons');
    go_2D('setproblem');    
  case 'drawset'
    if any(isempty([Problem.XLim Problem.YLim]))
      axes('units','normalized','Position',[0.21 0.04 0.78 0.95],'NextPlot','add','XGrid','on','YGrid','on');
    else
      axes('units','normalized','Position',[0.21 0.04 0.78 0.95],'XLim',Problem.XLim,'YLim',Problem.YLim,'NextPlot','add','XGrid','on','YGrid','on');
    end
    fill(Problem.X,Problem.Y,'y');

  case 'drawbuttons'
    dist1=0.28;

% Penalty frame
    uicontrol(gcf,'style','frame','units','normalized','position',[0.01 0.73 0.18 0.26],'backgroundcolor','b');
    Penaltybutton=uicontrol(gcf,'style','checkbox','string','Penalty metod','value',0,'units','normalized','position',[0.02 0.95 0.16 .03],'callback',{@callback_2D,'runpenalty'},'backgroundcolor','w','foregroundcolor','b');    
    % penaltyXstarttext=
    uicontrol(gcf,'style','text','string','xstart:','units','normalized','position',[0.02 0.91 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
    PenaltyXstartframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.91 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');
    % penaltyYstarttext=
    uicontrol(gcf,'style','text','string','ystart:','units','normalized','position',[0.02 0.88 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
    PenaltyYstartframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.88 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');
    % penaltyXtext=
    uicontrol(gcf,'style','text','string','x:','units','normalized','position',[0.02 0.85 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
    PenaltyXframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.85 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');
    % penaltyYtext=
    uicontrol(gcf,'style','text','string','y:','units','normalized','position',[0.02 0.82 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
    PenaltyYframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.82 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');
    % penaltyFtext=
    uicontrol(gcf,'style','text','string','f(x,y):','units','normalized','position',[0.02 0.79 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
    PenaltyFframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.79 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');    
    % mutext=
    uicontrol(gcf,'style','text','string','Mu','units','normalized','position',[0.02 0.75 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
    Muframe=uicontrol(gcf,'style','edit','units','normalized','position',[0.09 0.75 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',num2str(Mu),'Callback',{@callback_2D,'setmu'});
% Barrier frame
    uicontrol(gcf,'style','frame','units','normalized','position',[0.01 0.73-dist1 0.18 0.26],'backgroundcolor','m');
    Barrierbutton=uicontrol(gcf,'style','checkbox','string','Barrier metod','value',0,'units','normalized','position',[0.02 0.95-dist1 0.16 .03],'callback',{@callback_2D,'runbarrier'},'backgroundcolor','w','foregroundcolor','m');
    % barrierXstarttext=
    uicontrol(gcf,'style','text','string','xstart:','units','normalized','position',[0.02 0.91-dist1 0.06 .02],'foregroundcolor','m','backgroundcolor','w');
    BarrierXstartframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.91-dist1 0.09 .02],'backgroundcolor','w','foregroundcolor','m','string',' ');
    % barrierYstarttext=
    uicontrol(gcf,'style','text','string','ystart:','units','normalized','position',[0.02 0.88-dist1 0.06 .02],'foregroundcolor','m','backgroundcolor','w');
    BarrierYstartframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.88-dist1 0.09 .02],'backgroundcolor','w','foregroundcolor','m','string',' ');
    % barrierXtext=
    uicontrol(gcf,'style','text','string','x:','units','normalized','position',[0.02 0.85-dist1 0.06 .02],'foregroundcolor','m','backgroundcolor','w');
    BarrierXframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.85-dist1 0.09 .02],'backgroundcolor','w','foregroundcolor','m','string',' ');
    % barrierYtext=
    uicontrol(gcf,'style','text','string','y:','units','normalized','position',[0.02 0.82-dist1 0.06 .02],'foregroundcolor','m','backgroundcolor','w');
    BarrierYframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.82-dist1 0.09 .02],'backgroundcolor','w','foregroundcolor','m','string',' ');
    % barrierFtext=
    uicontrol(gcf,'style','text','string','f(x,y):','units','normalized','position',[0.02 0.79-dist1 0.06 .02],'foregroundcolor','m','backgroundcolor','w');
    BarrierFframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.79-dist1 0.09 .02],'backgroundcolor','w','foregroundcolor','m','string',' ');
    % epsilontext=
    uicontrol(gcf,'style','text','string','Epsilon','units','normalized','position',[0.02 0.75-dist1 0.06 .02],'foregroundcolor','m','backgroundcolor','w');
    Epsilonframe=uicontrol(gcf,'style','edit','units','normalized','position',[0.09 0.75-dist1 0.09 .02],'backgroundcolor','w','foregroundcolor','m','string',num2str(Epsilon),'Callback',{@callback_2D,'setepsilon'});
    
    Problems=uicontrol(gcf,'style','popup','units','normalized','position',[0.01 0.1 0.18 .03],'backgroundcolor','w','string',...
      'Problem 1|Problem 2|Problem 1 + your penalty/barrier|Problem 2 + your penalty/barrier|Try your data|Try tour data + penalty/barrier','Callback',{@callback_2D,'setproblem'},'Value',1);
    % exitbutton=
    uicontrol(gcf,'style','push','string','close','value',0,'units','normalized','position',[0.01 0.02 0.05 .07],'callback',{@callback_2D,'exit'},'backgroundcolor','w');
    % switchbutton=
    uicontrol(gcf,'style','push','string','3D','value',0,'units','normalized','position',[0.075 0.02 0.05 .07],'callback',{@callback_2D,'go3d'},'backgroundcolor','w');    
    % restartbutton=
    uicontrol(gcf,'style','push','string','restart','value',0,'units','normalized','position',[0.14 0.02 0.05 .07],'callback',{@callback_2D,'restart'},'backgroundcolor','w');
  case 'go3d'
    close;
    go_3D('init');
  case 'setmu'
    Mu=str2double(get(Muframe,'String'));
    if strcmp(Restart,'finish')
      Restart='no';
      set(Penaltybutton,'backgroundcolor','w');
    end
  case 'setepsilon'
    Epsilon=str2double(get(Epsilonframe,'String'));
    if strcmp(Restart,'finish')
      Restart='no';
      set(Barrierbutton,'backgroundcolor','w');
    end    
  case 'setproblem'
    switch get(Problems,'Value')
      case 1
        Problem=problem2D_1; 
        Penaltyfunction=@ag_penalty;
        Barrierfunction=@ag_barrier;
      case 2 
        Problem=problem2D_2;
        Penaltyfunction=@ag_penalty;
        Barrierfunction=@ag_barrier;
      case 3 
% Problem 1 with user penalty/barrier
        Problem=problem2D_1;
        Penaltyfunction=@new_penalty;
        Barrierfunction=@new_barrier;
      case 4
% Problem 2 with user penalty/barrier
        Problem=problem2D_2;
        Penaltyfunction=@new_penalty;
        Barrierfunction=@new_barrier;
      case 5
% Problem= load user data
        Problem=problem2D_extra;
      case 6 
% Problem= load user data + penalty/barrier
        Problem=problem2D_extra;
        Penaltyfunction=@new_penalty;
        Barrierfunction=@new_barrier;
    end
    go_2D('restart');    
  case 'restart'
    Restart='yes';
    delete(gca);
    go_2D('drawset');
    set(PenaltyXstartframe,'string','');
    set(PenaltyYstartframe,'string','');
    set(PenaltyXframe,'string','');
    set(PenaltyYframe,'string','');
    set(PenaltyFframe,'string','');    
    set(Penaltybutton,'backgroundcolor','w');
    set(Barrierbutton,'backgroundcolor','w');
    set(BarrierXstartframe,'string','');
    set(BarrierYstartframe,'string','');
    set(BarrierXframe,'string','');
    set(BarrierYframe,'string','');
    set(BarrierFframe,'string','');
    set(Muframe,'string','')
    set(Epsilonframe,'string','')
  case 'runpenalty'
    go_2D('restart');  
    set(Penaltybutton,'value',1);  
    set(Barrierbutton,'value',0);  
    set(gcf,'windowbuttondownfcn',{@callback_2D,'penaltystep'});
  case 'runbarrier'
    go_2D('restart');  
    set(Penaltybutton,'value',0);  
    set(Barrierbutton,'value',1);  
    set(gcf,'windowbuttondownfcn',{@callback_2D,'barrierstep'});
  case 'penaltystep'
    switch Restart
      case 'yes'
        Restart='no';
        cpoint=get(gca,'currentpoint');
        Penaltypoint=[cpoint(1,1);cpoint(1,2)];
        Penaltycurve=plot(Penaltypoint(1),Penaltypoint(2),'-*b');
        set(PenaltyXstartframe,'string',num2str(Penaltypoint(1),'%0.5g'));
        set(PenaltyYstartframe,'string',num2str(Penaltypoint(2),'%0.5g')); 
        set(PenaltyFframe,'string',num2str(Problem.fun(Penaltypoint),'%0.5g'));
        if isempty(get(Muframe,'String'))
          Mu=0.2;
        end
      case 'no'
        if isnan(Mu)
         return
        end
        Penaltypoint(:,end+1)=fminunc(@(x)Problem.fun(x)+Mu*Penaltyfunction(x,Problem),Penaltypoint(:,end),options);
        set(Penaltycurve,'xdata',Penaltypoint(1,:),'ydata',Penaltypoint(2,:));
        set(PenaltyXframe,'string',num2str(Penaltypoint(1,end),'%0.5g'));
        set(PenaltyYframe,'string',num2str(Penaltypoint(2,end),'%0.5g'));
        set(PenaltyFframe,'string',num2str(Problem.fun(Penaltypoint(:,end)),'%0.5g'));        
        if isempty(get(Muframe,'String'))
          Mu=Mu*2;
        end
        if norm(Penaltypoint(:,end)-Penaltypoint(:,end-1))<1e-6
          set(Penaltybutton,'backgroundcolor','y');
          Restart='finish';
        end
      case 'finish'
    end
  case 'barrierstep'
    switch Restart
      case 'yes'
        Restart='no';
        cpoint=get(gca,'currentpoint');
        Barrierpoint=[cpoint(1,1);cpoint(1,2)];
        Barriercurve=plot(Barrierpoint(1),Barrierpoint(2),'*-m');
        set(BarrierXstartframe,'string',num2str(Barrierpoint(1),'%0.5g'));
        set(BarrierYstartframe,'string',num2str(Barrierpoint(2),'%0.5g'));
        set(BarrierFframe,'string',num2str(Problem.fun(Barrierpoint),'%0.5g'));
        if isempty(get(Epsilonframe,'String'))
          Epsilon=10;
        end
      case 'no'
        if isnan(Epsilon)
         return
        end
        Barrierpoint(:,end+1)=fminunc(@(x)Problem.fun(x)+Epsilon*Barrierfunction(x,Problem),Barrierpoint(:,end),options);
        set(Barriercurve,'xdata',Barrierpoint(1,:),'ydata',Barrierpoint(2,:));
        set(BarrierXframe,'string',num2str(Barrierpoint(1,end),'%0.5g'));
        set(BarrierYframe,'string',num2str(Barrierpoint(2,end),'%0.5g'));
        set(BarrierFframe,'string',num2str(Problem.fun(Barrierpoint(:,end)),'%0.5g'));        
        if isempty(get(Epsilonframe,'String'))
          Epsilon=Epsilon/2;
        end
        if norm(Barrierpoint(:,end)-Barrierpoint(:,end-1))<1e-6
          set(Barrierbutton,'backgroundcolor','y');
          Restart='finish';
        end
      case 'finish'
    end    
  case 'exit'
    close;
  otherwise
    disp('Unknown action')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Three-dimensional problems %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function go_3D(action)

global Problem Penaltybutton StartvalueXframe StartvalueYframe StartvalueZframe PenaltyXframe PenaltyYframe PenaltyZframe PenaltyFframe Muframe Mu ...
  Barrierbutton BarrierXframe BarrierYframe BarrierZframe BarrierFframe Epsilonframe Epsilon ...
  Problems Restart Penaltycurve Barriercurve Penaltypoint Barrierpoint Penaltyfunction Barrierfunction Xstart Ystart Zstart

options = optimoptions(@fminunc,'Display','off','Algorithm','quasi-newton');

switch action
  case 'init'
    Restart='yes';
    figure('units','normalized','position',[0.1 0.1 0.6 0.8],'menubar','none');

    go_3D('drawbuttons');
    go_3D('setproblem');    
  case 'drawset'
    if any(isempty([Problem.XLim Problem.YLim Problem.ZLim]))
      axes('units','normalized','Position',[0.24 0.04 0.72 0.95],'NextPlot','add','XGrid','on','YGrid','on','ZGrid','on');
    else
      axes('units','normalized','Position',[0.24 0.04 0.72 0.95],'XLim',Problem.XLim,'YLim',Problem.YLim,'ZLim',Problem.ZLim,'NextPlot','add','XGrid','on','YGrid','on','ZGrid','on');
    end
    view([20 40]);

  case 'drawbuttons'
    dist1=0.25;
    dist2=0.55;

% Penalty frame
    uicontrol(gcf,'style','frame','units','normalized','position',[0.01 0.76 0.18 0.23],'backgroundcolor','b');
    Penaltybutton=uicontrol(gcf,'style','checkbox','string','Penalty metod','value',0,'units','normalized','position',[0.02 0.95 0.16 .03],'callback',{@callback_3D,'runpenalty'},'backgroundcolor','w','foregroundcolor','b');    
    % penaltyXtext=
    uicontrol(gcf,'style','text','string','x:','units','normalized','position',[0.02 0.91 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
    PenaltyXframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.91 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');
    % penaltyYtext=
    uicontrol(gcf,'style','text','string','y:','units','normalized','position',[0.02 0.88 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
    PenaltyYframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.88 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');
    % penaltyZtext=
    uicontrol(gcf,'style','text','string','z:','units','normalized','position',[0.02 0.85 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
    PenaltyZframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.85 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');
    % penaltyFtext=
    uicontrol(gcf,'style','text','string','f(x,y,z):','units','normalized','position',[0.02 0.82 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
    PenaltyFframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.82 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');    
    % mutext=
    uicontrol(gcf,'style','text','string','Mu','units','normalized','position',[0.02 0.78 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
    Muframe=uicontrol(gcf,'style','edit','units','normalized','position',[0.09 0.78 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',num2str(Mu),'Callback',{@callback_3D,'setmu'});
% Barrier frame
    uicontrol(gcf,'style','frame','units','normalized','position',[0.01 0.76-dist1 0.18 0.23],'backgroundcolor','m');
    Barrierbutton=uicontrol(gcf,'style','checkbox','string','Barrier metod','value',0,'units','normalized','position',[0.02 0.95-dist1 0.16 .03],'callback',{@callback_3D,'runbarrier'},'backgroundcolor','w','foregroundcolor','m');
    % barrierXtext=
    uicontrol(gcf,'style','text','string','x:','units','normalized','position',[0.02 0.91-dist1 0.06 .02],'foregroundcolor','m','backgroundcolor','w');
    BarrierXframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.91-dist1 0.09 .02],'backgroundcolor','w','foregroundcolor','m','string',' ');
    % barrierYtext=
    uicontrol(gcf,'style','text','string','y:','units','normalized','position',[0.02 0.88-dist1 0.06 .02],'foregroundcolor','m','backgroundcolor','w');
    BarrierYframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.88-dist1 0.09 .02],'backgroundcolor','w','foregroundcolor','m','string',' ');
    % barrierZtext=
    uicontrol(gcf,'style','text','string','z:','units','normalized','position',[0.02 0.85-dist1 0.06 .02],'foregroundcolor','m','backgroundcolor','w');
    BarrierZframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.85-dist1 0.09 .02],'backgroundcolor','w','foregroundcolor','m','string',' ');    
    % barrierFtext=
    uicontrol(gcf,'style','text','string','f(x,y,z):','units','normalized','position',[0.02 0.82-dist1 0.06 .02],'foregroundcolor','m','backgroundcolor','w');
    BarrierFframe=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.82-dist1 0.09 .02],'backgroundcolor','w','foregroundcolor','m','string',' ');   
    % epsilontext=
    uicontrol(gcf,'style','text','string','Epsilon','units','normalized','position',[0.02 0.78-dist1 0.06 .02],'foregroundcolor','m','backgroundcolor','w');
    Epsilonframe=uicontrol(gcf,'style','edit','units','normalized','position',[0.09 0.78-dist1 0.09 .02],'backgroundcolor','w','foregroundcolor','m','string',num2str(Epsilon),'Callback',{@callback_3D,'setepsilon'});
% Start value frame
    uicontrol(gcf,'style','frame','units','normalized','position',[0.01 0.84-dist2 0.18 0.15],'backgroundcolor','r');
    % startvaluetext=
    uicontrol(gcf,'style','text','string','Starting point','units','normalized','position',[0.02 0.96-dist2, 0.16 .02],'backgroundcolor','w','foregroundcolor','r');    
    % startvalueXtext=
    uicontrol(gcf,'style','text','string','xstart:','units','normalized','position',[0.02 0.92-dist2 0.06 .02],'foregroundcolor','r','backgroundcolor','w');
    StartvalueXframe=uicontrol(gcf,'style','edit','units','normalized','position',[0.09 0.92-dist2 0.09 .02],'backgroundcolor','w','foregroundcolor','r','string',num2str(Xstart),'callback',{@callback_3D,'setxstart'});
    % startvalueYtext=
    uicontrol(gcf,'style','text','string','ystart:','units','normalized','position',[0.02 0.89-dist2 0.06 .02],'foregroundcolor','r','backgroundcolor','w');
    StartvalueYframe=uicontrol(gcf,'style','edit','units','normalized','position',[0.09 0.89-dist2 0.09 .02],'backgroundcolor','w','foregroundcolor','r','string',num2str(Ystart),'callback',{@callback_3D,'setystart'});
    % startvalueZtext=
    uicontrol(gcf,'style','text','string','zstart:','units','normalized','position',[0.02 0.86-dist2 0.06 .02],'foregroundcolor','r','backgroundcolor','w');
    StartvalueZframe=uicontrol(gcf,'style','edit','units','normalized','position',[0.09 0.86-dist2 0.09 .02],'backgroundcolor','w','foregroundcolor','r','string',num2str(Zstart),'callback',{@callback_3D,'setzstart'});

    Problems=uicontrol(gcf,'style','popup','units','normalized','position',[0.01 0.1 0.18 .03],'backgroundcolor','w','string',...
      'Problem 3|Problem 3 + your penalty/barrier|Your data|Your data + penalty/barrier','Callback',{@callback_3D,'setproblem'},'Value',1);
    % exitbutton=
    uicontrol(gcf,'style','push','string','close','value',0,'units','normalized','position',[0.01 0.02 0.05 .07],'callback',{@callback_3D,'exit'},'backgroundcolor','w');
    % switchbutton=
    uicontrol(gcf,'style','push','string','2D','value',0,'units','normalized','position',[0.075 0.02 0.05 .07],'callback',{@callback_3D,'go2d'},'backgroundcolor','w');    
    % restartbutton=
    uicontrol(gcf,'style','push','string','restart','value',0,'units','normalized','position',[0.14 0.02 0.05 .07],'callback',{@callback_3D,'restart'},'backgroundcolor','w');

  case 'go2d'
    close;
    go_2D('init');
  case 'setxstart'
    Xstart=str2double(get(StartvalueXframe,'String'));
  case 'setystart'
    Ystart=str2double(get(StartvalueYframe,'String'));
  case 'setzstart'
    Zstart=str2double(get(StartvalueZframe,'String'));
  case 'setmu'
    Mu=str2double(get(Muframe,'String'));
    if strcmp(Restart,'finish')
      Restart='no';
      set(Penaltybutton,'backgroundcolor','w');
    end
  case 'setepsilon'
    Epsilon=str2double(get(Epsilonframe,'String'));
    if strcmp(Restart,'finish')
      Restart='no';
      set(Barrierbutton,'backgroundcolor','w');
    end    
  case 'setproblem'
    switch get(Problems,'Value')
      case 1
        Problem=problem3D_1; 
        Penaltyfunction=@ag_penalty;
        Barrierfunction=@ag_barrier;
      case 2
% Problem 1 with user penalty/barrier        
        Problem=problem3D_1;
        Penaltyfunction=@new_penalty;
        Barrierfunction=@new_barrier;
      case 3
% Problem= load user data
        Problem=problem3D_extra;
        Penaltyfunction=@ag_penalty;
        Barrierfunction=@ag_barrier;
      case 4
% Problem= load user data + penalty/barrier
        Problem=problem3D_extra;
        Penaltyfunction=@new_penalty;
        Barrierfunction=@new_barrier;
    end
    go_3D('restart');    
  case 'restart'
    Restart='yes';
    delete(gca);
    go_3D('drawset');
    set(StartvalueXframe,'string','');
    set(StartvalueYframe,'string','');
    set(StartvalueZframe,'string','');    
    set(PenaltyXframe,'string','');
    set(PenaltyYframe,'string','');
    set(PenaltyZframe,'string','');
    set(PenaltyFframe,'string','');    
    set(Penaltybutton,'backgroundcolor','w');
    set(Barrierbutton,'backgroundcolor','w');
    set(BarrierXframe,'string','');
    set(BarrierYframe,'string','');
    set(BarrierZframe,'string','');
    set(BarrierFframe,'string','');
    set(Muframe,'string','')
    set(Epsilonframe,'string','')
    Xstart=[];
    Ystart=[];
    Zstart=[];
  case 'runpenalty'
    go_3D('restart');  
    set(Penaltybutton,'value',1);  
    set(Barrierbutton,'value',0);  
    set(gcf,'windowbuttondownfcn',{@callback_3D,'penaltystep'});
  case 'runbarrier'
    go_3D('restart');  
    set(Penaltybutton,'value',0);  
    set(Barrierbutton,'value',1);  
    set(gcf,'windowbuttondownfcn',{@callback_3D,'barrierstep'});
  case 'penaltystep'
    switch Restart
      case 'yes'
        Penaltypoint=[Xstart;Ystart;Zstart];
        if any(isempty(Penaltypoint)) || length(Penaltypoint)~=3 || any(isnan(Penaltypoint))
          return
        end        
        Restart='no';
        Penaltycurve=plot3(Penaltypoint(1),Penaltypoint(2),Penaltypoint(3),'-*b');
        set(PenaltyXframe,'string',num2str(Penaltypoint(1),'%0.5g'));
        set(PenaltyYframe,'string',num2str(Penaltypoint(2),'%0.5g'));
        set(PenaltyZframe,'string',num2str(Penaltypoint(3),'%0.5g'));        
        set(PenaltyFframe,'string',num2str(Problem.fun(Penaltypoint),'%0.5g'));     
        if isempty(get(Muframe,'String'))
          Mu=0.2;
        end
      case 'no'
%        Mu
        if isnan(Mu)
         return
        end
        [next,~,flag]=fminunc(@(x)Problem.fun(x)+Mu*Penaltyfunction(x,Problem),Penaltypoint(:,end),options);
        if all(isfinite(next))
          Penaltypoint(:,end+1)=next;
        else
          disp('Ill-conditioned penalty problem')
          Restart='finish';
        end
        set(Penaltycurve,'xdata',Penaltypoint(1,:),'ydata',Penaltypoint(2,:),'zdata',Penaltypoint(3,:));
        set(PenaltyXframe,'string',num2str(Penaltypoint(1,end),'%0.5g'));
        set(PenaltyYframe,'string',num2str(Penaltypoint(2,end),'%0.5g'));
        set(PenaltyZframe,'string',num2str(Penaltypoint(3,end),'%0.5g'));
        set(PenaltyFframe,'string',num2str(Problem.fun(Penaltypoint(:,end)),'%0.5g'));        
        if isempty(get(Muframe,'String'))
          Mu=Mu*2;
        end
        if norm(Penaltypoint(:,end)-Penaltypoint(:,end-1))<1e-6
          set(Penaltybutton,'backgroundcolor','y');
          Restart='finish';
        end
      case 'finish'
    end
  case 'barrierstep'
    switch Restart
      case 'yes'
        Barrierpoint=[Xstart;Ystart;Zstart];
        if any(isempty(Barrierpoint)) || length(Barrierpoint)~=3 || any(isnan(Barrierpoint))
          return
        end        
        Restart='no';
        Barriercurve=plot3(Barrierpoint(1),Barrierpoint(2),Barrierpoint(3),'*-m');
        set(BarrierXframe,'string',num2str(Barrierpoint(1),'%0.5g'));
        set(BarrierYframe,'string',num2str(Barrierpoint(2),'%0.5g'));
        set(BarrierZframe,'string',num2str(Barrierpoint(3),'%0.5g'));
        set(BarrierFframe,'string',num2str(Problem.fun(Barrierpoint),'%0.5g'));      
        if isempty(get(Epsilonframe,'String'))
          Epsilon=10;
        end
      case 'no'
%        Epsilon
        if isnan(Epsilon)
         return
        end
        [next,~,flag]=fminunc(@(x)Problem.fun(x)+Epsilon*Barrierfunction(x,Problem),Barrierpoint(:,end),options);
        if all(isfinite(next))
          Barrierpoint(:,end+1)=next;
        else
          disp('Ill-conditioned barrier problem')
          Restart='finish';
        end
        set(Barriercurve,'xdata',Barrierpoint(1,:),'ydata',Barrierpoint(2,:),'zdata',Barrierpoint(3,:));
        set(BarrierXframe,'string',num2str(Barrierpoint(1,end),'%0.5g'));
        set(BarrierYframe,'string',num2str(Barrierpoint(2,end),'%0.5g'));
        set(BarrierZframe,'string',num2str(Barrierpoint(3,end),'%0.5g'));
        set(BarrierFframe,'string',num2str(Problem.fun(Barrierpoint(:,end)),'%0.5g'));
        if isempty(get(Epsilonframe,'String'))
          Epsilon=Epsilon/2;
        end
        if norm(Barrierpoint(:,end)-Barrierpoint(:,end-1))<1e-6
          set(Barrierbutton,'backgroundcolor','y');
          Restart='finish';
        end
      case 'finish'
%        disp('Done Barrier')        
    end    
  case 'exit'
    close;
  otherwise
    disp('Unknown action')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Other funuctions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function output=problem2D_1

output=struct('A',[1 1;-1 1;1 0;-1 -2],'b',[2;0;0;-6],'fun',@(x)[1 2]*x,'X',[2 0 0 1],'Y',[2 3 2 1],'Z',[],'XLim',[-5 7],'YLim',[-5 7]);

function output=problem2D_2

output=struct('A',[1 2;-1 3;1 -3;-3 -5;1 0;0 1],'b',[2;-2;-12;-34;0;0],'fun',@(x)[1 2]*x,'X',[2 0 0 3 8],'Y',[0 1 4 5 2],'Z',[],'XLim',[-4 10],'YLim',[-4 6]);

function output=problem2D_extra

[A,b,func]=problem_data;

if size(b,2)>1
  b=b';
end

output=struct('A',A,'b',b,'fun',func,'X',[],'Y',[],'XLim',[-5 5],'YLim',[-5 5]);

function output=problem3D_1

X=[0 20 0 0 0;20 20 0 20 0;10 10 10 15/2 0;0 15/2 15/2 0 0];
Y=[0 0 10 0 0;0 0 0 0 0;0 0 0 15 /2 0;0 15/2 15/2 10 10];
Z=[0 0 0 0 0;0 0 15 0 0;10 10 10 0 15;15 0 0 0 0];

X=X(:,2:3);
Y=Y(:,2:3);
Z=Z(:,2:3);

A=[1 3 2;1 1 1;3 5 3];
b=[30;24;60];
c=[2;4;3];

output=struct('A',[-A;eye(3)],'b',[-b;0;0;0],'fun',@(x)-c'*x,'X',X,'Y',Y,'Z',Z,'XLim',[-5 20],'YLim',[-5 20],'ZLim',[-5 20]);

function output=problem3D_extra

[A,b,func]=problem_data;

if size(b,2)>1
  b=b';
end

output=struct('A',A,'b',b,'fun',func,'X',[],'Y',[],'Z',[],'XLim',[],'YLim',[],'ZLim',[]);

function alpha=ag_penalty(x,problem)

g=problem.A*x-problem.b;
alpha=g'*diag(g<0)*g;

function beta=ag_barrier(x,problem)

g=problem.A*x-problem.b;

if any(g<=0)
  beta=1e200;
else
  beta=-sum(log(g));
end

function alpha=new_penalty(x,~)

alpha=penalty(x);

function beta=new_barrier(x,~)

beta=barrier(x);

function callback_2D(~,~,action)

go_2D(action)

function callback_3D(~,~,action)

go_3D(action)
