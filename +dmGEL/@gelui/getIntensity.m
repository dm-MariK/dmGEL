function getIntensity(obj, BW)
if isempty(obj.GelDataObj.ImgBackGround)
    msg = {'Can not acquire an Intensity of the Selection.', ...
        'The Image BackGround has not been calculated. Calculate and subtract a BackGround first.', ...
        'You can do that from the context menu of the bigest band''s selection.'};
    warndlg(msg, 'No Image BackGround', 'modal');
end

val = obj.GelDataObj.getInt(BW); % val will be empty if no Img BG calculated

% Switch bottom pan to val disp mode
obj.toggleBotPan;
% Set String of the corresponding Edit uicontrol
set(obj.hValueEdt, 'String', num2str(val));

% Append data to file, if 1)This option is enabled AND 2)val is not empty
end