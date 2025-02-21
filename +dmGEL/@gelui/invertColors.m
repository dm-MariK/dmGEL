function invertColors(obj)
disp('Image -> Invert Colors');

obj.GelDataObj.invertImg;
% adjust img 'layer' selection under View uimenu!
obj.updateViewUImenu;
obj.selectImg2ViewByTag(obj.GrayScaledImageViewItem_Tag);
end