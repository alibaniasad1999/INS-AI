%% AI error calculator %%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PNN model %%
PNN = importTensorFlowNetwork('../PNN/PNN_model');
%% LSTM model %%
LSTM = importTensorFlowNetwork('../LSTM/LSTM_NN_model');
%% LSTM error model %%
LSTM_error = importTensorFlowNetwork('../LSTM/LSTM_error_NN_model');
%% load data %%
load('IMU_meas_1000sec_otto.mat', 'in_profile');
load('../data_created/04-May-2023-14-19-45-INS_GPS_function')
%% predict data %%
x_train = data;
y_train = in_profile(2:end, 2:end);
y_test_PNN = predict(PNN, x_train);
y_test_LSTM = predict(LSTM, x_train);
y_test_LSTM_error = predict(LSTM_error, x_train) + x_train;

error_PNN = zeros(length(data), 10);
error_LSTM = zeros(length(data), 10);
error_LSTM_error = zeros(length(data), 10);
for i = 1:length(data)
    true_L_b = in_profile(i+1,2);
    true_lambda_b = in_profile(i+1,3);
    true_h_b = in_profile(i+1,4);
    true_v_eb_n = in_profile(i+1,5:7)';
    true_eul_nb = in_profile(i+1,8:10)';
    true_C_b_n = Euler_to_CTM(true_eul_nb)';

    [delta_r_eb_n,delta_v_eb_n,delta_eul_nb_n] = Calculate_errors_NED(...
        y_test_PNN(i, 1),y_test_PNN(i, 2),y_test_PNN(i, 3),y_test_PNN(i, 4:6)',...
        Euler_to_CTM(y_test_PNN(7:9)'),true_L_b,...
        true_lambda_b,true_h_b,true_v_eb_n,true_C_b_n);

    error_PNN(i,1) = in_profile(i, 1);
    error_PNN(i,2:4) = delta_r_eb_n';
    error_PNN(i,5:7) = delta_v_eb_n';
    error_PNN(i,8:10) = delta_eul_nb_n';

    [delta_r_eb_n,delta_v_eb_n,delta_eul_nb_n] = Calculate_errors_NED(...
    y_test_LSTM(i, 1),y_test_LSTM(i, 2),y_test_LSTM(i, 3),y_test_LSTM(i, 4:6)',...
    Euler_to_CTM(y_test_LSTM(7:9)'),true_L_b,...
    true_lambda_b,true_h_b,true_v_eb_n,true_C_b_n);

    error_LSTM(i,1) = in_profile(i, 1);
    error_LSTM(i,2:4) = delta_r_eb_n';
    error_LSTM(i,5:7) = delta_v_eb_n';
    error_LSTM(i,8:10) = delta_eul_nb_n';

        [delta_r_eb_n,delta_v_eb_n,delta_eul_nb_n] = Calculate_errors_NED(...
    y_test_LSTM_error(i, 1),y_test_LSTM_error(i, 2),y_test_LSTM_error(i, 3),y_test_LSTM_error(i, 4:6)',...
    Euler_to_CTM(y_test_LSTM_error(7:9)'),true_L_b,...
    true_lambda_b,true_h_b,true_v_eb_n,true_C_b_n);

    error_LSTM_error(i,1) = in_profile(i, 1);
    error_LSTM_error(i,2:4) = delta_r_eb_n';
    error_LSTM_error(i,5:7) = delta_v_eb_n';
    error_LSTM_error(i,8:10) = delta_eul_nb_n';
end


