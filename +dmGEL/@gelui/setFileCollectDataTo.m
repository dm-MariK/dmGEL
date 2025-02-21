function setFileCollectDataTo(obj, src, ~)
% Callback for hFileCollectDataTo uimenu item
% * If the uimenu Item is Checket - uncheck it and set 'CollectDataToFile'
%   property to false.
% * If the uimenu Item is unChecket - call uiputfile() to select a file to
%   collect data to.
%   * If user press Cancel: 1) uncheck the menu Item; 
%                           2) set 'CollectDataToFile' property to false.
%   * If user selects a file: 1) check the menu Item;
%         2) set 'CollectDataToFile' property to true.
%         3) set 'FileToCollectDataTo' property using uiputfile()'s output.

disp('File -> Collect data to file ...');

if strcmpi(get(src, 'Checked'), 'on')
    set(src, 'Checked', 'off');
    obj.CollectDataToFile = false;
    return
else
    filter = {'*.DAT;*.dat', 'DAT-files (*.DAT,*.dat)'; ...
        '*.CSV;*.csv', 'Comma Separated Values (*.CSV,*.csv)'; ...
        '*.TXT;*.txt', 'Text files (*.TXT,*.txt)'; ...
        '*.*','All Files (*.*)'};
    header = 'Select a file (DATA WILL ALWAYS BE APPENDED TO THE END OF THE FILE!)';
    [fname, fpath] = uiputfile(filter, header, obj.FileToCollectDataTo);
    if isequal(fname, 0)
        set(src, 'Checked', 'off');
        obj.CollectDataToFile = false;
    else
        set(src, 'Checked', 'on');
        obj.CollectDataToFile = true;
        obj.FileToCollectDataTo = fullfile(fpath, fname);
    end
end
end