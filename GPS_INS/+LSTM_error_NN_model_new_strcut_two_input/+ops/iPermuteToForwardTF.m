function fwdTFInput = iPermuteToForwardTF(revTFInput, rank)
% Permutes the data from reverse to forward TensorFlow format order

%   Copyright 2023 The MathWorks, Inc.

    if isdlarray(revTFInput) && rank >= 2    
        inputLabels = revTFInput.dims;
        % Only perform permute if the input data is all U-labeled
        if all(inputLabels == 'U')
            fwdTFInput = dlarray(permute(extractdata(revTFInput), rank:-1:1), repmat('U', [1 rank]));
        else 
            fwdTFInput = revTFInput;
        end
    else
        fwdTFInput = revTFInput;
    end

  
end