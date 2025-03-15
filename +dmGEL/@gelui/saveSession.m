function doProceed = saveSession(obj)
% Realize file-save-dlg and call saveobj() method of gelData object.

disp('File -> Save Session')

doProceed = false;

% Define the filter and dlg header
filters = {'*.dmgel.mat', 'dmGEL Saved Session Mat-Files (*.dmgel.mat)'; ...
    '*.mat', 'MATLAB Mat-Files (*.mat)'
    '*.*', 'All Files (*.*)'};
header = 'Select a file to save this session to';
% Open the file selection dialog
[fname, fpath] = uiputfile(filters, header);

% Try to save
if isequal(fname, 0)
    disp('User canceled saving session.');
    return
else
    selectedFile = fullfile(fpath, fname);
    %
    disp(['User will save session to: ', selectedFile]);
    %
    try
        s = obj.GelDataObj.saveobj;
        save(selectedFile, '-struct', 's', '-mat');
        obj.GelDataObj.setSaved;
        doProceed = true;
    catch ME
        msg = sprintf('Can not save Session to the file: \n%s\n%s', ...
            selectedFile, ME.message);
        errordlg(msg, 'Can not save Session to the file', 'modal');
    end
end
end