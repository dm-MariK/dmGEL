function doProceed = checkSaveSession(obj)
doProceed = false;
if obj.GelDataObj.IsSaved
    doProceed = true;
    return
else
    % Create the modal dialog with 'Yes', 'No', and 'Cancel' choices
    prompt = {...
        'The Session contains unsaved data.', ...
        'Would you like to save this session before continue?', ...
        '(Press "Cancel" if you do not want to proceed.)'}; % 'Do you want to proceed?'
    header = 'Save Session and proceed?';
    choice = questdlg(prompt, header, ...
        'Save', 'Do Not Save', 'Cancel', 'Cancel');
    
    % Handle the user's choice
    switch choice
        case 'Save'
            disp('User selected "Save"');
            doProceed = obj.saveSession;
        case 'Do Not Save'
            disp('User selected "Do Not Save"');
            doProceed = true;
            disp(' ++ gelui : checkSaveSession : doProceed:');
            disp(doProceed)
        case 'Cancel'
            disp('User selected "Cancel"');
            doProceed = false;
    end
end
end