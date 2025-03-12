function prepImgs(obj, GelDataObj, selectionMask)
% 
% Will make the Selection representation as follows:
% * The selected band with its neighbor inside the Selection will be of the
% pure blue Hue (240 degrees or 2/3) and of 100% Value. Its Saturation will
% represent the Intensity of the source gray scaled Image; the more
% Intensity the bigger Saturation, pure black (Intensity = 0) will
% correspond to completely desaturated color (Saturation = 0).
% * The rest of the Image area, outside the Selection, will be of the color
% defined by `SelectionImgBGColor` Constant.

bgCrtdImg = GelDataObj.BGCorrectedImg;
%imgLayerSz = size(bgCrtdImg); % not required; the selectionMask has the
% same size

% Selection's B = uint8(255) for all the pixels inside the Selection;
% R = G = uint8(255) - bgCrtdImg;
SltdImg(:,:,3) = uint8(selectionMask .* 255);
SltdImg(:,:,2) = (uint8(255) - bgCrtdImg) .* uint8(selectionMask);
SltdImg(:,:,1) = SltdImg(:,:,2);

% Convert `SelectionImgBGColor` to adequate uint8 representation
bgColor = dmGEL.Constants.SelectionImgBGColor;
bgColor = uint8(bgColor .* 255);

% Create RGB-image of the rest area
RestArea(:,:,3) = uint8(~selectionMask) .* bgColor(3);
RestArea(:,:,2) = uint8(~selectionMask) .* bgColor(2);
RestArea(:,:,1) = uint8(~selectionMask) .* bgColor(1);

% Make the final Image - the sum of the selected img and the rest area
obj.SelectionImg = SltdImg + RestArea;

% Save BGCorrectedImg to the obj's property
obj.BGCorrectedImg = bgCrtdImg;