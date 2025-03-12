function dispCalcDetails(obj, selectionMask)
% ...
if isempty(obj.HimprofPlotUI)
    obj.HimprofPlotUI = dmGEL.improfPlotUI(obj, selectionMask);
else
    if isvalid(obj.HimprofPlotUI)
        obj.HimprofPlotUI.updateData(obj.GelDataObj, selectionMask);
    else
        obj.HimprofPlotUI = [];
        obj.HimprofPlotUI = dmGEL.improfPlotUI(obj, selectionMask);
    end
end
end