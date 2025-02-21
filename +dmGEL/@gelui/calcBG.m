function calcBG(obj, pos)
if isempty(obj.GelDataObj.FilteredImg)
    msg = {'Can not calculate and subtract BackGround.', ...
        'The Image is not filtered. Apply noise filter first by:', ...
        '"Image --> Filter Noise"'};
    warndlg(msg, 'No Filtered Image', 'modal');
end
obj.GelDataObj.bgCorrect(pos);
obj.updateViewUImenu;
if ~isempty(obj.GelDataObj.BGCorrectedImg)
    obj.selectImg2ViewByTag(obj.BGCorrectedImageViewItem_Tag);
end
end