%% function to train online in performing %%
function new_model = online_traning(model, data)
    %% data ---> IMU(n, 6) + INS(n, 9)
    imu = data.imu;
    ins = data.ins;

    %% make data for trainig %%
    %% x ---> 10 sequnetial data if imu %%
    %% y ---> ins data for time t -10(steptime) %%
    imuSize = size(imu, 1);
    x_1 = zeros(imuSize - 10, 10, 6);  % Preallocate x with a constant size
    x_2 = zeros(imuSize-10, 9);
    y = zeros(imuSize - 10, 9);  % Preallocate y with a constant size
    
    for i = 1 + 10 : imuSize
        x_1(i-10, :, :) = imu(i - 10: i, :);
        x_2(i-10, :) = ins(i - 10, :);
        y(i, :) = ins(i, :);
    end
    
    %% train model options %%
    options = trainingOptions('adam', ...
        'MaxEpochs', 10, ...
        'MiniBatchSize', 100, ...
        'InitialLearnRate', 0.001, ...
        'LearnRateSchedule', 'piecewise', ...
        'LearnRateDropFactor', 0.1, ...
        'LearnRateDropPeriod', 10, ...
        'Shuffle', 'every-epoch', ...
        'Verbose', false, ...
        'Plots', 'training-progress');
    
    % train model %
    new_model = trainNetwork({x_1, x_2}, y, model.Layers, options);
end
