function clearBG(obj)
disp('Image -> Clear BackGround Calculation');

if isempty(obj.GelDataObj.ImgBackGround) % nothing to do
    return
end
obj.GelDataObj.ImgBackGround = [];
obj.GelDataObj.BGCorrectedImg = [];
% adjust img 'layer' selection under View uimenu!
obj.updateViewUImenu;
obj.selectImg2ViewByTag(obj.FilteredImageViewItem_Tag); % always non-empty if GelDataObj.ImgBackGround was non-empty
end