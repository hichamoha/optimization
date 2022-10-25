function y=lab1(x,fun)

% The first lab in Optimization course at LTH.
%
% Type lab1 to start.

%
% (c) LV
%
% Edited by AG, 2011: Callbacks in uicontrol replaced from file names to
% function handles in order to allow of callback of nested functions. All
% files are then united in one.

switch nargin
  case 0
    onedim
    y='Welcome to Lab 1';
  case 1
    y=fun1(x);
  case 2
    if length(x)==2
      if strcmp(fun,'f3')
        y=fthree(x);
      elseif strcmp(fun,'f4')
        y=ffour(x);
      else
        disp('The second parameter must be ''f3'' or ''f4'' only!')
      end
    else
      disp('The first parameter must be of dimension 2')
    end
  otherwise
    disp('Too many input parameters!')
end
          

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function onedim(action)

global   steg k almb x Axlar graf f F a b xmin xmax omstart funktioner ...
    xminruta xmaxruta  newtonkurva  newtonpunkter  newtonxstartruta ...
    newtonystartruta newtonyruta newtonxruta newtonknapp armijokurva  ...
    armijopunkter  armijoxstartruta armijoystartruta armijoyruta armijoxruta ...
    armijoknapp armijof  goldenknapp goldenxstartruta goldenystartruta goldenyruta ...
    goldenxruta fgoldenxstartruta fgoldenystartruta fgoldenyruta fgoldenxruta ymin ykant

if nargin<1,
	action='setup';
end;
if strcmp(action,'setup'),
%%%%%%%%%%%%%
figur=figure('units','normalized','position',[0.1 0.1 0.8 0.8],'menubar','none');
%%%%%%%%%%%%%
f=@fun1;
xmin=-0.25;
xmax=0.5;

onedim('ritafunktion');
onedim('ritaknappar');

elseif  strcmp(action,'ritafunktion'),
omstart=1;  
X=xmin:0.01:xmax;
Y=feval(f,X);
ymin=min(Y');
ymax=max(Y');
xkant=(xmax-xmin)/20;
ykant=(ymax-ymin)/20;
axlar=axes('units','normalized','Position',[0.2 0.02 0.79 0.96],'XLim',[xmin-xkant xmax+xkant],'YLim',[ymin-ykant ymax+ykant]);
hold on
graf=plot(X,Y,'erasemode','xor');

elseif strcmp(action,'ritaknappar'),
omstart=1;  
avst1=0.2;
avst2=0.12;
%%%%%%%%%%%%%
newtonram=uicontrol(gcf,'style','frame','units','normalized','position',[0.01 0.80 0.18 0.19],'backgroundcolor','k');
%%%%%%%%%%%%%
newtonknapp=uicontrol(gcf,'style','checkbox','string','Newtons metod','value',0,'units','normalized','position',[0.02 0.95 0.16 .03],'callback',{@onedim_callback,'newtontoggla'},'backgroundcolor','w','foregroundcolor','k');
%%%%%%%%%%%%%
newtonxstarttext=uicontrol(gcf,'style','text','string','xstart:','units','normalized','position',[0.02 0.91 0.06 .02],'foregroundcolor','k','backgroundcolor','w');
%%%%%%%%%%%%%
newtonxstartruta=uicontrol(gcf,'style','text','units','normalized', ...
		      'position',[0.09 0.91 0.09 .02],'backgroundcolor','w','foregroundcolor','k','string',' ');
%%%%%%%%%%%%%
newtonystarttext=uicontrol(gcf,'style','text','string','ystart:','units','normalized','position',[0.02 0.88 0.06 .02],'foregroundcolor','k','backgroundcolor','w');
%%%%%%%%%%%%%
newtonystartruta=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.88 0.09 .02],'backgroundcolor','w','foregroundcolor','k','string',' ');
%%%%%%%%%%%%%
newtonxtext=uicontrol(gcf,'style','text','string','x:','units','normalized','position',[0.02 0.85 0.06 .02],'foregroundcolor','k','backgroundcolor','w');
%%%%%%%%%%%%%
newtonxruta=uicontrol(gcf,'style','text','units','normalized', ...
		      'position',[0.09 0.85 0.09 .02],'backgroundcolor','w','foregroundcolor','k','string',' ');
%%%%%%%%%%%%%
newtonytext=uicontrol(gcf,'style','text','string','y:','units','normalized','position',[0.02 0.82 0.06 .02],'foregroundcolor','k','backgroundcolor','w');
%%%%%%%%%%%%%
newtonyruta=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.82 0.09 .02],'backgroundcolor','w','foregroundcolor','k','string',' ');
%%%%%%%%%%%%%
armijoram=uicontrol(gcf,'style','frame','units','normalized','position',[0.01 0.80-avst1 0.18 0.19],'backgroundcolor','m');
%%%%%%%%%%%%%
armijoknapp=uicontrol(gcf,'style','checkbox','string','Armijos metod','value',0,'units','normalized','position',[0.02 0.95-avst1 0.16 .03],'callback',{@onedim_callback,'armijotoggla'},'backgroundcolor','w','foregroundcolor','m');
%%%%%%%%%%%%%
armijoxstarttext=uicontrol(gcf,'style','text','string','xstart:','units','normalized','position',[0.02 0.91-avst1 0.06 .02],'foregroundcolor','m','backgroundcolor','w');
%%%%%%%%%%%%%
armijoxstartruta=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.91-avst1 0.09 .02],'backgroundcolor','w','foregroundcolor','m','string',' ');
%%%%%%%%%%%%%
armijoystarttext=uicontrol(gcf,'style','text','string','ystart:','units','normalized','position',[0.02 0.88-avst1 0.06 .02],'foregroundcolor','m','backgroundcolor','w');
%%%%%%%%%%%%%
armijoystartruta=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.88-avst1 0.09 .02],'backgroundcolor','w','foregroundcolor','m','string',' ');
%%%%%%%%%%%%%
armijoxtext=uicontrol(gcf,'style','text','string','x:','units','normalized','position',[0.02 0.85-avst1 0.06 .02],'foregroundcolor','m','backgroundcolor','w');
%%%%%%%%%%%%%
armijoxruta=uicontrol(gcf,'style','text','units','normalized', ...
		      'position',[0.09 0.85-avst1 0.09 .02],'backgroundcolor','w','foregroundcolor','m','string',' ');
