function importImg(obj, I, name, fullPath)
% * Accept image to import as I input var.
% * Call obj.GelDataObj.importImg(I) to import the image.
% * Use fullPath input var to set obj.GelDataObj.OriginalImgFilePath.
% * Use name input var to construct the Session name (sessionName). 
%   Get current date and time and concatenate them with the name passed. <-
% * Set Session name (obj.GelDataObj.SessionName property).
% * Update obj.hFig 'Name' with the Session Name constructed.
% * * Delete existing axtoolbar since it will be 'shadowed' by imshow
% * ** Preserve selection poligons of obj.GelDataObj (HroiArr) if exist **
% * ***Display obj.GelDataObj.GrayScaledImg on obj.hAxes by imshow***
% * ** Reconstruct the selection poligons of obj.GelDataObj (HroiArr)**
% * *Re-create the axtoolbar
% * update View selection, select 'GrayScaled' (set it checked).
% * toggle Bottom Panel to its 'normal' (ValueTxtString) mode.

obj.GelDataObj.importImg(I)
obj.GelDataObj.OriginalImgFilePath = fullPath;

% Set Session name - STUB! - append current date and time!
sessionName = ['dmGEL: ', name];
% -----------------
obj.GelDataObj.SessionName = sessionName;
set(obj.hFig, 'Name', sessionName);

% * Display GrayScaled Image on the axes:
% First delete existing axtoolbar since it will be 'shadowed' by imshow
delete(obj.hAxTB);

% Preserve selection poligons of obj.GelDataObj (HroiArr) if they exist
% (due to `imshow` deletes them on the Axes)
if ~isempty(obj.GelDataObj.HroiArr)
    for k = 1:length(obj.GelDataObj.HroiArr)
        roiData(k) = obj.GelDataObj.HroiArr(k).getSavedData;
    end
    % Delete the poligons explicitly and prepare a place-holder
    delete(obj.GelDataObj.HroiArr);
    obj.GelDataObj.HroiArr = dmGEL.roiPolygon.empty;
else
    roiData = struct([]);
end

% Find and delete any existing image objects in hAxes 
% (Here use findobj to find the image object(s) among the children of the
% axes)
existingImages = findobj(obj.hAxes, 'Type', 'image');
delete(existingImages);

% Use imshow to display GrayScaled Image on the axes
%h_img = imshow(obj.GelDataObj.GrayScaledImg, 'Parent', obj.hAxes);
imshow(obj.GelDataObj.GrayScaledImg, 'Parent', obj.hAxes);

% Reconstruct the selection poligons
if ~isempty(roiData)
    for k = 1:length(roiData)
        position = roiData(k).Position;
        color = roiData(k).Color;
        obj.GelDataObj.HroiArr(k) = dmGEL.roiPolygon(obj, position, color);
    end
end

% Fix order of hAxes Children. h_img must always be at the bottom;
% otherwise roiPoly selections will be non-visible (shadowed by h_img).
% axesChildren = get(obj.hAxes, 'Children');
% nonImgIdx = ~ismember(axesChildren, h_img);
% nonImgAxesChildren = axesChildren(nonImgIdx);
% axesChildren = [nonImgAxesChildren', h_img];
% set(obj.hAxes, 'Children', axesChildren);
% ^<--- This is not required, since we delete and then reconstruct roiPoly
% selections after the `imshow` call.

% Re-create the axtoolbar
obj.hAxTB = axtoolbar(obj.hAxes, {'pan', 'zoomin', 'zoomout', 'restoreview'});

% update View selection, select 'GrayScaled' (set it checked)
obj.updateViewUImenu;
menuItems = obj.ViewModeItems;
for i = 1:length(menuItems)
    set(menuItems{i}, 'Checked', 'off');
end
set(obj.hGrayScaled, 'Checked', 'on');

% toggle Bottom Panel to its 'normal' (ValueTxtString) mode
obj.toggleBotPan;
end