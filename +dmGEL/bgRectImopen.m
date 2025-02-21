function BG = bgRectImopen(I, roi_pixel_pos, xMult, yMult)
%BG = bgRectImopen(I, roi_pixel_pos, xMult, yMult)
% xMult, yMult are horizontal (along X-axis) and vertical (along Y-axis)
% multipliers, respectively. They defines how times bigger [in the
% corresponding dimension] will be the rectangle strel used for BackGround
% calculation, than the original polygon passed as roi_pixel_pos. 
% Size of that polygon is approximated as a size of rectangle circumscribed
% around this polygon.
%
% Copyright (c) 2025 Denis I. Markov aka MariK
% < dm DOT marik DOT 230185 AT gmail DOT com >
% < t DOT me / dm_MariK >
% This work is licensed under the Creative Commons Attribution-ShareAlike
% 4.0 International License. 
%

roiX = roi_pixel_pos(:,1); 
roiY = roi_pixel_pos(:,2);

%st_size = 1 + 2 .* round( [max(Y)-min(Y), max(X)-min(X)] ./2);
% ------
% size of the circumscribed rectangle:
crH = max(roiY) - min(roiY);
crW = max(roiX) - min(roiX);

% size of the rectangle strel (must always be odd in every dimension!):
st_size = 1 + 2 .* round( [crH*yMult, crW*xMult] ./2);

ST = strel ('rectangle',st_size);
BG = imopen(I, ST);
end