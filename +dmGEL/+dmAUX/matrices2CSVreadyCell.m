function combinedDataCell = matrices2CSVreadyCell(varargin)
%COMBO_CELL = matrices2CSVreadyCell(A, B, C, D, ...)
% Combine any number of input matrices A, B, C, D, ... and so on into one
% single cell array. The matrices will be placed side by side (concatenated
% horizontally) so that the number of rows in the combined cell array is
% the maximum among all matrices, and the total number of columns is the
% sum of columns of all matrices. 
% The matrices may be numeric, strings, or characters. All the matrices'
% elements will be written to the corresponding cells of the cell array 
% 'as is', i.e. without conversion.
% The resulting cell array is redy to be exported as a single CSV-file
% by using, for example, `writecell` (introduced in MATLAB R2019a) or 
% [with some additional "magic"] `writetable` (introduced in MATLAB
% R2013b).

if isempty(varargin)
    combinedDataCell = {};
    return
end

%% Determine Combined Dimensions
numMatrices = length(varargin);
maxRows = 0;
totalCols = 0;
for i = 1:numMatrices
    [r, c] = size(varargin{i});
    maxRows = max(maxRows, r);
    totalCols = totalCols + c;
end
    
%% Build the Combined Cell Array
% Initialize a cell array of size (maxRows x totalCols) with empty strings.
combinedDataCell = repmat({''}, maxRows, totalCols);

% Use a column offset to know where each matrix should go.
colOffset = 0;

for i = 1:numMatrices
    currentMatrix = varargin{i};
    [r, c] = size(currentMatrix);
    
    % Copy the current matrix into the correct position in combinedData.
    for row = 1:r
        for col = 1:c
            % Place element from currentMatrix at the proper column offset.
            combinedDataCell{row, colOffset + col} = currentMatrix(row, col);
        end
    end
    
    % Update the column offset by the number of columns in the current matrix.
    colOffset = colOffset + c;
end
end