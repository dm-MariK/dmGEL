function markROIobj(obj, roiObj)
roiArr = obj.HroiArr;
for k = 1:length(roiArr)
    if isequal(roiArr(k), roiObj)
        roiArr(k).markSelected;
    else
        roiArr(k).markSelected(false);
    end
end
end