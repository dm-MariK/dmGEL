function cellArrayToCSV(cellArray, filename, numPrecFmt, isComplexSrings, appendMode)
%cellArrayToCSV(cellArray, filename, numPrecFmt, isComplexSrings, appendMode)
% Write r-by-c cell array 'cellArray' to the 'filename' output file so that
% the file will be r-by-c CSV.
% Data Types: The function checks whether each element in the cell array is
% numeric, string or character arra. Elements of any other types are
% unsupported and be replaced wiht empty strings in the output file.
% Additional arguments:
% * numPrecFmt - the 2-nd arg for `num2str` convertor. It could be either
% 'precision' or 'formatSpec'. Consult `num2str` documentation for details.
% * isComplexSrings - true or false. Whether to treat cell elements of char
% and string type as so-called "comlex strings", i.e. strings that include
% commas, double quotes, semicolons or newlines themselves. Such strings
% must be wrapped in double quotes before being written to the file to
% conform with CSV standards. If such strings contain double quotes
% themselves, these double-quotes character must be doubled. By default the
% fuction expects the strings to be "comlex", i.e. isComplexSrings is true.
% If You sure that all strings and character arrays are "simple", i.e.
% single words, or couples of words with digits and white-spaces, You can
% pass isComplexSrings as false (to simplify the look of your CSV file).
% * appendMode - true or false. Defines whether the output file is being
% opened in write ('w'), or append mode ('a'). Default mode is 'w'. Pass
% appendMode as true to use 'a' mode.
%
% Why we need this function?
% 1) `writecell` was introduced in MATLAB R2019a. But we need the backward
% compatibility for earlier MATLAB versions.
% 2) While `writetable` was introduced in MATLAB R2013b, it is not flexible
% enough. For example, it could not handle multiline headers and have some
% compatibility issues if the cell array consists of different data types.

file_mode = 'w'; % file openning mode: write ('w'), or append mode ('a')
if nargin >= 5 && appendMode == true
    file_mode = 'a';
end
if nargin < 4
    isComplexSrings = true;
end
if nargin < 3
    numPrecFmt = [];
end

% Open the file to write data to.
fid = fopen(filename, file_mode);
if fid == -1
    error('Cannot open file: %s', filename);
end

% Iterate through each cell array's row, inside each row - 
% Iterate through each column in the row.
[rows, cols] = size(cellArray);
for r = 1:rows
    for c = 1:cols
        element = cellArray{r,c};
        if isnumeric(element) % process numeric elements
            if isempty(numPrecFmt)
                elementStr = num2str(element);
            else
                elementStr = num2str(element, numPrecFmt);
            end

        elseif isstring(element) % process strings and character arrays 
            elementStr = char(element);
            elementStr = processComplexSrings(elementStr);
        elseif ischar(element)
            elementStr = processComplexSrings(element);

        else % replace elements of non-supported types by empty strings
            elementStr = '';
        end

        % Write the element-string to the file, 
        % add a comma after every element except the last in the row.
        if c < cols
            fprintf(fid, '%s,', elementStr);
        else
            fprintf(fid, '%s', elementStr);
        end
    end

    % End the row with a newline in MS-DOS format (CR + LF):
    % char(13) is carriage return (CR); char(10) is line feed (LF).
    %fprintf(fid, '\n');
    fprintf(fid, [char(13), char(10)]);
end

% Close the file after writing.
fclose(fid);

%% Complex Srings processor-fcn:
    function out_str = processComplexSrings(in_str)
        if ~isComplexSrings
            out_str = in_str;
            return
        end
        out_str = '';
        for k = 1:length(in_str)
            out_str = [out_str, in_str(k)];
            if in_str(k) == '"' % double quotes must be doubled
                out_str = [out_str, '"'];
            end
        end
        % the output string must be enclosed (wrapped) in double quotes
        out_str = ['"', out_str, '"'];
    end
end
