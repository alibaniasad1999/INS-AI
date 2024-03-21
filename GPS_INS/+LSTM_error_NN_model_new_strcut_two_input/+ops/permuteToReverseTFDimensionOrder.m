function [varargout] = permuteToReverseTFDimensionOrder(varargin)
% Copyright 2023 The MathWorks, Inc.
% PERMUTETOREVERSETFDIMENSIONORDER This function permutes placeholder function outputs from 
% forward TF dimension order to reverse TF Dimension order 
    varargout = cell(1, nargin);
    for i=1:nargin
        x = varargin{i};
        if isstruct(x)
            % input is a struct with 'value' and 'rank' fields.    
            xstruct = permuteOneOutputToReverseTFDimensionOrder(x.value, x.rank);
            varargout{i} = xstruct;
        else            
            % return the value unchanged;
            varargout{i} = x;
        end
    end    
end

function xstruct = permuteOneOutputToReverseTFDimensionOrder(xval, xrank)
    isXDLTFormat = isa(xval, 'dlarray') && ~isempty(xval.dims) && ~all(xval.dims == 'U') && xrank > 1; 
    if ~isXDLTFormat       
        % if output has all U dimensions or no dimension labels or a numeric array, assume it is in forward TF format
        % and flip it to reverse TF format and add U labels
        xval = permute(xval, xrank:-1:1);
        xval = dlarray(xval, repmat('U', [1 xrank]));        
    elseif ~isXDLTFormat && xrank <= 1
        xval = dlarray(xval, 'UU');
    end
    % if output is a labelled dlarray (a dlarray method or user added labels to the dlarray)
    % leave it unchanged    
    xstruct.value = xval;
    xstruct.rank = xrank;
end