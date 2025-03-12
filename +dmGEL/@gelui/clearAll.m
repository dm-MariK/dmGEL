function clearAll(obj)
delete(obj.GelDataObj);
obj.GelDataObj = dmGEL.gelData(obj);
obj.updateViewUImenu;
axesChildren = get(obj.hAxes, 'Children');
delete(axesChildren);
set(obj.hFig, 'Name', obj.F_Name);

% clear session settings (Workflow variables) stored inside gelui obj:
%obj.CollectDataToFile = false; % <--- Moved to dmGEL.gelData
%obj.FileToCollectDataTo = '';  % <--- Moved to dmGEL.gelData
%obj.DispSelectionDetails = false; % SelectionDetails       % <--- removed
%obj.DispImgIntProfiles = false; % Image Intensity Profiles % <--- removed
% ... and update corresponding uis:
set(obj.hFileCollectDataTo, 'Checked', 'off'); % REQUIRED SYNCRONIZATION !!! !!!
set(obj.hViewCalcDetails, 'Checked', 'off'); % Or may be not. dmGEL.gelData initializes both as false
%set(obj.hViewSelectionDetails, 'Checked', 'off'); % REMOVED
%set(obj.hViewImgIntProfiles, 'Checked', 'off');%    REMOVED
% switch Bottom Panel to its 'normal' mode
obj.toggleBotPan;
end
