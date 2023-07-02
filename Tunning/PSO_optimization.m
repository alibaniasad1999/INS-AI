%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSO optimization with saving history and plot %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;

%%
nvars = 5;
micro_g_to_meters_per_second_squared = 9.80665E-6;
lb = zeros(1, nvars);
ub = zeros(1, nvars);
% Initial attitude uncertainty per axis (deg, converted to rad)
lb(1) = deg2rad(0);
ub(1) = deg2rad(2);
% Initial velocity uncertainty per axis (m/s)
lb(2) =0;
ub(2) = 0.5;
% Initial position uncertainty per axis (m)
lb(3) =0;
ub(3) = 20;
% Initial accelerometer bias uncertainty per instrument (micro-g, converted
% to m/s^2)
lb(4) =0;
ub(4) = 10000 * micro_g_to_meters_per_second_squared;
% Initial gyro bias uncertainty per instrument (deg/hour, converted to rad/sec)
lb(5) =0;
ub(5) = 20 * pi/180 / 3600;

%%

options = optimoptions('particleswarm','PlotFcn','pswplotbestf');
[x,fval,exitflag,output] = particleswarm(@Objective_function,nvars,...
    lb,ub,options);