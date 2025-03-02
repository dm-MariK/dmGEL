function sxsFlag = getIntensity(obj, BW)
sxsFlag = true;
if isempty(obj.GelDataObj.ImgBackGround)
    msg = {'Can not acquire an Intensity of the Selection.', ...
        'The Image BackGround has not been calculated. Calculate and subtract a BackGround first.', ...
        'You can do that from the context menu of the bigest band''s selection.'};
    warndlg(msg, 'No Image BackGround', 'modal');
    sxsFlag = false;
end

val = obj.GelDataObj.getInt(BW); % val will be empty if no Img BG calculated

% Switch bottom pan to val disp mode
obj.toggleBotPan;
% Set String of the corresponding Edit uicontrol
set(obj.hValueEdt, 'String', num2str(val));

%% Append data to file, if 1)The option is enabled AND 2)val is not empty
if ~isempty(val) && obj.GelDataObj.CollectDataToFile
    fileName = obj.GelDataObj.FileToCollectDataTo;
    fid = fopen(fileName, 'a');
    if fid == -1
        err_msg = {'Unable to open or create the file: ', fileName};
        errordlg(err_msg, 'File access error', 'modal');
    end
    fprintf(fid, '%d\n', val);
    fclose(fid);
end