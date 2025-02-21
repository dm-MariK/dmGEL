function toggleBotPan(obj, showPath)
if nargin < 2
    showPath = false;
end

edtBG4path = hsv2rgb([0.35, 0.7, 0.7020]);
if showPath
    set(obj.hValueTxt, 'String', obj.PathTxtString, ...
        'ForegroundColor', [1 0 0]);
    set(obj.hValueEdt, 'String', obj.GelDataObj.OriginalImgFilePath, ...
        'ForegroundColor', [1 0 0], 'BackgroundColor', edtBG4path, ...
        'FontWeight', 'bold');
else
    set(obj.hValueTxt, 'String', obj.ValueTxtString, ...
        'ForegroundColor', [0 0 0]);
    set(obj.hValueEdt, 'String', '', ...
        'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontWeight', 'normal');
end

obj.updatePanelsPosition;
end

%hValueTxt;  %  'Value:' 'text' uicontrol
%hValueEdt;  %  'Value' 'edit' uicontrol

% Allowed 'String' values of the Txt uicontrol of the Bottom Panel
%ValueTxtString = 'Value:';
%PathTxtString = 'Original Image File:';