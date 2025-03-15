function loadSession(obj)
disp('File -> Load Session')

doProceed = obj.checkSaveSession;
if ~ doProceed
    return
end

% Define the filter options
filters = {'*.dmgel.mat', 'dmGEL Saved Session Mat-Files (*.dmgel.mat)'; ...
    '*.mat', 'MATLAB Mat-Files (*.mat)'
    '*.*', 'All Files (*.*)'};
% Open the file selection dialog
[fileName, filePath] = uigetfile(filters, 'Select a File');

% Check if the user made a selection
if isequal(fileName, 0)
    disp('User canceled the file selection.');
    return
else
    selectedFile = fullfile(filePath, fileName);
    %
    disp(['User selected: ', selectedFile]);
    %
    try
        s = load(selectedFile, '-mat');
        obj.GelDataObj.loadSavedData(s);
    catch ME
        msg = sprintf('Can not load Session from the file: \n%s\n%s', ...
            selectedFile, ME.message);
        errordlg(msg, 'Can not load Session from the file', 'modal');
    end
end

end
% >> save('data_struct.mat', '-struct', 's');
% >> loaded_s = load('data_struct.mat')
% >> isequal(s, loaded_s)
%    ans =  <logical>  1
%
% S = load(FILENAME, '-mat', VARIABLES) % forces to treat as a MAT-file
% save(FILENAME, ..., FORMAT) saves in the specified format: '-mat' or ...
% Alternatively, use command syntax for the save operation.
% save pqfile.txt p q -ascii