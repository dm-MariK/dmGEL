function selectImg2View(obj, src, ~)
% Callback to toggle image view mode:
% 'Original Image', 'GrayScaled Image', 'Filtered Image',
% 'BackGround', 'BGCorrected Image', - all are mutually exclusive.

tag = get(src, 'Tag');
obj.selectImg2ViewByTag(tag);
end