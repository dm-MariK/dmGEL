function selectImg2ViewByTag(obj, tag)
% Toggle image view mode:
% 'Original Image', 'GrayScaled Image', 'Filtered Image',
% 'BackGround', 'BGCorrected Image', - all are mutually exclusive.
%    ***
% It is assumed that corresponding View menu is already SET UP correctly;
% i.e. Items that correspond to missing Images are already set DISABLED
% ('enable', 'off').
% It is also assumed that hg-object of 'Type', 'image' already exists among
% obj.hAxes, 'Children'. This 'image' object's 'CData' property will be
% updated.

% Find the selected item by tag, set it to 'on'. 
% Set all other items to 'off'.
menuItems = obj.ViewModeItems;
for i = 1:length(menuItems)
    if strcmpi(get(menuItems{i}, 'Tag'), tag)
        set(menuItems{i}, 'Checked', 'on');
    else
        set(menuItems{i}, 'Checked', 'off');
    end
end

% Use findobj to find the image object among the children of the axes ...
hImage = findobj(obj.hAxes, 'Type', 'image');

% ... and update its 'CData' according to tag value passed.
switch tag
    case obj.OriginalImageViewItem_Tag % 'Original'
        I = obj.GelDataObj.OriginalImg;
    case obj.GrayScaledImageViewItem_Tag % 'GrayScaled'
        I = obj.GelDataObj.GrayScaledImg;
    case obj.FilteredImageViewItem_Tag % 'Filtered'
        I = obj.GelDataObj.FilteredImg;
    case obj.BackGroundViewItem_Tag % 'BackGround'
        I = obj.GelDataObj.ImgBackGround;
    case obj.BGCorrectedImageViewItem_Tag % 'BGCorrected'
        I = obj.GelDataObj.BGCorrectedImg;
end
set(hImage, 'CData', I);
end