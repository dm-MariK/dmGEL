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
obj.DispSelectionDetails = false; % SelectionDetails
obj.DispImgIntProfiles = false; % Image Intensity Profiles
% ... and update corresponding uis:
set(obj.hFileCollectDataTo, 'Checked', 'off'); % REQUIRED SYNCRONIZATION !!! !!!
set(obj.hViewSelectionDetails, 'Checked', 'off'); % TO BE MODIFIED !!! !!! !!!
set(obj.hViewImgIntProfiles, 'Checked', 'off');%    TO BE MODIFIED !!! !!! !!!
% switch Bottom Panel to its 'normal' mode
obj.toggleBotPan;
end
