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
    
    for i = 10 : imuSize
        x_1(i-9, :, :) = imu(i - 9: i, :);
        x_2(i-9, :) = ins(i - 9, :);
        y(i-9, :) = ins(i-9, :);
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
    dlX1 = dlarray(reshape(x_1, [length(x_1), 6, 10]), 'CBT');
    dlX2 = dlarray(reshape(x_2, [length(x_2)  1  9]), 'CBT');
    new_model = trainNetwork({x_1, x_2}, y, model.Layers, options);
end
