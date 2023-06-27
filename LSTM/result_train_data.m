%% test data %%
% Assuming x_train is a matrix
x_train = readmatrix('../data_created/04-May-2023-14-19-45-INS_GPS_function.csv');
y = readmatrix('../GPS_INS/IMU_meas_1000sec_otto.csv');
% Selecting the columns from index 9 onwards (column 8 in MATLAB)
selected_columns = x_train(:, 9:end);

% Finding the indices where the values in column 9 are less than 0
negative_indices = x_train(:, 9) < 0;

% Adding 2*pi to the selected columns where column 9 is less than 0
selected_columns(negative_indices, :) = selected_columns(negative_indices, :)...
    + 2*pi;

% Updating the original matrix with the modified selected columns
x_train(:, 9:end) = selected_columns;

y_train = y(2:end, 5:7) - x_train(:, 4:6);

LSTM_error = importTensorFlowNetwork('LSTM_error_NN_model_v2_3_out');

y_pred = predict(LSTM_error, x_train);

y_pred = y_pred + x_train(:, 4:6);


set(gca, 'FontSize', 16)
plot(y(2:end, 1), y_pred...
    , 'LineWidth', 2);
hold on
plot(y(2:end, 1), y(2:end, 5:7)...
    , '--', 'LineWidth', 2);
legend('V_x predict', 'V_y predict', 'V_z predict', 'V_x true', ...
    'V_y true', 'V_z true');
xlabel('Time(sec)', 'interpreter', 'latex', 'FontSize', 24);
ylabel('Velocity(m/s)', 'interpreter', 'latex', 'FontSize', 24);
axis tight
set(gca, 'FontSize', 16, 'FontName', 'Times New Roman');


print('train', '-depsc');
