close all; clc;
%% ========================================================================
Set_Initialization_Error_GPS_INS;
KF_Config_GPS_INS;
tor_s = 1; % GPS Frequency
lGBB = [0;0;0];
%% ========================================================================
% Constants
D2R = 0.01745329252;%         convert degree to radian
R2D = 1/D2R;%                 convert radian to degree
Mug2mps2 = 9.80665E-6;%       convert micro-g to meter per second.^2
%% ========================================================================
% load('IMU_meas_60sec_car.mat');
% load('GPS_meas_1hz_60sec_car.mat');
load('IMU_meas_1000sec_otto.mat');
load('GPS_meas_1hz_otto_1000sec.mat');
%% ========================================================================
% Initialize true navigation solution
old_time = in_profile(1,1);
old_true_L_b = in_profile(1,2);
old_true_lambda_b = in_profile(1,3);
old_true_h_b = in_profile(1,4);
old_true_v_eb_n = in_profile(1,5:7)';
old_true_eul_nb = in_profile(1,8:10)';
old_true_C_b_n = Euler_to_CTM(old_true_eul_nb)';

% Initialize estimated navigation solution
[old_est_L_b,old_est_lambda_b,old_est_h_b,old_est_v_eb_n,old_est_C_b_n] =...
    Initialize_NED(old_true_L_b,old_true_lambda_b,old_true_h_b,...
    old_true_v_eb_n,old_true_C_b_n,initialization_errors);

% Initialize Kalman filter P matrix and IMU bias states
P_matrix = Initialize_LC_P_matrix(LC_KF_config);
est_IMU_bias = zeros(6,1);
%% ========================================================================
out_errors(1,1) = old_time;
out_errors(1,2:4) = initialization_errors.delta_r_eb_n';
out_errors(1,5:7) = initialization_errors.delta_v_eb_n';
out_errors(1,8:10) = initialization_errors.delta_eul_nb_n';

out_profile(1,1) = old_time;
out_profile(1,2) = old_est_L_b;
out_profile(1,3) = old_est_lambda_b;
out_profile(1,4) = old_est_h_b;
out_profile(1,5:7) = old_est_v_eb_n';
out_profile(1,8:10) = CTM_to_Euler(old_est_C_b_n')';
Train_data = zeros(length(IMU_meas), 9);

% Progress bar
dots = '....................';
bars = '||||||||||||||||||||';
rewind = '\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b';
fprintf(strcat('Processing: ',dots));
progress_mark = 0;
progress_epoch = 0;
%% ========================================================================
% Main loop
Run_time = 0;
GPS_k = 1;
GPS_update_time = 0;
no_epochs = length(IMU_meas);

for epoch = 2:no_epochs

    % Update progress bar
    if (epoch - progress_epoch) > (no_epochs/20)
        progress_mark = progress_mark + 1;
        progress_epoch = epoch;
        fprintf(strcat(rewind,bars(1:progress_mark),...
            dots(1:(20 - progress_mark))));
    end % if epoch

    % Input data from motion profile
    time = IMU_meas(epoch-1,1);

    % Time interval
    tor_i = time - old_time;

    meas_f_ib_b = IMU_meas(epoch-1,2:4)';
    meas_omega_ib_b = IMU_meas(epoch-1,5:7)';

    % Update estimated navigation solution
    [est_L_b,est_lambda_b,est_h_b,est_v_eb_n,est_C_b_n] = ...
        Nav_equations_NED(tor_i,old_est_L_b,old_est_lambda_b,old_est_h_b,...
        old_est_v_eb_n,old_est_C_b_n,meas_f_ib_b,meas_omega_ib_b);
    Train_data(epoch, 1) = est_L_b;
    Train_data(epoch, 2) = est_lambda_b;
    Train_data(epoch, 3) = est_h_b;
    Train_data(epoch, 4:6) = est_v_eb_n;
    Train_data(epoch, 7:9) = CTM_to_Euler(est_C_b_n')';
    %==========================================================================
    %% if GPS output received: run Kalman filter
    tao_GPS = time - GPS_update_time;  % Time update interval
    if (tao_GPS) >= tor_s
        GPS_update_time = time;
        GPS_k = GPS_k + 1;
        GNSS_r_eb_n = GPS_NED(GPS_k,2:4)';
        GNSS_v_eb_n = GPS_NED(GPS_k,5:7)';
        %--------------------------------------------------------------------------
        % Run Integration Kalman filter
        [est_L_b,est_lambda_b,est_h_b,est_v_eb_n,est_C_b_n,est_IMU_bias,...
            P_matrix] = LC_KF_NED(GNSS_r_eb_n,GNSS_v_eb_n,tor_s,est_L_b,...
            est_lambda_b,est_h_b,est_v_eb_n,est_C_b_n,est_IMU_bias,...
            P_matrix,meas_f_ib_b,meas_omega_ib_b,LC_KF_config,lGBB);
    end
    %--------------------------------------------------------------------------
    % Generate KF uncertainty output record
    %         SD_est(GPS_k,1) = Time;
    %         for i =1:15
    %             SD_est(GPS_k,i+1) = sqrt(Cov_est(i,i));
    %         end
    %%=========================================================================
    % Generate output profile record
    out_profile(epoch,1) = time;
    out_profile(epoch,2) = est_L_b;
    out_profile(epoch,3) = est_lambda_b;
    out_profile(epoch,4) = est_h_b;
    out_profile(epoch,5:7) = est_v_eb_n';
    out_profile(epoch,8:10) = CTM_to_Euler(est_C_b_n')';

    % Reset old values
    old_est_L_b = est_L_b;
    old_est_lambda_b = est_lambda_b;
    old_est_h_b = est_h_b;
    old_est_v_eb_n = est_v_eb_n;
    old_est_C_b_n = est_C_b_n;

    %% ========================================================================
    % Determine errors and generate output record
    true_L_b = in_profile(epoch,2);
    true_lambda_b = in_profile(epoch,3);
    true_h_b = in_profile(epoch,4);
    true_v_eb_n = in_profile(epoch,5:7)';
    true_eul_nb = in_profile(epoch,8:10)';
    true_C_b_n = Euler_to_CTM(true_eul_nb)';

    [delta_r_eb_n,delta_v_eb_n,delta_eul_nb_n] = Calculate_errors_NED(...
        est_L_b,est_lambda_b,est_h_b,est_v_eb_n,est_C_b_n,true_L_b,...
        true_lambda_b,true_h_b,true_v_eb_n,true_C_b_n);

    old_time = time;
    old_true_L_b = true_L_b;
    old_true_lambda_b = true_lambda_b;
    old_true_h_b = true_h_b;
    old_true_v_eb_n = true_v_eb_n;
    old_true_C_b_n = true_C_b_n;

    out_errors(epoch,1) = time;
    out_errors(epoch,2:4) = delta_r_eb_n';
    out_errors(epoch,5:7) = delta_v_eb_n';
    out_errors(epoch,8:10) = delta_eul_nb_n';
end %epoch
% Complete progress bar
fprintf(strcat(rewind,bars,'\n'));
choice = menu('Do you want save data','Yes', 'No');
if choice == 1
    saving_data_time(Train_data);
    saving_csv_data_time(Train_data);
end

% Plot the input motion profile and the errors (may not work in Octave).
close all;
Plot_profile(in_profile);
Plot_errors(out_errors);
Plot_Trajectory;