%%%%%%%%%%%%%
armijoytext=uicontrol(gcf,'style','text','string','y:','units','normalized','position',[0.02 0.82-avst1 0.06 .02],'foregroundcolor','m','backgroundcolor','w');
%%%%%%%%%%%%%
armijoyruta=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.82-avst1 0.09 .02],'backgroundcolor','w','foregroundcolor','m','string',' ');
%%%%%%%%%%%%%
goldenram=uicontrol(gcf,'style','frame','units','normalized','position',[0.01 0.80-2*avst1-avst2 0.18 0.19+avst2],'backgroundcolor','b');
%%%%%%%%%%%%%
goldenknapp=uicontrol(gcf,'style','checkbox','string','Golden section','value',0,'units','normalized','position',[0.02 0.95-2*avst1 0.16 .03],'callback',{@onedim_callback,'goldentoggla'},'backgroundcolor','w','foregroundcolor','b');
%%%%%%%%%%%%%
goldenxstarttext=uicontrol(gcf,'style','text','string','a:','units','normalized','position',[0.02 0.91-2*avst1 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
%%%%%%%%%%%%%
goldenxstartruta=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.91-2*avst1 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');
%%%%%%%%%%%%%
goldenystarttext=uicontrol(gcf,'style','text','string','lambda:','units','normalized','position',[0.02 0.88-2*avst1 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
%%%%%%%%%%%%%
goldenystartruta=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.88-2*avst1 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');
%%%%%%%%%%%%%
goldenxtext=uicontrol(gcf,'style','text','string','my:','units','normalized','position',[0.02 0.85-2*avst1 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
%%%%%%%%%%%%%
goldenxruta=uicontrol(gcf,'style','text','units','normalized', ...
		      'position',[0.09 0.85-2*avst1 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');
%%%%%%%%%%%%%
goldenytext=uicontrol(gcf,'style','text','string','b:','units','normalized','position',[0.02 0.82-2*avst1 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
%%%%%%%%%%%%%
goldenyruta=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.82-2*avst1 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');


%%%%%%%%%%%%%
fgoldenxstarttext=uicontrol(gcf,'style','text','string','f(a):','units','normalized','position',[0.02 0.91-2*avst1-avst2 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
%%%%%%%%%%%%%
fgoldenxstartruta=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.91-2*avst1-avst2 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');
%%%%%%%%%%%%%
fgoldenystarttext=uicontrol(gcf,'style','text','string','f(lambda):','units','normalized','position',[0.02 0.88-2*avst1-avst2 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
%%%%%%%%%%%%%
fgoldenystartruta=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.88-2*avst1-avst2 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');
%%%%%%%%%%%%%
fgoldenxtext=uicontrol(gcf,'style','text','string','f(my:)','units','normalized','position',[0.02 0.85-2*avst1-avst2 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
%%%%%%%%%%%%%
fgoldenxruta=uicontrol(gcf,'style','text','units','normalized', ...
		      'position',[0.09 0.85-2*avst1-avst2 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');
%%%%%%%%%%%%%
fgoldenytext=uicontrol(gcf,'style','text','string','f(b:)','units','normalized','position',[0.02 0.82-2*avst1-avst2 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
%%%%%%%%%%%%%
fgoldenyruta=uicontrol(gcf,'style','text','units','normalized','position',[0.09 0.82-2*avst1-avst2 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');
%%%%%%%%%%%%%
xmintext=uicontrol(gcf,'style','text','string','xmin','units','normalized','position',[0.01 0.194 0.05 .0202],'foregroundcolor','r','backgroundcolor','w');
%%%%%%%%%%%%%
xminruta=uicontrol(gcf,'style','edit','units','normalized','position',[0.075 0.19 0.05 .03],'backgroundcolor','w','foregroundcolor','r','string',num2str(xmin),'Callback',{@onedim_callback,'setxmin'});
%%%%%%%%%%%%%
xmaxtext=uicontrol(gcf,'style','text','string','xmax','units','normalized','position',[0.01 0.154 0.05 .0202],'foregroundcolor','r','backgroundcolor','w');
%%%%%%%%%%%%%
xmaxruta=uicontrol(gcf,'style','edit','units','normalized','position',[0.075 0.15 0.05 .03],'backgroundcolor','w','foregroundcolor','r','string',num2str(xmax),'Callback',{@onedim_callback,'setxmax'});
%%%%%%%%%%%%%
funktioner=uicontrol(gcf,'style','popup','units','normalized', ...
		     'position',[0.01 0.1 0.18 .03],'backgroundcolor','w','string','fun1|fun2','Callback',{@onedim_callback,'setfunktion'},'Value',1);
%%%%%%%%%%%%%
swapknapp=uicontrol(gcf,'style','push','foregroundcolor','r','string','change','value',0,'units','normalized','position',[0.14 0.15 0.05 .07],'callback',{@onedim_callback,'swa'},'backgroundcolor','w');  
%%%%%%%%%%%%%
slutknapp=uicontrol(gcf,'style','push','string','close','value',0, ...
		    'units','normalized','position',[0.01 0.02 0.05 .07],'callback',{@onedim_callback,'st�ng'},'backgroundcolor','w');  
%%%%%%%%%%%%%
multiknapp=uicontrol(gcf,'style','push','string','multidim','value',0,'units','normalized','position',[0.075 0.02 0.05 .07],'callback',{@onedim_callback,'multi'},'backgroundcolor','w');  

%%%%%%%%%%%%%
startknapp=uicontrol(gcf,'style','push','string','restart','value',0,'units','normalized','position',[0.14 0.02 0.05 .07],'callback',{@onedim_callback,'starta'},'backgroundcolor','w');  
%%%%%%%%%%%%%

elseif strcmp(action,'swa'),
  if xmin==-10
    xmin=-0.25;
  else
    xmin=-10;
  end;
  if xmax==10
    xmax=0.5;
  else
    xmax=10;
  end;
  set(xminruta,'string',num2str(xmin));
  set(xmaxruta,'string',num2str(xmax));  
onedim('starta')   

elseif strcmp(action,'st�ng'),
 close;
 
elseif strcmp(action,'multi'),
 close;
 multidim;
 
elseif strcmp(action,'starta'),
delete(gca);
pause(0.0001) % To prevent grey background after restarting in some cases (c) AG 2011
onedim('ritafunktion')
   set(newtonxstartruta,'string',' ');
   set(newtonystartruta,'string',' ');
   set(newtonxruta,'string',' ');
   set(newtonyruta,'string',' ');
   set(newtonknapp,'backgroundcolor','w')  % (c) AG 2013
   set(armijoxstartruta,'string',' ');
   set(armijoystartruta,'string',' ');
   set(armijoxruta,'string',' ');
   set(armijoyruta,'string',' ');
   set(goldenxstartruta,'string',' ');
   set(goldenystartruta,'string',' ');
   set(goldenxruta,'string',' ');
   set(goldenyruta,'string',' ');
   set(fgoldenxstartruta,'string',' ');
   set(fgoldenystartruta,'string',' ');
   set(fgoldenxruta,'string',' ');
   set(fgoldenyruta,'string',' ');
   
elseif strcmp(action,'newtontoggla'),
   onedim('starta');  
   set(newtonknapp,'value',1);  
   set(goldenknapp,'value',0);  
   set(armijoknapp,'value',0);  
   set(gcf,'windowbuttondownfcn',{@onedim_callback, 'newtonstega'});
   
elseif strcmp(action,'goldentoggla'),
   onedim('starta');  
   set(newtonknapp,'value',0);  
   set(goldenknapp,'value',1);  
   set(armijoknapp,'value',0);  
   set(gcf,'windowbuttondownfcn',{@onedim_callback, 'goldenstega'});
   
elseif strcmp(action,'armijotoggla'),
   onedim('starta');    
   set(newtonknapp,'value',0);  
   set(goldenknapp,'value',0);  
   set(armijoknapp,'value',1);  
   set(gcf,'windowbuttondownfcn',{@onedim_callback, 'armijostega'});

elseif strcmp(action,'setfunktion'),
   F=get(funktioner,'Value');
switch F
 case 1, f=@fun1;
 case 2, f=@fun2;
end;
onedim('starta')

elseif strcmp(action,'setxmin'),
  xmin=str2num(get(xminruta,'String'));
onedim('starta')  

elseif strcmp(action,'setxmax'),
  xmax=str2num(get(xmaxruta,'String'));
onedim('starta')



elseif strcmp(action,'newtonstega'),
 if omstart==1,
  omstart=0;
  cpoint=get(gca,'currentpoint');
  newtonpunkter=[cpoint(1) feval(f,cpoint(1))];
  newtonkurva=plot(newtonpunkter(:,1),newtonpunkter(:,2),'k','erasemode','xor','linewidth',[5]);
  set(newtonystartruta,'string',num2str(newtonpunkter(1,2)));
  set(newtonxstartruta,'string',num2str(newtonpunkter(1,1))); 
 else;
  x=newtonpunkter(end,1);
  d=-grad(f,x)/hessianen(f,x);
  newtonpunkter=[newtonpunkter;x+d feval(f,x+d)];
  set(newtonkurva,'xdata',newtonpunkter(:,1),'ydata',newtonpunkter(:,2));
  set(newtonyruta,'string',num2str(newtonpunkter(end,2)));
  set(newtonxruta,'string',num2str(newtonpunkter(end,1)));
  if norm(d)<1e-6                               % (c) AG 2013
    set(newtonknapp,'backgroundcolor','y')      %
  end                                           %
 end;

elseif strcmp(action,'armijostega'),
onedim('starta')
  cpoint=get(gca,'currentpoint');
  x=cpoint(1);
button=1;
g=grad(f,x);
F=feval(f,x);
  set(armijoxstartruta,'string',num2str(x));
  set(armijoystartruta,'string',num2str(F)); 
lambda=-sign(g);
k=-5;
while and(x+lambda*2^k<xmax,x+lambda*2^k>xmin)
%redstars=plot(x+lambda*2^k,feval(f,x+lambda*2^k),'r*');
redstars=plot(x+lambda*2^k,feval(f,x+lambda*2^k),'r*',x+lambda*2^k,ymin-ykant,'r*');
k=k+1;
end;
if lambda>0
t=x:0.01:xmax;
else
  t=xmin:0.01:x;
end;
greenline=plot(t,F+(t-x)*0.2*g,'g');
%blackstar=plot(x+lambda,feval(f,x+lambda),'k*',x+lambda,ymin-ykant,'k*');
while feval(f,x+2*lambda)<F+2*lambda*0.2*g
  lambda=2*lambda;
%  blackstar=plot(x+lambda,feval(f,x+lambda),'k*',x+lambda,ymin-ykant,'k*');
end;
while feval(f,x+lambda)>F+lambda*0.2*g
  lambda=lambda/2;
%  blackstar=plot(x+lambda,feval(f,x+lambda),'k*',x+lambda,ymin-ykant,'k*');
end;
x=x+lambda;
armijof=feval(f,x);
bluestar=plot(x,armijof,'b*',x,ymin-ykant,'b*');
set(armijoxruta,'string',num2str(x));
set(armijoyruta,'string',num2str(armijof)); 
  
  
elseif strcmp(action,'goldenstega'),  
 if omstart==1,
  omstart=2;
  cpoint=get(gca,'currentpoint');
  a=cpoint(1);
 elseif omstart==2
  omstart=0;
  cpoint=get(gca,'currentpoint');
  b=cpoint(1);
  almb=[];
  alfa=(sqrt(5)-1)/2;
  L=b-a;
  lambda=a+(1-alfa)*L;
  my=a+alfa*L;
  almb=[almb;a lambda my b];  
  x=almb;
  y=feval(f,x);
set(goldenxstartruta,'string',num2str(x(1)));
set(goldenystartruta,'string',num2str(x(2)));  
set(goldenxruta,'string',num2str(x(3)));
set(goldenyruta,'string',num2str(x(4)));  
set(fgoldenxstartruta,'string',num2str(y(1)));
set(fgoldenystartruta,'string',num2str(y(2)));  
set(fgoldenxruta,'string',num2str(y(3)));
set(fgoldenyruta,'string',num2str(y(4)));  
  Flambda=y(2);
  Fmy=y(3);  
  x=[x;x];
  y=[-10 -10 -10 -10;y];
  steg=plot(x,y,'r','erasemode','xor');  
  found=0;
  tol=1e-6;
  while not(found),
   if Flambda<=Fmy
    b=my;
    L=b-a;
    my=lambda;
    lambda=a+(1-alfa)*L;
    Fmy=Flambda;
    Flambda=feval(f,lambda);
   else
    a=lambda;
    L=b-a;
    lambda=my;
    my=a+alfa*L;
    Flambda=Fmy;
    Fmy=feval(f,my);
   end;  
   if abs(lambda-(a+b)/2)<tol
    found=1;
   end;
   almb=[almb;a lambda my b];   
  end;  
 k=1;
 elseif omstart==0
   if k<size(almb,1),
     k=k+1;
     x=almb(k,:);
     y=feval(f,x);
set(goldenxstartruta,'string',num2str(x(1)));
set(goldenystartruta,'string',num2str(x(2)));  
set(goldenxruta,'string',num2str(x(3)));
set(goldenyruta,'string',num2str(x(4)));   
set(fgoldenxstartruta,'string',num2str(y(1)));
set(fgoldenystartruta,'string',num2str(y(2)));  
set(fgoldenxruta,'string',num2str(y(3)));
set(fgoldenyruta,'string',num2str(y(4)));  
     x=[x;x];
     y=[-10 -10 -10 -10;y];
     delete(steg);
     steg=plot(x,y,'r','erasemode','xor');
   end;  
 end;
end;  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function multidim(action)

global newtonejklar modnewtonejklar sdarmijoejklar strategiejklar tol yminruta ymaxruta  ymin ymax   xminruta xmaxruta  xmin xmax  t newtontid sdarmijotid modnewtontid strategitid f F funktioner ettstrategi tvastrategi strategi1 strategi2  epsilonruta epsilon epsiruta epsi omstart newtonon newtonkurva  newtonpunkter ...
    newtonfruta newtoncpuruta  newtonknapp modnewtonon modnewtonkurva ...
    modnewtonpunkter modnewtonfruta  modnewtoncpuruta  modnewtonknapp ...
    sdarmijoon sdarmijokurva  sdarmijopunkter sdarmijofruta ...
    sdarmijocpuruta  sdarmijoknapp strategion strategikurva ...
    strategipunkter strategifruta   strategicpuruta strategiknapp

if nargin<1,
	action='setup';
end;

if strcmp(action,'setup'),
  warning off;
%%%%%%%%%%%%%
figur=figure('units','normalized','position',[0.1 0.1 0.8 0.8],'menubar','none');
%%%%%%%%%%%%%
f=@f1;
tol=1e-4;
xmin=-6;
xmax=6;
ymin=-6;
ymax=6;
newtonejklar=1;
modnewtonejklar=1;
sdarmijoejklar=1;
strategiejklar=1;

%multidim('ritafunktion'); (c) edited by AG
multidim('ritaknappar');
multidim('setfunktion');

elseif  strcmp(action,'ritafunktion'),
omstart=1; 
X=xmin:(xmax-xmin)/101:xmax;
Y=ymin:(ymax-ymin)/101:ymax;
xkant=(xmax-xmin)/20;
ykant=(ymax-ymin)/20;
axlar=axes('units','normalized','Position',[0.22 0.02 0.79 0.96], ...
	   'XLim',[xmin-xkant xmax+xkant],'YLim',[ymin-ykant ymax+ykant]);
hold on;
[x,y]=meshgrid(X,Y);
z=feval(f,x,y);
mi=min(min(z));
ma=max(max(z));
steg=(ma-mi)/100;
if and(~isequal(f,@f4),~isequal(f,@f3))
contour(x,y,z,[mi:steg:ma]);
end;
elseif strcmp(action,'ritaknappar'),
omstart=1;
epsilon=0;
newtonon=0;
modnewtonon=0;
strategion=0;
sdarmijoon=0;
set(gcf,'windowbuttondownfcn',{@multidim_callback, 'stega'});
%%%%%%%%%%%%%
kram=uicontrol(gcf,'style','frame','units','normalized','position',[0.01 0.88 0.18 0.11],'backgroundcolor','k');
%%%%%%%%%%%%%
newtonknapp=uicontrol(gcf,'style','checkbox','string','Newtons metod','value',0,'units','normalized','position',[0.02 0.95 0.16 .03],'callback',{@multidim_callback,'newtontoggla'},'backgroundcolor','w','foregroundcolor','k');
%%%%%%%%%%%%%
newtonftext=uicontrol(gcf,'style','text','string','f-value','units','normalized','position',[0.02 0.92 0.06 .02],'foregroundcolor','k','backgroundcolor','w');
%%%%%%%%%%%%%
newtonfruta=uicontrol(gcf,'style','text','units','normalized', ...
		      'position',[0.09 0.92 0.09 .02],'backgroundcolor','w','foregroundcolor','k','string',' ');
%%%%%%%%%%%%%
newtoncputext=uicontrol(gcf,'style','text','string','cputime','units','normalized','position',[0.02 0.89 0.06 .02],'foregroundcolor','k','backgroundcolor','w');
%%%%%%%%%%%%%
newtoncpuruta=uicontrol(gcf,'style','text','units','normalized', ...
			'position',[0.09 0.89 0.09 .02],'backgroundcolor','w','foregroundcolor','k','string',' ');
%%%%%%%%%%%%%
mram=uicontrol(gcf,'style','frame','units','normalized','position',[0.01 0.75 0.18 0.11],'backgroundcolor','m');
%%%%%%%%%%%%%
sdarmijoknapp=uicontrol(gcf,'style','checkbox','string','sd med armijo','value',0,'units','normalized','position',[0.02 0.82 0.16 .03],'callback',{@multidim_callback,'sdarmijotoggla'},'backgroundcolor','w','foregroundcolor','m');
%%%%%%%%%%%%%
sdarmijoftext=uicontrol(gcf,'style','text','string','f-value','units','normalized','position',[0.02 0.79 0.06 .02],'foregroundcolor','m','backgroundcolor','w');
%%%%%%%%%%%%%
sdarmijofruta=uicontrol(gcf,'style','text','units','normalized', ...
		      'position',[0.09 0.79 0.09 .02],'backgroundcolor','w','foregroundcolor','m','string',' ');
%%%%%%%%%%%%%
sdarmijocputext=uicontrol(gcf,'style','text','string','cputime','units','normalized','position',[0.02 0.76 0.06 .02],'foregroundcolor','m','backgroundcolor','w');
%%%%%%%%%%%%%
sdarmijocpuruta=uicontrol(gcf,'style','text','units','normalized', ...
			  'position',[0.09 0.76 0.09 .02],'backgroundcolor','w','foregroundcolor','m','string',' ');
%%%%%%%%%%%%%
bram=uicontrol(gcf,'style','frame','units','normalized','position',[0.01 0.59 0.18 0.14],'backgroundcolor','b');
%%%%%%%%%%%%%
modnewtonknapp=uicontrol(gcf,'style','checkbox','string','modnewton','value',0,'units','normalized','position',[0.02 0.69 0.16 .03],'callback',{@multidim_callback,'modnewtontoggla'},'foregroundcolor','b','backgroundcolor','w');
%%%%%%%%%%%%%
epsilontext=uicontrol(gcf,'style','text','string','EPSILON','units','normalized','position',[0.02 0.66 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
%%%%%%%%%%%%%
epsilonruta=uicontrol(gcf,'style','edit','units','normalized', ...
		      'position',[0.09 0.66 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',num2str(epsilon),'Callback',{@multidim_callback,'setepsilon'});
%%%%%%%%%%%%%
modnewtonftext=uicontrol(gcf,'style','text','string','f-value','units','normalized','position',[0.02 0.63 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
%%%%%%%%%%%%%
modnewtonfruta=uicontrol(gcf,'style','text','units','normalized', ...
		      'position',[0.09 0.63 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');
%%%%%%%%%%%%%
modnewtoncputext=uicontrol(gcf,'style','text','string','cputime','units','normalized','position',[0.02 0.60 0.06 .02],'foregroundcolor','b','backgroundcolor','w');
%%%%%%%%%%%%%
modnewtoncpuruta=uicontrol(gcf,'style','text','units', ...
			   'normalized','position',[0.09 0.60 0.09 .02],'backgroundcolor','w','foregroundcolor','b','string',' ');

%%%%%%%%%%%%%
redram=uicontrol(gcf,'style','frame','units','normalized','position',[0.01 0.42 0.18 0.14],'backgroundcolor','r');
%%%%%%%%%%%%%
strategiknapp=uicontrol(gcf,'style','checkbox','string','strategi','value',0,'units','normalized','position',[0.02 0.52 0.055 .03],'callback',{@multidim_callback,'strategitoggla'},'backgroundcolor','w','foregroundcolor','r');
%%%%%%%%%%%%%
strategi1=uicontrol(gcf,'style','radio','string','sd','value',1,'units','normalized','position',[0.08 0.52 0.035 .03],'callback',{@multidim_callback,'setstrategi1'},'backgroundcolor','w','foregroundcolor','r');
%%%%%%%%%%%%%
strategi2=uicontrol(gcf,'style','radio','string','newton','value',0,'units','normalized','position',[0.12 0.52 0.06 .03],'callback',{@multidim_callback,'setstrategi2'},'backgroundcolor','w','foregroundcolor','r');
%%%%%%%%%%%%%
epsitext=uicontrol(gcf,'style','text','string','EPSILON','units','normalized','position',[0.02 0.49 0.06 .02],'foregroundcolor','r','backgroundcolor','w');
%%%%%%%%%%%%%
epsiruta=uicontrol(gcf,'style','edit','units','normalized','position',[0.09 ...
		    0.49 0.09 .02],'backgroundcolor','w','foregroundcolor','r','string',num2str(epsi),'Callback',{@multidim_callback,'setepsi'});
%%%%%%%%%%%%%
strategiftext=uicontrol(gcf,'style','text','string','f-value','units','normalized','position',[0.02 0.46 0.06 .02],'foregroundcolor','r','backgroundcolor','w');
%%%%%%%%%%%%%
strategifruta=uicontrol(gcf,'style','text','units','normalized', ...
		      'position',[0.09 0.46 0.09 .02],'backgroundcolor','w','foregroundcolor','r','string',' ');
%%%%%%%%%%%%%
strategicputext=uicontrol(gcf,'style','text','string','cputime','units','normalized','position',[0.02 0.43 0.06 .02],'foregroundcolor','r','backgroundcolor','w');
%%%%%%%%%%%%%
strategicpuruta=uicontrol(gcf,'style','text','units','normalized', ...
			  'position',[0.09 0.43 0.09 .02],'backgroundcolor','w','foregroundcolor','r','string',' ');
%%%%%%%%%%%%%
xmintext=uicontrol(gcf,'style','text','string','xmin','units','normalized','position',[0.02 0.37 0.06 .02],'foregroundcolor','k','backgroundcolor','w');
%%%%%%%%%%%%%
xminruta=uicontrol(gcf,'style','edit','units','normalized','position',[0.09 ...
		    0.37-0.003 0.09 .025],'backgroundcolor','w','foregroundcolor','k','string',num2str(xmin),'Callback',{@multidim_callback,'setxmin'});
%%%%%%%%%%%%%
xmaxtext=uicontrol(gcf,'style','text','string','xmax','units','normalized','position',[0.02 0.33 0.06 .02],'foregroundcolor','k','backgroundcolor','w');
%%%%%%%%%%%%%
xmaxruta=uicontrol(gcf,'style','edit','units','normalized','position',[0.09 ...
		    0.33-0.003 0.09 .025],'backgroundcolor','w','foregroundcolor','k','string',num2str(xmax),'Callback',{@multidim_callback,'setxmax'});
%%%%%%%%%%%%%
ymintext=uicontrol(gcf,'style','text','string','ymin','units','normalized','position',[0.02 0.29 0.06 .02],'foregroundcolor','k','backgroundcolor','w');
%%%%%%%%%%%%%
yminruta=uicontrol(gcf,'style','edit','units','normalized','position',[0.09 ...
		    0.29-0.003 0.09 .025],'backgroundcolor','w','foregroundcolor','k','string',num2str(ymin),'Callback',{@multidim_callback,'setymin'});
%%%%%%%%%%%%%
ymaxtext=uicontrol(gcf,'style','text','string','ymax','units','normalized','position',[0.02 0.25 0.06 .02],'foregroundcolor','k','backgroundcolor','w');
%%%%%%%%%%%%%
ymaxruta=uicontrol(gcf,'style','edit','units','normalized','position',[0.09 ...
		    0.25-0.003 0.09 .025],'backgroundcolor','w','foregroundcolor','k','string',num2str(ymax),'Callback',{@multidim_callback,'setymax'});
%%%%%%%%%%%%%
funktioner=uicontrol(gcf,'style','popup','units','normalized', ...
		     'position',[0.01 0.1 0.18 .03],'backgroundcolor','w','string','f1|f2|f3|f4|f5|f6','Callback',{@multidim_callback,'setfunktion'},'Value',1);
%%%%%%%%%%%%%
slutknapp=uicontrol(gcf,'style','push','string','close','value',0, ...
		    'units','normalized','position',[0.01 0.02 0.05 .07],'callback',{@multidim_callback,'st�ng'},'backgroundcolor','w');  
%%%%%%%%%%%%%
oneknapp=uicontrol(gcf,'style','push','string','onedim','value',0,'units','normalized','position',[0.075 0.02 0.05 .07],'callback',{@multidim_callback,'one'},'backgroundcolor','w');
%%%%%%%%%%%%%
startknapp=uicontrol(gcf,'style','push','string','restart','value',0,'units','normalized','position',[0.14 0.02 0.05 .07],'callback',{@multidim_callback,'starta'},'backgroundcolor','w');  
%%%%%%%%%%%%%


elseif strcmp(action,'st�ng'),
  warning on;
 close;
 
elseif strcmp(action,'one'),
  warning on;
 close; 
 onedim;
 
elseif strcmp(action,'starta'),
   omstart=1;
delete(gca);
pause(0.0001)  % To prevent grey background after restart in some cases (c) AG 2011
multidim('ritafunktion')
   set(newtonfruta,'string',' ');
   set(modnewtonfruta,'string',' ');
   set(sdarmijofruta,'string',' '); 
   set(strategifruta,'string',' ');
   set(newtoncpuruta,'string',' ');
   set(modnewtoncpuruta,'string',' ');
   set(sdarmijocpuruta,'string',' '); 
   set(strategicpuruta,'string',' ');   
   set(newtonknapp,'backgroundcolor','w')
   set(modnewtonknapp,'backgroundcolor','w')
   set(sdarmijoknapp,'backgroundcolor','w')
   set(strategiknapp,'backgroundcolor','w')
   strategitid=0;
   newtontid=0;
   sdarmijotid=0;
   modnewtontid=0;
   newtonejklar=1;
   modnewtonejklar=1;
   sdarmijoejklar=1;
   strategiejklar=1;
 
 elseif strcmp(action,'newtontoggla'),
  newtonon=1-newtonon;
   newtontid=0;

   
 elseif strcmp(action,'modnewtontoggla'),
  modnewtonon=1-modnewtonon;
   modnewtontid=0;

 elseif strcmp(action,'sdarmijotoggla'),
  sdarmijoon=1-sdarmijoon;
   sdarmijotid=0;

 elseif strcmp(action,'strategitoggla'),
  strategion=1-strategion;
    strategitid=0;
   
 elseif strcmp(action,'setepsilon'),   
  epsilon=str2num(get(epsilonruta,'String'));
  
 elseif strcmp(action,'setepsi'),   
  epsi=str2num(get(epsiruta,'String'));  

elseif strcmp(action,'setstrategi1'),
  ettstrategi=get(strategi1,'Value');  
   set(strategi2,'Value',1-ettstrategi);  
   
elseif strcmp(action,'setstrategi2'),
  tvastrategi=get(strategi2,'Value');  
   set(strategi1,'Value',1-tvastrategi);     

elseif strcmp(action,'setxmax'),
  xmax=str2num(get(xmaxruta,'String'));
  multidim('starta');
  
elseif strcmp(action,'setxmin'),
  xmin=str2num(get(xminruta,'String')); 
  multidim('starta');

elseif strcmp(action,'setymax'),
  ymax=str2num(get(ymaxruta,'String'));
  multidim('starta');
  
elseif strcmp(action,'setymin'),
  ymin=str2num(get(yminruta,'String')); 
  multidim('starta');
  
elseif strcmp(action,'setfunktion'),
   F=get(funktioner,'Value');
switch F
 case 1, f=@f1;
 case 2, f=@f2;
 case 3, f=@f3;
 case 4, f=@f4;
 case 5, f=@f5;
 case 6, f=@f6;  
 case 7, f=@f7;   
end;
multidim('starta')
   
elseif strcmp(action,'stega'),
 if omstart==1,
  omstart=0;
  cpoint=get(gca,'currentpoint');
   newtonpunkter=[cpoint(1) cpoint(3)];
   newtonkurva=plot(newtonpunkter(:,1),newtonpunkter(:,2),'k','erasemode','xor','linewidth',[2]);
   newtonf=feval(f,newtonpunkter(end,1),newtonpunkter(end,2));
if newtonon
  set(newtonfruta,'string',num2str(newtonf));
end;
   modnewtonpunkter=[cpoint(1) cpoint(3)];
   modnewtonkurva=plot(modnewtonpunkter(:,1),modnewtonpunkter(:,2),'b','erasemode','xor','linewidth',[3]);
   modnewtonf=feval(f,modnewtonpunkter(end,1),modnewtonpunkter(end,2));
if modnewtonon
  set(modnewtonfruta,'string',num2str(modnewtonf));
end;
   sdarmijopunkter=[cpoint(1) cpoint(3)];
   sdarmijokurva=plot(sdarmijopunkter(:,1),sdarmijopunkter(:,2),'m','erasemode','xor','linewidth',[4]);
   sdarmijof=feval(f,sdarmijopunkter(end,1),sdarmijopunkter(end,2));
if sdarmijoon
  set(sdarmijofruta,'string',num2str(sdarmijof));
end;
   strategipunkter=[cpoint(1) cpoint(3)];
   strategikurva=plot(strategipunkter(:,1),strategipunkter(:,2),'r','erasemode','xor','linewidth',[5]);
   strategif=feval(f,strategipunkter(end,1),strategipunkter(end,2));
if strategion
  set(strategifruta,'string',num2str(strategif));
end;
else
if and(newtonon,newtonejklar)
   t=cputime;  
   x=newtonpunkter(end,:);
   d=-inv(lvhess(f,x(1),x(2)))*lvgrad(f,x(1),x(2));
if norm(d)<tol
  newtonejklar=0;
  set(newtonknapp,'backgroundcolor','y')
  end;
   newtonpunkter=[newtonpunkter;x+d'];
   set(newtonkurva,'xdata',newtonpunkter(:,1),'ydata',newtonpunkter(:,2));
   newtonf=feval(f,newtonpunkter(end,1),newtonpunkter(end,2));
   set(newtonfruta,'string',num2str(newtonf));
   newtontid=newtontid+cputime-t;   
   set(newtoncpuruta,'string',num2str(newtontid));
end;
if and(modnewtonon,modnewtonejklar)
   t=cputime;
   x=modnewtonpunkter(end,:);
   d=-inv(epsilon*eye(2)+lvhess(f,x(1),x(2)))*lvgrad(f,x(1),x(2));
   if norm(d)<tol
     modnewtonejklar=0;
     set(modnewtonknapp,'backgroundcolor','y')
   end;   
   modnewtonpunkter=[modnewtonpunkter;x+d'];
   set(modnewtonkurva,'xdata',modnewtonpunkter(:,1),'ydata',modnewtonpunkter(:,2));
   modnewtonf=feval(f,modnewtonpunkter(end,1),modnewtonpunkter(end,2));
   set(modnewtonfruta,'string',num2str(modnewtonf));
   modnewtontid=modnewtontid+cputime-t;   
   set(modnewtoncpuruta,'string',num2str(modnewtontid));
end;
if and(sdarmijoon,sdarmijoejklar)
   t=cputime;
   x=sdarmijopunkter(end,:);
   d=-lvgrad(f,x(1),x(2));
   d=d/norm(d);
   lambda=1;
   y=x+lambda*d';
   while feval(f,y(1),y(2))<=feval(f,x(1),x(2))+lambda*0.2*d'*lvgrad(f,x(1),x(2))
     lambda=2*lambda;
     y=x+lambda*d';   
     if lambda>100
       break;
     end;
   end;
   while feval(f,y(1),y(2))>feval(f,x(1),x(2))+lambda*0.2*d'*lvgrad(f,x(1),x(2))
     lambda=lambda/2;
     y=x+lambda*d';   
     if lambda<1.e-4
       break;
     end;
   end;
   sdarmijopunkter=[sdarmijopunkter;y];
if norm(y-x)<tol
  sdarmijoejklar=0;
  set(sdarmijoknapp,'backgroundcolor','y')
  end;   
   set(sdarmijokurva,'xdata',sdarmijopunkter(:,1),'ydata',sdarmijopunkter(:,2));
   sdarmijof=feval(f,sdarmijopunkter(end,1),sdarmijopunkter(end,2));
   set(sdarmijofruta,'string',num2str(sdarmijof)); 
   sdarmijotid=sdarmijotid+cputime-t;
   set(sdarmijocpuruta,'string',num2str(sdarmijotid));    
end;
if and(strategion,strategiejklar)
  t=cputime;
  x=strategipunkter(end,:);
  strategi=get(strategi1,'Value');
  if strategi==1
   d=-lvgrad(f,x(1),x(2));
   d=d/norm(d);
   lambda=1;
   y=x+lambda*d';
   while feval(f,y(1),y(2))<=feval(f,x(1),x(2))+lambda*0.2*d'*lvgrad(f,x(1),x(2))
    lambda=2*lambda;
    y=x+lambda*d';   
    if lambda>100
     break;
    end;
   end;
   while feval(f,y(1),y(2))>feval(f,x(1),x(2))+lambda*0.2*d'*lvgrad(f,x(1),x(2))
    lambda=lambda/2;
    y=x+lambda*d';   
    if lambda<1.e-4
     break;
    end;
   end;
  else
   d=-inv(epsi*eye(2)+lvhess(f,x(1),x(2)))*lvgrad(f,x(1),x(2));
   y=x+d';
  end;
if norm(y-x)<tol
  strategiejklar=0;
  set(strategiknapp,'backgroundcolor','y')
  end;  
   strategipunkter=[strategipunkter;y];
   set(strategikurva,'xdata',strategipunkter(:,1),'ydata',strategipunkter(:,2));
   strategif=feval(f,strategipunkter(end,1),strategipunkter(end,2));
   set(strategifruta,'string',num2str(strategif));
strategitid=strategitid+cputime-t;
   set(strategicpuruta,'string',num2str(strategitid));
 end;
 drawnow;
 end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function g = grad(F,x)
% g = grad(F,x)
%
% Calculates the gradient (column) vector of the function f at x.

for j = 1:length(x)
   xplus = x;
   xminus = x;
   xplus(j) = x(j) + 1.e-8;
   xminus(j) = x(j) - 1.e-8;
   fplus = feval(F,xplus);
   fminus = feval(F,xminus);
   g(j,1) = ( fplus - fminus )/2.e-8;
   end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h=hessianen(F,x)
e=1.e-4;
a=(feval(F,x+e)-2*feval(F,x)+feval(F,x-e))/e^2;
h=a;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function g=lvgrad(F,x,y)
e=1.e-8;
g=[(feval(F,x+e,y)-feval(F,x-e,y))/2/e;(feval(F,x,y+e)-feval(F,x,y-e))/2/e];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h=lvhess(F,x,y)
e=1.e-4;
a=(feval(F,x+e,y)-2*feval(F,x,y)+feval(F,x-e,y))/e^2;
b=(feval(F,x+e,y+e)+feval(F,x-e,y-e)-feval(F,x-e,y+e)-feval(F,x+e, ...
						  y-e))/4/e^2;
c=(feval(F,x,y+e)-2*feval(F,x,y)+feval(F,x,y-e))/e^2;
h=[a b;b c];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function z=f1(x,y)
z=exp(x)+x.^2+2*x.*y+4*y.^2+10*(x+2*y-6).^2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function z=f2(x,y)
%z=100*(y-x.^2).^2+(1-x).^2+2;
z=sqrt(x.^2+(y-2).^2)+sqrt(x.^2+y.^2)+sqrt((x-6).^2+(y+2).^2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function z=f3(x,y)
%z=sqrt(x.^2+(y-2).^2)+sqrt(x.^2+y.^2)+sqrt((x-6).^2+(y+2).^2);
z=100*(y-x.^2).^2+(1-x).^2+2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function z=f4(u,v)
%z=20*sin(x)+30*sin(y)+x.^2+y.^2;
x=(11*u+6)./12;
y=(8*v-24)./12;
z=(0.35*x).^3.*(0.2+0.35*y).*exp((-(0.35*x).^2-2*(0.35*y).^2)/2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function z=f5(u,v)
%z=y.^2/9+4*x.^2/9-x.^4/81;
x=(11*u+6)./12;
y=(8*v-24)./12;
z=(0.35*x).^3.*(0.2+0.35*y).*exp((-(0.35*x).^2-2*(0.35*y).^2)/2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function z=f6(x,y)
%x=(11*u+6)./12;
%y=(8*v-24)./12;
%z=(0.35*x).^3.*(0.2+0.35*y).*exp((-(0.35*x).^2-2*(0.35*y).^2)/2);
%z=20*sin(x)+30*sin(y)+x.^2+y.^2;
z=100*(y-x.^2).^2+(1-x).^2+2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function z=ffour(x)
z=f4(x(1),x(2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function z=fthree(x)
z=f3(x(1),x(2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=fun1(x)
y=(-x.^4+6*x.^2)./(1+(x-0.5).^4);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y=fun2(x)
y=max((x+7).^2/50+4,10-(x+10).^2/50);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function onedim_callback(fictive1,fictive2,action)

onedim(action)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function multidim_callback(fictive1,fictive2,action)

multidim(action)

