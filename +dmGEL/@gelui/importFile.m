function importFile(obj)
disp('File -> Import Image -> From file');

doProceed = obj.checkSaveSession;
if ~ doProceed
    return
end

% Define the filter options
filters = {'*.tiff;*.tif;*.jpg;*.jpeg;*.png;*.bmp', 'Image Files (*.tiff, *.tif, *.jpg, *.jpeg, *.png, *.bmp)'; ...
           '*.*', 'All Files (*.*)'};

% Open the file selection dialog
[fileName, filePath] = uigetfile(filters, 'Select an Image File');

% Check if the user made a selection
if isequal(fileName, 0)
    disp('User canceled the file selection.');
    return
else
    % add try-catch block !!!
    selectedFile = fullfile(filePath, fileName);
    I = imread(selectedFile);
    obj.importImg(I, fileName, selectedFile);
    %
    disp(['User selected: ', selectedFile]);
end

end