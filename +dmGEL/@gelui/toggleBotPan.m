function toggleBotPan(obj, showPath)
if nargin < 2
    showPath = false;
end

fg_color = dmGEL.Constants.GU_BotPanShowPathBlinkFGcolor;
bg_color = dmGEL.Constants.GU_BotPanShowPathBlinkBGcolor;
fontWeight = dmGEL.Constants.GU_BotPanShowPathBlinkFontWeight;
time_out = dmGEL.Constants.GU_BotPanShowPathBlinkTime;

if showPath
    % Switch to 'showPath' mode (show original Image location).
    set(obj.hValueTxt, 'String', obj.PathTxtString, ...
        'ForegroundColor', fg_color);
    set(obj.hValueEdt, 'String', obj.GelDataObj.OriginalImgFilePath, ...
        'ForegroundColor', fg_color, 'BackgroundColor', bg_color, ...
        'FontWeight', fontWeight);
    obj.updatePanelsPosition;
    drawnow nocallbacks;
    pause(time_out);
    % ----------------------
    set(obj.hValueTxt, 'ForegroundColor', [0 0 0]);
    set(obj.hValueEdt, ...
        'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontWeight', 'normal');
    obj.updatePanelsPosition;
    drawnow;
else
    % Switch back to "normal" mode (show Intensity of a Selection).
    set(obj.hValueTxt, 'String', obj.ValueTxtString, ...
        'ForegroundColor', [0 0 0]);
    set(obj.hValueEdt, 'String', '', ...
        'ForegroundColor', [0 0 0], 'BackgroundColor', [1 1 1], ...
        'FontWeight', 'normal');
    obj.updatePanelsPosition;
    drawnow;
end
end

%hValueTxt;  %  'Value:' 'text' uicontrol
%hValueEdt;  %  'Value' 'edit' uicontrol

% Allowed 'String' values of the Txt uicontrol of the Bottom Panel
%ValueTxtString = 'Value:';
%PathTxtString = 'Original Image File:';