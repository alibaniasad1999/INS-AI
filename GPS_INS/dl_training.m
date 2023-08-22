%% use train data function to train 
x_1 = dlarray(ones([6   1  10]), 'CBT');
x_2 = dlarray(ones([1   1  9]), 'CBT');

y = categorical([1 0 1 0 1 0 1 0 1 0]);

% net = importTensorFlowNetwork('../LSTM/LSTM_error_NN_model_new_strcut_two_input');
data.imu = x_1;
data.ins = x_2;
data.y = y;
train_network_custom(LSTM_error, data, 10);


















%% custom training for dl network %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function train_network_custom(net, data, numEpochs)
    x_1_train = data.imu;
    x_2_train = data.ins;
    y_train = data.y;

    epoch = 0;
    iteration = 0;
    
    while epoch < numEpochs
        epoch = epoch + 1;
        iteration = iteration + 1;
        fprintf('Epoch %d/%d\n', epoch, numEpochs);

        % x_1 and x_2 ----> [6   1  10]), 'CBT', [1  1  9]), 'CBT'
        [x_1_train, x_2_train, y_train] = shuffle_data(x_1_train, x_2_train, y_train);
        miniBatchSize = 32;
        numObservations = size(x_1_train, 4);
        numIterationsPerEpoch = floor(numObservations / miniBatchSize);
        iteration = 0;
        for i = 1:miniBatchSize:numObservations
            iteration = iteration + 1;
            idx = i:i+miniBatchSize-1;
            idx = idx(idx <= numObservations);
            numImages = numel(idx);
            if (numImages == 0)
                break;
            end
            % Extract mini-batch of data.
            x_1 = x_1_train(:,:,:,idx);
            x_2 = x_2_train(:,:,:,idx);
            y = y_train(idx);
            % Convert mini-batch of data to dlarray.
            dlx_1 = dlarray(single(x_1),'SSCB');
            dlx_2 = dlarray(single(x_2),'SSCB');
            dly = categorical(y);
            % If training on a GPU, then convert data to gpuArray.
            if (isa(net,'dlnetwork'))
                dlx_1 = gpuArray(dlx_1);
                dlx_2 = gpuArray(dlx_2);
            end
            % Evaluate the model gradients and loss using dlfeval and the
            % modelGradients function listed at the end of the example.
            [gradients,loss] = dlfeval(@modelGradients, net, dlx_1, dlx_2, dly);
            % Update the network parameters using the SGDM optimizer.
            net.State = adamupdate(net.State, gradients, ...
                'LearnRateSchedule', 1e-3, ...
                'Iteration', iteration, ...
                'GradientDecayFactor', 0.9, ...
                'SquaredGradientDecayFactor', 0.999, ...
                'Epsilon', 1e-8);
            % Display the training progress.
            if (rem(iteration,5) == 0)
                fprintf('Epoch: %d, Iteration: %d, Loss: %f\n', epoch, iteration, gather(extractdata(loss)));
            end
        end
    end
end