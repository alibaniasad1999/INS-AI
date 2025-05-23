function dlA = iAddDataFormatLabels(dlAStruct)
%IADDDATAFORMATLABELS Adds data format labels to input dlarray, if it doesn't already have one

dlA = dlAStruct.value;
dlARank = dlAStruct.rank;

    if isdlarray(dlA)
        if isempty(dlA.dims) || all(dlA.dims == 'U')
            [permvec, labels] = guessLabels(dlARank);
            dlA = dlarray(permute(dlA, permvec), labels);
        end
    else
    % Numeric array
        [permvec, labels] = guessLabels(dlA,dlARank);
        dlA = dlarray(permute(dlA, permvec), labels);
    end

end

function [permvec, labels] = guessLabels(dlInRank)
    switch dlInRank
        case 4
            labels = "CSSB";
            permvec = [1 3 2 4];
        case 3
            labels = "CSS";
            permvec = [1 3 2];
        case 2
            labels = "CB";
            permvec = [1 2];
        otherwise
            error("Unable to determine data format labels for input tensor");
    end
end