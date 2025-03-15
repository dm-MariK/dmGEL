function setCheckedUimenus(obj)
% Update checked / unchecked status of uimenus.

% Whether to collect acquired gel intensity data to a file:
if obj.GelDataObj.CollectDataToFile
    set(obj.hFileCollectDataTo, 'Checked', 'on');
else
    set(obj.hFileCollectDataTo, 'Checked', 'off');
end

% Whether to Display Calculation Details:
if obj.GelDataObj.DispCalcDetails
    set(obj.hViewCalcDetails, 'Checked', 'on');
else
    set(obj.hViewCalcDetails, 'Checked', 'off');
end
end