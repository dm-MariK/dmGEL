function clearAll(obj)

% delete existing GelDataObj, create new one instead
delete(obj.GelDataObj);
obj.GelDataObj = dmGEL.gelData(obj);

% clear axes
axesChildren = get(obj.hAxes, 'Children');
delete(axesChildren);

% update figure's name
set(obj.hFig, 'Name', obj.GelDataObj.SessionName);

% update checkable uimenus' items check-status
obj.setCheckedUimenus;
obj.updateViewUImenu;

% switch Bottom Panel to its 'normal' mode
obj.toggleBotPan;
end
