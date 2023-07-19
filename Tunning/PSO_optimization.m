%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSO optimization with saving history and plot %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;

%%
nvars = 6;
micro_g_to_meters_per_second_squared = 9.80665E-6;
lb = zeros(1, nvars);
ub = zeros(1, nvars);
% Initial attitude uncertainty per axis (deg, converted to rad)
lb(1) = deg2rad(0);
ub(1) = deg2rad(2);
% Initial velocity uncertainty per axis (m/s)
lb(2) =0;
ub(2) = 0.5;
D2R = 0.01745329252;%         convert degree to radian
R2D = 1/D2R;%                 convert radian to degree
Mug2mps2 = 9.80665E-6;%       convert micro-g to meter per second.^2
tao_INS = 0.01;
%accel_VRW: Accelerometer noise PSD (m^2 s^-3)
accel_VRW = (1100 * Mug2mps2) ^ 2 * tao_INS;
%accel_bias_PSD: Accelerometer bias random walk PSD (m^2 s^-5)
accel_bias_PSD = 1.0E-5;
%init_bg_sd: Initial gyro. bias uncertainty (rad/s)
init_bg_sd = 20 * D2R / 3600;
%gyro_ARW: Gyro noise PSD (rad^2/s)
gyro_ARW = (1.1 * D2R / 60)^ 2 * tao_INS;
%gyro_bias_PSD: Gyro bias random walk PSD (rad^2 s^-3)
gyro_bias_PSD = 4.0E-11;

%accel_VRW: Accelerometer noise PSD (m^2 s^-3)
lb(3) =0;
ub(3) = accel_VRW*2;
%gyro_ARW: Gyro noise PSD (rad^2/s)
lb(4) =0;
ub(4) = gyro_ARW*2;
%accel_bias_PSD: Accelerometer bias random walk PSD (m^2 s^-5)
lb(5) =0;
ub(5) = accel_bias_PSD*2;
%gyro_bias_PSD: Gyro bias random walk PSD (rad^2 s^-3)
lb(6) =0;
ub(6) = gyro_bias_PSD*2;


D2R = 0.01745329252;%         convert degree to radian
R2D = 1/D2R;%                 convert radian to degree
Mug2mps2 = 9.80665E-6;%       convert micro-g to meter per second.^2

%accel_VRW: Accelerometer noise PSD (m^2 s^-3)
accel_VRW = (1100 * Mug2mps2) ^ 2 * tao_INS;
%accel_bias_PSD: Accelerometer bias random walk PSD (m^2 s^-5)
accel_bias_PSD = 1.0E-5;
%init_bg_sd: Initial gyro. bias uncertainty (rad/s)
init_bg_sd = 20 * D2R / 3600;
%gyro_ARW: Gyro noise PSD (rad^2/s)
gyro_ARW = (1.1 * D2R / 60)^ 2 * tao_INS;
%gyro_bias_PSD: Gyro bias random walk PSD (rad^2 s^-3)
gyro_bias_PSD = 4.0E-11;


%%

options = optimoptions('particleswarm','PlotFcn','pswplotbestf');
[x,fval,exitflag,output] = particleswarm(@Objective_function,nvars,...
    lb,ub,options);