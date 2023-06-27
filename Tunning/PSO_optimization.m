%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSO optimization with saving history and plot %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fun = @fun_opt;
nvars = 2; %%%%
lb = [-5.12,-5.12]; %%%%%
ub = [5.12,5.12]; %%%%%
options = optimoptions('particleswarm','PlotFcn','pswplotbestf');
[x,fval,exitflag,output] = particleswarm(fun,nvars,lb,ub,options);

function y = fun_opt(x)
    y = x.^2-10*x+20;
    y = sum(sum(y));
end