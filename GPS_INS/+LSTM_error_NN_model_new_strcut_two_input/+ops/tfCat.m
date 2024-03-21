function z = tfCat(axis, varargin)
import LSTM_error_NN_model_new_strcut_two_input.ops.*;

%   Copyright 2020-2022 The MathWorks, Inc.

% All input tensors should have the same rank.
allRanks = cellfun(@(x)x.rank, varargin);
if numel(unique(allRanks)) ~= 1
    error('Ranks of all input tensors should match for ConcatV2.');
end

outputRank = unique(allRanks);

if isstruct(axis)
    axis = axis.value;
end

% If axis is a dlarray extract the numeric value
if isa(axis, 'dlarray')
    axis = axis.extractdata;
end

if axis < 0
    MLAxis = mod(axis, outputRank);
else
    MLAxis = axis;
end
MLAxis = outputRank - MLAxis;
isDlarray = cellfun(@(x)isa(x.value, 'dlarray'), varargin);

if any(isDlarray)
    % if any inputs are dlarrays, all values must be cast to the same
    % type and converted to TensorFlow dimension format.
    for i = 2:numel(varargin)
        varargin{i}.value = cast(varargin{i}.value, 'like', varargin{1}.value);
    end
end

hasDLTInput = false;
outputLabel = '';

for i = 1:numel(varargin)
    xRank = varargin{i}.rank;
    varargin{i} = varargin{i}.value;
    % convert all inputs that are labeled dlarrays (except for the ones that are all-U labeled)
    % to reverse TF format
    if isa(varargin{i}, 'dlarray') && ~isempty(varargin{i}.dims) && ~all(varargin{i}.dims == 'U') && outputRank > 1
        [permutationVec, TFLabels] = sortToTFLabel(1:xRank, varargin{i}.dims);
        varargin{i} = permute(varargin{i}.stripdims, fliplr(permutationVec));
        hasDLTInput = true;
        if isempty(outputLabel)
            outputLabel = TFLabels;
        end
    end
end

% remove any empty tensors
nonEmptyTensors = {};
j = 1;
for i = 1:numel(varargin)
    if ~isempty(varargin{i})
        nonEmptyTensors{j} = varargin{i}; %#ok<AGROW>
        j = j + 1;
    end
end

% concatenate all inputs (in reverse TF format)
% as long as one of the inputs has labels the output of 'cat' will have labels.
z = cat(MLAxis, nonEmptyTensors{:});

if hasDLTInput
    % If any of the inputs were labeled dlarrays, convert the output to forward TF format
    % And apply data format labels
    z = permute(z, flip(1:outputRank));
    z = dlarray(z, outputLabel);
else
    % No DLT labels, leave the output in reverse-TF format with all U labels
    if outputRank > 1
        z = dlarray(z, repmat('U', [1 outputRank]));
    else
        z = dlarray(z, 'UU');
    end
end
z = struct('value', z, 'rank', outputRank);
end