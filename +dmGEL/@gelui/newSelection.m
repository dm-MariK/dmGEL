function newSelection(obj)
disp('New Selection!')

%obj.GelDataObj = dmGEL.gelData(obj);
%hPoly_01 = dmGEL.roiPolygon(hUI.hAxes);
%obj = roiPolygon(geluiObj, position, color)
hPoly = dmGEL.roiPolygon(obj);
if ~isempty(hPoly)
    obj.GelDataObj.HroiArr(end+1) = hPoly;
end