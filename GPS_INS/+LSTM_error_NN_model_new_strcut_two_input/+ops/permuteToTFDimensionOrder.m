function [varargout] = permuteToTFDimensionOrder(varargin)
% Copyright 2023 The MathWorks, Inc.
% PERMUTETOTFDIMENSIONORDER This function permutes placeholder function inputs to forward TF Dimension order
varargout = cell(1, nargin);
for i=1:nargin
    x = varargin{i};
    if isstruct(x)
        % input is a struct with 'value' and 'rank' fields.
        xstruct = permuteOneInputToFwdTFDimensionOrder(x.value, x.rank);
        varargout{i} = xstruct;
    else
        % return the value unchanged;
        varargout{i} = x;
    end
end
end

function xstruct = permuteOneInputToFwdTFDimensionOrder(xval, xrank)
import LSTM_error_NN_model_new_strcut_two_input.ops.*;
isXDLTFormat = isa(xval, 'dlarray') && ~isempty(xval.dims) && ~all(xval.dims == 'U') && xrank > 1;
if isXDLTFormat
    % input is a labeled dlarray
    [xPermutationVec, ~] = sortToTFLabel(1:xrank, xval.dims);
    xval = stripdims(xval);
    xval = permute(xval, xPermutationVec);
elseif isa(xval, 'dlarray')
    % with all U dimensions or no dimension labels, already in reverse TF format
    xval = stripdims(xval);
    xval = permute(xval, xrank:-1:1);
else
    % numeric array, already in reverse TF format
    xval = permute(xval, xrank:-1:1);
end
xstruct.value = xval;
xstruct.rank = xrank;
end