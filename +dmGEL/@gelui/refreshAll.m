function refreshAll(obj)

% First delete existing axtoolbar since it will be 'shadowed' by imshow.
delete(obj.hAxTB);

% Clear axes.
axesChildren = get(obj.hAxes, 'Children');
delete(axesChildren);

% Update figure's name.
set(obj.hFig, 'Name', obj.GelDataObj.SessionName);

% Update checkable uimenus' items check-status.
obj.setCheckedUimenus;
obj.updateViewUImenu;

% Switch Bottom Panel to its 'normal' mode.
obj.toggleBotPan;

% Find, display and select in View menu the most processed gel Image.
if ~isempty(obj.GelDataObj.BGCorrectedImg) 
    set(obj.hBGCorrected, 'Checked', 'on');
    imshow(obj.GelDataObj.BGCorrectedImg, 'Parent', obj.hAxes);

elseif ~isempty(obj.GelDataObj.FilteredImg)
    set(obj.hFiltered, 'Checked', 'on');
    imshow(obj.GelDataObj.FilteredImg, 'Parent', obj.hAxes);

elseif ~isempty(obj.GelDataObj.GrayScaledImg)
    set(obj.hGrayScaled, 'Checked', 'on');
    imshow(obj.GelDataObj.GrayScaledImg, 'Parent', obj.hAxes);

elseif ~isempty(obj.GelDataObj.OriginalImg)
    set(obj.hOriginal, 'Checked', 'on');
    imshow(obj.GelDataObj.OriginalImg, 'Parent', obj.hAxes);
end

% Re-create the axtoolbar.
obj.hAxTB = axtoolbar(obj.hAxes, {'pan', 'zoomin', 'zoomout', 'restoreview'});
end