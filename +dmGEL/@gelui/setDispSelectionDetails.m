function setDispSelectionDetails(obj, src, ~)
% Callback for: 'View -> Calculation Details -> Selection details'

if strcmpi(get(src, 'Checked'), 'on')
    set(src, 'Checked', 'off');
    obj.DispSelectionDetails = false;
else
    set(src, 'Checked', 'on')
    obj.DispSelectionDetails = true;
end
end