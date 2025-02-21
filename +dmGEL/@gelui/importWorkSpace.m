function importWorkSpace(obj)
disp('File -> Import Image -> From Workspace');

doProceed = obj.checkSaveSession;
if ~ doProceed
    return
end


% Get the list of variables from the base workspace
vars = evalin('base', 'who');

% Create a selection dialog
[selectedIndex, ok] = listdlg('Name','Select a WorkSpace variable', ...
    'PromptString', 'Select a WorkSpace variable to import:', ...
    'SelectionMode', 'single', ...
    'ListString', vars);

% Check if the user made a selection
if ok
    % Retrieve the names of the selected variables
    selectedVar = vars{selectedIndex};
    I = evalin('base', selectedVar); % varValue
    name = ['-WSvar-',selectedVar];
    fullPath = ['< WorkSpace variable: ', selectedVar, ' >'];
    % Display the variable name and value (or process as needed) -DEBUG-
    disp(['Variable: ' selectedVar]);
    %disp(I);
    
    obj.importImg(I, name, fullPath);
else
    disp('No variables selected.');
    return
end
end