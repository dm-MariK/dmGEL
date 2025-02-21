function updateViewUImenu(obj)
% Update View menu to ensure that Items that correspond to missing Images 
% are being set DISABLED ('enable', 'off') and unchecked ('Checked', 'off')

if isempty(obj.GelDataObj.OriginalImg)
    set(obj.hOriginal, 'enable', 'off', 'Checked', 'off');
else
    set(obj.hOriginal, 'enable', 'on');
end

if isempty(obj.GelDataObj.GrayScaledImg)
    set(obj.hGrayScaled, 'enable', 'off', 'Checked', 'off');
else
    set(obj.hGrayScaled, 'enable', 'on');
end

if isempty(obj.GelDataObj.FilteredImg)
    set(obj.hFiltered, 'enable', 'off', 'Checked', 'off');
else
    set(obj.hFiltered, 'enable', 'on');
end

if isempty(obj.GelDataObj.ImgBackGround) 
    set(obj.hBackGround, 'enable', 'off', 'Checked', 'off');
else
    set(obj.hBackGround, 'enable', 'on');
end

if isempty(obj.GelDataObj.BGCorrectedImg) 
    set(obj.hBGCorrected, 'enable', 'off', 'Checked', 'off');
else
    set(obj.hBGCorrected, 'enable', 'on');
end

end