function revTFInput = iPermuteToReverseTF(fwdTFInput, rank)
% Permutes the data from forward to reverse TensorFlow format

%   Copyright 2023 The MathWorks, Inc.

    if isdlarray(fwdTFInput) && rank >= 2    
        inputLabels = fwdTFInput.dims;
        % Only perform permute if the input data is all U-labeled
        if all(inputLabels == 'U')
            revTFInput = dlarray(permute(extractdata(fwdTFInput), rank:-1:1), repmat('U', [1 rank]));
        else 
            revTFInput = fwdTFInput;
        end
    else
        revTFInput = fwdTFInput;
    end
end