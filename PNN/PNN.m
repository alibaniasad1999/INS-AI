clc
clear
%% load data %%
load('../data_created/04-May-2023-14-19-45-INS_GPS_function.mat');
load('../GPS_INS/IMU_meas_1000sec_otto', 'in_profile');

%% prepare data %%
x_train = data;
y_train = in_profile(2:end, 2:end);
%% make nn %%

layers = [
featureInputLayer(9)
fullyConnectedLayer(32)
sigmoidLayer
fullyConnectedLayer(32)
tanhLayer
fullyConnectedLayer(32)
reluLayer
fullyConnectedLayer(9)
regressionLayer
];

options = trainingOptions('adam', ...
    'Verbose',false, ...
    'Plots','training-progress', ...
    'Shuffle','every-epoch', ...
    'MaxEpochs', 300, ...
    'InitialLearnRate',1e-3, ...
    'GradientThresholdMethod','absolute-value', ...
    'ExecutionEnvironment','cpu', ...
    'GradientThreshold',1, ...
    'Epsilon',1e-8);

%% tarin %%
INS_GNSS_NN = trainNetwork(x_train, y_train,layers,options);

%% save nn %%
now_time = string(datetime('now'));
str_now_time = now_time{1};
str_now_time(12) = '-';
str_now_time(15) = '-';
str_now_time(18) = '-';
save(append(str_now_time, '-', 'INS_GNSS_NN'), 'INS_GNSS_NN');