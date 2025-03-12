function setDispCalcDetails(obj, src, ~)
% Callback for: 'View -> Calculation Details'

if strcmpi(get(src, 'Checked'), 'on')
    set(src, 'Checked', 'off');
    obj.GelDataObj.DispCalcDetails = false;
else
    set(src, 'Checked', 'on')
    obj.GelDataObj.DispCalcDetails = true;
end
end
