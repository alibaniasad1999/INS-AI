estimate_data = x_train;
saving_csv_data_time(estimate_data, 'estimate_data');
true_data = in_profile(1:100000, 2:end);
saving_csv_data_time(true_data, 'true_data')
imu_train = IMU_meas(1:100000, 2:end);
saving_csv_data_time(imu_train, 'imu_train')