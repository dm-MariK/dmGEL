function cellStr = dmCellArrayToString(cellArray)
%cellStr = dmCellArrayToString(cellArray)
% < some info >

% Convert each cell array element to a string representation:
strArray = cellfun(@(x) elemToString(x), cellArray, 'UniformOutput', false);

% Concatenate the elements into a single string with 'comma + white space'
% symbol combinations; then, apend leading and trailing curly brackets:
cellStr = strjoin(strArray, ', ');
cellStr = ['{', cellStr, '}'];
end

% ------------------------------------------------------------------------
function str = elemToString(elem)
if isnumeric(elem)
    % If the element is numeric (scalar, vector or matrix), 
    % convert it to string using mat2str:
    str = mat2str(elem);
elseif isa(elem, 'function_handle')
    % If the element is function_handle convert it to string ...
    f_str = func2str(elem);
    % ... and then ensure that the str representing this fcn begins with '@'
    if ~strcmp(f_str(1),'@')
        f_str = ['@', f_str]; 
    end
    str = f_str;
else
    % Otherwise, treat it as a text string:
    %str = elem;
    str = ['''', elem , ''''];
end
end